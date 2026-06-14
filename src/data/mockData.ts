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

export const getIngredients = (): Ingredient[] => dbData.ingredients as Ingredient[];
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
          // Add 10% wastage buffer
          const totalDeduction = ing.qty_eff * qty * 1.10;
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
