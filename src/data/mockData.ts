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
}

// Map POS codes to recipe codes
export const POS_MAPPING: Record<string, { recipe: string; type: 'alc' | 'set' | 'beer' }> = {
  "V8003": { recipe: "V8003", type: "beer" }, // LE BONHEUR (Cabernet Sauvignon) Stellenbosch
  "V8004": { recipe: "V8004", type: "beer" }, // LE BONHEUR, THE EAGLE'S LAIR (Chardonnay) Stellenbosch
  "V9004": { recipe: "V9004", type: "beer" }, // Kaiken Estate Sauvignon Blanc–Sémillon
  "V9005": { recipe: "V9005", type: "beer" }, // Kaiken Estate Malbec, Argentina
  "V9106": { recipe: "V9106", type: "beer" }, // Barramundi, Shiraz - Australia
  "B5001": { recipe: "B5001", type: "beer" }, // Heineken - 33cl
  "B5002": { recipe: "B5002", type: "beer" }, // Tiger - 33cl
  "B5004": { recipe: "B5004", type: "beer" }, // Beer 333 - 33cl
  "B5005": { recipe: "B5005", type: "beer" }, // Saigon beer - 33cl
  "B5007": { recipe: "B5007", type: "beer" }, // Sapporo draught
  "B5010": { recipe: "B5010", type: "beer" }, // Hanoi - 33cl
  "B5012": { recipe: "B5012", type: "beer" }, // Hanoi - can
  "B5016": { recipe: "B5016", type: "beer" }, // Leffe - Belgian beer - bottle 33cl
  "M9202": { recipe: "M9202", type: "beer" }, // Cigarettes Imported
  "M9203": { recipe: "M9203", type: "beer" }, // Cigar Havana
  "V2001": { recipe: "V2001", type: "beer" }, // Pierre Larousse Blanc De Blancs Brut 37.5cl, France
  "V2002": { recipe: "V2002", type: "beer" }, // Larousse Chardonnay Sparkling, France
  "V2006": { recipe: "V2006", type: "beer" }, // Champagne Taittinger Brut Reserve NV, France
  "V2009": { recipe: "V2009", type: "beer" }, // Champagne Moët & Chandon
  "V2015": { recipe: "V2015", type: "beer" }, // Chanoine Frères Brut NV (Champagne AOC — France)
  "V2016": { recipe: "V2016", type: "beer" }, // Jean-Noël Haton Cuvée Classic Brut NV ( Champagne AOC, Damery)
  "V2018": { recipe: "V2018", type: "beer" }, // Crémant de Bourgogne Brut Vignerons de Buxy, Chardonnay, Aligoté, Gamay
  "V6026": { recipe: "V6026", type: "beer" }, // Marques Casa Cabernet Sauvignon Chile
  "V60261": { recipe: "V60261", type: "beer" }, // Concha Y Toro, Marques de Casa Concha Chardonnay, Limari Valley - White Chile
  "V6027": { recipe: "V6027", type: "beer" }, // Luis Felipe Chardonnay
  "V6034": { recipe: "V6034", type: "beer" }, // Frontera Cabernet Sauvignon 75cl (Red)
  "V6035": { recipe: "V6035", type: "beer" }, // Frontera Sauvignon Blanc 75cl (White)
  "V6049": { recipe: "V6049", type: "beer" }, // Luis Felipe Red Wine Bottle
  "V6053": { recipe: "V6053", type: "beer" }, // MIGUEL TORRES, LAS MULAS ORGANIC (Cabernet Sauvignon) Central Valley
  "V6054": { recipe: "V6054", type: "beer" }, // MIGUEL TORRES, ANDICA RESERVA (Gewurztraminer) Curico Valley
  "V6056": { recipe: "V6056", type: "beer" }, // MontGras Estate Cabernet Sauvignon Chile
  "V6057": { recipe: "V6057", type: "beer" }, // Karku Cabernet Sauvignon ( Red )
  "V6058": { recipe: "V6058", type: "beer" }, // Karku Sauvignon Blanc- Chile ( White )
  "V6059": { recipe: "V6059", type: "beer" }, // Montes Classic Series Chardonnay (CuricóValley DO — Chile)
  "V6060": { recipe: "V6060", type: "beer" }, // Cremaschi Furlotti Chardonnay (Valle Central DO — Chile)
  "V6061": { recipe: "V6061", type: "beer" }, // Cremaschi Furlotti Sauvignon Blanc (Valle Central DO — Chile)
  "V6062": { recipe: "V6062", type: "beer" }, // Cremaschi Furlotti Cabernet Sauvignon (Valle Central DO — Chile)
  "V6063": { recipe: "V6063", type: "beer" }, // Montes Alpha Cabernet Sauvignon - Red
  "V9501": { recipe: "V9501", type: "beer" }, // Dalat Wine Red - Bottle
  "V9502": { recipe: "V9502", type: "beer" }, // Dalat Wine White - Bottle
  "V9504": { recipe: "V9504", type: "beer" }, // Chateau Dalat Special Cabernet Sauvignon 750ml
  "V9508": { recipe: "V9508", type: "beer" }, // Chateau Dalat Special Sauvignon Blanc 750ml
  "V1001": { recipe: "V1001", type: "beer" }, // Chateau Noaillac Medoc Cru Bourgeois 37.5cl (R)
  "V1008": { recipe: "V1008", type: "beer" }, // La Palma Cabernet Sauvignon 37.5cl, Chile
  "V7012": { recipe: "V7012", type: "beer" }, // F Negroamaro San Marzano Italy Red WIne
  "V7015": { recipe: "V7015", type: "beer" }, // Caselletti  Negroamaro Primitivo - Red
  "V7016": { recipe: "V7016", type: "beer" }, // Talò Primitivo di Manduria « San Marzano »
  "V9201": { recipe: "V9201", type: "beer" }, // Private Bin Sauvignon Blanc, Villa Maria (White)
  "V9202": { recipe: "V9202", type: "beer" }, // Private Bin Cabernet Merlot, Villa Maria (Red)
  "V9203": { recipe: "V9203", type: "beer" }, // Kim Crawford, Sauvignon Blanc - New Zealand
  "V9204": { recipe: "V9204", type: "beer" }, // Allan Scott Sauvignon Blanc(Marlborough GI — New Zealand)
  "V4008": { recipe: "V4008", type: "beer" }, // M. Chapoutier Belleruche, Côtes du Rhône Rouge
  "V4009": { recipe: "V4009", type: "beer" }, // Les Hauts de La Gaffeliere, Bordeaux Rouge
  "V4014": { recipe: "V4014", type: "beer" }, // Château Noaillac Cru Bourgeois
  "V4017": { recipe: "V4017", type: "beer" }, // Château Haut-Rocher Grand Cru
  "V4045": { recipe: "V4045", type: "beer" }, // Louis Latour - Bourgogne Pinot Noir
  "V4062": { recipe: "V4062", type: "beer" }, // Château Moulin De La Faye
  "V4063": { recipe: "V4063", type: "beer" }, // Chantecaille Bordeaux AOC Red
  "V4064": { recipe: "V4064", type: "beer" }, // F. Thienpont Causse Rouge Merlot, Bordeaux - Red
  "V4065": { recipe: "V4065", type: "beer" }, // Baron P. de Rothschild Mouton Cadet Bordeaux - Red
  "V4068": { recipe: "V4068", type: "beer" }, // Nicolas Thienpont, Chateau Puygueraud,(Merlot/Cab Franc/ Malbec) Francs Cotes de Bordeaux
  "V4069": { recipe: "V4069", type: "beer" }, // Alain Brumont, Chateau Bouscasse, Madiran - Red
  "V4071": { recipe: "V4071", type: "beer" }, // Baron P. de Rothschild Mouton Cadet Reserve Pauillac - Red
  "V4072": { recipe: "V4072", type: "beer" }, // Château La Garenne Pomerol - Red
  "V4074": { recipe: "V4074", type: "beer" }, // Louis Latour Domaine De Valmoissine - Red
  "V4075": { recipe: "V4075", type: "beer" }, // Louis Latour Pinot Noir Les Pierres Dorées - Red
  "V4076": { recipe: "V4076", type: "beer" }, // Guigal, Cotes du Rhone - Red
  "V4077": { recipe: "V4077", type: "beer" }, // Dufouleur Monopole Red Wine Bt
  "V4078": { recipe: "V4078", type: "beer" }, // Chateau Haut Selve Graves - Red
  "V4081": { recipe: "V4081", type: "beer" }, // Château La Branne Médoc Cru Bourgeois, France
  "V4082": { recipe: "V4082", type: "beer" }, // CHÂTEAU HAUT SAINT BRICE (Merlot - Cabernet Franc) Saint-Émilion Grand Cru
  "V4083": { recipe: "V4083", type: "beer" }, // CHÂTEAU MONT- PÉRAT (Merlot/Cabernet Franc/Cabernet Sauvignon) Bordeaux
  "V4088": { recipe: "V4088", type: "beer" }, // Château Baratet, Cabernet Sauvignon, France
  "V4089": { recipe: "V4089", type: "beer" }, // Chateau Haut Mouleyre AOP Bordeaux Rouge
  "V4090": { recipe: "V4090", type: "beer" }, // M. Chapoutier « Les Meysonniers »Crozes-Hermitage Syrah (organic)
  "V4091": { recipe: "V4091", type: "beer" }, // Bernard Magrez « Le Prélat » Rouge Côtes du Rhône Villages Laudun
  "V4092": { recipe: "V4092", type: "beer" }, // Grand Bateau Bordeaux Rouge (by Beychevelle) (Merlot · CS · AOC)
  "V9402": { recipe: "V9402", type: "beer" }, // Villa Garrel Rosé, France
  "V9408": { recipe: "V9408", type: "beer" }, // Bosio Moscato Rose Spumante Aromatico Dolce 7.5%
  "V9410": { recipe: "V9410", type: "beer" }, // Dufouleur Monopole Rose Wine
  "V9411": { recipe: "V9411", type: "beer" }, // Gérard Bertrand « Gris Blanc » IGP, France
  "V9412": { recipe: "V9412", type: "beer" }, // Croix de Peyrassol Rosé IGP, France
  "M6001": { recipe: "M6001", type: "beer" }, // Coke
  "M6002": { recipe: "M6002", type: "beer" }, // Soda
  "M6003": { recipe: "M6003", type: "beer" }, // Tonic
  "M6004": { recipe: "M6004", type: "beer" }, // Sprite
  "M6005": { recipe: "M6005", type: "beer" }, // Fanta
  "M6006": { recipe: "M6006", type: "beer" }, // Diet Coke
  "M6008": { recipe: "M6008", type: "beer" }, // La Vie 1,5 L
  "M6009": { recipe: "M6009", type: "beer" }, // Perrier (Sparkling water 0.33L)
  "M6010": { recipe: "M6010", type: "beer" }, // S.Pellegrino (Sparkling water 0.5L)
  "M6014": { recipe: "M6014", type: "beer" }, // Evian mineral water bottle 0.5L - France
  "M6020": { recipe: "M6020", type: "beer" }, // Maison Vie, mineral water bottle 0,52L
  "V9301": { recipe: "V9301", type: "beer" }, // Torrès Sangre de Toro White (Parellada) (White)
  "V9302": { recipe: "V9302", type: "beer" }, // Torrès, Sangre de Toro (Grenáche) (Red)
  "V9304": { recipe: "V9304", type: "beer" }, // Marqués de Cáceres Crianza, Spain
  "M9402": { recipe: "M9402", type: "beer" }, // Bailey
  "M9403": { recipe: "M9403", type: "beer" }, // Campari
  "M9405": { recipe: "M9405", type: "beer" }, // Cointrau
  "M9406": { recipe: "M9406", type: "beer" }, // Grand Marnier
  "M9407": { recipe: "M9407", type: "beer" }, // Kalua
  "M9408": { recipe: "M9408", type: "beer" }, // Malibu
  "M9409": { recipe: "M9409", type: "beer" }, // Martini Bianco
  "M9410": { recipe: "M9410", type: "beer" }, // Martini Dry
  "M9411": { recipe: "M9411", type: "beer" }, // Martini Rosso
  "M9413": { recipe: "M9413", type: "beer" }, // Porto
  "M9414": { recipe: "M9414", type: "beer" }, // Ricard
  "M9507": { recipe: "M9507", type: "beer" }, // Mens Vodka
  "M9508": { recipe: "M9508", type: "beer" }, // Lua moi 500ml
  "M9512": { recipe: "M9512", type: "beer" }, // Smirnoff Red Label
  "M9513": { recipe: "M9513", type: "beer" }, // Vodka Hanoi 300ml
  "M9514": { recipe: "M9514", type: "beer" }, // Vodka Hanoi 500ml
  "M9602": { recipe: "M9602", type: "beer" }, // Ballentines 12
  "M9603": { recipe: "M9603", type: "beer" }, // Ballentines 17
  "M9604": { recipe: "M9604", type: "beer" }, // Ballentines 21
  "M9606": { recipe: "M9606", type: "beer" }, // Ballentines Finese
  "M9609": { recipe: "M9609", type: "beer" }, // Chivas Regal 0.75L (12 years old)
  "M9611": { recipe: "M9611", type: "beer" }, // Creame de cassic
  "M9612": { recipe: "M9612", type: "beer" }, // Gordon Gin Bottle
  "M9620": { recipe: "M9620", type: "beer" }, // J - B
  "M9621": { recipe: "M9621", type: "beer" }, // Jack Daniel
  "M9623": { recipe: "M9623", type: "beer" }, // Jimbeam
  "M9629": { recipe: "M9629", type: "beer" }, // Johnny Walker red label
  "M9632": { recipe: "M9632", type: "beer" }, // Marcallan 12 year old
  "M9636": { recipe: "M9636", type: "beer" }, // Single Barrel Jack Daniel's
  "M9642": { recipe: "M9642", type: "beer" }, // GlenAllaChie 11
  "M9643": { recipe: "M9643", type: "beer" }, // FinLaggan 58
  "M9644": { recipe: "M9644", type: "beer" }, // Liqueur Bols Cherry Brandy 70cl
  "M9645": { recipe: "M9645", type: "beer" }, // Liqueur D.O.M Benedictine 70cl
  "M9702": { recipe: "M9702", type: "beer" }, // Bacardi Light
  "M9705": { recipe: "M9705", type: "beer" }, // Tequila light
  "M9801": { recipe: "M9801", type: "beer" }, // Creme de cassic (Triple Sec)
  "M9802": { recipe: "M9802", type: "beer" }, // Chabot Napoleon Special Reserve Armagnac
  "M98021": { recipe: "M98021", type: "beer" }, // Armagnac bottle
  "M9803": { recipe: "M9803", type: "beer" }, // Framboise
  "M9804": { recipe: "M9804", type: "beer" }, // Mirabelle (Massenez Wild Raspberry)
  "M9805": { recipe: "M9805", type: "beer" }, // Massenez Poire Williams
  "M9806": { recipe: "M9806", type: "beer" }, // Parisiennes Napoleon X.O 70cl
  "M9808": { recipe: "M9808", type: "beer" }, // Hennessy VSOP 0.7 liter
  "M9809": { recipe: "M9809", type: "beer" }, // Hennessy XO
  "M9812": { recipe: "M9812", type: "beer" }, // Remy Martin VSOP
  "V3002": { recipe: "V3002", type: "beer" }, // Baron Philippe de Rothschild, Mouton Cadet Réserve, Sauternes Half Bottle, France
  "V3003": { recipe: "V3003", type: "beer" }, // Baron Philippe de Rothschild, Mouton Cadet Réserve, Sauternes full  Bottle, France
  "S1003": { recipe: "S1003", type: "beer" }, // Grenadine (Siro Lựu)
  "S1004": { recipe: "S1004", type: "beer" }, // Syrup - Pineapple 70cl
  "V5004": { recipe: "V5004", type: "beer" }, // Les Hauts de La Gaffeliere, Bordeaux Blanc
  "V5008": { recipe: "V5008", type: "beer" }, // Gustave Lorentz Riesling
  "V5027": { recipe: "V5027", type: "beer" }, // Chantecaille Bordeaux AOC White
  "V5028": { recipe: "V5028", type: "beer" }, // F. Thienpont Sauvignon Blanc - White
  "V5029": { recipe: "V5029", type: "beer" }, // Ronan By Clinet (by Chateau Clinet, Pomerol) Bordauex Blanc - White
  "V5030": { recipe: "V5030", type: "beer" }, // Nicolas Thienpont, Chateau Puygueraud,  Francs Cotes de Bordeaux -White
  "V5032": { recipe: "V5032", type: "beer" }, // Louis Latour Chablis La Chanfleure, Chardonnay  - White
  "V5033": { recipe: "V5033", type: "beer" }, // Louis Latour Pouilly-Fuissé - White
  "V5034": { recipe: "V5034", type: "beer" }, // Dufouleur Monopole White wine Bt
  "V5037": { recipe: "V5037", type: "beer" }, // PASCAL JOLIVET ATTITUDE (Sauvignon Blanc) Loire Valley
  "V5038": { recipe: "V5038", type: "beer" }, // Château Baratet, Sauvignon Blanc, France
  "V5039": { recipe: "V5039", type: "beer" }, // Grand Bateau Bordeaux Blanc (by Beychevelle)
  "V5040": { recipe: "V5040", type: "beer" }, // M. Chapoutier « Belleruche » Côtes du Rhône Blanc, Grenache Blanc • Clairette
  "V5041": { recipe: "V5041", type: "beer" }, // Bernard Magrez « Le Prélat » Blanc Côtes du Rhône Villages Laudun
  "V5042": { recipe: "V5042", type: "beer" }, // M.Chapoutier Domaine des Granges de Mirabel
  "V5043": { recipe: "V5043", type: "beer" }, // Gustave Lorentz Gewurztraminer
  "NLP004": { recipe: "NLP004", type: "beer" }, // Trà olong  Tam Châu 100g
  "NLP3016": { recipe: "NLP3016", type: "beer" }, // Sữa tươi Vinamilk 1L
  "NLP3021": { recipe: "NLP3021", type: "beer" }, // Sữa tươi TH True Milk Nguyên chất 1L
  "NLP30251": { recipe: "NLP30251", type: "beer" }, // Đường nước Hàn Quốc
  "NLP60031": { recipe: "NLP60031", type: "beer" }, // Bưởi Năm roi
  "NLP60032": { recipe: "NLP60032", type: "beer" }, // Chanh
  "NLP60033": { recipe: "NLP60033", type: "beer" }, // Cam
  "NLP60034": { recipe: "NLP60034", type: "beer" }, // Xoài
  "NLP60035": { recipe: "NLP60035", type: "beer" }, // Dưa hấu
  "NLP600351": { recipe: "NLP600351", type: "beer" }, // Chè mạn
  "NLP60038": { recipe: "NLP60038", type: "beer" }, // Chanh leo
  "NLP60041": { recipe: "NLP60041", type: "beer" }, // Dứa quả
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
  "M7001": { recipe: "NLP60033", type: "beer" }, // Fresh orange juice -> Cam
  "M7003": { recipe: "NLP60035", type: "beer" }, // Mixed juice -> Dưa hấu
  "M7008": { recipe: "NLP60031", type: "beer" }, // Pomelo Juice -> Bưởi
  "M7009": { recipe: "NLP60041", type: "beer" }, // Pineapple Juice -> Dứa
  "M7006": { recipe: "NLP60034", type: "beer" }, // Mango Juice -> Xoài
  "M7031": { recipe: "NLP60034", type: "beer" }, // Mango Mojito -> Xoài
  "M7012": { recipe: "M9705", type: "beer" }, // Margarita -> Tequila
  "M7015": { recipe: "M9612", type: "beer" }, // Singapore Sling -> Gin
  "M7018": { recipe: "M9512", type: "beer" }, // Black Russian -> Vodka
  "M7014": { recipe: "M9512", type: "beer" }, // Long Island -> Vodka
  "M8001": { recipe: "M9612", type: "beer" }, // Gin and Tonic -> Gin
  "M8002": { recipe: "M9629", type: "beer" }, // Whisky & soda -> JW Red
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
