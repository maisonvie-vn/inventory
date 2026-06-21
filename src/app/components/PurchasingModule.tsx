'use client';

/**
 * PurchasingModule — Tab Mua hàng & Nhập kho v3.0
 * 
 * Gồm:
 * 1. Worklist cần order (từ v_order_worklist_ops)
 * 2. Màn duyệt PO phân tầng (Manager / CFO)
 * 3. Tạo PO từ worklist (gộp theo NCC)
 * 4. In PDF (react-pdf / window.print)
 * 5. Nhập hàng hàng loạt (bulk import Excel → validation + dedup + WAC)
 * 6. 3-way match status
 * 7. Badge nhấp nháy đỏ khi có PO chờ duyệt
 */

import React, { useState, useEffect, useCallback, useRef, useMemo } from 'react';
import * as XLSX from 'xlsx';
import {
  ShoppingCart, CheckCircle, XCircle, AlertTriangle, Upload,
  FileText, Printer, Clock, ChevronDown, ChevronRight,
  Package, DollarSign, RefreshCw, Eye, BadgeCheck
} from 'lucide-react';
import { supabase, isSupabaseConfigured } from '../../lib/supabaseClient';
import { NotificationBadge } from '../../lib/useRealtimeBadges';
import UniversalSearch from './UniversalSearch';

// -------------------------------------------------------------------
// Types
// -------------------------------------------------------------------
interface WorklistItem {
  ingredient_id: string;
  code: string;
  name: string;
  stock_uom: string;
  location_id: string;
  current_stock: number;
  reorder_point: number;
  alert_level: 'OUT' | 'CRITICAL' | 'REORDER';
  days_of_cover: number | null;
  supplier_name: string | null;
  purchase_uom: string | null;
  pack_size: number | null;
  moq: number | null;
  par_level: number | null;
  net_open_po_qty: number;
  suggested_order_qty: number;
  supplier_id?: string;
  unit_price?: number;     // chỉ Owner/CFO
  estimated_value?: number; // chỉ Owner/CFO
}

interface PurchaseOrder {
  id: string;
  po_no: string;
  supplier_id: string;
  supplier_name?: string;
  status: string;
  total_value: number;
  created_at: string;
  requested_by?: string;
  approved_by?: string;
  second_approver?: string;
  escalation_level: number;
  location_id: string;
  notes?: string;
  items?: POLine[];
}

interface POLine {
  ingredient_id: string;
  ingredient_name?: string;
  qty: number;
  purchase_uom: string;
  unit_price: number;
  estimated_value: number;
  suggested_qty: number;
}

interface GoodsReceipt {
  id: string;
  grn_no: string;
  po_id?: string;
  invoice_no: string;
  three_way_status: string;
  three_way_note: string;
  status: string;
  business_date: string;
}

interface PurchasingModuleProps {
  userRole: string;
  userId: string;
  badges: NotificationBadge[];
  onResolveBadge: (refId: string) => void;
  canViewFinancials: boolean;
}

