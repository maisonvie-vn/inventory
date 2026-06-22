import dbData from './db.json';

export interface Ingredient {
  id: string;
  code?: string;
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
  min_stock?: number;
  max_stock?: number;
  safety_stock?: number;
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
  "000": { recipe: "000", type: "alc" }, // Open Menu Food
  "0001": { recipe: "0001", type: "alc" }, // MK
  "001": { recipe: "001", type: "beer" }, // Open Menu Drink
  "B5001": { recipe: "B5001", type: "beer" }, // Heineken - 33cl
  "B5002": { recipe: "B5002", type: "beer" }, // Tiger - 33cl
  "B5003": { recipe: "B5003", type: "beer" }, // Halida,  33cl
  "B5004": { recipe: "B5004", type: "beer" }, // Beer 333 - 33cl
  "B5005": { recipe: "B5005", type: "beer" }, // Saigon beer - 33cl
  "B5006": { recipe: "B5006", type: "beer" }, // Pilsner - 33cl
  "B5007": { recipe: "B5007", type: "beer" }, // Sapporo draught
  "B5008": { recipe: "B5008", type: "beer" }, // Sapporo — bottle 33cl
  "B5009": { recipe: "B5009", type: "beer" }, // Bitburger - Germany - bottle 33cl
  "B5010": { recipe: "B5010", type: "beer" }, // Hanoi - 33cl
  "B5011": { recipe: "B5011", type: "beer" }, // Truc Bach Beer
  "B5012": { recipe: "B5012", type: "beer" }, // Hanoi - can
  "B5013": { recipe: "B5013", type: "beer" }, // Carlsberg draught
  "B5014": { recipe: "B5014", type: "beer" }, // Sagota— Alcohol free beer 33cl
  "B5015": { recipe: "B5015", type: "beer" }, // Radbuz draught
  "B5016": { recipe: "B5016", type: "beer" }, // Leffe - Belgian beer - bottle 33cl
  "B5017": { recipe: "B5017", type: "beer" }, // Hanoi Bia Hơi 500ml
  "DE1001": { recipe: "DE1001", type: "alc" }, // Sandwich - Ham and Cheese
  "DE1002": { recipe: "DE1002", type: "alc" }, // Sandwich -Smoked Salmon
  "DE1003": { recipe: "DE1003", type: "alc" }, // Set Hải Sản Gồm Rượu
  "DE1004": { recipe: "DE1004", type: "alc" }, // Roasted Chicken
  "DE1005": { recipe: "DE1005", type: "alc" }, // Roasted Chicken with Hanoi Bia Hơi
  "DE1006": { recipe: "DE1006", type: "alc" }, // Grilled Pork Rib
  "M1001": { recipe: "M1001", type: "beer" }, // Campari Glass
  "M1002": { recipe: "M1002", type: "beer" }, // Martini Rosso Glass
  "M1003": { recipe: "M1003", type: "beer" }, // Martini Bianco Glass
  "M1004": { recipe: "M1004", type: "beer" }, // Martini Dry Glass
  "M1005": { recipe: "M1005", type: "beer" }, // Ricard Glass
  "M1006": { recipe: "M1006", type: "beer" }, // Porto Glass
  "M1007": { recipe: "M1007", type: "beer" }, // Kir Glass
  "M2001": { recipe: "M2001", type: "beer" }, // Cointreau
  "M2002": { recipe: "M2002", type: "beer" }, // Baileys
  "M2003": { recipe: "M2003", type: "beer" }, // Grand Marnier
  "M3001": { recipe: "M3001", type: "beer" }, // Gordons Gin Glass
  "M3002": { recipe: "M3002", type: "beer" }, // Russian Vodka Glass
  "M3003": { recipe: "M3003", type: "beer" }, // Johnnie walker red label  glass
  "M3004": { recipe: "M3004", type: "beer" }, // Johnnie walker black label glass
  "M3005": { recipe: "M3005", type: "beer" }, // Chivas regal glass
  "M3006": { recipe: "M3006", type: "beer" }, // J & B rare glass
  "M3007": { recipe: "M3007", type: "beer" }, // Ballentines Fineses glass
  "M3008": { recipe: "M3008", type: "beer" }, // Creme de cassic glass
  "M3009": { recipe: "M3009", type: "beer" }, // Vodka Hanoi glass
  "M3010": { recipe: "M3010", type: "beer" }, // Lua moi glass
  "M3011": { recipe: "M3011", type: "beer" }, // Smirnoff red label glass
  "M3012": { recipe: "M3012", type: "beer" }, // Jack Daniel Glass
  "M4001": { recipe: "M4001", type: "beer" }, // Bacardi white
  "M5001": { recipe: "M5001", type: "beer" }, // Hennessy V.S.O.P Glass
  "M5002": { recipe: "M5002", type: "beer" }, // Remy martin V.S.O.P
  "M5003": { recipe: "M5003", type: "beer" }, // Hennessy X.O Glass
  "M5004": { recipe: "M5004", type: "beer" }, // Framboise
  "M5005": { recipe: "M5005", type: "beer" }, // Prune
  "M5006": { recipe: "M5006", type: "beer" }, // Poire William Glass
  "M5007": { recipe: "M5007", type: "beer" }, // Mirabelle
  "M5008": { recipe: "M5008", type: "beer" }, // Armagnac
  "M6001": { recipe: "M6001", type: "beer" }, // Coke
  "M6002": { recipe: "M6002", type: "beer" }, // Soda
  "M6003": { recipe: "M6003", type: "beer" }, // Tonic
  "M6004": { recipe: "M6004", type: "beer" }, // Sprite
  "M6005": { recipe: "M6005", type: "beer" }, // Fanta
  "M6006": { recipe: "M6006", type: "beer" }, // Diet Coke
  "M6007": { recipe: "M6007", type: "beer" }, // La Vie 0,5L
  "M6008": { recipe: "M6008", type: "beer" }, // La Vie 1,5 L
  "M6009": { recipe: "M6009", type: "beer" }, // Perrier (Sparkling water 0.33L)
  "M6010": { recipe: "M6010", type: "beer" }, // S.Pellegrino (Sparkling water 0.5L)
  "M6011": { recipe: "M6011", type: "beer" }, // Vitel (Sparking Water 0.5L)
  "M6012": { recipe: "M6012", type: "beer" }, // Aquafina 0.5L
  "M6013": { recipe: "M6013", type: "beer" }, // Vital (Sparking Water 0.5L)
  "M6014": { recipe: "M6014", type: "beer" }, // Evian mineral water bottle 0.5L - France
  "M6015": { recipe: "M6015", type: "beer" }, // La Vie Premium 0,4L
  "M6016": { recipe: "M6016", type: "beer" }, // San Benedetto Still Water 0.75L
  "M6017": { recipe: "M6017", type: "beer" }, // San Benedetto Still Water 0.5L
  "M6018": { recipe: "M6018", type: "beer" }, // San benedetto Still Water 0.65L
  "M6019": { recipe: "M6019", type: "beer" }, // San Benedetto Sparking Water 1L
  "M6020": { recipe: "M6020", type: "beer" }, // Maison Vie, mineral water bottle 0,52L
  "M7001": { recipe: "M7001", type: "alc" }, // 
  "M7002": { recipe: "M7002", type: "alc" }, // 
  "M7003": { recipe: "M7003", type: "alc" }, // 
  "M7004": { recipe: "M7004", type: "alc" }, // Lemon Milk
  "M7005": { recipe: "M7005", type: "alc" }, // 
  "M7006": { recipe: "M7006", type: "alc" }, // 
  "M7007": { recipe: "M7007", type: "alc" }, // 
  "M7008": { recipe: "M7008", type: "alc" }, // 
  "M7009": { recipe: "M7009", type: "alc" }, // 
  "M7010": { recipe: "M7010", type: "alc" }, // 
  "M7011": { recipe: "M7011", type: "alc" }, // Apple juice box
  "M7012": { recipe: "M7012", type: "alc" }, // 
  "M7013": { recipe: "M7013", type: "alc" }, // Whisky sour
  "M7014": { recipe: "M7014", type: "alc" }, // Long Island Iced Tea
  "M7015": { recipe: "M7015", type: "alc" }, // 
  "M7016": { recipe: "M7016", type: "alc" }, // Tequila Sunrise
  "M7017": { recipe: "M7017", type: "alc" }, // Daiquiri
  "M7018": { recipe: "M7018", type: "alc" }, // 
  "M7019": { recipe: "M7019", type: "alc" }, // Tom Collins
  "M7020": { recipe: "M7020", type: "alc" }, // 
  "M7021": { recipe: "M7021", type: "alc" }, // 
  "M7022": { recipe: "M7022", type: "alc" }, // 
  "M7023": { recipe: "M7023", type: "alc" }, // 
  "M7024": { recipe: "M7024", type: "alc" }, // Kombucha Dragon fruit
  "M7025": { recipe: "M7025", type: "alc" }, // 
  "M7026": { recipe: "M7026", type: "alc" }, // Sunset Citrus Cooler
  "M7027": { recipe: "M7027", type: "alc" }, // Watermelon Cooler
  "M7028": { recipe: "M7028", type: "alc" }, // 
  "M7029": { recipe: "M7029", type: "alc" }, // Pineapple Cooler
  "M7030": { recipe: "M7030", type: "alc" }, // 
  "M7031": { recipe: "M7031", type: "alc" }, // 
  "M7032": { recipe: "M7032", type: "alc" }, // 
  "M7033": { recipe: "M7033", type: "alc" }, // 
  "M7034": { recipe: "M7034", type: "alc" }, // 
  "M7035": { recipe: "M7035", type: "alc" }, // 
  "M7036": { recipe: "M7036", type: "alc" }, // 
  "M7037": { recipe: "M7037", type: "alc" }, // 
  "M7038": { recipe: "M7038", type: "alc" }, // 
  "M7039": { recipe: "M7039", type: "alc" }, // 
  "M7040": { recipe: "M7040", type: "alc" }, // 
  "M8001": { recipe: "M8001", type: "alc" }, // 
  "M8002": { recipe: "M8002", type: "alc" }, // 
  "M8003": { recipe: "M8003", type: "alc" }, // Campari & orange juice
  "M8004": { recipe: "M8004", type: "alc" }, // Campari & soda
  "M8005": { recipe: "M8005", type: "alc" }, // Whisky & coke
  "M9001": { recipe: "M9001", type: "alc" }, // 
  "M9002": { recipe: "M9002", type: "alc" }, // 
  "M9003": { recipe: "M9003", type: "alc" }, // 
  "M9004": { recipe: "M9004", type: "alc" }, // 
  "M9005": { recipe: "M9005", type: "alc" }, // 
  "M9006": { recipe: "M9006", type: "alc" }, // 
  "M9007": { recipe: "M9007", type: "alc" }, // Vietnamese tea
  "M9008": { recipe: "M9008", type: "alc" }, // 
  "M9009": { recipe: "M9009", type: "alc" }, // 
  "M9010": { recipe: "M9010", type: "alc" }, // 
  "M9011": { recipe: "M9011", type: "alc" }, // 
  "M9012": { recipe: "M9012", type: "alc" }, // 
  "M9013": { recipe: "M9013", type: "alc" }, // 
  "M9014": { recipe: "M9014", type: "alc" }, // 
  "M9015": { recipe: "M9015", type: "alc" }, // 
  "M9016": { recipe: "M9016", type: "alc" }, // 
  "M9017": { recipe: "M9017", type: "alc" }, // 
  "M9018": { recipe: "M9018", type: "alc" }, // 
  "M9101": { recipe: "M9101", type: "alc" }, // 
  "M9102": { recipe: "M9102", type: "alc" }, // 
  "M9103": { recipe: "M9103", type: "alc" }, // Red wine glass  CHILE - Luis Felipe
  "M9104": { recipe: "M9104", type: "alc" }, // 
  "M9105": { recipe: "M9105", type: "alc" }, // Sparkling wine glass
  "M9106": { recipe: "M9106", type: "alc" }, // 
  "M9107": { recipe: "M9107", type: "alc" }, // 
  "M9108": { recipe: "M9108", type: "alc" }, // Wine of the month glass
  "M9109": { recipe: "M9109", type: "alc" }, // 
  "M9110": { recipe: "M9110", type: "alc" }, // Beaujolais Nouveau wine glass
  "M9111": { recipe: "M9111", type: "alc" }, // Jacques Picard glass
  "M9112": { recipe: "M9112", type: "alc" }, // Rose wine glass - CHILE
  "M9113": { recipe: "M9113", type: "alc" }, // Red Wine Glass Chile - Fronterra
  "M9114": { recipe: "M9114", type: "alc" }, // White Wine Glass Chile - Fronterra
  "M9115": { recipe: "M9115", type: "alc" }, // Cremaschi Furlotti Chardonnay Chile- Glass
  "M9116": { recipe: "M9116", type: "alc" }, // Cremaschi Furlotti Sauvignon Blanc Chile-Glass
  "M9117": { recipe: "M9117", type: "alc" }, // Cremaschi Furlotti Cabernet Sauvignon Chile- Glass
  "M9118": { recipe: "M9118", type: "alc" }, // Château Baratet Sauvignon Blanc France Glass
  "M9119": { recipe: "M9119", type: "alc" }, // Château Baratet Cabernet Sauvignon France Glass
  "M9120": { recipe: "M9120", type: "alc" }, // Pitars Prosecco DOC Extra Dry “Sparkling” - Italy Glass
  "M9121": { recipe: "M9121", type: "alc" }, // 
  "M9201": { recipe: "M9201", type: "beer" }, // Cigarettes Local
  "M9202": { recipe: "M9202", type: "beer" }, // Cigarettes Imported
  "M9203": { recipe: "M9203", type: "beer" }, // Cigar Havana
  "M9204": { recipe: "M9204", type: "alc" }, // 
  "M9401": { recipe: "M9401", type: "beer" }, // Amaretto
  "M9402": { recipe: "M9402", type: "beer" }, // Bailey
  "M9403": { recipe: "M9403", type: "beer" }, // Campari
  "M9404": { recipe: "M9404", type: "beer" }, // Cinzano Dry
  "M9405": { recipe: "M9405", type: "beer" }, // Cointrau
  "M9406": { recipe: "M9406", type: "beer" }, // Grand Marnier
  "M9407": { recipe: "M9407", type: "beer" }, // Kalua
  "M9408": { recipe: "M9408", type: "beer" }, // Malibu
  "M9409": { recipe: "M9409", type: "beer" }, // Martini Bianco
  "M9410": { recipe: "M9410", type: "beer" }, // Martini Dry
  "M9411": { recipe: "M9411", type: "beer" }, // Martini Rosso
  "M9412": { recipe: "M9412", type: "beer" }, // Port Cockburns
  "M9413": { recipe: "M9413", type: "beer" }, // Porto
  "M9414": { recipe: "M9414", type: "beer" }, // Ricard
  "M9501": { recipe: "M9501", type: "beer" }, // Absolut 0.7L
  "M9502": { recipe: "M9502", type: "beer" }, // Absolut 1L
  "M9503": { recipe: "M9503", type: "beer" }, // Beluga
  "M9504": { recipe: "M9504", type: "beer" }, // Black vodka
  "M9505": { recipe: "M9505", type: "beer" }, // Lua moi 300ml
  "M9506": { recipe: "M9506", type: "beer" }, // Lua moi 750ml
  "M9507": { recipe: "M9507", type: "beer" }, // Mens Vodka
  "M9508": { recipe: "M9508", type: "beer" }, // Lua moi 500ml
  "M9509": { recipe: "M9509", type: "beer" }, // Nep moi 700ml
  "M9510": { recipe: "M9510", type: "beer" }, // Putinka
  "M9511": { recipe: "M9511", type: "beer" }, // Russian Vodka Red Label
  "M9512": { recipe: "M9512", type: "beer" }, // Smirnoff Red Label
  "M9513": { recipe: "M9513", type: "beer" }, // Vodka Hanoi 300ml
  "M9514": { recipe: "M9514", type: "beer" }, // Vodka Hanoi 500ml
  "M9515": { recipe: "M9515", type: "beer" }, // Skyy 90 vodka
  "M9516": { recipe: "M9516", type: "beer" }, // Skyy vodka Thuong
  "M9601": { recipe: "M9601", type: "beer" }, // Ballantines
  "M9602": { recipe: "M9602", type: "beer" }, // Ballentines 12
  "M96021": { recipe: "M96021", type: "beer" }, // Ballantines 15
  "M9603": { recipe: "M9603", type: "beer" }, // Ballentines 17
  "M9604": { recipe: "M9604", type: "beer" }, // Ballentines 21
  "M9605": { recipe: "M9605", type: "beer" }, // Ballentines 30
  "M9606": { recipe: "M9606", type: "beer" }, // Ballentines Finese
  "M9607": { recipe: "M9607", type: "beer" }, // Chivas 18 years old
  "M9608": { recipe: "M9608", type: "beer" }, // Chivas Regal 0.37
  "M9609": { recipe: "M9609", type: "beer" }, // Chivas Regal 0.75L (12 years old)
  "M9610": { recipe: "M9610", type: "beer" }, // Chivas regal 21 years old
  "M9611": { recipe: "M9611", type: "beer" }, // Creame de cassic
  "M9612": { recipe: "M9612", type: "beer" }, // Gordon Gin Bottle
  "M9613": { recipe: "M9613", type: "beer" }, // Gin bombay
  "M9614": { recipe: "M9614", type: "beer" }, // Glenfidich
  "M9615": { recipe: "M9615", type: "beer" }, // Glenfidich 15 years old
  "M9616": { recipe: "M9616", type: "beer" }, // Glenfidich 18 years old
  "M9617": { recipe: "M9617", type: "beer" }, // Glenlivert 18
  "M9618": { recipe: "M9618", type: "beer" }, // Grants
  "M9619": { recipe: "M9619", type: "beer" }, // Havana club
  "M9620": { recipe: "M9620", type: "beer" }, // J - B
  "M9621": { recipe: "M9621", type: "beer" }, // Jack Daniel
  "M9622": { recipe: "M9622", type: "beer" }, // Jameson
  "M9623": { recipe: "M9623", type: "beer" }, // Jimbeam
  "M9624": { recipe: "M9624", type: "beer" }, // Johnie Gold label
  "M9625": { recipe: "M9625", type: "beer" }, // Johnnie Green Label
  "M9626": { recipe: "M9626", type: "beer" }, // Johnnie Walker X.R 21 years
  "M9627": { recipe: "M9627", type: "beer" }, // Johnny Walker Black label
  "M9628": { recipe: "M9628", type: "beer" }, // Johnny Walker Blue label
  "M9629": { recipe: "M9629", type: "beer" }, // Johnny Walker red label
  "M9630": { recipe: "M9630", type: "beer" }, // Johnny Walker Double Black 1L
  "M9631": { recipe: "M9631", type: "beer" }, // Macallan 18year
  "M9632": { recipe: "M9632", type: "beer" }, // Marcallan 12 year old
  "M9633": { recipe: "M9633", type: "beer" }, // Platinum label
  "M9636": { recipe: "M9636", type: "beer" }, // Single Barrel Jack Daniel's
  "M96361": { recipe: "M96361", type: "beer" }, // Macallan 12 Double Cask
  "M9637": { recipe: "M9637", type: "beer" }, // Appleton White 40%
  "M9638": { recipe: "M9638", type: "beer" }, // WAKABA  - Sake 15 - bottle 350 ml
  "M9639": { recipe: "M9639", type: "beer" }, // ETSUNO HAJIME - Sake 15% - bottle 300 ml
  "M9640": { recipe: "M9640", type: "beer" }, // KOME HAJIME  - Shochu 25% - bottle 500 ml
  "M96401": { recipe: "M96401", type: "beer" }, // KOME HAJIME  - Shochu 25% - bottle 750 ml
  "M96402": { recipe: "M96402", type: "beer" }, // Tamura Shuzojo Kasen Sake 1.8L
  "M9641": { recipe: "M9641", type: "beer" }, // MUGI HAJIME - Shochu 25% - bottle 500 ml
  "M9642": { recipe: "M9642", type: "beer" }, // GlenAllaChie 11
  "M9643": { recipe: "M9643", type: "beer" }, // FinLaggan 58
  "M9644": { recipe: "M9644", type: "beer" }, // Liqueur Bols Cherry Brandy 70cl
  "M9645": { recipe: "M9645", type: "beer" }, // Liqueur D.O.M Benedictine 70cl
  "M9701": { recipe: "M9701", type: "beer" }, // Bacardi Gold
  "M9702": { recipe: "M9702", type: "beer" }, // Bacardi Light
  "M9703": { recipe: "M9703", type: "beer" }, // Tequila Gold
  "M9704": { recipe: "M9704", type: "beer" }, // Tequila Green label white
  "M9705": { recipe: "M9705", type: "beer" }, // Tequila light
  "M9801": { recipe: "M9801", type: "beer" }, // Creme de cassic (Triple Sec)
  "M9802": { recipe: "M9802", type: "beer" }, // Chabot Napoleon Special Reserve Armagnac
  "M98021": { recipe: "M98021", type: "beer" }, // Armagnac bottle
  "M9803": { recipe: "M9803", type: "beer" }, // Framboise
  "M9804": { recipe: "M9804", type: "beer" }, // Mirabelle (Massenez Wild Raspberry)
  "M9805": { recipe: "M9805", type: "beer" }, // Massenez Poire Williams
  "M9806": { recipe: "M9806", type: "beer" }, // Parisiennes Napoleon X.O 70cl
  "M9807": { recipe: "M9807", type: "beer" }, // Hennessy VSOP 0.37
  "M9808": { recipe: "M9808", type: "beer" }, // Hennessy VSOP 0.7 liter
  "M9809": { recipe: "M9809", type: "beer" }, // Hennessy XO
  "M9810": { recipe: "M9810", type: "beer" }, // Martell VSOP
  "M9811": { recipe: "M9811", type: "beer" }, // Matell XO
  "M9812": { recipe: "M9812", type: "beer" }, // Remy Martin VSOP
  "M9813": { recipe: "M9813", type: "beer" }, // Remy Martin XO
  "M9814": { recipe: "M9814", type: "beer" }, // Prune
  "M9815": { recipe: "M9815", type: "beer" }, // Ch Breuil Fine Calvados 70cl
  "NLC1006": { recipe: "NLC1006", type: "beer" }, // Top Side
  "NLC3001": { recipe: "NLC3001", type: "beer" }, // Foie gras Frozen
  "NLP004": { recipe: "NLP004", type: "beer" }, // Trà olong  Tam Châu 100g
  "NLP2021": { recipe: "NLP2021", type: "beer" }, // Egg
  "NLP3016": { recipe: "NLP3016", type: "beer" }, // Sữa tươi Vinamilk 1L
  "NLP3021": { recipe: "NLP3021", type: "beer" }, // Sữa tươi TH True Milk Nguyên chất 1L
  "NLP30251": { recipe: "NLP30251", type: "beer" }, // Đường nước Hàn Quốc
  "NLP50215": { recipe: "NLP50215", type: "beer" }, // Hạt óc chó
  "NLP50218": { recipe: "NLP50218", type: "beer" }, // Hạt thông
  "NLP6001": { recipe: "NLP6001", type: "beer" }, // Nguyên liệu chế biến ( ko nhập)
  "NLP6002": { recipe: "NLP6002", type: "beer" }, // Nguyên liệu chế biến bếp
  "NLP6003": { recipe: "NLP6003", type: "beer" }, // Nguyên liệu chế biến bar
  "NLP60031": { recipe: "NLP60031", type: "beer" }, // Bưởi Năm roi
  "NLP60032": { recipe: "NLP60032", type: "beer" }, // Chanh
  "NLP60033": { recipe: "NLP60033", type: "beer" }, // Cam
  "NLP60034": { recipe: "NLP60034", type: "beer" }, // Xoài
  "NLP60035": { recipe: "NLP60035", type: "beer" }, // Dưa hấu
  "NLP600351": { recipe: "NLP600351", type: "beer" }, // Chè mạn
  "NLP60036": { recipe: "NLP60036", type: "beer" }, // Bưởi xanh
  "NLP60037": { recipe: "NLP60037", type: "beer" }, // Táo
  "NLP60038": { recipe: "NLP60038", type: "beer" }, // Chanh leo
  "NLP600381": { recipe: "NLP600381", type: "beer" }, // Chanh vàng
  "NLP60039": { recipe: "NLP60039", type: "beer" }, // Dâu tây
  "NLP60040": { recipe: "NLP60040", type: "beer" }, // Bơ sáp
  "NLP60041": { recipe: "NLP60041", type: "beer" }, // Dứa quả
  "NLP60043": { recipe: "NLP60043", type: "beer" }, // Thanh long trắng
  "NLP60045": { recipe: "NLP60045", type: "beer" }, // Dưa vàng
  "NLP60047": { recipe: "NLP60047", type: "beer" }, // Kiwi
  "NLP60049": { recipe: "NLP60049", type: "beer" }, // Dâu tây đông lạnh
  "NLP60052": { recipe: "NLP60052", type: "beer" }, // Cam vàng
  "NLP60053": { recipe: "NLP60053", type: "beer" }, // Chuối chín
  "NLP60056": { recipe: "NLP60056", type: "beer" }, // Quả mâm xôi đen đông lạnh - Blackberry
  "NLP60057": { recipe: "NLP60057", type: "beer" }, // Cà rốt tươi
  "NLP60058": { recipe: "NLP60058", type: "beer" }, // Gừng tươi
  "NLP60059": { recipe: "NLP60059", type: "beer" }, // Bạc hà tươi
  "NLP60061": { recipe: "NLP60061", type: "beer" }, // Dưa chuột tươi
  "NLP9001": { recipe: "NLP9001", type: "beer" }, // Cafe hương chồn 500g
  "NLP9002": { recipe: "NLP9002", type: "beer" }, // Cafe season 500g/ túi
  "NLP90023": { recipe: "NLP90023", type: "beer" }, // Cafe hạt Javador 73 Italya
  "NLP9003": { recipe: "NLP9003", type: "beer" }, // Trà lipton túi lọc (25g/h)
  "NLP9004": { recipe: "NLP9004", type: "beer" }, // Trà Kim Anh (sen, nhài)
  "NLP9005": { recipe: "NLP9005", type: "beer" }, // Đường que
  "NLP9006": { recipe: "NLP9006", type: "beer" }, // Sữa đặc
  "NLP9020": { recipe: "NLP9020", type: "beer" }, // Trà gừng
  "NLP9024": { recipe: "NLP9024", type: "beer" }, // Trà Eargrey
  "NLP9026": { recipe: "NLP9026", type: "beer" }, // Trà hoa cúc
  "NVLC1001": { recipe: "NVLC1001", type: "beer" }, // Beef Tenderloin
  "NVLC1002": { recipe: "NVLC1002", type: "beer" }, // Rib eye (USA)
  "NVLC10021": { recipe: "NVLC10021", type: "beer" }, // Beef steak fuji
  "NVLC1003": { recipe: "NVLC1003", type: "beer" }, // Rib eye (Australia)
  "NVLC1004": { recipe: "NVLC1004", type: "beer" }, // Rib eye (Newzeland)
  "NVLC1005": { recipe: "NVLC1005", type: "beer" }, // Top Side
  "NVLC1010": { recipe: "NVLC1010", type: "beer" }, // T bone
  "NVLC1011": { recipe: "NVLC1011", type: "beer" }, // Top Blade
  "NVLC1012": { recipe: "NVLC1012", type: "beer" }, // Short rib
  "NVLC1013": { recipe: "NVLC1013", type: "beer" }, // Top Sirloin
  "NVLC1014": { recipe: "NVLC1014", type: "beer" }, // Hanging tender
  "NVLC1015": { recipe: "NVLC1015", type: "beer" }, // Local beef
  "NVLC1016": { recipe: "NVLC1016", type: "beer" }, // Chuck roll US
  "NVLC1017": { recipe: "NVLC1017", type: "beer" }, // Chuck tender
  "NVLC2001": { recipe: "NVLC2001", type: "beer" }, // Lamb rack
  "NVLC2002": { recipe: "NVLC2002", type: "beer" }, // Lamb shanks
  "NVLC2003": { recipe: "NVLC2003", type: "beer" }, // Lamb leg boneless
  "NVLC2004": { recipe: "NVLC2004", type: "beer" }, // Lamb tenderloin
  "NVLC3001": { recipe: "NVLC3001", type: "beer" }, // Pork shoulder
  "NVLC3002": { recipe: "NVLC3002", type: "beer" }, // Pork Loin
  "NVLC3003": { recipe: "NVLC3003", type: "beer" }, // Pork belly
  "NVLC4001": { recipe: "NVLC4001", type: "beer" }, // Duck leg
  "NVLC4002": { recipe: "NVLC4002", type: "beer" }, // Duck breast
  "NVLC4010": { recipe: "NVLC4010", type: "beer" }, // Chicken leg
  "NVLC4011": { recipe: "NVLC4011", type: "beer" }, // Chicken breast
  "NVLC5001": { recipe: "NVLC5001", type: "beer" }, // Salmon fillet
  "NVLC5002": { recipe: "NVLC5002", type: "beer" }, // Salmon whole
  "NVLC5005": { recipe: "NVLC5005", type: "beer" }, // Sea bass fillet
  "NVLC5006": { recipe: "NVLC5006", type: "beer" }, // Sea bass whole
  "NVLC5010": { recipe: "NVLC5010", type: "beer" }, // Tilapia fillet
  "NVLC5015": { recipe: "NVLC5015", type: "beer" }, // Ca Tra fillet
  "NVLC5016": { recipe: "NVLC5016", type: "beer" }, // Ca Tra whole
  "NVLC5017": { recipe: "NVLC5017", type: "beer" }, // Basa fillet
  "NVLC5020": { recipe: "NVLC5020", type: "beer" }, // Cod fish
  "NVLC5021": { recipe: "NVLC5021", type: "beer" }, // Lang Fish
  "NVLC5025": { recipe: "NVLC5025", type: "beer" }, // Gouper
  "NVLC6001": { recipe: "NVLC6001", type: "beer" }, // Lobster
  "NVLC6002": { recipe: "NVLC6002", type: "beer" }, // Scallope
  "NVLC60021": { recipe: "NVLC60021", type: "beer" }, // Scallope (10)
  "NVLC6003": { recipe: "NVLC6003", type: "beer" }, // Fresh Musells
  "NVLC6004": { recipe: "NVLC6004", type: "beer" }, // Frog leg
  "NVLC6005": { recipe: "NVLC6005", type: "beer" }, // Prawn 31-40 (425g/ túi)
  "NVLC6006": { recipe: "NVLC6006", type: "beer" }, // Mussell meat
  "NVLC6007": { recipe: "NVLC6007", type: "beer" }, // Escargot in tin 800gr
  "NVLC6010": { recipe: "NVLC6010", type: "beer" }, // Rabit
  "NVLC6015": { recipe: "NVLC6015", type: "beer" }, // Turkey Whole
  "NVLC7001": { recipe: "NVLC7001", type: "beer" }, // Veal tenderloin
  "NVLC7002": { recipe: "NVLC7002", type: "beer" }, // Veal Sweet Breast
  "PKG-001": { recipe: "PKG-001", type: "beer" }, // Cốc giấy mang về 270ml
  "PKG-002": { recipe: "PKG-002", type: "beer" }, // Nắp cốc mang về
  "PKG-003": { recipe: "PKG-003", type: "beer" }, // Ống hút giấy
  "PKG-004": { recipe: "PKG-004", type: "beer" }, // Túi giấy mang về
  "R1001": { recipe: "R1001", type: "alc" }, // Confit gizzards and duck breast salad
  "R1002": { recipe: "R1002", type: "alc" }, // Beef Carpaccio with basil
  "R1003": { recipe: "R1003", type: "alc" }, // Warm goat cheese salad and Parma ham
  "R1004": { recipe: "R1004", type: "alc" }, // Blinis with smoked salmon
  "R1005": { recipe: "R1005", type: "alc" }, // Goose liver terrine
  "R1006": { recipe: "R1006", type: "alc" }, // Pan fried foie gras escalope
  "R1007": { recipe: "R1007", type: "alc" }, // Seasonal vegetable soup
  "R1008": { recipe: "R-006", type: "alc" }, // 
  "R1009": { recipe: "R1009", type: "alc" }, // Mussels soup
  "R1010": { recipe: "R1010", type: "alc" }, // Egg blown wild mushroom cream
  "R1011": { recipe: "R1011", type: "alc" }, // Burgundy snails (six pcs)
  "R1012": { recipe: "R1012", type: "alc" }, // Breaded frog's legs
  "R1013": { recipe: "R1013", type: "alc" }, // Mixed garden salad
  "R1014": { recipe: "R1014", type: "alc" }, // Cold cut platter 2 Pers
  "R1015": { recipe: "R1015", type: "alc" }, // Cold cut platter 3 Pers
  "R1016": { recipe: "R1016", type: "alc" }, // Cold cut platter 4 Pers
  "R1017": { recipe: "R1017", type: "alc" }, // Cucumber and Tomaoes 2 Pers
  "R1018": { recipe: "R1018", type: "alc" }, // Cucumber and Tomaoes 3 Pers
  "R1019": { recipe: "R1019", type: "alc" }, // Cucumber and Tomaoes 4 Pers
  "R1020": { recipe: "R1020", type: "alc" }, // French fries
  "R1021": { recipe: "R1021", type: "alc" }, // Olive Platter
  "R1022": { recipe: "R1022", type: "alc" }, // Mixed Olive Platter
  "R1023": { recipe: "R1023", type: "alc" }, // Soup bouillabaisse rouille garlic baguette
  "R1024": { recipe: "R-008", type: "alc" }, // 
  "R1025": { recipe: "R-009", type: "alc" }, // 
  "R1026": { recipe: "R1026", type: "alc" }, // Frogs legs parsley cream and garlic puree
  "R1027": { recipe: "R1027", type: "alc" }, // Pan fried king prawn lobster sauce coriander
  "R1028": { recipe: "R1028", type: "alc" }, // Pan fried duck foie gras with red fruits sauce 80gm
  "R1029": { recipe: "R1029", type: "alc" }, // Assorted Ham, Salami with Cheese and Pate
  "R1030": { recipe: "R1030", type: "alc" }, // Salmon Sashimi
  "R1031": { recipe: "R1031", type: "alc" }, // Terrine Platter
  "R1032": { recipe: "R1032", type: "alc" }, // Trâu Gác Bếp (110 gram)
  "R1033": { recipe: "R1033", type: "alc" }, // Bò một nắng (110 gram)
  "R1101": { recipe: "R1101", type: "alc" }, // Chef's salad
  "R1102": { recipe: "R1102", type: "alc" }, // Nicoise salad with anchovies
  "R1103": { recipe: "R1103", type: "alc" }, // Garden vegetables with nuts, orange balsamic dressing
  "R1104": { recipe: "R1104", type: "alc" }, // Chicken caesar salad
  "R1105": { recipe: "R1105", type: "alc" }, // Tuna cappaccio with quail egg and sesame oil
  "R1106": { recipe: "R1106", type: "alc" }, // Smoke salmon cucumber black pearl cream
  "R1107": { recipe: "R1107", type: "alc" }, // Assorted ham, salami and terrine mustard Dijon
  "R1108": { recipe: "R1108", type: "alc" }, // Foie gras salad with quail egg Serano ham
  "R1109": { recipe: "R1109", type: "alc" }, // Lobster caesar salad
  "R1110": { recipe: "R1110", type: "alc" }, // Beef Tartare
  "R1111": { recipe: "R1111", type: "alc" }, // Garden Vegetables
  "R1112": { recipe: "R1112", type: "alc" }, // Baked Beet Salad
  "R1113": { recipe: "R1113", type: "alc" }, // Cured Salmon Carpaccio
  "R1114": { recipe: "R1114", type: "alc" }, // Beef  Carpaccio
  "R1115": { recipe: "R1115", type: "alc" }, // Seared Ahi Tuna
  "R1116": { recipe: "R1116", type: "alc" }, // Slice Scallops
  "R1117": { recipe: "R1117", type: "alc" }, // Tomato Seafood Soup
  "R1118": { recipe: "R1118", type: "alc" }, // Dalat Artichoke Soup
  "R1119": { recipe: "R1119", type: "alc" }, // Pan-Fried Duck Foie Gras 40Gram
  "R1120": { recipe: "R1120", type: "alc" }, // Creamy pumpkin soup
  "R1121": { recipe: "R-001", type: "alc" }, // 
  "R1122": { recipe: "R-010", type: "alc" }, // 
  "R1123": { recipe: "R1123", type: "alc" }, // Lobster salad with mango, avocado, and passion fruit dressing
  "R2001": { recipe: "R2001", type: "alc" }, // Roasted chicken breast
  "R2002": { recipe: "R2002", type: "alc" }, // Roasted duck breast with green olives sauce
  "R2003": { recipe: "R2003", type: "alc" }, // Fried duck-leg, calamansi sauce
  "R2004": { recipe: "R2004", type: "alc" }, // Grilled beef rib eye bordelaise sauce
  "R2005": { recipe: "R2005", type: "alc" }, // Roasted Australian beef tenderloin
  "R2006": { recipe: "R2006", type: "alc" }, // American Hanging tender
  "R2007": { recipe: "R2007", type: "alc" }, // Grilled T-bone steak besarnaise sauce
  "R2008": { recipe: "R2008", type: "alc" }, // Lamb shank confit with sweet spices
  "R2009": { recipe: "R2009", type: "alc" }, // Grilled cutlet with Provence's herbs
  "R2010": { recipe: "R2010", type: "alc" }, // Veal tenderloin in apple cider
  "R2011": { recipe: "R2011", type: "alc" }, // Sauteed pork tenderloin with gouda cheese sauce
  "R2012": { recipe: "R2012", type: "alc" }, // Local beef fillet with Provencal herbs
  "R2013": { recipe: "R2013", type: "alc" }, // Chopped beef fillet served with salad and frites
  "R2014": { recipe: "R2014", type: "alc" }, // Food of the month
  "R2015": { recipe: "R2015", type: "alc" }, // American Ribeye Steak 200gram
  "R2016": { recipe: "R2016", type: "alc" }, // American Ribeye Steak 250gram
  "R2017": { recipe: "R2017", type: "alc" }, // American Ribeye Steak 300gram
  "R2018": { recipe: "R2018", type: "alc" }, // American KOBE Ribeye Steak 250 gram
  "R2019": { recipe: "R2019", type: "alc" }, // American beef steak
  "R2020": { recipe: "R2020", type: "alc" }, // Grilled top blade steak
  "R2021": { recipe: "R2021", type: "alc" }, // Buffalo fillet with spicy sauce
  "R2101": { recipe: "R2101", type: "alc" }, // SIGNATURE Vietnamese buffalo fillet 150gr
  "R2102": { recipe: "R2102", type: "alc" }, // SIGNATURE Pork shank stew with Hanoi beer
  "R21021": { recipe: "R21021", type: "alc" }, // Pigeon wellington foie gras red beetroot truffle jus
  "R2103": { recipe: "R2103", type: "alc" }, // Grilled US beef rib eyes 150 gram
  "R21031": { recipe: "R21031", type: "alc" }, // Grilled US beef rib eyes 200 gram
  "R21032": { recipe: "R21032", type: "alc" }, // Grilled US beef rib eyes 300 gram
  "R21033": { recipe: "R21033", type: "alc" }, // Grilled US beef rib eyes 400 gram
  "R2104": { recipe: "R2104", type: "alc" }, // Grilled US beef striploin 150 gram
  "R21041": { recipe: "R21041", type: "alc" }, // Grilled US beef striploin 200 gram
  "R21042": { recipe: "R21042", type: "alc" }, // Grilled US beef striploin 300 gram
  "R21043": { recipe: "R21043", type: "alc" }, // Grilled US beef striploin 400 gram
  "R2105": { recipe: "R2105", type: "alc" }, // Grilled US T-bone signature sauce 350gm
  "R2106": { recipe: "R2106", type: "alc" }, // Grilled US beef tenderloin 150 gram
  "R21061": { recipe: "R21061", type: "alc" }, // Grilled US beef tenderloin 200 gram
  "R21062": { recipe: "R21062", type: "alc" }, // Grilled US beef tenderloin 300 gram
  "R2107": { recipe: "R2107", type: "alc" }, // Australian Wagyu rib eyes steak MBS 9+ 150gm
  "R2108": { recipe: "R2108", type: "alc" }, // Grilled US topblade 180 gram
  "R21081": { recipe: "R21081", type: "alc" }, // Grilled US topblade 300 gram
  "R21082": { recipe: "R21082", type: "alc" }, // Grilled US topblade 400 gram
  "R2109": { recipe: "R2109", type: "alc" }, // US Short rib boneless Prime Black Angus
  "R2110": { recipe: "R2110", type: "alc" }, // Vietnamese beef fillet signature sauce 150gm
  "R2111": { recipe: "R2111", type: "alc" }, // Slow cooked US beef short ribs
  "R2112": { recipe: "R2112", type: "alc" }, // Burgundy beef stew mashed potatoes
  "R2113": { recipe: "R2113", type: "alc" }, // Veal fillet with wild mushroom cream
  "R2115": { recipe: "R2115", type: "alc" }, // Roasted lamb rack with rosemary 3 chops
  "R2116": { recipe: "R2116", type: "alc" }, // Braised lamb shank in Cassoulet bean
  "R2117": { recipe: "R2117", type: "alc" }, // Roast duck fillet orange sauce and seasonal creation
  "R2118": { recipe: "R2118", type: "alc" }, // Fired duck confit thyme sauce
  "R2119": { recipe: "R2119", type: "alc" }, // Roasted chicken fillet tarragon juice
  "R2120": { recipe: "R2120", type: "alc" }, // Boneless chicken thighs stuffed with vegetables
  "R2121": { recipe: "R2121", type: "alc" }, // Roasted pork fillet mignon cheese sauce
  "R2122": { recipe: "R2122", type: "alc" }, // Roasted Lamb Leg (Kg)
  "R2123": { recipe: "R2123", type: "alc" }, // Roasted Beef Op Rib (kg)
  "R2124": { recipe: "R2124", type: "alc" }, // SIGNATURE Roasted pigeon and foie gras mashed peas
  "R2125": { recipe: "R2125", type: "alc" }, // Black Angus US Beef Ribeye 150 gram
  "R2126": { recipe: "R2126", type: "alc" }, // Black Angus US Beef Ribeye 200 gram
  "R2127": { recipe: "R2127", type: "alc" }, // Black Angus US Beef Ribeye 300 gram
  "R2128": { recipe: "R2128", type: "alc" }, // Black Angus US Beef Ribeye 400 gram
  "R2129": { recipe: "R2129", type: "alc" }, // Char Grilled AUS Beef Tenderloin 150 gram
  "R2130": { recipe: "R2130", type: "alc" }, // Char Grilled AUS Beef Tenderloin 200 gram
  "R2131": { recipe: "R2131", type: "alc" }, // Char Grilled AUS Beef Tenderloin 300 gram
  "R2132": { recipe: "R2132", type: "alc" }, // Prime US Chuck Eye Roll 170 gram
  "R2133": { recipe: "R2133", type: "alc" }, // Prime US Chuck Eye Roll 300 gram
  "R2134": { recipe: "R2134", type: "alc" }, // Australian Wagyu Ribeye MBS 6+ 150 gram
  "R2135": { recipe: "R2135", type: "alc" }, // AUS Lamb Rack with Asian herb 3 chops
  "R2136": { recipe: "R2136", type: "alc" }, // Pan - Fried French Duck Breast
  "R2137": { recipe: "R2137", type: "alc" }, // Roasted Iberico Pork Fillet Mignon
  "R2138": { recipe: "R2138", type: "alc" }, // Braised Beef Cheek with Dalat Red Wine
  "R2139": { recipe: "R2139", type: "alc" }, // Chicken rolls with Sapa mushroom
  "R2140": { recipe: "R2140", type: "alc" }, // Braised Lamb Shank nestled in a bed of couscous
  "R2141": { recipe: "R-012", type: "alc" }, // 
  "R2142": { recipe: "R-019", type: "alc" }, // 
  "R2143": { recipe: "R2143", type: "alc" }, // AUS beef tenderloin with green peppercorn sauce and mashed potatoes
  "R2144": { recipe: "R-028", type: "alc" }, // 
  "R2145": { recipe: "R-012", type: "alc" }, // 
  "R2146": { recipe: "R2146", type: "alc" }, // Burgundy-style beef stew with red wine, organic noodles and mushrooms
  "R2147": { recipe: "R2147", type: "alc" }, // Chicken à la Provençale with mashed potatoes
  "R2148": { recipe: "R-017", type: "alc" }, // 
  "R2149": { recipe: "R-018", type: "alc" }, // 
  "R2150": { recipe: "R-018", type: "alc" }, // 
  "R2151": { recipe: "R2151", type: "alc" }, // Roast Iberico pork tenderloin with apple Calvados sauce and sweet potatoes
  "R3001": { recipe: "R3001", type: "alc" }, // Pan seared Scallops wild mushrooms "Royale"
  "R3002": { recipe: "R3002", type: "alc" }, // Prawns flambéed with Pastis
  "R3003": { recipe: "R3003", type: "alc" }, // Tilapia fillet breaded with sesame
  "R3004": { recipe: "R3004", type: "alc" }, // Roasted Sea bass crusted chorizo
  "R3005": { recipe: "R3005", type: "alc" }, // Pan seared Norwegian salmon
  "R3006": { recipe: "R3006", type: "alc" }, // Black Cod Fish
  "R3101": { recipe: "R3101", type: "alc" }, // Basa fish fillet with dill butter sauce
  "R3102": { recipe: "R3102", type: "alc" }, // Sea bass Bouilabaisse style
  "R3103": { recipe: "R3103", type: "alc" }, // Pan-fried salmon fillet dry fig sauce
  "R3104": { recipe: "R3104", type: "alc" }, // Tuna Rossini with foie foie gras porto wine sauce
  "R3105": { recipe: "R3105", type: "alc" }, // Steamed cod fish fillet bisque sauce
  "R3106": { recipe: "R3106", type: "alc" }, // Pan seared Scallops wild mushrooms Royale
  "R3107": { recipe: "R3107", type: "alc" }, // Pan-fried langouste rock lobster
  "R3108": { recipe: "R3108", type: "alc" }, // Sole fillet with butter sauce
  "R3109": { recipe: "R3109", type: "alc" }, // Cold seafood platter for 1 per
  "R3110": { recipe: "R3110", type: "alc" }, // Cold seafood platter for 2 pers
  "R3111": { recipe: "R3111", type: "alc" }, // Cold seafood platter for 3 pers
  "R3112": { recipe: "R3112", type: "alc" }, // Cold seafood platter for 4 pers
  "R3113": { recipe: "R3113", type: "alc" }, // Cold seafood platter for 5 pers
  "R3114": { recipe: "R3114", type: "alc" }, // Cold seafood platter for 6 pers
  "R3115": { recipe: "R3115", type: "alc" }, // Fresh Oyster Size L (Pcs)
  "R3116": { recipe: "R3116", type: "alc" }, // Ốc Bulot Vùng Burgundy Pháp (Pcs)
  "R3117": { recipe: "R3117", type: "alc" }, // Tôm Bắc Cực (Cold Water Shrimp) Kg
  "R3118": { recipe: "R3118", type: "alc" }, // Vẹm Xanh Newzealand (Newzealand Musseles) Kg
  "R3119": { recipe: "R3119", type: "alc" }, // Slow cook Octopus
  "R3120": { recipe: "R3120", type: "alc" }, // Pan-Fried Norwegian Salmon,Hanoi basil sauce
  "R3121": { recipe: "R3121", type: "alc" }, // Baked Oven Sea bass, creamy curry sauce
  "R3122": { recipe: "R3122", type: "alc" }, // Pan- Fried Balck Cod, Tamarind sauce
  "R3123": { recipe: "R3123", type: "alc" }, // Pan- Fried Japanese Scallops
  "R3124": { recipe: "R3124", type: "alc" }, // Tiger Prawns in a tantalizing chili tamarind sauce
  "R3125": { recipe: "R-004", type: "alc" }, // 
  "R3126": { recipe: "R-002", type: "alc" }, // 
  "R3127": { recipe: "R-011", type: "alc" }, // 
  "R4001": { recipe: "R4001", type: "alc" }, // Pasta with sauce Bolognaise
  "R4002": { recipe: "R4002", type: "alc" }, // Pasta with sauce Carbonara
  "R4003": { recipe: "R4003", type: "alc" }, // Pasta with Grogonzola chesse sauce
  "R4004": { recipe: "R4004", type: "alc" }, // Pasta with smoked salmon
  "R4005": { recipe: "R4005", type: "alc" }, // Pasta with tomatoes and shrimps
  "R4006": { recipe: "R4006", type: "alc" }, // Pasta with vegetable (vegetarian)
  "R4007": { recipe: "R4007", type: "alc" }, // Couscous stuffed peppers (vegetarian)
  "R4008": { recipe: "R4008", type: "alc" }, // Risotto with mushrooms and onions (vegetarian)
  "R5001": { recipe: "R5001", type: "alc" }, // Haft-cooked dark chocolate cake
  "R5002": { recipe: "R5002", type: "alc" }, // "Vacherin" ice cream mint and chocolate
  "R5003": { recipe: "R5003", type: "alc" }, // Crepes Suzette flambeed Grand Marnier
  "R5004": { recipe: "R5004", type: "alc" }, // Profiteroles with vanilla ice cream and hot chocolate sauce
  "R5005": { recipe: "R5005", type: "alc" }, // Fine apple tart, cinnamon ice cream
  "R5006": { recipe: "R5006", type: "alc" }, // Cheese platter with walnut bread
  "R5007": { recipe: "R5007", type: "alc" }, // Fresh Fruit Platter
  "R5008": { recipe: "R5008", type: "alc" }, // Ice cream (1 scoop)
  "R5009": { recipe: "R5009", type: "alc" }, // Ice cream (2 scoops)
  "R5010": { recipe: "R5010", type: "alc" }, // Chocolate balls
  "R5011": { recipe: "R5011", type: "alc" }, // Ice cream (1 scoop)
  "R5012": { recipe: "R5012", type: "alc" }, // Ice cream (2 scoops)
  "R5101": { recipe: "R5101", type: "alc" }, // Chocolate lava cake coffee whipped cream
  "R5102": { recipe: "R5102", type: "alc" }, // Apple flower fine tart cinnamon ice cream
  "R5103": { recipe: "R-024", type: "alc" }, // 
  "R5104": { recipe: "R5104", type: "alc" }, // Ice Drop 3 scoops of ice cream
  "R5105": { recipe: "R5105", type: "alc" }, // Chocolate sphere salted butter caramel sauce
  "R5106": { recipe: "R5106", type: "alc" }, // Mango ravioli with coconut pudding
  "R5107": { recipe: "R5107", type: "alc" }, // Seasonal fresh fruit platter
  "R5108": { recipe: "R5108", type: "alc" }, // Birthday cake
  "R5109": { recipe: "R5109", type: "alc" }, // Banana Flambee Chuối đốt rượu
  "R5110": { recipe: "R5110", type: "alc" }, // Bưởi da xanh tráng miệng
  "R5111": { recipe: "R5111", type: "alc" }, // Tiramisu Coffee Flavoured
  "R5112": { recipe: "R5112", type: "alc" }, // Chocolate and Orange Cheese Cake
  "R5113": { recipe: "R-023", type: "alc" }, // 
  "R5114": { recipe: "R-022", type: "alc" }, // 
  "R5115": { recipe: "R5115", type: "alc" }, // Caramelized apple tart and vanilla ice cream
  "R5116": { recipe: "R5116", type: "alc" }, // Cream puffs with vani la ice cream and chocolate sauce
  "R5117": { recipe: "R-021", type: "alc" }, // 
  "R5118": { recipe: "R-025", type: "alc" }, // 
  "R6001": { recipe: "R6001", type: "alc" }, // Set Lunch1
  "R6002": { recipe: "R6002", type: "alc" }, // Set Dinner1
  "R6003": { recipe: "R6003", type: "alc" }, // Set Menu 320760
  "R6004": { recipe: "R6004", type: "alc" }, // Set Menu 320760
  "R6005": { recipe: "R6005", type: "alc" }, // Set Menu 12B1
  "R6006": { recipe: "R6006", type: "alc" }, // Set Menu 12B2
  "R6007": { recipe: "R6007", type: "alc" }, // Set Menu 15A1
  "R6008": { recipe: "R6008", type: "alc" }, // Set Menu 15A2
  "R6009": { recipe: "R6009", type: "alc" }, // Set Menu 15B1
  "R6010": { recipe: "R6010", type: "alc" }, // Set Menu 15B2
  "R6011": { recipe: "R6011", type: "alc" }, // Set Menu 18A1
  "R6012": { recipe: "R6012", type: "alc" }, // Set Menu 18A2
  "R6013": { recipe: "R6013", type: "alc" }, // Set Menu 18B1
  "R6014": { recipe: "R6014", type: "alc" }, // Set Menu 18B2
  "R6015": { recipe: "R6015", type: "alc" }, // Set Menu 20A1
  "R6016": { recipe: "R6016", type: "alc" }, // Set Menu 20A2
  "R6017": { recipe: "R6017", type: "alc" }, // Set Menu 20B1
  "R6018": { recipe: "R6018", type: "alc" }, // Set Menu 20B2
  "R6019": { recipe: "R6019", type: "alc" }, // Set Menu 25A1
  "R6020": { recipe: "R6020", type: "alc" }, // Set Menu 25A2
  "R6021": { recipe: "R6021", type: "alc" }, // Set Menu 30A1
  "R6022": { recipe: "R6022", type: "alc" }, // Set Menu 30A2
  "R6023": { recipe: "R6023", type: "alc" }, // Set Menu 35A1
  "R6024": { recipe: "R6024", type: "alc" }, // Set menu 35A2
  "R6025": { recipe: "R6025", type: "alc" }, // Set Menu 40
  "R6027": { recipe: "R6027", type: "alc" }, // Set Menu 45
  "R6028": { recipe: "R6028", type: "alc" }, // Set Menu 11A
  "R6029": { recipe: "R6029", type: "alc" }, // Set Menu 11B
  "R6030": { recipe: "R6030", type: "alc" }, // Set Menu 13A
  "R6031": { recipe: "R6031", type: "alc" }, // Set Menu 13B
  "R6032": { recipe: "R6032", type: "alc" }, // Set Menu 13C
  "R6033": { recipe: "R6033", type: "alc" }, // Set Menu 10 A
  "R6034": { recipe: "R6034", type: "alc" }, // Set Menu 10B
  "R6035": { recipe: "R6035", type: "alc" }, // Set Menu 10C
  "R6036": { recipe: "R6036", type: "alc" }, // Set menu 11C
  "R6037": { recipe: "R6037", type: "alc" }, // Set menu 50
  "R6038": { recipe: "R6038", type: "alc" }, // Set menu 55
  "R6039": { recipe: "R6039", type: "alc" }, // Set menu 60
  "R6040": { recipe: "R6040", type: "alc" }, // Set Lunch2
  "R6041": { recipe: "R6041", type: "alc" }, // Set Lunch3
  "R6042": { recipe: "R6042", type: "alc" }, // Set Lunch4
  "R6043": { recipe: "R6043", type: "alc" }, // Set Lunch5
  "R6044": { recipe: "R6044", type: "alc" }, // Set Lunch6
  "R6045": { recipe: "R6045", type: "alc" }, // Set Lunch7
  "R6046": { recipe: "R6046", type: "alc" }, // Set Lunch9
  "R6047": { recipe: "R6047", type: "alc" }, // Set lunch10
  "R6050": { recipe: "R6050", type: "alc" }, // Set Dinner2
  "R6051": { recipe: "R6051", type: "alc" }, // Set Dinner3
  "R6052": { recipe: "R6052", type: "alc" }, // Set Dinner4
  "R6053": { recipe: "R6053", type: "alc" }, // Set Dinner5
  "R6054": { recipe: "R6054", type: "alc" }, // Set Dinner6
  "R6055": { recipe: "R6055", type: "alc" }, // Set Dinner7
  "R6056": { recipe: "R6056", type: "alc" }, // Set Dinner8
  "R6057": { recipe: "R6057", type: "alc" }, // Set Dinner9
  "R6058": { recipe: "R6058", type: "alc" }, // Set dinner10
  "R6059": { recipe: "R6059", type: "alc" }, // Set dinner11
  "R6060": { recipe: "R6060", type: "alc" }, // Set menu 12C1
  "R6061": { recipe: "R6061", type: "alc" }, // Set menu 15C1
  "R6062": { recipe: "R6062", type: "alc" }, // Set menu 20C1
  "R6063": { recipe: "R6063", type: "alc" }, // Set menu 30B1
  "R6064": { recipe: "R6064", type: "alc" }, // Set menu 30B2
  "R6065": { recipe: "R6065", type: "alc" }, // Set menu 14A1
  "R6066": { recipe: "R6066", type: "alc" }, // Set menu 14A2
  "R6067": { recipe: "R6067", type: "alc" }, // Set menu 13D
  "R6068": { recipe: "R6068", type: "alc" }, // Set menu 35A3
  "R6069": { recipe: "R6069", type: "alc" }, // Set lunch8
  "R6070": { recipe: "R6070", type: "alc" }, // Set menu 35A4
  "R6071": { recipe: "R6071", type: "alc" }, // Set menu 90
  "R6072": { recipe: "R6072", type: "alc" }, // Set Dinner12
  "R6073": { recipe: "R6073", type: "alc" }, // Set Dinner13
  "R6074": { recipe: "R6074", type: "alc" }, // Set menu 25A3
  "R6075": { recipe: "R6075", type: "alc" }, // Set menu 70
  "R6076": { recipe: "R6076", type: "alc" }, // Set menu 15C2
  "R6077": { recipe: "R6077", type: "alc" }, // Set menu 23A1
  "R6078": { recipe: "R6078", type: "alc" }, // Set menu 23A2
  "R6079": { recipe: "R6079", type: "alc" }, // Set menu 15D1
  "R6080": { recipe: "R6080", type: "alc" }, // Set menu 35A5
  "R6081": { recipe: "R6081", type: "alc" }, // Roasted Pork with Steam rice
  "R60811": { recipe: "R60811", type: "alc" }, // Pork rib with Steam rice
  "R6082": { recipe: "R6082", type: "alc" }, // Pork stew with Steam rice
  "R6083": { recipe: "R6083", type: "alc" }, // Stuffed chicken leg with Steam rice
  "R60831": { recipe: "R60831", type: "alc" }, // Hai Nam Chicken Rice
  "R6084": { recipe: "R6084", type: "alc" }, // Set dinner14
  "R6085": { recipe: "R6085", type: "alc" }, // Set menu 16.89A1
  "R6086": { recipe: "R6086", type: "alc" }, // Set menu 16.89A2
  "R6087": { recipe: "R6087", type: "alc" }, // Sandwich Set Menu
  "R6091": { recipe: "R6091", type: "alc" }, // Set menu (700)
  "R6092": { recipe: "R6092", type: "alc" }, // Set menu Christmas
  "R60921": { recipe: "R60921", type: "alc" }, // Set Menu New Year for 2 pers
  "R609212": { recipe: "R609212", type: "alc" }, // Set Menu New Year for 2 pers with wine
  "R609213": { recipe: "R609213", type: "alc" }, // Valentine set menu for 2 pers
  "R609214": { recipe: "R609214", type: "alc" }, // New Year Set Menu
  "R6093": { recipe: "R6093", type: "alc" }, // Set dinner15
  "R6094": { recipe: "R6094", type: "alc" }, // Deluxe set menu1
  "R6095": { recipe: "R6095", type: "alc" }, // Deluxe set menu2
  "R6096": { recipe: "R6096", type: "alc" }, // Deluxe set menu3
  "R6097": { recipe: "R6097", type: "alc" }, // Deluxe set menu4
  "R6098": { recipe: "R6098", type: "alc" }, // Deluxe set menu5
  "R6099": { recipe: "R6099", type: "alc" }, // Deluxe set menu6
  "R6100": { recipe: "R6100", type: "alc" }, // Deluxe set menu7
  "R6101": { recipe: "R6101", type: "alc" }, // Deluxe set menu8
  "R6102": { recipe: "R6102", type: "alc" }, // Deluxe set menu9
  "R6103": { recipe: "R6103", type: "alc" }, // Deluxe set menu10
  "R6104": { recipe: "R6104", type: "alc" }, // Deluxe set menu11
  "R6105": { recipe: "R6105", type: "alc" }, // Deluxe set menu12
  "R6106": { recipe: "R6106", type: "alc" }, // Deluxe set menu13
  "R6107": { recipe: "R6107", type: "alc" }, // Deluxe set menu14
  "R6108": { recipe: "R6108", type: "alc" }, // Deluxe set menu15
  "R6109": { recipe: "R6109", type: "alc" }, // Deluxe set menu16
  "R6110": { recipe: "R6110", type: "alc" }, // Deluxe set menu17
  "R6111": { recipe: "R6111", type: "alc" }, // Deluxe set menu18
  "R6112": { recipe: "R6112", type: "alc" }, // Deluxe set menu19
  "R6113": { recipe: "R6113", type: "alc" }, // Deluxe set menu20
  "R6114": { recipe: "R6114", type: "alc" }, // Deluxe set menu21
  "R6115": { recipe: "R6115", type: "alc" }, // Deluxe set menu22
  "R6116": { recipe: "R6116", type: "alc" }, // Deluxe set menu23
  "R6117": { recipe: "R6117", type: "alc" }, // Deluxe set menu24
  "R6118": { recipe: "R6118", type: "alc" }, // Deluxe set menu25
  "R6119": { recipe: "R6119", type: "alc" }, // Deluxe set menu26
  "R6120": { recipe: "R6120", type: "alc" }, // Deluxe set menu27
  "R6121": { recipe: "R6121", type: "alc" }, // Deluxe set menu28
  "R6122": { recipe: "R6122", type: "alc" }, // Set menu 23B1
  "R6123": { recipe: "R6123", type: "alc" }, // Set menu 23B2
  "R6124": { recipe: "R6124", type: "alc" }, // Set menu 23B3
  "R6125": { recipe: "R6125", type: "alc" }, // Set menu 23B4
  "R6126": { recipe: "R6126", type: "alc" }, // Set Menu 24A1
  "R6127": { recipe: "R6127", type: "alc" }, // Set Menu 24A2
  "R6128": { recipe: "R6128", type: "alc" }, // Deluxe set menu29
  "R6129": { recipe: "R6129", type: "alc" }, // Deluxe set menu30
  "R6130": { recipe: "R6130", type: "alc" }, // Deluxe set menu31
  "R6131": { recipe: "R6131", type: "alc" }, // Set Menu 350A
  "R6132": { recipe: "R6132", type: "alc" }, // Set Menu 350B
  "R6133": { recipe: "R6133", type: "alc" }, // Set menu 350C
  "R6134": { recipe: "R6134", type: "alc" }, // Set Menu 430A
  "R6135": { recipe: "R6135", type: "alc" }, // Set Menu 430B
  "R6136": { recipe: "R6136", type: "alc" }, // Set Menu 550A
  "R6137": { recipe: "R6137", type: "alc" }, // Set Menu 550B
  "R6138": { recipe: "R6138", type: "alc" }, // Set Menu 710A
  "R6139": { recipe: "R6139", type: "alc" }, // Set Menu 710B
  "R6140": { recipe: "R6140", type: "alc" }, // Set Menu 940
  "R61401": { recipe: "R61401", type: "alc" }, // Set Menu 950
  "R614011": { recipe: "R614011", type: "alc" }, // Set Menu 1050
  "R6141": { recipe: "R6141", type: "alc" }, // Set Menu 1190
  "R61411": { recipe: "R61411", type: "alc" }, // Set Menu 1200
  "R6142": { recipe: "R6142", type: "alc" }, // Set Menu 1500
  "R6143": { recipe: "R6143", type: "alc" }, // Set Menu 1800A
  "R6144": { recipe: "R6144", type: "alc" }, // Set Menu 2200
  "R6145": { recipe: "R6145", type: "alc" }, // Set Menu 2700
  "R6146": { recipe: "R6146", type: "alc" }, // Set Menu 3300
  "R6147": { recipe: "R6147", type: "alc" }, // Set Menu 720A
  "R6148": { recipe: "R6148", type: "alc" }, // Set Menu 720B
  "R6149": { recipe: "R6149", type: "alc" }, // Set Menu 720C
  "R6150": { recipe: "R6150", type: "alc" }, // Set Menu 720D
  "R61501": { recipe: "R61501", type: "alc" }, // Set Menu 720E
  "R61502": { recipe: "R61502", type: "alc" }, // Set Menu 720F
  "R6151": { recipe: "R6151", type: "alc" }, // Set Menu 650A
  "R6152": { recipe: "R6152", type: "alc" }, // Set Menu 650B
  "R6153": { recipe: "R6153", type: "alc" }, // Set Menu 710C
  "R6154": { recipe: "R6154", type: "alc" }, // Set Menu 430C
  "R6155": { recipe: "R6155", type: "alc" }, // Set Menu 510A
  "R61551": { recipe: "R61551", type: "alc" }, // Set Menu 510B
  "R6156": { recipe: "R6156", type: "alc" }, // Set Menu Two Courses 1+3 A
  "R6157": { recipe: "R6157", type: "alc" }, // Set Menu Two Courses 1+3 B
  "R6158": { recipe: "R6158", type: "alc" }, // Set Menu Two Courses 1+3 C
  "R6159": { recipe: "R6159", type: "alc" }, // Set Menu Two Courses 1+3 D
  "R6160": { recipe: "R6160", type: "alc" }, // Set Menu Two Courses 1+3 E
  "R6161": { recipe: "R6161", type: "alc" }, // Set Menu Two Courses 2+3 A
  "R6162": { recipe: "R6162", type: "alc" }, // Set Menu Two Courses 2+3 B
  "R6163": { recipe: "R6163", type: "alc" }, // Set Menu Two Courses 2+3 C
  "R6164": { recipe: "R6164", type: "alc" }, // Set Menu Two Courses 2+3 D
  "R6165": { recipe: "R6165", type: "alc" }, // Set Menu Two Courses 2+3 E
  "R6166": { recipe: "R6166", type: "alc" }, // Set Menu Two Courses 1+4
  "R6167": { recipe: "R6167", type: "alc" }, // Set Menu Two Courses 2+4
  "R6168": { recipe: "R6168", type: "alc" }, // Set Menu Two Courses 3+4 A
  "R6169": { recipe: "R6169", type: "alc" }, // Set Menu Two Courses 3+4 B
  "R6170": { recipe: "R6170", type: "alc" }, // Set Menu Two Courses 3+4 C
  "R6171": { recipe: "R6171", type: "alc" }, // Set Menu Two Courses 3+4 D
  "R6172": { recipe: "R6172", type: "alc" }, // Set Menu Two Courses 3+4 E
  "R6173": { recipe: "R6173", type: "alc" }, // Set Menu Three Courses 1+2+3 A
  "R6174": { recipe: "R6174", type: "alc" }, // Set Menu Three Courses 1+2+3 B
  "R6175": { recipe: "R6175", type: "alc" }, // Set Menu Three Courses 1+2+3 C
  "R6176": { recipe: "R6176", type: "alc" }, // Set Menu Three Courses 1+2+3 D
  "R6177": { recipe: "R6177", type: "alc" }, // Set Menu Three Courses 1+2+3 E
  "R6178": { recipe: "R6178", type: "alc" }, // Set Menu Three Courses 1+3+4 A
  "R6179": { recipe: "R6179", type: "alc" }, // Set Menu Three Courses 1+3+4 B
  "R6180": { recipe: "R6180", type: "alc" }, // Set Menu Three Courses 1+3+4 C
  "R6181": { recipe: "R6181", type: "alc" }, // Set Menu Three Courses 1+3+4 D
  "R6182": { recipe: "R6182", type: "alc" }, // Set Menu Three Courses 1+3+4 E
  "R6183": { recipe: "R6183", type: "alc" }, // Set Menu Three Courses 2+3+4 A
  "R6184": { recipe: "R6184", type: "alc" }, // Set Menu Three Courses 2+3+4 B
  "R6185": { recipe: "R6185", type: "alc" }, // Set Menu Three Courses 2+3+4 C
  "R6186": { recipe: "R6186", type: "alc" }, // Set Menu Three Courses 2+3+4 D
  "R6187": { recipe: "R6187", type: "alc" }, // Set Menu Three Courses 2+3+4 E
  "R6188": { recipe: "R6188", type: "alc" }, // Set Menu Four Courses A
  "R6189": { recipe: "R6189", type: "alc" }, // Set Menu Four Courses B
  "R6190": { recipe: "R6190", type: "alc" }, // Set Menu Four Courses C
  "R6191": { recipe: "R6191", type: "alc" }, // Set Menu Four Courses D
  "R6192": { recipe: "R6192", type: "alc" }, // Set Menu Four Courses E
  "R6193": { recipe: "R6193", type: "alc" }, // Set Menu 500A
  "R6194": { recipe: "R6194", type: "alc" }, // Set Menu 500B
  "R6195": { recipe: "R6195", type: "alc" }, // Set Menu 710D
  "R6196": { recipe: "R6196", type: "alc" }, // Set Menu 550C
  "R6197": { recipe: "R6197", type: "alc" }, // Set Menu 550D
  "R6198": { recipe: "R6198", type: "alc" }, // Set Menu 550E
  "R6199": { recipe: "R6199", type: "alc" }, // Set Menu 850A
  "R61991": { recipe: "R61991", type: "alc" }, // Set Menu 850B
  "R61992": { recipe: "R61992", type: "alc" }, // Set Menu 850C
  "R6200": { recipe: "R6200", type: "set" }, // US Steak Combo
  "R6201": { recipe: "R6201", type: "set" }, // Pork Cuttles Combo
  "R6202": { recipe: "R6202", type: "set" }, // Dong Tao Chicken Feet Combo
  "R6203": { recipe: "R6203", type: "set" }, // Duck Breast Combo
  "R6204": { recipe: "R6204", type: "set" }, // Salmon Combo
  "R6205": { recipe: "R6205", type: "set" }, // Lamb Stew Combo
  "R6206": { recipe: "R6206", type: "set" }, // Chicken Breast Combo
  "R6207": { recipe: "R6207", type: "set" }, // Pork Tenderloin Combo
  "R6208": { recipe: "R6208", type: "set" }, // Dégustation Set Menu 4 to 7 Courses-1
  "R6209": { recipe: "R6209", type: "set" }, // Dégustation Set Menu 4 to 7 Courses-2
  "R6210": { recipe: "R6210", type: "set" }, // Dégustation Set Menu 4 to 7 Courses-3
  "R6211": { recipe: "R6211", type: "set" }, // Dégustation Set Menu 4 to 7 Courses-4
  "R6212": { recipe: "deg_set_5", type: "set" }, // 
  "R6213": { recipe: "deg_set_6", type: "set" }, // 
  "R6214": { recipe: "R6214", type: "set" }, // Dégustation Set Menu 4 to 7 Courses-7
  "R6215": { recipe: "R6215", type: "set" }, // Dégustation Set Menu 4 to 7 Courses-8
  "R6216": { recipe: "R6216", type: "set" }, // Dégustation Set Menu 4 to 7 Courses-9
  "R6217": { recipe: "R6217", type: "set" }, // Dégustation Set Menu 4 to 7 Courses-10
  "R6218": { recipe: "deg_set_7", type: "set" }, // 
  "R6219": { recipe: "R6219", type: "set" }, // Dégustation Set Menu 4 to 7 Courses-12
  "R6220": { recipe: "R6220", type: "set" }, // Set Menu Two Courses 1+2
  "R6221": { recipe: "R6221", type: "set" }, // Set Menu Two Courses 1+3 F
  "R6222": { recipe: "R6222", type: "set" }, // Set Menu Two Courses 1+3 G
  "R6223": { recipe: "R6223", type: "set" }, // Set Menu Two Courses 3+4 F
  "R6224": { recipe: "R6224", type: "set" }, // Set Menu Two Courses 3+4 G
  "R6225": { recipe: "R6225", type: "set" }, // Set Menu Three Courses 1+2+3 F
  "R6226": { recipe: "R6226", type: "set" }, // Set Menu Three Courses 1+2+3 G
  "R6227": { recipe: "R6227", type: "set" }, // Set Menu Three Courses 1+3+4 F
  "R6228": { recipe: "R6228", type: "set" }, // Set Menu Three Courses 1+3+4 G
  "R6229": { recipe: "R6229", type: "set" }, // Set Menu Three Courses 2+3+4 F
  "R6230": { recipe: "R6230", type: "set" }, // Set Menu Three Courses 2+3+4 G
  "R6231": { recipe: "R6231", type: "set" }, // Set Menu Four Courses F
  "R6232": { recipe: "R6232", type: "set" }, // Set Menu Four Courses G
  "R6233": { recipe: "R6233", type: "set" }, // Set Menu Two Courses 2+3 F
  "R6234": { recipe: "R6234", type: "set" }, // Set Menu Two Courses 2+3 G
  "R6260001": { recipe: "R6260001", type: "set" }, // Set Menu 370A
  "R6260002": { recipe: "R6260002", type: "set" }, // Set Menu 370B
  "R6260003": { recipe: "R6260003", type: "set" }, // Set Menu 370C
  "R6260004": { recipe: "R6260004", type: "set" }, // Set Menu 470A
  "R6260005": { recipe: "R6260005", type: "set" }, // Set Menu 470B
  "R6260006": { recipe: "R6260006", type: "set" }, // Set Menu 470C
  "R6260007": { recipe: "R6260007", type: "set" }, // Set Menu 600A
  "R6260008": { recipe: "R6260008", type: "set" }, // Set Menu 600B
  "R6260009": { recipe: "R6260009", type: "set" }, // Set Menu 770A
  "R6260010": { recipe: "R6260010", type: "set" }, // Set Menu 770B
  "R6260011": { recipe: "R6260011", type: "set" }, // Set Menu 970A
  "R6260012": { recipe: "R6260012", type: "set" }, // Set Menu 1250
  "R6260013": { recipe: "R6260013", type: "set" }, // Set Menu 1550
  "R6260014": { recipe: "R6260014", type: "set" }, // Set Menu 1800
  "R6260015": { recipe: "R6260015", type: "set" }, // Set Menu 2000
  "R7001": { recipe: "R7001", type: "alc" }, // Multicolor Salad
  "R7002": { recipe: "R7002", type: "alc" }, // Green seasonal vegetables soup
  "R7003": { recipe: "R7003", type: "alc" }, // Breaded pork loin, tomatoes sauce, broccoli and carrot flan
  "R7004": { recipe: "R7004", type: "alc" }, // Basa fillet roulade southern, broccoli and carrot flan
  "R7005": { recipe: "R7005", type: "alc" }, // Banana crepe, chocolate sauce
  "R7006": { recipe: "R7006", type: "alc" }, // Regular Vietnamese coffee or green tea
  "R8001": { recipe: "R8001", type: "alc" }, // Oven-baked stuffed eggplant with lentils and ratatoui le (Vegetarian)
  "R8002": { recipe: "R8002", type: "alc" }, // Grilled vegetable Napoleon with red pepper coulis (Vegetarian)
  "S1003": { recipe: "S1003", type: "beer" }, // Grenadine (Siro Lựu)
  "S1004": { recipe: "S1004", type: "beer" }, // Syrup - Pineapple 70cl
  "SET1250": { recipe: "SET1250", type: "alc" }, // 
  "SET1550": { recipe: "SET1550", type: "alc" }, // 
  "SET1800": { recipe: "SET1800", type: "alc" }, // 
  "SET2000": { recipe: "SET2000", type: "alc" }, // 
  "SET370": { recipe: "SET370", type: "alc" }, // 
  "SET470": { recipe: "SET470", type: "alc" }, // 
  "SET600": { recipe: "SET600", type: "alc" }, // 
  "SET770": { recipe: "SET770", type: "alc" }, // 
  "SET970": { recipe: "SET970", type: "alc" }, // 
  "SI0001": { recipe: "SI0001", type: "alc" }, // Sauteed Mushroom
  "SI0002": { recipe: "SI0002", type: "alc" }, // Grilled Asparagus
  "SI0003": { recipe: "SI0003", type: "alc" }, // Arugula Salad
  "SI0004": { recipe: "SI0004", type: "alc" }, // French Fries
  "SI0005": { recipe: "SI0005", type: "alc" }, // Baked Potatoes
  "SI0006": { recipe: "SI0006", type: "alc" }, // Mashed Potatoes
  "SI0007": { recipe: "SI0007", type: "alc" }, // Extra sauce
  "T1100A": { recipe: "T1100A", type: "alc" }, // 
  "T1100B": { recipe: "T1100B", type: "alc" }, // 
  "T1100C": { recipe: "T1100C", type: "alc" }, // 
  "T1100D": { recipe: "T1100D", type: "alc" }, // 
  "T1200A": { recipe: "T1200A", type: "alc" }, // 
  "T1200B": { recipe: "T1200B", type: "alc" }, // 
  "T1250A": { recipe: "T1250A", type: "alc" }, // 
  "T1500A": { recipe: "T1500A", type: "alc" }, // 
  "T1500B": { recipe: "T1500B", type: "alc" }, // 
  "T1550A": { recipe: "T1550A", type: "alc" }, // 
  "T1800A": { recipe: "T1800A", type: "alc" }, // 
  "T2000A": { recipe: "T2000A", type: "alc" }, // 
  "T290A": { recipe: "T290A", type: "alc" }, // 
  "T370A": { recipe: "T370A", type: "alc" }, // 
  "T380A": { recipe: "T380A", type: "alc" }, // 
  "T380B": { recipe: "T380B", type: "alc" }, // 
  "T380C": { recipe: "T380C", type: "alc" }, // 
  "T380D": { recipe: "T380D", type: "alc" }, // 
  "T380E": { recipe: "T380E", type: "alc" }, // 
  "T380F": { recipe: "T380F", type: "alc" }, // 
  "T380H": { recipe: "T380H", type: "alc" }, // 
  "T380J": { recipe: "T380J", type: "alc" }, // 
  "T380K": { recipe: "T380K", type: "alc" }, // 
  "T380N": { recipe: "T380N", type: "alc" }, // 
  "T430G": { recipe: "T430G", type: "alc" }, // 
  "T470A": { recipe: "T470A", type: "alc" }, // 
  "T500A": { recipe: "T500A", type: "alc" }, // 
  "T500B": { recipe: "T500B", type: "alc" }, // 
  "T500C": { recipe: "T500C", type: "alc" }, // 
  "T500D": { recipe: "T500D", type: "alc" }, // 
  "T500E": { recipe: "T500E", type: "alc" }, // 
  "T600A": { recipe: "T600A", type: "alc" }, // 
  "T600B": { recipe: "T600B", type: "alc" }, // 
  "T600D": { recipe: "T600D", type: "alc" }, // 
  "T650A": { recipe: "T650A", type: "alc" }, // 
  "T650B": { recipe: "T650B", type: "alc" }, // 
  "T650C": { recipe: "T650C", type: "alc" }, // 
  "T770A": { recipe: "T770A", type: "alc" }, // 
  "T770B": { recipe: "T770B", type: "alc" }, // 
  "T850A": { recipe: "T850A", type: "alc" }, // 
  "T850B": { recipe: "T850B", type: "alc" }, // 
  "T850C": { recipe: "T850C", type: "alc" }, // 
  "T850D": { recipe: "T850D", type: "alc" }, // 
  "T950A": { recipe: "T950A", type: "alc" }, // 
  "T950B": { recipe: "T950B", type: "alc" }, // 
  "T970A": { recipe: "T970A", type: "alc" }, // 
  "V1001": { recipe: "V1001", type: "alc" }, // Chateau Noaillac Medoc Cru Bourgeois 37.5cl (R)
  "V1002": { recipe: "V1002", type: "alc" }, // Penfolds Koonunga Hill Chardonnay 37.5cl (W)
  "V1003": { recipe: "V1003", type: "alc" }, // Penfolds Koonunga Hill Shiraz Cabernet Sauvignon 37.5cl (R)
  "V1004": { recipe: "V1004", type: "alc" }, // Chile Evolucion Cabernet Sauvignon 37.5cl (red)
  "V1005": { recipe: "V1005", type: "alc" }, // Chile Evolucion Sauvignon Blanc 37.5cl (White)
  "V1006": { recipe: "V1006", type: "alc" }, // Just VDP OC Merlot 37.5cl
  "V1007": { recipe: "V1007", type: "alc" }, // Vistana Cabernet Sauvignon Merlot 3.75cl
  "V1008": { recipe: "V1008", type: "alc" }, // La Palma Cabernet Sauvignon 37.5cl, Chile
  "V2001": { recipe: "V2001", type: "alc" }, // Pierre Larousse Blanc De Blancs Brut 37.5cl, France
  "V2002": { recipe: "V2002", type: "alc" }, // Larousse Chardonnay Sparkling, France
  "V2003": { recipe: "V2003", type: "alc" }, // Champagne Brut 37.5cl Grande Reserve Brut, Baron Fuente, France
  "V2004": { recipe: "V2004", type: "alc" }, // Champagne Jacques Picard, France
  "V2005": { recipe: "V2005", type: "alc" }, // Champagne Brut 75cl Baron Fuente Rose Dolores, France
  "V2006": { recipe: "V2006", type: "alc" }, // Champagne Taittinger Brut Reserve NV, France
  "V2007": { recipe: "V2007", type: "alc" }, // Cuvee Jean-Louis Brut
  "V2008": { recipe: "V2008", type: "alc" }, // Torley - Rosé (Sparking)
  "V2009": { recipe: "V2009", type: "alc" }, // Champagne Moët & Chandon
  "V2010": { recipe: "V2010", type: "alc" }, // Delafinca Carta Blance Sparkling Wine
  "V2011": { recipe: "V2011", type: "alc" }, // BOTTEGA Fragolino Sparkling
  "V2012": { recipe: "V2012", type: "alc" }, // Montparnasse Brut Vin Mousseux, France
  "V2013": { recipe: "V2013", type: "alc" }, // Gemma Di Luma Moscato 75CL
  "V2014": { recipe: "V2014", type: "alc" }, // trống
  "V2015": { recipe: "V2015", type: "alc" }, // Chanoine Frères Brut NV (Champagne AOC — France)
  "V2016": { recipe: "V2016", type: "alc" }, // Jean-Noël Haton Cuvée Classic Brut NV ( Champagne AOC, Damery)
  "V2017": { recipe: "V2017", type: "alc" }, // Pitars Prosecco DOC Extra Dry (Glera · Grave del Friuli DOC — Italy) - Sparkling
  "V2018": { recipe: "V2018", type: "alc" }, // Crémant de Bourgogne Brut Vignerons de Buxy, Chardonnay, Aligoté, Gamay
  "V3001": { recipe: "V3001", type: "alc" }, // Late Harvest Sauvignon Blanc 37.5cl, Chile
  "V3002": { recipe: "V3002", type: "alc" }, // Baron Philippe de Rothschild, Mouton Cadet Réserve, Sauternes Half Bottle, France
  "V3003": { recipe: "V3003", type: "alc" }, // Baron Philippe de Rothschild, Mouton Cadet Réserve, Sauternes full  Bottle, France
  "V3008": { recipe: "V3008", type: "alc" }, // Montes Late Harvest Gewyztraminer 37.5cl
  "V3009": { recipe: "V3009", type: "alc" }, // De Bortoli, Deen Vat 5, Botrytis Semillon Late Harvest 37.5cl
  "V4001": { recipe: "V4001", type: "alc" }, // Les Pierres Boissy Syrah Merlot - House wine
  "V4002": { recipe: "V4002", type: "alc" }, // CHÂTEAU BAUVALLON (Red)
  "V4003": { recipe: "V4003", type: "alc" }, // La Croix Bacalan Merlot (R)
  "V4004": { recipe: "V4004", type: "alc" }, // Château de Villenouvette Reserve
  "V4005": { recipe: "V4005", type: "alc" }, // Georges Duboeuf Pinot Noir
  "V4006": { recipe: "V4006", type: "alc" }, // Collection Privée Rouge (Merlot, Cabernet Sauvignon) _ Bordeaux
  "V4007": { recipe: "V4007", type: "alc" }, // Georges Duboeuf Beaujolais Villages
  "V4008": { recipe: "V4008", type: "alc" }, // M. Chapoutier Belleruche, Côtes du Rhône Rouge
  "V4009": { recipe: "V4009", type: "alc" }, // Les Hauts de La Gaffeliere, Bordeaux Rouge
  "V4010": { recipe: "V4010", type: "alc" }, // DOURTHE N.1 ROUGE
  "V4011": { recipe: "V4011", type: "alc" }, // FAMILLE PERRIN Reserve
  "V4012": { recipe: "V4012", type: "alc" }, // BOUCHARD PERE ET FILS Bourgogne Pinot Noir «La Vigné»
  "V4013": { recipe: "V4013", type: "alc" }, // Clarendelle rouge – Inspired by Haut Brion
  "V4014": { recipe: "V4014", type: "alc" }, // Château Noaillac Cru Bourgeois
  "V4015": { recipe: "V4015", type: "alc" }, // Madiran Château de Crouseilles
  "V4016": { recipe: "V4016", type: "alc" }, // Les Hauts de La Gaffeliere, Saint Emilion
  "V4017": { recipe: "V4017", type: "alc" }, // Château Haut-Rocher Grand Cru
  "V4018": { recipe: "V4018", type: "alc" }, // Château De Malengin, Baron E. De Rothschild
  "V4019": { recipe: "V4019", type: "alc" }, // Croix de Carbonnieux Red (by Château Carbonnieux) (Grand Cru Classé)  (red)
  "V4020": { recipe: "V4020", type: "alc" }, // Le Haut Medoc de Giscours (by Château Giscours) (Grand Cru Classé)
  "V4021": { recipe: "V4021", type: "alc" }, // 2010 CHÂTEAU VIEUX LARTIGUE « Grand Crus»
  "V4022": { recipe: "V4022", type: "alc" }, // 2010 CHÂTEAU LA MISSION
  "V4023": { recipe: "V4023", type: "alc" }, // Le Médoc de Cos (by Château Cos d’Estournel Grand Cru Classé)
  "V4024": { recipe: "V4024", type: "alc" }, // Domaine De Saint-Guirons by Château Grand Puy Lacoste (Grand Cru Classé)
  "V4025": { recipe: "V4025", type: "alc" }, // CLUB ELITE, Château Tour Massac, Margaux
  "V4026": { recipe: "V4026", type: "alc" }, // Georges Duboeuf Macon Villages
  "V4027": { recipe: "V4027", type: "alc" }, // Balmontée Bordeaux - Red
  "V4028": { recipe: "V4028", type: "alc" }, // Balmontée Bordeaux Superior - Red
  "V4029": { recipe: "V4029", type: "alc" }, // Chateauneauf du-pape
  "V4030": { recipe: "V4030", type: "alc" }, // Château de Villenouvette Cuvee Marcel
  "V4031": { recipe: "V4031", type: "alc" }, // Clos Saint Vincent Saint-Emilion Grand Cru
  "V4032": { recipe: "V4032", type: "alc" }, // Chateau Brane Cantenac 2009 - Margeaux Grand Cru Classe
  "V4033": { recipe: "V4033", type: "alc" }, // Chateau Dauzac  - Beaudaux, Cabernet Sauvignon-Merlot
  "V4034": { recipe: "V4034", type: "alc" }, // Roc Saint Andre (Red)
  "V4035": { recipe: "V4035", type: "alc" }, // Georges Duboeuf Beaujolais Villages Nouveau (Fresh Wine)
  "V4036": { recipe: "V4036", type: "alc" }, // Légende Bordeaux Rouge 75cl (Red)
  "V4037": { recipe: "V4037", type: "alc" }, // Légende Saint-Émilion 75cl (Red)
  "V4038": { recipe: "V4038", type: "alc" }, // Chateau Puy Razac Grand Cru Merlot- Cabernet 75cl
  "V4039": { recipe: "V4039", type: "alc" }, // Les Hauts De Lynch Moussac - Haut Medoc 75cl (Red)
  "V4040": { recipe: "V4040", type: "alc" }, // Chateau Belle Vue, Haut-Médoc- Bordeaux 75cl (Red)
  "V4041": { recipe: "V4041", type: "alc" }, // Chateau  Rocher Calon, Montagne Saint Emilion - Red
  "V4042": { recipe: "V4042", type: "alc" }, // Chateau Chantemerle Cru Bourgeois - Red
  "V4043": { recipe: "V4043", type: "alc" }, // Aurore De Dauzac 750- Red
  "V4044": { recipe: "V4044", type: "alc" }, // Premiere Note Syrah 75cl
  "V4045": { recipe: "V4045", type: "alc" }, // Louis Latour - Bourgogne Pinot Noir
  "V4046": { recipe: "V4046", type: "alc" }, // Cotes Catalanes Domaine Rombeau Merlot - Red
  "V4047": { recipe: "V4047", type: "alc" }, // Domain Rombeau La Cave Secrete - Red
  "V4048": { recipe: "V4048", type: "alc" }, // Chateau Rombeau Elise Vieles Vignes 16% - Red
  "V4049": { recipe: "V4049", type: "alc" }, // Chateau Badette, Pessac - Saint Emilion GCC
  "V4050": { recipe: "V4050", type: "alc" }, // Mercurey Rouge Louis Latour
  "V4051": { recipe: "V4051", type: "alc" }, // Brio de Cantenac Brown,Cabernet Sauvignon
  "V4052": { recipe: "V4052", type: "alc" }, // Louis Eschenauer Saint Emilion AOC
  "V4053": { recipe: "V4053", type: "alc" }, // ChaiMas Rouge
  "V4054": { recipe: "V4054", type: "alc" }, // La Pommeraie de Brown, Cabernet Sauvignon
  "V4055": { recipe: "V4055", type: "alc" }, // Optimum, Fronton
  "V4056": { recipe: "V4056", type: "alc" }, // Chateau Tabuteau, Lussac - Saint Emilion
  "V4057": { recipe: "V4057", type: "alc" }, // Patriarche, Mercurey - Red
  "V4058": { recipe: "V4058", type: "alc" }, // Côte De Nuits-Villages Louis Latour
  "V4059": { recipe: "V4059", type: "alc" }, // Domaine de saravel valreas cotes du rhone villages - Red
  "V4060": { recipe: "V4060", type: "alc" }, // F31 Belle Bergere bottle - Red
  "V4061": { recipe: "V4061", type: "alc" }, // Chateau Batailley Red Bottle
  "V4062": { recipe: "V4062", type: "alc" }, // Château Moulin De La Faye
  "V4063": { recipe: "V4063", type: "alc" }, // Chantecaille Bordeaux AOC Red
  "V4064": { recipe: "V4064", type: "alc" }, // F. Thienpont Causse Rouge Merlot, Bordeaux - Red
  "V4065": { recipe: "V4065", type: "alc" }, // Baron P. de Rothschild Mouton Cadet Bordeaux - Red
  "V4066": { recipe: "V4066", type: "alc" }, // Ronan By Clinet (by Chateau Clinet, Pomerol) Merlot Bordeaux AC- Red
  "V4067": { recipe: "V4067", type: "alc" }, // Maltus, Pezat, Bordeaux Superior - Red
  "V4068": { recipe: "V4068", type: "alc" }, // Nicolas Thienpont, Chateau Puygueraud,(Merlot/Cab Franc/ Malbec) Francs Cotes de Bordeaux
  "V4069": { recipe: "V4069", type: "alc" }, // Alain Brumont, Chateau Bouscasse, Madiran - Red
  "V4070": { recipe: "V4070", type: "alc" }, // Chateau Roc de Candale, Saint Emilion Grand Cru- Red
  "V4071": { recipe: "V4071", type: "alc" }, // Baron P. de Rothschild Mouton Cadet Reserve Pauillac - Red
  "V4072": { recipe: "V4072", type: "alc" }, // Château La Garenne Pomerol - Red
  "V4073": { recipe: "V4073", type: "alc" }, // Chateau Bertineau Saint-Vincent | Pomerol - Bordeaux- Red
  "V4074": { recipe: "V4074", type: "alc" }, // Louis Latour Domaine De Valmoissine - Red
  "V4075": { recipe: "V4075", type: "alc" }, // Louis Latour Pinot Noir Les Pierres Dorées - Red
  "V4076": { recipe: "V4076", type: "alc" }, // Guigal, Cotes du Rhone - Red
  "V4077": { recipe: "V4077", type: "alc" }, // Dufouleur Monopole Red Wine Bt
  "V4078": { recipe: "V4078", type: "alc" }, // Chateau Haut Selve Graves - Red
  "V4079": { recipe: "V4079", type: "alc" }, // Chateau Haut Dambert
  "V4080": { recipe: "V4080", type: "alc" }, // Château Clou Du Pin Bordeaux Supérieur ( Red )
  "V4081": { recipe: "V4081", type: "alc" }, // Château La Branne Médoc Cru Bourgeois, France
  "V4082": { recipe: "V4082", type: "alc" }, // CHÂTEAU HAUT SAINT BRICE (Merlot - Cabernet Franc) Saint-Émilion Grand Cru
  "V4083": { recipe: "V4083", type: "alc" }, // CHÂTEAU MONT- PÉRAT (Merlot/Cabernet Franc/Cabernet Sauvignon) Bordeaux
  "V4084": { recipe: "V4084", type: "alc" }, // CHATEAU CAP DE FAUGERES Cotes de Castillon
  "V4085": { recipe: "V4085", type: "alc" }, // JEAN LUC COLOMBO, "LA VIOLETTE" (Syrah) IGP d'Oc
  "V4086": { recipe: "V4086", type: "alc" }, // M.CHAPOUTIER CROZES-HERMITAGE LA PETITE RUCHE (Syrah) Rhone
  "V4087": { recipe: "V4087", type: "alc" }, // Chateau Fleur Cardinale, Saint-Emilion Grand Cru, France
  "V4088": { recipe: "V4088", type: "alc" }, // Château Baratet, Cabernet Sauvignon, France
  "V4089": { recipe: "V4089", type: "alc" }, // Chateau Haut Mouleyre AOP Bordeaux Rouge
  "V4090": { recipe: "V4090", type: "alc" }, // M. Chapoutier « Les Meysonniers »Crozes-Hermitage Syrah (organic)
  "V4091": { recipe: "V4091", type: "alc" }, // Bernard Magrez « Le Prélat » Rouge Côtes du Rhône Villages Laudun
  "V4092": { recipe: "V4092", type: "alc" }, // Grand Bateau Bordeaux Rouge (by Beychevelle) (Merlot · CS · AOC)
  "V5001": { recipe: "V5001", type: "alc" }, // Les Pierres Boissy Chardonnay  - House wine
  "V5002": { recipe: "V5002", type: "alc" }, // La Croix Bacalan Semillon Sauvignon
  "V5003": { recipe: "V5003", type: "alc" }, // Collection Privée Blanc (Sauvignon Blanc) _ Bordeaux
  "V5004": { recipe: "V5004", type: "alc" }, // Les Hauts de La Gaffeliere, Bordeaux Blanc
  "V5005": { recipe: "V5005", type: "alc" }, // Bourgogne Aligote, Louis Jadot
  "V5006": { recipe: "V5006", type: "alc" }, // DOURTHE N.1 BLANC
  "V5007": { recipe: "V5007", type: "alc" }, // Clarendelle Blanc – Inspired by Haut Brion
  "V5008": { recipe: "V5008", type: "alc" }, // Gustave Lorentz Riesling
  "V5009": { recipe: "V5009", type: "alc" }, // WILLIAM FEVRE Petit Chablis
  "V5010": { recipe: "V5010", type: "alc" }, // Trimbach, Gewurztraminer
  "V5011": { recipe: "V5011", type: "alc" }, // BOUCHARD PERE ET FILS Pouilly Fuisse
  "V5012": { recipe: "V5012", type: "alc" }, // Pouilly Fuisse, Domaine J.A. Ferret
  "V5013": { recipe: "V5013", type: "alc" }, // CHÂTEAU BAUVALLON (White)
  "V5014": { recipe: "V5014", type: "alc" }, // CHÂTEAU LARY (White)
  "V5015": { recipe: "V5015", type: "alc" }, // Châtteau de MeurSault - Bourgone - Chardonay
  "V5016": { recipe: "V5016", type: "alc" }, // Sancerre Blance le Barones
  "V5018": { recipe: "V5018", type: "alc" }, // Muscadet Sevre et Maine sur Lie- D&F 75cl (White)
  "V5019": { recipe: "V5019", type: "alc" }, // Légende Bordeaux Blanc 750ml (White)
  "V5020": { recipe: "V5020", type: "alc" }, // Chateau La Rose Bellevue Cuvee Tradition 75cl (White)
  "V5021": { recipe: "V5021", type: "alc" }, // Petit Chablis Pas Si Petit 75cl - White
  "V5022": { recipe: "V5022", type: "alc" }, // Premiere Note Marsanne 75cl (White)
  "V5023": { recipe: "V5023", type: "alc" }, // Louis Latour - Bourgogne Chardonnay
  "V5024": { recipe: "V5024", type: "alc" }, // ChaiMas Blanc Chateau Paul Mas Languedoc
  "V5025": { recipe: "V5025", type: "alc" }, // Louis Latour - Chablis Burgundy
  "V5026": { recipe: "V5026", type: "alc" }, // F30 Belle Bergere bottle - White
  "V5027": { recipe: "V5027", type: "alc" }, // Chantecaille Bordeaux AOC White
  "V5028": { recipe: "V5028", type: "alc" }, // F. Thienpont Sauvignon Blanc - White
  "V5029": { recipe: "V5029", type: "alc" }, // Ronan By Clinet (by Chateau Clinet, Pomerol) Bordauex Blanc - White
  "V5030": { recipe: "V5030", type: "alc" }, // Nicolas Thienpont, Chateau Puygueraud,  Francs Cotes de Bordeaux -White
  "V5031": { recipe: "V5031", type: "alc" }, // Louis Latour Ardèche, Chardonnay - White
  "V5032": { recipe: "V5032", type: "alc" }, // Louis Latour Chablis La Chanfleure, Chardonnay  - White
  "V5033": { recipe: "V5033", type: "alc" }, // Louis Latour Pouilly-Fuissé - White
  "V5034": { recipe: "V5034", type: "alc" }, // Dufouleur Monopole White wine Bt
  "V5035": { recipe: "V5035", type: "alc" }, // Château Clou Du Pin Bordeaux Blanc ( White )
  "V5036": { recipe: "V5036", type: "alc" }, // CHÂTEAU MONT-PÉRAT (Sauvignon Blanc-Semillon) Bordeaux
  "V5037": { recipe: "V5037", type: "alc" }, // PASCAL JOLIVET ATTITUDE (Sauvignon Blanc) Loire Valley
  "V5038": { recipe: "V5038", type: "alc" }, // Château Baratet, Sauvignon Blanc, France
  "V5039": { recipe: "V5039", type: "alc" }, // Grand Bateau Bordeaux Blanc (by Beychevelle)
  "V5040": { recipe: "V5040", type: "alc" }, // M. Chapoutier « Belleruche » Côtes du Rhône Blanc, Grenache Blanc • Clairette
  "V5041": { recipe: "V5041", type: "alc" }, // Bernard Magrez « Le Prélat » Blanc Côtes du Rhône Villages Laudun
  "V5042": { recipe: "V5042", type: "alc" }, // M.Chapoutier Domaine des Granges de Mirabel
  "V5043": { recipe: "V5043", type: "alc" }, // Gustave Lorentz Gewurztraminer
  "V6001": { recipe: "V6001", type: "alc" }, // ECHEVERRÍA Valle Dorado Sauvignon Blanc (White)
  "V6002": { recipe: "V6002", type: "alc" }, // ECHEVERRÍA Valle Dorado Cabernet Sauvignon (red)
  "V6003": { recipe: "V6003", type: "alc" }, // Baron Philippe de Rothschild Mapu Reserva Merlot (Red)
  "V6004": { recipe: "V6004", type: "alc" }, // Baron Philippe de Rothschild Mapu Chardonay (White)
  "V6005": { recipe: "V6005", type: "alc" }, // Santa Digna, Gewurztraminer (White)
  "V6006": { recipe: "V6006", type: "alc" }, // Santa Digna, Cabernet Sauvignon (Red)
  "V6007": { recipe: "V6007", type: "alc" }, // Casillero Del Diablo Reserva Privada Sauvignon Blanc, Concha Y Toro (White)
  "V6008": { recipe: "V6008", type: "alc" }, // Casillero Del Diablo Reserva Privada Cabernet Syrah, Concha Y Toro (Red)
  "V60081": { recipe: "V60081", type: "alc" }, // Casillero Del Diablo Syrah
  "V6009": { recipe: "V6009", type: "alc" }, // Cordillera Reserva Privada Shiraz Blend, Miguel Torres (Red)
  "V6010": { recipe: "V6010", type: "alc" }, // Cordillera, Carménère, Curico, Miguel Torres (Red)
  "V6011": { recipe: "V6011", type: "alc" }, // Château Los Boldos Grand Cru (Red)
  "V6012": { recipe: "V6012", type: "alc" }, // PAVO REAL Cabernet Sauvignon (Reserva)
  "V6014": { recipe: "V6014", type: "alc" }, // PAVO REAL Cabernet Sauvignon - Carmenere (GR)
  "V6015": { recipe: "V6015", type: "alc" }, // PAVO REAL Sauvignon Blanc (Reserva)
  "V6016": { recipe: "V6016", type: "alc" }, // PAVO REAL Sauvignon Blanc (Variietals)
  "V6017": { recipe: "V6017", type: "alc" }, // PAVO REAL Cabernet Sauvignon (Varietals)
  "V6018": { recipe: "V6018", type: "alc" }, // Montes Alpha Syrah
  "V6019": { recipe: "V6019", type: "alc" }, // Montes Alpha-M
  "V6020": { recipe: "V6020", type: "alc" }, // Wine of the Month (bottle)
  "V6021": { recipe: "V6021", type: "alc" }, // Luis Felipe Gran Reserva Shiraz
  "V6022": { recipe: "V6022", type: "alc" }, // Luis Felipe Gran Reserva Chardonnay
  "V6023": { recipe: "V6023", type: "alc" }, // Rios Chie Red
  "V6024": { recipe: "V6024", type: "alc" }, // La Capitana Cabernet Merlot
  "V6025": { recipe: "V6025", type: "alc" }, // Marques De Casa Concha Shiraz, CYT, CHILE
  "V6026": { recipe: "V6026", type: "alc" }, // Marques Casa Cabernet Sauvignon Chile
  "V60261": { recipe: "V60261", type: "alc" }, // Concha Y Toro, Marques de Casa Concha Chardonnay, Limari Valley - White Chile
  "V6027": { recipe: "V6027", type: "alc" }, // Luis Felipe Chardonnay
  "V6028": { recipe: "V6028", type: "alc" }, // 1887 Cabernet Sauvignon
  "V6029": { recipe: "V6029", type: "alc" }, // 1887 Sauvignon Blanc
  "V6030": { recipe: "V6030", type: "alc" }, // Santa Rita Reserva Cabernet Sauvignon 75cl (Red)
  "V6031": { recipe: "V6031", type: "alc" }, // Santa Rita Reserva sauvignon Blanc 75cl (White)
  "V6032": { recipe: "V6032", type: "alc" }, // Sunrise Cabernet Sauvignon, Concha Y Toro 75cl (Red)
  "V6033": { recipe: "V6033", type: "alc" }, // Sunrise Chardonay, Concha Y Toro (White)
  "V6034": { recipe: "V6034", type: "alc" }, // Frontera Cabernet Sauvignon 75cl (Red)
  "V6035": { recipe: "V6035", type: "alc" }, // Frontera Sauvignon Blanc 75cl (White)
  "V6036": { recipe: "V6036", type: "alc" }, // Novas Gran Reserva Cabernet Sauvignon Organic Wine
  "V6037": { recipe: "V6037", type: "alc" }, // Novas Gran Reserva Sauvignon Blanc Organic Wine
  "V6038": { recipe: "V6038", type: "alc" }, // Santa Ema Teroir Reserva Cabernet Sauvignon (Red)
  "V6039": { recipe: "V6039", type: "alc" }, // Santa Ema Teroir Reserva Sauvignon Blanc (White)
  "V6041": { recipe: "V6041", type: "alc" }, // Santa Ema Reserva Sauvignon Blanc
  "V6042": { recipe: "V6042", type: "alc" }, // G7 Reserva, Carta Vieja - Red
  "V6043": { recipe: "V6043", type: "alc" }, // G7 Reserva, Carta Vieja - White
  "V6044": { recipe: "V6044", type: "alc" }, // Santa Carolina Vistana - Red
  "V6045": { recipe: "V6045", type: "alc" }, // Santa Carolina Vistana - White
  "V6046": { recipe: "V6046", type: "alc" }, // Yali Reserva, Ventisquero - Red
  "V6047": { recipe: "V6047", type: "alc" }, // Yali Reserva, Ventisquero - White
  "V6048": { recipe: "V6048", type: "alc" }, // Yali Sauvignon Blanc
  "V6049": { recipe: "V6049", type: "alc" }, // Luis Felipe Red Wine Bottle
  "V6050": { recipe: "V6050", type: "alc" }, // Casa Subercaseaux Cab Sauv
  "V6051": { recipe: "V6051", type: "alc" }, // CASAS DEL TOQUI, Barrel Reserva, Cabernet Sauvignon - Red Chile
  "V6052": { recipe: "V6052", type: "alc" }, // CASAS DEL TOQUI, Barrel Reserva, Chardonnay - White Chile
  "V6053": { recipe: "V6053", type: "alc" }, // MIGUEL TORRES, LAS MULAS ORGANIC (Cabernet Sauvignon) Central Valley
  "V6054": { recipe: "V6054", type: "alc" }, // MIGUEL TORRES, ANDICA RESERVA (Gewurztraminer) Curico Valley
  "V6055": { recipe: "V6055", type: "alc" }, // Ocho Reserva Cabernet Sauvignon
  "V6056": { recipe: "V6056", type: "alc" }, // MontGras Estate Cabernet Sauvignon Chile
  "V6057": { recipe: "V6057", type: "alc" }, // Karku Cabernet Sauvignon ( Red )
  "V6058": { recipe: "V6058", type: "alc" }, // Karku Sauvignon Blanc- Chile ( White )
  "V6059": { recipe: "V6059", type: "alc" }, // Montes Classic Series Chardonnay (CuricóValley DO — Chile)
  "V6060": { recipe: "V6060", type: "alc" }, // Cremaschi Furlotti Chardonnay (Valle Central DO — Chile)
  "V6061": { recipe: "V6061", type: "alc" }, // Cremaschi Furlotti Sauvignon Blanc (Valle Central DO — Chile)
  "V6062": { recipe: "V6062", type: "alc" }, // Cremaschi Furlotti Cabernet Sauvignon (Valle Central DO — Chile)
  "V6063": { recipe: "V6063", type: "alc" }, // Montes Alpha Cabernet Sauvignon - Red
  "V7001": { recipe: "V7001", type: "alc" }, // Bonacosta, Masi (Corvina, Rondinella and Molinara) (Red)
  "V7002": { recipe: "V7002", type: "alc" }, // Chianti Placido Primavera Selection (bordolese bottle) (Red)
  "V7003": { recipe: "V7003", type: "alc" }, // Masianco Supervenetian, Masi (Pinot Grigio, Verduzzo) (White)
  "V7004": { recipe: "V7004", type: "alc" }, // Passo
  "V7005": { recipe: "V7005", type: "alc" }, // Carpineto Chianti Classico Riserva DOCG, Sangiovese- Canaiolo (Red)
  "V7006": { recipe: "V7006", type: "alc" }, // Carpineto Farnito, Chardonay- Toscana IGT (White)
  "V7007": { recipe: "V7007", type: "alc" }, // Passimiento Baglio Gibellina (Red)
  "V7008": { recipe: "V7008", type: "alc" }, // Moscato Luca Bosio - White
  "V7009": { recipe: "V7009", type: "alc" }, // Purato, Siccari Appassimento Organic, Terre Siciliane IGP - Red
  "V7010": { recipe: "V7010", type: "alc" }, // Grande Passolo, Salento - Puglia, Primitivo - Negroamaro - Red
  "V7011": { recipe: "V7011", type: "alc" }, // Grande Passolo, Piemonte, Chardonnay - White
  "V7012": { recipe: "V7012", type: "alc" }, // F Negroamaro San Marzano Italy Red WIne
  "V7013": { recipe: "V7013", type: "alc" }, // DRAGA (Merlot) Venezia Giulia IGP
  "V7014": { recipe: "V7014", type: "alc" }, // DRAGA (Sauvignon Blanc) Collio
  "V7015": { recipe: "V7015", type: "alc" }, // Caselletti  Negroamaro Primitivo - Red
  "V7016": { recipe: "V7016", type: "alc" }, // Talò Primitivo di Manduria « San Marzano »
  "V8001": { recipe: "V8001", type: "alc" }, // Fleur du Cap Chardonnay (White)
  "V8002": { recipe: "V8002", type: "alc" }, // Fleur Du Cap Cabernet Sauvignon (Red)
  "V8003": { recipe: "V8003", type: "alc" }, // LE BONHEUR (Cabernet Sauvignon) Stellenbosch
  "V8004": { recipe: "V8004", type: "alc" }, // LE BONHEUR, THE EAGLE'S LAIR (Chardonnay) Stellenbosch
  "V9001": { recipe: "V9001", type: "alc" }, // Tribu Chardonnay (White)
  "V9002": { recipe: "V9002", type: "alc" }, // Tribu Pinot Noir (Red)
  "V9003": { recipe: "V9003", type: "alc" }, // Tribu Malbec (Red)
  "V9004": { recipe: "V9004", type: "alc" }, // Kaiken Estate Sauvignon Blanc–Sémillon
  "V9005": { recipe: "V9005", type: "alc" }, // Kaiken Estate Malbec, Argentina
  "V9006": { recipe: "V9006", type: "alc" }, // 
  "V9101": { recipe: "V9101", type: "alc" }, // Bin 65 Chardonnay, Lindemans (White)
  "V9102": { recipe: "V9102", type: "alc" }, // Bin 40 Merlot, Lindemans (Red)
  "V9103": { recipe: "V9103", type: "alc" }, // Hamilton Island Shiraz (888)
  "V9104": { recipe: "V9104", type: "alc" }, // Hamilton Island Shiraz (389)
  "V9105": { recipe: "V9105", type: "alc" }, // Hamilton Island Cabernet Sauvignon (168)
  "V9106": { recipe: "V9106", type: "alc" }, // Barramundi, Shiraz - Australia
  "V9107": { recipe: "V9107", type: "alc" }, // Barramundi, Chardonnay - Australia
  "V9201": { recipe: "V9201", type: "alc" }, // Private Bin Sauvignon Blanc, Villa Maria (White)
  "V9202": { recipe: "V9202", type: "alc" }, // Private Bin Cabernet Merlot, Villa Maria (Red)
  "V9203": { recipe: "V9203", type: "alc" }, // Kim Crawford, Sauvignon Blanc - New Zealand
  "V9204": { recipe: "V9204", type: "alc" }, // Allan Scott Sauvignon Blanc(Marlborough GI — New Zealand)
  "V9301": { recipe: "V9301", type: "alc" }, // Torrès Sangre de Toro White (Parellada) (White)
  "V9302": { recipe: "V9302", type: "alc" }, // Torrès, Sangre de Toro (Grenáche) (Red)
  "V9303": { recipe: "V9303", type: "alc" }, // Portia Prima, red
  "V9304": { recipe: "V9304", type: "alc" }, // Marqués de Cáceres Crianza, Spain
  "V9401": { recipe: "V9401", type: "alc" }, // Les Domaines Barsalou Grenache Gris Rose, France
  "V9402": { recipe: "V9402", type: "alc" }, // Villa Garrel Rosé, France
  "V9403": { recipe: "V9403", type: "alc" }, // Château Aumedes Corbières Rosé, France
  "V9404": { recipe: "V9404", type: "alc" }, // Tavel Guigal, Rose, France
  "V9405": { recipe: "V9405", type: "alc" }, // Luis Pinel Cinsault Rose
  "V9407": { recipe: "V9407", type: "alc" }, // Premiere note rose de syrah 75cl
  "V9408": { recipe: "V9408", type: "alc" }, // Bosio Moscato Rose Spumante Aromatico Dolce 7.5%
  "V9409": { recipe: "V9409", type: "alc" }, // La Palma Rose, Chile
  "V9410": { recipe: "V9410", type: "alc" }, // Dufouleur Monopole Rose Wine
  "V9411": { recipe: "V9411", type: "alc" }, // Gérard Bertrand « Gris Blanc » IGP, France
  "V9412": { recipe: "V9412", type: "alc" }, // Croix de Peyrassol Rosé IGP, France
  "V9413": { recipe: "V9413", type: "alc" }, // Dufouleur Père & Fils Pinot Noir Rosé (Vin de France — France)
  "V9501": { recipe: "V9501", type: "alc" }, // Dalat Wine Red - Bottle
  "V9502": { recipe: "V9502", type: "alc" }, // Dalat Wine White - Bottle
  "V9503": { recipe: "V9503", type: "alc" }, // Chateau Dalat Reserve Merlot 75cl
  "V9504": { recipe: "V9504", type: "alc" }, // Chateau Dalat Special Cabernet Sauvignon 750ml
  "V9505": { recipe: "V9505", type: "alc" }, // Chateau Dalat Special Chardonay 75cl
  "V9506": { recipe: "V9506", type: "alc" }, // Chateau Dalat Special Merlot 75cl
  "V9507": { recipe: "V9507", type: "alc" }, // Chateau Dalat Tradition Chardonay 75cl
  "V9508": { recipe: "V9508", type: "alc" }, // Chateau Dalat Special Sauvignon Blanc 750ml
  "V9601": { recipe: "V9601", type: "alc" }, // Belle Ambiance Pinot Noir California
  "V9602": { recipe: "V9602", type: "alc" }, // Belle Ambiance Pinot Grigio California
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
    const codeVal = ing.code || ing.id;
    if (['Wine', 'Alcohol'].includes(ing.category) || codeVal.startsWith('ING-069') || codeVal.startsWith('ING-070') || codeVal.startsWith('ING-071')) {
      // Rượu: Tồn theo BOTTLE (Chai), công thức dùng ML
      stock_uom = 'BOTTLE';
      recipe_uom = 'ML';
      factor = 750; // 1 Chai = 750 ML
    } else if (codeVal === 'ING-021') {
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
  ingredients.forEach(i => {
    ingMap.set(i.id, i);
    if (i.code) ingMap.set(i.code, i);
  });
  
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
