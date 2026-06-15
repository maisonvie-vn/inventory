'use client';

import React, { useState, useEffect } from 'react';
import { supabase, isSupabaseConfigured } from '../../lib/supabaseClient';
import { 
  Wine, 
  Layers, 
  RotateCcw, 
  AlertTriangle, 
  CheckCircle, 
  Plus, 
  TrendingUp, 
  UserCheck, 
  Lock, 
  Clock, 
  LogOut,
  Scale,
  RefreshCw,
  FileText,
  FileDown
} from 'lucide-react';
import { getIngredients, Ingredient } from '../../data/mockData';

// Mock Profiles for Bar Portal (PIN matching)
const BAR_PROFILES = [
  { id: 'u01', name: 'Nguyễn Văn A (Bartender)', role: 'BARTENDER', pin: '1234' },
  { id: 'u02', name: 'Trần Thị B (Bar Supervisor)', role: 'BAR_SUPERVISOR', pin: '5678' }
];

// Mock bottle calibration data (2-point calibration)
const MOCK_CALIBRATIONS: Record<string, { full_weight: number; empty_weight: number; volume_ml: number }> = {
  "ING-070": { full_weight: 1200, empty_weight: 450, volume_ml: 750 }, // Vang trắng khô
  "ING-071": { full_weight: 1250, empty_weight: 480, volume_ml: 750 }, // Vang đỏ đậm
  "ING-072": { full_weight: 1600, empty_weight: 650, volume_ml: 1000 }, // Cognac VSOP
};

