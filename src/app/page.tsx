'use client';

import React, { useState, useMemo } from 'react';
import { 
  LayoutDashboard, 
  UploadCloud, 
  Package, 
  BookOpen, 
  CheckSquare, 
  Search, 
  AlertTriangle, 
  TrendingUp, 
  DollarSign, 
  Settings, 
  ArrowRight, 
  FileText,
  UserCheck,
  ChevronRight,
  Filter,
  CheckCircle,
  RefreshCw
} from 'lucide-react';

import { 
  getIngredients, 
  getRecipes, 
  getSales, 
  getSalesSummary, 
  getSimulatedConsumption, 
  POS_MAPPING, 
  SET_MENU_DEFINITIONS,
  Ingredient,
  Recipe,
  SaleRecord
} from '../data/mockData';

export default function Home() {
  const [activeTab, setActiveTab] = useState<'dashboard' | 'sales' | 'inventory' | 'recipes' | 'stockcount'>('dashboard');
  const [searchQuery, setSearchQuery] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('ALL');
  const [recipeType, setRecipeType] = useState<'alc' | 'deg'>('alc');
  const [selectedRecipe, setSelectedRecipe] = useState<string | null>('R-001');
  const [searchRecipe, setSearchRecipe] = useState('');
  const [isImporting, setIsImporting] = useState(false);
  const [importSuccess, setImportSuccess] = useState(false);
  const [salesData, setSalesData] = useState<SaleRecord[]>(getSales());

  // Stock count state - initialize with empty strings (represents not counted yet)
  const [actualStocks, setActualStocks] = useState<Record<string, string>>({
    "ING-003": "15.5", // Black cod - Opening stock assumed 20kg, consumed 5.15kg, actual counted 15.5kg
    "ING-093": "22.0", // Black angus
    "ING-013": "8.5",  // Lamb rack
    "ING-017": "12.0", // Butter Isigny
    "ING-025": "4.2",  // Mushroom Tam Dao
  });

  // Load static data
  const ingredients = useMemo(() => getIngredients(), []);
  const recipes = useMemo(() => getRecipes(), []);
  
  // Calculate consumption based on current sales data
  const consumptionData = useMemo(() => {
    const ingMap = new Map<string, Ingredient>();
    ingredients.forEach(i => ingMap.set(i.id, i));
    
    const consumption: Record<string, number> = {};

    salesData.forEach(sale => {
      const mapping = POS_MAPPING[sale.code];
      if (!mapping) return;

      const qty = sale.qty;
      const { recipe, type } = mapping;

      if (type === 'beer') {
        consumption[recipe] = (consumption[recipe] || 0) + qty;
      } else if (type === 'alc') {
        const r = recipes[recipe];
        if (r && r.ingredients) {
          r.ingredients.forEach(ing => {
            const totalDeduction = ing.qty_eff * qty * 1.10; // 10% wastage buffer
            consumption[ing.ing_id] = (consumption[ing.ing_id] || 0) + totalDeduction;
          });
        }
      } else if (type === 'set') {
        const subRecipes = SET_MENU_DEFINITIONS[recipe] || [];
        subRecipes.forEach(sub => {
          const r = recipes[sub];
          if (r && r.ingredients) {
            r.ingredients.forEach(ing => {
              const totalDeduction = ing.qty_eff * qty * 1.10;
              consumption[ing.ing_id] = (consumption[ing.ing_id] || 0) + totalDeduction;
            });
          }
        });
      }
    });

    return Object.entries(consumption).map(([ingId, qty]) => {
      const ing = ingMap.get(ingId);
      const price = ing ? ing.price : 0;
      const name = ing ? ing.vi_name : (ingId.startsWith("ING-BEER") ? `Bia ${ingId}` : "Chưa xác định");
      const unit = ing ? ing.unit : "cái";
      const category = ing ? ing.category : "Khác";

      return {
        id: ingId,
        name,
        qty,
        unit,
        category,
        unitPrice: price,
        totalCost: qty * price
      };
    }).sort((a, b) => b.totalCost - a.totalCost);
  }, [salesData, ingredients, recipes]);

  // Calculate total costs and metrics
  const metrics = useMemo(() => {
    let totalRevenue = 0;
    let totalDiscount = 0;
    salesData.forEach(s => {
      totalRevenue += s.total_before_discount;
      totalDiscount += s.discount;
    });

    let totalIngredientCost = 0;
    consumptionData.forEach(c => {
      totalIngredientCost += c.totalCost;
    });

    // Calculate total actual value & variance cost
    let totalVarianceCost = 0;
    ingredients.forEach(ing => {
      const actualVal = actualStocks[ing.id];
      if (actualVal && !isNaN(parseFloat(actualVal))) {
        // Let's assume a mock theoretical stock for calculation
        // Theoretical stock = Opening (e.g. 30kg) - Consumption
        const mockOpening = 30; // standard mock opening
        const consumed = consumptionData.find(c => c.id === ing.id)?.qty || 0;
        const theoretical = Math.max(0, mockOpening - consumed);
        const actual = parseFloat(actualVal);
        const variance = actual - theoretical;
        totalVarianceCost += variance * ing.price;
      }
    });

    const foodCostPercentage = totalRevenue > 0 ? (totalIngredientCost / (totalRevenue - totalDiscount)) * 100 : 0;

    return {
      salesRevenue: totalRevenue,
      salesDiscount: totalDiscount,
      netSales: totalRevenue - totalDiscount,
      ingredientCost: totalIngredientCost,
      foodCostPct: foodCostPercentage,
      varianceCost: totalVarianceCost,
      inventoryValue: 112450000 // Mock value representing current total warehouse value
    };
  }, [salesData, consumptionData, ingredients, actualStocks]);

  // Categories list
  const categories = useMemo(() => {
    const cats = new Set<string>();
    ingredients.forEach(i => {
      if (i.category) cats.add(i.category);
    });
    return Array.from(cats);
  }, [ingredients]);

  // Filtering ingredients
  const filteredIngredients = useMemo(() => {
    return ingredients.filter(ing => {
      const matchesSearch = ing.vi_name.toLowerCase().includes(searchQuery.toLowerCase()) || 
                            ing.fr_name.toLowerCase().includes(searchQuery.toLowerCase()) || 
                            ing.id.toLowerCase().includes(searchQuery.toLowerCase());
      const matchesCategory = categoryFilter === 'ALL' || ing.category === categoryFilter;
      return matchesSearch && matchesCategory;
    });
  }, [ingredients, searchQuery, categoryFilter]);

  // Filtered recipes
  const filteredRecipes = useMemo(() => {
    return Object.values(recipes).filter(r => {
      const isTasting = r.code.endsWith('_DEG');
      const matchesType = recipeType === 'deg' ? isTasting : !isTasting;
      const matchesSearch = r.name.toLowerCase().includes(searchRecipe.toLowerCase()) || 
                            r.code.toLowerCase().includes(searchRecipe.toLowerCase());
      return matchesType && matchesSearch;
    });
  }, [recipes, recipeType, searchRecipe]);

  // Get active recipe details
  const activeRecipeDetails = useMemo(() => {
    if (!selectedRecipe) return null;
    const key = recipeType === 'deg' ? `${selectedRecipe}_DEG` : selectedRecipe;
    return recipes[key] || recipes[selectedRecipe] || null;
  }, [recipes, selectedRecipe, recipeType]);

  // Handle mock file import
  const handleImportSales = () => {
    setIsImporting(true);
    setImportSuccess(false);
    setTimeout(() => {
      setIsImporting(false);
      setImportSuccess(true);
      // Double the sales data to simulate new sales imported
      const freshSales = getSales().map(s => ({
        ...s,
        qty: s.qty + Math.floor(Math.random() * 5) // add random sales quantity
      }));
      setSalesData(freshSales);
    }, 2000);
  };

  return (
    <div className="min-h-screen flex flex-col bg-[#090d16] text-gray-100 selection:bg-amber-500 selection:text-black">
      {/* 1. Header (High-End French Neoclassical Styling) */}
      <header className="border-b border-amber-500/20 bg-[#0c1220]/80 backdrop-blur-md sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-6 py-4 flex flex-col md:flex-row items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <div className="relative w-10 h-10 border border-amber-500/50 flex items-center justify-center rounded-sm rotate-45 bg-[#090d16]">
              <span className="text-amber-500 font-serif font-semibold text-lg rotate-[-45deg] scale-90">MV</span>
            </div>
            <div>
              <h1 className="text-2xl font-semibold tracking-widest text-[#d4af37]">MAISON VIE</h1>
              <p className="text-[10px] tracking-[0.2em] text-gray-400 font-sans uppercase">Inventory CRM & Finance Controller</p>
            </div>
          </div>

          <div className="flex items-center gap-4">
            <div className="text-right hidden sm:block">
              <span className="text-[11px] text-gray-400 block font-sans">Kỳ báo cáo (Sales Period)</span>
              <span className="text-xs font-semibold text-amber-500/80">01/06/2026 - 13/06/2026</span>
            </div>
            <div className="h-8 w-[1px] bg-amber-500/20 hidden sm:block"></div>
            <div className="flex items-center gap-2">
              <span className="w-2.5 h-2.5 bg-emerald-500 rounded-full animate-ping"></span>
              <span className="text-xs text-gray-300 font-medium">Bản phẳng đồng bộ (Sync Database Active)</span>
            </div>
          </div>
        </div>
      </header>

      {/* 2. Main Container */}
      <div className="flex-1 max-w-7xl w-full mx-auto px-6 py-8 flex flex-col lg:flex-row gap-8">
        
        {/* Sidebar Nav */}
        <aside className="w-full lg:w-64 flex flex-col gap-3">
          <div className="text-xs font-semibold uppercase tracking-wider text-gray-400 px-3 py-1 font-sans">
            Phân hệ Quản trị (Modules)
          </div>
          <button 
            onClick={() => setActiveTab('dashboard')}
            className={`w-full flex items-center gap-3 px-4 py-3 rounded-md transition-all text-left border text-sm ${
              activeTab === 'dashboard' 
                ? 'bg-amber-500/10 border-amber-500/40 text-amber-400 font-medium' 
                : 'border-transparent text-gray-400 hover:text-gray-200 hover:bg-[#141a29]/50'
            }`}
          >
            <LayoutDashboard size={18} />
            <span>Báo cáo Tổng quan</span>
          </button>
          
          <button 
            onClick={() => setActiveTab('sales')}
            className={`w-full flex items-center gap-3 px-4 py-3 rounded-md transition-all text-left border text-sm ${
              activeTab === 'sales' 
                ? 'bg-amber-500/10 border-amber-500/40 text-amber-400 font-medium' 
                : 'border-transparent text-gray-400 hover:text-gray-200 hover:bg-[#141a29]/50'
            }`}
          >
            <UploadCloud size={18} />
            <span>Doanh số & POS Import</span>
          </button>

          <button 
            onClick={() => setActiveTab('inventory')}
            className={`w-full flex items-center gap-3 px-4 py-3 rounded-md transition-all text-left border text-sm ${
              activeTab === 'inventory' 
                ? 'bg-amber-500/10 border-amber-500/40 text-amber-400 font-medium' 
                : 'border-transparent text-gray-400 hover:text-gray-200 hover:bg-[#141a29]/50'
            }`}
          >
            <Package size={18} />
            <span>Bảng Master Kho (101)</span>
          </button>

          <button 
            onClick={() => setActiveTab('recipes')}
            className={`w-full flex items-center gap-3 px-4 py-3 rounded-md transition-all text-left border text-sm ${
              activeTab === 'recipes' 
                ? 'bg-amber-500/10 border-amber-500/40 text-amber-400 font-medium' 
                : 'border-transparent text-gray-400 hover:text-gray-200 hover:bg-[#141a29]/50'
            }`}
          >
            <BookOpen size={18} />
            <span>Định mức công thức (Recipes)</span>
          </button>

          <button 
            onClick={() => setActiveTab('stockcount')}
            className={`w-full flex items-center gap-3 px-4 py-3 rounded-md transition-all text-left border text-sm ${
              activeTab === 'stockcount' 
                ? 'bg-amber-500/10 border-amber-500/40 text-amber-400 font-medium' 
                : 'border-transparent text-gray-400 hover:text-gray-200 hover:bg-[#141a29]/50'
            }`}
          >
            <CheckSquare size={18} />
            <span>Kiểm kho & Tính Variance</span>
          </button>

          {/* Quick Info Box */}
          <div className="mt-8 glass-panel rounded-md p-4 border-amber-500/10 text-[11px] text-gray-400 leading-relaxed font-sans">
            <h4 className="text-amber-500 font-serif font-semibold text-xs mb-2 tracking-wider">THÔNG TIN HỆ THỐNG</h4>
            <p className="mb-2"><strong>Mô hình trừ kho:</strong> Tồn Lý Thuyết = Tồn Đầu + Tổng Nhập - Xuất Định Mức (Gross Weight * Doanh số POS).</p>
            <p><strong>Wastage Buffer:</strong> Công thức bếp tự cộng thêm 10% để bù hao phí thao tác thực tế.</p>
          </div>
        </aside>

        {/* Content Area */}
        <main className="flex-1 flex flex-col gap-6">

          {/* 3. Global Stats Grid */}
          <section className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-4">
            
            <div className="glass-panel rounded-md p-5 relative overflow-hidden">
              <div className="absolute top-0 right-0 w-24 h-24 bg-amber-500/5 rounded-full blur-2xl"></div>
              <div className="flex items-center justify-between text-gray-400 mb-2">
                <span className="text-xs uppercase tracking-wider font-sans">Tổng Doanh thu POS</span>
                <DollarSign size={16} className="text-amber-500" />
              </div>
              <div className="text-2xl font-bold text-gray-100">{metrics.salesRevenue.toLocaleString()} <span className="text-xs text-amber-500">đ</span></div>
              <div className="text-[10px] text-gray-400 mt-1">Nửa đầu tháng 6 (Chưa trừ CK: {metrics.salesDiscount.toLocaleString()}đ)</div>
            </div>

            <div className="glass-panel rounded-md p-5 relative overflow-hidden">
              <div className="absolute top-0 right-0 w-24 h-24 bg-amber-500/5 rounded-full blur-2xl"></div>
              <div className="flex items-center justify-between text-gray-400 mb-2">
                <span className="text-xs uppercase tracking-wider font-sans">Chi phí Tiêu hao (Cost)</span>
                <TrendingUp size={16} className="text-amber-500" />
              </div>
              <div className="text-2xl font-bold text-gray-100">{metrics.ingredientCost.toLocaleString()} <span className="text-xs text-amber-500">đ</span></div>
              <div className="text-[10px] text-gray-400 mt-1">Food Cost lý thuyết: <span className="text-amber-500 font-semibold">{metrics.foodCostPct.toFixed(1)}%</span></div>
            </div>

            <div className="glass-panel rounded-md p-5 relative overflow-hidden">
              <div className="absolute top-0 right-0 w-24 h-24 bg-amber-500/5 rounded-full blur-2xl"></div>
              <div className="flex items-center justify-between text-gray-400 mb-2">
                <span className="text-xs uppercase tracking-wider font-sans">Giá trị Tồn kho Ước tính</span>
                <Package size={16} className="text-amber-500" />
              </div>
              <div className="text-2xl font-bold text-gray-100">{metrics.inventoryValue.toLocaleString()} <span className="text-xs text-amber-500">đ</span></div>
              <div className="text-[10px] text-gray-400 mt-1">Tổng giá trị kho nguyên liệu tĩnh tại quầy</div>
            </div>

            <div className="glass-panel rounded-md p-5 relative overflow-hidden">
              <div className="absolute top-0 right-0 w-24 h-24 bg-amber-500/5 rounded-full blur-2xl"></div>
              <div className="flex items-center justify-between text-gray-400 mb-2">
                <span className="text-xs uppercase tracking-wider font-sans">Lệch kho (Variance)</span>
                <AlertTriangle size={16} className={metrics.varianceCost < 0 ? "text-rose-500 animate-pulse" : "text-[#d4af37]"} />
              </div>
              <div className={`text-2xl font-bold ${metrics.varianceCost < 0 ? "text-rose-400" : "text-emerald-400"}`}>
                {metrics.varianceCost > 0 ? "+" : ""}{metrics.varianceCost.toLocaleString()} <span className="text-xs">đ</span>
              </div>
              <div className="text-[10px] text-gray-400 mt-1">Tính theo chênh lệch các món đã kiểm kê thực tế</div>
            </div>
          </section>

          {/* 4. Tab Views */}
          
          {/* TAB 1: DASHBOARD */}
          {activeTab === 'dashboard' && (
            <div className="flex flex-col gap-6">
              {/* Cost of Goods Sold Chart & Top Cost Ingredients */}
              <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                
                {/* Simulated Consumption list */}
                <div className="glass-panel rounded-md p-6 lg:col-span-2 flex flex-col gap-4">
                  <div>
                    <h3 className="text-xl font-semibold text-[#d4af37] font-serif">Nguyên liệu tiêu hao nhiều nhất (01/06 - 13/06)</h3>
                    <p className="text-[11px] text-gray-400">Đã bao gồm tỷ lệ hao hụt Yield % và 10% bù bếp</p>
                  </div>
                  
                  {/* Custom SVG Bar Chart */}
                  <div className="h-44 w-full bg-[#0c1220]/50 rounded border border-amber-500/5 p-4 flex items-end justify-between gap-2">
                    {consumptionData.slice(0, 8).map((item, idx) => {
                      const maxVal = Math.max(...consumptionData.slice(0, 8).map(c => c.totalCost));
                      const barHeight = maxVal > 0 ? (item.totalCost / maxVal) * 100 : 0;
                      return (
                        <div key={item.id} className="flex-1 flex flex-col items-center gap-2 group cursor-pointer">
                          <div className="w-full flex items-end justify-center h-28 relative">
                            {/* Hover cost value */}
                            <span className="absolute -top-6 text-[9px] text-amber-400 opacity-0 group-hover:opacity-100 transition-opacity bg-black px-1.5 py-0.5 rounded border border-amber-500/30 whitespace-nowrap">
                              {Math.round(item.totalCost).toLocaleString()}đ
                            </span>
                            <div 
                              style={{ height: `${Math.max(5, barHeight)}%` }}
                              className="w-4 sm:w-6 bg-gradient-to-t from-amber-600 via-amber-400 to-[#f3e5ab] rounded-t-sm transition-all duration-500 hover:shadow-lg hover:shadow-amber-500/20 group-hover:scale-x-110"
                            ></div>
                          </div>
                          <span className="text-[9px] text-gray-400 group-hover:text-amber-300 w-12 text-center truncate">{item.name}</span>
                        </div>
                      );
                    })}
                  </div>

                  <div className="overflow-x-auto">
                    <table className="w-full text-xs text-left text-gray-300">
                      <thead className="bg-[#0c1220] uppercase text-gray-400 border-b border-amber-500/10">
                        <tr>
                          <th className="px-4 py-2">Mã</th>
                          <th className="px-4 py-2">Tên Nguyên Liệu</th>
                          <th className="px-4 py-2 text-right">Lượng tiêu thụ</th>
                          <th className="px-4 py-2 text-right">Đơn giá mua</th>
                          <th className="px-4 py-2 text-right">Thành tiền (VND)</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-amber-500/5">
                        {consumptionData.slice(0, 6).map((item) => (
                          <tr key={item.id} className="hover:bg-[#141a29]/30">
                            <td className="px-4 py-2 font-mono text-amber-500/70">{item.id}</td>
                            <td className="px-4 py-2 font-medium">{item.name}</td>
                            <td className="px-4 py-2 text-right">{item.qty.toFixed(3)} {item.unit}</td>
                            <td className="px-4 py-2 text-right">{item.unitPrice.toLocaleString()} đ</td>
                            <td className="px-4 py-2 text-right font-semibold text-gray-200">{Math.round(item.totalCost).toLocaleString()} đ</td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>

                {/* Live Warnings and Alerts */}
                <div className="glass-panel rounded-md p-6 flex flex-col gap-4">
                  <div>
                    <h3 className="text-xl font-semibold text-[#d4af37] font-serif">Cảnh báo Tồn kho tối thiểu</h3>
                    <p className="text-[11px] text-gray-400">Nguyên liệu sắp chạm mốc cần đặt hàng</p>
                  </div>
                  
                  <div className="flex flex-col gap-3 overflow-y-auto max-h-[350px] pr-2">
                    {ingredients.slice(2, 7).map((ing) => {
                      const consumed = consumptionData.find(c => c.id === ing.id)?.qty || 0;
                      // Simulate a stock check
                      const currentStock = Math.max(0, 30 - consumed);
                      const isLow = currentStock < 20; // Simulated minimum level threshold
                      
                      return (
                        <div key={ing.id} className={`p-3 rounded border flex flex-col gap-1 transition-all ${
                          isLow ? 'bg-amber-500/5 border-amber-500/20' : 'bg-[#141a29]/30 border-gray-800'
                        }`}>
                          <div className="flex items-center justify-between">
                            <span className="font-medium text-xs text-gray-200">{ing.vi_name}</span>
                            {isLow && <span className="flex items-center gap-1 text-[9px] bg-amber-500/10 text-amber-400 border border-amber-500/20 px-1.5 py-0.5 rounded uppercase font-semibold">Low Stock</span>}
                          </div>
                          <div className="flex justify-between items-center text-[10px] text-gray-400 font-mono mt-1">
                            <span>Mã: {ing.id}</span>
                            <span>Tồn hiện tại: <strong className="text-gray-200">{currentStock.toFixed(2)}</strong> {ing.unit}</span>
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* TAB 2: SALES & IMPORT */}
          {activeTab === 'sales' && (
            <div className="glass-panel rounded-md p-6 flex flex-col gap-6">
              <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 border-b border-amber-500/10 pb-4">
                <div>
                  <h3 className="text-xl font-semibold text-[#d4af37] font-serif">Doanh số POS cuối ngày</h3>
                  <p className="text-xs text-gray-400">Dữ liệu bán hàng đồng bộ lý thuyết để tính toán trừ định mức.</p>
                </div>
                
                <div className="flex items-center gap-3">
                  <button 
                    onClick={handleImportSales}
                    disabled={isImporting}
                    className="flex items-center gap-2 bg-gradient-to-r from-amber-600 to-amber-500 hover:from-amber-500 hover:to-[#f3e5ab] text-[#090d16] font-semibold text-xs px-4 py-2.5 rounded-sm transition-all shadow-md active:scale-95 disabled:opacity-50"
                  >
                    {isImporting ? <RefreshCw size={14} className="animate-spin" /> : <UploadCloud size={14} />}
                    <span>{isImporting ? "Đang phân tích..." : "Tải lên file POS mới (.xls)"}</span>
                  </button>
                </div>
              </div>

              {importSuccess && (
                <div className="bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 p-4 rounded text-xs flex items-center gap-2">
                  <CheckCircle size={16} />
                  <span><strong>Import POS thành công!</strong> CRM đã tự động phân rã 3 Set Menu (Tasting) thành 18 món con, khấu trừ 15 nguyên liệu thô tương ứng trên cơ sở dữ liệu.</span>
                </div>
              )}

              {/* POS mapping table summary */}
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6 my-2">
                <div className="p-4 bg-[#0c1220]/50 rounded border border-amber-500/5 flex flex-col">
                  <span className="text-[10px] text-gray-400 uppercase tracking-wider">Cơ cấu bia</span>
                  <span className="text-lg font-bold text-gray-200 mt-1">Đã phân tách</span>
                  <span className="text-[10px] text-emerald-400 mt-1">B5001 (Heineken), B5002 (Tiger) riêng biệt</span>
                </div>
                <div className="p-4 bg-[#0c1220]/50 rounded border border-amber-500/5 flex flex-col">
                  <span className="text-[10px] text-gray-400 uppercase tracking-wider">Set Menu Phân rã (BOM)</span>
                  <span className="text-lg font-bold text-gray-200 mt-1">Cấu hình sẵn</span>
                  <span className="text-[10px] text-emerald-400 mt-1">Tự trừ cá/thịt theo portion Tasting (~67%)</span>
                </div>
                <div className="p-4 bg-[#0c1220]/50 rounded border border-amber-500/5 flex flex-col">
                  <span className="text-[10px] text-gray-400 uppercase tracking-wider">Trạng thái cấu hình</span>
                  <span className="text-lg font-bold text-gray-200 mt-1">Đồng bộ</span>
                  <span className="text-[10px] text-amber-500 mt-1">100% mã POS đã map với Recipe ID</span>
                </div>
              </div>

              <div className="overflow-x-auto">
                <table className="w-full text-xs text-left text-gray-300">
                  <thead className="bg-[#0c1220] uppercase text-gray-400 border-b border-amber-500/10">
                    <tr>
                      <th className="px-4 py-3">Mã POS</th>
                      <th className="px-4 py-3">Tên món trên POS</th>
                      <th className="px-4 py-3 text-right">Đơn giá bán thực tế</th>
                      <th className="px-4 py-3 text-right">Số lượng bán</th>
                      <th className="px-4 py-3 text-right">Tổng tiền bán</th>
                      <th className="px-4 py-3 text-center">Liên kết Recipe</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-amber-500/5">
                    {salesData.slice(0, 15).map((sale, i) => {
                      const mapInfo = POS_MAPPING[sale.code];
                      return (
                        <tr key={i} className="hover:bg-[#141a29]/30">
                          <td className="px-4 py-3 font-mono text-amber-500/70">{sale.code}</td>
                          <td className="px-4 py-3 font-medium text-gray-100">{sale.name}</td>
                          <td className="px-4 py-3 text-right">{sale.price.toLocaleString()} đ</td>
                          <td className="px-4 py-3 text-right font-mono font-semibold">{sale.qty}</td>
                          <td className="px-4 py-3 text-right font-mono text-gray-200">{sale.total_before_discount.toLocaleString()} đ</td>
                          <td className="px-4 py-3 text-center">
                            {mapInfo ? (
                              <span className="inline-block px-2 py-0.5 text-[9px] bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 rounded uppercase font-semibold">
                                {mapInfo.recipe} ({mapInfo.type})
                              </span>
                            ) : (
                              <span className="inline-block px-2 py-0.5 text-[9px] bg-gray-500/10 text-gray-400 border border-gray-500/20 rounded uppercase">Bỏ qua kho</span>
                            )}
                          </td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* TAB 3: INVENTORY MASTER */}
          {activeTab === 'inventory' && (
            <div className="glass-panel rounded-md p-6 flex flex-col gap-6">
              <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 border-b border-amber-500/10 pb-4">
                <div>
                  <h3 className="text-xl font-semibold text-[#d4af37] font-serif">Bảng Master Kho nguyên liệu (101 mã)</h3>
                  <p className="text-xs text-gray-400">Danh mục nguyên liệu và giá vốn đồng bộ từ tab CONFIG của Recipe Master.</p>
                </div>
                
                <div className="flex flex-wrap items-center gap-3 w-full md:w-auto">
                  <div className="relative flex-1 md:flex-none">
                    <Search size={14} className="absolute left-3 top-3 text-gray-400" />
                    <input 
                      type="text"
                      placeholder="Tìm mã / tên..."
                      value={searchQuery}
                      onChange={(e) => setSearchQuery(e.target.value)}
                      className="bg-[#0c1220]/60 border border-amber-500/10 text-xs px-9 py-2.5 rounded-sm focus:outline-none focus:border-amber-500/50 w-full"
                    />
                  </div>

                  <select 
                    value={categoryFilter} 
                    onChange={(e) => setCategoryFilter(e.target.value)}
                    className="bg-[#0c1220]/60 border border-amber-500/10 text-xs px-3 py-2.5 rounded-sm focus:outline-none focus:border-amber-500/50 text-gray-200"
                  >
                    <option value="ALL">Tất cả danh mục (All)</option>
                    {categories.map((cat, i) => (
                      <option key={i} value={cat}>{cat}</option>
                    ))}
                  </select>
                </div>
              </div>

              <div className="overflow-x-auto">
                <table className="w-full text-xs text-left text-gray-300">
                  <thead className="bg-[#0c1220] uppercase text-gray-400 border-b border-amber-500/10">
                    <tr>
                      <th className="px-4 py-3">Mã NVL</th>
                      <th className="px-4 py-3">Tên tiếng Việt</th>
                      <th className="px-4 py-3">Tên tiếng Pháp</th>
                      <th className="px-4 py-3">Danh mục</th>
                      <th className="px-4 py-3 text-center">ĐVT</th>
                      <th className="px-4 py-3 text-right">Giá vốn chuẩn</th>
                      <th className="px-4 py-3 text-center">Yield % (CONFIG)</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-amber-500/5">
                    {filteredIngredients.map((ing) => (
                      <tr key={ing.id} className="hover:bg-[#141a29]/30">
                        <td className="px-4 py-3 font-mono text-amber-500/70 font-semibold">{ing.id}</td>
                        <td className="px-4 py-3 font-medium text-gray-100">{ing.vi_name}</td>
                        <td className="px-4 py-3 text-gray-400 italic">{ing.fr_name}</td>
                        <td className="px-4 py-3 text-gray-400">{ing.category}</td>
                        <td className="px-4 py-3 text-center text-gray-300 font-medium">{ing.unit}</td>
                        <td className="px-4 py-3 text-right font-mono font-semibold text-amber-500/80">{ing.price.toLocaleString()} đ</td>
                        <td className="px-4 py-3 text-center font-mono text-gray-300">{(ing.yield_rate * 100).toFixed(0)}%</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* TAB 4: RECIPES */}
          {activeTab === 'recipes' && (
            <div className="grid grid-cols-1 xl:grid-cols-3 gap-6">
              
              {/* Recipe List */}
              <div className="glass-panel rounded-md p-6 flex flex-col gap-4 xl:col-span-1">
                <div className="border-b border-amber-500/10 pb-4">
                  <h3 className="text-xl font-semibold text-[#d4af37] font-serif">Định mức món ăn (Recipes)</h3>
                  
                  {/* À La Carte vs Tasting Portions Toggle */}
                  <div className="flex gap-2 mt-4 bg-[#0c1220]/60 p-1 rounded border border-amber-500/10">
                    <button 
                      onClick={() => setRecipeType('alc')}
                      className={`flex-1 text-center py-1.5 text-[11px] rounded transition-all uppercase font-semibold ${
                        recipeType === 'alc' ? 'bg-amber-500/15 text-amber-400' : 'text-gray-400 hover:text-gray-200'
                      }`}
                    >
                      À La Carte (Portion Đầy đủ)
                    </button>
                    <button 
                      onClick={() => setRecipeType('deg')}
                      className={`flex-1 text-center py-1.5 text-[11px] rounded transition-all uppercase font-semibold ${
                        recipeType === 'deg' ? 'bg-amber-500/15 text-amber-400' : 'text-gray-400 hover:text-gray-200'
                      }`}
                    >
                      Dégustation (Portion Tasting)
                    </button>
                  </div>

                  <div className="relative mt-3">
                    <Search size={13} className="absolute left-3 top-3 text-gray-400" />
                    <input 
                      type="text"
                      placeholder="Tìm kiếm công thức..."
                      value={searchRecipe}
                      onChange={(e) => setSearchRecipe(e.target.value)}
                      className="bg-[#0c1220]/60 border border-amber-500/10 text-xs px-9 py-2.5 rounded-sm focus:outline-none focus:border-amber-500/50 w-full"
                    />
                  </div>
                </div>

                <div className="flex flex-col gap-2 overflow-y-auto max-h-[450px] pr-2">
                  {filteredRecipes.map((r) => {
                    const displayCode = r.code.replace('_DEG', '');
                    const isSelected = selectedRecipe === displayCode;
                    return (
                      <button
                        key={r.code}
                        onClick={() => setSelectedRecipe(displayCode)}
                        className={`w-full p-3 text-left rounded border flex items-center justify-between transition-all ${
                          isSelected 
                            ? 'bg-amber-500/5 border-amber-500/40 text-amber-400' 
                            : 'bg-[#141a29]/30 border-gray-800 text-gray-300 hover:bg-[#141a29]/60 hover:text-gray-100'
                        }`}
                      >
                        <div className="flex flex-col gap-1 min-w-0 pr-2">
                          <span className="font-serif font-semibold text-sm truncate">{r.name}</span>
                          <div className="flex items-center gap-2 text-[10px] text-gray-400 font-mono">
                            <span>Mã: {r.code}</span>
                            <span>•</span>
                            <span>{r.course}</span>
                          </div>
                        </div>
                        <ChevronRight size={14} className={isSelected ? 'text-amber-400' : 'text-gray-500'} />
                      </button>
                    );
                  })}
                </div>
              </div>

              {/* Recipe Details View */}
              <div className="glass-panel rounded-md p-6 xl:col-span-2 flex flex-col gap-6">
                {activeRecipeDetails ? (
                  <>
                    <div className="border-b border-amber-500/10 pb-4 flex flex-col md:flex-row md:items-center justify-between gap-4">
                      <div>
                        <div className="flex items-center gap-2">
                          <span className="font-mono text-xs text-amber-500/70 border border-amber-500/20 px-2 py-0.5 rounded uppercase font-semibold">
                            {activeRecipeDetails.code}
                          </span>
                          <span className="text-xs text-gray-400">• {activeRecipeDetails.course}</span>
                        </div>
                        <h2 className="text-2xl font-semibold text-[#d4af37] font-serif mt-1">{activeRecipeDetails.name}</h2>
                      </div>
                      
                      {activeRecipeDetails.price > 0 && (
                        <div className="text-right">
                          <span className="text-[10px] text-gray-400 uppercase tracking-wider block">Giá bán thực đơn lẻ</span>
                          <span className="text-lg font-bold text-gray-100">{activeRecipeDetails.price.toLocaleString()} đ</span>
                        </div>
                      )}
                    </div>

                    {/* Ingredients Table */}
                    <div>
                      <h3 className="text-lg font-serif font-semibold text-[#d4af37] mb-3">Định lượng & Giá vốn thành phần (Yield & Loss applied)</h3>
                      <div className="overflow-x-auto">
                        <table className="w-full text-xs text-left text-gray-300">
                          <thead className="bg-[#0c1220] uppercase text-gray-400 border-b border-amber-500/10">
                            <tr>
                              <th className="px-4 py-2">Mã NVL</th>
                              <th className="px-4 py-2">Tên tiếng Việt</th>
                              <th className="px-4 py-2 text-right">Lượng Net</th>
                              <th className="px-4 py-2 text-center">Yield %</th>
                              <th className="px-4 py-2 text-right">Lượng Thô (Deducted)</th>
                              <th className="px-4 py-2 text-right">Giá/ĐVT</th>
                              <th className="px-4 py-2 text-right">Chi phí</th>
                            </tr>
                          </thead>
                          <tbody className="divide-y divide-amber-500/5">
                            {activeRecipeDetails.ingredients.map((ing, i) => {
                              const details = ingredients.find(x => x.id === ing.ing_id);
                              return (
                                <tr key={i} className="hover:bg-[#141a29]/30">
                                  <td className="px-4 py-2 font-mono text-amber-500/70">{ing.ing_id}</td>
                                  <td className="px-4 py-2 font-medium">{details?.vi_name || "Bán thành phẩm"}</td>
                                  <td className="px-4 py-2 text-right">{ing.qty_net.toFixed(3)} {ing.unit}</td>
                                  <td className="px-4 py-2 text-center font-mono">{(ing.yield_pct * 100).toFixed(0)}%</td>
                                  <td className="px-4 py-2 text-right font-mono font-semibold text-gray-200">{ing.qty_eff.toFixed(3)} {ing.unit}</td>
                                  <td className="px-4 py-2 text-right">{ing.unit_price.toLocaleString()} đ</td>
                                  <td className="px-4 py-2 text-right font-mono font-semibold text-amber-500/80">{Math.round(ing.line_cost).toLocaleString()} đ</td>
                                </tr>
                              );
                            })}
                          </tbody>
                        </table>
                      </div>

                      {/* Wastage calculation box */}
                      <div className="mt-4 p-4 bg-[#0c1220]/40 rounded border border-amber-500/10 flex flex-col md:flex-row md:items-center justify-between gap-4 text-xs font-sans">
                        <div className="text-gray-400">
                          <p>• Chi phí nguyên liệu thực tế: <strong className="text-gray-200">
                            {Math.round(activeRecipeDetails.ingredients.reduce((acc, x) => acc + x.line_cost, 0)).toLocaleString()} đ
                          </strong></p>
                          <p>• Hao hụt bếp cộng thêm (Wastage buffer 10%): <strong className="text-gray-200">
                            {Math.round(activeRecipeDetails.ingredients.reduce((acc, x) => acc + x.line_cost, 0) * 0.1).toLocaleString()} đ
                          </strong></p>
                        </div>
                        <div className="text-right border-t md:border-t-0 border-amber-500/15 pt-2 md:pt-0">
                          <span className="text-[10px] text-gray-400 uppercase tracking-wider block">Tổng Giá vốn đĩa (Food Cost)</span>
                          <span className="text-xl font-bold text-amber-400">
                            {Math.round(activeRecipeDetails.ingredients.reduce((acc, x) => acc + x.line_cost, 0) * 1.1).toLocaleString()} đ
                          </span>
                        </div>
                      </div>
                    </div>

                    {/* Step-by-Step Method */}
                    {activeRecipeDetails.method && activeRecipeDetails.method.length > 0 && (
                      <div>
                        <h3 className="text-lg font-serif font-semibold text-[#d4af37] mb-2 border-b border-amber-500/5 pb-1">Quy trình sơ chế & Phục vụ (Cooking Method)</h3>
                        <div className="flex flex-col gap-2 font-sans text-xs text-gray-300">
                          {activeRecipeDetails.method.map((step) => (
                            <div key={step.step} className="flex gap-3 items-start">
                              <span className="font-serif font-bold text-amber-500">{step.step}.</span>
                              <p className="flex-1 leading-relaxed">{step.description}</p>
                            </div>
                          ))}
                        </div>
                      </div>
                    )}

                    {/* Notes */}
                    {activeRecipeDetails.notes && (
                      <div className="bg-[#141a29]/30 rounded border border-gray-800 p-4 font-sans text-xs leading-relaxed text-gray-400">
                        <strong className="text-amber-500 block mb-1">Ghi chú của Chef (Chef&apos;s Notes):</strong>
                        <p className="italic">{activeRecipeDetails.notes}</p>
                      </div>
                    )}
                  </>
                ) : (
                  <div className="flex-1 flex flex-col items-center justify-center text-gray-500 p-12">
                    <BookOpen size={48} className="text-gray-700 mb-2" />
                    <p>Chọn một công thức từ danh sách bên trái để xem định lượng chi tiết.</p>
                  </div>
                )}
              </div>
            </div>
          )}

          {/* TAB 5: STOCK TAKE */}
          {activeTab === 'stockcount' && (
            <div className="glass-panel rounded-md p-6 flex flex-col gap-6">
              <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 border-b border-amber-500/10 pb-4">
                <div>
                  <h3 className="text-xl font-semibold text-[#d4af37] font-serif">Báo cáo Kiểm kho & Tính Variance</h3>
                  <p className="text-xs text-gray-400">Nhập số lượng kiểm kho thực tế tại quầy để so khớp chênh lệch tài chính.</p>
                </div>
                
                <div className="flex items-center gap-2 bg-[#0c1220]/60 p-1.5 rounded border border-amber-500/10 text-xs">
                  <span className="text-gray-400 px-2 font-sans">Loại kho lọc:</span>
                  <button className="bg-amber-500/15 text-amber-400 px-3 py-1 rounded font-semibold uppercase text-[10px]">Tất cả Bếp</button>
                </div>
              </div>

              <div className="bg-amber-500/5 border border-amber-500/10 p-4 rounded text-xs leading-relaxed font-sans text-gray-400">
                <strong className="text-amber-500 block mb-1">HƯỚNG DẪN KIỂM KHO:</strong>
                <p>1. Nhập số lượng cân đếm thực tế của nguyên liệu vào ô **Tồn thực tế**.</p>
                <p>2. CRM sẽ tự động so khớp với **Tồn lý thuyết** (= Standard Opening 30 - Tiêu hao định mức).</p>
                <p>3. **Chênh lệch (Variance)** âm (màu đỏ) đại diện cho phần hao hụt ngoài định mức (lãng phí, thất thoát hoặc hư hỏng).</p>
              </div>

              <div className="overflow-x-auto">
                <table className="w-full text-xs text-left text-gray-300">
                  <thead className="bg-[#0c1220] uppercase text-gray-400 border-b border-amber-500/10">
                    <tr>
                      <th className="px-4 py-3">Mã</th>
                      <th className="px-4 py-3">Tên Nguyên Liệu</th>
                      <th className="px-4 py-3 text-right">Giá mua</th>
                      <th className="px-4 py-3 text-right">Tiêu hao định mức</th>
                      <th className="px-4 py-3 text-right">Tồn lý thuyết</th>
                      <th className="px-4 py-3 text-center">Tồn thực tế đếm tay</th>
                      <th className="px-4 py-3 text-right">Chênh lệch (Variance)</th>
                      <th className="px-4 py-3 text-right">Tài chính hao hụt</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-amber-500/5">
                    {ingredients.slice(0, 15).map((ing) => {
                      const consumed = consumptionData.find(c => c.id === ing.id)?.qty || 0;
                      const mockOpening = 30; // standard mock opening
                      const theoretical = Math.max(0, mockOpening - consumed);
                      
                      const actualStr = actualStocks[ing.id] || '';
                      const actualVal = actualStr !== '' ? parseFloat(actualStr) : NaN;
                      const variance = !isNaN(actualVal) ? actualVal - theoretical : 0;
                      const varianceCost = variance * ing.price;

                      return (
                        <tr key={ing.id} className="hover:bg-[#141a29]/30">
                          <td className="px-4 py-3 font-mono text-amber-500/70">{ing.id}</td>
                          <td className="px-4 py-3 font-medium text-gray-100">{ing.vi_name}</td>
                          <td className="px-4 py-3 text-right">{ing.price.toLocaleString()} đ</td>
                          <td className="px-4 py-3 text-right font-mono text-amber-500">{consumed.toFixed(3)} {ing.unit}</td>
                          <td className="px-4 py-3 text-right font-mono text-gray-400">{theoretical.toFixed(3)} {ing.unit}</td>
                          <td className="px-4 py-3 text-center">
                            <input 
                              type="number"
                              placeholder="Cân đếm..."
                              value={actualStr}
                              onChange={(e) => {
                                setActualStocks({
                                  ...actualStocks,
                                  [ing.id]: e.target.value
                                });
                              }}
                              className="bg-[#090d16] border border-amber-500/20 rounded-sm text-center text-xs w-20 py-1 font-mono text-gray-100 focus:outline-none focus:border-amber-500"
                            />
                          </td>
                          <td className={`px-4 py-3 text-right font-mono font-semibold ${
                            isNaN(actualVal) 
                              ? 'text-gray-500' 
                              : variance < 0 
                                ? 'text-rose-400' 
                                : variance > 0 
                                  ? 'text-emerald-400' 
                                  : 'text-gray-300'
                          }`}>
                            {isNaN(actualVal) ? "Chưa kiểm" : `${variance > 0 ? "+" : ""}${variance.toFixed(3)} ${ing.unit}`}
                          </td>
                          <td className={`px-4 py-3 text-right font-mono font-semibold ${
                            isNaN(actualVal) 
                              ? 'text-gray-500' 
                              : varianceCost < 0 
                                ? 'text-rose-400' 
                                : varianceCost > 0 
                                  ? 'text-emerald-400' 
                                  : 'text-gray-300'
                          }`}>
                            {isNaN(actualVal) ? "—" : `${varianceCost > 0 ? "+" : ""}${Math.round(varianceCost).toLocaleString()} đ`}
                          </td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              </div>
            </div>
          )}

        </main>
      </div>

      {/* 5. Footer */}
      <footer className="border-t border-amber-500/10 bg-[#0c1220] py-6 text-center text-xs text-gray-400 font-sans mt-auto">
        <div className="max-w-7xl mx-auto px-6 flex flex-col sm:flex-row items-center justify-between gap-4">
          <p>© 2026 Maison Vie. Hệ thống CRM/ERP Inventory đã chuẩn hóa cấu trúc dữ liệu phẳng.</p>
          <div className="flex gap-4">
            <span className="text-[10px] text-[#d4af37] font-semibold">SUPABASE</span>
            <span className="text-[10px] text-gray-500">|</span>
            <span className="text-[10px] text-gray-400">VERCEL</span>
            <span className="text-[10px] text-gray-500">|</span>
            <span className="text-[10px] text-gray-400">GITHUB</span>
          </div>
        </div>
      </footer>
    </div>
  );
}
