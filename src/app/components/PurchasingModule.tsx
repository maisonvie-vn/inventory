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
  po_reference?: string;
  supplier_id: string;
  supplier_name?: string;
  status: string;
  total_value: number;
  created_at: string;
  requested_by?: string;
  approved_by?: string;
  second_approver?: string;
  approved_at?: string;
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
  moq?: number;
  pack_size?: number;
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
  checkInputGuardRail?: (ingredientId: string, type: 'qty' | 'price', value: number, txnType?: string) => { warning: boolean; msg?: string };
}

// -------------------------------------------------------------------
// Component chính
// -------------------------------------------------------------------
export default function PurchasingModule({
  userRole, userId, badges, onResolveBadge, canViewFinancials, checkInputGuardRail
}: PurchasingModuleProps) {
  const [activeSubTab, setActiveSubTab] = useState<'worklist' | 'create_po' | 'approve' | 'history' | 'grn' | 'suppliers_mgmt'>('worklist');
  const [editingPO, setEditingPO] = useState<PurchaseOrder | null>(null);
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

  // Xóa nhà cung cấp
  const handleDeleteSupplier = useCallback(async (id: string, name: string) => {
    if (!window.confirm(`Bạn có chắc muốn XÓA nhà cung cấp "${name}" không?\nHành động này không thể hoàn tác.`)) return;
    try {
      // Xóa tất cả bảng con có FK trỏ về suppliers (theo thứ tự)
      await supabase.from('supplier_prices').delete().eq('supplier_id', id);
      await supabase.from('supplier_ingredients').delete().eq('supplier_id', id);
      // Đặt preferred_supplier = null trên ingredients trỏ về NCC này
      await supabase.from('ingredients').update({ preferred_supplier_id: null }).eq('preferred_supplier_id', id);
      // Xóa purchase_order_lines liên quan (nếu có PO nháp)
      // Không xóa PO đã duyệt - để nguyên lịch sử
      const { error } = await supabase.from('suppliers').delete().eq('id', id);
      if (error) throw error;
      alert('✅ Đã xóa nhà cung cấp thành công!');
      fetchAll();
    } catch (err: any) {
      alert(`❌ Lỗi xóa nhà cung cấp: ${err.message}`);
    }
  }, [fetchAll]);

  // Lưu danh sách sản phẩm của NCC vào supplier_ingredients
  const handleSaveSupplierIngredients = useCallback(async (supplierId: string, ingredientIds: string[]) => {
    try {
      // Xóa hết mapping cũ
      await supabase.from('supplier_ingredients').delete().eq('supplier_id', supplierId);
      // Insert mapping mới
      if (ingredientIds.length > 0) {
        const rows = ingredientIds.map(ingId => ({ supplier_id: supplierId, ingredient_id: ingId }));
        const { error } = await supabase.from('supplier_ingredients').insert(rows);
        if (error) throw error;
      }
      alert(`✅ Đã lưu ${ingredientIds.length} sản phẩm cho nhà cung cấp!`);
      fetchAll();
    } catch (err: any) {
      alert(`❌ Lỗi lưu sản phẩm NCC: ${err.message}`);
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

  // Rút lại PO về DRAFT (từ PENDING_APPROVAL, APPROVED, hoặc SENT)
  const handleRecallPO = useCallback(async (poId: string, currentStatus: string) => {
    if (!window.confirm(`Rút lại PO này từ trạng thái "${currentStatus}" về trạng thái Nháp để chỉnh sửa? Bạn sẽ cần gửi duyệt lại sau khi sửa xong.`)) return;
    try {
      const { error } = await supabase
        .from('purchase_orders')
        .update({ status: 'DRAFT', approved_by: null, second_approver: null, approved_at: null })
        .eq('id', poId)
        .in('status', ['PENDING_APPROVAL', 'APPROVED', 'SENT']);
      if (error) throw error;
      alert('✅ Đã rút lại PO về Nháp! Bạn có thể chỉnh sửa và gửi duyệt lại.');
      fetchAll();
    } catch (err: any) {
      alert(`❌ Lỗi rút lại PO: ${err.message}`);
    }
  }, [fetchAll]);

  // Xóa PO hoàn toàn (chỉ khi ở DRAFT)
  const handleDeletePO = useCallback(async (poId: string, poNo: string) => {
    if (!window.confirm(`Bạn có chắc muốn XÓA hoàn toàn phiếu đặt hàng ${poNo} không?\nHành động này không thể hoàn tác.`)) return;
    try {
      const { error } = await supabase
        .from('purchase_orders')
        .delete()
        .eq('id', poId);
      if (error) throw error;
      alert('✅ Đã xóa PO thành công!');
      onResolveBadge(poId);
      fetchAll();
    } catch (err: any) {
      alert(`❌ Lỗi xóa PO: ${err.message}`);
    }
  }, [fetchAll, onResolveBadge]);

  // Lưu PO sau khi chỉnh sửa
  const handleSavePO = useCallback(async (poId: string, updatedLines: any[], notes: string, locationId: string) => {
    try {
      setLoading(true);
      const newTotal = updatedLines.reduce((sum, line) => sum + (line.suggested_qty * line.unit_price), 0);

      // Cập nhật PO Header
      const { error: poErr } = await supabase
        .from('purchase_orders')
        .update({
          notes: notes,
          location_id: locationId,
          total_value: Math.round(newTotal)
        })
        .eq('id', poId);
      
      if (poErr) throw poErr;

      // Xóa lines cũ
      const { error: delLinesErr } = await supabase
        .from('po_lines')
        .delete()
        .eq('po_id', poId);

      if (delLinesErr) throw delLinesErr;

      // Chèn lines mới
      const formattedLines = await Promise.all(updatedLines.map(async (line) => {
        let stockAtOrder = 0;
        try {
          const { data: stockData } = await supabase
            .from('v_stock_on_hand')
            .select('qty_on_hand')
            .eq('ingredient_id', line.ingredient_id)
            .eq('location_id', locationId)
            .maybeSingle();
          stockAtOrder = stockData?.qty_on_hand || 0;
        } catch (e) {
          console.warn('Error fetching stock_at_order:', e);
        }

        return {
          po_id: poId,
          ingredient_id: line.ingredient_id,
          qty: line.suggested_qty,
          qty_ordered: line.suggested_qty,
          uom: line.uom,
          purchase_uom: line.uom,
          unit_price: line.unit_price,
          suggested_qty: line.suggested_qty,
          moq_applied: line.moq || 1,
          pack_size_applied: line.pack_size || 1,
          estimated_value: line.suggested_qty * line.unit_price,
          stock_at_order: stockAtOrder
        };
      }));

      const { error: insLinesErr } = await supabase
        .from('po_lines')
        .insert(formattedLines);

      if (insLinesErr) throw insLinesErr;

      alert('✅ Đã cập nhật phiếu đặt hàng PO thành công!');
      setEditingPO(null);
      fetchAll();
    } catch (err: any) {
      alert(`❌ Lỗi lưu PO: ${err.message}`);
    } finally {
      setLoading(false);
    }
  }, [fetchAll]);

  // Hủy PO (bất kỳ trạng thái nào trước RECEIVED/CLOSED)
  const handleCancelPO = useCallback(async (poId: string, poRef: string) => {
    const reason = window.prompt(`Lý do hủy PO "${poRef}":\n(Bắt buộc)`);
    if (reason === null) return; // User nhấn Cancel
    if (!reason.trim()) { alert('Vui lòng nhập lý do hủy!'); return; }
    try {
      // Kiểm tra trạng thái hiện tại trước
      const { data: po, error: fetchErr } = await supabase
        .from('purchase_orders')
        .select('id, status')
        .eq('id', poId)
        .single();
      if (fetchErr) throw fetchErr;
      if (['RECEIVED', 'CLOSED', 'CANCELLED'].includes(po.status)) {
        alert(`⚠️ PO này đang ở trạng thái "${po.status}" — không thể hủy.`);
        return;
      }
      const { error } = await supabase
        .from('purchase_orders')
        .update({ status: 'CANCELLED', notes: `[HỦY] ${reason.trim()}` })
        .eq('id', poId);
      if (error) throw error;
      alert('✅ Đã hủy PO thành công!');
      await fetchAll();
    } catch (err: any) {
      alert(`❌ Lỗi hủy PO: ${err.message}`);
    }
  }, [fetchAll]);

  // Nhân bản PO (để sửa): tạo DRAFT mới sao chép từ PO cũ
  const handleClonePO = useCallback(async (po: PurchaseOrder) => {
    if (!window.confirm(`Tạo Phiếu Đặt Hàng mới sao chép từ PO này?\n(PO cũ giữ nguyên, PO mới sẽ ở trạng thái Nháp để bạn chỉnh sửa rồi gửi duyệt lại.)`)) return;
    try {
      // Lấy các dòng của PO gốc
      const { data: lines, error: lErr } = await supabase
        .from('po_lines')
        .select('ingredient_id, suggested_qty, unit_price, uom, moq_applied, pack_size_applied')
        .eq('po_id', po.id);
      if (lErr) throw lErr;

      const formattedLines = (lines || []).map((l: any) => ({
        ingredient_id: l.ingredient_id,
        suggested_qty: l.suggested_qty,
        unit_price: l.unit_price,
        uom: l.uom,
        moq: l.moq_applied || 1,
        pack_size: l.pack_size_applied || 1,
      }));

      const { data: newPoId, error } = await supabase.rpc('create_po_from_worklist', {
        p_supplier_id: po.supplier_id,
        p_location_id: po.location_id || 'MAIN_STORE',
        p_lines: formattedLines,
        p_notes: `[SAO CHÉP từ PO] ${po.po_reference || po.id.slice(0,8)} - Chỉnh sửa lại`,
      });
      if (error) throw error;
      alert(`✅ Đã tạo PO mới (Nháp) từ bản sao chép!\nID: ${newPoId}\n\nVui lòng vào tab "Duyệt PO" để xem và gửi duyệt.`);
      fetchAll();
      setActiveSubTab('approve');
    } catch (err: any) {
      alert(`❌ Lỗi sao chép PO: ${err.message}`);
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
        const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
        const validUserId = (userId && uuidRegex.test(userId)) ? userId : null;
        const { error: approveErr } = await supabase.rpc('approve_goods_receipt', {
          p_grn_id: grn!.id,
          p_user_id: validUserId
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
          internalCode,
          ingredientName,
          item.qty,
          item.purchase_uom || 'UNIT',
          item.unit_price || matchingIng?.wac_price || matchingIng?.standard_price || 0,
          po.po_no,
          todayStr,
          po.notes || '',
          stockAtOrder
        ]);
      }
    }

    const ws = XLSX.utils.aoa_to_sheet([...headers, ...dataRows]);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'GRN_PO_Import');

    const fileSuffix = pos.length === 1 ? pos[0].po_no : `BULK_${pos.length}_POs`;
    const excelFileName = `GRN_PO_Import_${fileSuffix}.xlsx`;

    XLSX.writeFile(wb, excelFileName);
    alert(`Đã xuất dữ liệu đặt hàng thành công ra file Excel nhập kho: ${excelFileName}\nBạn có thể sửa số lượng thực nhận, đơn giá trực tiếp trên file này và upload vào tab "Nhập hàng".`);
  };

  // Xuất PDF Purchase Order gửi NCC — dùng browser print
  // Xuất PDF Purchase Order gửi NCC — dùng browser print
  const handleExportPDF = (poOrPos: PurchaseOrder | PurchaseOrder[]) => {
    const pos = Array.isArray(poOrPos) ? poOrPos : [poOrPos];
    if (pos.length === 0) return;

    const today = new Date().toLocaleDateString('vi-VN');

    // Group POs by Supplier (NCC)
    const groups: Record<string, {
      supplierId: string;
      supplierName: string;
      poNumbers: string[];
      items: {
        ingredient_id: string;
        ingredient_name: string;
        qty: number;
        purchase_uom: string;
        unit_price: number;
        stock_at_order: number;
      }[];
      notes: string[];
      leadTimeDays: number;
    }> = {};

    pos.forEach((po) => {
      const supId = po.supplier_id || 'UNKNOWN';
      const supplier = suppliers.find((s: any) => s.id === po.supplier_id);
      const supName = po.supplier_name || supplier?.name || supId;
      
      if (!groups[supId]) {
        groups[supId] = {
          supplierId: supId,
          supplierName: supName,
          poNumbers: [],
          items: [],
          notes: [],
          leadTimeDays: (po as any).lead_time_days || supplier?.lead_time_days || 2
        };
      }

      groups[supId].poNumbers.push(po.po_no);
      if (po.notes && po.notes.trim()) {
        groups[supId].notes.push(`${po.po_no}: ${po.notes}`);
      }

      (po.items || []).forEach((item) => {
        const existing = groups[supId].items.find(i => i.ingredient_id === item.ingredient_id);
        if (existing) {
          existing.qty += item.qty;
        } else {
          groups[supId].items.push({
            ingredient_id: item.ingredient_id,
            ingredient_name: item.ingredient_name || '',
            qty: item.qty,
            purchase_uom: item.purchase_uom,
            unit_price: item.unit_price,
            stock_at_order: (item as any).stock_at_order || 0
          });
        }
      });
    });

    const pages = Object.values(groups).map((group) => {
      const supplier = suppliers.find((s: any) => s.id === group.supplierId);
      const supPhone = supplier?.contact?.phone || '';
      const supEmail = supplier?.contact?.email || '';
      const supAddress = supplier?.contact?.address || '';

      const lines = group.items.map((item, idx) => {
        const matchingIng = allIngredients.find((ing: any) =>
          ing.id === item.ingredient_id || ing.code === item.ingredient_id
        );
        const code = matchingIng?.code || item.ingredient_id || '';
        const name = item.ingredient_name || matchingIng?.ten_vi || '';
        const qty = item.qty || 0;
        const uom = item.purchase_uom || 'UNIT';
        const price = item.unit_price || matchingIng?.wac_price || 0;
        const total = qty * price;
        const stock = item.stock_at_order || 0;

        return `
          <tr>
            <td style="text-align:center;border:1px solid #ccc;padding:6px 4px;">${idx + 1}</td>
            <td style="font-family:monospace;border:1px solid #ccc;padding:6px 4px;">${code}</td>
            <td style="border:1px solid #ccc;padding:6px 8px;">${name}</td>
            <td style="text-align:center;border:1px solid #ccc;padding:6px 4px;">${uom}</td>
            <td style="text-align:right;border:1px solid #ccc;padding:6px 4px;">${qty.toLocaleString('vi-VN')}</td>
            <td style="text-align:right;border:1px solid #ccc;padding:6px 4px;">${price > 0 ? price.toLocaleString('vi-VN') : '—'}</td>
            <td style="text-align:right;border:1px solid #ccc;padding:6px 4px;font-weight:600;">${price > 0 ? total.toLocaleString('vi-VN') : '—'}</td>
            <td style="text-align:right;border:1px solid #ccc;padding:6px 4px;color:#c0392b;">${stock.toFixed(2)}</td>
          </tr>`;
      }).join('');

      const grandTotal = group.items.reduce((sum, item) => {
        const qty = item.qty || 0;
        const price = item.unit_price || 0;
        return sum + qty * price;
      }, 0);

      const deliveryDate = new Date(Date.now() + (group.leadTimeDays * 86400000)).toLocaleDateString('vi-VN');
      const poNumbersStr = group.poNumbers.join(', ');

      return `
        <div class="po-page" style="page-break-inside:avoid;margin-bottom:50px;border-bottom:3px double #7a5c2e;padding-bottom:30px;">
          <!-- Header -->
          <div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:24px;">
            <div>
              <div style="font-size:22px;font-weight:800;color:#1a3a38;letter-spacing:1px;">MAISON VIE</div>
              <div style="font-size:11px;color:#555;margin-top:2px;">Nhà hàng – Fine Dining</div>
              <div style="font-size:10px;color:#777;margin-top:6px;">📍 28 Tăng Bạt Hổ, Hai Bà Trưng, Hà Nội</div>
              <div style="font-size:10px;color:#777;">📞 024 3633 8828 &nbsp; ✉️ info@maisonvie.vn</div>
            </div>
            <div style="text-align:right;">
              <div style="font-size:20px;font-weight:800;color:#7a5c2e;letter-spacing:2px;">PURCHASE ORDER</div>
              <div style="font-size:11px;color:#333;margin-top:4px;">PHIẾU ĐẶT HÀNG</div>
              <table style="margin-top:8px;font-size:11px;border-collapse:collapse;margin-left:auto;">
                <tr><td style="color:#777;padding:2px 8px 2px 0;text-align:right;">Số PO:</td><td style="font-weight:700;color:#1a3a38;text-align:left;">${poNumbersStr}</td></tr>
                <tr><td style="color:#777;padding:2px 8px 2px 0;text-align:right;">Ngày lập:</td><td style="text-align:left;">${today}</td></tr>
                <tr><td style="color:#777;padding:2px 8px 2px 0;text-align:right;">Giao trước:</td><td style="font-weight:600;color:#c0392b;text-align:left;">${deliveryDate}</td></tr>
              </table>
            </div>
          </div>

          <hr style="border:none;border-top:2px solid #7a5c2e;margin-bottom:16px;"/>

          <!-- Supplier Info -->
          <div style="background:#f9f6f0;border:1px solid #e8d5b0;border-radius:6px;padding:12px 16px;margin-bottom:20px;">
            <div style="font-size:11px;font-weight:700;color:#7a5c2e;text-transform:uppercase;letter-spacing:1px;margin-bottom:6px;">Kính gửi Nhà Cung Cấp:</div>
            <div style="font-size:14px;font-weight:700;color:#1a3a38;">${group.supplierName}</div>
            ${supPhone ? `<div style="font-size:11px;color:#555;margin-top:3px;">📞 ${supPhone}</div>` : ''}
            ${supEmail ? `<div style="font-size:11px;color:#555;">✉️ ${supEmail}</div>` : ''}
            ${supAddress ? `<div style="font-size:11px;color:#555;">📍 ${supAddress}</div>` : ''}
          </div>

          <!-- Items Table -->
          <table style="width:100%;border-collapse:collapse;font-size:11px;margin-bottom:16px;">
            <thead>
              <tr style="background:#1a3a38;color:white;">
                <th style="padding:8px 4px;text-align:center;border:1px solid #1a3a38;width:32px;">STT</th>
                <th style="padding:8px 4px;text-align:left;border:1px solid #1a3a38;width:80px;">Mã hàng</th>
                <th style="padding:8px 8px;text-align:left;border:1px solid #1a3a38;">Tên sản phẩm / Nguyên liệu</th>
                <th style="padding:8px 4px;text-align:center;border:1px solid #1a3a38;width:50px;">ĐVT</th>
                <th style="padding:8px 4px;text-align:right;border:1px solid #1a3a38;width:65px;">SL đặt</th>
                <th style="padding:8px 4px;text-align:right;border:1px solid #1a3a38;width:90px;">Đơn giá (₫)</th>
                <th style="padding:8px 4px;text-align:right;border:1px solid #1a3a38;width:100px;">Thành tiền (₫)</th>
                <th style="padding:8px 4px;text-align:right;border:1px solid #1a3a38;width:80px;">SL tồn</th>
              </tr>
            </thead>
            <tbody>
              ${lines}
            </tbody>
            <tfoot>
              <tr style="background:#f0ece3;">
                <td colspan="6" style="text-align:right;border:1px solid #ccc;padding:8px;font-weight:700;">TỔNG CỘNG:</td>
                <td colspan="2" style="text-align:right;border:1px solid #ccc;padding:8px;font-weight:800;color:#7a5c2e;font-size:13px;">
                  ${grandTotal > 0 ? grandTotal.toLocaleString('vi-VN') : '(Giá TBD)'}
                </td>
              </tr>
            </tfoot>
          </table>

          <!-- Notes -->
          ${group.notes.length > 0 ? `
          <div style="background:#fff8e8;border-left:3px solid #e8b84b;padding:8px 12px;font-size:11px;margin-bottom:16px;">
            <strong>Ghi chú đơn hàng:</strong><br/>
            ${group.notes.map(n => `• ${n}`).join('<br/>')}
          </div>` : ''}

          <!-- Terms -->
          <div style="font-size:10px;color:#777;border:1px solid #eee;border-radius:4px;padding:10px 12px;margin-bottom:20px;">
            <strong style="color:#333;">Điều kiện giao hàng:</strong>
            Vui lòng giao hàng đúng số lượng, chủng loại, chất lượng theo yêu cầu. Hàng hóa cần kèm theo hóa đơn VAT hợp lệ.
            Mọi thắc mắc vui lòng liên hệ bộ phận thu mua trước khi giao hàng.
          </div>

          <!-- Signatures -->
          <div style="display:flex;justify-content:space-between;margin-top:24px;">
            <div style="text-align:center;width:30%;">
              <div style="font-size:11px;font-weight:700;color:#333;margin-bottom:48px;">NGƯỜI LẬP PHIẾU</div>
              <div style="border-top:1px solid #999;padding-top:4px;font-size:10px;color:#777;">(Ký, họ tên)</div>
            </div>
            <div style="text-align:center;width:30%;">
              <div style="font-size:11px;font-weight:700;color:#333;margin-bottom:48px;">TRƯỞNG BỘ PHẬN</div>
              <div style="border-top:1px solid #999;padding-top:4px;font-size:10px;color:#777;">(Ký, họ tên)</div>
            </div>
            <div style="text-align:center;width:30%;">
              <div style="font-size:11px;font-weight:700;color:#333;margin-bottom:48px;">NHÀ CUNG CẤP XÁC NHẬN</div>
              <div style="border-top:1px solid #999;padding-top:4px;font-size:10px;color:#777;">(Ký, đóng dấu)</div>
            </div>
          </div>

          <div style="text-align:center;font-size:9px;color:#aaa;margin-top:16px;border-top:1px solid #eee;padding-top:8px;">
            Maison Vie · Purchase Order ${poNumbersStr} · Xuất ngày ${today}
          </div>
        </div>`;
    });

    // Tạo cửa sổ in
    const printWin = window.open('', '_blank', 'width=900,height=700');
    if (!printWin) { alert('Trình duyệt đã chặn popup. Vui lòng cho phép popup cho trang này.'); return; }

    printWin.document.write(`<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Purchase Order – Consolidated PDF</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Segoe UI', Arial, sans-serif; color: #222; background: #fff; }
    .po-page {
      width: 210mm;
      min-height: 297mm;
      margin: 0 auto;
      padding: 20mm 18mm;
      page-break-after: always;
    }
    .po-page:last-child { page-break-after: avoid; }
    @media print {
      body { margin: 0; }
      .po-page { margin: 0; padding: 15mm 14mm; }
      .no-print { display: none !important; }
    }
    @page { size: A4; margin: 0; }
  </style>
</head>
<body>
  <div class="no-print" style="background:#1a3a38;color:white;padding:12px 20px;display:flex;gap:12px;align-items:center;position:sticky;top:0;z-index:99;">
    <span style="font-weight:700;">📄 Purchase Order PDF Preview (NCC Grouped)</span>
    <button onclick="window.print()" style="background:#c0a050;color:white;border:none;padding:8px 20px;border-radius:6px;font-weight:700;cursor:pointer;font-size:14px;">🖨️ In / Lưu PDF</button>
    <button onclick="window.close()" style="background:transparent;color:#aaa;border:1px solid #aaa;padding:8px 14px;border-radius:6px;cursor:pointer;">Đóng</button>
    <span style="font-size:12px;color:#aaa;margin-left:8px;">Tip: Chọn "Lưu thành PDF" trong hộp thoại in để xuất file PDF</span>
  </div>
  ${pages.join('\n')}
</body>
</html>`);
    printWin.document.close();
    // Tự động mở print dialog sau khi load xong
    printWin.onload = () => { printWin.focus(); };
  };



  // -------------------------------------------------------------------
  // Render
  // -------------------------------------------------------------------
  return (
    <div className="space-y-4">
      {editingPO ? (
        <EditPOPanel
          po={editingPO}
          ingredients={allIngredients}
          supplierIngredients={supplierIngredients}
          suppliers={suppliers}
          onSave={handleSavePO}
          onCancel={() => setEditingPO(null)}
        />
      ) : (
        <>
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
          checkInputGuardRail={checkInputGuardRail}
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
          onRecall={handleRecallPO}
          onCancel={handleCancelPO}
          onPrint={handlePrintPO}
          onExportPDF={handleExportPDF}
          onEdit={setEditingPO}
          onDelete={handleDeletePO}
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
          onCancel={handleCancelPO}
          onClone={handleClonePO}
          onExportPDF={handleExportPDF}
          onRecall={handleRecallPO}
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
          allIngredients={allIngredients}
          supplierIngredients={supplierIngredients}
          onAddSupplier={handleAddSupplier}
          onToggleActive={handleToggleSupplierActive}
          onDeleteSupplier={handleDeleteSupplier}
          onSaveSupplierIngredients={handleSaveSupplierIngredients}
          loading={loading}
          canApprove={canApprove}
        />
      )}
        </>
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
          <table className="w-full text-xs min-w-[850px]">
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
                        {item.estimated_value ? `${Math.round(item.estimated_value).toLocaleString('vi-VN')}` : '–'}
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
  onRecall,
  onCancel,
  onPrint,
  onExportPDF,
  onEdit,
  onDelete,
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
              <div className="flex gap-2">
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
                <button
                  onClick={() => {
                    const selectedList = purchaseOrders.filter((po: any) => selectedPOs.has(po.id));
                    onExportPDF(selectedList);
                  }}
                  className="px-3 py-1.5 bg-[#0C201F] border border-[#62A57C]/50 text-[#62A57C] hover:bg-[#62A57C] hover:text-white rounded-lg text-xs font-medium transition-colors flex items-center gap-1.5"
                >
                  <Printer size={12} />
                  Xuất PDF hàng loạt ({selectedPOs.size} PO)
                </button>
              </div>
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
                      {po.total_value?.toLocaleString('vi-VN')}
                    </div>
                  )}
                </div>
                <div className="flex gap-2">
                  <button onClick={() => onPrint(po)} className="p-2 rounded border border-[#C9A581]/30 text-[#C9A581] hover:text-white hover:border-[#A8884E] transition-colors" title="Xuất Excel Nhập Kho">
                    <Upload size={14} className="rotate-180" />
                  </button>
                  <button onClick={() => onExportPDF(po)} className="p-2 rounded border border-[#C9A581]/30 text-[#C9A581] hover:text-white hover:border-[#A8884E] transition-colors" title="Xuất PDF Gửi NCC">
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
                {po.status === 'DRAFT' && (
                  <>
                    <button
                      onClick={() => onEdit(po)}
                      className="px-3 py-1.5 bg-[#0C201F] border border-[#C9A581]/50 text-[#C9A581] hover:bg-[#A8884E] hover:text-white rounded-lg text-xs font-medium transition-colors flex items-center gap-1"
                      title="Chỉnh sửa nội dung PO"
                    >
                      ✏️ Sửa PO
                    </button>
                    <button
                      onClick={() => onDelete(po.id, po.po_no)}
                      className="px-3 py-1.5 bg-[#3A1B17] border border-[#D06A5C]/50 text-[#D06A5C] hover:bg-[#D06A5C] hover:text-white rounded-lg text-xs font-medium transition-colors flex items-center gap-1"
                      title="Xóa PO vĩnh viễn"
                    >
                      🗑️ Xóa PO
                    </button>
                  </>
                )}
                {/* Nút Rút lại: người tạo hoặc admin/manager có thể rút lại PO đang chờ duyệt */}
                {po.status === 'PENDING_APPROVAL' && (isSelfRequested || canApprove) && (
                  <button
                    onClick={() => onRecall(po.id, po.status)}
                    className="px-3 py-1.5 bg-[#3A2C13] border border-[#D8AA57] text-[#D8AA57] hover:bg-[#D8AA57] hover:text-white rounded-lg text-xs font-medium transition-colors flex items-center gap-1"
                  >
                    ↩ Rút lại về Nháp
                  </button>
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
                {po.status === 'PENDING_APPROVAL' && !isSelfRequested && !canApprove && (
                  <span className="text-xs text-[#D8AA57] italic">⚠ Đang chờ người có quyền duyệt...</span>
                )}
                {/* Nút Hủy PO (chỉ admin/manager) */}
                {canApprove && !['RECEIVED','CLOSED','CANCELLED'].includes(po.status) && (
                  <button
                    onClick={() => onCancel(po.id, po.po_reference || po.po_no || po.id.slice(0,8))}
                    className="px-3 py-1.5 bg-[#3A1B17] border border-[#D06A5C]/50 text-[#D06A5C] hover:bg-[#D06A5C] hover:text-white rounded-lg text-xs font-medium transition-colors flex items-center gap-1"
                  >
                    <XCircle size={12} /> Hủy PO
                  </button>
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
  onCancel,
  onClone,
  onExportPDF,
  onRecall,
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
          <div className="flex gap-2">
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
            <button
              onClick={() => {
                const selectedList = filtered.filter((po: any) => selectedPOs.has(po.id));
                onExportPDF(selectedList);
              }}
              className="px-3 py-1.5 bg-[#0C201F] border border-[#62A57C]/50 text-[#62A57C] hover:bg-[#62A57C] hover:text-white rounded-lg text-xs font-medium transition-colors flex items-center gap-1.5"
            >
              <Printer size={12} />
              Xuất PDF hàng loạt ({selectedPOs.size} PO)
            </button>
          </div>
        )}
      </div>
      <div className="overflow-x-auto rounded-xl border border-[#C9A581]/20">
        <table className="w-full text-xs min-w-[700px]">
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
                    {po.total_value?.toLocaleString('vi-VN')}
                  </td>
                )}
                <td className="p-2 text-[#C9A581]">{new Date(po.created_at).toLocaleDateString('vi-VN')}</td>
                <td className="p-2">
                  <div className="flex items-center gap-1">
                    <button onClick={() => onPrint(po)} className="p-1 text-[#C9A581] hover:text-white transition-colors" title="Xuất Excel Nhập Kho">
                      <Upload size={12} className="rotate-180" />
                    </button>
                    <button onClick={() => onExportPDF(po)} className="p-1 text-[#C9A581] hover:text-white transition-colors" title="Xuất PDF Gửi NCC">
                      <Printer size={12} />
                    </button>
                    {/* Rút lại về Nháp để sửa (cho phép nếu là APPROVED hoặc SENT) */}
                    {['APPROVED', 'SENT'].includes(po.status) && onRecall && (
                      <button
                        onClick={() => onRecall(po.id, po.status)}
                        title="Rút lại PO này về trạng thái Nháp để chỉnh sửa"
                        className="p-1 text-[#D8AA57] hover:text-[#D8AA57] transition-colors text-[10px] cursor-pointer"
                      >
                        ↩️
                      </button>
                    )}
                    {/* Nhân bản PO để sửa (tạo DRAFT mới) */}
                    {!['CANCELLED'].includes(po.status) && onClone && (
                      <button
                        onClick={() => onClone(po)}
                        title="Sao chép PO này để tạo đơn mới (có thể chỉnh sửa)"
                        className="p-1 text-[#C9A581] hover:text-[#A8884E] transition-colors text-[10px] font-bold cursor-pointer"
                      >
                        📋
                      </button>
                    )}
                    {/* Hủy PO */}
                    {!['RECEIVED','CLOSED','CANCELLED'].includes(po.status) && onCancel && (
                      <button
                        onClick={() => onCancel(po.id, po.po_reference || po.po_no || po.id.slice(0,8))}
                        title="Hủy PO này"
                        className="p-1 text-[#D06A5C] hover:text-[#f87171] transition-colors text-[10px] cursor-pointer"
                      >
                        ⛔
                      </button>
                    )}
                  </div>
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
      <div className="rounded-xl border border-[#C9A581]/20 overflow-x-auto">
        <table className="w-full text-xs min-w-[650px]">
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
function CreatePOTab({ suppliers, ingredients, supplierIngredients = [], onCreatePO, loading, checkInputGuardRail }: any) {
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

    if (checkInputGuardRail) {
      const qtyRes = checkInputGuardRail(selIngId, 'qty', qty, 'IMPORT');
      if (qtyRes.warning) {
        const ok = window.confirm(`${qtyRes.msg}\n\nBạn có chắc chắn muốn thêm dòng này không?`);
        if (!ok) return;
      }
      
      const priceRes = checkInputGuardRail(selIngId, 'price', price || selectedIng.wac_price || 0, 'IMPORT');
      if (priceRes.warning) {
        const ok = window.confirm(`${priceRes.msg}\n\nBạn có chắc chắn muốn thêm dòng này không?`);
        if (!ok) return;
      }
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
              <div>WAC hiện tại: <span className="font-mono text-[#62A57C]">{(selectedIng.wac_price || 0).toLocaleString()}</span></div>
            </div>
          )}
        </div>
      </div>

      {/* Danh sách dòng PO đã thêm */}
      {lines.length > 0 && (
        <div className="border-t border-[#C9A581]/20 pt-3">
          <div className="overflow-x-auto rounded-xl border border-[#C9A581]/20">
            <table className="w-full text-xs min-w-[600px]">
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
                  <td className="p-2 text-right text-[#C2A35A]">{l.unit_price.toLocaleString('vi-VN')}</td>
                  <td className="p-2 text-right text-[#62A57C] font-semibold">{(l.suggested_qty * l.unit_price).toLocaleString('vi-VN')}</td>
                  <td className="p-2 text-center">
                    <button onClick={() => handleRemoveLine(idx)} className="text-[#D06A5C] hover:text-[#f87171]">Xóa</button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          </div>

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
function SuppliersMgmtTab({ suppliers, allIngredients, supplierIngredients, onAddSupplier, onToggleActive, onDeleteSupplier, onSaveSupplierIngredients, loading, canApprove }: any) {
  // Form thêm NCC mới
  const [name, setName] = useState('');
  const [leadTime, setLeadTime] = useState(1);
  const [cutoffTime, setCutoffTime] = useState('17:00');
  const [phone, setPhone] = useState('');
  const [email, setEmail] = useState('');
  const [address, setAddress] = useState('');
  const [saving, setSaving] = useState(false);
  const [importStatus, setImportStatus] = useState<string | null>(null);

  // Tìm kiếm + panel sản phẩm NCC
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedSupplier, setSelectedSupplier] = useState<any>(null); // NCC đang chỉnh sửa sản phẩm
  const [ingSearchQuery, setIngSearchQuery] = useState(''); // tìm nguyên liệu trong panel
  const [editingIngIds, setEditingIngIds] = useState<Set<string>>(new Set()); // IDs đã tích trong panel
  const [savingIngs, setSavingIngs] = useState(false);

  // Khi chọn NCC để sửa sản phẩm → load danh sách hiện tại
  const openIngPanel = (sup: any) => {
    const currentIds = new Set<string>(
      supplierIngredients
        .filter((si: any) => si.supplier_id === sup.id)
        .map((si: any) => si.ingredient_id)
    );
    setEditingIngIds(currentIds);
    setIngSearchQuery('');
    setSelectedSupplier(sup);
  };

  const handleSaveIngs = async () => {
    if (!selectedSupplier) return;
    setSavingIngs(true);
    await onSaveSupplierIngredients(selectedSupplier.id, Array.from(editingIngIds));
    setSavingIngs(false);
    setSelectedSupplier(null);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim()) { alert('Vui lòng nhập tên nhà cung cấp'); return; }
    setSaving(true);
    await onAddSupplier({
      name: name.trim(),
      lead_time_days: Number(leadTime),
      cutoff_time: cutoffTime ? `${cutoffTime}:00` : null,
      contact: { phone: phone.trim() || null, email: email.trim() || null, address: address.trim() || null },
      is_active: true
    });
    setSaving(false);
    setName(''); setLeadTime(1); setCutoffTime('17:00'); setPhone(''); setEmail(''); setAddress('');
  };

  // File Excel mẫu — bao gồm cột mã sản phẩm NCC
  const handleExportTemplate = () => {
    const ws = XLSX.utils.aoa_to_sheet([
      ['Tên nhà cung cấp', 'Thời gian giao (ngày)', 'Giờ chốt đơn', 'Số điện thoại', 'Email', 'Địa chỉ', 'Mã sản phẩm (cách nhau bằng dấu phẩy)'],
      ['Cty TNHH Đầu tư phát triển TM TH Việt Nam', 2, '17:00', '024-3718-6200', 'order@company.vn', 'Hà Nội', 'V6027,V6028,B5001,M4012'],
      ['Nhà cung cấp Rau sạch Đà Lạt Hải Yến', 1, '20:00', '0912-345-678', 'sales@haiyenvn.vn', 'Đà Lạt, Lâm Đồng', 'NLP6001,NLP6002,NLP6010'],
    ]);
    // Đặt độ rộng cột
    ws['!cols'] = [{ wch: 45 }, { wch: 18 }, { wch: 14 }, { wch: 16 }, { wch: 25 }, { wch: 20 }, { wch: 40 }];
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
      if (dataRows.length === 0) { setImportStatus('❌ File Excel không có dữ liệu nhà cung cấp.'); return; }

      const names = dataRows.map(r => r[0].toString().trim());
      const { data: existing } = await supabase.from('suppliers').select('id, name').in('name', names);
      const existingMap = new Map((existing || []).map((s: any) => [s.name.toLowerCase(), s.id]));

      const toInsert: any[] = [];
      const skipped: string[] = [];
      const productMappings: { name: string; codes: string[] }[] = [];

      for (const row of dataRows) {
        const supName = row[0].toString().trim();
        const productCodesStr = row[6] ? row[6].toString().trim() : '';
        const productCodes = productCodesStr ? productCodesStr.split(',').map((c: string) => c.trim()).filter(Boolean) : [];

        if (existingMap.has(supName.toLowerCase())) {
          skipped.push(supName);
          // Vẫn xử lý sản phẩm cho NCC đã tồn tại nếu có
          if (productCodes.length > 0) productMappings.push({ name: supName, codes: productCodes });
          continue;
        }

        let ct = row[2] ? row[2].toString().trim() : null;
        if (ct) {
          const num = Number(ct);
          if (!isNaN(num)) {
            const tot = Math.round((num % 1) * 86400);
            ct = `${String(Math.floor(tot/3600)).padStart(2,'0')}:${String(Math.floor((tot%3600)/60)).padStart(2,'0')}:${String(tot%60).padStart(2,'0')}`;
          } else if (/^\d{1,2}:\d{2}$/.test(ct)) { ct = `${ct}:00`; }
          else if (!/^\d{1,2}:\d{2}:\d{2}$/.test(ct)) { ct = null; }
        }
        toInsert.push({
          name: supName,
          lead_time_days: isNaN(parseInt(row[1])) ? 1 : parseInt(row[1]),
          cutoff_time: ct,
          contact: { phone: row[3]?.toString().trim() || null, email: row[4]?.toString().trim() || null, address: row[5]?.toString().trim() || null },
          is_active: true
        });
        if (productCodes.length > 0) productMappings.push({ name: supName, codes: productCodes });
      }

      if (toInsert.length === 0 && productMappings.length === 0) {
        setImportStatus(`⚠️ Không có dữ liệu mới (${dataRows.length} NCC đã tồn tại và không có sản phẩm nào cần cập nhật).`);
        return;
      }

      // Insert NCC mới
      let insertedSupIds: Record<string, string> = {};
      if (toInsert.length > 0) {
        const { data: inserted, error } = await supabase.from('suppliers').insert(toInsert).select('id, name');
        if (error) throw error;
        (inserted || []).forEach((s: any) => { insertedSupIds[s.name.toLowerCase()] = s.id; });
      }

      // Gán sản phẩm vào supplier_ingredients
      let productsMapped = 0;
      if (productMappings.length > 0) {
        const { data: allSups } = await supabase.from('suppliers').select('id, name');
        const supMap = new Map((allSups || []).map((s: any) => [s.name.toLowerCase(), s.id]));
        const { data: allIngs } = await supabase.from('ingredients').select('id, code').eq('is_active', true);
        const ingCodeMap = new Map((allIngs || []).map((i: any) => [i.code.toUpperCase(), i.id]));
        const siRows: any[] = [];
        for (const pm of productMappings) {
          const supId = supMap.get(pm.name.toLowerCase());
          if (!supId) continue;
          for (const code of pm.codes) {
            const ingId = ingCodeMap.get(code.toUpperCase());
            if (ingId) { siRows.push({ supplier_id: supId, ingredient_id: ingId }); productsMapped++; }
          }
        }
        if (siRows.length > 0) {
          await supabase.from('supplier_ingredients').upsert(siRows, { onConflict: 'supplier_id,ingredient_id' });
        }
      }

      setImportStatus(
        `✅ Nhập thành công ${toInsert.length} nhà cung cấp mới${productsMapped > 0 ? ` + ${productsMapped} liên kết sản phẩm` : ''}.` +
        (skipped.length > 0 ? `\n⚠️ Bỏ qua ${skipped.length} NCC trùng tên: ${skipped.slice(0, 3).join(', ')}${skipped.length > 3 ? '...' : ''}` : '')
      );
      await onAddSupplier(null);
    } catch (err: any) {
      setImportStatus(`❌ Lỗi import: ${err.message}`);
    }
  };

  const filteredSuppliers = suppliers.filter((s: any) => {
    const q = searchQuery.toLowerCase();
    return s.name.toLowerCase().includes(q) || JSON.stringify(s.contact || {}).toLowerCase().includes(q);
  });

  // Nguyên liệu hiển thị trong panel gán sản phẩm
  const filteredIngsForPanel = useMemo(() => {
    const q = ingSearchQuery.toLowerCase().trim();
    const list: any[] = allIngredients || [];
    if (!q) return list.slice(0, 60);
    return list.filter((ing: any) =>
      (ing.code || '').toLowerCase().includes(q) ||
      (ing.ten_vi || ing.vi_name || '').toLowerCase().includes(q)
    ).slice(0, 60);
  }, [allIngredients, ingSearchQuery]);

  return (
    <div className="space-y-4 text-xs">

      {/* === PANEL GÁN SẢN PHẨM CHO NCC (mở khi click "Sản phẩm") === */}
      {selectedSupplier && (
        <div className="rounded-xl border border-[#A8884E] bg-[#042726] p-4 space-y-3 animate-fadeIn">
          <div className="flex items-center justify-between">
            <h3 className="text-[#FBF8F4] font-semibold text-sm flex items-center gap-2">
              <Package size={16} className="text-[#A8884E]" />
              Gán sản phẩm / nguyên liệu cho: <span className="text-[#C2A35A]">{selectedSupplier.name}</span>
            </h3>
            <button onClick={() => setSelectedSupplier(null)} className="text-gray-400 hover:text-gray-200 text-xs cursor-pointer">✕ Đóng</button>
          </div>
          <p className="text-[#C9A581] text-[11px]">
            Tích chọn các sản phẩm / nguyên liệu mà nhà cung cấp này cung ứng. Danh sách này sẽ được dùng để lọc khi tạo phiếu nhập GRN và PO.
          </p>

          {/* Tìm kiếm nguyên liệu */}
          <input
            type="text"
            placeholder="🔍 Tìm mã NVL hoặc tên sản phẩm..."
            value={ingSearchQuery}
            onChange={(e) => setIngSearchQuery(e.target.value)}
            className="w-full px-3 py-2 bg-[#03201E] border border-[#C9A581]/30 rounded-lg text-[#FBF8F4] placeholder-[#C9A581]/50 focus:outline-none focus:border-[#A8884E] transition-all"
          />

          <div className="flex items-center gap-3 text-[11px] text-[#C9A581]">
            <span>Đã chọn: <strong className="text-[#C2A35A]">{editingIngIds.size}</strong> sản phẩm</span>
            <button onClick={() => setEditingIngIds(new Set())} className="underline hover:text-[#FBF8F4] cursor-pointer">Bỏ chọn tất cả</button>
            <button onClick={() => setEditingIngIds(new Set((allIngredients || []).map((i: any) => i.id)))} className="underline hover:text-[#FBF8F4] cursor-pointer">Chọn tất cả</button>
          </div>

          {/* Grid sản phẩm */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-1.5 max-h-72 overflow-y-auto pr-1">
            {filteredIngsForPanel.map((ing: any) => {
              const ingId = ing.id;
              const ingCode = ing.code || '';
              const ingName = ing.ten_vi || ing.vi_name || '';
              const checked = editingIngIds.has(ingId);
              return (
                <label
                  key={ingId}
                  className={`flex items-center gap-2 p-2 rounded cursor-pointer border transition-all ${
                    checked
                      ? 'bg-[#C2A35A]/15 border-[#C2A35A]/50 text-[#C2A35A]'
                      : 'bg-[#03201E] border-[#C9A581]/20 text-[#C9A581] hover:border-[#C9A581]/50'
                  }`}
                >
                  <input
                    type="checkbox"
                    checked={checked}
                    onChange={() => {
                      setEditingIngIds(prev => {
                        const next = new Set(prev);
                        if (next.has(ingId)) next.delete(ingId); else next.add(ingId);
                        return next;
                      });
                    }}
                    className="accent-[#A8884E] shrink-0"
                  />
                  <div className="min-w-0">
                    <div className="font-mono text-[10px] font-bold truncate">{ingCode}</div>
                    <div className="text-[10px] truncate text-gray-300">{ingName}</div>
                  </div>
                </label>
              );
            })}
            {filteredIngsForPanel.length === 0 && (
              <div className="col-span-3 text-center text-gray-500 italic py-6">Không tìm thấy nguyên liệu</div>
            )}
          </div>

          <div className="flex justify-end gap-2 pt-2 border-t border-[#C9A581]/20">
            <button onClick={() => setSelectedSupplier(null)} className="px-4 py-2 border border-[#C9A581]/30 text-[#C9A581] rounded-lg hover:bg-[#C9A581]/10 transition-colors cursor-pointer">
              Hủy
            </button>
            <button
              onClick={handleSaveIngs}
              disabled={savingIngs}
              className="px-4 py-2 bg-[#A8884E] hover:bg-[#8C6F3C] disabled:opacity-60 text-white rounded-lg font-semibold transition-colors cursor-pointer"
            >
              {savingIngs ? 'Đang lưu...' : `💾 Lưu ${editingIngIds.size} sản phẩm cho NCC`}
            </button>
          </div>
        </div>
      )}

      {/* === EXCEL BULK IMPORT === */}
      {canApprove && (
        <div className="rounded-xl border border-[#C9A581]/30 bg-[#042726] p-4 space-y-3">
          <h3 className="text-[#FBF8F4] font-semibold flex items-center gap-2">
            <Upload size={16} className="text-[#A8884E]" />
            Nhập nhà cung cấp hàng loạt (Excel)
          </h3>
          <p className="text-[#C9A581] text-xs">
            File mẫu bao gồm cột <strong>Mã sản phẩm</strong> — bạn có thể điền mã code (cách nhau bằng dấu phẩy) để gán sản phẩm cho NCC ngay khi nhập.
          </p>
          <div className="flex gap-2 flex-wrap">
            <button onClick={handleExportTemplate} className="px-3 py-1.5 border border-[#A8884E] text-[#A8884E] hover:bg-[#A8884E]/10 rounded-lg text-xs flex items-center gap-2 transition-colors">
              <FileText size={12} /> Tải mẫu Excel (có cột Sản phẩm)
            </button>
            <label className="px-3 py-1.5 bg-[#A8884E] hover:bg-[#8C6F3C] text-white rounded-lg text-xs flex items-center gap-2 cursor-pointer transition-colors">
              <Upload size={12} /> Chọn file nhập hàng loạt
              <input type="file" accept=".xlsx,.xls" className="hidden" onChange={(e) => { const f = e.target.files?.[0]; if (f) { handleImportExcel(f); e.target.value = ''; } }} />
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

      {/* === LAYOUT: FORM THÊM + DANH SÁCH === */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-4">

        {/* Form thêm NCC mới */}
        {canApprove && (
          <div className="lg:col-span-1 rounded-xl border border-[#C9A581]/30 bg-[#042726] p-4 space-y-3">
            <h3 className="text-[#FBF8F4] font-semibold text-sm">Thêm nhà cung cấp mới</h3>
            <form onSubmit={handleSubmit} className="space-y-3">
              <div>
                <label className="block text-[#C9A581] mb-1 font-semibold">Tên nhà cung cấp *</label>
                <input
                  type="text" required value={name} onChange={(e) => setName(e.target.value)}
                  placeholder="VD: Công ty TNHH Thực Phẩm Sạch"
                  className="w-full bg-[#03201E] border border-[#C9A581]/30 rounded-lg p-2 text-[#FBF8F4] focus:outline-none focus:border-[#A8884E]"
                />
              </div>
              <div className="grid grid-cols-2 gap-2">
                <div>
                  <label className="block text-[#C9A581] mb-1 font-semibold">Giao hàng (ngày)</label>
                  <input type="number" min="0" value={leadTime} onChange={(e) => setLeadTime(Number(e.target.value))}
                    className="w-full bg-[#03201E] border border-[#C9A581]/30 rounded-lg p-2 text-[#FBF8F4] focus:outline-none focus:border-[#A8884E]" />
                </div>
                <div>
                  <label className="block text-[#C9A581] mb-1 font-semibold">Giờ chốt đơn</label>
                  <input type="time" value={cutoffTime} onChange={(e) => setCutoffTime(e.target.value)}
                    className="w-full bg-[#03201E] border border-[#C9A581]/30 rounded-lg p-2 text-[#FBF8F4] focus:outline-none focus:border-[#A8884E]" />
                </div>
              </div>
              <div>
                <label className="block text-[#C9A581] mb-1 font-semibold">Số điện thoại</label>
                <input type="text" value={phone} onChange={(e) => setPhone(e.target.value)} placeholder="VD: 0912345678"
                  className="w-full bg-[#03201E] border border-[#C9A581]/30 rounded-lg p-2 text-[#FBF8F4] focus:outline-none focus:border-[#A8884E]" />
              </div>
              <div>
                <label className="block text-[#C9A581] mb-1 font-semibold">Email</label>
                <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="VD: contact@supplier.com"
                  className="w-full bg-[#03201E] border border-[#C9A581]/30 rounded-lg p-2 text-[#FBF8F4] focus:outline-none focus:border-[#A8884E]" />
              </div>
              <div>
                <label className="block text-[#C9A581] mb-1 font-semibold">Địa chỉ</label>
                <textarea value={address} onChange={(e) => setAddress(e.target.value)} placeholder="Địa chỉ văn phòng / kho NCC..." rows={2}
                  className="w-full bg-[#03201E] border border-[#C9A581]/30 rounded-lg p-2 text-[#FBF8F4] focus:outline-none focus:border-[#A8884E] resize-none" />
              </div>
              <button type="submit" disabled={saving}
                className="w-full py-2 bg-[#A8884E] hover:bg-[#8C6F3C] disabled:opacity-50 text-white rounded-lg font-medium transition-colors">
                {saving ? 'Đang lưu...' : '+ Lưu nhà cung cấp'}
              </button>
              <p className="text-[10px] text-[#C9A581]/60 italic text-center">Sau khi lưu, nhấn nút "Sản phẩm" để gán nguyên liệu cho NCC này</p>
            </form>
          </div>
        )}

        {/* Danh sách NCC */}
        <div className={`${canApprove ? 'lg:col-span-2' : 'lg:col-span-3'} rounded-xl border border-[#C9A581]/30 bg-[#042726] p-4 space-y-3`}>
          <div className="flex items-center justify-between">
            <h3 className="text-[#FBF8F4] font-semibold text-sm">Danh sách nhà cung cấp</h3>
            <span className="text-[#C9A581] text-xs">Tổng số: {suppliers.length}</span>
          </div>

          <input type="text" placeholder="🔍 Tìm theo tên hoặc thông tin liên hệ..."
            value={searchQuery} onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full px-3 py-2 bg-[#03201E] border border-[#C9A581]/30 rounded-lg text-[#FBF8F4] placeholder-[#C9A581]/50 focus:outline-none focus:border-[#A8884E] transition-all"
          />

          {filteredSuppliers.length === 0 ? (
            <p className="text-[#C9A581] text-center py-8">Không tìm thấy nhà cung cấp nào</p>
          ) : (
            <div className="overflow-x-auto border border-[#C9A581]/10 rounded-lg">
              <table className="w-full text-xs min-w-[750px]">
                <thead>
                  <tr className="bg-[#03201E] text-[#C9A581] border-b border-[#C9A581]/20">
                    <th className="p-2 text-left">Tên nhà cung cấp</th>
                    <th className="p-2 text-left">Liên hệ</th>
                    <th className="p-2 text-center">Giao hàng</th>
                    <th className="p-2 text-center">Sản phẩm</th>
                    <th className="p-2 text-center">Trạng thái</th>
                    {canApprove && <th className="p-2 text-center">Thao tác</th>}
                  </tr>
                </thead>
                <tbody>
                  {filteredSuppliers.map((s: any) => {
                    const sPhone = s.contact?.phone || '';
                    const sEmail = s.contact?.email || '';
                    const sAddress = s.contact?.address || '';
                    const prodCount = supplierIngredients.filter((si: any) => si.supplier_id === s.id).length;
                    const isSelected = selectedSupplier?.id === s.id;
                    return (
                      <tr key={s.id} className={`border-b border-[#C9A581]/10 transition-colors ${isSelected ? 'bg-[#A8884E]/10' : 'hover:bg-[#0d3330]'}`}>
                        <td className="p-2 font-medium text-[#FBF8F4]">{s.name}</td>
                        <td className="p-2 text-[#C9A581] space-y-0.5">
                          {sPhone && <div>📞 {sPhone}</div>}
                          {sEmail && <div>✉️ {sEmail}</div>}
                          {sAddress && <div className="max-w-[160px] truncate" title={sAddress}>📍 {sAddress}</div>}
                          {!sPhone && !sEmail && !sAddress && <span>–</span>}
                        </td>
                        <td className="p-2 text-center text-[#FBF8F4]">
                          <div>{s.lead_time_days} ngày</div>
                          {s.cutoff_time && <div className="text-[#C9A581] text-[10px]">Cutoff: {s.cutoff_time.slice(0, 5)}</div>}
                        </td>
                        <td className="p-2 text-center">
                          <button
                            onClick={() => isSelected ? setSelectedSupplier(null) : openIngPanel(s)}
                            className={`px-2 py-1 rounded text-[10px] font-bold transition-colors cursor-pointer ${
                              isSelected
                                ? 'bg-[#A8884E] text-white'
                                : prodCount > 0
                                  ? 'bg-[#0C201F] text-[#62A57C] border border-[#62A57C]/30 hover:bg-[#62A57C] hover:text-white'
                                  : 'bg-[#3A2C13] text-[#D8AA57] border border-[#D8AA57]/30 hover:bg-[#D8AA57] hover:text-white'
                            }`}
                          >
                            {isSelected ? '✓ Đang sửa' : prodCount > 0 ? `📦 ${prodCount} SP` : '+ Thêm SP'}
                          </button>
                        </td>
                        <td className="p-2 text-center">
                          {canApprove ? (
                            <button
                              onClick={() => onToggleActive(s.id, s.is_active)}
                              className={`px-2 py-1 rounded text-[10px] font-bold transition-colors cursor-pointer ${
                                s.is_active
                                  ? 'bg-[#0C201F] text-[#62A57C] border border-[#62A57C]/30 hover:bg-[#62A57C] hover:text-white'
                                  : 'bg-[#3A1B17] text-[#D06A5C] border border-[#D06A5C]/30 hover:bg-[#D06A5C] hover:text-white'
                              }`}
                            >
                              {s.is_active ? 'Hoạt động' : 'Tắt'}
                            </button>
                          ) : (
                            <span className={`px-2 py-0.5 rounded text-[10px] font-bold ${s.is_active ? 'bg-[#0C201F] text-[#62A57C]' : 'bg-[#3A1B17] text-[#D06A5C]'}`}>
                              {s.is_active ? 'Hoạt động' : 'Tắt'}
                            </span>
                          )}
                        </td>
                        {canApprove && (
                          <td className="p-2 text-center">
                            <button
                              onClick={() => onDeleteSupplier(s.id, s.name)}
                              className="px-2 py-1 rounded text-[10px] font-bold bg-[#3A1B17] text-[#D06A5C] border border-[#D06A5C]/30 hover:bg-[#D06A5C] hover:text-white transition-colors cursor-pointer"
                              title="Xóa nhà cung cấp"
                            >
                              🗑 Xóa
                            </button>
                          </td>
                        )}
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

// -------------------------------------------------------------------
// EditPOPanel — Chỉnh sửa PO DRAFT
// -------------------------------------------------------------------
function EditPOPanel({
  po,
  ingredients,
  supplierIngredients = [],
  onSave,
  onCancel,
  suppliers
}: {
  po: PurchaseOrder;
  ingredients: any[];
  supplierIngredients?: any[];
  onSave: (poId: string, updatedLines: any[], notes: string, locationId: string) => Promise<void>;
  onCancel: () => void;
  suppliers: any[];
}) {
  const [lines, setLines] = useState<any[]>([]);
  const [notes, setNotes] = useState(po.notes || '');
  const [locationId, setLocationId] = useState(po.location_id || 'MAIN_STORE');
  const [selIngId, setSelIngId] = useState('');
  const [selectedIng, setSelectedIng] = useState<any>(null);
  const [qty, setQty] = useState(1);
  const [price, setPrice] = useState(0);

  // Khởi tạo lines từ PO items
  useEffect(() => {
    if (po && po.items) {
      setLines(po.items.map(item => {
        const ing = ingredients.find(i => i.id === item.ingredient_id || i.code === item.ingredient_id);
        return {
          ingredient_id: ing?.id || item.ingredient_id,
          code: ing?.code || item.ingredient_id,
          name: item.ingredient_name || ing?.ten_vi || '',
          suggested_qty: item.qty || 0,
          unit_price: item.unit_price || 0,
          uom: item.purchase_uom || ing?.stock_uom || 'kg',
          moq: item.moq || 1,
          pack_size: item.pack_size || 1
        };
      }));
    }
  }, [po, ingredients]);

  // Lọc nguyên liệu theo nhà cung cấp của PO
  const filteredIngs = useMemo(() => {
    const supplierId = po.supplier_id;
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
  }, [ingredients, po.supplier_id, supplierIngredients, suppliers]);

  const searchIngredientsFormat = useMemo(() => {
    return filteredIngs.map((ing: any) => ({
      id: ing.id,
      code: ing.code,
      vi_name: ing.ten_vi || ing.vi_name || '',
      fr_name: ing.nom_fr || '',
      category: ing.category || 'Nguyên liệu',
      unit: ing.stock_uom || ing.unit || 'kg',
      price: ing.wac_price || ing.price || 0,
      wac_price: ing.wac_price || ing.price || 0
    }));
  }, [filteredIngs]);

  const handleAddLine = () => {
    if (!selIngId || !selectedIng) return;
    if (lines.some(l => l.ingredient_id === selIngId)) {
      alert('Mặt hàng này đã có trong đơn');
      return;
    }
    const rawIng = ingredients.find((i: any) => i.id === selIngId);
    setLines([...lines, {
      ingredient_id: selectedIng.id,
      code: selectedIng.code,
      name: rawIng?.ten_vi || selectedIng.vi_name || '',
      suggested_qty: qty,
      unit_price: price || selectedIng.wac_price || rawIng?.wac_price || 0,
      uom: selectedIng.unit || rawIng?.stock_uom || 'kg',
      moq: 1,
      pack_size: 1
    }]);
    setSelIngId('');
    setSelectedIng(null);
    setQty(1);
    setPrice(0);
  };

  const handleRemoveLine = (idx: number) => {
    setLines(lines.filter((_, i) => i !== idx));
  };

  const handleUpdateLineQty = (idx: number, newQty: number) => {
    setLines(lines.map((l, i) => i === idx ? { ...l, suggested_qty: newQty } : l));
  };

  const handleUpdateLinePrice = (idx: number, newPrice: number) => {
    setLines(lines.map((l, i) => i === idx ? { ...l, unit_price: newPrice } : l));
  };

  const handleSubmit = () => {
    if (lines.length === 0) {
      alert('Vui lòng thêm ít nhất 1 mặt hàng');
      return;
    }
    onSave(po.id, lines, notes, locationId);
  };

  const supplier = suppliers.find(s => s.id === po.supplier_id);

  return (
    <div className="rounded-xl border border-[#A8884E] bg-[#042726] p-4 space-y-4 text-xs">
      <div className="flex items-center justify-between border-b border-[#C9A581]/20 pb-2">
        <h3 className="text-[#FBF8F4] font-semibold text-sm">Chỉnh sửa đơn đặt hàng: <span className="text-[#C2A35A] font-mono">{po.po_no}</span></h3>
        <button onClick={onCancel} className="text-gray-400 hover:text-gray-200 text-sm">✕ Đóng</button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
        <div>
          <label className="block text-[#C9A581] mb-1 font-semibold font-mono text-[10px]">NHÀ CUNG CẤP</label>
          <div className="bg-[#03201E] border border-[#C9A581]/20 rounded-lg p-2 text-[#FBF8F4] font-semibold">
            {supplier?.name || po.supplier_name || po.supplier_id}
          </div>
        </div>

        <div>
          <label className="block text-[#C9A581] mb-1 font-semibold font-mono text-[10px]">KHO NHẬN HÀNG *</label>
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
          <label className="block text-[#C9A581] mb-1 font-semibold font-mono text-[10px]">GHI CHÚ PO</label>
          <input
            type="text"
            value={notes}
            onChange={(e) => setNotes(e.target.value)}
            placeholder="Ghi chú đơn hàng..."
            className="w-full bg-[#03201E] border border-[#C9A581]/30 rounded-lg p-2 text-[#FBF8F4] focus:outline-none focus:border-[#A8884E]"
          />
        </div>
      </div>

      {/* Form thêm mặt hàng */}
      <div className="border-t border-[#C9A581]/20 pt-3 space-y-3">
        <h4 className="text-[#C9A581] font-semibold">Thêm mặt hàng mới vào đơn</h4>
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
              placeholder={po.supplier_id ? "Mã NVL hoặc tên của NCC..." : "Nhập mã hoặc tên..."}
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
        </div>
      </div>

      {/* Danh sách dòng hàng */}
      <div className="border-t border-[#C9A581]/20 pt-3">
        <div className="overflow-x-auto rounded-xl border border-[#C9A581]/20">
          <table className="w-full text-xs min-w-[650px]">
          <thead>
            <tr className="bg-[#03201E] text-[#C9A581] border-b border-[#C9A581]/20">
              <th className="p-2 text-left">Mã</th>
              <th className="p-2 text-left">Tên hàng</th>
              <th className="p-2 text-right w-24">SL đặt</th>
              <th className="p-2 text-right w-32">Đơn giá</th>
              <th className="p-2 text-right">Thành tiền</th>
              <th className="p-2"></th>
            </tr>
          </thead>
          <tbody>
            {lines.map((l, idx) => (
              <tr key={l.ingredient_id} className="border-b border-[#C9A581]/10 hover:bg-[#0d3330]">
                <td className="p-2 font-mono text-[#C2A35A]">{l.code}</td>
                <td className="p-2 text-[#FBF8F4]">{l.name}</td>
                <td className="p-2 text-right">
                  <div className="flex items-center justify-end gap-1">
                    <input
                      type="number"
                      min="0.0001"
                      step="any"
                      value={l.suggested_qty}
                      onChange={(e) => handleUpdateLineQty(idx, Number(e.target.value))}
                      className="bg-[#03201E] border border-[#C9A581]/30 rounded p-1 text-right text-[#FBF8F4] w-16"
                    />
                    <span className="text-[#C9A581]">{l.uom}</span>
                  </div>
                </td>
                <td className="p-2 text-right">
                  <input
                    type="number"
                    min="0"
                    value={l.unit_price}
                    onChange={(e) => handleUpdateLinePrice(idx, Number(e.target.value))}
                    className="bg-[#03201E] border border-[#C9A581]/30 rounded p-1 text-right text-[#C2A35A] w-24"
                  />
                </td>
                <td className="p-2 text-right text-[#62A57C] font-semibold">{(l.suggested_qty * l.unit_price).toLocaleString('vi-VN')}</td>
                <td className="p-2 text-center">
                  <button onClick={() => handleRemoveLine(idx)} className="text-[#D06A5C] hover:text-[#f87171]">Xóa</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        </div>

        <div className="flex justify-end items-center gap-4 mt-4 pt-3 border-t border-[#C9A581]/20">
          <div className="text-right">
            <span className="text-gray-400">TỔNG CỘNG: </span>
            <strong className="text-lg text-[#C2A35A] font-bold">
              {lines.reduce((sum, l) => sum + (l.suggested_qty * l.unit_price), 0).toLocaleString('vi-VN')}
            </strong>
          </div>
          <div className="flex gap-2">
            <button onClick={onCancel} className="px-4 py-2 border border-[#C9A581]/30 text-[#C9A581] rounded-lg hover:bg-[#C9A581]/10">Hủy</button>
            <button
              onClick={handleSubmit}
              className="px-4 py-2 bg-[#62A57C] hover:bg-[#4d8f66] text-white rounded-lg font-medium transition-colors"
            >
              Lưu thay đổi
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

