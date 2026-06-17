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
  order_type?: 'DINE_IN' | 'TAKEAWAY';
  mapping_status?: 'MAPPED' | 'UNMAPPED' | 'RESOLVED' | 'NO_STOCK_IMPACT';
}

// Map POS codes to recipe codes
export const POS_MAPPING: Record<string, { recipe: string; type: 'alc' | 'set' | 'beer' }> = {
  "B5001": { recipe: "B5001", type: "beer" }, // Heineken - 33cl
  "B5002": { recipe: "B5002", type: "beer" }, // Tiger - 33cl
  "B5004": { recipe: "B5004", type: "beer" }, // Beer 333 - 33cl
  "B5005": { recipe: "B5005", type: "beer" }, // Saigon beer - 33cl
  "B5007": { recipe: "B5007", type: "beer" }, // Sapporo draught
  "B5010": { recipe: "B5010", type: "beer" }, // Hanoi - 33cl
  "B5012": { recipe: "B5012", type: "beer" }, // Hanoi - can
  "B5016": { recipe: "B5016", type: "beer" }, // Leffe - Belgian beer - bottle 33cl
  "M9203": { recipe: "M9203", type: "beer" }, // Cigar Havana
  "M6001": { recipe: "M6001", type: "beer" }, // Coke
  "M6002": { recipe: "M6002", type: "beer" }, // Soda
  "M6003": { recipe: "M6003", type: "beer" }, // Tonic
  "M6004": { recipe: "M6004", type: "beer" }, // Sprite
  "M6006": { recipe: "M6006", type: "beer" }, // Diet Coke
  "M6008": { recipe: "M6008", type: "beer" }, // La Vie 1,5 L
  "M6010": { recipe: "M6010", type: "beer" }, // S.Pellegrino (Sparkling water 0.5L)
  "M6020": { recipe: "M6020", type: "beer" }, // Maison Vie, mineral water bottle 0,52L
  "V1001": { recipe: "V1001", type: "alc" }, // Chateau Noaillac Medoc Cru Bourgeois 37.5cl (R)
  "V2002": { recipe: "V2002", type: "alc" }, // Larousse Chardonnay Sparkling, France
  "V4045": { recipe: "V4045", type: "alc" }, // Louis Latour - Bourgogne Pinot Noir
  "V4064": { recipe: "V4064", type: "alc" }, // F. Thienpont Causse Rouge Merlot, Bordeaux - Red
  "V4065": { recipe: "V4065", type: "alc" }, // Baron P. de Rothschild Mouton Cadet Bordeaux - Red
  "V4075": { recipe: "V4075", type: "alc" }, // Louis Latour Pinot Noir Les Pierres Dorées - Red
  "V4088": { recipe: "V4088", type: "alc" }, // Château Baratet, Cabernet Sauvignon, France
  "V4091": { recipe: "V4091", type: "alc" }, // Bernard Magrez « Le Prélat » Rouge Côtes du Rhône Villages Laudun
  "V6027": { recipe: "V6027", type: "alc" }, // Luis Felipe Chardonnay
  "V6034": { recipe: "V6034", type: "alc" }, // Frontera Cabernet Sauvignon 75cl (Red)
  "V6056": { recipe: "V6056", type: "alc" }, // MontGras Estate Cabernet Sauvignon Chile
  "V6059": { recipe: "V6059", type: "alc" }, // Montes Classic Series Chardonnay (CuricóValley DO — Chile)
  "V9410": { recipe: "V9410", type: "alc" }, // Dufouleur Monopole Rose Wine
  "V9501": { recipe: "V9501", type: "alc" }, // Dalat Wine Red - Bottle
  "V9502": { recipe: "V9502", type: "alc" }, // Dalat Wine White - Bottle
  "M7001": { recipe: "M7001", type: "alc" }, // Fresh orange juice
  "M7002": { recipe: "M7002", type: "alc" }, // Fresh lemon juice
  "M7003": { recipe: "M7003", type: "alc" }, // Mixed Seasonal fresh fruit juice
  "M7005": { recipe: "M7005", type: "alc" }, // Water Melon Juice
  "M7006": { recipe: "M7006", type: "alc" }, // Mango Juice
  "M7007": { recipe: "M7007", type: "alc" }, // Passion juice
  "M7008": { recipe: "M7008", type: "alc" }, // Pomelo Juice
  "M7009": { recipe: "M7009", type: "alc" }, // Pineapple Juice
  "M7010": { recipe: "M7010", type: "alc" }, // Apple Juice
  "M7012": { recipe: "M7012", type: "alc" }, // Margarita
  "M7015": { recipe: "M7015", type: "alc" }, // Singapore Sling
  "M7018": { recipe: "M7018", type: "alc" }, // Black Russian
  "M7021": { recipe: "M7021", type: "alc" }, // Pineapple Cooler
  "M7020": { recipe: "M7020", type: "alc" }, // Sangria
  "M7022": { recipe: "M7022", type: "alc" }, // Detox Juice
  "M7023": { recipe: "M7023", type: "alc" }, // Watermelon Cooler
  "M7025": { recipe: "M7025", type: "alc" }, // Sunset Citrus Cooler
  "M7028": { recipe: "M7028", type: "alc" }, // Cucumber Lime Cooler
  "M7030": { recipe: "M7030", type: "alc" }, // Virgin Mojito
  "M7031": { recipe: "M7031", type: "alc" }, // Mango Mojito
  "M7032": { recipe: "M7032", type: "alc" }, // Mojito
  "M7033": { recipe: "M7033", type: "alc" }, // Piña Colada
  "M7034": { recipe: "M7034", type: "alc" }, // Whisky Sour
  "M7035": { recipe: "M7035", type: "alc" }, // Tom Collins
  "M7036": { recipe: "M7036", type: "alc" }, // Tequila Sunrise
  "M7037": { recipe: "M7037", type: "alc" }, // Daiquiri
  "M7038": { recipe: "M7038", type: "alc" }, // Kir Royal
  "M7039": { recipe: "M7039", type: "alc" }, // Campari Soda
  "M7040": { recipe: "M7040", type: "alc" }, // Campari Orange
  "M8001": { recipe: "M8001", type: "alc" }, // Gin and Tonic
  "M8002": { recipe: "M8002", type: "alc" }, // Whisky & soda
  "M9001": { recipe: "M9001", type: "alc" }, // Espresso coffee
  "M9002": { recipe: "M9002", type: "alc" }, // Cappuccino
  "M9003": { recipe: "M9003", type: "alc" }, // Regular coffee
  "M9004": { recipe: "M9004", type: "alc" }, // Ice coffee
  "M9005": { recipe: "M9005", type: "alc" }, // Lipton tea
  "M9006": { recipe: "M9006", type: "alc" }, // Ice Lipton tea
  "M9008": { recipe: "M9008", type: "alc" }, // Vietnamese ice tea
  "M9009": { recipe: "M9009", type: "alc" }, // Olong tea (pot)
  "M9010": { recipe: "M9010", type: "alc" }, // Double Espresso
  "M9011": { recipe: "M9011", type: "alc" }, // Latte Coffee
  "M9012": { recipe: "M9012", type: "alc" }, // Americano Coffee
  "M9013": { recipe: "M9013", type: "alc" }, // Vietnamese tea Pot (Ấm Trà Mạn Thái Nguyên)
  "M9014": { recipe: "M9014", type: "alc" }, // Earl grey tea
  "M9015": { recipe: "M9015", type: "alc" }, // Mocha Coffee
  "M9016": { recipe: "M9016", type: "alc" }, // Vietnamese milk coffee
  "M9017": { recipe: "M9017", type: "alc" }, // Jasmine Tea
  "M9018": { recipe: "M9018", type: "alc" }, // Lotus Tea
  "M9101": { recipe: "M9101", type: "alc" }, // Red wine glass - FRANCE
  "M9102": { recipe: "M9102", type: "alc" }, // White wine glass - FRANCE
  "M9104": { recipe: "M9104", type: "alc" }, // White wine glass CHILE - Luis Felipe
  "M9106": { recipe: "M9106", type: "alc" }, // Dalat red wine glass
  "M9107": { recipe: "M9107", type: "alc" }, // Dalat white wine glass
  "M9109": { recipe: "M9109", type: "alc" }, // Rose wine France (glass)
  "M9121": { recipe: "M9121", type: "alc" }, // Pierre Larousse Sparkling Brut -  Glass
  "M9204": { recipe: "M9204", type: "alc" }, // Cigar Cohiba Siglo VI
  "R1121": { recipe: "R-001", type: "alc" },
  "R3125": { recipe: "R-004", type: "alc" },
  "R3126": { recipe: "R-002", type: "alc" },
  "R3127": { recipe: "R-011", type: "alc" },
  "R1008": { recipe: "R-006", type: "alc" },
  "R1024": { recipe: "R-008", type: "alc" },
  "R1025": { recipe: "R-009", type: "alc" },
  "R1122": { recipe: "R-010", type: "alc" },
  "R2141": { recipe: "R-012", type: "alc" },
  "R2142": { recipe: "R-019", type: "alc" },
  "R2145": { recipe: "R-012", type: "alc" },
  "R2148": { recipe: "R-017", type: "alc" },
  "R2149": { recipe: "R-018", type: "alc" },
  "R2150": { recipe: "R-018", type: "alc" },
  "R5117": { recipe: "R-021", type: "alc" },
  "R5114": { recipe: "R-022", type: "alc" },
  "R5113": { recipe: "R-023", type: "alc" },
  "R5103": { recipe: "R-024", type: "alc" },
  "R5118": { recipe: "R-025", type: "alc" },
  "R2144": { recipe: "R-028", type: "alc" },
  "R6212": { recipe: "deg_set_5", type: "set" },
  "R6213": { recipe: "deg_set_6", type: "set" },
  "R6218": { recipe: "deg_set_7", type: "set" },
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
