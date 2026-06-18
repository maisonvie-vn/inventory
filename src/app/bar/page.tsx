'use client';

import React, { useState, useEffect, useMemo } from 'react';
import { useRouter } from 'next/navigation';
import { supabase, isSupabaseConfigured } from '../../lib/supabaseClient';
import { 
  getIngredients, 
  getSales, 
  POS_MAPPING, 
  Ingredient, 
  SaleRecord 
} from '../../data/mockData';
import { 
  Scale, 
  Lock, 
  LogIn, 
  LogOut, 
  AlertTriangle, 
  CheckCircle, 
  RefreshCw, 
  FolderPlus, 
  Layers, 
  Wine, 
  FileText, 
  ChevronRight, 
  Compass, 
  Coffee, 
  Beer,
  CheckSquare,
  Trash2,
  Send,
  UserCheck
} from 'lucide-react';

interface BarUser {
  id: string;
  name: string;
  pin: string;
  role: 'BARTENDER' | 'BAR_SUPERVISOR';
}

const BAR_USERS: BarUser[] = [
  { id: 'b-1', name: 'Bartender Minh Cường', pin: '1234', role: 'BARTENDER' },
  { id: 'b-2', name: 'Bartender Hoài Nam', pin: '5678', role: 'BARTENDER' },
  { id: 'b-3', name: 'Trưởng Bar Quốc Tuấn', pin: '0000', role: 'BAR_SUPERVISOR' }
];

