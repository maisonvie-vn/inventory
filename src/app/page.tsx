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
  RefreshCw,
  Download,
  Cpu
} from 'lucide-react';

import * as XLSX from 'xlsx';

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
  const [activeTab, setActiveTab] = useState<'dashboard' | 'sales' | 'inventory' | 'recipes' | 'stockcount' | 'subrecipes'>('dashboard');
  const [searchQuery, setSearchQuery] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('ALL');
  const [recipeType, setRecipeType] = useState<'alc' | 'deg'>('alc');
  const [selectedRecipe, setSelectedRecipe] = useState<string | null>('R-001');
  const [searchRecipe, setSearchRecipe] = useState('');
  const [isImporting, setIsImporting] = useState(false);
  const [importSuccess, setImportSuccess] = useState(false);
  const [salesData, setSalesData] = useState<SaleRecord[]>(getSales());

  // 7-Level RBAC Role state
  const [userRole, setUserRole] = useState<'admin' | 'restaurant_manager' | 'head_chef' | 'senior_accountant' | 'foh_supervisor' | 'sous_chef' | 'junior_accountant'>('admin');

  // Simulated time and locking
  const [simulatedTime, setSimulatedTime] = useState<string>('17:00');
  const [isWacLocked, setIsWacLocked] = useState<boolean>(false);

  // Waste Logs
  const [wasteLogs, setWasteLogs] = useState<{
    id: string;
    ingredientId: string;
    qty: number;
    reason: string;
    status: 'pending_approval' | 'approved' | 'rejected';
    is_processed: boolean;
    createdBy: string;
    createdAt: string;
  }[]>([
    { id: 'waste-1', ingredientId: 'ING-011', qty: 1.5, reason: 'Trâu Việt Nam bị cháy khi nướng Wellington', status: 'approved', is_processed: false, createdBy: 'Bếp phó Minh', createdAt: '2026-06-14' },
    { id: 'waste-2', ingredientId: 'ING-017', qty: 0.8, reason: 'Bơ Isigny bị nóng chảy do hỏng tủ lạnh phụ', status: 'pending_approval', is_processed: false, createdBy: 'Bếp phó Minh', createdAt: '2026-06-14' }
  ]);

  // Mapping screen countdown and modal
  const [showMappingModal, setShowMappingModal] = useState(false);
  const [mappingCountdown, setMappingCountdown] = useState(30);
  const [pendingImportType, setPendingImportType] = useState<'sales' | 'ingredients' | 'stock'>('sales');
  const [pendingImportData, setPendingImportData] = useState<any[]>([]);
  const [mappingItems, setMappingItems] = useState<{
    code: string;
    name: string;
    status: 'matched' | 'suggested' | 'unmatched';
    accuracy: number;
    matchedRecipeId: string;
    qty: number;
    price: number;
  }[]>([]);

  // Editable lists loaded into state
  const [ingredients, setIngredients] = useState<Ingredient[]>(() => getIngredients());
  const [recipes, setRecipes] = useState<Record<string, Recipe>>(() => getRecipes());

  // Stock count state - initialize with empty strings (represents not counted yet)
  const [actualStocks, setActualStocks] = useState<Record<string, string>>({
    "ING-003": "15.5", 
    "ING-093": "22.0", 
    "ING-013": "8.5",  
    "ING-017": "12.0", 
    "ING-025": "4.2",  
  });

  // State for inventory transactions to track movement
  const [transactions, setTransactions] = useState<{
    id: string;
    ingredientId: string;
    type: 'import' | 'consumption' | 'stock_take' | 'waste';
    qty: number;
    unit_price: number;
    status: 'pending' | 'approved' | 'rejected';
    approvedBy?: string;
    date: string;
    note: string;
  }[]>(() => {
    // Initialize with mock opening stock of 30 for all ingredients
    return getIngredients().map(ing => ({
      id: `init-${ing.id}`,
      ingredientId: ing.id,
      type: 'import' as const,
      qty: 30,
      unit_price: ing.price,
      status: 'approved' as const,
      date: '2026-06-01',
      note: 'Tồn đầu kỳ (Opening Stock)'
    }));
  });

  // State for Auto-PO simulation results
  const [generatedPOs, setGeneratedPOs] = useState<{
    fileName: string;
    items: { ingId: string; name: string; qtyNeeded: number; unit: string; estCost: number }[];
  }[]>([]);

  const hasTabAccess = (role: string, tab: string) => {
    if (role === 'admin') return true;
    switch (role) {
      case 'restaurant_manager':
        return ['dashboard', 'sales', 'inventory', 'stockcount', 'subrecipes'].includes(tab);
      case 'head_chef':
        return ['dashboard', 'inventory', 'recipes', 'stockcount', 'subrecipes'].includes(tab);
      case 'senior_accountant':
        return ['dashboard', 'sales', 'inventory', 'stockcount'].includes(tab);
      case 'foh_supervisor':
        return ['sales', 'recipes'].includes(tab);
      case 'sous_chef':
        return ['recipes', 'stockcount', 'subrecipes'].includes(tab);
      case 'junior_accountant':
        return ['inventory'].includes(tab);
      default:
        return false;
    }
  };

  React.useEffect(() => {
    const tabs: ('dashboard' | 'sales' | 'inventory' | 'recipes' | 'stockcount' | 'subrecipes')[] = [
      'dashboard', 'sales', 'inventory', 'recipes', 'stockcount', 'subrecipes'
    ];
    if (!hasTabAccess(userRole, activeTab)) {
      const firstAccessible = tabs.find(t => hasTabAccess(userRole, t));
      if (firstAccessible) {
        setActiveTab(firstAccessible);
      }
    }
  }, [userRole]);

  // Sub-recipe formulas (how raw ingredients are consumed when prepared in-house)
  const SUB_RECIPE_FORMULAS: Record<string, { name: string; unit: string; ingredients: { ing_id: string; qty: number }[] }> = {
    "ING-081": {
      name: "Nước dùng gà (Fond de volaille)",
      unit: "L",
      ingredients: [
        { ing_id: "ING-015", qty: 0.8 }, // Gà thô
        { ing_id: "ING-024", qty: 0.2 }, // Rau Đà Lạt
        { ing_id: "ING-041", qty: 0.005 } // Húng tây
      ]
    },
    "ING-082": {
      name: "Nước dùng cá (Fond de poisson)",
      unit: "L",
      ingredients: [
        { ing_id: "ING-004", qty: 0.7 }, // Cá vược file thô
        { ing_id: "ING-024", qty: 0.15 },
        { ing_id: "ING-032", qty: 0.05 } // Hành tím Pháp
      ]
    },
    "ING-083": {
      name: "Nước sốt bê/trâu (Jus veau/buffle)",
      unit: "L",
      ingredients: [
        { ing_id: "ING-011", qty: 1.2 }, // Trâu Việt Nam
        { ing_id: "ING-025", qty: 0.15 }, // Nấm Tam Đảo
        { ing_id: "ING-071", qty: 0.3 }, // Vang đỏ đậm
        { ing_id: "ING-017", qty: 0.05 } // Bơ Isigny
      ]
    },
    "ING-084": {
      name: "Bơ tinh luyện (Beurre clarifié)",
      unit: "kg",
      ingredients: [
        { ing_id: "ING-017", qty: 1.33 } // Bơ Isigny thô (Yield 75%)
      ]
    },
    "ING-092": {
      name: "Bơ nâu nhà làm (Beurre noisette)",
      unit: "kg",
      ingredients: [
        { ing_id: "ING-017", qty: 1.2 }
      ]
    }
  };

  const [selectedSubRecipe, setSelectedSubRecipe] = useState('ING-083');
  const [cookedQty, setCookedQty] = useState('10');
  const [subRecipeSuccess, setSubRecipeSuccess] = useState(false);

  // Helper function to compute transaction-aware theoretical stock
  const getTheoreticalStock = (ingId: string) => {
    let stock = 0;
    transactions.forEach(t => {
      if (t.ingredientId === ingId && t.status === 'approved') {
        if (t.type === 'import') {
          stock += t.qty;
        } else if (t.type === 'consumption' || t.type === 'waste') {
          stock -= t.qty;
        }
      }
    });
    // Deduct POS sales consumption
    const consumed = consumptionData.find(c => c.id === ingId)?.qty || 0;
    stock -= consumed;
    
    // Deduct approved waste logs that are not yet aggregated into transactions
    const unTransactionedWaste = wasteLogs
      .filter(w => w.ingredientId === ingId && w.status === 'approved' && !w.is_processed)
      .reduce((sum, w) => sum + w.qty, 0);
    stock -= unTransactionedWaste;

    return Math.max(0, stock);
  };

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
          const baseCode = sub.replace('_DEG', '');
          const r = recipes[baseCode]; // Get À La Carte recipe
          if (r && r.ingredients) {
            r.ingredients.forEach(ing => {
              // Deduct set menu portion at exactly 70% of À La Carte
              const scaledQty = ing.qty_eff * 0.70;
              const totalDeduction = scaledQty * qty * 1.10;
              consumption[ing.ing_id] = (consumption[ing.ing_id] || 0) + totalDeduction;
            });
          } else {
            // Fallback to _DEG recipe if À La Carte is missing
            const degR = recipes[sub];
            if (degR && degR.ingredients) {
              degR.ingredients.forEach(ing => {
                const totalDeduction = ing.qty_eff * qty * 1.10;
                consumption[ing.ing_id] = (consumption[ing.ing_id] || 0) + totalDeduction;
              });
            }
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
        const theoretical = getTheoreticalStock(ing.id);
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
  }, [salesData, consumptionData, ingredients, actualStocks, transactions]);

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

  const strVal = (val: any) => {
    if (val === null || val === undefined) return '';
    return String(val).trim();
  };

  const floatVal = (val: any) => {
    if (val === null || val === undefined) return 0;
    if (typeof val === 'number') return val;
    const clean = String(val).replace(/[^0-9.-]/g, '');
    const num = parseFloat(clean);
    return isNaN(num) ? 0 : num;
  };

  // Log in-house cooked sub-recipe production
  const handleLogSubRecipeCooking = (e: React.FormEvent) => {
    e.preventDefault();
    const qty = parseFloat(cookedQty);
    if (isNaN(qty) || qty <= 0) {
      alert('Vui lòng nhập số lượng hợp lệ.');
      return;
    }

    const formula = SUB_RECIPE_FORMULAS[selectedSubRecipe];
    if (!formula) return;

    // Deduct raw ingredients and add sub-recipe
    const newTrans: {
      id: string;
      ingredientId: string;
      type: 'import' | 'consumption' | 'stock_take' | 'waste';
      qty: number;
      unit_price: number;
      status: 'pending' | 'approved' | 'rejected';
      date: string;
      note: string;
    }[] = [];
    const nowStr = new Date().toISOString().split('T')[0];

    const subRecipeIng = ingredients.find(i => i.id === selectedSubRecipe);
    const subRecipePrice = subRecipeIng ? subRecipeIng.price : 0;

    newTrans.push({
      id: `sr-add-${Date.now()}`,
      ingredientId: selectedSubRecipe,
      type: 'import' as const,
      qty: qty,
      unit_price: subRecipePrice,
      status: 'approved' as const,
      date: nowStr,
      note: `Sản xuất: Nấu thành công ${qty} ${formula.unit} ${formula.name}`
    });

    formula.ingredients.forEach(ing => {
      const deductionQty = ing.qty * qty;
      const rawIng = ingredients.find(i => i.id === ing.ing_id);
      const rawPrice = rawIng ? rawIng.price : 0;
      newTrans.push({
        id: `sr-deduct-${Date.now()}-${ing.ing_id}`,
        ingredientId: ing.ing_id,
        type: 'waste' as const,
        qty: deductionQty,
        unit_price: rawPrice,
        status: 'approved' as const,
        date: nowStr,
        note: `Tiêu hao nguyên liệu thô để nấu ${formula.name}`
      });
    });

    setTransactions(prev => [...prev, ...newTrans]);
    setSubRecipeSuccess(true);
    setTimeout(() => setSubRecipeSuccess(false), 4000);
  };

  // Function to run Moving WAC simulation
  const handleRunWacSimulation = () => {
    // Collect all imports in transactions
    const updatedIngredients = ingredients.map(ing => {
      // Find imports for this ingredient that are approved/pending in this period
      const ingTrans = transactions.filter(t => t.ingredientId === ing.id && t.type === 'import');
      if (ingTrans.length === 0) return ing;

      // Suppose opening stock is 30 at original price (ing.price)
      let totalQty = 30;
      let totalValue = 30 * ing.price;

      ingTrans.forEach(t => {
        // Exclude initial transaction since it represents opening stock
        if (t.id.startsWith('init-')) return;
        totalQty += t.qty;
        totalValue += t.qty * t.unit_price;
      });

      const newWac = totalQty > 0 ? totalValue / totalQty : ing.price;
      return {
        ...ing,
        price: Math.round(newWac)
      };
    });

    setIngredients(updatedIngredients);
    setIsWacLocked(true);
    alert('Đã chạy tính toán Moving WAC lúc 18h30 thành công!\nGiá vốn bình quân gia quyền đã được cập nhật cho các mặt hàng có phát sinh giao dịch nhập kho trong ngày. Khóa sổ nhập kho cho đến ca sáng hôm sau.');
  };

  // Function to run Auto-PO simulation
  const handleRunAutoPOSimulation = () => {
    const minStock = 15;
    const maxStock = 50;
    
    // Group ingredients that need ordering
    const poItems: Record<string, { ingId: string; name: string; qtyNeeded: number; unit: string; price: number; category: string }[]> = {
      'Thịt & Thủy Hải Sản': [],
      'Rau Củ & Đồ Khô': [],
      'Rượu Vang & Đồ Uống': []
    };

    ingredients.forEach(ing => {
      const currentStock = getTheoreticalStock(ing.id);
      if (currentStock < minStock) {
        const qtyNeeded = maxStock - currentStock;
        const item = {
          ingId: ing.id,
          name: ing.vi_name,
          qtyNeeded: parseFloat(qtyNeeded.toFixed(2)),
          unit: ing.unit,
          price: ing.price,
          category: ing.category
        };

        // Classify into PO groups
        if (['Meat', 'Seafood'].includes(ing.category)) {
          poItems['Thịt & Thủy Hải Sản'].push(item);
        } else if (['Produce', 'Dry', 'Dairy', 'Groceries'].includes(ing.category) || ing.category === 'Khác') {
          poItems['Rau Củ & Đồ Khô'].push(item);
        } else if (['Wine', 'Beverage', 'Bar'].includes(ing.category)) {
          poItems['Rượu Vang & Đồ Uống'].push(item);
        }
      }
    });

    const newPOs: { fileName: string; items: any[] }[] = [];

    Object.entries(poItems).forEach(([groupName, items]) => {
      if (items.length === 0) return;
      
      let filePrefix = '';
      if (groupName === 'Thịt & Thủy Hải Sản') filePrefix = 'PO_Thit_HaiSan';
      else if (groupName === 'Rau Củ & Đồ Khô') filePrefix = 'PO_RauCu_DoKho';
      else filePrefix = 'PO_RuouVang_DoUong';

      const nowStr = new Date().toISOString().split('T')[0];
      const fileName = `${filePrefix}_${nowStr}.xlsx`;

      newPOs.push({
        fileName,
        items: items.map(it => ({
          ingId: it.ingId,
          name: it.name,
          qtyNeeded: it.qtyNeeded,
          unit: it.unit,
          estCost: Math.round(it.qtyNeeded * it.price)
        }))
      });
    });

    setGeneratedPOs(newPOs);
    alert(`Đã chạy tự động sinh đơn hàng Auto-PO lúc 22h40!\nPhát hiện ${Object.values(poItems).flat().length} nguyên liệu dưới định mức min-stock (15). Đã tạo ${newPOs.length} đơn hàng PO tách biệt.`);
  };

  // Helper to trigger Excel download for a generated PO
  const downloadGeneratedPOExcel = (po: { fileName: string; items: any[] }) => {
    const headers = [['Mã NVL', 'Tên Nguyên Liệu', 'Số Lượng Cần Đặt', 'Đơn Vị', 'Chi Phí Ước Tính (VND)']];
    const dataRows = po.items.map(it => [
      it.ingId,
      it.name,
      it.qtyNeeded,
      it.unit,
      it.estCost
    ]);
    const ws = XLSX.utils.aoa_to_sheet([...headers, ...dataRows]);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'PO_Order');
    XLSX.writeFile(wb, po.fileName);
  };

  // Mapping Modal Effects & Logic
  React.useEffect(() => {
    let timer: any;
    if (showMappingModal && mappingCountdown > 0) {
      timer = setTimeout(() => {
        setMappingCountdown(prev => prev - 1);
      }, 1000);
    } else if (showMappingModal && mappingCountdown === 0) {
      handleConfirmMapping();
    }
    return () => clearTimeout(timer);
  }, [showMappingModal, mappingCountdown]);

  const triggerMappingProcess = (data: any[], type: 'sales' | 'ingredients' | 'stock') => {
    const items = data.map((item: any) => {
      const code = String(item.code || item.id || '').trim();
      const name = String(item.name || item.vi_name || '');
      
      const exactMatch = POS_MAPPING[code] || ingredients.find(ing => ing.id === code);
      
      if (exactMatch) {
        return {
          code,
          name,
          status: 'matched' as const,
          accuracy: 100,
          matchedRecipeId: (exactMatch as any).recipe || (exactMatch as any).id || code,
          qty: item.qty || item.qty_sold || 1,
          price: item.price || item.unit_price || 0
        };
      } else {
        let bestMatch = '';
        let accuracy = 0;
        
        if (code.startsWith('R') || code.startsWith('M') || code.startsWith('B')) {
          const keys = Object.keys(recipes);
          const found = keys.find(k => k.toLowerCase().includes(code.toLowerCase().slice(0, 3)));
          if (found) {
            bestMatch = found;
            accuracy = 85 + Math.floor(Math.random() * 10);
          }
        } else if (code.startsWith('ING')) {
          const found = ingredients.find(i => i.id.toLowerCase().includes(code.toLowerCase().slice(0, 5)));
          if (found) {
            bestMatch = found.id;
            accuracy = 80 + Math.floor(Math.random() * 15);
          }
        }
        
        return {
          code,
          name,
          status: bestMatch ? ('suggested' as const) : ('unmatched' as const),
          accuracy: bestMatch ? accuracy : 0,
          matchedRecipeId: bestMatch || 'IGNORE',
          qty: item.qty || 1,
          price: item.price || 0
        };
      }
    });

    setMappingItems(items);
    setPendingImportType(type);
    setPendingImportData(data);
    setMappingCountdown(30);
    setShowMappingModal(true);
  };

  const handleConfirmMapping = () => {
    setShowMappingModal(false);
    
    if (pendingImportType === 'sales') {
      const finalSales = pendingImportData.map((item, idx) => {
        const mapped = mappingItems[idx];
        return {
          ...item,
          code: mapped.matchedRecipeId === 'IGNORE' ? 'IGNORE' : mapped.code
        };
      }).filter(s => s.code !== 'IGNORE');

      setSalesData(finalSales);
      setImportSuccess(true);
      setTimeout(() => setImportSuccess(false), 4000);
      alert(`Đã hoàn tất rà soát mapping và chốt ghi sổ thành công ${finalSales.length} dòng hàng POS!`);
    } else if (pendingImportType === 'ingredients') {
      alert('Đã cập nhật danh mục NVL sau khi rà soát!');
    }
  };

  // File Upload Handlers
  const handleImportSalesExcel = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    setIsImporting(true);
    setImportSuccess(false);

    const reader = new FileReader();
    reader.onload = (evt) => {
      try {
        const bstr = evt.target?.result;
        const wb = XLSX.read(bstr, { type: 'binary' });
        const wsname = wb.SheetNames[0];
        const ws = wb.Sheets[wsname];
        const data = XLSX.utils.sheet_to_json<any[]>(ws, { header: 1 });

        let headerRowIdx = -1;
        for (let i = 0; i < data.length; i++) {
          const row = data[i] as any[];
          if (row.includes('Mã hàng') && row.includes('Số lượng')) {
            headerRowIdx = i;
            break;
          }
        }

        if (headerRowIdx === -1) {
          alert('Không tìm thấy cột "Mã hàng" và "Số lượng" trong file Excel.');
          setIsImporting(false);
          return;
        }

        const headers = data[headerRowIdx] as any[];
        const codeIdx = headers.indexOf('Mã hàng');
        const nameIdx = headers.indexOf('Tên hàng');
        const priceIdx = headers.indexOf('Giá bán');
        const qtyIdx = headers.indexOf('Số lượng');
        const totalIdx = headers.indexOf('Tổng tiền trước giảm giá');
        const discountIdx = headers.indexOf('Tiền giảm giá');
        const taxIdx = headers.indexOf('Tiền thuế');
        const serviceIdx = headers.indexOf('Tiền phí dịch vụ');

        const parsedSales: SaleRecord[] = [];
        for (let i = headerRowIdx + 1; i < data.length; i++) {
          const row = data[i] as any[];
          if (!row || row.length <= Math.max(codeIdx, qtyIdx)) continue;
          
          const code = strVal(row[codeIdx]).trim();
          const qty = floatVal(row[qtyIdx]);
          if (!code || isNaN(qty) || qty <= 0) continue;

          // Reject category summary rows (e.g. "Beer", "Brandy – Eau de Vie", "Set menu")
          const isValidProductCode = /^\d+$/.test(code) || /^[A-Za-z]+\d+[A-Za-z0-9]*$/.test(code);
          if (!isValidProductCode) continue;

          parsedSales.push({
            code,
            name: strVal(row[nameIdx]) || `Món ${code}`,
            price: floatVal(row[priceIdx]) || 0,
            qty: qty,
            total_before_discount: floatVal(row[totalIdx]) || (floatVal(row[priceIdx]) * qty) || 0,
            discount: floatVal(row[discountIdx]) || 0,
            discount_pct: 0,
            service_charge: floatVal(row[serviceIdx]) || 0,
            tax: floatVal(row[taxIdx]) || 0
          });
        }

        if (parsedSales.length > 0) {
          triggerMappingProcess(parsedSales, 'sales');
        } else {
          alert('Không tìm thấy bản ghi bán hàng hợp lệ.');
        }
      } catch (err) {
        alert('Lỗi phân tích Excel: ' + (err as Error).message);
      } finally {
        setIsImporting(false);
      }
    };
    reader.readAsBinaryString(file);
  };

  const handleImportIngredientsExcel = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (evt) => {
      try {
        const bstr = evt.target?.result;
        const wb = XLSX.read(bstr, { type: 'binary' });
        const ws = wb.Sheets[wb.SheetNames[0]];
        const data = XLSX.utils.sheet_to_json<any[]>(ws, { header: 1 });

        let headerRowIdx = -1;
        for (let i = 0; i < data.length; i++) {
          const row = data[i] as any[];
          if (row && (row.includes('Mã NVL') || row.includes('Mã'))) {
            headerRowIdx = i;
            break;
          }
        }

        if (headerRowIdx === -1) {
          alert('Không tìm thấy cột "Mã NVL" trong file Excel.');
          return;
        }

        const headers = data[headerRowIdx] as any[];
        const codeIdx = headers.findIndex(h => String(h).includes('Mã'));
        const viNameIdx = headers.findIndex(h => String(h).includes('Tên tiếng Việt') || String(h).includes('Tên'));
        const frNameIdx = headers.findIndex(h => String(h).includes('Tên tiếng Pháp'));
        const unitIdx = headers.findIndex(h => String(h).includes('ĐVT') || String(h).includes('Đơn vị'));
        const priceIdx = headers.findIndex(h => String(h).includes('Giá vốn') || String(h).includes('Giá'));
        const yieldIdx = headers.findIndex(h => String(h).includes('Yield') || String(h).includes('Tỷ lệ'));
        const catIdx = headers.findIndex(h => String(h).includes('Danh mục'));

        const newIngredients: Ingredient[] = [];
        for (let i = headerRowIdx + 1; i < data.length; i++) {
          const row = data[i] as any[];
          if (!row || row.length <= codeIdx) continue;
          const code = strVal(row[codeIdx]);
          const viName = strVal(row[viNameIdx]);
          if (!code || !viName) continue;

          newIngredients.push({
            id: code,
            vi_name: viName,
            fr_name: frNameIdx !== -1 ? strVal(row[frNameIdx]) : '',
            en_name: '',
            category: catIdx !== -1 ? strVal(row[catIdx]) : 'Khác',
            supplier_tier: 'A',
            unit: unitIdx !== -1 ? strVal(row[unitIdx]) : 'kg',
            price: priceIdx !== -1 ? floatVal(row[priceIdx]) : 0,
            yield_rate: yieldIdx !== -1 ? floatVal(row[yieldIdx]) / 100 || 1.0 : 1.0
          });
        }

        if (newIngredients.length > 0) {
          setIngredients(newIngredients);
          const newInitTrans = newIngredients.map(ing => ({
            id: `init-${ing.id}`,
            ingredientId: ing.id,
            type: 'import' as const,
            qty: 30,
            unit_price: ing.price,
            status: 'approved' as const,
            date: '2026-06-01',
            note: 'Tồn đầu kỳ (Opening Stock)'
          }));
          setTransactions(newInitTrans);
          alert(`Đã nhập thành công ${newIngredients.length} nguyên liệu vào bảng Master Kho!`);
        }
      } catch (err) {
        alert('Lỗi nhập danh mục kho: ' + (err as Error).message);
      }
    };
    reader.readAsBinaryString(file);
  };

  const handleImportRecipesExcel = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (evt) => {
      try {
        const bstr = evt.target?.result;
        const wb = XLSX.read(bstr, { type: 'binary' });
        const ws = wb.Sheets[wb.SheetNames[0]];
        const data = XLSX.utils.sheet_to_json<any[]>(ws, { header: 1 });

        let headerRowIdx = -1;
        for (let i = 0; i < data.length; i++) {
          const row = data[i] as any[];
          if (row && row.includes('Mã Món') && row.includes('Mã NVL')) {
            headerRowIdx = i;
            break;
          }
        }

        if (headerRowIdx === -1) {
          alert('Không tìm thấy cột "Mã Món" và "Mã NVL" trong file Excel.');
          return;
        }

        const headers = data[headerRowIdx] as any[];
        const menuCodeIdx = headers.indexOf('Mã Món');
        const menuNameIdx = headers.indexOf('Tên món');
        const salePriceIdx = headers.indexOf('Giá bán lẻ');
        const ingCodeIdx = headers.indexOf('Mã NVL');
        const ingNameIdx = headers.indexOf('Tên NVL');
        const qtyNetIdx = headers.indexOf('Định lượng Net');
        const yieldIdx = headers.indexOf('Yield (%)');
        const unitIdx = headers.indexOf('Đơn vị');

        const parsedRecipes: Record<string, Recipe> = {};
        let currentRecipe: Recipe | null = null;

        for (let i = headerRowIdx + 1; i < data.length; i++) {
          const row = data[i] as any[];
          if (!row) continue;

          const menuCode = strVal(row[menuCodeIdx]);
          const menuName = strVal(row[menuNameIdx]);
          const ingCode = strVal(row[ingCodeIdx]);
          
          if (menuCode) {
            currentRecipe = {
              code: menuCode,
              name: menuName || `Món ${menuCode}`,
              course: 'Bếp',
              category: 'Món chính',
              menu_role: 'À la carte',
              price: floatVal(row[salePriceIdx]) || 0,
              ingredients: [],
              method: [],
              notes: ''
            };
            parsedRecipes[menuCode] = currentRecipe;
          }

          if (currentRecipe && ingCode) {
            const qtyNet = floatVal(row[qtyNetIdx]) || 0;
            const yieldPct = (floatVal(row[yieldIdx]) || 100) / 100;
            const qtyEff = qtyNet / yieldPct;
            const unit = strVal(row[unitIdx]) || 'kg';
            
            const ingObj = ingredients.find(ing => ing.id === ingCode);
            const unitPrice = ingObj ? ingObj.price : 0;

            currentRecipe.ingredients.push({
              ing_id: ingCode,
              qty_net: qtyNet,
              unit: unit,
              yield_pct: yieldPct,
              qty_eff: qtyEff,
              unit_price: unitPrice,
              line_cost: qtyEff * unitPrice
            });
          }
        }

        if (Object.keys(parsedRecipes).length > 0) {
          setRecipes(parsedRecipes);
          alert(`Đã chuẩn hóa và nhập thành công ${Object.keys(parsedRecipes).length} công thức món ăn!`);
        }
      } catch (err) {
        alert('Lỗi nhập định lượng: ' + (err as Error).message);
      }
    };
    reader.readAsBinaryString(file);
  };

  // Template Excel Download Handlers (SheetJS client-side creation)
  const downloadPOSTemplate = () => {
    const headers = [['Mã hàng', 'Tên hàng', 'Giá bán', 'Số lượng', 'Tổng tiền trước giảm giá', 'Tiền giảm giá', 'Tiền chiết khấu', 'Tiền phí dịch vụ', 'Tiền thuế', 'Thành tiền']];
    const sampleData = [
      ['B5001', 'Heineken - 33cl', 45000, 10, 450000, 0, 0, 22500, 47250, 519750],
      ['B5002', 'Tiger - 33cl', 45000, 15, 675000, 0, 0, 33750, 70875, 779625],
      ['R1121', 'Carpaccio de Thon', 300000, 4, 1200000, 0, 0, 0, 0, 1200000],
      ['R2141', 'Buffalo Wellington', 535000, 8, 4280000, 0, 0, 0, 0, 4280000],
      ['R6212', 'Tasting 5 courses (Set Menu)', 1200000, 2, 2400000, 0, 0, 0, 0, 2400000]
    ];
    const ws = XLSX.utils.aoa_to_sheet([...headers, ...sampleData]);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Sales_POS_Template');
    XLSX.writeFile(wb, 'Maison_Vie_POS_Sales_Template.xlsx');
  };

  const downloadIngredientsTemplate = () => {
    const headers = [['Mã NVL', 'Tên tiếng Việt', 'Tên tiếng Pháp', 'ĐVT', 'Giá vốn chuẩn', 'Yield Rate (%)', 'Danh mục']];
    const sampleData = [
      ['ING-001', 'Cá ngừ fillet tươi', 'Thon rouge sashimi-grade', 'kg', 580000, 85, 'Seafood'],
      ['ING-017', 'Bơ Isigny AOP', 'Beurre d\'Isigny AOP', 'kg', 760000, 100, 'Dairy'],
      ['ING-093', 'Bò Black Angus ribeye US', 'Côte de Bœuf Black Angus US', 'kg', 1113000, 80, 'Meat']
    ];
    const ws = XLSX.utils.aoa_to_sheet([...headers, ...sampleData]);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Master_Ingredients_Template');
    XLSX.writeFile(wb, 'Maison_Vie_Master_Ingredients_Template.xlsx');
  };

  const downloadRecipesTemplate = () => {
    const headers = [['Mã Món', 'Tên món', 'Giá bán lẻ', 'Mã NVL', 'Tên NVL', 'Định lượng Net', 'Yield (%)', 'Đơn vị']];
    const sampleData = [
      ['R-001', 'Carpaccio de Thon', 300000, 'ING-001', 'Cá ngừ fillet tươi', 0.08, 85, 'kg'],
      ['', '', '', 'ING-045', 'Quả yuzu', 0.01, 65, 'kg'],
      ['', '', '', 'ING-064', 'Hoa muối', 0.001, 100, 'kg'],
      ['R-012', 'Buffalo Wellington', 535000, 'ING-011', 'Trâu Việt Nam', 0.16, 75, 'kg'],
      ['', '', '', 'ING-079', 'Bột bánh ngàn lớp', 0.075, 100, 'kg']
    ];
    const ws = XLSX.utils.aoa_to_sheet([...headers, ...sampleData]);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Recipes_Template');
    XLSX.writeFile(wb, 'Maison_Vie_Recipes_Template.xlsx');
  };

  const downloadSubRecipeTemplate = () => {
    const headers = [['Mã BTP', 'Tên bán thành phẩm', 'Số lượng nấu', 'Đơn vị']];
    const sampleData = [
      ['ING-083', 'Nước sốt bê/trâu', 10, 'Lít'],
      ['ING-081', 'Nước dùng gà', 15, 'Lít']
    ];
    const ws = XLSX.utils.aoa_to_sheet([...headers, ...sampleData]);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Sub_Recipes_Production');
    XLSX.writeFile(wb, 'Maison_Vie_Sub_Recipes_Production_Template.xlsx');
  };

  const downloadStockTakeTemplate = () => {
    const headers = [['Mã NVL', 'Tên nguyên liệu', 'ĐVT', 'Tồn thực tế đếm tay']];
    const sampleData = ingredients.map(ing => [
      ing.id,
      ing.vi_name,
      ing.unit,
      actualStocks[ing.id] || ''
    ]);
    const ws = XLSX.utils.aoa_to_sheet([...headers, ...sampleData]);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'StockTake_Template');
    XLSX.writeFile(wb, 'Maison_Vie_Kiem_Kho_Template.xlsx');
  };

  const handleImportStockTakeExcel = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (evt) => {
      try {
        const bstr = evt.target?.result;
        const wb = XLSX.read(bstr, { type: 'binary' });
        const ws = wb.Sheets[wb.SheetNames[0]];
        const data = XLSX.utils.sheet_to_json<any[]>(ws, { header: 1 });

        let headerRowIdx = -1;
        for (let i = 0; i < data.length; i++) {
          const row = data[i] as any[];
          if (row && (row.includes('Mã NVL') || row.includes('Mã'))) {
            headerRowIdx = i;
            break;
          }
        }

        if (headerRowIdx === -1) {
          alert('Không tìm thấy cột "Mã NVL" trong file Excel.');
          return;
        }

        const headers = data[headerRowIdx] as any[];
        const codeIdx = headers.findIndex(h => String(h).includes('Mã'));
        const qtyIdx = headers.findIndex(h => String(h).includes('Tồn thực tế') || String(h).includes('Thực tế'));

        if (codeIdx === -1 || qtyIdx === -1) {
          alert('Cần có cột "Mã NVL" và "Tồn thực tế đếm tay" trong file Excel.');
          return;
        }

        const newActualStocks = { ...actualStocks };
        let count = 0;

        for (let i = headerRowIdx + 1; i < data.length; i++) {
          const row = data[i] as any[];
          if (!row || row.length <= Math.max(codeIdx, qtyIdx)) continue;

          const code = strVal(row[codeIdx]).trim();
          const qtyStr = strVal(row[qtyIdx]).trim();
          if (!code || qtyStr === '') continue;

          const qty = parseFloat(qtyStr);
          if (isNaN(qty)) continue;

          newActualStocks[code] = String(qty);
          count++;
        }

        if (count > 0) {
          setActualStocks(newActualStocks);
          alert(`Đã cập nhật số lượng kiểm kho thực tế cho ${count} nguyên liệu từ file Excel!`);
        } else {
          alert('Không tìm thấy bản ghi kiểm kho hợp lệ.');
        }
      } catch (err) {
        alert('Lỗi nhập file kiểm kho: ' + (err as Error).message);
      }
    };
    reader.readAsBinaryString(file);
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

          <div className="flex flex-wrap items-center gap-4">
            {/* Simulated Time & WAC Control */}
            <div className="flex items-center gap-2 bg-[#0c1220] border border-amber-500/20 px-3 py-1.5 rounded-sm">
              <span className="text-[10px] text-gray-400 font-sans uppercase">Giờ hệ thống:</span>
              <select 
                value={simulatedTime}
                onChange={(e) => {
                  setSimulatedTime(e.target.value);
                  const [hours, mins] = e.target.value.split(':').map(Number);
                  if (hours > 18 || (hours === 18 && mins >= 30)) {
                    setIsWacLocked(true);
                  } else {
                    setIsWacLocked(false);
                  }
                }}
                className="bg-transparent border-none text-xs font-mono text-amber-500 focus:outline-none cursor-pointer font-bold"
              >
                <option value="08:00" className="bg-[#090d16] text-gray-300">08:00 (Nhập kho)</option>
                <option value="12:00" className="bg-[#090d16] text-gray-300">12:00 (Trưa)</option>
                <option value="17:00" className="bg-[#090d16] text-gray-300">17:00 (Chiều)</option>
                <option value="18:30" className="bg-[#090d16] text-gray-300">18:30 (Chốt WAC)</option>
                <option value="22:30" className="bg-[#090d16] text-gray-300">22:30 (Trừ kho POS)</option>
                <option value="23:00" className="bg-[#090d16] text-gray-300">23:00 (Đóng cửa)</option>
              </select>
            </div>

            {/* Role Switcher */}
            <div className="flex items-center gap-2 bg-[#0c1220] border border-amber-500/20 px-3 py-1.5 rounded-sm">
              <span className="text-[10px] text-gray-400 font-sans uppercase">Vai trò:</span>
              <select 
                value={userRole}
                onChange={(e) => setUserRole(e.target.value as any)}
                className="bg-transparent border-none text-xs text-[#d4af37] focus:outline-none cursor-pointer font-semibold"
              >
                <option value="admin" className="bg-[#090d16] text-gray-300">Cấp 1: Admin (CFO/Owner)</option>
                <option value="restaurant_manager" className="bg-[#090d16] text-gray-300">Cấp 2: Quản lý Nhà hàng</option>
                <option value="head_chef" className="bg-[#090d16] text-gray-300">Cấp 3: Bếp trưởng</option>
                <option value="senior_accountant" className="bg-[#090d16] text-gray-300">Cấp 4: Kế toán kho cấp cao</option>
                <option value="foh_supervisor" className="bg-[#090d16] text-gray-300">Cấp 5: Giám sát (FOH)</option>
                <option value="sous_chef" className="bg-[#090d16] text-gray-300">Cấp 6: Bếp phó</option>
                <option value="junior_accountant" className="bg-[#090d16] text-gray-300">Cấp 7: Thủ kho / Kế toán phụ</option>
              </select>
            </div>

            <div className="h-8 w-[1px] bg-amber-500/20 hidden sm:block"></div>
            <div className="flex items-center gap-2">
              <span className="w-2.5 h-2.5 bg-emerald-500 rounded-full animate-ping"></span>
              <span className="text-xs text-gray-300 font-medium">Bản phẳng đồng bộ (Sync)</span>
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
          {hasTabAccess(userRole, 'dashboard') && (
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
          )}
          
          {hasTabAccess(userRole, 'sales') && (
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
          )}

          {hasTabAccess(userRole, 'inventory') && (
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
          )}

          {hasTabAccess(userRole, 'recipes') && (
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
          )}

          {hasTabAccess(userRole, 'stockcount') && (
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
          )}

          {hasTabAccess(userRole, 'subrecipes') && (
            <button 
              onClick={() => setActiveTab('subrecipes')}
              className={`w-full flex items-center gap-3 px-4 py-3 rounded-md transition-all text-left border text-sm ${
                activeTab === 'subrecipes' 
                  ? 'bg-amber-500/10 border-amber-500/40 text-amber-400 font-medium' 
                  : 'border-transparent text-gray-400 hover:text-gray-200 hover:bg-[#141a29]/50'
              }`}
            >
              <Cpu size={18} />
              <span>Sản xuất Bán thành phẩm</span>
            </button>
          )}


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
              <div className="text-2xl font-bold text-gray-100">
                {userRole === 'admin' ? `${metrics.ingredientCost.toLocaleString()} đ` : '🔒 Khóa (Cấp 1)'}
              </div>
              <div className="text-[10px] text-gray-400 mt-1">
                Food Cost lý thuyết: <span className="text-amber-500 font-semibold">{userRole === 'admin' ? `${metrics.foodCostPct.toFixed(1)}%` : '🔒 Chỉ CFO'}</span>
              </div>
            </div>

            <div className="glass-panel rounded-md p-5 relative overflow-hidden">
              <div className="absolute top-0 right-0 w-24 h-24 bg-amber-500/5 rounded-full blur-2xl"></div>
              <div className="flex items-center justify-between text-gray-400 mb-2">
                <span className="text-xs uppercase tracking-wider font-sans">Giá trị Tồn kho Ước tính</span>
                <Package size={16} className="text-amber-500" />
              </div>
              <div className="text-2xl font-bold text-gray-100">
                {userRole === 'admin' ? `${metrics.inventoryValue.toLocaleString()} đ` : '🔒 Khóa (Cấp 1)'}
              </div>
              <div className="text-[10px] text-gray-400 mt-1">Tổng giá trị kho nguyên liệu tĩnh tại quầy</div>
            </div>

            <div className="glass-panel rounded-md p-5 relative overflow-hidden">
              <div className="absolute top-0 right-0 w-24 h-24 bg-amber-500/5 rounded-full blur-2xl"></div>
              <div className="flex items-center justify-between text-gray-400 mb-2">
                <span className="text-xs uppercase tracking-wider font-sans">Lệch kho (Variance)</span>
                <AlertTriangle size={16} className={metrics.varianceCost < 0 ? "text-rose-500 animate-pulse" : "text-[#d4af37]"} />
              </div>
              <div className={`text-2xl font-bold ${userRole === 'admin' ? (metrics.varianceCost < 0 ? "text-rose-400" : "text-emerald-400") : "text-gray-400"}`}>
                {userRole === 'admin' ? `${metrics.varianceCost > 0 ? "+" : ""}${metrics.varianceCost.toLocaleString()} đ` : '🔒 Khóa (Cấp 1)'}
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
                      const currentStock = getTheoreticalStock(ing.id);
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
                  <p className="text-xs text-gray-400">Tải lên file Excel POS (ví dụ: `BH ngày 1-13.06.2026.xls`) để khấu trừ tồn kho lý thuyết.</p>
                </div>
                
                <div className="flex flex-wrap items-center gap-3">
                  <button 
                    onClick={downloadPOSTemplate}
                    className="flex items-center gap-1.5 border border-amber-500/30 hover:bg-amber-500/5 text-amber-500 font-semibold text-xs px-3.5 py-2.5 rounded-sm transition-all shadow-md active:scale-95"
                  >
                    <Download size={14} />
                    <span>Tải file mẫu POS</span>
                  </button>
                  <label className="flex items-center gap-2 bg-gradient-to-r from-amber-600 to-amber-500 hover:from-amber-500 hover:to-[#f3e5ab] text-[#090d16] font-semibold text-xs px-4 py-2.5 rounded-sm transition-all shadow-md active:scale-95 cursor-pointer">
                    {isImporting ? <RefreshCw size={14} className="animate-spin" /> : <UploadCloud size={14} />}
                    <span>{isImporting ? "Đang xử lý..." : "Tải lên doanh số POS (.xls/.xlsx)"}</span>
                    <input 
                      type="file" 
                      accept=".xls,.xlsx" 
                      onChange={handleImportSalesExcel} 
                      className="hidden" 
                      disabled={isImporting} 
                    />
                  </label>
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
                  <h3 className="text-xl font-semibold text-[#d4af37] font-serif">Bảng Master Kho nguyên liệu ({ingredients.length} mã)</h3>
                  <p className="text-xs text-gray-400">Danh mục nguyên liệu và giá vốn. Bạn có thể chuẩn hóa nhanh bằng cách tải file Excel lên.</p>
                </div>
                
                <div className="flex flex-wrap items-center gap-3 w-full md:w-auto">
                  <button 
                    onClick={downloadIngredientsTemplate}
                    className="flex items-center gap-1.5 border border-amber-500/30 hover:bg-amber-500/5 text-amber-500 font-semibold text-xs px-3.5 py-2.5 rounded-sm transition-all shadow-md active:scale-95"
                  >
                    <Download size={14} />
                    <span>Tải file mẫu NVL</span>
                  </button>
                  <label className="flex items-center gap-2 bg-gradient-to-r from-amber-600 to-amber-500 hover:from-amber-500 hover:to-[#f3e5ab] text-[#090d16] font-semibold text-xs px-4 py-2.5 rounded-sm transition-all shadow-md active:scale-95 cursor-pointer">
                    <UploadCloud size={14} />
                    <span>Tải lên danh mục NVL</span>
                    <input 
                      type="file" 
                      accept=".xls,.xlsx" 
                      onChange={handleImportIngredientsExcel} 
                      className="hidden" 
                    />
                  </label>
                </div>
              </div>

              {/* BẢNG ĐIỀU KHIỂN MÔ PHỎNG VẬN HÀNH DÀNH CHO ADMIN & KẾ TOÁN KHO CẤP CAO */}
              {(userRole === 'admin' || userRole === 'senior_accountant' || userRole === 'head_chef') && (
                <div className="p-4 bg-[#0c1220]/60 border border-amber-500/20 rounded-md flex flex-col gap-4 font-sans">
                  <div className="flex items-center justify-between border-b border-amber-500/10 pb-2">
                    <div className="flex items-center gap-2">
                      <span className="w-2.5 h-2.5 bg-amber-500 rounded-full animate-pulse"></span>
                      <h4 className="text-xs uppercase tracking-wider text-amber-400 font-bold">ERP Operations Simulation (Mô phỏng Vận hành)</h4>
                    </div>
                    <span className="text-[10px] text-gray-400">Thời gian mô phỏng: <strong className="text-amber-500">{simulatedTime}</strong></span>
                  </div>
                  
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div className="flex flex-col gap-2 p-3 bg-[#090d16]/80 border border-amber-500/5 rounded">
                      <span className="text-xs font-semibold text-gray-200">1. Chốt giá Moving WAC (18:30)</span>
                      <p className="text-[10px] text-gray-400 leading-relaxed">
                        Đúng 18h30, hệ thống tự động khóa sổ nhập kho và tính toán giá vốn Bình quan gia quyền lũy tiến (WAC) cho tất cả nguyên liệu dựa trên hóa đơn trong ngày.
                      </p>
                      <div className="mt-2 flex items-center gap-2">
                        <button 
                          onClick={handleRunWacSimulation}
                          className="bg-amber-500/10 hover:bg-amber-500/20 border border-amber-500/30 text-amber-400 text-[11px] font-semibold px-3 py-1.5 rounded-sm transition-all"
                        >
                          Chạy chốt Moving WAC
                        </button>
                        {isWacLocked ? (
                          <span className="text-[10px] text-rose-400 flex items-center gap-1 font-semibold">🔒 Đang khóa sổ (Sau 18:30)</span>
                        ) : (
                          <span className="text-[10px] text-emerald-400 flex items-center gap-1 font-semibold">🔓 Đang mở (Trước 18:30)</span>
                        )}
                      </div>
                    </div>

                    <div className="flex flex-col gap-2 p-3 bg-[#090d16]/80 border border-amber-500/5 rounded">
                      <span className="text-xs font-semibold text-gray-200">2. Đơn đặt hàng tự động Auto-PO (22:40)</span>
                      <p className="text-[10px] text-gray-400 leading-relaxed">
                        Vào lúc 22h40 (sau khi trừ kho bán hàng), hệ thống tự động gom nhóm nguyên liệu có tồn &lt; 15 (min-stock) và tự sinh các file Excel đơn đặt hàng riêng biệt.
                      </p>
                      <div className="mt-2 flex items-center gap-2">
                        <button 
                          onClick={handleRunAutoPOSimulation}
                          className="bg-amber-500/10 hover:bg-amber-500/20 border border-amber-500/30 text-amber-400 text-[11px] font-semibold px-3 py-1.5 rounded-sm transition-all"
                        >
                          Chạy Auto-PO
                        </button>
                      </div>
                    </div>
                  </div>

                  {generatedPOs.length > 0 && (
                    <div className="border-t border-amber-500/10 pt-3 flex flex-col gap-2">
                      <span className="text-xs font-semibold text-gray-300">Danh sách File Đơn hàng Auto-PO đã sẵn sàng:</span>
                      <div className="flex flex-wrap gap-2">
                        {generatedPOs.map((po, i) => (
                          <button
                            key={i}
                            onClick={() => downloadGeneratedPOExcel(po)}
                            className="flex items-center gap-2 bg-amber-500/10 hover:bg-amber-500/20 border border-amber-500/30 text-amber-300 text-[10px] px-3 py-1.5 rounded transition-all"
                          >
                            <Download size={12} />
                            <span>{po.fileName} ({po.items.length} món)</span>
                          </button>
                        ))}
                      </div>
                    </div>
                  )}
                </div>
              )}

              {/* Filters row */}
              <div className="flex flex-col md:flex-row justify-end items-center gap-4">
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
                <div className="border-b border-amber-500/10 pb-4 flex flex-col gap-3">
                  <div className="flex justify-between items-center">
                    <h3 className="text-lg font-semibold text-[#d4af37] font-serif">Định mức món ăn ({Object.keys(recipes).length})</h3>
                  </div>
                  
                  <div className="flex gap-2">
                    <button 
                      onClick={downloadRecipesTemplate}
                      className="flex-1 flex items-center justify-center gap-1 border border-amber-500/30 hover:bg-amber-500/5 text-amber-500 font-semibold text-[10px] py-1.5 rounded transition-all"
                    >
                      <Download size={12} />
                      <span>Mẫu Excel</span>
                    </button>
                    <label className="flex-1 flex items-center justify-center gap-1 bg-amber-500/20 hover:bg-amber-500/30 text-amber-400 font-semibold text-[10px] py-1.5 rounded transition-all cursor-pointer text-center text-wrap justify-items-center">
                      <UploadCloud size={12} className="inline mr-1" />
                      <span>Tải định lượng</span>
                      <input 
                        type="file" 
                        accept=".xls,.xlsx" 
                        onChange={handleImportRecipesExcel} 
                        className="hidden" 
                      />
                    </label>
                  </div>
                  
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
                  <p className="text-xs text-gray-400">Nhập hoặc tải lên file Excel kiểm kho để tính chênh lệch tồn kho thực tế.</p>
                </div>
                
                <div className="flex flex-wrap items-center gap-3 w-full md:w-auto">
                  <button 
                    onClick={downloadStockTakeTemplate}
                    className="flex items-center gap-1.5 border border-amber-500/30 hover:bg-amber-500/5 text-amber-500 font-semibold text-xs px-3.5 py-2.5 rounded-sm transition-all shadow-md active:scale-95"
                  >
                    <Download size={14} />
                    <span>Tải file mẫu Kiểm kho</span>
                  </button>
                  <label className="flex items-center gap-2 bg-gradient-to-r from-amber-600 to-amber-500 hover:from-amber-500 hover:to-[#f3e5ab] text-[#090d16] font-semibold text-xs px-4 py-2.5 rounded-sm transition-all shadow-md active:scale-95 cursor-pointer">
                    <UploadCloud size={14} />
                    <span>Tải lên kết quả Kiểm kho</span>
                    <input 
                      type="file" 
                      accept=".xls,.xlsx" 
                      onChange={handleImportStockTakeExcel} 
                      className="hidden" 
                    />
                  </label>
                  <div className="flex items-center gap-2 bg-[#0c1220]/60 p-1.5 rounded border border-amber-500/10 text-xs">
                    <span className="text-gray-400 px-2 font-sans">Loại kho lọc:</span>
                    <button className="bg-amber-500/15 text-amber-400 px-3 py-1 rounded font-semibold uppercase text-[10px]">Tất cả Bếp</button>
                  </div>
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
                      const theoretical = getTheoreticalStock(ing.id);
                      const consumed = consumptionData.find(c => c.id === ing.id)?.qty || 0;
                      
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

          {/* TAB 6: SUB-RECIPES PRODUCTION */}
          {activeTab === 'subrecipes' && (
            <div className="glass-panel rounded-md p-6 flex flex-col gap-6">
              <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 border-b border-amber-500/10 pb-4">
                <div>
                  <h3 className="text-xl font-semibold text-[#d4af37] font-serif font-sans">Sản xuất Bán thành phẩm (Sub-recipes)</h3>
                  <p className="text-xs text-gray-400">Ghi nhận sản xuất nước sốt, nước dùng cốt. Hệ thống tự động trừ kho nguyên liệu thô tương ứng.</p>
                </div>
                
                <div className="flex items-center gap-3">
                  <button 
                    onClick={downloadSubRecipeTemplate}
                    className="flex items-center gap-1.5 border border-amber-500/30 hover:bg-amber-500/5 text-amber-500 font-semibold text-xs px-4 py-2.5 rounded-sm transition-all shadow-md active:scale-95"
                  >
                    <Download size={14} />
                    <span>Mẫu Excel Sản xuất</span>
                  </button>
                </div>
              </div>

              {subRecipeSuccess && (
                <div className="bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 p-4 rounded text-xs flex items-center gap-2">
                  <CheckCircle size={16} />
                  <span><strong>Ghi nhận thành công!</strong> Đã tăng lượng tồn kho bán thành phẩm và trừ khấu hao các nguyên liệu thô theo đúng định lượng cấu hình.</span>
                </div>
              )}

              <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                
                {/* Form to log production */}
                <div className="p-5 bg-[#0c1220]/50 rounded border border-amber-500/10 flex flex-col gap-4 lg:col-span-1">
                  <h4 className="text-sm font-semibold text-amber-400 uppercase tracking-wider font-serif font-sans">Khai báo sản xuất thủ công</h4>
                  
                  <form onSubmit={handleLogSubRecipeCooking} className="flex flex-col gap-4">
                    <div className="flex flex-col gap-1.5 font-sans">
                      <label className="text-xs text-gray-400">Chọn loại bán thành phẩm:</label>
                      <select 
                        value={selectedSubRecipe}
                        onChange={(e) => setSelectedSubRecipe(e.target.value)}
                        className="bg-[#090d16] border border-amber-500/20 rounded text-xs p-2.5 text-gray-200 focus:outline-none focus:border-amber-500"
                      >
                        {Object.entries(SUB_RECIPE_FORMULAS).map(([id, formula]) => (
                          <option key={id} value={id}>{formula.name} ({formula.unit})</option>
                        ))}
                      </select>
                    </div>

                    <div className="flex flex-col gap-1.5 font-sans">
                      <label className="text-xs text-gray-400">Số lượng nấu ra ({SUB_RECIPE_FORMULAS[selectedSubRecipe]?.unit}):</label>
                      <input 
                        type="number"
                        step="any"
                        value={cookedQty}
                        onChange={(e) => setCookedQty(e.target.value)}
                        className="bg-[#090d16] border border-amber-500/20 rounded text-xs p-2.5 text-gray-100 focus:outline-none focus:border-amber-500 font-mono"
                      />
                    </div>

                    <button 
                      type="submit"
                      className="w-full flex items-center justify-center gap-2 bg-gradient-to-r from-amber-600 to-amber-500 hover:from-amber-500 hover:to-[#f3e5ab] text-[#090d16] font-bold text-xs py-2.5 rounded-sm transition-all shadow-md active:scale-95"
                    >
                      <Cpu size={14} />
                      <span>Ghi nhận & Khấu trừ kho</span>
                    </button>
                  </form>

                  {/* Excel Upload Option */}
                  <div className="border-t border-amber-500/10 pt-4 mt-2 flex flex-col gap-2 font-sans">
                    <span className="text-[10px] text-gray-400 font-sans">Hoặc tải lên phiếu sản xuất hàng loạt:</span>
                    <label className="w-full flex items-center justify-center gap-2 border border-dashed border-amber-500/30 hover:border-amber-500/50 hover:bg-amber-500/5 text-amber-400 font-semibold text-xs py-2.5 rounded-sm transition-all cursor-pointer text-center font-sans">
                      <UploadCloud size={14} />
                      <span>Tải file sản xuất (.xls/.xlsx)</span>
                      <input 
                        type="file" 
                        accept=".xls,.xlsx" 
                        onChange={(e) => {
                          const file = e.target.files?.[0];
                          if (!file) return;
                          const reader = new FileReader();
                          reader.onload = (evt) => {
                            try {
                              const bstr = evt.target?.result;
                              const wb = XLSX.read(bstr, { type: 'binary' });
                              const ws = wb.Sheets[wb.SheetNames[0]];
                              const data = XLSX.utils.sheet_to_json<any[]>(ws, { header: 1 });
                              
                              let headerRowIdx = -1;
                              for (let i = 0; i < data.length; i++) {
                                const row = data[i] as any[];
                                if (row && row.includes('Mã BTP')) {
                                  headerRowIdx = i;
                                  break;
                                }
                              }
                              
                              if (headerRowIdx === -1) {
                                alert('Không tìm thấy cột "Mã BTP" trong file Excel.');
                                return;
                              }
                              
                              const headers = data[headerRowIdx] as any[];
                              const codeIdx = headers.indexOf('Mã BTP');
                              const qtyIdx = headers.indexOf('Số lượng nấu');
                              
                              const newTrans: {
                                id: string;
                                ingredientId: string;
                                type: 'import' | 'consumption' | 'stock_take' | 'waste';
                                qty: number;
                                unit_price: number;
                                status: 'pending' | 'approved' | 'rejected';
                                date: string;
                                note: string;
                              }[] = [];
                              const nowStr = new Date().toISOString().split('T')[0];
                              let successCount = 0;
                              
                              for (let i = headerRowIdx + 1; i < data.length; i++) {
                                const row = data[i] as any[];
                                if (!row || row.length <= codeIdx) continue;
                                const code = strVal(row[codeIdx]);
                                const qty = floatVal(row[qtyIdx]);
                                if (!code || isNaN(qty) || qty <= 0) continue;
                                
                                const formula = SUB_RECIPE_FORMULAS[code];
                                if (!formula) continue;
                                
                                const subRecipeIng = ingredients.find(i => i.id === code);
                                const subRecipePrice = subRecipeIng ? subRecipeIng.price : 0;
                                
                                newTrans.push({
                                  id: `sr-excel-add-${Date.now()}-${code}`,
                                  ingredientId: code,
                                  type: 'import' as const,
                                  qty: qty,
                                  unit_price: subRecipePrice,
                                  status: 'approved' as const,
                                  date: nowStr,
                                  note: `Sản xuất (Excel): Nấu ${qty} ${formula.unit} ${formula.name}`
                                });
                                
                                formula.ingredients.forEach(ing => {
                                  const rawIng = ingredients.find(i => i.id === ing.ing_id);
                                  const rawPrice = rawIng ? rawIng.price : 0;
                                  newTrans.push({
                                    id: `sr-excel-deduct-${Date.now()}-${code}-${ing.ing_id}`,
                                    ingredientId: ing.ing_id,
                                    type: 'waste' as const,
                                    qty: ing.qty * qty,
                                    unit_price: rawPrice,
                                    status: 'approved' as const,
                                    date: nowStr,
                                    note: `Tiêu hao nguyên liệu thô cho ${formula.name}`
                                  });
                                });
                                successCount++;
                              }
                              
                              if (successCount > 0) {
                                setTransactions(prev => [...prev, ...newTrans]);
                                setSubRecipeSuccess(true);
                                setTimeout(() => setSubRecipeSuccess(false), 4000);
                                alert(`Đã ghi nhận sản xuất hàng loạt thành công cho ${successCount} bán thành phẩm!`);
                              }
                            } catch (err) {
                              alert('Lỗi nhập file sản xuất: ' + (err as Error).message);
                            }
                          };
                          reader.readAsBinaryString(file);
                        }} 
                        className="hidden" 
                      />
                    </label>
                  </div>

                </div>

                {/* Formula display and transaction log */}
                <div className="lg:col-span-2 flex flex-col gap-6 font-sans">
                  
                  {/* Current selected formula ingredients preview */}
                  <div className="p-5 bg-[#0c1220]/30 rounded border border-amber-500/5">
                    <h4 className="text-sm font-semibold text-[#d4af37] font-serif mb-3 font-sans">
                      Định lượng thành phần của: <span className="text-gray-100 font-sans">{SUB_RECIPE_FORMULAS[selectedSubRecipe]?.name}</span>
                    </h4>
                    
                    <div className="overflow-x-auto">
                      <table className="w-full text-xs text-left text-gray-300 font-sans">
                        <thead className="bg-[#0c1220] uppercase text-gray-400 border-b border-amber-500/10 font-sans">
                          <tr>
                            <th className="px-4 py-2">Mã nguyên liệu thô</th>
                            <th className="px-4 py-2">Tên nguyên liệu thô</th>
                            <th className="px-4 py-2 text-right">Hao phí trên 1 đơn vị nấu</th>
                            <th className="px-4 py-2 text-right">Tổng tiêu hao dự kiến ({cookedQty} đơn vị)</th>
                            <th className="px-4 py-2 text-right">Tồn lý thuyết hiện tại</th>
                          </tr>
                        </thead>
                        <tbody className="divide-y divide-amber-500/5 font-sans">
                          {SUB_RECIPE_FORMULAS[selectedSubRecipe]?.ingredients.map((ing) => {
                            const detail = ingredients.find(i => i.id === ing.ing_id);
                            const currentStock = getTheoreticalStock(ing.ing_id);
                            const totalDeduction = ing.qty * (parseFloat(cookedQty) || 0);
                            return (
                              <tr key={ing.ing_id} className="hover:bg-[#141a29]/30 font-sans">
                                <td className="px-4 py-2 font-mono text-amber-500/70">{ing.ing_id}</td>
                                <td className="px-4 py-2 font-medium">{detail?.vi_name || 'Chưa rõ'}</td>
                                <td className="px-4 py-2 text-right font-mono">{ing.qty} {detail?.unit || 'kg'}</td>
                                <td className="px-4 py-2 text-right font-mono text-amber-400 font-semibold">{totalDeduction.toFixed(3)} {detail?.unit || 'kg'}</td>
                                <td className={`px-4 py-2 text-right font-mono ${currentStock < totalDeduction ? 'text-rose-400 font-bold' : 'text-gray-400'}`}>
                                  {currentStock.toFixed(3)} {detail?.unit || 'kg'} {currentStock < totalDeduction && '(Thiếu hụt!)'}
                                </td>
                              </tr>
                            );
                          })}
                        </tbody>
                      </table>
                    </div>
                  </div>

                  {/* Production logs (list of recently cooked transactions) */}
                  <div className="p-5 bg-[#0c1220]/30 rounded border border-amber-500/5 font-sans">
                    <h4 className="text-sm font-semibold text-[#d4af37] font-serif mb-3 font-sans">Nhật ký sản xuất gần đây</h4>
                    
                    <div className="overflow-x-auto max-h-56 font-sans">
                      <table className="w-full text-xs text-left text-gray-300 font-sans">
                        <thead className="bg-[#0c1220] uppercase text-gray-400 border-b border-amber-500/10 font-sans">
                          <tr>
                            <th className="px-4 py-2 font-sans">Thời gian</th>
                            <th className="px-4 py-2 font-sans">Mã NVL / BTP</th>
                            <th className="px-4 py-2 font-sans">Loại hoạt động</th>
                            <th className="px-4 py-2 text-right font-sans">Số lượng</th>
                            <th className="px-4 py-2 font-sans">Mô tả chi tiết</th>
                          </tr>
                        </thead>
                        <tbody className="divide-y divide-amber-500/5 font-mono font-sans">
                          {transactions.filter(t => t.id.startsWith('sr-')).slice(-8).reverse().map((t) => {
                            const detail = ingredients.find(i => i.id === t.ingredientId);
                            return (
                              <tr key={t.id} className="hover:bg-[#141a29]/30 font-sans">
                                <td className="px-4 py-2 text-gray-400 text-[10px]">{t.date}</td>
                                <td className="px-4 py-2 font-semibold text-amber-500/80">{t.ingredientId}</td>
                                <td className="px-4 py-2">
                                  <span className={`px-1.5 py-0.5 rounded text-[9px] font-semibold uppercase ${t.type === 'import' ? 'bg-emerald-500/10 text-emerald-400' : 'bg-amber-500/10 text-amber-400'}`}>
                                    {t.type === 'import' ? 'NHẬP BTP' : 'TRỪ THÔ'}
                                  </span>
                                </td>
                                <td className={`px-4 py-2 text-right font-semibold ${t.type === 'import' ? 'text-emerald-400' : 'text-rose-400'}`}>
                                  {t.type === 'import' ? '+' : '-'}{t.qty.toFixed(2)} {detail?.unit || 'kg'}
                                </td>
                                <td className="px-4 py-2 text-gray-300 text-[10px] font-sans">{t.note}</td>
                              </tr>
                            );
                          })}
                          {transactions.filter(t => t.id.startsWith('sr-')).length === 0 && (
                            <tr>
                              <td colSpan={5} className="px-4 py-6 text-center text-gray-500 font-sans font-normal">Chưa có bản ghi sản xuất nào được thực hiện trong phiên này.</td>
                            </tr>
                          )}
                        </tbody>
                      </table>
                    </div>
                  </div>

                </div>

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

      {showMappingModal && (
        <div className="fixed inset-0 bg-black/85 backdrop-blur-md z-50 flex items-center justify-center p-4">
          <div className="bg-[#0c1220] border border-amber-500/30 w-full max-w-5xl rounded-md p-6 flex flex-col gap-6 shadow-2xl relative">
            <div className="absolute top-0 right-0 w-48 h-48 bg-amber-500/5 rounded-full blur-3xl"></div>
            
            <div className="flex justify-between items-center border-b border-amber-500/20 pb-4">
              <div>
                <h3 className="text-xl font-semibold text-[#d4af37] font-serif">MÀN HÌNH MAPPING TRUNG GIAN & XÁC NHẬN GHI SỔ</h3>
                <p className="text-xs text-gray-400 mt-1">Rà soát và đồng bộ mã hàng POS với cơ sở dữ liệu định lượng (Recipes).</p>
              </div>
              <div className="flex items-center gap-3">
                <div className="bg-amber-500/10 border border-amber-500/30 px-3 py-1.5 rounded flex items-center gap-2">
                  <span className="w-2 h-2 bg-amber-500 rounded-full animate-ping"></span>
                  <span className="text-xs font-mono font-bold text-amber-400">Chốt tự động sau: {mappingCountdown}s</span>
                </div>
                <button 
                  onClick={handleConfirmMapping}
                  className="bg-gradient-to-r from-amber-600 to-amber-500 hover:from-amber-500 hover:to-[#f3e5ab] text-[#090d16] font-bold text-xs px-4 py-2.5 rounded shadow active:scale-95"
                >
                  Xác nhận chốt sổ ngay
                </button>
              </div>
            </div>

            <div className="overflow-y-auto max-h-[400px] border border-amber-500/10 rounded">
              <table className="w-full text-xs text-left text-gray-300">
                <thead className="bg-[#0c1220] sticky top-0 uppercase text-gray-400 border-b border-amber-500/10">
                  <tr>
                    <th className="px-4 py-3">Mã POS</th>
                    <th className="px-4 py-3">Tên hàng trên POS</th>
                    <th className="px-4 py-3 text-center">Trạng thái</th>
                    <th className="px-4 py-3 text-center">Độ chính xác</th>
                    <th className="px-4 py-3">Đối khớp Recipe ID</th>
                    <th className="px-4 py-3 text-right">Số lượng</th>
                    <th className="px-4 py-3 text-right">Giá bán</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-amber-500/5 font-sans">
                  {mappingItems.map((item, idx) => (
                    <tr key={idx} className="hover:bg-[#141a29]/30">
                      <td className="px-4 py-3 font-mono text-amber-500/70 font-semibold">{item.code}</td>
                      <td className="px-4 py-3 font-medium text-gray-100">{item.name}</td>
                      <td className="px-4 py-3 text-center">
                        {item.status === 'matched' ? (
                          <span className="inline-flex items-center gap-1.5 px-2 py-0.5 rounded text-[10px] bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 font-semibold uppercase">
                            🟢 Khớp 100%
                          </span>
                        ) : item.status === 'suggested' ? (
                          <span className="inline-flex items-center gap-1.5 px-2 py-0.5 rounded text-[10px] bg-amber-500/10 text-amber-400 border border-amber-500/20 font-semibold uppercase">
                            🟡 Gợi ý
                          </span>
                        ) : (
                          <span className="inline-flex items-center gap-1.5 px-2 py-0.5 rounded text-[10px] bg-rose-500/10 text-rose-400 border border-rose-500/20 font-semibold uppercase">
                            🔴 Bỏ qua
                          </span>
                        )}
                      </td>
                      <td className="px-4 py-3 text-center font-mono font-bold text-gray-300">
                        {item.status === 'matched' ? '100%' : item.status === 'suggested' ? `${item.accuracy}%` : '—'}
                      </td>
                      <td className="px-4 py-3">
                        <select
                          value={item.matchedRecipeId}
                          onChange={(e) => {
                            const updated = [...mappingItems];
                            updated[idx] = {
                              ...item,
                              matchedRecipeId: e.target.value,
                              status: e.target.value === 'IGNORE' ? 'unmatched' : e.target.value === item.code ? 'matched' : 'suggested'
                            };
                            setMappingItems(updated);
                          }}
                          className="bg-[#090d16] border border-amber-500/20 text-xs rounded px-2 py-1 text-gray-200 focus:outline-none focus:border-amber-500 font-mono w-44"
                        >
                          <option value="IGNORE">❌ Bỏ qua kho (Ignore)</option>
                          {Object.keys(recipes).map(code => (
                            <option key={code} value={code}>📖 {code} - {recipes[code].name.slice(0, 20)}...</option>
                          ))}
                        </select>
                      </td>
                      <td className="px-4 py-3 text-right font-mono font-semibold">{item.qty}</td>
                      <td className="px-4 py-3 text-right font-mono text-gray-400">{item.price.toLocaleString()} đ</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            <div className="flex justify-between items-center text-xs text-gray-400 border-t border-amber-500/10 pt-4">
              <p>• Mã màu xanh lá 🟢 sẽ được chốt tự động. Các mã màu vàng 🟡 đã được dự đoán dựa trên khoảng cách ký tự.</p>
              <div className="flex gap-3">
                <button 
                  onClick={() => setShowMappingModal(false)}
                  className="border border-gray-700 hover:bg-gray-800 text-gray-300 px-4 py-2 rounded text-xs font-semibold"
                >
                  Hủy bỏ
                </button>
                <button 
                  onClick={handleConfirmMapping}
                  className="bg-gradient-to-r from-amber-600 to-amber-500 hover:from-amber-500 hover:to-[#f3e5ab] text-[#090d16] font-bold text-xs px-5 py-2 rounded shadow"
                >
                  Xác nhận ghi sổ & Trừ kho
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
