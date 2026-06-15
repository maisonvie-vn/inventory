import dbData from './db.json';

export interface Ingredient {
  id: string;
  fr_name: string;
  vi_name: string;
  en_name: string;
  category: string;
  supplier_tier: string;
  unit: string;
  price: number;
  yield_rate: number;
  stock_uom?: string;
  recipe_uom?: string;
  stock_to_recipe_factor?: number;
  tolerance_percent?: number;
  tare_weight_grams?: number;
}

export interface RecipeIngredient {
  ing_id: string;
  qty_net: number;
  unit: string;
  yield_pct: number;
  qty_eff: number;
  unit_price: number;
  line_cost: number;
}

export interface RecipeStep {
  step: string;
  description: string;
}

export interface Recipe {
  code: string;
  name: string;
  course: string;
  category: string;
  menu_role: string;
  price: number;
  ingredients: RecipeIngredient[];
  method: RecipeStep[];
  notes: string;
}

export interface SaleRecord {
  code: string;
  name: string;
  price: number;
  qty: number;
  total_before_discount: number;
  discount: number;
  discount_pct: number;
  service_charge: number;
  tax: number;
}

// Map POS codes to recipe codes
export const POS_MAPPING: Record<string, { recipe: string; type: 'alc' | 'set' | 'beer' }> = {
  // Beer
  "B5001": { recipe: "ING-056", type: "beer" }, // Heineken - mapped to its raw material or self
  "B5002": { recipe: "ING-057", type: "beer" }, // Tiger
  "B5004": { recipe: "ING-058", type: "beer" }, // 333
  "B5005": { recipe: "ING-060", type: "beer" }, // Saigon
  "B5007": { recipe: "ING-061", type: "beer" }, // Sapporo
  // Food
  "R1121": { recipe: "R-001", type: "alc" }, // Tuna carpaccio
  "R3125": { recipe: "R-004", type: "alc" }, // Scallops
  "R3126": { recipe: "R-002", type: "alc" }, // Salmon gravlax
  "R3127": { recipe: "R-011", type: "alc" }, // Black cod miso
  "R1008": { recipe: "R-006", type: "alc" }, // Onion soup
  "R1024": { recipe: "R-008", type: "alc" }, // Mushroom soup
  "R1025": { recipe: "R-009", type: "alc" }, // Snails Burgundy
  "R1122": { recipe: "R-010", type: "alc" }, // Foie gras
  "R2141": { recipe: "R-012", type: "alc" }, // Buffalo Wellington
  "R2142": { recipe: "R-019", type: "alc" }, // Wagyu ribeye
  "R2145": { recipe: "R-012", type: "alc" }, // Beef Wellington
  "R2148": { recipe: "R-017", type: "alc" }, // Duck breast
  "R2149": { recipe: "R-018", type: "alc" }, // Lamb rack
  "R2150": { recipe: "R-018", type: "alc" }, // Lamb shank
  "R5117": { recipe: "R-021", type: "alc" }, // Cheeses
  "R5114": { recipe: "R-022", type: "alc" }, // Soufflé
  "R5113": { recipe: "R-023", type: "alc" }, // Chocolate mousse
  "R5103": { recipe: "R-024", type: "alc" }, // Crème Brûlée
  "R5118": { recipe: "R-025", type: "alc" }, // Fresh fruits
  "R2144": { recipe: "R-028", type: "alc" }, // Black Angus
  // Set Menus
  "R6212": { recipe: "deg_set_5", type: "set" }, // Tasting 5 courses
  "R6213": { recipe: "deg_set_6", type: "set" }, // Tasting 6 courses
  "R6218": { recipe: "deg_set_7", type: "set" }, // Tasting 7 courses

  // Auto-imported Excel Set Menus & Tour Sets
  "SET1250": { recipe: "SET1250", type: "alc" },
  "SET1550": { recipe: "SET1550", type: "alc" },
  "SET1800": { recipe: "SET1800", type: "alc" },
  "SET2000": { recipe: "SET2000", type: "alc" },
  "SET370": { recipe: "SET370", type: "alc" },
  "SET470": { recipe: "SET470", type: "alc" },
  "SET600": { recipe: "SET600", type: "alc" },
  "SET770": { recipe: "SET770", type: "alc" },
  "SET970": { recipe: "SET970", type: "alc" },
  "T1100A": { recipe: "T1100A", type: "alc" },
  "T1100B": { recipe: "T1100B", type: "alc" },
  "T1100C": { recipe: "T1100C", type: "alc" },
  "T1100D": { recipe: "T1100D", type: "alc" },
  "T1200A": { recipe: "T1200A", type: "alc" },
  "T1200B": { recipe: "T1200B", type: "alc" },
  "T1250A": { recipe: "T1250A", type: "alc" },
  "T1500A": { recipe: "T1500A", type: "alc" },
  "T1500B": { recipe: "T1500B", type: "alc" },
  "T1550A": { recipe: "T1550A", type: "alc" },
  "T1800A": { recipe: "T1800A", type: "alc" },
  "T2000A": { recipe: "T2000A", type: "alc" },
  "T290A": { recipe: "T290A", type: "alc" },
  "T370A": { recipe: "T370A", type: "alc" },
  "T380A": { recipe: "T380A", type: "alc" },
  "T380B": { recipe: "T380B", type: "alc" },
  "T380C": { recipe: "T380C", type: "alc" },
  "T380D": { recipe: "T380D", type: "alc" },
  "T380E": { recipe: "T380E", type: "alc" },
  "T380F": { recipe: "T380F", type: "alc" },
  "T380H": { recipe: "T380H", type: "alc" },
  "T380J": { recipe: "T380J", type: "alc" },
  "T380K": { recipe: "T380K", type: "alc" },
  "T380N": { recipe: "T380N", type: "alc" },
  "T430G": { recipe: "T430G", type: "alc" },
  "T470A": { recipe: "T470A", type: "alc" },
  "T500A": { recipe: "T500A", type: "alc" },
  "T500B": { recipe: "T500B", type: "alc" },
  "T500C": { recipe: "T500C", type: "alc" },
  "T500D": { recipe: "T500D", type: "alc" },
  "T500E": { recipe: "T500E", type: "alc" },
  "T600A": { recipe: "T600A", type: "alc" },
  "T600B": { recipe: "T600B", type: "alc" },
  "T600D": { recipe: "T600D", type: "alc" },
  "T650A": { recipe: "T650A", type: "alc" },
  "T650B": { recipe: "T650B", type: "alc" },
  "T650C": { recipe: "T650C", type: "alc" },
  "T770A": { recipe: "T770A", type: "alc" },
  "T770B": { recipe: "T770B", type: "alc" },
  "T850A": { recipe: "T850A", type: "alc" },
  "T850B": { recipe: "T850B", type: "alc" },
  "T850C": { recipe: "T850C", type: "alc" },
  "T850D": { recipe: "T850D", type: "alc" },
  "T950A": { recipe: "T950A", type: "alc" },
  "T950B": { recipe: "T950B", type: "alc" },
  "T970A": { recipe: "T970A", type: "alc" },
};