// -------------------------------------------------------------------
// Component chính
// -------------------------------------------------------------------
export default function PurchasingModule({
  userRole, userId, badges, onResolveBadge, canViewFinancials
}: PurchasingModuleProps) {
  const [activeSubTab, setActiveSubTab] = useState<'worklist' | 'create_po' | 'approve' | 'history' | 'grn' | 'suppliers_mgmt'>('worklist');
  const [worklist, setWorklist] = useState<WorklistItem[]>([]);
  const [selectedItems, setSelectedItems] = useState<Set<string>>(new Set());
  const [purchaseOrders, setPurchaseOrders] = useState<PurchaseOrder[]>([]);
  const [goodsReceipts, setGoodsReceipts] = useState<GoodsReceipt[]>([]);
  const [suppliers, setSuppliers] = useState<any[]>([]);
  const [allIngredients, setAllIngredients] = useState<any[]>([]);
  const [supplierIngredients, setSupplierIngredients] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const [importStatus, setImportStatus] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [searchText, setSearchText] = useState('');
  const [selectedPOs, setSelectedPOs] = useState<Set<string>>(new Set());

  // Reset selected POs when sub tab changes
  useEffect(() => {
    setSelectedPOs(new Set());
  }, [activeSubTab]);

  // Badges liên quan PO
  const poBadges = badges.filter(b => b.badge_type === 'PO_PENDING_APPROVAL' || b.badge_type === 'ESCALATION');
  const hasBlinkingBadge = poBadges.length > 0;

  const canApprove = ['admin','restaurant_manager','senior_accountant'].includes(userRole);
  const canCreate  = ['admin','restaurant_manager','senior_accountant','junior_accountant','head_chef','BAR_SUPERVISOR'].includes(userRole);

  // Fetch dữ liệu
  const fetchAll = useCallback(async () => {
    if (!isSupabaseConfigured()) return;
    setLoading(true);
    try {
      // Worklist: Nếu có quyền tài chính, lấy đầy đủ từ RPC (có thông tin giá); ngược lại lấy từ view ops (che giá)
      let wlData = [];
      if (canViewFinancials) {
        const { data, error } = await supabase.rpc('get_order_worklist_finance');
        if (error) throw error;
        wlData = data || [];
      } else {
        const { data, error } = await supabase.from('v_order_worklist_ops').select('*');
        if (error) throw error;
        wlData = data || [];
      }
      setWorklist(wlData as WorklistItem[]);

      // POs
      const { data: pos } = await supabase
        .from('purchase_orders')
        .select(`
          *,
          suppliers(name),
          po_lines(*, ingredients(ten_vi, code)),
          creator:created_by(full_name),
          requester:requested_by(full_name),
          approver:approved_by(full_name),
          second_approver_profile:second_approver(full_name)
        `)
        .order('created_at', { ascending: false })
        .limit(100);
      setPurchaseOrders((pos || []).map((p: any) => ({
        ...p,
        supplier_name: p.suppliers?.name || p.supplier_id,
        creator: p.creator,
        requester: p.requester,
        approver: p.approver,
        second_approver_profile: p.second_approver_profile,
        items: (p.po_lines || []).map((line: any) => ({
          ingredient_id: line.ingredients?.code || line.ingredient_id,
          ingredient_name: line.ingredients?.ten_vi || '',
          qty: line.qty_ordered || line.qty || 0,
          purchase_uom: line.purchase_uom || 'UNIT',
          unit_price: line.unit_price || 0,
          estimated_value: line.estimated_value || ((line.qty_ordered || line.qty || 0) * (line.unit_price || 0)),
          stock_at_order: line.stock_at_order || 0
        }))
      })));

      // GRNs
      const { data: grns } = await supabase
        .from('goods_receipts')
        .select('*')
        .order('created_at', { ascending: false })
        .limit(50);
      setGoodsReceipts(grns || []);

      // Suppliers
      const { data: sups } = await supabase.from('suppliers').select('*').order('name', { ascending: true });
      setSuppliers(sups || []);

      // Ingredients
      const { data: ings } = await supabase.from('ingredients').select('id, code, ten_vi, stock_uom, wac_price').eq('is_active', true);
      setAllIngredients(ings || []);

      // Supplier Ingredients
      const { data: supIngs } = await supabase.from('supplier_ingredients').select('*');
      setSupplierIngredients(supIngs || []);
    } catch (err) {
      console.error('[Purchasing] Fetch error:', err);
    } finally {
      setLoading(false);
    }
  }, [canViewFinancials]);

  useEffect(() => { fetchAll(); }, [fetchAll]);

  // Supabase Realtime: cập nhật PO status ngay
  useEffect(() => {
    if (!isSupabaseConfigured()) return;
    const channel = supabase
      .channel('po-realtime')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'purchase_orders' }, () => {
        fetchAll();
      })
      .subscribe();
    return () => { supabase.removeChannel(channel); };
  }, [fetchAll]);

  // Tạo PO từ các items đã chọn
  const handleCreatePO = useCallback(async () => {
    const selected = worklist.filter(w => selectedItems.has(`${w.ingredient_id}:${w.location_id}`));
    if (selected.length === 0) {
      alert('Vui lòng chọn ít nhất 1 mặt hàng để tạo PO');
      return;
    }

    // Gom theo supplier
    const bySupplier: Record<string, WorklistItem[]> = {};
    const noSupplierItems: WorklistItem[] = [];
    for (const item of selected) {
      if (!item.supplier_id) {
        noSupplierItems.push(item);
      } else {
        const key = item.supplier_id;
        if (!bySupplier[key]) bySupplier[key] = [];
        bySupplier[key].push(item);
      }
    }

    if (noSupplierItems.length > 0) {
      alert(`⚠️ Không thể tạo PO tự động cho các mặt hàng chưa có Nhà cung cấp ưu tiên:\n\n${noSupplierItems.map(i => `• ${i.code} - ${i.name}`).join('\n')}\n\nVui lòng gán NCC cho các mặt hàng này trước, hoặc sang tab "Tạo PO" để lập đơn thủ công chọn NCC.`);
      return;
    }

    try {
      for (const [supplierId, items] of Object.entries(bySupplier)) {
        const lines = items.map(i => ({
          ingredient_id: i.ingredient_id,
          suggested_qty: i.suggested_order_qty,
          unit_price: i.unit_price || 0,
          uom: i.purchase_uom || i.stock_uom,
          moq: i.moq || 1,
          pack_size: i.pack_size || 1,
        }));

        const { data: poId, error } = await supabase.rpc('create_po_from_worklist', {
          p_supplier_id: supplierId,
          p_location_id: items[0]?.location_id || 'MAIN_STORE',
          p_lines: lines,
          p_notes: `Tạo từ worklist ${new Date().toLocaleDateString('vi-VN')}`,
        });

        if (error) throw error;
        alert(`✅ Đã lập PO nháp thành công (ID: ${poId}). Bạn hoặc người khác có thể Gửi duyệt PO này tại tab Duyệt PO.`);
      }
      setSelectedItems(new Set());
      fetchAll();
      setActiveSubTab('approve'); // Chuyển sang tab duyệt để họ bấm gửi duyệt ngay!
    } catch (err: any) {
      alert(`❌ Lỗi tạo PO: ${err.message}`);
    }
  }, [worklist, selectedItems, fetchAll]);

  // Tạo PO thủ công từ Form
  const handleCreatePOManual = useCallback(async (supplierId: string, locationId: string, lines: any[], notes: string) => {
    try {
      const formattedLines = lines.map(l => ({
        ingredient_id: l.ingredient_id,
        suggested_qty: l.suggested_qty,
        unit_price: l.unit_price,
        uom: l.uom,
        moq: l.moq || 1,
        pack_size: l.pack_size || 1,
      }));

      const { data: poId, error } = await supabase.rpc('create_po_from_worklist', {
        p_supplier_id: supplierId,
        p_location_id: locationId,
        p_lines: formattedLines,
        p_notes: notes || `Tạo thủ công ngày ${new Date().toLocaleDateString('vi-VN')}`,
      });

      if (error) throw error;
      alert(`✅ Đã lập PO nháp thành công (ID: ${poId}). Bạn hoặc người khác có thể Gửi duyệt PO này tại tab Duyệt PO.`);
      fetchAll();
      setActiveSubTab('approve'); // Chuyển sang tab duyệt để họ bấm gửi duyệt ngay!
    } catch (err: any) {
      alert(`❌ Lỗi tạo PO: ${err.message}`);
    }
  }, [fetchAll]);

  // Đặt Nhà cung cấp ưu tiên nhanh từ UI
  const handleSetPreferredSupplier = useCallback(async (ingredientId: string, supplierId: string) => {
    try {
      const { error } = await supabase.rpc('set_preferred_supplier', {
        p_ingredient_id: ingredientId,
        p_supplier_id: supplierId
      });
      if (error) throw error;
      fetchAll(); // Tải lại để cập nhật danh sách
    } catch (err: any) {
      alert(`❌ Lỗi đặt NCC ưu tiên: ${err.message}`);
    }
  }, [fetchAll]);

  // Thêm nhà cung cấp mới
  const handleAddSupplier = useCallback(async (newSup: { name: string; lead_time_days: number; cutoff_time: string | null; contact: any } | null) => {
    try {
      if (newSup) {
        const { error } = await supabase
          .from('suppliers')
          .insert([newSup]);
        if (error) throw error;
        alert('✅ Thêm nhà cung cấp thành công!');
      }
      fetchAll();
    } catch (err: any) {
      alert(`❌ Lỗi thêm nhà cung cấp: ${err.message}`);
    }
  }, [fetchAll]);

  // Bật/tắt trạng thái hoạt động của nhà cung cấp
  const handleToggleSupplierActive = useCallback(async (id: string, currentActive: boolean) => {
    try {
      const { error } = await supabase
        .from('suppliers')
        .update({ is_active: !currentActive })
        .eq('id', id);
      if (error) throw error;
      fetchAll();
    } catch (err: any) {
      alert(`❌ Lỗi cập nhật trạng thái: ${err.message}`);
    }
  }, [fetchAll]);

  // Submit PO để duyệt
  const handleSubmitPO = useCallback(async (poId: string) => {
    try {
      const { error } = await supabase.rpc('submit_po_for_approval', { p_po_id: poId });
      if (error) throw error;
      alert('✅ Đã gửi PO đi duyệt! Người duyệt sẽ nhận thông báo ngay.');
      fetchAll();
    } catch (err: any) {
      alert(`❌ Lỗi submit: ${err.message}`);
    }
  }, [fetchAll]);

  // Duyệt / Từ chối PO
  const handleApprovePO = useCallback(async (poId: string, approve: boolean) => {
    const note = approve ? undefined : prompt('Lý do từ chối:') || 'Không phê duyệt';
    try {
      const { data: result, error } = await supabase.rpc('approve_po', {
        p_po_id: poId,
        p_approve: approve,
        p_note: note,
      });
      if (error) throw error;
      alert(approve ? `✅ Đã duyệt PO! Kết quả: ${result}` : '❌ Đã từ chối PO');
      onResolveBadge(poId);
      fetchAll();
    } catch (err: any) {
      alert(`❌ Lỗi duyệt PO: ${err.message}`);
    }
  }, [fetchAll, onResolveBadge]);

  // Export mẫu nhập hàng hàng loạt
  const handleExportTemplate = () => {
    const ws = XLSX.utils.aoa_to_sheet([
      ['Mã hàng', 'Tên hàng', 'SL nhận', 'ĐVT mua', 'Đơn giá (VND)', 'Số HĐ', 'Ngày nhận', 'Ghi chú'],
      ['V6027', 'Luis Felipe Chardonnay', 12, 'BOTTLE', 280000, 'INV-001', new Date().toLocaleDateString('vi-VN'), ''],
      ['B5001', 'Heineken 330ml', 24, 'CAN', 15000, 'INV-001', new Date().toLocaleDateString('vi-VN'), ''],
    ]);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Mẫu nhập hàng');
    XLSX.writeFile(wb, 'MAU_NHAP_HANG_MAISON_VIE.xlsx');
  };

  // Import hàng loạt từ Excel
  const handleBulkImport = useCallback(async (file: File) => {
    setImportStatus('Đang đọc file...');
    try {
      const buf = await file.arrayBuffer();
      const wb = XLSX.read(buf, { type: 'array' });
      const ws = wb.Sheets[wb.SheetNames[0]];
      const rows: any[][] = XLSX.utils.sheet_to_json(ws, { header: 1 });
      const dataRows = rows.slice(1).filter(r => r[0]); // bỏ header, bỏ dòng trống

      // Dedup theo số HĐ
      const invoiceNos = new Set(dataRows.map(r => r[5]?.toString()).filter(Boolean));
      const { data: existingGRNs } = await supabase
        .from('goods_receipts')
        .select('invoice_no')
        .in('invoice_no', Array.from(invoiceNos));
      const duplicateInvoices = new Set((existingGRNs || []).map((g: any) => g.invoice_no));

      const validRows = dataRows.filter(r => !duplicateInvoices.has(r[5]?.toString()));
      const skipped = dataRows.length - validRows.length;

      if (validRows.length === 0) {
        setImportStatus(`⚠️ Tất cả ${dataRows.length} dòng đã tồn tại (số HĐ trùng). Không có gì để import.`);
        return;
      }

      // Validate: mã hàng phải tồn tại
      const codes = [...new Set(validRows.map(r => r[0]?.toString()))];
      const { data: ingredients } = await supabase
        .from('ingredients')
        .select('id, code, ten_vi, wac_price')
        .in('code', codes);
      const codeToIng = new Map((ingredients || []).map(i => [i.code, i]));

      const errors: string[] = [];
      const validLines = validRows.filter(r => {
        const code = r[0]?.toString();
        if (!codeToIng.has(code)) { errors.push(`Mã ${code} không tồn tại`); return false; }
        if (isNaN(parseFloat(r[2]))) { errors.push(`SL không hợp lệ: ${r[2]}`); return false; }
        if (isNaN(parseFloat(r[4]))) { errors.push(`Đơn giá không hợp lệ: ${r[4]}`); return false; }
        return true;
      });

      if (errors.length > 0) {
        setImportStatus(`❌ Lỗi validation:\n${errors.slice(0, 10).join('\n')}`);
        return;
      }

      // Gom theo số HĐ → mỗi HĐ 1 GRN
      const byInvoice: Record<string, any[]> = {};
      for (const row of validLines) {
        const invNo = row[5]?.toString() || `IMPORT-${Date.now()}`;
        if (!byInvoice[invNo]) byInvoice[invNo] = [];
        byInvoice[invNo].push(row);
      }

      // Lookup purchase orders matching the invoice/PO numbers
      const invoiceKeys = Object.keys(byInvoice);
      const { data: matchedPOs } = await supabase
        .from('purchase_orders')
        .select('id, po_no, supplier_id')
        .in('po_no', invoiceKeys);

      const poMap = new Map((matchedPOs || []).map(p => [p.po_no, p]));

      let created = 0;
      for (const [invNo, rows2] of Object.entries(byInvoice)) {
        const totalInvoice = rows2.reduce((s, r) => s + parseFloat(r[2]) * parseFloat(r[4]), 0);
        
        const matchedPO = poMap.get(invNo);
        const poId = matchedPO ? matchedPO.id : null;
        const supplierId = matchedPO ? matchedPO.supplier_id : null;

        // Tạo GRN header
        const { data: grn, error: grnErr } = await supabase
          .from('goods_receipts')
          .insert({
            invoice_no: invNo,
            po_id: poId,
            supplier_id: supplierId,
            invoice_amount: Math.round(totalInvoice),
            status: 'pending',
            match_status: 'PENDING',
            three_way_status: 'PENDING',
            business_date: rows2[0][6] ? new Date(rows2[0][6]).toISOString().split('T')[0] : new Date().toISOString().split('T')[0],
            dedup_hash: `BULK-${invNo}-${Date.now()}`,
          })
          .select('id')
          .single();

        if (grnErr) { errors.push(`GRN error ${invNo}: ${grnErr.message}`); continue; }

        // Tạo GRN lines
        const grnLines = rows2.map(r => {
          const ing = codeToIng.get(r[0]?.toString());
          return {
            grn_id: grn!.id,
            ingredient_id: ing!.id,
            qty_received: parseFloat(r[2]),
            purchase_uom: r[3]?.toString() || 'UNIT',
            unit_price_fx: Math.round(parseFloat(r[4])),
          };
        });
        await supabase.from('grn_lines').insert(grnLines);

        // Auto-approve → trigger WAC + 3-way match via RPC
        const { error: approveErr } = await supabase.rpc('approve_goods_receipt', {
          p_grn_id: grn!.id,
          p_user_id: userId
        });

        if (approveErr) {
          errors.push(`Approve error ${invNo}: ${approveErr.message}`);
        } else {
          created++;
        }
      }

      setImportStatus(
        `✅ Import thành công: ${created} phiếu GRN, ${validLines.length} dòng hàng.` +
        (skipped > 0 ? ` ⚠️ Bỏ qua ${skipped} dòng trùng số HĐ.` : '') +
        (errors.length > 0 ? `\n❌ ${errors.length} lỗi: ${errors.slice(0,3).join('; ')}` : '')
      );
      fetchAll();
    } catch (err: any) {
      setImportStatus(`❌ Lỗi import: ${err.message}`);
    }
  }, [fetchAll]);

  // In PDF (browser print)
  // Export PO data to Excel in GRN import structure (8 standard + 1 stock column)
  const handlePrintPO = (poOrPos: PurchaseOrder | PurchaseOrder[]) => {
    const pos = Array.isArray(poOrPos) ? poOrPos : [poOrPos];
    if (pos.length === 0) return;

    // Generate Excel file matching GRN import structure
    const headers = [['Mã hàng', 'Tên hàng', 'SL nhận', 'ĐVT mua', 'Đơn giá (VND)', 'Số HĐ', 'Ngày nhận', 'Ghi chú', 'SL tồn']];
    const todayStr = new Date().toISOString().split('T')[0];

    const dataRows: any[][] = [];

    for (const po of pos) {
      for (const item of po.items || []) {
        const matchingIng = allIngredients.find((ing: any) => ing.id === item.ingredient_id || ing.code === item.ingredient_id);
        const internalCode = matchingIng?.code || item.ingredient_id || '';
        const ingredientName = item.ingredient_name || matchingIng?.ten_vi || '';
        const stockAtOrder = (item as any).stock_at_order || 0;

        dataRows.push([
          internalCode,                              // Mã hàng
          ingredientName,                            // Tên hàng
          item.qty,                                  // SL nhận
          item.purchase_uom || 'UNIT',               // ĐVT mua
          item.unit_price || matchingIng?.wac_price || matchingIng?.standard_price || 0, // Đơn giá (VND)
          po.po_no,                                  // Số HĐ
          todayStr,                                  // Ngày nhận
          po.notes || '',                            // Ghi chú
          stockAtOrder                               // SL tồn
        ]);
      }
    }

    const ws = XLSX.utils.aoa_to_sheet([...headers, ...dataRows]);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'GRN_PO_Import');

    // Name file based on PO numbers
    const fileSuffix = pos.length === 1 ? pos[0].po_no : `BULK_${pos.length}_POs`;
    const excelFileName = `GRN_PO_Import_${fileSuffix}.xlsx`;

    XLSX.writeFile(wb, excelFileName);
    
    alert(`Đã xuất dữ liệu đặt hàng thành công ra file Excel nhập kho: ${excelFileName}\nBạn có thể sửa số lượng thực nhận, đơn giá trực tiếp trên file này và upload vào tab "Nhập hàng".`);
  };

  // -------------------------------------------------------------------
  // Render
  // -------------------------------------------------------------------
  return (
    <div className="space-y-4">
      {/* Sub-navigation */}
      <div className="flex gap-2 flex-wrap">
        {[
          { key: 'worklist', label: 'Cần đặt hàng', icon: <AlertTriangle size={14}/> },
          { key: 'create_po', label: 'Tạo PO', icon: <ShoppingCart size={14}/> },
          {
            key: 'approve',
            label: 'Duyệt PO',
            icon: hasBlinkingBadge
              ? <span className="relative flex h-3 w-3">
                  <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-[#D06A5C] opacity-75"/>
                  <span className="relative inline-flex rounded-full h-3 w-3 bg-[#D06A5C]"/>
                </span>
              : <BadgeCheck size={14}/>,
            badge: poBadges.length > 0 ? poBadges.length : undefined
          },
          { key: 'history', label: 'Lịch sử PO', icon: <Clock size={14}/> },
          { key: 'grn', label: 'Nhập hàng (GRN)', icon: <Upload size={14}/> },
          { key: 'suppliers_mgmt', label: 'Nhà cung cấp', icon: <Package size={14}/> },
        ].map((tab: any) => (
          <button
            key={tab.key}
            onClick={() => setActiveSubTab(tab.key)}
            className={`flex items-center gap-2 px-3 py-1.5 rounded-lg text-sm font-medium transition-all border ${
              activeSubTab === tab.key
                ? 'bg-[#A8884E] border-[#A8884E] text-white'
                : 'bg-[#042726] border-[#C9A581]/30 text-[#C9A581] hover:border-[#A8884E]'
            }`}
          >
            {tab.icon}
            {tab.label}
            {tab.badge && (
              <span className={`text-xs font-bold rounded-full px-1.5 min-w-[18px] text-center ${
                activeSubTab === tab.key ? 'bg-white text-[#A8884E]' : 'bg-[#D06A5C] text-white'
              }`}>
                {tab.badge}
              </span>
            )}
          </button>
        ))}
      </div>

      {/* Tab: Worklist */}
      {activeSubTab === 'worklist' && (() => {
        const filteredWorklist = worklist.filter(item => {
          const q = searchText.toLowerCase();
          return (
            item.code.toLowerCase().includes(q) ||
            item.name.toLowerCase().includes(q) ||
            (item.supplier_name && item.supplier_name.toLowerCase().includes(q))
          );
        });
        return (
          <WorklistTab
            worklist={filteredWorklist}
            loading={loading}
            selectedItems={selectedItems}
            onToggleItem={(key: string) => setSelectedItems(prev => {
              const s = new Set(prev);
              s.has(key) ? s.delete(key) : s.add(key);
              return s;
            })}
            onToggleAll={() => {
              const allFilteredSelected = filteredWorklist.every(w => selectedItems.has(`${w.ingredient_id}:${w.location_id}`));
              if (allFilteredSelected) {
                setSelectedItems(prev => {
                  const s = new Set(prev);
                  filteredWorklist.forEach(w => s.delete(`${w.ingredient_id}:${w.location_id}`));
                  return s;
                });
              } else {
                setSelectedItems(prev => {
                  const s = new Set(prev);
                  filteredWorklist.forEach(w => s.add(`${w.ingredient_id}:${w.location_id}`));
                  return s;
                });
              }
            }}
            onCreatePO={handleCreatePO}
            canCreate={canCreate}
            canViewFinancials={canViewFinancials}
            onRefresh={fetchAll}
            searchText={searchText}
            setSearchText={setSearchText}
            rawWorklist={worklist}
            suppliers={suppliers}
            onSetPreferredSupplier={handleSetPreferredSupplier}
          />
        );
      })()}

      {/* Tab: Tạo PO thủ công */}
      {activeSubTab === 'create_po' && (
        <CreatePOTab
          suppliers={suppliers}
          ingredients={allIngredients}
          supplierIngredients={supplierIngredients}
          onCreatePO={handleCreatePOManual}
          loading={loading}
        />
      )}

      {/* Tab: Duyệt PO */}
      {activeSubTab === 'approve' && (
        <ApproveTab
          purchaseOrders={purchaseOrders.filter(po =>
            po.status === 'PENDING_APPROVAL' || po.status === 'DRAFT'
          )}
          canApprove={canApprove}
          onApprove={handleApprovePO}
          onSubmit={handleSubmitPO}
          onPrint={handlePrintPO}
          poBadges={poBadges}
          canViewFinancials={canViewFinancials}
          userId={userId}
          selectedPOs={selectedPOs}
          onTogglePO={(id: string) => setSelectedPOs(prev => {
            const s = new Set(prev);
            s.has(id) ? s.delete(id) : s.add(id);
            return s;
          })}
          onToggleAllPOs={(ids: string[]) => setSelectedPOs(prev => {
            const allSelected = ids.every(id => prev.has(id));
            const s = new Set(prev);
            if (allSelected) {
              ids.forEach(id => s.delete(id));
            } else {
              ids.forEach(id => s.add(id));
            }
            return s;
          })}
        />
      )}

      {/* Tab: Lịch sử PO */}
      {activeSubTab === 'history' && (
        <HistoryTab
          purchaseOrders={purchaseOrders}
          canViewFinancials={canViewFinancials}
          onPrint={handlePrintPO}
          selectedPOs={selectedPOs}
          onTogglePO={(id: string) => setSelectedPOs(prev => {
            const s = new Set(prev);
            s.has(id) ? s.delete(id) : s.add(id);
            return s;
          })}
          onToggleAllPOs={(ids: string[]) => setSelectedPOs(prev => {
            const allSelected = ids.every(id => prev.has(id));
            const s = new Set(prev);
            if (allSelected) {
              ids.forEach(id => s.delete(id));
            } else {
              ids.forEach(id => s.add(id));
            }
            return s;
          })}
        />
      )}

      {/* Tab: GRN nhập hàng hàng loạt */}
      {activeSubTab === 'grn' && (
        <GRNTab
          goodsReceipts={goodsReceipts}
          importStatus={importStatus}
          fileInputRef={fileInputRef}
          onExportTemplate={handleExportTemplate}
          onImport={handleBulkImport}
          onRefresh={fetchAll}
        />
      )}

      {/* Tab: Quản lý Nhà cung cấp */}
      {activeSubTab === 'suppliers_mgmt' && (
        <SuppliersMgmtTab
          suppliers={suppliers}
          onAddSupplier={handleAddSupplier}
          onToggleActive={handleToggleSupplierActive}
          loading={loading}
          canApprove={canApprove}
        />
      )}
    </div>
  );
}