export default function BarPortal() {
  // Authentication states
  const [pin, setPin] = useState('');
  const [activeUser, setActiveUser] = useState<{ id: string; name: string; role: string } | null>(null);
  const [loginError, setLoginError] = useState('');

  // Core business states
  const [ingredients, setIngredients] = useState<Ingredient[]>([]);
  const [calibrations, setCalibrations] = useState<Record<string, { full_weight: number; empty_weight: number; volume_ml: number }>>(MOCK_CALIBRATIONS);
  const [transactions, setTransactions] = useState<any[]>([]);
  
  // Bar counts (Shift counts)
  const [activeShift, setActiveShift] = useState<'OPEN' | 'CLOSE'>('OPEN');
  const [barCounts, setBarCounts] = useState<Record<string, { sealed: number; openWeight: number }>>({});
  const [derivedCounts, setDerivedCounts] = useState<Record<string, number>>({}); // derived volume in ML
  
  // Non-sale log states (spillage, breakage, comp, tasting)
  const [nonSaleIngId, setNonSaleIngId] = useState('');
  const [nonSaleQty, setNonSaleQty] = useState('');
  const [nonSaleType, setNonSaleType] = useState('SPILL');
  const [nonSaleNote, setNonSaleNote] = useState('');
  const [pinVerify, setPinVerify] = useState('');
  const [nonSaleStatus, setNonSaleStatus] = useState<string | null>(null);

  // Internal transfer states
  const [transferIngId, setTransferIngId] = useState('');
  const [transferQty, setTransferQty] = useState('');
  const [transferStatus, setTransferStatus] = useState<string | null>(null);

  // Daily movement states
  const [businessDate, setBusinessDate] = useState('2026-06-15');
  const [importsConfirmed, setImportsConfirmed] = useState(false);
  const [issuesConfirmed, setIssuesConfirmed] = useState(false);
  const [dailyStatus, setDailyStatus] = useState<'OPEN' | 'CLOSED'>('OPEN');

  // PO & PDF order documents states
  const [orderDrafts, setOrderDrafts] = useState<any[]>([]);
  const [selectedDraft, setSelectedDraft] = useState<any | null>(null);

  // Load ingredients & data
  useEffect(() => {
    // Filter ingredients to only show Wine/Alcohol/Beverage categories
    const allIngredients = getIngredients();
    const barIngredients = allIngredients.filter(ing => 
      ['Wine', 'Alcohol', 'beverage', 'Beverage'].includes(ing.category) ||
      ing.id === 'ING-070' || ing.id === 'ING-071' || ing.id === 'ING-072' ||
      ing.vi_name.toLowerCase().includes('vang') || ing.vi_name.toLowerCase().includes('bia')
    );
    setIngredients(barIngredients);

    // Initial mock transactions for Bar
    setTransactions([
      { id: 'tx-1', ingredientId: 'ING-070', type: 'import', qty: 12, date: '2026-06-15', note: 'Nhập kho từ PO-20260615-DALO' },
      { id: 'tx-2', ingredientId: 'ING-071', type: 'import', qty: 18, date: '2026-06-15', note: 'Nhập kho từ PO-20260615-DALO' }
    ]);

    // Initial mock order drafts for Bar NCCs
    setOrderDrafts([
      {
        id: 'draft-1',
        doc_no: 'PO-2026-0615-BAR-001',
        business_date: '2026-06-15',
        supplier_name: 'Tổng kho Rượu vang Đa Lộc',
        status: 'DRAFT',
        items: [
          { ingId: 'ING-070', name: 'Vang trắng khô', onHand: 2.5, warning: '🔴 CRITICAL', slDat: 24, unit: 'BOTTLE' },
          { ingId: 'ING-071', name: 'Vang đỏ đậm', onHand: 4.0, warning: '🟡 LOW', slDat: 12, unit: 'BOTTLE' }
        ]
      }
    ]);
  }, []);

  // Sync with Supabase if available
  useEffect(() => {
    if (!isSupabaseConfigured() || !activeUser) return;
    
    const fetchSupabaseData = async () => {
      try {
        const { data: calibData } = await supabase.from('bar_bottle_calibration').select('*');
        if (calibData) {
          const mapped: any = {};
          calibData.forEach(item => {
            mapped[item.ingredient_id] = {
              full_weight: item.full_weight_grams,
              empty_weight: item.empty_weight_grams,
              volume_ml: item.full_volume_ml
            };
          });
          setCalibrations(prev => ({ ...prev, ...mapped }));
        }

        const { data: movementData } = await supabase
          .from('daily_stock_movement')
          .select('*')
          .eq('business_date', businessDate)
          .eq('location_id', 'BAR')
          .single();

        if (movementData) {
          setImportsConfirmed(movementData.imports_confirmed);
          setIssuesConfirmed(movementData.issues_confirmed);
          setDailyStatus(movementData.status);
        }
      } catch (e) {
        console.error("Error fetching bar Supabase data", e);
      }
    };

    fetchSupabaseData();
  }, [activeUser, businessDate]);

  // Keypad PIN entry handler
  const handleKeyPress = (num: string) => {
    if (pin.length < 4) {
      setPin(prev => prev + num);
    }
  };

  const handleClearPin = () => {
    setPin('');
    setLoginError('');
  };

  const handlePinLoginSubmit = () => {
    const matched = BAR_PROFILES.find(u => u.pin === pin);
    if (matched) {
      setActiveUser(matched);
      setPin('');
      setLoginError('');
    } else {
      setLoginError('Mã PIN không chính xác. Vui lòng nhập lại!');
      setPin('');
    }
  };

  const handleLogout = () => {
    setActiveUser(null);
    setPin('');
  };

  // 2-point bottle weight calculation
  const handleWeightChange = (ingId: string, weightGrams: number) => {
    const cal = calibrations[ingId];
    if (!cal) return;

    // derived volume = full_volume_ml * (measured_grams - empty_weight_grams) / (full_weight_grams - empty_weight_grams)
    let derivedMl = 0;
    if (weightGrams > cal.empty_weight) {
      derivedMl = cal.volume_ml * (weightGrams - cal.empty_weight) / (cal.full_weight - cal.empty_weight);
      derivedMl = Math.min(Math.round(derivedMl), cal.volume_ml);
    }

    setDerivedCounts(prev => ({ ...prev, [ingId]: derivedMl }));
  };

  // Submit Bar Shift Counts
  const handleSubmitCounts = async () => {
    if (!activeUser) return;
    
    // Validate all counts
    alert(`Đã lưu bảng kiểm kê ${activeShift === 'OPEN' ? 'Đầu ca' : 'Cuối ca'} quầy Bar của ${activeUser.name}.`);
    
    if (isSupabaseConfigured()) {
      try {
        const promises = Object.entries(barCounts).map(async ([ingId, data]) => {
          const derivedMl = derivedCounts[ingId] || 0;
          return supabase.from('bar_counts').insert({
            business_date: businessDate,
            ingredient_id: ingId,
            sealed_qty: data.sealed,
            open_bottle_grams: data.openWeight,
            derived_volume_ml: derivedMl,
            shift: activeShift,
            counted_by: activeUser.id
          });
        });
        await Promise.all(promises);
      } catch (err) {
        console.error("Error saving counts to Supabase", err);
      }
    }
  };

  // Log Breakage / Spill / Comp for Bar
  const handleLogSpillage = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!nonSaleIngId || !nonSaleQty) return;

    // Validate PIN signature
    const signer = BAR_PROFILES.find(u => u.pin === pinVerify);
    if (!signer) {
      setNonSaleStatus('Lỗi: Mã PIN người ký duyệt không chính xác!');
      return;
    }

    const ing = ingredients.find(i => i.id === nonSaleIngId);
    const qtyNum = parseFloat(nonSaleQty);

    const newTx = {
      id: `tx-${Date.now()}`,
      ingredientId: nonSaleIngId,
      type: 'consumption',
      qty: qtyNum,
      date: businessDate,
      note: `Khai báo Bar ${nonSaleType}: ${nonSaleNote} (Ký bởi ${signer.name})`
    };

    setTransactions(prev => [...prev, newTx]);
    setNonSaleStatus(`Thành công: Đã ghi nhận khấu hao -${qtyNum} ${ing?.unit} lý do ${nonSaleType}.`);
    setNonSaleIngId('');
    setNonSaleQty('');
    setNonSaleNote('');
    setPinVerify('');
  };

  // Internal Transfer Request
  const handleRequestTransfer = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!transferIngId || !transferQty) return;

    const ing = ingredients.find(i => i.id === transferIngId);
    const qtyNum = parseFloat(transferQty);

    const newTx = {
      id: `tx-${Date.now()}`,
      ingredientId: transferIngId,
      type: 'import',
      qty: qtyNum,
      date: businessDate,
      note: `Yêu cầu cấp kho từ Kho tổng: ${qtyNum} ${ing?.unit}`
    };

    setTransactions(prev => [...prev, newTx]);
    setTransferStatus(`Thành công: Đã tạo yêu cầu chuyển kho ${qtyNum} ${ing?.unit}. Vui lòng chờ Kho tổng duyệt xuất.`);
    setTransferIngId('');
    setTransferQty('');
  };

  // Confirm daily movement flags
  const handleConfirmMovement = async (type: 'IMPORT' | 'ISSUE') => {
    if (!activeUser) return;
    
    if (type === 'IMPORT') {
      setImportsConfirmed(true);
      alert('Đã xác nhận: "Đã nhập đủ hàng trong ngày" cho quầy Bar.');
    } else {
      setIssuesConfirmed(true);
      alert('Đã xác nhận: "Đã xuất tiêu hao trong ca" cho quầy Bar.');
    }

    if (isSupabaseConfigured()) {
      try {
        const { error } = await supabase.rpc('confirm_daily_movement', {
          p_date: businessDate,
          p_loc_id: 'BAR',
          p_type: type,
          p_user_id: activeUser.id
        });
        if (error) throw error;
      } catch (err) {
        console.error("Error calling confirm_daily_movement", err);
      }
    }
  };

  // PDF Document Generation & Storage upload simulator
  const handleApproveAndExportPdf = (draft: any) => {
    // Generate a simple SHA-256 mock hash
    const hash = 'SHA256-' + Math.random().toString(36).substring(2, 10).toUpperCase() + Math.random().toString(36).substring(2, 10).toUpperCase();
    
    // Update draft status
    setOrderDrafts(prev => prev.map(d => d.id === draft.id ? { ...d, status: 'APPROVED', content_hash: hash } : d));
    
    // Open a styled neoclassic print layout window
    const printWindow = window.open('', '_blank');
    if (printWindow) {
      printWindow.document.write(`
        <html>
          <head>
            <title>Phiếu Đặt Hàng - ${draft.doc_no}</title>
            <style>
              body { font-family: 'Times New Roman', serif; background-color: #fff; color: #000; padding: 40px; }
              .header { text-align: center; border-bottom: 2px solid #b59410; padding-bottom: 10px; margin-bottom: 30px; }
              .title { font-size: 22px; font-weight: bold; letter-spacing: 2px; margin: 0; color: #7a6300; }
              .subtitle { font-size: 11px; letter-spacing: 3px; text-transform: uppercase; margin: 5px 0 0 0; color: #555; }
              .meta-table { width: 100%; margin-bottom: 30px; font-size: 13px; }
              .meta-table td { padding: 4px; vertical-align: top; }
              .warn-box { border: 1px solid #b59410; padding: 10px; margin-bottom: 20px; font-size: 11px; display: flex; gap: 15px; }
              .data-table { width: 100%; border-collapse: collapse; margin-bottom: 40px; font-size: 12px; }
              .data-table th, .data-table td { border: 1px solid #ccc; padding: 8px; text-align: left; }
              .data-table th { background-color: #f5f5f5; font-weight: bold; }
              .footer-sigs { width: 100%; margin-top: 50px; text-align: center; font-size: 13px; }
              .footer-sigs td { width: 33%; height: 100px; vertical-align: top; }
              .hash-info { margin-top: 60px; border-top: 1px solid #eee; padding-top: 10px; font-family: monospace; font-size: 10px; color: #666; text-align: right; }
            </style>
          </head>
          <body>
            <div class="header">
              <h1 class="title">MAISON VIE</h1>
              <p class="subtitle">Hệ thống CRM/ERP Inventory & Finance</p>
              <h2 style="font-size: 16px; margin: 15px 0 0 0; text-decoration: underline;">PHIẾU ĐỀ XUẤT ĐẶT HÀNG / PURCHASE ORDER</h2>
            </div>
            
            <table class="meta-table">
              <tr>
                <td><strong>Số chứng từ:</strong> ${draft.doc_no}</td>
                <td><strong>Nhà cung cấp:</strong> ${draft.supplier_name}</td>
              </tr>
              <tr>
                <td><strong>Ngày chốt sổ:</strong> ${draft.business_date}</td>
                <td><strong>Bộ phận yêu cầu:</strong> QUẦY BAR (BAR)</td>
              </tr>
            </table>

            <div class="warn-box">
              <span>Chú giải cảnh báo:</span>
              <span>🔴 KHẨN CẤP (Tồn &le; An toàn)</span>
              <span>🟡 SẮP HẾT (Tồn &le; Tối thiểu)</span>
              <span>🟢 ĐỦ TỒN (Không đặt)</span>
            </div>

            <table class="data-table">
              <thead>
                <tr>
                  <th>STT</th>
                  <th>Mã NVL</th>
                  <th>Tên nguyên liệu</th>
                  <th>Tồn vật lý</th>
                  <th>ĐVT</th>
                  <th>Cảnh báo</th>
                  <th>SL Đặt đề xuất</th>
                </tr>
              </thead>
              <tbody>
                ${draft.items.map((it: any, idx: number) => `
                  <tr>
                    <td>${idx + 1}</td>
                    <td>${it.ingId}</td>
                    <td>${it.name}</td>
                    <td>${it.onHand}</td>
                    <td>${it.unit}</td>
                    <td>${it.warning}</td>
                    <td><strong>${it.slDat}</strong></td>
                  </tr>
                `).join('')}
              </tbody>
            </table>

            <table class="footer-sigs">
              <tr>
                <td><strong>Người lập phiếu</strong><br/><span style="font-size:11px; color:#555;">(Ký, ghi rõ họ tên)</span></td>
                <td><strong>Trưởng bộ phận Bar</strong><br/><span style="font-size:11px; color:#555;">(Ký, duyệt tồn ca)</span></td>
                <td><strong>Phê duyệt (CFO)</strong><br/><span style="font-size:11px; color:#555;">(Ký, duyệt ngân sách)</span></td>
              </tr>
            </table>

            <div class="hash-info">
              Document SHA-256: ${hash.substring(0, 32)}...<br/>
              *Bản nháp được hệ thống chốt tự động. Có hiệu lực pháp lý khi đủ chữ ký duyệt.
            </div>
          </body>
        </html>
      `);
      printWindow.document.close();
      printWindow.print();
    }
  };

  // Login PIN entry UI
  if (!activeUser) {
    return (
      <div className="min-h-screen flex flex-col bg-[#090d16] text-gray-100 selection:bg-amber-500 selection:text-black justify-center items-center p-6 relative overflow-hidden">
        <div className="absolute top-1/4 left-1/4 w-[40rem] h-[40rem] bg-amber-500/5 rounded-full blur-[10rem] pointer-events-none"></div>
        
        <div className="w-full max-w-sm bg-[#0c1220]/80 border border-amber-500/30 rounded-md p-8 flex flex-col gap-6 shadow-2xl backdrop-blur-md relative z-10 font-sans">
          <div className="flex flex-col items-center gap-2 text-center">
            <div className="relative w-12 h-12 border border-amber-500/60 flex items-center justify-center rounded-sm rotate-45 bg-[#090d16] mb-2">
              <span className="text-amber-500 font-serif font-semibold text-2xl rotate-[-45deg] scale-90">MV</span>
            </div>
            <h2 className="text-xl font-semibold tracking-widest text-[#d4af37] font-serif">BAR PORTAL</h2>
            <p className="text-[10px] tracking-[0.2em] text-gray-400 font-sans uppercase">Tablet Quầy Bar & Kiểm Kê</p>
          </div>

          <div className="flex flex-col gap-4">
            <div className="bg-[#090d16] border border-amber-500/20 rounded p-4 text-center">
              <div className="text-2xl font-mono tracking-[0.5em] text-amber-500 h-8 font-bold">
                {pin.split('').map(() => '•').join('') || <span className="text-gray-600 text-sm tracking-normal">NHẬP MÃ PIN</span>}
              </div>
            </div>

            {loginError && (
              <p className="text-xs text-rose-400 font-medium text-center">{loginError}</p>
            )}

            {/* Numeric Keypad Grid */}
            <div className="grid grid-cols-3 gap-3">
              {['1', '2', '3', '4', '5', '6', '7', '8', '9'].map(num => (
                <button
                  key={num}
                  onClick={() => handleKeyPress(num)}
                  className="bg-[#0c1220]/50 hover:bg-[#090d16] active:scale-95 transition-all py-4 rounded border border-amber-500/10 text-lg font-bold text-gray-200"
                >
                  {num}
                </button>
              ))}
              <button
                onClick={handleClearPin}
                className="bg-rose-950/20 hover:bg-rose-900/30 text-rose-400 py-4 rounded border border-rose-500/10 text-xs font-bold font-sans"
              >
                XÓA
              </button>
              <button
                onClick={() => handleKeyPress('0')}
                className="bg-[#0c1220]/50 hover:bg-[#090d16] active:scale-95 py-4 rounded border border-amber-500/10 text-lg font-bold text-gray-200"
              >
                0
              </button>
              <button
                onClick={handlePinLoginSubmit}
                disabled={pin.length < 4}
                className="bg-amber-600/20 hover:bg-amber-500 hover:text-black disabled:opacity-30 text-amber-400 py-4 rounded border border-amber-500/20 text-xs font-bold font-sans"
              >
                VÀO
              </button>
            </div>

            <div className="border-t border-amber-500/10 pt-3 text-center">
              <span className="text-[9px] text-gray-500 block uppercase tracking-wider">Tài khoản Sandbox Demo:</span>
              <div className="flex justify-center gap-4 mt-2 text-[9px] text-amber-500/70 font-mono">
                <span>Bartender: PIN 1234</span>
                <span>•</span>
                <span>Supervisor: PIN 5678</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }

  // Active Bar Portal Panel
  return (
    <div className="min-h-screen flex flex-col bg-[#090d16] text-gray-100 font-sans selection:bg-amber-500 selection:text-black">
      {/* Portal Header */}
      <header className="border-b border-amber-500/20 bg-[#0c1220]/80 backdrop-blur-md sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="relative w-8 h-8 border border-amber-500/50 flex items-center justify-center rounded-sm rotate-45 bg-[#090d16]">
              <span className="text-amber-500 font-serif font-semibold rotate-[-45deg] scale-90">MV</span>
            </div>
            <div>
              <h1 className="text-lg font-semibold tracking-wider text-[#d4af37] font-serif">MAISON VIE BAR</h1>
              <p className="text-[9px] tracking-[0.1em] text-gray-400 uppercase">Cổng nghiệp vụ Bar độc lập</p>
            </div>
          </div>

          <div className="flex items-center gap-4">
            <div className="flex items-center gap-2 bg-[#0c1220] border border-amber-500/20 px-3 py-1.5 rounded-sm text-xs">
              <UserCheck size={14} className="text-amber-500" />
              <span className="text-gray-300 font-semibold">{activeUser.name} ({activeUser.role})</span>
            </div>

            <button 
              onClick={handleLogout}
              className="flex items-center gap-1 bg-rose-950/30 hover:bg-rose-900/30 text-rose-400 border border-rose-500/20 px-3 py-1.5 rounded-sm text-xs font-semibold"
            >
              <LogOut size={14} />
              <span>Thoát</span>
            </button>
          </div>
        </div>
      </header>

      {/* Main Grid Content */}
      <main className="max-w-7xl mx-auto px-6 py-8 grid grid-cols-1 lg:grid-cols-12 gap-8 w-full">
        
        {/* Left Side: Shift Count & Weighing calibration (derived ml) */}
        <div className="lg:col-span-8 flex flex-col gap-6">
          <div className="bg-[#0c1220]/50 rounded border border-amber-500/10 p-6 flex flex-col gap-4">
            <div className="flex justify-between items-center border-b border-amber-500/10 pb-3">
              <div className="flex items-center gap-2">
                <Scale className="text-[#d4af37]" />
                <h2 className="text-base font-bold text-[#d4af37] uppercase tracking-wider font-serif">Kiểm Kê Chai Rượu Dở & Hiệu Chuẩn 2 Điểm</h2>
              </div>
              <div className="flex gap-2">
                <button
                  onClick={() => setActiveShift('OPEN')}
                  className={`px-3 py-1 rounded text-xs font-bold transition-all ${activeShift === 'OPEN' ? 'bg-amber-500 text-black' : 'bg-[#090d16] text-gray-400 border border-amber-500/10'}`}
                >
                  ĐẦU CA (OPEN)
                </button>
                <button
                  onClick={() => setActiveShift('CLOSE')}
                  className={`px-3 py-1 rounded text-xs font-bold transition-all ${activeShift === 'CLOSE' ? 'bg-amber-500 text-black' : 'bg-[#090d16] text-gray-400 border border-amber-500/10'}`}
                >
                  CUỐI CA (CLOSE)
                </button>
              </div>
            </div>

            <div className="flex flex-col gap-4">
              <table className="w-full text-xs text-left">
                <thead>
                  <tr className="text-gray-400 uppercase tracking-wider border-b border-amber-500/10 pb-2">
                    <th className="py-2">Mã NVL</th>
                    <th>Tên rượu</th>
                    <th>Chai nguyên</th>
                    <th>Cân nặng chai dở (g)</th>
                    <th>Quy đổi (ml)</th>
                    <th>Định mức hiệu chuẩn</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-amber-500/5">
                  {ingredients.map(ing => {
                    const cal = calibrations[ing.id] || { full_weight: 1200, empty_weight: 450, volume_ml: 750 };
                    const current = barCounts[ing.id] || { sealed: 0, openWeight: 0 };
                    const derivedMl = derivedCounts[ing.id] || 0;

                    return (
                      <tr key={ing.id} className="hover:bg-amber-500/5">
                        <td className="py-3 font-mono font-bold text-amber-500">{ing.id}</td>
                        <td>
                          <div className="flex flex-col">
                            <span className="font-semibold text-gray-200">{ing.vi_name}</span>
                            <span className="text-[10px] text-gray-500">tolerance: {ing.tolerance_percent || 2}%</span>
                          </div>
                        </td>
                        <td>
                          <input
                            type="number"
                            placeholder="0"
                            value={current.sealed || ''}
                            onChange={(e) => {
                              const val = parseFloat(e.target.value) || 0;
                              setBarCounts(prev => ({
                                ...prev,
                                [ing.id]: { ...current, sealed: val }
                              }));
                            }}
                            className="bg-[#090d16] border border-amber-500/20 text-xs rounded text-center w-16 py-1 text-gray-100 focus:outline-none focus:border-amber-500 font-mono"
                          />
                        </td>
                        <td>
                          <input
                            type="number"
                            placeholder="g"
                            value={current.openWeight || ''}
                            onChange={(e) => {
                              const val = parseFloat(e.target.value) || 0;
                              setBarCounts(prev => ({
                                ...prev,
                                [ing.id]: { ...current, openWeight: val }
                              }));
                              handleWeightChange(ing.id, val);
                            }}
                            className="bg-[#090d16] border border-amber-500/20 text-xs rounded text-center w-24 py-1 text-gray-100 focus:outline-none focus:border-amber-500 font-mono"
                          />
                        </td>
                        <td>
                          <span className="font-mono text-emerald-400 font-semibold">{derivedMl} ML</span>
                        </td>
                        <td>
                          <span className="text-[10px] text-gray-500 block font-mono">Đầy: {cal.full_weight}g</span>
                          <span className="text-[10px] text-gray-500 block font-mono">Rỗng: {cal.empty_weight}g</span>
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>

              <button
                onClick={handleSubmitCounts}
                className="bg-gradient-to-r from-amber-600 to-amber-500 hover:from-amber-500 hover:to-[#f3e5ab] text-[#090d16] font-bold text-xs py-3 rounded shadow transition-all active:scale-95 uppercase tracking-wider mt-4"
              >
                Ghi Nhận & Khóa Số Kiểm kê Ca
              </button>
            </div>
          </div>

          {/* Confirmations section: imports and issues */}
          <div className="bg-[#0c1220]/50 rounded border border-amber-500/10 p-6 flex flex-col gap-4">
            <div className="flex items-center gap-2 border-b border-amber-500/10 pb-3">
              <Clock className="text-[#d4af37]" />
              <h2 className="text-base font-bold text-[#d4af37] uppercase tracking-wider font-serif">Cổng Xác Nhận Vận Động Kho Bar Trong Ngày</h2>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 font-sans">
              <div className="bg-[#090d16]/70 border border-amber-500/10 rounded p-5 flex flex-col gap-3">
                <h4 className="text-xs font-bold text-gray-300 uppercase tracking-wider">1. Xác nhận nhập kho</h4>
                <p className="text-[11px] text-gray-400 leading-relaxed">Đơn nhận từ NCC hoặc Kho tổng đã đối soát chuyển giao vật lý thành công.</p>
                <div className="flex justify-between items-center mt-2">
                  <span className={`text-[10px] font-bold px-2 py-0.5 rounded ${importsConfirmed ? 'bg-emerald-500/10 text-emerald-400' : 'bg-amber-500/10 text-amber-400'}`}>
                    {importsConfirmed ? '🟢 ĐÃ NHẬP XONG' : '🟡 CHỜ XÁC NHẬN'}
                  </span>
                  <button
                    disabled={importsConfirmed || dailyStatus === 'CLOSED'}
                    onClick={() => handleConfirmMovement('IMPORT')}
                    className="bg-emerald-600 hover:bg-emerald-500 disabled:opacity-40 text-gray-100 text-[10px] font-bold px-3 py-1.5 rounded active:scale-95 transition-all"
                  >
                    ✔ ĐÃ NHẬP XONG
                  </button>
                </div>
              </div>

              <div className="bg-[#090d16]/70 border border-amber-500/10 rounded p-5 flex flex-col gap-3">
                <h4 className="text-xs font-bold text-gray-300 uppercase tracking-wider">2. Xác nhận xuất ca</h4>
                <p className="text-[11px] text-gray-400 leading-relaxed">Đã cập nhật đầy đủ các khoản hao phí, vỡ, đổ, hoặc tặng khách của ca quầy Bar.</p>
                <div className="flex justify-between items-center mt-2">
                  <span className={`text-[10px] font-bold px-2 py-0.5 rounded ${issuesConfirmed ? 'bg-emerald-500/10 text-emerald-400' : 'bg-amber-500/10 text-amber-400'}`}>
                    {issuesConfirmed ? '🟢 ĐÃ XUẤT XONG' : '🟡 CHỜ XÁC NHẬN'}
                  </span>
                  <button
                    disabled={issuesConfirmed || dailyStatus === 'CLOSED'}
                    onClick={() => handleConfirmMovement('ISSUE')}
                    className="bg-emerald-600 hover:bg-emerald-500 disabled:opacity-40 text-gray-100 text-[10px] font-bold px-3 py-1.5 rounded active:scale-95 transition-all"
                  >
                    ✔ ĐÃ XUẤT XONG
                  </button>
                </div>
              </div>
            </div>

            {importsConfirmed && issuesConfirmed && (
              <div className="bg-emerald-500/10 border border-emerald-500/20 rounded p-3 text-center text-xs text-emerald-400 font-semibold mt-2">
                🎉 KHÓA SỔ TỒN CUỐI NGÀY THÀNH CÔNG: Tồn kho Bar hôm nay đã lưu snapshot bất biến.
              </div>
            )}
          </div>
        </div>

        {/* Right Side: Spillage Log (non-sale) & Transfer requests */}
        <div className="lg:col-span-4 flex flex-col gap-6">
          
          {/* Spillage Form */}
          <div className="bg-[#0c1220]/50 rounded border border-amber-500/10 p-6 flex flex-col gap-4 font-sans">
            <h3 className="text-sm font-bold text-[#d4af37] uppercase tracking-wider border-b border-amber-500/10 pb-3 flex items-center gap-1.5">
              <Wine size={16} />
              <span>Khai Báo Hao Phí Quầy Bar (Spill/Vỡ)</span>
            </h3>

            <form onSubmit={handleLogSpillage} className="flex flex-col gap-4">
              <div className="flex flex-col gap-1.5">
                <label className="text-[10px] uppercase text-gray-400 font-semibold">1. Chọn rượu / Đồ uống</label>
                <select
                  value={nonSaleIngId}
                  onChange={(e) => setNonSaleIngId(e.target.value)}
                  className="bg-[#090d16] border border-amber-500/20 text-xs rounded p-2.5 text-gray-200 focus:outline-none focus:border-amber-500 w-full"
                  required
                >
                  <option value="">-- Chọn loại rượu --</option>
                  {ingredients.map(ing => (
                    <option key={ing.id} value={ing.id}>{ing.id} - {ing.vi_name}</option>
                  ))}
                </select>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="flex flex-col gap-1.5">
                  <label className="text-[10px] uppercase text-gray-400 font-semibold">2. Số lượng hao</label>
                  <input
                    type="number"
                    step="0.01"
                    required
                    placeholder="Số chai/ly..."
                    value={nonSaleQty}
                    onChange={(e) => setNonSaleQty(e.target.value)}
                    className="bg-[#090d16] border border-amber-500/20 text-xs rounded p-2.5 text-gray-100 focus:outline-none focus:border-amber-500 font-mono"
                  />
                </div>
                <div className="flex flex-col gap-1.5">
                  <label className="text-[10px] uppercase text-gray-400 font-semibold">3. Loại sự cố</label>
                  <select
                    value={nonSaleType}
                    onChange={(e) => setNonSaleType(e.target.value)}
                    className="bg-[#090d16] border border-amber-500/20 text-xs rounded p-2.5 text-gray-200 focus:outline-none focus:border-amber-500 w-full"
                  >
                    <option value="SPILL">Rót quá tay (Spill)</option>
                    <option value="BREAKAGE">Bể vỡ chai (Breakage)</option>
                    <option value="COMP_DRINK">Tặng khách (Comp)</option>
                    <option value="TASTING">Thử rượu (Tasting)</option>
                  </select>
                </div>
              </div>

              <div className="flex flex-col gap-1.5">
                <label className="text-[10px] uppercase text-gray-400 font-semibold">4. Ghi chú chi tiết</label>
                <input
                  type="text"
                  placeholder="Vỡ lúc dọn quầy..."
                  value={nonSaleNote}
                  onChange={(e) => setNonSaleNote(e.target.value)}
                  className="bg-[#090d16] border border-amber-500/20 text-xs rounded p-2.5 text-gray-100 focus:outline-none focus:border-amber-500"
                />
              </div>

              <div className="flex flex-col gap-1.5">
                <label className="text-[10px] uppercase text-gray-400 font-semibold">5. Mã PIN xác minh người trực</label>
                <input
                  type="password"
                  placeholder="Mã PIN 4 số"
                  value={pinVerify}
                  onChange={(e) => setPinVerify(e.target.value)}
                  className="bg-[#090d16] border border-amber-500/20 text-xs rounded p-2.5 text-gray-100 focus:outline-none focus:border-amber-500 font-mono tracking-widest text-center"
                  required
                />
              </div>

              {nonSaleStatus && (
                <p className={`text-xs font-semibold ${nonSaleStatus.includes('Lỗi') ? 'text-rose-400' : 'text-emerald-400'}`}>
                  {nonSaleStatus}
                </p>
              )}

              <button
                type="submit"
                className="bg-rose-900/40 hover:bg-rose-900/60 text-rose-300 font-bold text-xs py-3 rounded shadow transition-all active:scale-95"
              >
                Ghi nhận Hao phí Bar
              </button>
            </form>
          </div>

          {/* Internal Transfer Request Form */}
          <div className="bg-[#0c1220]/50 rounded border border-amber-500/10 p-6 flex flex-col gap-4 font-sans">
            <h3 className="text-sm font-bold text-[#d4af37] uppercase tracking-wider border-b border-amber-500/10 pb-3 flex items-center gap-1.5">
              <Layers size={16} />
              <span>Yêu Cầu Cấp Rượu (Transfer In)</span>
            </h3>

            <form onSubmit={handleRequestTransfer} className="flex flex-col gap-4">
              <div className="flex flex-col gap-1.5">
                <label className="text-[10px] uppercase text-gray-400 font-semibold">1. Chọn loại rượu cần cấp</label>
                <select
                  value={transferIngId}
                  onChange={(e) => setTransferIngId(e.target.value)}
                  className="bg-[#090d16] border border-amber-500/20 text-xs rounded p-2.5 text-gray-200 focus:outline-none focus:border-amber-500 w-full"
                  required
                >
                  <option value="">-- Chọn rượu --</option>
                  {ingredients.map(ing => (
                    <option key={ing.id} value={ing.id}>{ing.id} - {ing.vi_name}</option>
                  ))}
                </select>
              </div>

              <div className="flex flex-col gap-1.5">
                <label className="text-[10px] uppercase text-gray-400 font-semibold">2. Số lượng yêu cầu (Chai)</label>
                <input
                  type="number"
                  required
                  placeholder="Số lượng..."
                  value={transferQty}
                  onChange={(e) => setTransferQty(e.target.value)}
                  className="bg-[#090d16] border border-amber-500/20 text-xs rounded p-2.5 text-gray-100 focus:outline-none focus:border-amber-500 font-mono"
                />
              </div>

              {transferStatus && (
                <p className="text-xs font-semibold text-emerald-400">{transferStatus}</p>
              )}

              <button
                type="submit"
                className="bg-amber-600/20 hover:bg-amber-500 hover:text-black text-amber-400 font-bold text-xs py-3 rounded shadow border border-amber-500/20 transition-all active:scale-95"
              >
                Gửi yêu cầu cấp kho
              </button>
            </form>
          </div>

          {/* PO PDF Approve & Export - Supervisor Only */}
          {activeUser.role === 'BAR_SUPERVISOR' && (
            <div className="bg-[#0c1220]/50 rounded border border-amber-500/10 p-6 flex flex-col gap-4 font-sans">
              <h3 className="text-sm font-bold text-[#d4af37] uppercase tracking-wider border-b border-amber-500/10 pb-3 flex items-center gap-1.5">
                <FileText size={16} />
                <span>Bản Nháp Phiếu Đặt Hàng Bar</span>
              </h3>

              <div className="flex flex-col gap-3">
                {orderDrafts.map(draft => (
                  <div key={draft.id} className="bg-[#090d16] border border-amber-500/10 rounded p-3 flex flex-col gap-2">
                    <div className="flex justify-between items-center text-xs">
                      <span className="font-mono text-amber-500 font-bold">{draft.doc_no}</span>
                      <span className={`px-1 rounded text-[8px] font-bold ${draft.status === 'APPROVED' ? 'bg-emerald-500/10 text-emerald-400' : 'bg-amber-500/10 text-amber-400'}`}>
                        {draft.status}
                      </span>
                    </div>
                    <span className="text-xs text-gray-300 font-semibold">{draft.supplier_name}</span>
                    <span className="text-[10px] text-gray-500">Mã hàng dự kiến: {draft.items.length} mặt hàng</span>
                    
                    <button
                      onClick={() => handleApproveAndExportPdf(draft)}
                      className="bg-gradient-to-r from-amber-600 to-amber-500 hover:from-amber-500 hover:to-[#f3e5ab] text-[#090d16] font-bold text-[10px] py-2 rounded mt-2 flex items-center justify-center gap-1"
                    >
                      <FileDown size={12} />
                      <span>DUYỆT & XUẤT PO PDF</span>
                    </button>
                  </div>
                ))}
              </div>
            </div>
          )}

        </div>

      </main>
    </div>
  );
}