export const SET_MENU_DEFINITIONS: Record<string, string[]> = {
  "deg_set_5": [
    "R-001_DEG", // Carpaccio Thon
    "R-008_DEG", // Velouté Tam Đảo
    "R-011_DEG", // Cabillaud Miso
    "R-012_DEG", // Wellington Buffle
    "R-023_DEG"  // Chocolat VN
  ],
  "deg_set_6": [
    "R-001_DEG", // Carpaccio Thon
    "R-008_DEG", // Velouté Tam Đảo
    "R-011_DEG", // Cabillaud Miso
    "R-026_DEG", // Sorbet Intermezzo
    "R-012_DEG", // Wellington Buffle
    "R-023_DEG"  // Chocolat VN
  ],
  "deg_set_7": [
    "R-001_DEG", // Carpaccio Thon
    "R-008_DEG", // Velouté Tam Đảo
    "R-011_DEG", // Cabillaud Miso
    "R-026_DEG", // Sorbet Intermezzo
    "R-012_DEG", // Wellington Buffle
    "R-021_DEG", // Fromages
    "R-023_DEG"  // Chocolat VN
  ]
};

export const getIngredients = (): Ingredient[] => {
  return (dbData.ingredients as any[]).map(ing => {
    // Ngưỡng tolerance theo nhóm hàng ABC
    let tolerance = 5.0;
    if (['Seafood', 'Meat', 'Wine', 'Alcohol'].includes(ing.category)) {
      tolerance = 2.0; // Nhóm A: 2%
    } else if (['Vegetable', 'Herb', 'Fruit'].includes(ing.category)) {
      tolerance = 10.0; // Nhóm C: 10%
    }

    // Thiết lập đơn vị và hệ số quy đổi mặc định
    let factor = 1;
    let recipe_uom = ing.unit;
    let stock_uom = ing.unit;
    
    // Quy đổi đặc thù cho v8.0
    if (['Wine', 'Alcohol'].includes(ing.category) || ing.id.startsWith('ING-069') || ing.id.startsWith('ING-070') || ing.id.startsWith('ING-071')) {
      // Rượu: Tồn theo BOTTLE (Chai), công thức dùng ML
      stock_uom = 'BOTTLE';
      recipe_uom = 'ML';
      factor = 750; // 1 Chai = 750 ML
    } else if (ing.id === 'ING-021') {
      // Trứng: Tồn theo CASE (Thùng), công thức dùng cái (pc)
      stock_uom = 'CASE';
      recipe_uom = 'pc';
      factor = 300; // 1 Thùng = 300 Quả
    } else if (ing.unit === 'kg') {
      // Nguyên liệu khô/thực phẩm: Tồn theo KG, công thức dùng Gram (g)
      recipe_uom = 'g';
      factor = 1000;
    }

    // Trọng lượng vỏ chai rỗng (Tare weight) cho rượu Bar
    let tareWeight = 0;
    if (['Wine', 'Alcohol', 'Beverage'].includes(ing.category)) {
      tareWeight = 450; // Mặc định vỏ chai nặng 450g
    }

    return {
      ...ing,
      stock_uom,
      recipe_uom,
      stock_to_recipe_factor: factor,
      tolerance_percent: tolerance,
      tare_weight_grams: tareWeight
    };
  }) as unknown as Ingredient[];
};
export const getRecipes = (): Record<string, Recipe> => dbData.recipes as unknown as Record<string, Recipe>;
export const getSales = (): SaleRecord[] => dbData.sales as SaleRecord[];