// -------------------------------------------------------------------
// WorklistTab
// -------------------------------------------------------------------
function WorklistTab({
  worklist,
  loading,
  selectedItems,
  onToggleItem,
  onToggleAll,
  onCreatePO,
  canCreate,
  canViewFinancials,
  onRefresh,
  searchText,
  setSearchText,
  rawWorklist,
  suppliers,
  onSetPreferredSupplier
}: any) {
  const countsSource = rawWorklist || worklist;
  const critCount = countsSource.filter((w: WorklistItem) => w.alert_level === 'OUT' || w.alert_level === 'CRITICAL').length;
  const reorderCount = countsSource.filter((w: WorklistItem) => w.alert_level === 'REORDER').length;

  return (
    <div>
      <div className="flex items-center justify-between mb-3">
        <div>
          <span className="text-[#FBF8F4] font-semibold">Worklist cần đặt hàng</span>
          <span className="ml-2 text-xs text-[#C9A581]">
            🔴 {critCount} nguy cấp · 🟠 {reorderCount} cần đặt
          </span>
        </div>
        <div className="flex gap-2">
          <button onClick={onRefresh} className="p-1.5 rounded border border-[#C9A581]/30 text-[#C9A581] hover:text-white hover:border-[#A8884E] transition-colors">
            <RefreshCw size={14} className={loading ? 'animate-spin' : ''} />
          </button>
          {canCreate && selectedItems.size > 0 && (
            <button
              onClick={onCreatePO}
              className="px-3 py-1.5 bg-[#A8884E] hover:bg-[#8C6F3C] text-white rounded-lg text-sm font-medium transition-colors flex items-center gap-2"
            >
              <ShoppingCart size={14} />
              Tạo PO ({selectedItems.size} mặt hàng)
            </button>
          )}
        </div>
      </div>

      {/* Tìm kiếm */}
      <div className="mb-4">
        <input
          type="text"
          placeholder="🔍 Tìm kiếm nhanh theo mã hoặc tên sản phẩm..."
          value={searchText}
          onChange={(e) => setSearchText(e.target.value)}
          className="w-full max-w-md px-3 py-2 bg-[#042726] border border-[#C9A581]/30 rounded-lg text-sm text-[#FBF8F4] placeholder-[#C9A581]/50 focus:outline-none focus:border-[#A8884E] transition-all"
        />
      </div>

      {worklist.length === 0 && !loading && (
        <div className="text-center py-12 text-[#C9A581]">
          <CheckCircle size={40} className="mx-auto mb-2 text-[#62A57C]" />
          <p>Tất cả mặt hàng đều đủ tồn kho 🎉</p>
        </div>
      )}

      {worklist.length > 0 && (
        <div className="overflow-x-auto rounded-xl border border-[#C9A581]/20">
          <table className="w-full text-xs">
            <thead>
              <tr className="bg-[#042726] text-[#C9A581] border-b border-[#C9A581]/20">
                <th className="p-2 text-left">
                  <input type="checkbox"
                    checked={selectedItems.size === worklist.length && worklist.length > 0}
                    onChange={onToggleAll}
                    className="accent-[#A8884E]"
                  />
                </th>
                <th className="p-2 text-left">Mã hàng</th>
                <th className="p-2 text-left">Tên</th>
                <th className="p-2 text-center">Bộ phận</th>
                <th className="p-2 text-right">Tồn hiện tại</th>
                <th className="p-2 text-right">Ngưỡng</th>
                <th className="p-2 text-right">Đủ dùng</th>
                <th className="p-2 text-left">NCC ưu tiên</th>
                <th className="p-2 text-right">SL gợi ý</th>
                <th className="p-2 text-right">PO đang mở</th>
                {canViewFinancials && <th className="p-2 text-right">Ước tính</th>}
                <th className="p-2 text-center">Mức</th>
              </tr>
            </thead>
            <tbody>
              {worklist.map((item: WorklistItem) => {
                const key = `${item.ingredient_id}:${item.location_id}`;
                const isSelected = selectedItems.has(key);
                const alertColor = item.alert_level === 'REORDER' ? '#D8AA57' : '#D06A5C';
                return (
                  <tr
                    key={key}
                    className={`border-b border-[#C9A581]/10 transition-colors cursor-pointer ${
                      isSelected ? 'bg-[#A8884E]/10' : 'hover:bg-[#0d3330]'
                    }`}
                    onClick={() => onToggleItem(key)}
                  >
                    <td className="p-2">
                      <input type="checkbox" checked={isSelected} onChange={() => {}} className="accent-[#A8884E]" />
                    </td>
                    <td className="p-2 font-mono text-[#C2A35A]">{item.code}</td>
                    <td className="p-2 text-[#FBF8F4] max-w-[160px] truncate" title={item.name}>{item.name}</td>
                    <td className="p-2 text-center text-[#C9A581]">
                      {item.location_id === 'BAR' ? '🍸' : item.location_id === 'KITCHEN' ? '🍳' : '📦'}
                    </td>
                    <td className="p-2 text-right" style={{ color: alertColor }}>
                      <strong>{item.current_stock.toFixed(2)}</strong> {item.stock_uom}
                    </td>
                    <td className="p-2 text-right text-[#C9A581]">{item.reorder_point?.toFixed(2)}</td>
                    <td className="p-2 text-right text-[#C9A581]">
                      {item.days_of_cover !== null ? `${item.days_of_cover}d` : '–'}
                    </td>
                    <td className="p-2" onClick={(e) => e.stopPropagation()}>
                      <select
                        value={item.supplier_id || ''}
                        onChange={async (e) => {
                          const val = e.target.value;
                          if (val) {
                            await onSetPreferredSupplier(item.ingredient_id, val);
                          }
                        }}
                        className="bg-[#03201E] border border-[#C9A581]/30 rounded px-1 py-0.5 text-xs text-[#FBF8F4] focus:outline-none focus:border-[#A8884E] w-full max-w-[140px]"
                      >
                        <option value="">-- Chọn NCC --</option>
                        {suppliers.filter((s: any) => s.is_active || s.id === item.supplier_id).map((s: any) => (
                          <option key={s.id} value={s.id}>{s.name}</option>
                        ))}
                      </select>
                    </td>
                    <td className="p-2 text-right text-[#62A57C] font-bold">
                      {item.suggested_order_qty} {item.purchase_uom || item.stock_uom}
                    </td>
                    <td className="p-2 text-right text-[#C9A581]">
                      {item.net_open_po_qty > 0 ? (
                        <span className="text-[#D8AA57]">{item.net_open_po_qty}</span>
                      ) : '–'}
                    </td>
                    {canViewFinancials && (
                      <td className="p-2 text-right text-[#C2A35A]">
                        {item.estimated_value ? `${Math.round(item.estimated_value).toLocaleString('vi-VN')}đ` : '–'}
                      </td>
                    )}
                    <td className="p-2 text-center">
                      <span className="text-xs font-bold px-1.5 py-0.5 rounded" style={{
                        backgroundColor: alertColor + '20', color: alertColor
                      }}>
                        {item.alert_level}
                      </span>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}

// -------------------------------------------------------------------
// ApproveTab
// -------------------------------------------------------------------
function ApproveTab({
  purchaseOrders,
  canApprove,
  onApprove,
  onSubmit,
  onPrint,
  poBadges,
  canViewFinancials,
  userId,
  selectedPOs,
  onTogglePO,
  onToggleAllPOs
}: any) {
  return (
    <div>
      <div className="mb-3 flex items-center justify-between">
        <div className="flex items-center gap-2">
          <h3 className="text-[#FBF8F4] font-semibold">PO chờ xử lý</h3>
          {poBadges.length > 0 && (
            <span className="animate-pulse bg-[#D06A5C] text-white text-xs font-bold rounded-full px-2 py-0.5">
              {poBadges.length} chờ duyệt
            </span>
          )}
        </div>
        {purchaseOrders.length > 0 && (
          <div className="flex items-center gap-3">
            <label className="flex items-center gap-2 text-xs text-[#C9A581] cursor-pointer">
              <input
                type="checkbox"
                checked={purchaseOrders.every((po: any) => selectedPOs.has(po.id))}
                onChange={() => onToggleAllPOs(purchaseOrders.map((po: any) => po.id))}
                className="accent-[#A8884E] cursor-pointer"
              />
              Chọn tất cả
            </label>
            {selectedPOs.size > 0 && (
              <button
                onClick={() => {
                  const selectedList = purchaseOrders.filter((po: any) => selectedPOs.has(po.id));
                  onPrint(selectedList);
                }}
                className="px-3 py-1.5 bg-[#A8884E] hover:bg-[#8C6F3C] text-white rounded-lg text-xs font-medium transition-colors flex items-center gap-1.5"
              >
                <Upload size={12} className="rotate-180" />
                Xuất Excel hàng loạt ({selectedPOs.size} PO)
              </button>
            )}
          </div>
        )}
      </div>

      {purchaseOrders.length === 0 && (
        <p className="text-[#C9A581] text-sm text-center py-8">Không có PO nào chờ xử lý ✓</p>
      )}

      <div className="space-y-3">
        {purchaseOrders.map((po: PurchaseOrder) => {
          const isBlinking = poBadges.some((b: NotificationBadge) => b.ref_id === po.id);
          const isEscalated = po.escalation_level > 0;
          const needsSecond = canViewFinancials && po.approved_by && !po.second_approver;
          const isSelfRequested = po.requested_by === userId;

          return (
            <div
              key={po.id}
              className={`rounded-xl border p-4 space-y-3 transition-all ${
                isBlinking
                  ? 'border-[#D06A5C] bg-[#3A1B17] shadow-[0_0_12px_rgba(208,106,92,0.3)]'
                  : 'border-[#C9A581]/30 bg-[#042726]'
              }`}
            >
              <div className="flex items-start justify-between">
                <div>
                  <div className="flex items-center gap-2">
                    <input
                      type="checkbox"
                      checked={selectedPOs.has(po.id)}
                      onChange={() => onTogglePO(po.id)}
                      className="accent-[#A8884E] w-4 h-4 cursor-pointer"
                    />
                    <span className="font-mono font-bold text-[#C2A35A]">{po.po_no}</span>
                    <POStatusBadge status={po.status} />
                    {isEscalated && (
                      <span className="text-xs bg-[#D06A5C]/20 text-[#D06A5C] px-2 py-0.5 rounded animate-pulse">
                        ⚡ ESCALATED
                      </span>
                    )}
                  </div>
                  <div className="text-[#C9A581] text-xs mt-1">
                    {po.supplier_name || po.supplier_id} · {po.location_id}
                    {po.created_at && ` · ${new Date(po.created_at).toLocaleDateString('vi-VN')}`}
                  </div>
                  {canViewFinancials && (
                    <div className="text-[#C2A35A] text-sm font-semibold mt-1">
                      {po.total_value?.toLocaleString('vi-VN')} đ
                    </div>
                  )}
                </div>
                <div className="flex gap-2">
                  <button onClick={() => onPrint(po)} className="p-2 rounded border border-[#C9A581]/30 text-[#C9A581] hover:text-white hover:border-[#A8884E] transition-colors" title="Xuất Excel Nhập Kho">
                    <Upload size={14} className="rotate-180" />
                  </button>
                </div>
              </div>

              {/* Actions */}
              <div className="flex gap-2 flex-wrap">
                {po.status === 'DRAFT' && !isSelfRequested && (
                  <button
                    onClick={() => onSubmit(po.id)}
                    className="px-3 py-1.5 bg-[#A8884E] hover:bg-[#8C6F3C] text-white rounded-lg text-xs font-medium transition-colors flex items-center gap-1"
                  >
                    <FileText size={12} /> Gửi duyệt
                  </button>
                )}
                {po.status === 'DRAFT' && isSelfRequested && (
                  <span className="text-xs text-[#C9A581] italic">Bạn là người tạo — cần người khác gửi duyệt</span>
                )}
                {po.status === 'PENDING_APPROVAL' && canApprove && !isSelfRequested && (
                  <>
                    <button
                      onClick={() => onApprove(po.id, true)}
                      className="px-3 py-1.5 bg-[#0C201F] border border-[#62A57C] text-[#62A57C] hover:bg-[#62A57C] hover:text-white rounded-lg text-xs font-medium transition-colors flex items-center gap-1"
                    >
                      <CheckCircle size={12} /> Duyệt
                    </button>
                    <button
                      onClick={() => onApprove(po.id, false)}
                      className="px-3 py-1.5 bg-[#3A1B17] border border-[#D06A5C] text-[#D06A5C] hover:bg-[#D06A5C] hover:text-white rounded-lg text-xs font-medium transition-colors flex items-center gap-1"
                    >
                      <XCircle size={12} /> Từ chối
                    </button>
                  </>
                )}
                {po.status === 'PENDING_APPROVAL' && isSelfRequested && (
                  <span className="text-xs text-[#D8AA57] italic">⚠ Bạn là người tạo PO này — không được tự duyệt (segregation of duties)</span>
                )}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}

// -------------------------------------------------------------------
// HistoryTab
// -------------------------------------------------------------------
function HistoryTab({
  purchaseOrders,
  canViewFinancials,
  onPrint,
  selectedPOs,
  onTogglePO,
  onToggleAllPOs
}: any) {
  const statusFilter = ['APPROVED','SENT','PARTIAL','RECEIVED','CLOSED','CANCELLED'];
  const filtered = purchaseOrders.filter((p: PurchaseOrder) => statusFilter.includes(p.status));
  return (
    <div>
      <div className="mb-3 flex items-center justify-between">
        <h3 className="text-[#FBF8F4] font-semibold">Lịch sử PO</h3>
        {filtered.length > 0 && selectedPOs.size > 0 && (
          <button
            onClick={() => {
              const selectedList = filtered.filter((po: any) => selectedPOs.has(po.id));
              onPrint(selectedList);
            }}
            className="px-3 py-1.5 bg-[#A8884E] hover:bg-[#8C6F3C] text-white rounded-lg text-xs font-medium transition-colors flex items-center gap-1.5"
          >
            <Upload size={12} className="rotate-180" />
            Xuất Excel hàng loạt ({selectedPOs.size} PO)
          </button>
        )}
      </div>
      <div className="overflow-x-auto rounded-xl border border-[#C9A581]/20">
        <table className="w-full text-xs">
          <thead>
            <tr className="bg-[#042726] text-[#C9A581] border-b border-[#C9A581]/20">
              <th className="p-2 text-left w-8">
                <input
                  type="checkbox"
                  checked={filtered.length > 0 && filtered.every((po: any) => selectedPOs.has(po.id))}
                  onChange={() => onToggleAllPOs(filtered.map((po: any) => po.id))}
                  className="accent-[#A8884E] cursor-pointer"
                />
              </th>
              <th className="p-2 text-left">Số PO</th>
              <th className="p-2 text-left">NCC</th>
              <th className="p-2 text-center">Trạng thái</th>
              {canViewFinancials && <th className="p-2 text-right">Giá trị</th>}
              <th className="p-2 text-left">Ngày tạo</th>
              <th className="p-2"></th>
            </tr>
          </thead>
          <tbody>
            {filtered.map((po: PurchaseOrder) => (
              <tr key={po.id} className="border-b border-[#C9A581]/10 hover:bg-[#0d3330]">
                <td className="p-2">
                  <input
                    type="checkbox"
                    checked={selectedPOs.has(po.id)}
                    onChange={() => onTogglePO(po.id)}
                    className="accent-[#A8884E] cursor-pointer"
                  />
                </td>
                <td className="p-2 font-mono text-[#C2A35A]">{po.po_no}</td>
                <td className="p-2 text-[#FBF8F4]">{po.supplier_name || po.supplier_id}</td>
                <td className="p-2 text-center"><POStatusBadge status={po.status} /></td>
                {canViewFinancials && (
                  <td className="p-2 text-right text-[#C2A35A]">
                    {po.total_value?.toLocaleString('vi-VN')}đ
                  </td>
                )}
                <td className="p-2 text-[#C9A581]">{new Date(po.created_at).toLocaleDateString('vi-VN')}</td>
                <td className="p-2">
                  <button onClick={() => onPrint(po)} className="p-1 text-[#C9A581] hover:text-white transition-colors" title="Xuất Excel Nhập Kho">
                    <Upload size={12} className="rotate-180" />
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

// -------------------------------------------------------------------
// GRNTab — Nhập hàng hàng loạt
// -------------------------------------------------------------------
function GRNTab({ goodsReceipts, importStatus, fileInputRef, onExportTemplate, onImport, onRefresh }: any) {
  return (
    <div className="space-y-4">
      <div className="rounded-xl border border-[#C9A581]/30 bg-[#042726] p-4 space-y-3">
        <h3 className="text-[#FBF8F4] font-semibold flex items-center gap-2">
          <Upload size={16} className="text-[#A8884E]" />
          Nhập hàng hàng loạt (Excel)
        </h3>
        <p className="text-[#C9A581] text-xs">
          Upload file Excel nhập hàng → hệ thống tự validation, dedup theo số HĐ, tính WAC, 3-way match với PO.
        </p>
        <div className="flex gap-2 flex-wrap">
          <button
            onClick={onExportTemplate}
            className="px-3 py-2 border border-[#A8884E] text-[#A8884E] hover:bg-[#A8884E]/10 rounded-lg text-sm flex items-center gap-2 transition-colors"
          >
            <FileText size={14} /> Tải mẫu Excel
          </button>
          <label className="px-3 py-2 bg-[#A8884E] hover:bg-[#8C6F3C] text-white rounded-lg text-sm flex items-center gap-2 cursor-pointer transition-colors">
            <Upload size={14} /> Chọn file nhập hàng
            <input
              type="file"
              accept=".xlsx,.xls"
              className="hidden"
              ref={fileInputRef}
              onChange={(e) => {
                const f = e.target.files?.[0];
                if (f) { onImport(f); e.target.value = ''; }
              }}
            />
          </label>
          <button onClick={onRefresh} className="px-3 py-2 border border-[#C9A581]/30 text-[#C9A581] hover:text-white rounded-lg text-sm flex items-center gap-2 transition-colors">
            <RefreshCw size={14} /> Làm mới
          </button>
        </div>
        {importStatus && (
          <div className={`rounded-lg p-3 text-xs whitespace-pre-line ${
            importStatus.startsWith('✅') ? 'bg-[#0C201F] text-[#62A57C] border border-[#62A57C]/30' :
            importStatus.startsWith('❌') ? 'bg-[#3A1B17] text-[#D06A5C] border border-[#D06A5C]/30' :
            'bg-[#3A2C13] text-[#D8AA57] border border-[#D8AA57]/30'
          }`}>
            {importStatus}
          </div>
        )}
      </div>

      {/* GRN list với 3-way match status */}
      <div className="rounded-xl border border-[#C9A581]/20 overflow-hidden">
        <table className="w-full text-xs">
          <thead>
            <tr className="bg-[#042726] text-[#C9A581] border-b border-[#C9A581]/20">
              <th className="p-2 text-left">Số GRN</th>
              <th className="p-2 text-left">Số HĐ</th>
              <th className="p-2 text-center">Trạng thái</th>
              <th className="p-2 text-center">3-Way Match</th>
              <th className="p-2 text-left">Ghi chú</th>
              <th className="p-2 text-left">Ngày nhận</th>
            </tr>
          </thead>
          <tbody>
            {(goodsReceipts || []).slice(0, 30).map((grn: GoodsReceipt) => (
              <tr key={grn.id} className="border-b border-[#C9A581]/10 hover:bg-[#0d3330]">
                <td className="p-2 font-mono text-[#C2A35A]">{grn.grn_no || grn.id.slice(0,8)}</td>
                <td className="p-2 text-[#FBF8F4]">{grn.invoice_no}</td>
                <td className="p-2 text-center">
                  <span className={`text-xs px-1.5 py-0.5 rounded ${
                    grn.status === 'approved' ? 'bg-[#0C201F] text-[#62A57C]' : 'bg-[#3A2C13] text-[#D8AA57]'
                  }`}>{grn.status}</span>
                </td>
                <td className="p-2 text-center">
                  <ThreeWayBadge status={grn.three_way_status} />
                </td>
                <td className="p-2 text-[#C9A581] max-w-[200px] truncate" title={grn.three_way_note}>
                  {grn.three_way_note || '–'}
                </td>
                <td className="p-2 text-[#C9A581]">{grn.business_date}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

// Helpers
function POStatusBadge({ status }: { status: string }) {
  const colors: Record<string, string> = {
    DRAFT: 'bg-[#1f4a3f] text-[#62A57C]',
    PENDING_APPROVAL: 'bg-[#3A2C13] text-[#D8AA57]',
    APPROVED: 'bg-[#0C201F] text-[#62A57C]',
    SENT: 'bg-[#042726] text-[#A8884E]',
    PARTIAL: 'bg-[#3A2C13] text-[#D8AA57]',
    RECEIVED: 'bg-[#0C201F] text-[#62A57C]',
    CLOSED: 'bg-[#042726] text-[#C9A581]',
    CANCELLED: 'bg-[#3A1B17] text-[#D06A5C]',
  };
  return (
    <span className={`text-xs font-bold px-2 py-0.5 rounded ${colors[status] || 'bg-[#042726] text-[#C9A581]'}`}>
      {status}
    </span>
  );
}

function ThreeWayBadge({ status }: { status: string }) {
  if (!status || status === 'PENDING') return <span className="text-[#C9A581]">–</span>;
  const colors: Record<string, string> = {
    MATCHED: 'text-[#62A57C]',
    SHORT_DELIVERY: 'text-[#D06A5C]',
    OVER_DELIVERY: 'text-[#D8AA57]',
    PRICE_VARIANCE: 'text-[#D06A5C]',
    APPROVED_WITH_VARIANCE: 'text-[#D8AA57]',
  };
  const icons: Record<string, string> = {
    MATCHED: '✅',
    SHORT_DELIVERY: '⚠️',
    OVER_DELIVERY: '📦',
    PRICE_VARIANCE: '💰',
    APPROVED_WITH_VARIANCE: '✓~',
  };
  return (
    <span className={`text-xs font-bold ${colors[status] || ''}`}>
      {icons[status] || ''} {status.replace(/_/g, ' ')}
    </span>
  );
}

// -------------------------------------------------------------------
// CreatePOTab — Tạo PO thủ công
// -------------------------------------------------------------------
function CreatePOTab({ suppliers, ingredients, supplierIngredients = [], onCreatePO, loading }: any) {
  const [supplierId, setSupplierId] = useState('');
  const [locationId, setLocationId] = useState('MAIN_STORE');
  const [lines, setLines] = useState<any[]>([]);
  const [selIngId, setSelIngId] = useState('');
  const [selectedIng, setSelectedIng] = useState<any>(null);
  const [qty, setQty] = useState(1);
  const [price, setPrice] = useState(0);
  const [notes, setNotes] = useState('');

  // Reset selected ingredient when supplier changes
  useEffect(() => {
    setSelIngId('');
    setSelectedIng(null);
  }, [supplierId]);

  // Lọc nguyên liệu theo nhà cung cấp được chọn
  const filteredIngsForPo = useMemo(() => {
    if (!supplierId) return ingredients;
    const allowedIds = new Set(
      supplierIngredients
        .filter((si: any) => si.supplier_id === supplierId)
        .map((si: any) => si.ingredient_id)
    );

    if (allowedIds.size === 0) {
      // Fallback matching by code prefixes based on supplier name
      const supplier = suppliers.find((s: any) => s.id === supplierId);
      const sName = supplier?.name?.toLowerCase() || '';
      if (sName.includes('đa lộc') || sName.includes('việt nam')) {
        return ingredients.filter((ing: any) => {
          const code = (ing.code || ing.id || '').toUpperCase();
          return code.startsWith('V') || code.startsWith('B') || code.startsWith('M');
        });
      } else if (sName.includes('hải yến') || sName.includes('rau')) {
        return ingredients.filter((ing: any) => {
          const code = (ing.code || ing.id || '').toUpperCase();
          return code.startsWith('NLP6');
        });
      } else if (sName.includes('an nam')) {
        return ingredients.filter((ing: any) => {
          const code = (ing.code || ing.id || '').toUpperCase();
          const isBar = code.startsWith('V') || code.startsWith('B') || code.startsWith('M');
          const isVeg = code.startsWith('NLP6');
          return !isBar && !isVeg;
        });
      }
      return ingredients;
    }

    return ingredients.filter((ing: any) => allowedIds.has(ing.id));
  }, [ingredients, supplierId, supplierIngredients, suppliers]);

  // Map to UniversalSearch format
  const searchIngredientsFormat = useMemo(() => {
    return filteredIngsForPo.map((ing: any) => ({
      id: ing.id,
      code: ing.code,
      vi_name: ing.ten_vi || ing.vi_name || '',
      fr_name: ing.nom_fr || '',
      category: ing.category || 'Nguyên liệu',
      unit: ing.stock_uom || ing.unit || 'kg',
      price: ing.wac_price || ing.price || 0,
      wac_price: ing.wac_price || ing.price || 0
    }));
  }, [filteredIngsForPo]);

  const handleAddLine = () => {
    if (!selIngId || !selectedIng) return;

    // Check trùng
    if (lines.some(l => l.ingredient_id === selIngId)) {
      alert('Mặt hàng này đã có trong đơn');
      return;
    }

    // Use selectedIng directly (already stored from onSelect, has all fields)
    // Also try raw ingredients as fallback for ten_vi
    const rawIng = ingredients.find((i: any) => i.id === selIngId);
    const ingName = rawIng?.ten_vi || selectedIng.vi_name || selectedIng.fr_name || '';

    setLines([...lines, {
      ingredient_id: selectedIng.id,
      code: selectedIng.code,
      name: ingName,
      suggested_qty: qty,
      unit_price: price || selectedIng.wac_price || rawIng?.wac_price || 0,
      uom: selectedIng.unit || rawIng?.stock_uom || 'kg',
      moq: 1,
      pack_size: 1
    }]);

    // Reset line input
    setSelIngId('');
    setSelectedIng(null);
    setQty(1);
    setPrice(0);
  };

  const handleRemoveLine = (idx: number) => {
    setLines(lines.filter((_, i) => i !== idx));
  };

  const handleSubmit = () => {
    if (!supplierId) { alert('Vui lòng chọn Nhà cung cấp'); return; }
    if (lines.length === 0) { alert('Vui lòng thêm ít nhất 1 mặt hàng'); return; }
    
    onCreatePO(supplierId, locationId, lines, notes);
    
    // Reset form
    setSupplierId('');
    setLines([]);
    setNotes('');
  };

  return (
    <div className="rounded-xl border border-[#C9A581]/30 bg-[#042726] p-4 space-y-4 text-xs">
      <h3 className="text-[#FBF8F4] font-semibold text-sm">Lập phiếu đặt hàng PO thủ công</h3>
      
      <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
        <div>
          <label className="block text-[#C9A581] mb-1 font-semibold">Nhà cung cấp *</label>
          <select
            value={supplierId}
            onChange={(e) => setSupplierId(e.target.value)}
            className="w-full bg-[#03201E] border border-[#C9A581]/30 rounded-lg p-2 text-[#FBF8F4] focus:outline-none focus:border-[#A8884E]"
          >
            <option value="">-- Chọn Nhà cung cấp --</option>
            {suppliers.filter((s: any) => s.is_active || s.id === supplierId).map((s: any) => (
              <option key={s.id} value={s.id}>{s.name}</option>
            ))}
          </select>
        </div>

        <div>
          <label className="block text-[#C9A581] mb-1 font-semibold">Kho nhận hàng *</label>
          <select
            value={locationId}
            onChange={(e) => setLocationId(e.target.value)}
            className="w-full bg-[#03201E] border border-[#C9A581]/30 rounded-lg p-2 text-[#FBF8F4] focus:outline-none focus:border-[#A8884E]"
          >
            <option value="MAIN_STORE">Kho chính (MAIN_STORE)</option>
            <option value="BAR">Quầy Bar (BAR)</option>
            <option value="KITCHEN">Bếp chính (KITCHEN)</option>
          </select>
        </div>

        <div>
          <label className="block text-[#C9A581] mb-1 font-semibold">Ghi chú PO</label>
          <input
            type="text"
            value={notes}
            onChange={(e) => setNotes(e.target.value)}
            placeholder="Ví dụ: Đặt gấp cho cuối tuần..."
            className="w-full bg-[#03201E] border border-[#C9A581]/30 rounded-lg p-2 text-[#FBF8F4] focus:outline-none focus:border-[#A8884E]"
          />
        </div>
      </div>

      {/* Form thêm mặt hàng */}
      <div className="border-t border-[#C9A581]/20 pt-3 space-y-3">
        <h4 className="text-[#C9A581] font-semibold">Thêm mặt hàng</h4>
        <div className="grid grid-cols-1 md:grid-cols-4 gap-2 items-end">
          <div className="relative">
            <label className="block text-[#C9A581] mb-1">Tìm nguyên liệu</label>
            <UniversalSearch
              ingredients={searchIngredientsFormat}
              onSelect={(ing) => {
                setSelIngId(ing.id);
                setSelectedIng(ing);
                setPrice(ing.wac_price || 0);
              }}
              placeholder={supplierId ? "Mã NVL hoặc tên của NCC..." : "Nhập mã hoặc tên..."}
            />
          </div>

          <div>
            <label className="block text-[#C9A581] mb-1">Số lượng đặt</label>
            <input
              type="number"
              min="1"
              value={qty}
              onChange={(e) => setQty(Number(e.target.value))}
              className="w-full bg-[#03201E] border border-[#C9A581]/30 rounded-lg p-2 text-[#FBF8F4] focus:outline-none"
            />
          </div>

          <div>
            <label className="block text-[#C9A581] mb-1">Đơn giá dự kiến (VND)</label>
            <input
              type="number"
              min="0"
              value={price}
              onChange={(e) => setPrice(Number(e.target.value))}
              className="w-full bg-[#03201E] border border-[#C9A581]/30 rounded-lg p-2 text-[#FBF8F4] focus:outline-none"
            />
          </div>

          <button
            type="button"
            onClick={handleAddLine}
            disabled={!selIngId}
            className="w-full py-2 bg-[#A8884E] hover:bg-[#8C6F3C] disabled:bg-[#A8884E]/40 disabled:cursor-not-allowed text-white rounded-lg font-medium transition-colors"
          >
            Thêm dòng
          </button>

          {selectedIng && (
            <div className="bg-[#03201E] border border-[#A8884E]/40 p-2.5 rounded text-[11px] text-[#FBF8F4] flex flex-col gap-1 mt-2 animate-fadeIn col-span-full md:col-span-4">
              <div className="flex justify-between">
                <span>Mã: <strong className="text-[#C2A35A]">{selectedIng.code}</strong></span>
                <span className="text-gray-400">ĐVT: {selectedIng.unit}</span>
              </div>
              <div className="truncate">Tên: <strong className="text-gray-100">{selectedIng.vi_name}</strong></div>
              <div>WAC hiện tại: <span className="font-mono text-[#62A57C]">{(selectedIng.wac_price || 0).toLocaleString()}đ</span></div>
            </div>
          )}
        </div>
      </div>

      {/* Danh sách dòng PO đã thêm */}
      {lines.length > 0 && (
        <div className="border-t border-[#C9A581]/20 pt-3">
          <table className="w-full text-xs">
            <thead>
              <tr className="bg-[#03201E] text-[#C9A581] border-b border-[#C9A581]/20">
                <th className="p-2 text-left">Mã</th>
                <th className="p-2 text-left">Tên hàng</th>
                <th className="p-2 text-right">SL đặt</th>
                <th className="p-2 text-right">Đơn giá</th>
                <th className="p-2 text-right">Thành tiền</th>
                <th className="p-2"></th>
              </tr>
            </thead>
            <tbody>
              {lines.map((l, idx) => (
                <tr key={l.ingredient_id} className="border-b border-[#C9A581]/10 hover:bg-[#0d3330]">
                  <td className="p-2 font-mono text-[#C2A35A]">{l.code}</td>
                  <td className="p-2 text-[#FBF8F4]">{l.name}</td>
                  <td className="p-2 text-right text-[#FBF8F4]">{l.suggested_qty} {l.uom}</td>
                  <td className="p-2 text-right text-[#C2A35A]">{l.unit_price.toLocaleString('vi-VN')}đ</td>
                  <td className="p-2 text-right text-[#62A57C] font-semibold">{(l.suggested_qty * l.unit_price).toLocaleString('vi-VN')}đ</td>
                  <td className="p-2 text-center">
                    <button onClick={() => handleRemoveLine(idx)} className="text-[#D06A5C] hover:text-[#f87171]">Xóa</button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>

          <div className="flex justify-end gap-2 mt-4">
            <button
              onClick={handleSubmit}
              disabled={loading}
              className="px-4 py-2 bg-[#62A57C] hover:bg-[#4d8f66] text-white rounded-lg font-medium transition-colors"
            >
              Lập PO Nháp
            </button>
          </div>
        </div>
      )}
    </div>
  );
}

// -------------------------------------------------------------------
// SuppliersMgmtTab — Quản lý Nhà cung cấp
// -------------------------------------------------------------------
function SuppliersMgmtTab({ suppliers, onAddSupplier, onToggleActive, loading, canApprove }: any) {
  const [name, setName] = useState('');
  const [leadTime, setLeadTime] = useState(1);
  const [cutoffTime, setCutoffTime] = useState('17:00');
  const [phone, setPhone] = useState('');
  const [email, setEmail] = useState('');
  const [address, setAddress] = useState('');
  const [searchQuery, setSearchQuery] = useState('');
  const [saving, setSaving] = useState(false);
  const [importStatus, setImportStatus] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim()) {
      alert('Vui lòng nhập tên nhà cung cấp');
      return;
    }
    setSaving(true);
    await onAddSupplier({
      name: name.trim(),
      lead_time_days: Number(leadTime),
      cutoff_time: cutoffTime ? `${cutoffTime}:00` : null,
      contact: {
        phone: phone.trim() || null,
        email: email.trim() || null,
        address: address.trim() || null
      },
      is_active: true
    });
    setSaving(false);
    // Reset form
    setName('');
    setLeadTime(1);
    setCutoffTime('17:00');
    setPhone('');
    setEmail('');
    setAddress('');
  };

  const handleExportTemplate = () => {
    const ws = XLSX.utils.aoa_to_sheet([
      ['Tên nhà cung cấp', 'Thời gian giao (ngày)', 'Giờ chốt đơn (cutoff)', 'Số điện thoại', 'Email', 'Địa chỉ'],
      ['Công ty Cổ phần Thực phẩm An Nam', 2, '17:00', '024-3718-6200', 'order@annam.vn', 'Số 1 Phố Test, Hà Nội'],
      ['Nhà cung cấp Rau sạch Đà Lạt Hải Yến', 1, '20:00', '0912-345-678', 'sales@dalatyen.vn', 'Đà Lạt, Lâm Đồng'],
    ]);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Mẫu nhà cung cấp');
    XLSX.writeFile(wb, 'MAU_NHAP_NHA_CUNG_CAP.xlsx');
  };

  const handleImportExcel = async (file: File) => {
    setImportStatus('Đang đọc file...');
    try {
      const buf = await file.arrayBuffer();
      const wb = XLSX.read(buf, { type: 'array' });
      const ws = wb.Sheets[wb.SheetNames[0]];
      const rows: any[][] = XLSX.utils.sheet_to_json(ws, { header: 1 });
      const dataRows = rows.slice(1).filter(r => r[0] && r[0].toString().trim());

      if (dataRows.length === 0) {
        setImportStatus('❌ File Excel không có dữ liệu nhà cung cấp.');
        return;
      }

      // Check existing names to prevent duplicates
      const names = dataRows.map(r => r[0].toString().trim());
      const { data: existing } = await supabase
        .from('suppliers')
        .select('name')
        .in('name', names);
      
      const existingNames = new Set((existing || []).map((s: any) => s.name.toLowerCase()));

      const toInsert: any[] = [];
      const skipped: string[] = [];

      for (const row of dataRows) {
        const name = row[0].toString().trim();
        if (existingNames.has(name.toLowerCase())) {
          skipped.push(name);
          continue;
        }

        const leadTimeDays = isNaN(parseInt(row[1])) ? 1 : parseInt(row[1]);
        let cutoffTime = row[2] ? row[2].toString().trim() : null;
        if (cutoffTime) {
          const num = Number(cutoffTime);
          if (!isNaN(num)) {
            const timeFraction = num % 1;
            const totalSeconds = Math.round(timeFraction * 24 * 3600);
            const hours = Math.floor(totalSeconds / 3600);
            const minutes = Math.floor((totalSeconds % 3600) / 60);
            const seconds = totalSeconds % 60;
            cutoffTime = `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
          } else if (/^\d{1,2}:\d{2}$/.test(cutoffTime)) {
            cutoffTime = `${cutoffTime}:00`;
          } else if (/^\d{1,2}:\d{2}:\d{2}$/.test(cutoffTime)) {
            // Already in HH:MM:SS format, keep it
          } else {
            cutoffTime = null; // Invalid time format, set to null
          }
        }

        const phone = row[3] ? row[3].toString().trim() : null;
        const email = row[4] ? row[4].toString().trim() : null;
        const address = row[5] ? row[5].toString().trim() : null;

        toInsert.push({
          name,
          lead_time_days: leadTimeDays,
          cutoff_time: cutoffTime,
          contact: { phone, email, address },
          is_active: true
        });
      }

      if (toInsert.length === 0) {
        setImportStatus(`⚠️ Không có nhà cung cấp mới được thêm (Tất cả ${dataRows.length} NCC đã tồn tại trên hệ thống).`);
        return;
      }

      console.log('Inserting suppliers payload:', toInsert);
      const { error } = await supabase
        .from('suppliers')
        .insert(toInsert);

      if (error) throw error;

      setImportStatus(
        `✅ Nhập thành công ${toInsert.length} nhà cung cấp.` +
        (skipped.length > 0 ? `\n⚠️ Bỏ qua ${skipped.length} NCC trùng tên: ${skipped.slice(0, 3).join(', ')}${skipped.length > 3 ? '...' : ''}` : '')
      );
      
      // Refresh list
      await onAddSupplier(null);
    } catch (err: any) {
      setImportStatus(`❌ Lỗi import: ${err.message}`);
    }
  };

  const filteredSuppliers = suppliers.filter((s: any) => {
    const q = searchQuery.toLowerCase();
    const contactStr = JSON.stringify(s.contact || {}).toLowerCase();
    return s.name.toLowerCase().includes(q) || contactStr.includes(q);
  });

  return (
    <div className="grid grid-cols-1 lg:grid-cols-3 gap-4 text-xs">
      {/* Excel bulk import uploader */}
      {canApprove && (
        <div className="lg:col-span-3 rounded-xl border border-[#C9A581]/30 bg-[#042726] p-4 space-y-3">
          <h3 className="text-[#FBF8F4] font-semibold flex items-center gap-2">
            <Upload size={16} className="text-[#A8884E]" />
            Nhập nhà cung cấp hàng loạt (Excel)
          </h3>
          <p className="text-[#C9A581] text-xs">
            Tải tệp Excel mẫu để chuẩn bị dữ liệu, sau đó tải lên để thêm hàng loạt nhà cung cấp vào hệ thống.
          </p>
          <div className="flex gap-2 flex-wrap">
            <button
              onClick={handleExportTemplate}
              className="px-3 py-1.5 border border-[#A8884E] text-[#A8884E] hover:bg-[#A8884E]/10 rounded-lg text-xs flex items-center gap-2 transition-colors"
            >
              <FileText size={12} /> Tải mẫu Excel
            </button>
            <label className="px-3 py-1.5 bg-[#A8884E] hover:bg-[#8C6F3C] text-white rounded-lg text-xs flex items-center gap-2 cursor-pointer transition-colors">
              <Upload size={12} /> Chọn file nhập hàng loạt
              <input
                type="file"
                accept=".xlsx,.xls"
                className="hidden"
                onChange={(e) => {
                  const f = e.target.files?.[0];
                  if (f) { handleImportExcel(f); e.target.value = ''; }
                }}
              />
            </label>
          </div>
          {importStatus && (
            <div className={`rounded-lg p-3 text-[11px] whitespace-pre-line ${
              importStatus.startsWith('✅') ? 'bg-[#0C201F] text-[#62A57C] border border-[#62A57C]/30' :
              importStatus.startsWith('❌') ? 'bg-[#3A1B17] text-[#D06A5C] border border-[#D06A5C]/30' :
              'bg-[#3A2C13] text-[#D8AA57] border border-[#D8AA57]/30'
            }`}>
              {importStatus}
            </div>
          )}
        </div>
      )}

      {/* Form thêm NCC mới */}
      {canApprove && (
        <div className="lg:col-span-1 rounded-xl border border-[#C9A581]/30 bg-[#042726] p-4 space-y-4">
          <h3 className="text-[#FBF8F4] font-semibold text-sm">Thêm nhà cung cấp mới</h3>
          <form onSubmit={handleSubmit} className="space-y-3">
            <div>
              <label className="block text-[#C9A581] mb-1 font-semibold">Tên nhà cung cấp *</label>
              <input
                type="text"
                required
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="VD: Công ty TNHH Thực Phẩm Sạch"
                className="w-full bg-[#03201E] border border-[#C9A581]/30 rounded-lg p-2 text-[#FBF8F4] focus:outline-none focus:border-[#A8884E]"
              />
            </div>
            
            <div className="grid grid-cols-2 gap-2">
              <div>
                <label className="block text-[#C9A581] mb-1 font-semibold">Thời gian giao (ngày)</label>
                <input
                  type="number"
                  min="0"
                  value={leadTime}
                  onChange={(e) => setLeadTime(Number(e.target.value))}
                  className="w-full bg-[#03201E] border border-[#C9A581]/30 rounded-lg p-2 text-[#FBF8F4] focus:outline-none focus:border-[#A8884E]"
                />
              </div>
              <div>
                <label className="block text-[#C9A581] mb-1 font-semibold">Giờ chốt đơn (cutoff)</label>
                <input
                  type="time"
                  value={cutoffTime}
                  onChange={(e) => setCutoffTime(e.target.value)}
                  className="w-full bg-[#03201E] border border-[#C9A581]/30 rounded-lg p-2 text-[#FBF8F4] focus:outline-none focus:border-[#A8884E]"
                />
              </div>
            </div>

            <div>
              <label className="block text-[#C9A581] mb-1 font-semibold">Số điện thoại</label>
              <input
                type="text"
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
                placeholder="VD: 0912345678"
                className="w-full bg-[#03201E] border border-[#C9A581]/30 rounded-lg p-2 text-[#FBF8F4] focus:outline-none focus:border-[#A8884E]"
              />
            </div>

            <div>
              <label className="block text-[#C9A581] mb-1 font-semibold">Email</label>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="VD: contact@supplier.com"
                className="w-full bg-[#03201E] border border-[#C9A581]/30 rounded-lg p-2 text-[#FBF8F4] focus:outline-none focus:border-[#A8884E]"
              />
            </div>

            <div>
              <label className="block text-[#C9A581] mb-1 font-semibold">Địa chỉ</label>
              <textarea
                value={address}
                onChange={(e) => setAddress(e.target.value)}
                placeholder="Địa chỉ văn phòng / kho NCC..."
                rows={2}
                className="w-full bg-[#03201E] border border-[#C9A581]/30 rounded-lg p-2 text-[#FBF8F4] focus:outline-none focus:border-[#A8884E] resize-none"
              />
            </div>

            <button
              type="submit"
              disabled={saving}
              className="w-full py-2 bg-[#A8884E] hover:bg-[#8C6F3C] disabled:bg-[#A8884E]/50 text-white rounded-lg font-medium transition-colors"
            >
              {saving ? 'Đang lưu...' : 'Lưu nhà cung cấp'}
            </button>
          </form>
        </div>
      )}

      {/* Danh sách NCC */}
      <div className={`${canApprove ? 'lg:col-span-2' : 'lg:col-span-3'} rounded-xl border border-[#C9A581]/30 bg-[#042726] p-4 space-y-3`}>
        <div className="flex items-center justify-between">
          <h3 className="text-[#FBF8F4] font-semibold text-sm">Danh sách nhà cung cấp</h3>
          <span className="text-[#C9A581] text-xs">Tổng số: {suppliers.length}</span>
        </div>

        {/* Tìm kiếm */}
        <input
          type="text"
          placeholder="🔍 Tìm theo tên hoặc thông tin liên hệ..."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="w-full px-3 py-2 bg-[#03201E] border border-[#C9A581]/30 rounded-lg text-[#FBF8F4] placeholder-[#C9A581]/50 focus:outline-none focus:border-[#A8884E] transition-all"
        />

        {filteredSuppliers.length === 0 ? (
          <p className="text-[#C9A581] text-center py-8">Không tìm thấy nhà cung cấp nào</p>
        ) : (
          <div className="overflow-x-auto border border-[#C9A581]/10 rounded-lg">
            <table className="w-full text-xs">
              <thead>
                <tr className="bg-[#03201E] text-[#C9A581] border-b border-[#C9A581]/20">
                  <th className="p-2 text-left">Tên nhà cung cấp</th>
                  <th className="p-2 text-left">Liên hệ</th>
                  <th className="p-2 text-center">Giao hàng / Chốt đơn</th>
                  <th className="p-2 text-center">Trạng thái</th>
                </tr>
              </thead>
              <tbody>
                {filteredSuppliers.map((s: any) => {
                  const phone = s.contact?.phone || '';
                  const email = s.contact?.email || '';
                  const address = s.contact?.address || '';

                  return (
                    <tr key={s.id} className="border-b border-[#C9A581]/10 hover:bg-[#0d3330]">
                      <td className="p-2 font-medium text-[#FBF8F4]">
                        {s.name}
                      </td>
                      <td className="p-2 text-[#C9A581] space-y-0.5">
                        {phone && <div className="flex items-center gap-1">📞 {phone}</div>}
                        {email && <div className="flex items-center gap-1">✉️ {email}</div>}
                        {address && <div className="max-w-[200px] truncate" title={address}>📍 {address}</div>}
                        {!phone && !email && !address && <span>–</span>}
                      </td>
                      <td className="p-2 text-center text-[#FBF8F4]">
                        <div>{s.lead_time_days} ngày</div>
                        {s.cutoff_time && <div className="text-[#C9A581] text-[10px]">Cutoff: {s.cutoff_time.slice(0, 5)}</div>}
                      </td>
                      <td className="p-2 text-center">
                        {canApprove ? (
                          <button
                            onClick={() => onToggleActive(s.id, s.is_active)}
                            className={`px-2 py-1 rounded text-[10px] font-bold transition-colors ${
                              s.is_active
                                ? 'bg-[#0C201F] text-[#62A57C] border border-[#62A57C]/30 hover:bg-[#62A57C] hover:text-white'
                                : 'bg-[#3A1B17] text-[#D06A5C] border border-[#D06A5C]/30 hover:bg-[#D06A5C] hover:text-white'
                            }`}
                          >
                            {s.is_active ? 'Hoạt động' : 'Tắt'}
                          </button>
                        ) : (
                          <span
                            className={`px-2 py-0.5 rounded text-[10px] font-bold ${
                              s.is_active
                                ? 'bg-[#0C201F] text-[#62A57C]'
                                : 'bg-[#3A1B17] text-[#D06A5C]'
                            }`}
                          >
                            {s.is_active ? 'Hoạt động' : 'Tắt'}
                          </span>
                        )}
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}
