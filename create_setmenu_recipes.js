/**
 * SET MENU & INDIVIDUAL DISH RECIPES - FINE DINING STANDARD
 * Maison Vie - Supabase Production
 * 
 * Nguồn: MENU VIẾT TẮT 2026.xlsx + định mức fine dining chuẩn
 * 
 * Mỗi "1 portion" của Set Menu = 1 cover (1 khách)
 * Các nguyên liệu được tính theo định mức F&B chuẩn nhà hàng Pháp
 */
const { Client } = require('pg');
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';
const connectionString = 'postgres://postgres.vtbrohaccikrhgcpjvec:1972Urmylove%40@aws-1-ap-northeast-1.pooler.supabase.com:6543/postgres?sslmode=require';

async function main() {
  const client = new Client({ connectionString, ssl: { rejectUnauthorized: false } });
  await client.connect();
  console.log('✅ Connected!\n');

  // ============================================================
  // Build ingredient UUID map from codes
  // ============================================================
  const ingRows = await client.query("SELECT id, code, stock_uom FROM ingredients");
  const ING = {}; // code -> { id, uom }
  ingRows.rows.forEach(r => { ING[r.code] = { id: r.id, uom: r.stock_uom }; });
  console.log(`Loaded ${Object.keys(ING).length} ingredient codes\n`);

  // Quick helper: get id or null
  const id = (code) => ING[code]?.id || null;

  // ============================================================
  // FINE DINING INGREDIENT REFERENCE
  // (Mã nguyên liệu đã xác nhận tồn tại trong DB)
  // ============================================================
  // Dairy & Sauce Base
  const BUTTER    = 'NLP3008';   // Anchor butter - KG
  const CREAM     = 'NLP3015';   // Whipping cream Tatua 1L - BOX
  const MILK      = 'NLP3016';   // Fresh milk - BOX
  const EGG       = 'NLP2021';   // Egg - PIECE
  const DEMI      = 'NLP5001';   // Demi glace Knorr - BOX
  const REDWINE   = 'NLP5004';   // Dalat Red Wine 3L - CAN
  const WHITEWINE = 'NLP5005';   // Dalat White Wine 3L - CAN
  const SUGAR     = 'NLP3019';   // Sugar - KG
  const MISO      = 'NLP5061';   // Miso paste - KG
  const SAKE      = 'NLP5042';   // Sake cooking - L
  const MIRIN     = 'NLP5041';   // Mirin - L
  // Vegetables
  const CARROT    = 'NLP60057';  // Carrot tươi - KG
  const POTATO    = 'NLP60054';  // Khoai tây - KG
  const MUSHROOM  = 'NLP5024';   // Nấm rừng khô - G
  const ARTICHOKE = 'NLP50182';  // Atiso đông lạnh - KG
  const TOMATO    = 'NLP5033';   // Whole peeled tomato - BOX
  // Fruits / Dessert
  const CHOC_DARK = 'NLP4002';   // Dark chocolate - KG
  const CHOC_WH   = 'NLP4001';   // White chocolate - KG
  const STRAW     = 'NLP60039';  // Dâu tây - KG
  const MANGO     = 'NLP60034';  // Xoài - KG
  const APPLE     = 'NLP60037';  // Táo - KG
  const PASSIFR   = 'NLP60038';  // Chanh leo - KG
  const AVOCADO   = 'NLP60040';  // Bơ sáp - KG
  const PINEAPPLE = 'NLP60041';  // Dứa - PIECE
  // Proteins (Fine dining grade)
  const FOIE      = 'NLP2011';   // Foie gras frozen - KG
  const PARMA     = 'NLP20021';  // Parma ham - KG
  const SMOKECHX  = 'NLP2014';   // Smoked chicken breast - KG
  // Kitchen proteins (NVLC series - exist from stock & purchase evidence)
  const BEEF_TDL  = 'NVLC10011'; // Beef tenderloin - KG
  const BEEF_RIB  = 'NVLC10025'; // Ribeye Angus - KG
  const PORK      = 'NVLC3001';  // Pork (shoulder/loin) - KG
  const LAMB      = 'NVLC2001';  // Lamb - KG
  const SALMON    = 'NVLC5001';  // Salmon fillet - KG
  const SEABASS   = 'NVLC5005';  // Seabass / White fish - KG
  const BLACKCOD  = 'NVLC5020';  // Black cod / Premium fish - KG
  const SCALLOP   = 'NVLC60021'; // Scallops - KG
  const PRAWN     = 'NVLC6020';  // Prawn - KG
  const ESCARGOT  = 'NVLC6030';  // Escargots Bourguignon - KG
  const CHICKEN   = 'NVLC4010';  // Chicken breast/leg - KG
  const CHICKEN2  = 'NVLC4011';  // Chicken variant - KG

  // ============================================================
  // RECIPE BUILDER
  // Each entry: [ingredient_code, qty, uom_override_or_null]
  // qty is per 1 cover (1 person / 1 portion of the dish)
  // ============================================================

  /**
   * 3-COURSE SET MENU STANDARD (Soup → Main → Dessert)
   * Fine dining standard per cover for a 3-course menu
   */
  const base3Course = [
    // Sauce & dairy across all courses
    [BUTTER,  0.030, 'KG'],   // Butter: sauce, soup, sautéing — 30g/cover
    [CREAM,   0.080, 'BOX'],  // Cream: soup + sauce — 80ml/cover
    [EGG,     2,     'PIECE'],// Eggs: dessert (crêpes/mousse) — 2pcs
    [SUGAR,   0.030, 'KG'],   // Sugar: dessert — 30g
    [DEMI,    0.050, 'BOX'],  // Demi glace: meat sauce — 50ml equiv
    [CHOC_DARK, 0.030, 'KG'],// Chocolate: dessert — 30g
  ];

  /**
   * 4-COURSE SET MENU adds STARTER course
   */
  const extra4thCourse = [
    [BUTTER,  0.010, 'KG'],  // Extra butter for starter
    [CREAM,   0.020, 'BOX'], // Extra cream for starter sauce
    [EGG,     1,     'PIECE'],// Extra egg for pâté/mousse starter
  ];

  /**
   * 5-6 COURSE SET MENU adds both starter AND fish course
   */
  const extra5thCourse = [
    [BUTTER,  0.015, 'KG'],  // Extra butter for fish course
    [WHITEWINE, 0.020, 'CAN'], // White wine for fish sauce — 60ml
    [CREAM,   0.020, 'BOX'], // Extra cream for fish sauce
  ];

  // ============================================================
  // COMPLETE RECIPE DEFINITIONS
  // Format: { menu_item_id: [[code, qty, uom], ...] }
  // ============================================================
  const recipeMap = {

    // ============================================================
    // 3-COURSE SET MENUS (350 range → 380 new price)
    // Soup → Main → Dessert
    // ============================================================

    'R6131': [ // Set Menu 350A: Vegetable soup | Pork Genevoise | Crêpes dessert
      ...base3Course,
      [PORK,    0.160, 'KG'],  // Pork Genevoise - main: 160g/cover
      [CARROT,  0.050, 'KG'],  // Carrot garnish + soup — 50g
      [POTATO,  0.100, 'KG'],  // Potato garnish — 100g
      [REDWINE, 0.033, 'CAN'], // Red wine for Genevoise braising — ~100ml
    ],

    'R6132': [ // Set Menu 350B: Pumpkin soup | Fish (Basa/Seabass) | Crêpes
      ...base3Course,
      [SEABASS, 0.150, 'KG'],  // Seabass fillet - main: 150g/cover
      [CARROT,  0.040, 'KG'],  // Carrot garnish — 40g
      [WHITEWINE, 0.017, 'CAN'], // White wine for fish sauce — 50ml
    ],

    'R6133': [ // Set Menu 350C: Potato soup | Chicken Roulade | Dessert
      ...base3Course,
      [CHICKEN, 0.160, 'KG'],  // Chicken roulade - main: 160g/cover
      [POTATO,  0.120, 'KG'],  // Potato: soup (100g) + garnish (20g) — 120g
      [MUSHROOM, 8,    'G'],   // Mushroom for sauce — 8g
    ],

    // ============================================================
    // 4-COURSE SET MENUS (430 range → 500 new price)
    // Starter → Soup → Main → Dessert
    // ============================================================

    'R6134': [ // Set Menu 430A: Chicken-Veg Pâté | Pumpkin soup | Fish/Chicken | Dessert
      ...base3Course, ...extra4thCourse,
      [SMOKECHX, 0.040, 'KG'], // Smoked chicken for pâté starter — 40g
      [CHICKEN,  0.160, 'KG'], // Chicken main — 160g
      [CARROT,   0.040, 'KG'], // Vegetable soup + garnish — 40g
      [POTATO,   0.060, 'KG'], // Potato garnish — 60g
    ],

    'R6135': [ // Set Menu 430B: Croquettes | Carrot soup | Chicken | Dessert
      ...base3Course, ...extra4thCourse,
      [CHICKEN,  0.160, 'KG'], // Chicken main — 160g
      [CARROT,   0.080, 'KG'], // Carrot soup (60g) + croquette filling (20g) — 80g
      [POTATO,   0.060, 'KG'], // Croquette base — 60g
      [MUSHROOM, 6,     'G'],  // Mushroom garnish — 6g
    ],

    'R6154': [ // Set Menu 430C: Mimosa | Pumpkin soup | Chicken/Fish | Dessert
      ...base3Course, ...extra4thCourse,
      [CHICKEN,  0.150, 'KG'], // Chicken main — 150g
      [CARROT,   0.030, 'KG'], // Garnish — 30g
      [POTATO,   0.060, 'KG'], // Potato garnish — 60g
      [EGG,      1,     'PIECE'], // Mimosa starter (extra egg) — 1pc
    ],

    'R6193': [ // Set Menu 500A (was old 430A upgraded): Chicken-Veg Pâté | Pumpkin | Main | Dessert
      ...base3Course, ...extra4thCourse,
      [SMOKECHX, 0.040, 'KG'], // Smoked chicken pâté — 40g
      [CHICKEN,  0.160, 'KG'], // Chicken main — 160g
      [CARROT,   0.040, 'KG'], // Vegetable garnish — 40g
      [POTATO,   0.060, 'KG'], // Potato garnish — 60g
    ],

    'R6194': [ // Set Menu 450B (similar 4-course)
      ...base3Course, ...extra4thCourse,
      [SEABASS,  0.150, 'KG'], // Fish main — 150g
      [CARROT,   0.050, 'KG'], // Carrot garnish — 50g
      [POTATO,   0.080, 'KG'], // Potato garnish — 80g
    ],

    'R6136': [ // Set Menu 550A: Mimosa | Potato | Seabass | Dessert
      ...base3Course, ...extra4thCourse,
      [SEABASS,  0.160, 'KG'], // Seabass main — 160g
      [POTATO,   0.100, 'KG'], // Potato soup + garnish — 100g
      [WHITEWINE, 0.020, 'CAN'], // White wine fish sauce — 60ml
      [EGG,      1,     'PIECE'], // Mimosa (extra) — 1pc
    ],

    'R6137': [ // Set Menu 550B: Mimosa | Potato | Seabass | Dessert (variant B)
      ...base3Course, ...extra4thCourse,
      [SEABASS,  0.160, 'KG'], // Seabass main — 160g
      [POTATO,   0.100, 'KG'], // Potato soup — 100g
      [MUSHROOM, 8,     'G'],  // Mushroom garnish — 8g
      [EGG,      1,     'PIECE'], // Mimosa — 1pc
    ],

    // ============================================================
    // 5-6 COURSE SET MENUS (710 range → 850 new)
    // Starter → Soup → Fish → Meat → Dessert
    // ============================================================

    'R6153': [ // Set Menu 710C: Salmon & Potato | Onion soup | Seabass | Beef/Duck | Dessert
      ...base3Course, ...extra4thCourse, ...extra5thCourse,
      [SALMON,   0.060, 'KG'], // Smoked salmon starter — 60g
      [SEABASS,  0.120, 'KG'], // Seabass fish course — 120g (slightly reduced for 5-course)
      [BEEF_TDL, 0.160, 'KG'], // Beef tenderloin main — 160g
      [POTATO,   0.100, 'KG'], // Potato: starter (40g) + garnish (60g) — 100g
      [CARROT,   0.030, 'KG'], // Onion soup + garnish — 30g
      [REDWINE,  0.033, 'CAN'], // Beef sauce red wine — ~100ml
      [DEMI,     0.010, 'BOX'], // Extra demi glace — extra 10ml
    ],

    'R6138': [ // Set Menu 710A: Duck Pâté | Onion | Seabass | Beef | Dessert
      ...base3Course, ...extra4thCourse, ...extra5thCourse,
      [SEABASS,  0.120, 'KG'], // Fish course — 120g
      [BEEF_TDL, 0.160, 'KG'], // Beef main — 160g
      [POTATO,   0.080, 'KG'], // Garnish — 80g
      [CARROT,   0.030, 'KG'], // Garnish — 30g
      [REDWINE,  0.033, 'CAN'], // Beef sauce — 100ml
    ],

    // ============================================================
    // 6-7 COURSE (950 range → Degustation)
    // Amuse → Starter → Soup → Fish → Meat → Cheese/Sorbet → Dessert
    // ============================================================

    'R61401': [ // Set Menu 950 (old 840-Op1): Duck Rillettes | Pumpkin | Fish | Beef | Dessert
      ...base3Course, ...extra4thCourse, ...extra5thCourse,
      [SALMON,   0.070, 'KG'], // Salmon/duck pâté starter — 70g equiv fish
      [SEABASS,  0.130, 'KG'], // Fish main — 130g
      [BEEF_TDL, 0.160, 'KG'], // Beef tenderloin main — 160g
      [POTATO,   0.090, 'KG'], // Potato garnish — 90g
      [CARROT,   0.040, 'KG'], // Vegetable — 40g
      [REDWINE,  0.040, 'CAN'], // Red wine sauce — 120ml
      [MUSHROOM, 12,    'G'],  // Mushroom for sauce — 12g
      [CHOC_DARK, 0.010, 'KG'], // Extra chocolate dessert — 10g
    ],

    'R614011': [ // Set Menu 1050 (new 1200A): Escargots | Leek & Potato | Fish | Beef Wgyu | Dessert
      ...base3Course, ...extra4thCourse, ...extra5thCourse,
      [ESCARGOT, 0.050, 'KG'], // Escargots starter — 50g (6-8 pieces)
      [SEABASS,  0.130, 'KG'], // Fish course — 130g
      [BEEF_RIB, 0.180, 'KG'], // Ribeye Angus main — 180g (premium)
      [POTATO,   0.100, 'KG'], // Potato: leek&potato soup + garnish — 100g
      [CARROT,   0.040, 'KG'], // Vegetable — 40g
      [REDWINE,  0.040, 'CAN'], // Wine sauce — 120ml
      [MUSHROOM, 15,    'G'],  // Mushroom truffle sauce — 15g
      [FOIE,     0.030, 'KG'], // Small foie gras garnish (premium) — 30g
    ],

    'R6140': [ // Set Menu 940 (old 940A): Smoked Salmon | Sea Snail | Seabass | Beef | Dessert
      ...base3Course, ...extra4thCourse, ...extra5thCourse,
      [SALMON,   0.060, 'KG'], // Smoked salmon starter — 60g
      [SEABASS,  0.140, 'KG'], // Fish course — 140g
      [BEEF_TDL, 0.180, 'KG'], // Beef main — 180g
      [PRAWN,    0.050, 'KG'], // Seafood garnish — 50g
      [POTATO,   0.080, 'KG'], // Potato garnish — 80g
      [REDWINE,  0.040, 'CAN'], // Wine sauce — 120ml
      [MUSHROOM, 12,    'G'],  // Mushroom — 12g
    ],

    // ============================================================
    // FOUR-COURSE NAMED MENUS
    // ============================================================

    'R6191': [ // Set Menu Four Courses D: Croquettes | Carrot | Fish | Dessert
      ...base3Course, ...extra4thCourse,
      [SEABASS,  0.150, 'KG'], // Seabass main — 150g
      [CARROT,   0.060, 'KG'], // Carrot soup + croquette — 60g
      [POTATO,   0.070, 'KG'], // Croquette base — 70g
    ],

    'R6192': [ // Set Menu Four Courses E: Mimosa | Pumpkin | Fish/Chicken | Dessert
      ...base3Course, ...extra4thCourse,
      [CHICKEN,  0.150, 'KG'], // Chicken main — 150g
      [CARROT,   0.040, 'KG'], // Garnish — 40g
      [POTATO,   0.060, 'KG'], // Garnish — 60g
      [EGG,      1,     'PIECE'], // Mimosa extra — 1pc
    ],

    'R6231': [ // Set Menu Four Courses F (from file: Mimosa|Pumpkin|Fish/Chicken|Dessert variant)
      ...base3Course, ...extra4thCourse,
      [SEABASS,  0.150, 'KG'], // Fish main — 150g
      [CARROT,   0.040, 'KG'], // Garnish — 40g
      [POTATO,   0.070, 'KG'], // Garnish — 70g
    ],

    'R6188': [ // Set Menu Four Courses A
      ...base3Course, ...extra4thCourse,
      [CHICKEN,  0.160, 'KG'], // Chicken main — 160g
      [CARROT,   0.050, 'KG'], // Soup + garnish — 50g
      [POTATO,   0.080, 'KG'], // Garnish — 80g
    ],

    'R6190': [ // Set Menu Four Courses C
      ...base3Course, ...extra4thCourse,
      [SEABASS,  0.150, 'KG'], // Fish main — 150g
      [CARROT,   0.040, 'KG'], // Garnish — 40g
      [POTATO,   0.070, 'KG'], // Garnish — 70g
    ],

    // ============================================================
    // 370-470 Range (NEW 2026 MENUS)
    // ============================================================

    'R6260001': [ // Set Menu 370A: Pumpkin | Basa/Pork | Dessert (3-course at 370)
      ...base3Course,
      [SEABASS,  0.140, 'KG'], // Fish/Basa main — 140g
      [CARROT,   0.040, 'KG'], // Garnish — 40g
      [POTATO,   0.080, 'KG'], // Garnish — 80g
    ],

    'R6260003': [ // Set Menu 370C: Potato | Chicken Roulade | Dessert
      ...base3Course,
      [CHICKEN,  0.155, 'KG'], // Chicken roulade — 155g
      [POTATO,   0.110, 'KG'], // Potato soup + garnish — 110g
    ],

    'R6260004': [ // Set Menu 470A: Shrimp Croquettes | Mushroom | Main | Dessert (4-course)
      ...base3Course, ...extra4thCourse,
      [PRAWN,    0.060, 'KG'], // Shrimp croquettes starter — 60g
      [CHICKEN,  0.150, 'KG'], // Main — 150g
      [MUSHROOM, 10,    'G'],  // Mushroom — 10g
      [CARROT,   0.040, 'KG'], // Garnish — 40g
    ],

    'R6260005': [ // Set Menu 470B: Croquettes | Carrot | Fish | Dessert
      ...base3Course, ...extra4thCourse,
      [SEABASS,  0.150, 'KG'], // Fish main — 150g
      [CARROT,   0.070, 'KG'], // Carrot soup + croquette — 70g
      [POTATO,   0.060, 'KG'], // Croquette base — 60g
    ],

    'R6260007': [ // Set Menu 600A: Mimosa | Potato | Seabass | Dessert (4-course)
      ...base3Course, ...extra4thCourse,
      [SEABASS,  0.160, 'KG'], // Seabass main — 160g
      [POTATO,   0.110, 'KG'], // Potato soup — 110g
      [EGG,      1,     'PIECE'], // Mimosa — 1pc
      [WHITEWINE, 0.020, 'CAN'], // Fish sauce — 60ml
    ],

    'R6260010': [ // Set Menu 770B: Mimosa | Potato | Seabass | Dessert (5-course)
      ...base3Course, ...extra4thCourse, ...extra5thCourse,
      [SALMON,   0.050, 'KG'], // Salmon starter — 50g
      [SEABASS,  0.130, 'KG'], // Seabass course — 130g
      [POTATO,   0.100, 'KG'], // Potato — 100g
      [EGG,      1,     'PIECE'], // Mimosa — 1pc
    ],

    'R6260012': [ // Set Menu 1200 (Degustation 7 courses)
      ...base3Course, ...extra4thCourse, ...extra5thCourse,
      [FOIE,     0.050, 'KG'], // Foie gras starter — 50g (PREMIUM)
      [SALMON,   0.060, 'KG'], // Salmon course — 60g
      [SCALLOP,  0.060, 'KG'], // Scallop course — 60g
      [SEABASS,  0.120, 'KG'], // Fish course — 120g
      [BEEF_RIB, 0.170, 'KG'], // Ribeye Angus main — 170g
      [POTATO,   0.090, 'KG'], // Garnish — 90g
      [CARROT,   0.030, 'KG'], // Garnish — 30g
      [REDWINE,  0.040, 'CAN'], // Wine sauce — 120ml
      [MUSHROOM, 15,    'G'],  // Mushroom — 15g
      [CHOC_DARK, 0.010, 'KG'], // Extra dessert — 10g
      [FOIE,     0.010, 'KG'], // Terrine garnish — 10g
    ],

    'R61501': [ // Set Menu 720E (similar to 710 range)
      ...base3Course, ...extra4thCourse, ...extra5thCourse,
      [SALMON,   0.060, 'KG'], // Salmon starter — 60g
      [SEABASS,  0.130, 'KG'], // Fish course — 130g
      [BEEF_TDL, 0.160, 'KG'], // Beef main — 160g
      [POTATO,   0.090, 'KG'], // Garnish — 90g
      [REDWINE,  0.033, 'CAN'], // Wine sauce — 100ml
    ],

    'R6196': [ // Set Menu 550C: Beetroot | Mushroom | Duck | Dessert (4-course)
      ...base3Course, ...extra4thCourse,
      [CHICKEN,  0.155, 'KG'], // Duck/Chicken main — 155g
      [MUSHROOM, 12,    'G'],  // Mushroom bisque + sauce — 12g
      [CARROT,   0.040, 'KG'], // Garnish — 40g
      [REDWINE,  0.020, 'CAN'], // Duck sauce — 60ml
    ],

    'R6167': [ // Set Menu Two Courses 2+4
      [BUTTER,   0.020, 'KG'], [CREAM, 0.060, 'BOX'], [EGG, 1, 'PIECE'],
      [CHICKEN,  0.150, 'KG'], // Main — 150g
      [POTATO,   0.080, 'KG'], // Garnish — 80g
    ],

    // ============================================================
    // DEGUSTATION MENUS (4-7 courses)
    // ============================================================

    'R6208': [ // Degustation 4-7 Courses #1
      ...base3Course, ...extra4thCourse, ...extra5thCourse,
      [FOIE,     0.050, 'KG'], // Foie gras — 50g
      [SEABASS,  0.120, 'KG'], // Fish course — 120g
      [BEEF_TDL, 0.160, 'KG'], // Beef main — 160g
      [SALMON,   0.050, 'KG'], // Salmon starter — 50g
      [POTATO,   0.090, 'KG'], // Garnish — 90g
      [REDWINE,  0.040, 'CAN'], // Wine sauce
      [MUSHROOM, 12,    'G'],  // Mushroom — 12g
    ],

    'R6209': [ // Degustation 4-7 Courses #2
      ...base3Course, ...extra4thCourse, ...extra5thCourse,
      [SCALLOP,  0.070, 'KG'], // Scallop course — 70g
      [SEABASS,  0.120, 'KG'], // Fish course — 120g
      [BEEF_TDL, 0.160, 'KG'], // Beef main — 160g
      [POTATO,   0.090, 'KG'], // Garnish — 90g
      [WHITEWINE, 0.020, 'CAN'], // Fish sauce — 60ml
      [REDWINE,  0.030, 'CAN'], // Beef sauce — 90ml
    ],

    'R6211': [ // Degustation 4-7 Courses #4
      ...base3Course, ...extra4thCourse, ...extra5thCourse,
      [FOIE,     0.040, 'KG'], // Foie gras — 40g
      [SALMON,   0.060, 'KG'], // Salmon — 60g
      [SEABASS,  0.120, 'KG'], // Seabass — 120g
      [BEEF_TDL, 0.160, 'KG'], // Beef — 160g
      [POTATO,   0.090, 'KG'], // Garnish — 90g
      [REDWINE,  0.040, 'CAN'], // Wine sauce
    ],

    'R6217': [ // Degustation 4-7 Courses #10
      ...base3Course, ...extra4thCourse, ...extra5thCourse,
      [FOIE,     0.050, 'KG'], // Foie gras — 50g
      [SCALLOP,  0.060, 'KG'], // Scallop — 60g
      [SEABASS,  0.120, 'KG'], // Fish — 120g
      [BEEF_RIB, 0.170, 'KG'], // Premium beef — 170g
      [POTATO,   0.090, 'KG'], // Garnish — 90g
      [REDWINE,  0.040, 'CAN'], // Wine sauce
      [MUSHROOM, 12,    'G'],  // Mushroom — 12g
    ],

    // ============================================================
    // INDIVIDUAL DISHES (món lẻ chưa có công thức)
    // ============================================================

    'R1008': [ // French Onion Soup / Soupe à l'Oignon
      [BUTTER,  0.025, 'KG'],  // Butter for caramelizing — 25g
      [CREAM,   0.030, 'BOX'], // Cream garnish — 30ml
      [CARROT,  0.020, 'KG'],  // Vegetable stock — 20g
    ],

    'R1013': [ // Mixed Garden Salad / Salade Mixte
      [CARROT,  0.040, 'KG'],  // Carrot julienne — 40g
      [AVOCADO, 0.040, 'KG'],  // Avocado — 40g
      [TOMATO,  0.020, 'BOX'], // Tomato — equiv 40g
    ],

    'R1024': [ // Mushroom Soup / Soupe aux Champignons
      [BUTTER,  0.020, 'KG'],  // Butter — 20g
      [CREAM,   0.080, 'BOX'], // Cream — 80ml
      [MUSHROOM, 20,   'G'],   // Dried mushroom — 20g (reconstitutes to ~80g)
    ],

    'R1025': [ // Burgundy Snails / Escargots Bourguignon
      [ESCARGOT, 0.060, 'KG'], // Escargots — 60g (6-8 snails)
      [BUTTER,   0.035, 'KG'], // Garlic butter — 35g
      [CREAM,    0.020, 'BOX'], // Cream — 20ml
    ],

    'R1107': [ // Assorted Ham, Salami & Terrine Mustard Dijon
      [PARMA,   0.040, 'KG'],  // Parma ham — 40g
    ],

    'R1108': [ // Foie Gras Salad with Quail Egg & Serrano Ham
      [FOIE,    0.060, 'KG'],  // Foie gras — 60g
      [PARMA,   0.025, 'KG'],  // Serrano/Parma ham — 25g
      [EGG,     2,     'PIECE'], // Quail egg equiv — 2 pcs
    ],

    'R1111': [ // Garden Vegetables (Légumes du Jardin)
      [CARROT,  0.060, 'KG'],  // Carrot — 60g
      [POTATO,  0.080, 'KG'],  // Potato — 80g
      [BUTTER,  0.015, 'KG'],  // Butter for cooking — 15g
      [CREAM,   0.020, 'BOX'], // Cream sauce — 20ml
    ],

    'R1121': [ // Tuna Carpaccio with Quail Egg & Caviar
      [EGG,     2,     'PIECE'], // Quail egg equiv — 2pcs
      [CREAM,   0.020, 'BOX'], // Cream sauce — 20ml
    ],

    'R1122': [ // Pan-seared Foie Gras with Calvados & Brioche
      [FOIE,    0.080, 'KG'],  // Foie gras — 80g (generous portion, premium)
      [APPLE,   0.060, 'KG'],  // Apple for Calvados sauce — 60g
      [SUGAR,   0.015, 'KG'],  // Caramelized sugar — 15g
      [BUTTER,  0.020, 'KG'],  // Butter — 20g
    ],

    'R2141': [ // Vietnamese Buffalo Fillet with Pink Peppercorn
      [BEEF_TDL, 0.180, 'KG'], // Buffalo/beef fillet — 180g
      [BUTTER,   0.020, 'KG'], // Butter — 20g
      [DEMI,     0.060, 'BOX'], // Demi glace sauce — 60ml
      [CREAM,    0.040, 'BOX'], // Peppercorn cream sauce — 40ml
    ],

    'R2142': [ // Wagyu Ribeye with Truffle Mushroom Sauce
      [BEEF_RIB, 0.200, 'KG'], // Wagyu ribeye — 200g (premium cut)
      [MUSHROOM, 15,    'G'],  // Truffle mushroom — 15g
      [BUTTER,   0.025, 'KG'], // Butter — 25g
      [DEMI,     0.060, 'BOX'], // Demi glace — 60ml
      [CREAM,    0.040, 'BOX'], // Cream sauce — 40ml
    ],

    'R2143': [ // AUS Beef Tenderloin with Green Peppercorn Sauce
      [BEEF_TDL, 0.180, 'KG'], // Beef tenderloin — 180g
      [BUTTER,   0.020, 'KG'], // Butter — 20g
      [DEMI,     0.060, 'BOX'], // Demi glace — 60ml
      [CREAM,    0.040, 'BOX'], // Cream sauce — 40ml
    ],

    'R2144': [ // Black Angus Ribeye with Béarnaise Sauce
      [BEEF_RIB, 0.200, 'KG'], // Ribeye Angus — 200g
      [BUTTER,   0.025, 'KG'], // Butter for béarnaise — 25g
      [EGG,      2,     'PIECE'], // Egg yolks for béarnaise — 2 pcs
      [CARROT,   0.030, 'KG'], // Vegetable garnish — 30g
      [POTATO,   0.080, 'KG'], // Potato garnish — 80g
    ],

    'R2145': [ // Beef Wellington with Madeira Sauce
      [BEEF_TDL, 0.180, 'KG'], // Beef tenderloin centre-cut — 180g
      [MUSHROOM, 20,    'G'],  // Duxelles mushroom — 20g
      [FOIE,     0.030, 'KG'], // Foie gras in Wellington — 30g
      [DEMI,     0.070, 'BOX'], // Madeira/Demi glace — 70ml
      [BUTTER,   0.020, 'KG'], // Butter — 20g
    ],

    'R2148': [ // Seared French Duck Breast with Blackberry Sauce
      [CHOC_DARK, 0.020, 'KG'], // Dark chocolate in berry sauce — 20g
      [BUTTER,    0.020, 'KG'], // Butter — 20g
      [REDWINE,   0.020, 'CAN'], // Red wine sauce — 60ml
      [DEMI,      0.060, 'BOX'], // Demi glace — 60ml
      [POTATO,    0.080, 'KG'], // Potato garnish — 80g
    ],

    'R2149': [ // Herb-crusted AUS Lamb Rack with Organic Extras
      [LAMB,     0.200, 'KG'], // Lamb rack — 200g (3-4 bones)
      [BUTTER,   0.025, 'KG'], // Herb butter crust — 25g
      [DEMI,     0.060, 'BOX'], // Demi glace — 60ml
      [REDWINE,  0.020, 'CAN'], // Red wine jus — 60ml
      [POTATO,   0.080, 'KG'], // Potato gratin — 80g
      [CARROT,   0.040, 'KG'], // Vegetable — 40g
    ],

    'R3116': [ // Ốc Bulot Vùng Burgundy Pháp
      [ESCARGOT, 0.060, 'KG'], // Sea snails / Bulot — 60g (same stock as escargots)
      [BUTTER,   0.035, 'KG'], // Garlic butter — 35g
      [CREAM,    0.015, 'BOX'], // Cream — 15ml
    ],

    'R3125': [ // Seared Japanese Scallops with Beurre Blanc
      [SCALLOP,  0.080, 'KG'], // Scallops — 80g (2-3 pieces)
      [BUTTER,   0.030, 'KG'], // Beurre blanc — 30g (butter-intensive sauce)
      [CREAM,    0.040, 'BOX'], // Cream — 40ml
      [WHITEWINE, 0.010, 'CAN'], // White wine — 30ml
    ],

    'R3127': [ // Miso-marinated Black Cod with Organic Asparagus
      [BLACKCOD,  0.150, 'KG'], // Black cod fillet — 150g (premium)
      [MISO,      0.030, 'KG'], // Miso paste marinade — 30g
      [SAKE,      0.020, 'L'],  // Sake — 20ml
      [MIRIN,     0.020, 'L'],  // Mirin — 20ml
      [SUGAR,     0.015, 'KG'], // Sugar for marinade — 15g
      [BUTTER,    0.015, 'KG'], // Butter — 15g
    ],

    'R5103': [ // Vanilla Crème Brûlée
      [CREAM,   0.120, 'BOX'], // Heavy cream — 120ml
      [EGG,     3,     'PIECE'], // Egg yolks — 3pcs
      [SUGAR,   0.030, 'KG'],  // Sugar — 30g
    ],

    'R5113': [ // Chocolate Mousse with Organic Dark Cocoa
      [CHOC_DARK, 0.060, 'KG'], // Dark chocolate 72% — 60g
      [CREAM,    0.080, 'BOX'], // Whipping cream — 80ml
      [EGG,      2,     'PIECE'], // Egg whites — 2pcs
      [SUGAR,    0.020, 'KG'],  // Sugar — 20g
    ],

    'R5114': [ // Grand Marnier Soufflé with Vanilla Ice Cream
      [EGG,     3,     'PIECE'], // Egg whites — 3pcs
      [SUGAR,   0.040, 'KG'],  // Sugar — 40g
      [CREAM,   0.060, 'BOX'], // Cream — 60ml
      [BUTTER,  0.020, 'KG'],  // Butter for ramekin — 20g
    ],

    'R5115': [ // Caramelized Apple Tart with Vanilla Ice Cream
      [APPLE,   0.120, 'KG'],  // Apple — 120g (tart filling)
      [SUGAR,   0.030, 'KG'],  // Caramelized sugar — 30g
      [BUTTER,  0.025, 'KG'],  // Pastry butter — 25g
      [CREAM,   0.060, 'BOX'], // Vanilla ice cream base — 60ml
    ],

    'R5117': [ // Selection of French Cheeses with Cinnamon Bread
      [CREAM,   0.020, 'BOX'], // Cream cheese accompaniment — 20ml
    ],

    'R5118': [ // Plate of Seasonal Fresh Fruits
      [MANGO,   0.080, 'KG'],  // Mango — 80g
      [STRAW,   0.050, 'KG'],  // Strawberry — 50g
      [PASSIFR, 0.030, 'KG'],  // Passion fruit — 30g
      [PINEAPPLE, 0.3,  'PIECE'], // Pineapple wedge — 1/3 pineapple
    ],

    // Rice dishes
    'R6081': [ // Roasted Pork with Steam Rice
      [PORK,    0.150, 'KG'],  // Pork — 150g
      [DEMI,    0.040, 'BOX'], // Demi glace — 40ml
      [CARROT,  0.030, 'KG'],  // Vegetable — 30g
    ],

    'R6082': [ // Pork Stew with Steam Rice
      [PORK,    0.150, 'KG'],  // Pork — 150g
      [TOMATO,  0.015, 'BOX'], // Tomato sauce — 15ml equiv
      [CARROT,  0.040, 'KG'],  // Carrot stew — 40g
      [POTATO,  0.050, 'KG'],  // Potato stew — 50g
    ],

    'R60811': [ // Pork Rib with Steam Rice
      [PORK,    0.180, 'KG'],  // Pork rib (with bone) — 180g
      [TOMATO,  0.015, 'BOX'], // Tomato sauce — 15ml
      [CARROT,  0.030, 'KG'],  // Vegetable — 30g
    ],

    'R60831': [ // Hải Nam Chicken Rice
      [CHICKEN, 0.160, 'KG'],  // Chicken — 160g
      [CREAM,   0.020, 'BOX'], // Chicken stock — 20ml
      [CARROT,  0.020, 'KG'],  // Vegetable — 20g
    ],

    'R8001': [ // Oven-baked Stuffed Eggplant with Lentils
      [TOMATO,  0.030, 'BOX'], // Tomato sauce — 30ml
      [BUTTER,  0.015, 'KG'],  // Butter — 15g
      [CREAM,   0.020, 'BOX'], // Cream — 20ml
    ],

    'R1020': [ // French Fries
      [POTATO,  0.150, 'KG'],  // Potato — 150g
    ],

    'SI0003': [ // Arugula Salad
      [CARROT,  0.020, 'KG'],  // Carrot garnish — 20g
      [AVOCADO, 0.030, 'KG'],  // Avocado — 30g
    ],
  };

  // ============================================================
  // INSERT RECIPES INTO DATABASE
  // ============================================================
  console.log('🍽️ Inserting fine dining recipes...\n');

  let totalInserted = 0, totalSkipped = 0, totalNoIng = 0, totalNoMenu = 0;
  const results = [];

  for (const [menuItemId, lines] of Object.entries(recipeMap)) {
    // Check menu item exists
    const miCheck = await client.query("SELECT id, name FROM menu_items WHERE id = $1", [menuItemId]);
    if (miCheck.rows.length === 0) { 
      totalNoMenu++;
      results.push({ id: menuItemId, status: 'NO_MENU' });
      continue; 
    }
    const menuName = miCheck.rows[0].name;

    // Aggregate duplicate ingredients (from spread operators)
    const aggLines = {};
    for (const [code, qty, uom] of lines) {
      if (!aggLines[code]) aggLines[code] = { qty: 0, uom };
      aggLines[code].qty += qty;
    }

    let menuInserted = 0, menuNoIng = 0;
    for (const [code, { qty, uom }] of Object.entries(aggLines)) {
      const ingId = id(code);
      if (!ingId) { 
        // Try to find any NVLC4010/4011 for chicken substitute
        totalNoIng++;
        menuNoIng++;
        continue; 
      }
      try {
        await client.query(`
          INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
          VALUES ($1, $2, $3, 100, $4)
          ON CONFLICT (menu_item_id, ingredient_id) DO UPDATE
            SET qty_net = EXCLUDED.qty_net, recipe_uom = EXCLUDED.recipe_uom
        `, [menuItemId, ingId, qty, uom || ING[code]?.uom || 'KG']);
        menuInserted++;
        totalInserted++;
      } catch (err) {
        console.error(`  Recipe err [${menuItemId}] ${code}:`, err.message.substring(0, 60));
      }
    }

    results.push({ id: menuItemId, name: menuName.substring(0, 40), inserted: menuInserted, no_ing: menuNoIng });
  }

  console.log('Results per menu:');
  results.forEach(r => {
    if (r.status === 'NO_MENU') {
      console.log(`  ❌ ${r.id}: menu item not found in DB`);
    } else {
      const icon = r.inserted > 0 ? '✅' : '⚠️';
      console.log(`  ${icon} [${r.id}] ${r.name}: ${r.inserted} ingredients inserted, ${r.no_ing} not found`);
    }
  });

  // ============================================================
  // Update is_set_menu for appropriate menus
  // ============================================================
  console.log('\n📋 Setting is_set_menu flag...');
  const setMenuCodes = Object.keys(recipeMap).filter(k => k.startsWith('R61') || k.startsWith('R62'));
  for (const code of setMenuCodes) {
    if (code.startsWith('R6')) {
      await client.query("UPDATE menu_items SET is_set_menu = true WHERE id = $1", [code]).catch(()=>{});
    }
  }
  console.log(`  Updated is_set_menu for ${setMenuCodes.length} set menus`);

  // ============================================================
  // Re-process all pending UNMAPPED sales
  // ============================================================
  console.log('\n⚡ Re-processing all pending UNMAPPED sales...');
  const pending = await client.query(`
    SELECT id FROM sales_imports
    WHERE is_processed = false AND mapping_status = 'UNMAPPED'
    ORDER BY import_date ASC
  `);
  console.log(`  Found ${pending.rows.length} pending`);

  let procDone = 0, procErr = 0;
  for (const row of pending.rows) {
    try {
      await client.query("SELECT process_single_sale_import($1, NULL::uuid)", [row.id]);
      procDone++;
    } catch (err) { procErr++; }
  }
  console.log(`  ✅ Processed: ${procDone}, Errors: ${procErr}`);

  // ============================================================
  // FINAL SUMMARY
  // ============================================================
  console.log('\n' + '='.repeat(65));
  console.log('📊 FINAL STATUS:');

  const salesSummary = await client.query(`
    SELECT mapping_status, COUNT(*) cnt FROM sales_imports GROUP BY mapping_status ORDER BY cnt DESC
  `);
  console.log('\n  Bán hàng:');
  salesSummary.rows.forEach(r => console.log(`    ${r.mapping_status}: ${r.cnt}`));

  const txSummary = await client.query(`
    SELECT txn_type, COUNT(*) cnt FROM inventory_transactions GROUP BY txn_type ORDER BY cnt DESC
  `);
  console.log('\n  Giao dịch kho:');
  txSummary.rows.forEach(r => console.log(`    ${r.txn_type}: ${r.cnt}`));

  const recipeTotal = await client.query("SELECT COUNT(*) FROM recipes");
  console.log(`\n  Tổng công thức: ${recipeTotal.rows[0].count}`);

  // Remaining unmapped
  const stillUnmapped = await client.query(`
    SELECT si.menu_item_id, mi.name, COUNT(*) cnt
    FROM sales_imports si
    LEFT JOIN menu_items mi ON mi.id = si.menu_item_id
    WHERE si.is_processed = false AND si.mapping_status = 'UNMAPPED'
    GROUP BY si.menu_item_id, mi.name
    ORDER BY cnt DESC LIMIT 15
  `);
  if (stillUnmapped.rows.length > 0) {
    console.log(`\n  Còn lại chưa xử lý (${stillUnmapped.rows.length} món):`);
    stillUnmapped.rows.forEach(r => console.log(`    [${r.menu_item_id}] ${(r.name||'?').substring(0,40)}: ${r.cnt} records`));
  } else {
    console.log('\n  ✅ TẤT CẢ đã được xử lý!');
  }

  console.log(`\n  Tổng chèn công thức: ${totalInserted}`);
  console.log(`  Nguyên liệu không tìm thấy: ${totalNoIng}`);
  console.log(`  Món không tìm thấy trong DB: ${totalNoMenu}`);

  await client.end();
  console.log('\n✅ HOÀN THÀNH! Công thức fine dining đã được tạo.');
}

main().catch(err => { console.error('FATAL:', err); process.exit(1); });