// Calculate total sales revenue and statistics
export const getSalesSummary = () => {
  const sales = getSales();
  let totalRevenue = 0;
  let totalQty = 0;
  let totalDiscount = 0;
  let totalTax = 0;
  let totalServiceCharge = 0;

  sales.forEach(s => {
    totalRevenue += s.total_before_discount;
    totalQty += s.qty;
    totalDiscount += s.discount;
    totalTax += s.tax;
    totalServiceCharge += s.service_charge;
  });

  return {
    totalRevenue,
    totalQty,
    totalDiscount,
    netRevenue: totalRevenue - totalDiscount + totalServiceCharge + totalTax,
    totalTax,
    totalServiceCharge,
  };
};

// Calculate simulated ingredient consumption
export const getSimulatedConsumption = () => {
  const sales = getSales();
  const recipes = getRecipes();
  const ingredients = getIngredients();
  
  const ingMap = new Map<string, Ingredient>();
  ingredients.forEach(i => ingMap.set(i.id, i));
  
  const consumption: Record<string, number> = {};

  sales.forEach(sale => {
    const mapping = POS_MAPPING[sale.code];
    if (!mapping) return;

    const qty = sale.qty;
    const { recipe, type } = mapping;

    if (type === 'beer') {
      // Beers are direct inventory items
      consumption[recipe] = (consumption[recipe] || 0) + qty;
    } else if (type === 'alc') {
      const r = recipes[recipe];
      if (r && r.ingredients) {
        r.ingredients.forEach(ing => {
          // Bỏ hệ số 1.10 hao hụt ảo và chia cho hệ số quy đổi tồn -> công thức (mặc định 1)
          const ingObj = ingMap.get(ing.ing_id) as any;
          const factor = ingObj?.stock_to_recipe_factor || 1;
          const totalDeduction = (ing.qty_eff * qty) / factor;
          consumption[ing.ing_id] = (consumption[ing.ing_id] || 0) + totalDeduction;
        });
      }
    } else if (type === 'set') {
      const subRecipes = SET_MENU_DEFINITIONS[recipe] || [];
      subRecipes.forEach(sub => {
        const r = recipes[sub];
        if (r && r.ingredients) {
          r.ingredients.forEach(ing => {
            // Bỏ hệ số 1.10 hao hụt ảo và chia cho hệ số quy đổi tồn -> công thức (mặc định 1)
            const ingObj = ingMap.get(ing.ing_id) as any;
            const factor = ingObj?.stock_to_recipe_factor || 1;
            const totalDeduction = (ing.qty_eff * qty) / factor;
            consumption[ing.ing_id] = (consumption[ing.ing_id] || 0) + totalDeduction;
          });
        }
      });
    }
  });

  // Convert to array and calculate costs
  const result = Object.entries(consumption).map(([ingId, qty]) => {
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
  });

  return result.sort((a, b) => b.totalCost - a.totalCost);
};
