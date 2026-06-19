'use client';

import React, { useState, useMemo, useEffect } from 'react';
import { supabase, isSupabaseConfigured } from '../../lib/supabaseClient';
import { 
  Lock, 
  Unlock, 
  FileText, 
  Download, 
  Calendar, 
  CheckCircle2, 
  AlertTriangle, 
  History, 
  Search,
  Filter,
  Check,
  ChevronDown
} from 'lucide-react';
import * as XLSX from 'xlsx';

interface ClosedInventoryProps {
  userRole: 'admin' | 'restaurant_manager' | 'head_chef' | 'senior_accountant' | 'foh_supervisor' | 'sous_chef' | 'junior_accountant' | 'BAR_SUPERVISOR' | 'BARTENDER';
  ingredients: any[];
  transactions: any[];
  salesData: any[];
  wasteLogs: any[];
  goodsReceipts: any[];
  currentUser: any;
  posMappings: any;
  locations: any[];
}

export default function ClosedInventory({
  userRole,
  ingredients,
  transactions,
  salesData,
  wasteLogs,
  goodsReceipts,
  currentUser,
  posMappings,
  locations
}: ClosedInventoryProps) {
  const [periodType, setPeriodType] = useState<'DAY' | 'WEEK' | 'MONTH' | 'QUARTER' | 'YEAR'>('MONTH');
  const [selectedDate, setSelectedDate] = useState<string>(() => new Date().toISOString().split('T')[0]);
  const [selectedLocation, setSelectedLocation] = useState<string>('ALL');
  const [categoryFilter, setCategoryFilter] = useState<string>('ALL');
  const [searchQuery, setSearchQuery] = useState<string>('');
  const [showOnlyWithStock, setShowOnlyWithStock] = useState<boolean>(true);

  // Period stock data fetched via RPC (bypasses RLS on inventory_transactions)
  const [periodStockData, setPeriodStockData] = useState<any[]>([]);
  const [isLoadingPeriodData, setIsLoadingPeriodData] = useState(false);

  // UI state for period close operations
  const [showChecklistModal, setShowChecklistModal] = useState(false);
  const [showReopenModal, setShowReopenModal] = useState(false);
  const [reopenReason, setReopenReason] = useState('');
  const [selectedPeriodToReopen, setSelectedPeriodToReopen] = useState<any>(null);

  // Simulated DB states for period close
  const [closedPeriods, setClosedPeriods] = useState<any[]>(() => {
    if (typeof window !== 'undefined') {
      const saved = localStorage.getItem('mv_closed_periods');
      if (saved) return JSON.parse(saved);
    }
    // Seed default closed periods (simulated)
    return [
      { period_type: 'MONTH', period_end: '2026-05-31', version: 1, status: 'CLOSED', closed_by: 'ceo@maisonvie.vn', closed_at: '2026-05-31T23:00:00Z', reopened_by: null, reopen_reason: null }
    ];
  });

  const [snapshots, setSnapshots] = useState<any[]>(() => {
    if (typeof window !== 'undefined') {
      const saved = localStorage.getItem('mv_inventory_snapshots');
      if (saved) return JSON.parse(saved);
    }
    return [];
  });

  useEffect(() => {
    localStorage.setItem('mv_closed_periods', JSON.stringify(closedPeriods));
  }, [closedPeriods]);

  useEffect(() => {
    localStorage.setItem('mv_inventory_snapshots', JSON.stringify(snapshots));
  }, [snapshots]);

  // Read live status from DB if Supabase is configured
  const fetchClosedPeriods = async () => {
    if (!isSupabaseConfigured()) return;
    try {
      const { data: periods, error } = await supabase
        .from('inventory_period_close')
        .select('*')
        .order('period_end', { ascending: false });
      if (!error && periods) {
        setClosedPeriods(periods);
      }
      
      const { data: snaps, error: snapError } = await supabase
        .from('inventory_snapshots')
        .select('*');
      if (!snapError && snaps) {
        setSnapshots(snaps);
      }
    } catch (e) {
      console.error(e);
    }
  };

  useEffect(() => {
    fetchClosedPeriods();
  }, []);

  // Fetch period stock data from Supabase RPC whenever period changes
  const fetchPeriodStockData = async (startDate: string, endDate: string) => {
    if (!isSupabaseConfigured()) return;
    setIsLoadingPeriodData(true);
    try {
      const { data, error } = await supabase.rpc('get_period_stock_summary', {
        p_start_date: startDate,
        p_end_date: endDate
      });
      if (error) {
        console.error('get_period_stock_summary error:', error);
      } else if (data) {
        setPeriodStockData(data);
      }
    } catch (e) {
      console.error('fetchPeriodStockData failed:', e);
    } finally {
      setIsLoadingPeriodData(false);
    }
  };



  // Determine if financial info (price, cost, value) is visible to current user
  // (Only Owner/CFO - 'admin' role in this system has financial privileges)
  const isFinancialVisible = useMemo(() => {
    return userRole === 'admin';
  }, [userRole]);

  // Calculate the dates for the active period
  const periodRange = useMemo(() => {
    const d = new Date(selectedDate);
    let start = new Date(selectedDate);
    let end = new Date(selectedDate);

    if (periodType === 'DAY') {
      start = new Date(selectedDate);
      end = new Date(selectedDate);
    } else if (periodType === 'WEEK') {
      const day = d.getDay();
      const diff = d.getDate() - day + (day === 0 ? -6 : 1); // adjust when day is sunday
      start = new Date(d.setDate(diff));
      end = new Date(d.setDate(diff + 6));
    } else if (periodType === 'MONTH') {
      start = new Date(d.getFullYear(), d.getMonth(), 1);
      end = new Date(d.getFullYear(), d.getMonth() + 1, 0);
    } else if (periodType === 'QUARTER') {
      const quarter = Math.floor(d.getMonth() / 3);
      start = new Date(d.getFullYear(), quarter * 3, 1);
      end = new Date(d.getFullYear(), (quarter + 1) * 3, 0);
    } else if (periodType === 'YEAR') {
      start = new Date(d.getFullYear(), 0, 1);
      end = new Date(d.getFullYear(), 11, 31);
    }

    return {
      startStr: start.toISOString().split('T')[0],
      endStr: end.toISOString().split('T')[0]
    };
  }, [selectedDate, periodType]);

  // Fetch period stock data whenever the period range changes
  useEffect(() => {
    if (periodRange.startStr && periodRange.endStr) {
      fetchPeriodStockData(periodRange.startStr, periodRange.endStr);
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [periodRange.startStr, periodRange.endStr]);

  // Find if current period range is locked
  const currentPeriodStatus = useMemo(() => {
    const match = closedPeriods.find(
      p => p.period_type === periodType && p.period_end === periodRange.endStr && p.status === 'CLOSED'
    );
    return match ? 'LOCKED' : 'OPEN';
  }, [closedPeriods, periodType, periodRange]);

  // Period checklist checks
  const checklist = useMemo(() => {
    const start = new Date(periodRange.startStr);
    const end = new Date(periodRange.endStr);

    // 1. Unmapped POS items
    const unmappedSales = salesData.filter(s => {
      const d = new Date(s.import_date || selectedDate);
      return d >= start && d <= end && s.mapping_status === 'UNMAPPED';
    });

    // 2. Pending GRN (receipts)
    const pendingGRNs = goodsReceipts.filter(g => {
      const d = new Date(g.date || g.created_at);
      return d >= start && d <= end && g.status === 'pending';
    });

    // 3. Pending Waste Logs
    const pendingWastes = wasteLogs.filter(w => {
      const d = new Date(w.createdAt);
      return d >= start && d <= end && w.status === 'pending_approval';
    });

    return {
      hasUnmappedSales: unmappedSales.length > 0,
      unmappedCount: unmappedSales.length,
      hasPendingGRNs: pendingGRNs.length > 0,
      pendingGRNCount: pendingGRNs.length,
      hasPendingWastes: pendingWastes.length > 0,
      pendingWasteCount: pendingWastes.length,
      isReady: unmappedSales.length === 0 && pendingGRNs.length === 0 && pendingWastes.length === 0
    };
  }, [periodRange, salesData, goodsReceipts, wasteLogs, selectedDate]);

  // Calculate stock table data: from RPC data (bypasses RLS) or snapshots
  const closedInventoryData = useMemo(() => {
    // If period is closed and snapshots exist, read from snapshot
    const closedRecord = closedPeriods.find(
      p => p.period_type === periodType && p.period_end === periodRange.endStr && p.status === 'CLOSED'
    );
    
    if (closedRecord && snapshots.length > 0) {
      const periodSnaps = snapshots.filter(
        s => s.period_type === periodType && s.period_end === periodRange.endStr
      );
      if (periodSnaps.length > 0) {
        return periodSnaps.map(s => {
          const ing = ingredients.find(i => i.id === s.ingredient_id) || {};
          return {
            id: s.ingredient_id,
            code: ing.code || 'UNKNOWN',
            nom_fr: ing.fr_name || '',
            ten_vi: ing.vi_name || '',
            category: ing.category || 'Khác',
            unit: ing.unit || 'kg',
            wac: s.wac_at_close,
            openingQty: s.opening_qty,
            inQty: s.in_qty,
            outQty: s.out_qty,
            closingQty: s.closing_qty,
            closingValue: s.closing_value,
            variance: 0
          };
        });
      }
    }

    // Use RPC data (SECURITY DEFINER → bypasses RLS on inventory_transactions)
    if (periodStockData.length > 0) {
      return periodStockData.map(row => ({
        id: row.ingredient_id,
        code: row.ingredient_code || 'UNKNOWN',
        nom_fr: row.nom_fr || '',
        ten_vi: row.ten_vi || '',
        category: row.category || 'Khác',
        unit: row.stock_uom || 'kg',
        wac: parseFloat(row.wac_price) || 0,
        openingQty: parseFloat(row.opening_qty) || 0,
        inQty: parseFloat(row.in_qty) || 0,
        outQty: parseFloat(row.out_qty) || 0,
        closingQty: parseFloat(row.closing_qty) || 0,
        closingValue: parseFloat(row.closing_value) || 0,
        variance: parseFloat(row.adj_qty) || 0
      }));
    }

    // Fallback: empty (waiting for RPC data)
    return [];
  }, [periodType, periodRange, ingredients, periodStockData, closedPeriods, snapshots]);

  // Filtered Closed Inventory table rows
  const filteredRows = useMemo(() => {
    return closedInventoryData
      .filter(row => {
        const matchesSearch = row.code.toLowerCase().includes(searchQuery.toLowerCase()) || 
                              row.ten_vi.toLowerCase().includes(searchQuery.toLowerCase()) ||
                              row.nom_fr.toLowerCase().includes(searchQuery.toLowerCase());
        const matchesCategory = categoryFilter === 'ALL' || row.category === categoryFilter;
        const matchesStock = !showOnlyWithStock || 
                             (row.openingQty !== 0 || row.inQty !== 0 || row.outQty !== 0 || row.closingQty !== 0);
        return matchesSearch && matchesCategory && matchesStock;
      })
      .sort((a, b) => b.closingQty - a.closingQty);
  }, [closedInventoryData, searchQuery, categoryFilter, showOnlyWithStock]);

  // Aggregated asset summary
  const totals = useMemo(() => {
    let totalValue = 0;
    let totalOpeningValue = 0;
    let totalInValue = 0;
    let totalOutValue = 0;

    closedInventoryData.forEach(row => {
      totalValue += row.closingValue;
      totalOpeningValue += row.openingQty * row.wac;
      totalInValue += row.inQty * row.wac;
      totalOutValue += row.outQty * row.wac;
    });

    return {
      totalOpeningValue,
      totalInValue,
      totalOutValue,
      totalValue
    };
  }, [closedInventoryData]);

  // Categories list for filter
  const categoriesList = useMemo(() => {
    const set = new Set(ingredients.map(i => i.category || 'Khác'));
    return Array.from(set);
  }, [ingredients]);

  // Action: Close the period (Locks and saves snapshots)
  const handleClosePeriod = async () => {
    if (!checklist.isReady) {
      alert('Không thể đóng kỳ. Vui lòng hoàn thành toàn bộ các đầu mục trong checklist.');
      return;
    }

    const confirm = window.confirm(`Bạn có chắc chắn muốn chốt kỳ ${periodType} kết thúc ngày ${periodRange.endStr}? Hành động này sẽ khóa toàn bộ dữ liệu kỳ cũ.`);
    if (!confirm) return;

    const newPeriodClose = {
      period_type: periodType,
      period_end: periodRange.endStr,
      version: 1,
      status: 'CLOSED',
      closed_by: currentUser?.email || 'admin@maisonvie.vn',
      closed_at: new Date().toISOString(),
      reopened_by: null,
      reopen_reason: null
    };

    // Calculate snaps to save
    const periodSnaps = closedInventoryData.map(row => ({
      period_type: periodType,
      period_end: periodRange.endStr,
      ingredient_id: row.id,
      opening_qty: row.openingQty,
      in_qty: row.inQty,
      out_qty: row.outQty,
      closing_qty: row.closingQty,
      wac_at_close: row.wac,
      closing_value: row.closingValue,
      locked: true,
      created_at: new Date().toISOString()
    }));

    if (isSupabaseConfigured()) {
      try {
        const { error } = await supabase.from('inventory_period_close').insert(newPeriodClose);
        if (error) throw error;
        
        const { error: snapError } = await supabase.from('inventory_snapshots').insert(periodSnaps);
        if (snapError) throw snapError;
        
        await fetchClosedPeriods();
      } catch (err: any) {
        alert(`Lỗi Supabase: ${err.message}`);
      }
    } else {
      // Local Storage simulation
      setClosedPeriods(prev => [newPeriodClose, ...prev]);
      setSnapshots(prev => [...periodSnaps, ...prev]);
      alert(`Đã đóng kỳ ${periodType} kết thúc ngày ${periodRange.endStr} thành công! (Simulation Mode)`);
    }

    setShowChecklistModal(false);
  };

  // Action: Reopen a locked period
  const handleReopenPeriod = async () => {
    if (!reopenReason.trim()) {
      alert('Vui lòng nhập lý do mở lại kỳ.');
      return;
    }

    const confirm = window.confirm(`CẢNH BÁO: Mở lại kỳ đã khóa có thể làm sai lệch dữ liệu kế toán. Bạn có chắc chắn muốn mở lại kỳ này?`);
    if (!confirm) return;

    // Find current version
    const matches = closedPeriods.filter(
      p => p.period_type === selectedPeriodToReopen.period_type && p.period_end === selectedPeriodToReopen.period_end
    );
    const maxVersion = matches.reduce((max, p) => Math.max(max, p.version), 0);

    // Create a new record with status OPEN (versioned reopen)
    const newVersionClose = {
      period_type: selectedPeriodToReopen.period_type,
      period_end: selectedPeriodToReopen.period_end,
      version: maxVersion + 1,
      status: 'OPEN',
      closed_by: selectedPeriodToReopen.closed_by,
      closed_at: selectedPeriodToReopen.closed_at,
      reopened_by: currentUser?.email || 'admin@maisonvie.vn',
      reopen_reason: reopenReason,
      created_at: new Date().toISOString()
    };

    if (isSupabaseConfigured()) {
      try {
        const { error } = await supabase.from('inventory_period_close').insert(newVersionClose);
        if (error) throw error;
        
        // Remove snapshots for this period to allow live edits/calculations again
        const { error: deleteError } = await supabase
          .from('inventory_snapshots')
          .delete()
          .eq('period_type', selectedPeriodToReopen.period_type)
          .eq('period_end', selectedPeriodToReopen.period_end);
        if (deleteError) throw deleteError;

        await fetchClosedPeriods();
      } catch (err: any) {
        alert(`Lỗi Supabase: ${err.message}`);
      }
    } else {
      // Local Storage simulation
      // Mark old version as OPEN or insert new version
      setClosedPeriods(prev => [newVersionClose, ...prev.map(p => {
        if (p.period_type === selectedPeriodToReopen.period_type && p.period_end === selectedPeriodToReopen.period_end && p.status === 'CLOSED') {
          return { ...p, status: 'OPEN' }; // open old ones
        }
        return p;
      })]);
      // Remove snapshots of this period in simulation
      setSnapshots(prev => prev.filter(
        s => !(s.period_type === selectedPeriodToReopen.period_type && s.period_end === selectedPeriodToReopen.period_end)
      ));
      alert(`Đã mở lại kỳ ${selectedPeriodToReopen.period_type} (${selectedPeriodToReopen.period_end}) thành công! (Simulation Mode)`);
    }

    setShowReopenModal(false);
    setReopenReason('');
    setSelectedPeriodToReopen(null);
  };

  // Export Closed Inventory to Excel
  const exportToExcel = () => {
    const headers = [
      'Mã NVL', 'Tên tiếng Việt', 'Tên tiếng Pháp', 'ĐVT', 'Tồn đầu kỳ', 'Nhập trong kỳ', 'Xuất trong kỳ', 'Tồn cuối kỳ', 'Hao hụt/Điều chỉnh'
    ];
    if (isFinancialVisible) {
      headers.push('Giá vốn WAC (VND)', 'Trị giá tồn cuối (VND)');
    }

    const data = filteredRows.map(row => {
      const baseRow: any = {
        'Mã NVL': row.code,
        'Tên tiếng Việt': row.ten_vi,
        'Tên tiếng Pháp': row.nom_fr,
        'ĐVT': row.unit,
        'Tồn đầu kỳ': row.openingQty,
        'Nhập trong kỳ': row.inQty,
        'Xuất trong kỳ': row.outQty,
        'Tồn cuối kỳ': row.closingQty,
        'Hao hụt/Điều chỉnh': row.variance
      };
      if (isFinancialVisible) {
        baseRow['Giá vốn WAC (VND)'] = row.wac;
        baseRow['Trị giá tồn cuối (VND)'] = row.closingValue;
      }
      return baseRow;
    });

    const worksheet = XLSX.utils.json_to_sheet(data);
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, 'Closed Inventory');
    XLSX.writeFile(workbook, `MaisonVie_ClosedInventory_${periodType}_${periodRange.endStr}.xlsx`);
  };

  return (
    <div className="flex flex-col gap-6 font-sans text-[#FBF8F4] bg-[#102B2A] p-6 rounded-lg border border-[#C9A581]">
      {/* Title Header */}
      <div className="flex flex-col lg:flex-row justify-between items-start lg:items-center gap-4 border-b border-[#C9A581] pb-4">
        <div>
          <h2 className="text-2xl font-serif text-[#A8884E] font-bold tracking-wide">Báo Cáo Tồn Kho Đóng Kỳ (Closed Inventory)</h2>
          <p className="text-xs text-gray-300 opacity-90 mt-1">
            Báo cáo tồn kho đã được chốt và khóa sổ theo chu kỳ. Trực quan hóa giá trị tài sản kho theo WAC.
          </p>
        </div>
        <div className="flex items-center gap-3">
          {currentPeriodStatus === 'LOCKED' ? (
            <div className="flex items-center gap-2 bg-[#3A1B17] border border-[#D06A5C] text-[#D06A5C] px-3.5 py-2 rounded text-xs font-mono font-bold uppercase">
              <Lock size={15} />
              <span>Đã khóa sổ kỳ</span>
            </div>
          ) : (
            <div className="flex items-center gap-2 bg-[#0C201F] border border-[#62A57C] text-[#62A57C] px-3.5 py-2 rounded text-xs font-mono font-bold uppercase">
              <Unlock size={15} />
              <span>Đang mở kỳ</span>
            </div>
          )}
          
          {userRole === 'admin' && (
            <button
              onClick={() => {
                if (currentPeriodStatus === 'LOCKED') {
                  setSelectedPeriodToReopen(
                    closedPeriods.find(
                      p => p.period_type === periodType && p.period_end === periodRange.endStr && p.status === 'CLOSED'
                    )
                  );
                  setShowReopenModal(true);
                } else {
                  setShowChecklistModal(true);
                }
              }}
              className={`flex items-center gap-2 px-4 py-2 rounded text-xs font-bold font-sans active:scale-95 transition-all shadow-md cursor-pointer ${
                currentPeriodStatus === 'LOCKED'
                  ? 'bg-amber-600 hover:bg-amber-700 text-[#FBF8F4]'
                  : 'bg-[#A8884E] hover:bg-[#8C6F3C] text-[#042726]'
              }`}
            >
              {currentPeriodStatus === 'LOCKED' ? (
                <>
                  <Unlock size={14} />
                  <span>Mở lại kỳ đóng</span>
                </>
              ) : (
                <>
                  <Lock size={14} />
                  <span>Đóng kỳ chốt sổ</span>
                </>
              )}
            </button>
          )}
        </div>
      </div>

      {/* Financial Asset Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="bg-[#042726] p-4 rounded border border-[#C9A581]/60">
          <span className="text-[10px] text-gray-300 uppercase tracking-widest font-semibold block">Tồn đầu kỳ</span>
          {isFinancialVisible ? (
            <span className="text-xl font-serif text-[#C2A35A] font-bold mt-1.5 block">
              {Math.round(totals.totalOpeningValue).toLocaleString()}đ
            </span>
          ) : (
            <div className="flex items-center gap-1.5 text-gray-400 text-xs mt-2.5 font-medium">
              <Lock size={13} className="text-[#A8884E]" />
              <span>Đã khóa (Cấp 1)</span>
            </div>
          )}
        </div>
        <div className="bg-[#042726] p-4 rounded border border-[#C9A581]/60">
          <span className="text-[10px] text-gray-300 uppercase tracking-widest font-semibold block">Tổng nhập kỳ</span>
          {isFinancialVisible ? (
            <span className="text-xl font-serif text-[#C2A35A] font-bold mt-1.5 block">
              {Math.round(totals.totalInValue).toLocaleString()}đ
            </span>
          ) : (
            <div className="flex items-center gap-1.5 text-gray-400 text-xs mt-2.5 font-medium">
              <Lock size={13} className="text-[#A8884E]" />
              <span>Đã khóa (Cấp 1)</span>
            </div>
          )}
        </div>
        <div className="bg-[#042726] p-4 rounded border border-[#C9A581]/60">
          <span className="text-[10px] text-gray-300 uppercase tracking-widest font-semibold block">Tổng xuất kỳ</span>
          {isFinancialVisible ? (
            <span className="text-xl font-serif text-[#C2A35A] font-bold mt-1.5 block">
              {Math.round(totals.totalOutValue).toLocaleString()}đ
            </span>
          ) : (
            <div className="flex items-center gap-1.5 text-gray-400 text-xs mt-2.5 font-medium">
              <Lock size={13} className="text-[#A8884E]" />
              <span>Đã khóa (Cấp 1)</span>
            </div>
          )}
        </div>
        <div className="bg-[#042726] p-4 rounded border border-[#C9A581]/60 relative overflow-hidden">
          <span className="text-[10px] text-gray-300 uppercase tracking-widest font-semibold block">Giá trị tài sản cuối kỳ</span>
          {isFinancialVisible ? (
            <span className="text-xl font-serif text-emerald-400 font-bold mt-1.5 block">
              {Math.round(totals.totalValue).toLocaleString()}đ
            </span>
          ) : (
            <div className="flex items-center gap-1.5 text-gray-400 text-xs mt-2.5 font-medium">
              <Lock size={13} className="text-[#A8884E]" />
              <span>Đã khóa (Cấp 1)</span>
            </div>
          )}
          <div className="absolute right-2.5 bottom-2 opacity-5">
            <Calendar size={70} />
          </div>
        </div>
      </div>

      {/* Query Filters */}
      <div className="bg-[#042726] p-4 rounded border border-[#C9A581]/40 flex flex-wrap gap-4 items-center justify-between">
        <div className="flex flex-wrap gap-4 items-center">
          {/* Period selector */}
          <div className="flex flex-col gap-1">
            <span className="text-[10px] uppercase text-gray-300 tracking-wider font-semibold">Chu kỳ</span>
            <select
              value={periodType}
              onChange={(e) => setPeriodType(e.target.value as any)}
              className="bg-[#102B2A] border border-[#C9A581] text-xs rounded p-2 text-[#FBF8F4] focus:outline-none focus:border-[#A8884E] font-mono cursor-pointer"
            >
              <option value="DAY">Kỳ Ngày</option>
              <option value="WEEK">Kỳ Tuần</option>
              <option value="MONTH">Kỳ Tháng</option>
              <option value="QUARTER">Kỳ Quý</option>
              <option value="YEAR">Kỳ Năm</option>
            </select>
          </div>

          {/* Date Selector */}
          <div className="flex flex-col gap-1">
            <span className="text-[10px] uppercase text-gray-300 tracking-wider font-semibold">Ngày chốt kỳ</span>
            <input
              type="date"
              value={selectedDate}
              onChange={(e) => setSelectedDate(e.target.value)}
              className="bg-[#102B2A] border border-[#C9A581] text-xs rounded p-2 text-[#FBF8F4] focus:outline-none focus:border-[#A8884E] font-mono cursor-pointer"
            />
          </div>

          {/* Location Selector */}
          <div className="flex flex-col gap-1">
            <span className="text-[10px] uppercase text-gray-300 tracking-wider font-semibold">Địa điểm</span>
            <select
              value={selectedLocation}
              onChange={(e) => setSelectedLocation(e.target.value)}
              className="bg-[#102B2A] border border-[#C9A581] text-xs rounded p-2 text-[#FBF8F4] focus:outline-none focus:border-[#A8884E] cursor-pointer"
            >
              <option value="ALL">Tất cả địa điểm</option>
              {locations.map(loc => (
                <option key={loc.id} value={loc.id}>{loc.name}</option>
              ))}
            </select>
          </div>

          {/* Category Filter */}
          <div className="flex flex-col gap-1">
            <span className="text-[10px] uppercase text-gray-300 tracking-wider font-semibold">Nhóm hàng</span>
            <select
              value={categoryFilter}
              onChange={(e) => setCategoryFilter(e.target.value)}
              className="bg-[#102B2A] border border-[#C9A581] text-xs rounded p-2 text-[#FBF8F4] focus:outline-none focus:border-[#A8884E] cursor-pointer"
            >
              <option value="ALL">Tất cả nhóm</option>
              {categoriesList.map(cat => (
                <option key={cat} value={cat}>{cat}</option>
              ))}
            </select>
          </div>

          {/* Search bar */}
          <div className="flex flex-col gap-1">
            <span className="text-[10px] uppercase text-gray-300 tracking-wider font-semibold">Tìm kiếm nhanh</span>
            <div className="relative">
              <Search className="absolute left-2.5 top-2.5 text-gray-400" size={14} />
              <input
                type="text"
                placeholder="Tên hoặc mã..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="bg-[#102B2A] border border-[#C9A581] pl-8 pr-2.5 py-2 text-xs rounded text-[#FBF8F4] placeholder-gray-400 focus:outline-none focus:border-[#A8884E] w-48 font-sans"
              />
            </div>
          </div>
        </div>

        <div className="flex items-center gap-2 mt-4 md:mt-0">
          {/* Show only with stock toggle */}
          <button
            onClick={() => setShowOnlyWithStock(prev => !prev)}
            className={`flex items-center gap-1.5 px-3.5 py-2 rounded text-xs font-bold font-sans active:scale-95 transition-all cursor-pointer shadow border ${
              showOnlyWithStock
                ? 'bg-emerald-900/50 border-emerald-500/60 text-emerald-400'
                : 'bg-[#0C201F] border-[#C9A581]/30 text-gray-400'
            }`}
            title={showOnlyWithStock ? 'Đang lọc: chỉ hiển thị hàng có tồn' : 'Hiển thị tất cả hàng'}
          >
            <Filter size={14} />
            <span>{showOnlyWithStock ? `Có tồn (${filteredRows.length})` : `Tất cả (${filteredRows.length})`}</span>
          </button>

          <button
            onClick={exportToExcel}
            className="flex items-center gap-1.5 bg-[#0C201F] hover:bg-[#0c201f]/80 text-[#62A57C] border border-[#62A57C]/40 px-3.5 py-2 rounded text-xs font-bold font-sans active:scale-95 transition-all cursor-pointer shadow"
          >
            <Download size={14} />
            <span>Xuất Excel</span>
          </button>
        </div>
      </div>

      {/* Closed Period Data Grid Table */}
      <div className="overflow-x-auto bg-[#042726] rounded border border-[#C9A581]/40">
        <table className="w-full text-left text-xs border-collapse">
          <thead>
            <tr className="bg-[#102B2A] border-b border-[#C9A581]/60 text-gray-300 font-mono font-medium">
              <th className="p-3.5">Mã NVL</th>
              <th className="p-3.5">Tên nguyên liệu</th>
              <th className="p-3.5 text-center">ĐVT</th>
              <th className="p-3.5 text-right">Tồn đầu kỳ</th>
              <th className="p-3.5 text-right">Nhập kỳ</th>
              <th className="p-3.5 text-right">Xuất kỳ</th>
              <th className="p-3.5 text-right text-emerald-400 font-bold">Tồn cuối kỳ</th>
              <th className="p-3.5 text-right text-amber-400">Điều chỉnh</th>
              {isFinancialVisible && (
                <>
                  <th className="p-3.5 text-right">Giá vốn WAC</th>
                  <th className="p-3.5 text-right font-bold text-emerald-400">Trị giá cuối kỳ</th>
                </>
              )}
            </tr>
          </thead>
          <tbody>
            {filteredRows.map((row, idx) => (
              <tr key={idx} className="border-b border-[#C9A581]/30 hover:bg-[#102B2A]/40 transition-colors">
                <td className="p-3 font-mono text-accent-gold font-bold">{row.code}</td>
                <td className="p-3 font-sans">
                  <div className="flex flex-col">
                    <span className="font-semibold text-gray-100 text-xs">{row.ten_vi}</span>
                    <span className="text-[10px] text-gray-400 italic font-medium">{row.nom_fr}</span>
                  </div>
                </td>
                <td className="p-3 text-center font-semibold text-gray-300 font-sans">{row.unit}</td>
                <td className="p-3 text-right font-mono font-medium text-gray-200">{row.openingQty.toFixed(2)}</td>
                <td className="p-3 text-right font-mono font-medium text-emerald-300">+{row.inQty.toFixed(2)}</td>
                <td className="p-3 text-right font-mono font-medium text-rose-300">-{row.outQty.toFixed(2)}</td>
                <td className="p-3 text-right font-mono font-bold text-emerald-400">{row.closingQty.toFixed(2)}</td>
                <td className="p-3 text-right font-mono font-medium text-amber-400">
                  {row.variance > 0 ? `+${row.variance.toFixed(2)}` : row.variance === 0 ? '-' : row.variance.toFixed(2)}
                </td>
                {isFinancialVisible && (
                  <>
                    <td className="p-3 text-right font-mono font-medium text-[#C2A35A]">{Math.round(row.wac).toLocaleString()}đ</td>
                    <td className="p-3 text-right font-mono font-bold text-emerald-400">{Math.round(row.closingValue).toLocaleString()}đ</td>
                  </>
                )}
              </tr>
            ))}
            {isLoadingPeriodData && (
              <tr>
                <td colSpan={isFinancialVisible ? 10 : 8} className="p-8 text-center text-gray-400 italic font-medium">
                  <span className="animate-pulse">⏳ Đang tải dữ liệu tồn kho kỳ...</span>
                </td>
              </tr>
            )}
            {!isLoadingPeriodData && filteredRows.length === 0 && (
              <tr>
                <td colSpan={isFinancialVisible ? 10 : 8} className="p-8 text-center text-gray-500 italic font-medium">
                  Không tìm thấy nguyên liệu nào trong kỳ này.
                </td>
              </tr>
            )}

          </tbody>
        </table>
      </div>

      {/* Versioned Reopen Audit History Logs */}
      <div className="bg-[#042726] p-5 rounded border border-[#C9A581]/40 flex flex-col gap-3">
        <h4 className="text-sm font-bold uppercase text-[#A8884E] flex items-center gap-2 border-b border-[#C9A581]/30 pb-2">
          <History size={16} />
          <span>Lịch sử chốt sổ & Mở lại (Versioned Audit Logs)</span>
        </h4>
        <div className="flex flex-col gap-3 max-h-48 overflow-y-auto pr-1">
          {closedPeriods
            .filter(p => p.period_type === periodType && p.period_end === periodRange.endStr)
            .map((p, idx) => (
              <div key={idx} className="bg-[#102B2A]/60 p-3.5 rounded border border-[#C9A581]/30 text-xs flex flex-col gap-2">
                <div className="flex justify-between items-center">
                  <div className="flex items-center gap-2">
                    <span className="bg-[#0C201F] text-[#62A57C] border border-[#62A57C]/40 px-2 py-0.5 rounded font-mono font-bold text-[10px]">
                      Phiên bản v{p.version}
                    </span>
                    <span className={`px-2 py-0.5 rounded font-mono font-bold text-[10px] ${
                      p.status === 'CLOSED' ? 'bg-[#3A1B17] text-[#D06A5C] border border-[#D06A5C]/40' : 'bg-[#3A2C13] text-[#D8AA57] border border-[#D8AA57]/40'
                    }`}>
                      {p.status === 'CLOSED' ? 'ĐÃ KHÓA' : 'MỞ LẠI'}
                    </span>
                  </div>
                  <span className="text-[10px] text-gray-400 font-mono">
                    {new Date(p.created_at || p.closed_at).toLocaleString('vi-VN')}
                  </span>
                </div>
                <div className="grid grid-cols-2 gap-2 text-[11px] text-gray-300">
                  <div>
                    <span className="text-gray-400 font-medium">Người đóng sổ: </span>
                    <span className="font-semibold text-gray-200">{p.closed_by}</span>
                  </div>
                  {p.reopened_by && (
                    <div>
                      <span className="text-gray-400 font-medium">Người mở lại: </span>
                      <span className="font-semibold text-[#D8AA57]">{p.reopened_by}</span>
                    </div>
                  )}
                </div>
                {p.reopen_reason && (
                  <div className="bg-[#3A2C13]/30 border border-[#D8AA57]/20 p-2 rounded text-[11px] text-[#D8AA57] italic">
                    <strong className="not-italic font-bold">Lý do mở lại: </strong>
                    {p.reopen_reason}
                  </div>
                )}
              </div>
            ))}
          {closedPeriods.filter(p => p.period_type === periodType && p.period_end === periodRange.endStr).length === 0 && (
            <div className="text-gray-500 italic text-center py-4 font-normal">
              Chưa có phiên chốt sổ nào được ghi nhận cho kỳ này.
            </div>
          )}
        </div>
      </div>

      {/* Modal: Period Closing Checklist */}
      {showChecklistModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-[#042726]/80 backdrop-blur-sm p-4">
          <div className="bg-[#102B2A] border border-[#C9A581] rounded-lg shadow-xl w-full max-w-lg overflow-hidden flex flex-col">
            <div className="bg-[#042726] px-5 py-4 border-b border-[#C9A581] flex justify-between items-center">
              <h3 className="text-base font-bold text-[#A8884E] font-serif uppercase tracking-wide">Checklist chốt sổ kỳ {periodType}</h3>
              <button 
                onClick={() => setShowChecklistModal(false)}
                className="text-gray-400 hover:text-[#FBF8F4] font-bold text-xs"
              >
                Đóng
              </button>
            </div>
            <div className="p-6 overflow-y-auto flex flex-col gap-4 text-xs">
              <div className="bg-[#3A2C13]/20 border border-[#D8AA57]/30 p-3.5 rounded text-gray-300 leading-relaxed">
                <span className="font-bold text-[#D8AA57] block mb-1">QUY ĐỊNH CHỐT KỲ:</span>
                Vui lòng đảm bảo các điều kiện kế toán và đối soát dữ liệu sau đây được thỏa mãn 100% trước khi thực hiện khóa sổ kỳ.
              </div>

              {/* Checklist items */}
              <div className="flex flex-col gap-3">
                {/* 1. Mapped POS */}
                <div className="flex items-start gap-3 p-3 rounded border bg-[#042726]/40 border-[#C9A581]/30">
                  {checklist.hasUnmappedSales ? (
                    <AlertTriangle className="text-[#D06A5C] shrink-0 mt-0.5" size={16} />
                  ) : (
                    <CheckCircle2 className="text-[#62A57C] shrink-0 mt-0.5" size={16} />
                  )}
                  <div className="flex flex-col">
                    <span className="font-bold text-gray-200">Không có hóa đơn POS chưa ánh xạ</span>
                    <span className="text-gray-400 mt-1">
                      {checklist.hasUnmappedSales 
                        ? `Còn phát hiện ${checklist.unmappedCount} món bán chưa ánh xạ công thức định lượng (đang treo ở worklist).`
                        : 'Hoàn thành: Toàn bộ món bán đã được ánh xạ recipe/BOM.'}
                    </span>
                  </div>
                </div>

                {/* 2. Pending GRN */}
                <div className="flex items-start gap-3 p-3 rounded border bg-[#042726]/40 border-[#C9A581]/30">
                  {checklist.hasPendingGRNs ? (
                    <AlertTriangle className="text-[#D06A5C] shrink-0 mt-0.5" size={16} />
                  ) : (
                    <CheckCircle2 className="text-[#62A57C] shrink-0 mt-0.5" size={16} />
                  )}
                  <div className="flex flex-col">
                    <span className="font-bold text-gray-200">Không có chứng từ GRN (nhập kho) chưa duyệt</span>
                    <span className="text-gray-400 mt-1">
                      {checklist.hasPendingGRNs
                        ? `Còn phát hiện ${checklist.pendingGRNCount} phiếu nhận hàng GRN chưa được kế toán/admin duyệt.`
                        : 'Hoàn thành: Toàn bộ GRN đã được duyệt và ghi nhận.'}
                    </span>
                  </div>
                </div>

                {/* 3. Pending Waste Logs */}
                <div className="flex items-start gap-3 p-3 rounded border bg-[#042726]/40 border-[#C9A581]/30">
                  {checklist.hasPendingWastes ? (
                    <AlertTriangle className="text-[#D06A5C] shrink-0 mt-0.5" size={16} />
                  ) : (
                    <CheckCircle2 className="text-[#62A57C] shrink-0 mt-0.5" size={16} />
                  )}
                  <div className="flex flex-col">
                    <span className="font-bold text-gray-200">Không có nhật ký hủy hỏng (Waste Log) chưa duyệt</span>
                    <span className="text-gray-400 mt-1">
                      {checklist.hasPendingWastes
                        ? `Còn phát hiện ${checklist.pendingWasteCount} phiếu hủy hỏng nguyên liệu chưa được bếp trưởng/admin duyệt.`
                        : 'Hoàn thành: Toàn bộ Waste Logs đã xử lý duyệt xong.'}
                    </span>
                  </div>
                </div>
              </div>

              {/* Action buttons */}
              <div className="flex justify-end gap-3 border-t border-[#C9A581]/30 pt-4 mt-2">
                <button
                  onClick={() => setShowChecklistModal(false)}
                  className="border border-[#C9A581]/60 hover:bg-[#042726] text-gray-300 px-4 py-2 rounded font-semibold transition-colors"
                >
                  Hủy bỏ
                </button>
                <button
                  onClick={handleClosePeriod}
                  disabled={!checklist.isReady}
                  className="bg-[#A8884E] hover:bg-[#8C6F3C] text-[#042726] font-bold px-5 py-2 rounded shadow disabled:opacity-50 disabled:cursor-not-allowed transition-all"
                >
                  Khóa sổ & Chốt kỳ
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Modal: Reopen Closed Period */}
      {showReopenModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-[#042726]/80 backdrop-blur-sm p-4">
          <div className="bg-[#102B2A] border border-[#C9A581] rounded-lg shadow-xl w-full max-w-md overflow-hidden flex flex-col font-sans">
            <div className="bg-[#042726] px-5 py-4 border-b border-[#C9A581] flex justify-between items-center">
              <h3 className="text-base font-bold text-[#A8884E] uppercase">Mở lại kỳ đóng sổ</h3>
              <button 
                onClick={() => {
                  setShowReopenModal(false);
                  setReopenReason('');
                  setSelectedPeriodToReopen(null);
                }}
                className="text-gray-400 hover:text-white font-bold text-xs"
              >
                Đóng
              </button>
            </div>
            <div className="p-6 flex flex-col gap-4 text-xs">
              <div className="bg-[#3A1B17]/20 border border-[#D06A5C]/30 p-3.5 rounded text-gray-300 leading-relaxed">
                <span className="font-bold text-[#D06A5C] block mb-1">CẢNH BÁO KẾ TOÁN:</span>
                Việc mở lại kỳ chốt sổ sẽ giải phóng khóa sổ, cho phép nhân viên sửa đổi lịch sử. 
                Hành động này **bắt buộc** phải nhập lý do giải trình rõ ràng và được lưu vết audit vĩnh viễn.
              </div>

              <div className="flex flex-col gap-2">
                <span className="font-bold text-gray-200">Lý do mở lại kỳ:</span>
                <textarea
                  placeholder="Nhập lý do cụ thể... (ví dụ: Kế toán điều chỉnh hóa đơn nhập hàng bị sai đơn giá)"
                  value={reopenReason}
                  onChange={(e) => setReopenReason(e.target.value)}
                  rows={4}
                  className="bg-[#042726] border border-[#C9A581] rounded p-2.5 text-[#FBF8F4] placeholder-gray-500 focus:outline-none focus:border-[#A8884E] leading-relaxed resize-none"
                />
              </div>

              <div className="flex justify-end gap-3 border-t border-[#C9A581]/30 pt-4 mt-2">
                <button
                  onClick={() => {
                    setShowReopenModal(false);
                    setReopenReason('');
                    setSelectedPeriodToReopen(null);
                  }}
                  className="border border-[#C9A581]/60 hover:bg-[#042726] text-gray-300 px-4 py-2 rounded font-semibold transition-colors"
                >
                  Hủy bỏ
                </button>
                <button
                  onClick={handleReopenPeriod}
                  disabled={!reopenReason.trim()}
                  className="bg-[#D06A5C] hover:bg-[#D06A5C]/80 text-white font-bold px-5 py-2 rounded shadow transition-all disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  Mở lại kỳ
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
