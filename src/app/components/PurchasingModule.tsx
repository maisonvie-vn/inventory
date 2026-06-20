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

import React, { useState, useEffect, useCallback, useRef } from 'react';
import * as XLSX from 'xlsx';
import {
  ShoppingCart, CheckCircle, XCircle, AlertTriangle, Upload,
  FileText, Printer, Clock, ChevronDown, ChevronRight,
  Package, DollarSign, RefreshCw, Eye, BadgeCheck
} from 'lucide-react';
import { supabase, isSupabaseConfigured } from '../../lib/supabaseClient';
import { NotificationBadge } from '../../lib/useRealtimeBadges';

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
  const [activeSubTab, setActiveSubTab] = useState<'worklist' | 'create_po' | 'approve' | 'history' | 'grn'>('worklist');
  const [worklist, setWorklist] = useState<WorklistItem[]>([]);
  const [selectedItems, setSelectedItems] = useState<Set<string>>(new Set());
  const [purchaseOrders, setPurchaseOrders] = useState<PurchaseOrder[]>([]);
  const [goodsReceipts, setGoodsReceipts] = useState<GoodsReceipt[]>([]);
  const [suppliers, setSuppliers] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const [importStatus, setImportStatus] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [searchText, setSearchText] = useState('');

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
      // Worklist
      const { data: wl } = await supabase.from('v_order_worklist_ops').select('*');
      setWorklist((wl || []) as WorklistItem[]);

      // POs
      const { data: pos } = await supabase
        .from('purchase_orders')
        .select('*, suppliers(name)')
        .order('created_at', { ascending: false })
        .limit(100);
      setPurchaseOrders((pos || []).map((p: any) => ({
        ...p,
        supplier_name: p.suppliers?.name || p.supplier_id
      })));

      // GRNs
      const { data: grns } = await supabase
        .from('goods_receipts')
        .select('*')
        .order('created_at', { ascending: false })
        .limit(50);
      setGoodsReceipts(grns || []);

      // Suppliers
      const { data: sups } = await supabase.from('suppliers').select('id, name').eq('is_active', true);
      setSuppliers(sups || []);
    } catch (err) {
      console.error('[Purchasing] Fetch error:', err);
    } finally {
      setLoading(false);
    }
  }, []);

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
    for (const item of selected) {
      const key = item.supplier_id || 'MANUAL';
      if (!bySupplier[key]) bySupplier[key] = [];
      bySupplier[key].push(item);
    }

    try {
      for (const [supplierId, items] of Object.entries(bySupplier)) {
        if (supplierId === 'MANUAL') continue; // skip nếu không có NCC

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
        alert(`✅ Đã tạo PO thành công (ID: ${poId}). Submit để gửi duyệt.`);
      }
      setSelectedItems(new Set());
      fetchAll();
    } catch (err: any) {
      alert(`❌ Lỗi tạo PO: ${err.message}`);
    }
  }, [worklist, selectedItems, fetchAll]);

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

      let created = 0;
      for (const [invNo, rows2] of Object.entries(byInvoice)) {
        const totalInvoice = rows2.reduce((s, r) => s + parseFloat(r[2]) * parseFloat(r[4]), 0);

        // Tạo GRN header
        const { data: grn, error: grnErr } = await supabase
          .from('goods_receipts')
          .insert({
            invoice_no: invNo,
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

        // Auto-approve → trigger WAC + 3-way match
        await supabase
          .from('goods_receipts')
          .update({ status: 'approved' })
          .eq('id', grn!.id);

        created++;
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
  const handlePrintPO = (po: PurchaseOrder) => {
    const printContent = `
      <html><head><title>PO ${po.po_no}</title>
      <style>
        body { font-family: Arial, sans-serif; color: #222; }
        h1 { font-size: 18px; border-bottom: 2px solid #333; padding-bottom: 8px; }
        table { width: 100%; border-collapse: collapse; margin-top: 16px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; font-size: 12px; }
        th { background: #f5f5f5; }
        .footer { margin-top: 40px; display: flex; justify-content: space-between; }
        .sign-box { border-top: 1px solid #333; padding-top: 8px; width: 180px; text-align: center; font-size: 11px; }
      </style></head><body>
      <h1>PHIẾU ĐẶT HÀNG — ${po.po_no}</h1>
      <p><strong>Nhà cung cấp:</strong> ${po.supplier_name || po.supplier_id}</p>
      <p><strong>Ngày lập:</strong> ${new Date(po.created_at).toLocaleDateString('vi-VN')}</p>
      <p><strong>Trạng thái:</strong> ${po.status}</p>
      ${canViewFinancials ? `<p><strong>Tổng giá trị:</strong> ${po.total_value?.toLocaleString('vi-VN')} đ</p>` : ''}
      <table>
        <thead><tr><th>#</th><th>Mã hàng</th><th>Tên hàng</th><th>SL đặt</th><th>ĐVT</th>${canViewFinancials ? '<th>Đơn giá</th><th>Thành tiền</th>' : ''}</tr></thead>
        <tbody>
          ${(po.items || []).map((line, i) => `
            <tr>
              <td>${i + 1}</td>
              <td>${line.ingredient_id}</td>
              <td>${line.ingredient_name || ''}</td>
              <td>${line.qty}</td>
              <td>${line.purchase_uom}</td>
              ${canViewFinancials ? `<td>${line.unit_price?.toLocaleString('vi-VN')}</td><td>${line.estimated_value?.toLocaleString('vi-VN')}</td>` : ''}
            </tr>
          `).join('')}
        </tbody>
      </table>
      <div class="footer">
        <div class="sign-box">Người lập<br/><br/><br/></div>
        <div class="sign-box">Kế toán<br/><br/><br/></div>
        <div class="sign-box">Người duyệt<br/><br/><br/></div>
      </div>
      </body></html>
    `;
    const w = window.open('', '_blank');
    if (w) { w.document.write(printContent); w.document.close(); w.print(); }
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
          />
        );
      })()}

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
        />
      )}

      {/* Tab: Lịch sử PO */}
      {activeSubTab === 'history' && (
        <HistoryTab purchaseOrders={purchaseOrders} canViewFinancials={canViewFinancials} onPrint={handlePrintPO} />
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
  rawWorklist
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
                    <td className="p-2 text-[#FBF8F4] max-w-[120px] truncate" title={item.supplier_name || ''}>
                      {item.supplier_name || <span className="text-[#C9A581] italic">Chưa có NCC</span>}
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
function ApproveTab({ purchaseOrders, canApprove, onApprove, onSubmit, onPrint, poBadges, canViewFinancials, userId }: any) {
  return (
    <div>
      <div className="mb-3 flex items-center gap-2">
        <h3 className="text-[#FBF8F4] font-semibold">PO chờ xử lý</h3>
        {poBadges.length > 0 && (
          <span className="animate-pulse bg-[#D06A5C] text-white text-xs font-bold rounded-full px-2 py-0.5">
            {poBadges.length} chờ duyệt
          </span>
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
                  <button onClick={() => onPrint(po)} className="p-2 rounded border border-[#C9A581]/30 text-[#C9A581] hover:text-white hover:border-[#A8884E] transition-colors" title="In PDF">
                    <Printer size={14} />
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
function HistoryTab({ purchaseOrders, canViewFinancials, onPrint }: any) {
  const statusFilter = ['APPROVED','SENT','PARTIAL','RECEIVED','CLOSED','CANCELLED'];
  const filtered = purchaseOrders.filter((p: PurchaseOrder) => statusFilter.includes(p.status));
  return (
    <div>
      <h3 className="text-[#FBF8F4] font-semibold mb-3">Lịch sử PO</h3>
      <div className="overflow-x-auto rounded-xl border border-[#C9A581]/20">
        <table className="w-full text-xs">
          <thead>
            <tr className="bg-[#042726] text-[#C9A581] border-b border-[#C9A581]/20">
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
                  <button onClick={() => onPrint(po)} className="p-1 text-[#C9A581] hover:text-white transition-colors">
                    <Printer size={12} />
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