export default function BarPortal() {
  const router = useRouter();

  // Authentication State
  const [activeUser, setActiveUser] = useState<BarUser | null>(null);
  const [selectedUserForLogin, setSelectedUserForLogin] = useState<BarUser | null>(BAR_USERS[0]);
  const [pinInput, setPinInput] = useState<string>('');
  const [pinError, setPinError] = useState<string>('');
  const [lastActivityTime, setLastActivityTime] = useState<number>(Date.now());

  // Inventory & Calibration State
  const [ingredients, setIngredients] = useState<Ingredient[]>([]);
  const [calibrations, setCalibrations] = useState<Record<string, { full_weight: number; empty_weight: number; volume_ml: number }>>({
    "ING-070": { full_weight: 1200, empty_weight: 450, volume_ml: 750 },
    "ING-071": { full_weight: 1250, empty_weight: 480, volume_ml: 750 },
    "ING-072": { full_weight: 1600, empty_weight: 650, volume_ml: 1000 },
  });

  // Scale Weighing Interactive State
  const [selectedCalibIng, setSelectedCalibIng] = useState<string>('ING-070');
  const [scaleReadingGrams, setScaleReadingGrams] = useState<string>('850');
  const [fullWeightInput, setFullWeightInput] = useState<string>('1200');
  const [emptyWeightInput, setEmptyWeightInput] = useState<string>('450');
  const [volumeInput, setVolumeInput] = useState<string>('750');
  const [calibSaveSuccess, setCalibSaveSuccess] = useState(false);

  // Shift counting & Stock takes
  const [currentShift, setCurrentShift] = useState<'OPEN' | 'CLOSE'>('OPEN');
  const [shiftCounts, setShiftCounts] = useState<Record<string, { full_bottles: number; scale_grams: number }>>({});
  const [shiftSubmitSuccess, setShiftSubmitSuccess] = useState(false);

  // Pour Variance and historical counts list
  const [pastCounts, setPastCounts] = useState<any[]>([
    { id: 'c-1', business_date: '2026-06-15', ingredient_id: 'ING-070', name: 'Vang trắng khô', sealed_qty: 5, open_bottle_grams: 850, derived_volume_ml: 400, shift: 'CLOSE', counted_by: 'Bartender Minh Cường', counted_at: '2026-06-15 23:05' },
    { id: 'c-2', business_date: '2026-06-15', ingredient_id: 'ING-071', name: 'Vang đỏ đậm', sealed_qty: 3, open_bottle_grams: 900, derived_volume_ml: 407, shift: 'CLOSE', counted_by: 'Bartender Minh Cường', counted_at: '2026-06-15 23:08' },
  ]);

  // Waste logging form state
  const [wasteIngId, setWasteIngId] = useState<string>('ING-070');
  const [wasteQtyMl, setWasteQtyMl] = useState<string>('150');
  const [wasteReason, setWasteReason] = useState<string>('Spill (Rót đổ/tràn)');
  const [wasteSuccess, setWasteSuccess] = useState(false);

  // Internal transfer form state
  const [transferIngId, setTransferIngId] = useState<string>('ING-070');
  const [transferQty, setTransferQty] = useState<string>('3'); // 3 chai
  const [transferNote, setTransferNote] = useState<string>('Yêu cầu cấp thêm hàng phục vụ ca tối');
  const [transferSuccess, setTransferSuccess] = useState(false);

  // General Settings
  const [weightToleranceGrams, setWeightToleranceGrams] = useState<number>(5); // ±5g
  const [selectedSettingsTab, setSelectedSettingsTab] = useState<'calib' | 'tolerance' | 'history'>('calib');

  // Load ingredients & calibrations from Supabase or Fallback
  useEffect(() => {
    const loadData = async () => {
      let loadedIngredients = getIngredients();
      // Filter only bar relevant items: Wine, Alcohol, Beverage categories
      const barRelevant = loadedIngredients.filter(ing => 
        ['Wine', 'Alcohol', 'Beverage'].includes(ing.category) ||
        ing.id.startsWith('M9') || ing.id.startsWith('S1') || ing.id.startsWith('V3') || ing.id.startsWith('V5')
      );
      setIngredients(barRelevant);

      // Initialize shift counts structure
      const initialCounts: Record<string, { full_bottles: number; scale_grams: number }> = {};
      barRelevant.forEach(ing => {
        initialCounts[ing.id] = { full_bottles: 0, scale_grams: ing.tare_weight_grams || 450 };
      });
      setShiftCounts(initialCounts);

      if (isSupabaseConfigured()) {
        try {
          // Fetch calibration parameters
          const { data: calibData } = await supabase.from('bar_bottle_calibration').select('*');
          if (calibData && calibData.length > 0) {
            const mappedCalibs: Record<string, { full_weight: number; empty_weight: number; volume_ml: number }> = {};
            calibData.forEach(item => {
              mappedCalibs[item.ingredient_id] = {
                full_weight: parseFloat(item.full_weight_grams),
                empty_weight: parseFloat(item.empty_weight_grams),
                volume_ml: parseFloat(item.full_volume_ml)
              };
            });
            setCalibrations(mappedCalibs);
          }

          // Fetch past bar counts
          const { data: countData } = await supabase.from('bar_counts').select('*').order('counted_at', { ascending: false }).limit(20);
          if (countData) {
            setPastCounts(countData.map(c => ({
              id: c.id,
              business_date: c.business_date,
              ingredient_id: c.ingredient_id,
              name: barRelevant.find(i => i.id === c.ingredient_id)?.vi_name || c.ingredient_id,
              sealed_qty: parseFloat(c.sealed_qty),
              open_bottle_grams: parseFloat(c.open_bottle_grams),
              derived_volume_ml: parseFloat(c.derived_volume_ml),
              shift: c.shift,
              counted_by: c.counted_by || 'Bartender',
              counted_at: c.counted_at?.replace('T', ' ').substring(0, 16)
            })));
          }
        } catch (e) {
          console.error("Supabase load failed in bar page, falling back to local simulation.", e);
        }
      }
    };

    loadData();
  }, []);

  // Update scale helper form when selected item changes
  useEffect(() => {
    const cal = calibrations[selectedCalibIng] || { full_weight: 1200, empty_weight: 450, volume_ml: 750 };
    setFullWeightInput(cal.full_weight.toString());
    setEmptyWeightInput(cal.empty_weight.toString());
    setVolumeInput(cal.volume_ml.toString());
  }, [selectedCalibIng, calibrations]);

  // Inactivity Auto-logout Watchdog (3 minutes)
  useEffect(() => {
    if (!activeUser) return;

    const interval = setInterval(() => {
      const idleTime = Date.now() - lastActivityTime;
      if (idleTime > 3 * 60 * 1000) { // 3 minutes
        handleLogout();
      }
    }, 10000);

    const resetTimer = () => setLastActivityTime(Date.now());
    window.addEventListener('mousemove', resetTimer);
    window.addEventListener('keydown', resetTimer);
    window.addEventListener('touchstart', resetTimer);

    return () => {
      clearInterval(interval);
      window.removeEventListener('mousemove', resetTimer);
      window.removeEventListener('keydown', resetTimer);
      window.removeEventListener('touchstart', resetTimer);
    };
  }, [activeUser, lastActivityTime]);

  const handleLogout = () => {
    setActiveUser(null);
    setPinInput('');
    setPinError('');
  };

  const handlePinPress = (num: string) => {
    setLastActivityTime(Date.now());
    if (pinInput.length < 4) {
      const nextInput = pinInput + num;
      setPinInput(nextInput);
      setPinError('');
      
      if (nextInput.length === 4) {
        // Verify PIN
        if (selectedUserForLogin && selectedUserForLogin.pin === nextInput) {
          setActiveUser(selectedUserForLogin);
          setPinInput('');
        } else {
          setPinError('Mã PIN không đúng, vui lòng thử lại.');
          setPinInput('');
        }
      }
    }
  };

  const handlePinClear = () => {
    setPinInput('');
    setPinError('');
  };

  // 2-point Interpolated Volume Calculation
  const getInterpolatedVolume = (ingId: string, currentWeight: number) => {
    const cal = calibrations[ingId] || { full_weight: 1200, empty_weight: 450, volume_ml: 750 };
    const { full_weight, empty_weight, volume_ml } = cal;
    
    if (currentWeight <= empty_weight) return 0;
    if (currentWeight >= full_weight) return volume_ml;
    
    // Derived volume: weight ratio to volume
    const ratio = (currentWeight - empty_weight) / (full_weight - empty_weight);
    return Math.round(ratio * volume_ml);
  };

  // Calibration points update handler
  const handleSaveCalibration = async () => {
    setLastActivityTime(Date.now());
    const full = parseFloat(fullWeightInput) || 1200;
    const empty = parseFloat(emptyWeightInput) || 450;
    const vol = parseFloat(volumeInput) || 750;

    const updated = {
      ...calibrations,
      [selectedCalibIng]: { full_weight: full, empty_weight: empty, volume_ml: vol }
    };
    setCalibrations(updated);

    if (isSupabaseConfigured()) {
      try {
        await supabase.from('bar_bottle_calibration').upsert({
          ingredient_id: selectedCalibIng,
          full_weight_grams: full,
          empty_weight_grams: empty,
          full_volume_ml: vol
        });
      } catch (e) {
        console.error("Failed to save calibration to Supabase", e);
      }
    }

    setCalibSaveSuccess(true);
    setTimeout(() => setCalibSaveSuccess(false), 3000);
  };

  // Shift counting submit handler
  const handleSubmitShiftCount = async () => {
    setLastActivityTime(Date.now());
    const entries = Object.entries(shiftCounts);
    const businessDate = '2026-06-16'; // Current business date
    const newRecords: any[] = [];

    for (const [ingId, count] of entries) {
      if (count.full_bottles === 0 && count.scale_grams === 0) continue;

      const derivedVol = getInterpolatedVolume(ingId, count.scale_grams);
      const cal = calibrations[ingId] || { volume_ml: 750 };
      const record = {
        business_date: businessDate,
        ingredient_id: ingId,
        sealed_qty: count.full_bottles,
        open_bottle_grams: count.scale_grams,
        derived_volume_ml: derivedVol,
        shift: currentShift,
        counted_by: activeUser?.name || 'Bartender',
        counted_at: new Date().toISOString().replace('T', ' ').substring(0, 16)
      };
      newRecords.push(record);
    }

    if (newRecords.length === 0) return;

    if (isSupabaseConfigured()) {
      try {
        const payload = newRecords.map(r => ({
          business_date: r.business_date,
          ingredient_id: r.ingredient_id,
          sealed_qty: r.sealed_qty,
          open_bottle_grams: r.open_bottle_grams,
          derived_volume_ml: r.derived_volume_ml,
          shift: r.shift
        }));
        await supabase.from('bar_counts').insert(payload);
      } catch (e) {
        console.error("Supabase insert failed", e);
      }
    }

    // Prepend to display history
    const historyItems = newRecords.map((r, index) => ({
      id: `new-${index}`,
      ...r,
      name: ingredients.find(i => i.id === r.ingredient_id)?.vi_name || r.ingredient_id
    }));
    setPastCounts(prev => [...historyItems, ...prev]);
    setShiftSubmitSuccess(true);

    // Reset counts form
    const resetCounts: Record<string, { full_bottles: number; scale_grams: number }> = {};
    ingredients.forEach(ing => {
      resetCounts[ing.id] = { full_bottles: 0, scale_grams: ing.tare_weight_grams || 450 };
    });
    setShiftCounts(resetCounts);
    setTimeout(() => setShiftSubmitSuccess(false), 4000);
  };

  // Spill / Waste Logging handler
  const handleLogWaste = async () => {
    setLastActivityTime(Date.now());
    const qtyMlVal = parseFloat(wasteQtyMl) || 0;
    const ing = ingredients.find(i => i.id === wasteIngId);
    if (!ing || qtyMlVal <= 0) return;

    // Convert ML to stock unit (Bottle)
    // 1 Bottle = 750ml, so qty in stock unit = ml / 750
    const factor = calibrations[wasteIngId]?.volume_ml || 750;
    const qtyBottles = qtyMlVal / factor;

    const payload = {
      ingredient_id: wasteIngId,
      qty: parseFloat(qtyBottles.toFixed(4)),
      reason: wasteReason,
      status: 'approved',
      is_processed: true,
      created_by: activeUser?.name || 'Bartender'
    };

    if (isSupabaseConfigured()) {
      try {
        await supabase.from('waste_logs').insert([payload]);
      } catch (e) {
        console.error("Supabase waste logging failed", e);
      }
    }

    setWasteSuccess(true);
    setWasteQtyMl('150');
    setTimeout(() => setWasteSuccess(false), 3000);
  };

  // Transfer requesting handler
  const handleLogTransfer = async () => {
    setLastActivityTime(Date.now());
    const qtyVal = parseFloat(transferQty) || 0;
    if (qtyVal <= 0) return;

    const payload = {
      ingredient_id: transferIngId,
      txn_type: 'TRANSFER_IN',
      qty: qtyVal,
      location_id: 'BAR',
      ref_table: 'internal_transfer',
      business_date: '2026-06-16',
      status: 'pending',
      note: `${transferNote} (Yêu cầu bởi ${activeUser?.name})`
    };

    if (isSupabaseConfigured()) {
      try {
        await supabase.from('inventory_transactions').insert([payload]);
      } catch (e) {
        console.error("Supabase transfer insert failed", e);
      }
    }

    setTransferSuccess(true);
    setTransferQty('3');
    setTimeout(() => setTransferSuccess(false), 3000);
  };

  // Calculate Pour Variance based on mock POS sales and shift records
  const pourVarianceReport = useMemo(() => {
    const report: any[] = [];
    const sales: SaleRecord[] = getSales();
    
    // Group sales by ingredient id
    const theoreticalConsumption: Record<string, number> = {}; // in ml
    sales.forEach(sale => {
      const mapping = POS_MAPPING[sale.code];
      if (!mapping || mapping.type !== 'beer') return; // direct items or mixed drinks on quầy bar
      
      const ingId = mapping.recipe;
      const cal = calibrations[ingId] || { volume_ml: 750 };
      
      // Assume direct bottle sales or glass sales
      const saleVol = sale.code.startsWith('GLASS') ? 150 : cal.volume_ml; // 150ml per glass or full bottle
      theoreticalConsumption[ingId] = (theoreticalConsumption[ingId] || 0) + (sale.qty * saleVol);
    });

    ingredients.forEach(ing => {
      // Find closing count and opening count for the ingredient
      const closings = pastCounts.filter(c => c.ingredient_id === ing.id && c.shift === 'CLOSE');
      const openings = pastCounts.filter(c => c.ingredient_id === ing.id && c.shift === 'OPEN');
      
      const lastClosing = closings.length > 0 ? closings[0] : null;
      const lastOpening = openings.length > 0 ? openings[0] : null;
      
      // Opening = 10 bottles, closing = 8 bottles. Actual usage = 2 bottles = 1500ml
      const openVol = lastOpening ? (lastOpening.sealed_qty * (calibrations[ing.id]?.volume_ml || 750) + lastOpening.derived_volume_ml) : 10 * (calibrations[ing.id]?.volume_ml || 750); // mock 10 bottles opening if not counted
      const closeVol = lastClosing ? (lastClosing.sealed_qty * (calibrations[ing.id]?.volume_ml || 750) + lastClosing.derived_volume_ml) : 8.5 * (calibrations[ing.id]?.volume_ml || 750); // mock 8.5 bottles closing if not counted
      
      const actualConsumedMl = Math.max(0, openVol - closeVol);
      const theoreticalConsumedMl = theoreticalConsumption[ing.id] || 0;
      
      const varianceMl = actualConsumedMl - theoreticalConsumedMl;
      const toleranceMl = weightToleranceGrams * (calibrations[ing.id]?.volume_ml || 750) / 100; // tolerance mapped to ml

      const isWithinTolerance = Math.abs(varianceMl) <= toleranceMl;

      report.push({
        id: ing.id,
        name: ing.vi_name,
        actual: actualConsumedMl,
        theoretical: theoreticalConsumedMl,
        variance: varianceMl,
        isOk: isWithinTolerance || varianceMl <= 0
      });
    });

    return report.sort((a, b) => Math.abs(b.variance) - Math.abs(a.variance));
  }, [ingredients, pastCounts, calibrations, weightToleranceGrams]);

  // LOGIN SCREEN
  if (!activeUser) {
    return (
      <div className="min-h-screen bg-bg-main flex flex-col items-center justify-center p-4">
        <div className="w-full max-w-md bg-[#2E3A2C] rounded-2xl border border-[#46553B] shadow-2xl overflow-hidden p-6 text-[#F1EAD9]">
          <div className="text-center mb-6">
            <h1 className="text-3xl font-bold text-center gold-text-gradient mb-1">MAISON VIE</h1>
            <p className="text-xs text-[#C2C9B4] tracking-widest font-semibold uppercase">Cổng Vận Hành Quầy Bar (Tablet Portal)</p>
          </div>

          <div className="mb-4">
            <label className="block text-xs font-semibold text-[#C2C9B4] uppercase mb-1">1. Chọn nhân viên trực ca</label>
            <div className="grid grid-cols-1 gap-2">
              {BAR_USERS.map(user => (
                <button
                  key={user.id}
                  onClick={() => setSelectedUserForLogin(user)}
                  className={`flex items-center justify-between p-3 rounded-lg border text-left transition-all ${
                    selectedUserForLogin?.id === user.id
                      ? 'bg-[#38462F] border-[#B08D4F] text-[#F1EAD9] ring-1 ring-[#B08D4F]'
                      : 'bg-[#2E3A2C] border-[#46553B] text-[#C2C9B4] hover:bg-[#38462F]'
                  }`}
                >
                  <div className="flex items-center gap-3">
                    <UserCheck className={`w-5 h-5 ${selectedUserForLogin?.id === user.id ? 'text-[#B08D4F]' : 'text-[#6B7560]'}`} />
                    <div>
                      <p className="font-semibold text-sm">{user.name}</p>
                      <p className="text-[10px] opacity-75">{user.role === 'BAR_SUPERVISOR' ? 'Trưởng ca / Giám sát Bar' : 'Nhân viên pha chế'}</p>
                    </div>
                  </div>
                  <div className={`w-3 h-3 rounded-full border ${selectedUserForLogin?.id === user.id ? 'bg-[#B08D4F] border-[#B08D4F]' : 'border-[#46553B]'}`} />
                </button>
              ))}
            </div>
          </div>

          <div className="mb-4">
            <label className="block text-xs font-semibold text-[#C2C9B4] uppercase mb-2 text-center">
              2. Nhập mã PIN (4 số) của {selectedUserForLogin?.name.split(' ').slice(-1)}
            </label>
            <div className="flex justify-center gap-3 mb-4">
              {[0, 1, 2, 3].map(index => (
                <div
                  key={index}
                  className={`w-10 h-10 rounded-full border flex items-center justify-center text-lg font-bold ${
                    pinInput.length > index
                      ? 'bg-[#B08D4F] border-[#B08D4F] text-[#2E3A2C]'
                      : 'border-[#46553B] bg-[#2E3A2C]'
                  }`}
                >
                  {pinInput.length > index ? '●' : ''}
                </div>
              ))}
            </div>
            {pinError && <p className="text-red-400 text-xs text-center font-medium mt-1 mb-2">{pinError}</p>}
          </div>

          {/* Numeric Keypad */}
          <div className="grid grid-cols-3 gap-2 max-w-[280px] mx-auto mb-4">
            {['1', '2', '3', '4', '5', '6', '7', '8', '9'].map(num => (
              <button
                key={num}
                onClick={() => handlePinPress(num)}
                className="w-16 h-16 rounded-full bg-[#38462F] hover:bg-[#46553B] border border-[#46553B] flex items-center justify-center text-xl font-bold text-[#F1EAD9] transition-all active:scale-95 mx-auto"
              >
                {num}
              </button>
            ))}
            <button
              onClick={handlePinClear}
              className="w-16 h-16 rounded-full bg-[#2E3A2C] border border-[#46553B] flex items-center justify-center text-xs font-bold text-[#C2C9B4] hover:bg-[#38462F] transition-all mx-auto"
            >
              XÓA
            </button>
            <button
              onClick={() => handlePinPress('0')}
              className="w-16 h-16 rounded-full bg-[#38462F] hover:bg-[#46553B] border border-[#46553B] flex items-center justify-center text-xl font-bold text-[#F1EAD9] transition-all active:scale-95 mx-auto"
            >
              0
            </button>
            <button
              onClick={() => router.push('/')}
              className="w-16 h-16 rounded-full bg-[#2E3A2C] border border-[#46553B] flex items-center justify-center text-[10px] font-bold text-[#B08D4F] hover:bg-[#38462F] transition-all mx-auto uppercase"
            >
              QUAY LẠI
            </button>
          </div>
        </div>
      </div>
    );
  }

  // PORTAL MAIN SCREEN
  return (
    <div className="min-h-screen bg-bg-main flex flex-col text-text-dark">
      {/* Header */}
      <header className="bg-[#2E3A2C] border-b border-[#46553B] p-4 text-[#F1EAD9] sticky top-0 z-40">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Wine className="w-8 h-8 text-[#B08D4F]" />
            <div>
              <h1 className="text-2xl font-bold leading-tight gold-text-gradient">MAISON VIE — QUẦY BAR</h1>
              <p className="text-[10px] text-[#C2C9B4] font-semibold uppercase tracking-wider">Cổng thiết bị kiểm soát chai dở & hao hụt rót</p>
            </div>
          </div>
          
          <div className="flex items-center gap-3">
            <div className="text-right hidden sm:block">
              <p className="text-xs font-semibold text-[#F1EAD9]">{activeUser.name}</p>
              <p className="text-[10px] text-[#C2C9B4] font-semibold uppercase tracking-wider">{activeUser.role}</p>
            </div>
            
            <button 
              onClick={handleLogout}
              className="flex items-center gap-2 px-3 py-1.5 bg-[#38462F] hover:bg-[#B23A2E] text-xs font-bold rounded-lg border border-[#46553B] transition-all"
            >
              <LogOut className="w-3.5 h-3.5" />
              <span>ĐĂNG XUẤT</span>
            </button>
          </div>
        </div>
      </header>

      {/* Main Grid Layout */}
      <main className="flex-1 max-w-7xl w-full mx-auto p-4 grid grid-cols-1 lg:grid-cols-3 gap-6">
        
        {/* COL 1: 2-Point Calibration scale weighing */}
        <section className="bg-[#2E3A2C] rounded-2xl border border-[#46553B] p-5 text-[#F1EAD9] flex flex-col gap-4">
          <div className="flex items-center gap-2 border-b border-[#46553B] pb-3">
            <Scale className="w-6 h-6 text-[#B08D4F]" />
            <h2 className="text-xl font-bold font-serif">1. Hiệu chuẩn Cân dở 2 điểm</h2>
          </div>

          <div>
            <label className="block text-xs font-semibold text-[#C2C9B4] uppercase mb-1">Chọn Rượu/Đồ uống cân dở</label>
            <select
              value={selectedCalibIng}
              onChange={(e) => setSelectedCalibIng(e.target.value)}
              className="w-full bg-[#38462F] border border-[#46553B] rounded-lg p-2.5 text-sm font-semibold text-[#F1EAD9] focus:outline-none focus:ring-1 focus:ring-[#B08D4F]"
            >
              {ingredients.map(ing => (
                <option key={ing.id} value={ing.id}>{ing.vi_name} ({ing.unit})</option>
              ))}
            </select>
          </div>

          {/* Scale Weight simulation */}
          <div className="bg-[#232B20] p-4 rounded-xl border border-[#46553B] flex flex-col items-center justify-center text-center">
            <p className="text-xs text-[#C2C9B4] uppercase font-bold tracking-widest mb-1">Màn hình cân điện tử</p>
            <div className="flex items-baseline gap-1.5 mb-2">
              <span className="text-4xl font-extrabold text-[#F1EAD9] font-mono">{scaleReadingGrams}</span>
              <span className="text-sm font-bold text-[#B08D4F] font-mono">g</span>
            </div>
            
            <input
              type="range"
              min="400"
              max="1700"
              value={scaleReadingGrams}
              onChange={(e) => setScaleReadingGrams(e.target.value)}
              className="w-full accent-[#B08D4F] cursor-pointer mb-2"
            />
            <span className="text-[10px] text-[#C2C9B4]">Kéo thanh trượt để giả lập đặt chai lên cân thực tế</span>
          </div>

          {/* Interpolated Volume display */}
          <div className="bg-[#38462F] p-4 rounded-xl border border-[#46553B] text-center">
            <p className="text-xs text-[#C2C9B4] uppercase font-bold tracking-widest mb-1">Thể tích nội suy (2-Point)</p>
            <div className="flex items-baseline justify-center gap-1.5">
              <span className="text-3xl font-extrabold text-[#B08D4F] font-mono">
                {getInterpolatedVolume(selectedCalibIng, parseFloat(scaleReadingGrams) || 0)}
              </span>
              <span className="text-sm font-bold text-[#F1EAD9] font-mono">ml</span>
            </div>
            <p className="text-[10px] text-[#C2C9B4] mt-1">
              Chiếm {(getInterpolatedVolume(selectedCalibIng, parseFloat(scaleReadingGrams) || 0) / (calibrations[selectedCalibIng]?.volume_ml || 750) * 100).toFixed(0)}% dung tích chai
            </p>
          </div>

          {/* Edit Calibration parameters */}
          <div className="border-t border-[#46553B] pt-3 flex flex-col gap-3">
            <h3 className="text-sm font-bold text-[#B08D4F] uppercase tracking-wider">Thông số hiệu chuẩn 2 điểm</h3>
            
            <div className="grid grid-cols-3 gap-2">
              <div>
                <label className="block text-[9px] text-[#C2C9B4] uppercase font-bold mb-1">1. Đầy (g)</label>
                <input
                  type="number"
                  value={fullWeightInput}
                  onChange={(e) => setFullWeightInput(e.target.value)}
                  className="w-full bg-[#38462F] border border-[#46553B] rounded p-1.5 text-xs text-center font-bold focus:outline-none"
                />
              </div>
              <div>
                <label className="block text-[9px] text-[#C2C9B4] uppercase font-bold mb-1">2. Rỗng (g)</label>
                <input
                  type="number"
                  value={emptyWeightInput}
                  onChange={(e) => setEmptyWeightInput(e.target.value)}
                  className="w-full bg-[#38462F] border border-[#46553B] rounded p-1.5 text-xs text-center font-bold focus:outline-none"
                />
              </div>
              <div>
                <label className="block text-[9px] text-[#C2C9B4] uppercase font-bold mb-1">3. Dung tích (ml)</label>
                <input
                  type="number"
                  value={volumeInput}
                  onChange={(e) => setVolumeInput(e.target.value)}
                  className="w-full bg-[#38462F] border border-[#46553B] rounded p-1.5 text-xs text-center font-bold focus:outline-none"
                />
              </div>
            </div>

            <button
              onClick={handleSaveCalibration}
              className="w-full py-2 bg-[#B08D4F] hover:bg-[#9A7B3F] text-xs font-bold rounded-lg text-[#2E3A2C] transition-all flex items-center justify-center gap-1"
            >
              <RefreshCw className="w-3.5 h-3.5" />
              CẬP NHẬT HIỆU CHUẨN CHAI
            </button>
            {calibSaveSuccess && (
              <p className="text-[#3E7A52] text-xs font-semibold text-center">✓ Đã lưu thông số hiệu chuẩn mới vào DB.</p>
            )}
          </div>
        </section>

        {/* COL 2: Shift counting & Stock takes */}
        <section className="bg-[#2E3A2C] rounded-2xl border border-[#46553B] p-5 text-[#F1EAD9] flex flex-col gap-4">
          <div className="flex items-center gap-2 border-b border-[#46553B] pb-3 justify-between">
            <div className="flex items-center gap-2">
              <CheckSquare className="w-6 h-6 text-[#B08D4F]" />
              <h2 className="text-xl font-bold font-serif">2. Kiểm kho Đóng/Mở ca</h2>
            </div>
            
            <div className="flex rounded-lg overflow-hidden border border-[#46553B]">
              <button
                onClick={() => setCurrentShift('OPEN')}
                className={`px-3 py-1 text-[10px] font-bold transition-all ${currentShift === 'OPEN' ? 'bg-[#B08D4F] text-[#2E3A2C]' : 'bg-[#2E3A2C] text-[#C2C9B4]'}`}
              >
                MỞ CA
              </button>
              <button
                onClick={() => setCurrentShift('CLOSE')}
                className={`px-3 py-1 text-[10px] font-bold transition-all ${currentShift === 'CLOSE' ? 'bg-[#B08D4F] text-[#2E3A2C]' : 'bg-[#2E3A2C] text-[#C2C9B4]'}`}
              >
                ĐÓNG CA
              </button>
            </div>
          </div>

          <div className="flex-1 overflow-y-auto max-h-[360px] pr-1 flex flex-col gap-3">
            {ingredients.map(ing => (
              <div key={ing.id} className="p-3 bg-[#38462F] rounded-xl border border-[#46553B] flex flex-col gap-2">
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold">{ing.vi_name}</span>
                  {ing.code && <span className="text-[10px] text-[#C2C9B4] font-mono">{ing.code}</span>}
                </div>
                
                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <label className="block text-[9px] text-[#C2C9B4] uppercase font-bold mb-1">Chai nguyên (seal)</label>
                    <input
                      type="number"
                      placeholder="0"
                      value={shiftCounts[ing.id]?.full_bottles || ''}
                      onChange={(e) => setShiftCounts({
                        ...shiftCounts,
                        [ing.id]: {
                          ...shiftCounts[ing.id],
                          full_bottles: parseInt(e.target.value) || 0
                        }
                      })}
                      className="w-full bg-[#2E3A2C] border border-[#46553B] rounded p-1.5 text-xs font-bold text-center text-[#F1EAD9] focus:outline-none"
                    />
                  </div>
                  <div>
                    <label className="block text-[9px] text-[#C2C9B4] uppercase font-bold mb-1">Cân chai dở (g)</label>
                    <div className="relative">
                      <input
                        type="number"
                        placeholder="450"
                        value={shiftCounts[ing.id]?.scale_grams || ''}
                        onChange={(e) => setShiftCounts({
                          ...shiftCounts,
                          [ing.id]: {
                            ...shiftCounts[ing.id],
                            scale_grams: parseFloat(e.target.value) || 0
                          }
                        })}
                        className="w-full bg-[#2E3A2C] border border-[#46553B] rounded p-1.5 text-xs font-bold text-center text-[#F1EAD9] focus:outline-none pr-6"
                      />
                      <span className="absolute right-2 top-2 text-[9px] text-[#C2C9B4]">g</span>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>

          <button
            onClick={handleSubmitShiftCount}
            className="w-full py-2.5 bg-[#B08D4F] hover:bg-[#9A7B3F] text-sm font-bold rounded-lg text-[#2E3A2C] transition-all flex items-center justify-center gap-1.5"
          >
            <Send className="w-4 h-4" />
            NỘP PHIẾU ĐẾM QUẦY BAR
          </button>
          {shiftSubmitSuccess && (
            <p className="text-[#3E7A52] text-xs font-semibold text-center">✓ Đã nộp và lưu trữ phiếu đếm ca thành công.</p>
          )}
        </section>

        {/* COL 3: Variance & Waste & Transfers */}
        <section className="bg-[#2E3A2C] rounded-2xl border border-[#46553B] p-5 text-[#F1EAD9] flex flex-col gap-4">
          {/* Settings Tab Selector */}
          <div className="flex border-b border-[#46553B] pb-2">
            <button
              onClick={() => setSelectedSettingsTab('calib')}
              className={`flex-1 pb-1.5 text-xs font-bold text-center transition-all ${selectedSettingsTab === 'calib' ? 'text-[#B08D4F] border-b-2 border-[#B08D4F]' : 'text-[#C2C9B4] hover:text-[#F1EAD9]'}`}
            >
              Hao Hụt Rót
            </button>
            <button
              onClick={() => setSelectedSettingsTab('tolerance')}
              className={`flex-1 pb-1.5 text-xs font-bold text-center transition-all ${selectedSettingsTab === 'tolerance' ? 'text-[#B08D4F] border-b-2 border-[#B08D4F]' : 'text-[#C2C9B4] hover:text-[#F1EAD9]'}`}
            >
              Hủy / Chuyển
            </button>
            <button
              onClick={() => setSelectedSettingsTab('history')}
              className={`flex-1 pb-1.5 text-xs font-bold text-center transition-all ${selectedSettingsTab === 'history' ? 'text-[#B08D4F] border-b-2 border-[#B08D4F]' : 'text-[#C2C9B4] hover:text-[#F1EAD9]'}`}
            >
              Lịch sử đếm
            </button>
          </div>

          {/* TAB 1: Pour Variance Report */}
          {selectedSettingsTab === 'calib' && (
            <div className="flex-1 flex flex-col gap-3">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold text-[#C2C9B4] uppercase tracking-wide">Báo cáo Pour Variance ca hiện tại</span>
                <span className="text-[10px] bg-[#38462F] px-2 py-0.5 rounded text-[#B08D4F] font-bold">Dung sai: ±{weightToleranceGrams}%</span>
              </div>

              <div className="flex-1 overflow-y-auto max-h-[300px] pr-1 flex flex-col gap-2">
                {pourVarianceReport.map(item => (
                  <div key={item.id} className="p-3 bg-[#38462F] rounded-xl border border-[#46553B] flex items-center justify-between text-xs">
                    <div>
                      <p className="font-bold">{item.name}</p>
                      <p className="text-[10px] text-[#C2C9B4]">Tiêu thụ: {item.actual}ml | POS: {item.theoretical}ml</p>
                    </div>
                    <div className="text-right">
                      <span className={`font-mono font-bold px-2 py-1 rounded ${
                        item.isOk 
                          ? 'bg-[#E4EFE5] text-[#3E7A52]' 
                          : 'bg-[#F3DAD3] text-[#B23A2E]'
                      }`}>
                        {item.variance > 0 ? `+${item.variance}` : item.variance} ml
                      </span>
                    </div>
                  </div>
                ))}
              </div>

              {/* Configure Weight Tolerance Slider */}
              <div className="border-t border-[#46553B] pt-3">
                <label className="block text-xs font-semibold text-[#C2C9B4] uppercase mb-1">
                  Định cấu hình dung sai rót: ±{weightToleranceGrams}%
                </label>
                <input
                  type="range"
                  min="2"
                  max="10"
                  value={weightToleranceGrams}
                  onChange={(e) => setWeightToleranceGrams(parseInt(e.target.value))}
                  className="w-full accent-[#B08D4F] cursor-pointer"
                />
                <span className="text-[9px] text-[#C2C9B4]">Cấp 2/Cấp 1 có thể điều chỉnh để lọc nhiễu cảnh báo variance</span>
              </div>
            </div>
          )}

          {/* TAB 2: Spills & internal transfers */}
          {selectedSettingsTab === 'tolerance' && (
            <div className="flex-1 flex flex-col gap-4 overflow-y-auto max-h-[380px] pr-1">
              
              {/* Form 1: Spills / Waste logging */}
              <div className="p-4 bg-[#38462F] rounded-xl border border-[#46553B] flex flex-col gap-2">
                <h3 className="text-xs font-bold text-[#B08D4F] uppercase tracking-wider border-b border-[#46553B] pb-1.5">
                  Ghi nhận Rót đổ / Bể vỡ (Spills)
                </h3>
                <div>
                  <label className="block text-[9px] text-[#C2C9B4] uppercase mb-1">Sản phẩm bị hao hụt</label>
                  <select
                    value={wasteIngId}
                    onChange={(e) => setWasteIngId(e.target.value)}
                    className="w-full bg-[#2E3A2C] border border-[#46553B] rounded p-1.5 text-xs text-[#F1EAD9]"
                  >
                    {ingredients.map(ing => (
                      <option key={ing.id} value={ing.id}>{ing.vi_name}</option>
                    ))}
                  </select>
                </div>
                <div className="grid grid-cols-2 gap-2">
                  <div>
                    <label className="block text-[9px] text-[#C2C9B4] uppercase mb-1">Lượng mất (ml)</label>
                    <input
                      type="number"
                      value={wasteQtyMl}
                      onChange={(e) => setWasteQtyMl(e.target.value)}
                      className="w-full bg-[#2E3A2C] border border-[#46553B] rounded p-1.5 text-xs font-bold text-center text-[#F1EAD9]"
                    />
                  </div>
                  <div>
                    <label className="block text-[9px] text-[#C2C9B4] uppercase mb-1">Lý do</label>
                    <select
                      value={wasteReason}
                      onChange={(e) => setWasteReason(e.target.value)}
                      className="w-full bg-[#2E3A2C] border border-[#46553B] rounded p-1.5 text-xs text-[#F1EAD9]"
                    >
                      <option value="Spill (Rót đổ/tràn)">Spill (Rót đổ/tràn)</option>
                      <option value="Breakage (Bể chai)">Breakage (Bể chai)</option>
                      <option value="Comp (Tặng khách lẻ)">Comp (Tặng khách lẻ)</option>
                      <option value="RD (Thử đồ mới)">R&D (Thử đồ mới)</option>
                    </select>
                  </div>
                </div>
                <button
                  onClick={handleLogWaste}
                  className="w-full py-1.5 bg-[#B23A2E] hover:bg-red-700 text-xs font-bold rounded text-[#F1EAD9] transition-all flex items-center justify-center gap-1"
                >
                  <Trash2 className="w-3 h-3" />
                  KÝ DUYỆT PHIẾU HỦY
                </button>
                {wasteSuccess && <p className="text-[#3E7A52] text-[10px] text-center font-bold">✓ Đã ghi nhận phiếu hao hụt vào DB.</p>}
              </div>

              {/* Form 2: Request internal transfers */}
              <div className="p-4 bg-[#38462F] rounded-xl border border-[#46553B] flex flex-col gap-2">
                <h3 className="text-xs font-bold text-[#B08D4F] uppercase tracking-wider border-b border-[#46553B] pb-1.5">
                  Yêu cầu Chuyển kho (Cấp hàng)
                </h3>
                <div>
                  <label className="block text-[9px] text-[#C2C9B4] uppercase mb-1">Nguyên liệu cần cấp</label>
                  <select
                    value={transferIngId}
                    onChange={(e) => setTransferIngId(e.target.value)}
                    className="w-full bg-[#2E3A2C] border border-[#46553B] rounded p-1.5 text-xs text-[#F1EAD9]"
                  >
                    {ingredients.map(ing => (
                      <option key={ing.id} value={ing.id}>{ing.vi_name}</option>
                    ))}
                  </select>
                </div>
                <div className="grid grid-cols-2 gap-2">
                  <div>
                    <label className="block text-[9px] text-[#C2C9B4] uppercase mb-1">Số lượng đặt (Chai/Lon)</label>
                    <input
                      type="number"
                      value={transferQty}
                      onChange={(e) => setTransferQty(e.target.value)}
                      className="w-full bg-[#2E3A2C] border border-[#46553B] rounded p-1.5 text-xs font-bold text-center text-[#F1EAD9]"
                    />
                  </div>
                  <div>
                    <label className="block text-[9px] text-[#C2C9B4] uppercase mb-1">Từ kho</label>
                    <input
                      type="text"
                      disabled
                      value="Kho tổng (MAIN)"
                      className="w-full bg-[#2E3A2C] border border-[#46553B] rounded p-1.5 text-xs text-[#C2C9B4] text-center opacity-70"
                    />
                  </div>
                </div>
                <button
                  onClick={handleLogTransfer}
                  className="w-full py-1.5 bg-[#B08D4F] hover:bg-[#9A7B3F] text-xs font-bold rounded text-[#2E3A2C] transition-all flex items-center justify-center gap-1"
                >
                  <RefreshCw className="w-3.5 h-3.5" />
                  GỬI YÊU CẦU CẤP HÀNG
                </button>
                {transferSuccess && <p className="text-[#3E7A52] text-[10px] text-center font-bold">✓ Yêu cầu cấp hàng đã được ghi nhận.</p>}
              </div>

            </div>
          )}

          {/* TAB 3: Historical Shift Counts */}
          {selectedSettingsTab === 'history' && (
            <div className="flex-1 flex flex-col gap-3">
              <span className="text-xs font-bold text-[#C2C9B4] uppercase tracking-wide">Nhật ký đếm ca gần đây</span>
              <div className="flex-1 overflow-y-auto max-h-[360px] pr-1 flex flex-col gap-2">
                {pastCounts.map(c => (
                  <div key={c.id} className="p-3 bg-[#38462F] rounded-xl border border-[#46553B] flex flex-col gap-1 text-xs">
                    <div className="flex items-center justify-between font-bold">
                      <span>{c.name}</span>
                      <span className={`px-1.5 py-0.5 rounded text-[8px] font-bold ${
                        c.shift === 'CLOSE' ? 'bg-[#F3DAD3] text-[#B23A2E]' : 'bg-[#E4EFE5] text-[#3E7A52]'
                      }`}>
                        {c.shift === 'CLOSE' ? 'ĐÓNG CA' : 'MỞ CA'}
                      </span>
                    </div>
                    <div className="flex justify-between text-[10px] text-[#C2C9B4] font-mono">
                      <span>Tồn: {c.sealed_qty} chai seal + {c.open_bottle_grams}g ({c.derived_volume_ml}ml)</span>
                      <span>{c.counted_at}</span>
                    </div>
                    <p className="text-[9px] text-[#C2C9B4] italic">Người đếm: {c.counted_by}</p>
                  </div>
                ))}
              </div>
            </div>
          )}
        </section>

      </main>

      {/* Footer copyright */}
      <footer className="bg-[#2E3A2C] border-t border-[#46553B] p-3 text-center text-[#C2C9B4] text-[10px] font-semibold tracking-wider">
        MAISON VIE RESTAURANT • HỆ THỐNG KIỂM SOÁT KHO & HAO HỤT RÓT HÓA ĐƠN VẬN HÀNH v9.4
      </footer>
    </div>
  );
}
