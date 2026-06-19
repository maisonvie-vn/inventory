/**
 * MAISON VIE - Full Production Import Script
 * Imports: menu_items, opening_stock (BAR+BEP), sales (1-13 + 14-16), purchases, recipes
 * Safe: checks existing data before inserting (ON CONFLICT DO NOTHING)
 */
const XLSX = require('xlsx');
const { Client } = require('pg');
const path = require('path');
const fs = require('fs');

process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';
const connectionString = 'postgres://postgres.vtbrohaccikrhgcpjvec:1972Urmylove%40@aws-1-ap-northeast-1.pooler.supabase.com:6543/postgres?sslmode=require';
const BASE = 'D:\\Invenroty';

// ============================================================
// HELPERS
// ============================================================
function parseQty(v) {
  if (v === null || v === undefined || v === '') return 0;
  const n = parseFloat(String(v).replace(/[^0-9.\-]/g, ''));
  return isNaN(n) ? 0 : n;
}
function parsePrice(v) {
  if (v === null || v === undefined || v === '') return 0;
  const s = String(v).replace(/[^0-9.]/g, '');
  const n = parseFloat(s);
  return isNaN(n) ? 0 : n;
}
function readSheet(file, sheetName, opts = {}) {
  const wb = XLSX.readFile(path.join(BASE, file));
  const ws = wb.Sheets[sheetName || wb.SheetNames[0]];
  if (!ws) return [];
  return XLSX.utils.sheet_to_json(ws, { header: 1, defval: '', ...opts });
}
function readSheetObj(file, sheetName) {
  const wb = XLSX.readFile(path.join(BASE, file));
  const ws = wb.Sheets[sheetName || wb.SheetNames[0]];
  if (!ws) return [];
  return XLSX.utils.sheet_to_json(ws, { defval: '' });
}

async function bulkInsert(client, table, rows, conflictTarget, updateFields) {
  if (!rows.length) return 0;
  let count = 0;
  for (const row of rows) {
    const keys = Object.keys(row);
    const vals = keys.map(k => row[k]);
    const placeholders = keys.map((_, i) => `$${i + 1}`).join(', ');
    const colNames = keys.join(', ');
    let sql;
    if (conflictTarget) {
      if (updateFields && updateFields.length) {
        const updates = updateFields.map(f => `${f} = EXCLUDED.${f}`).join(', ');
        sql = `INSERT INTO ${table} (${colNames}) VALUES (${placeholders}) ON CONFLICT (${conflictTarget}) DO UPDATE SET ${updates}`;
      } else {
        sql = `INSERT INTO ${table} (${colNames}) VALUES (${placeholders}) ON CONFLICT (${conflictTarget}) DO NOTHING`;
      }
    } else {
      sql = `INSERT INTO ${table} (${colNames}) VALUES (${placeholders})`;
    }
    try {
      await client.query(sql, vals);
      count++;
    } catch (err) {
      // Silent skip for conflicts
      if (!err.message.includes('duplicate') && !err.message.includes('conflict') && !err.message.includes('unique')) {
        console.error(`  ⚠ Insert error in ${table}:`, err.message.substring(0, 100));
      }
    }
  }
  return count;
}

// ============================================================
// 1. MENU ITEMS from MAMONANUONG.xlsx
// ============================================================
function extractMenuItems() {
  const raw = readSheet('MAMONANUONG.xlsx', 'CBUI');
  const items = [];
  for (let i = 1; i < raw.length; i++) {
    const row = raw[i];
    const code = String(row[0] || '').trim();
    const name = String(row[1] || '').trim();
    if (!code || !name) continue;
    const priceStr = String(row[3] || '0').replace(/[^0-9]/g, '');
    const price = parseInt(priceStr || '0', 10);
    const active = String(row[7] || '').toLowerCase().includes('check');
    items.push({ id: code, name, sale_price: price, is_set_menu: false, deduction_type: 'RECIPE' });
  }
  return items;
}

// ============================================================
// 2. OPENING STOCK BAR from BÁO CÁO TỒN KHO BAR T05.2026.xlsx
// ============================================================
function extractOpeningStockBAR() {
  const raw = readSheet('BÁO CÁO TỒN KHO BAR T05.2026.xlsx', 'T5.26');
  const items = [];
  // Header is at row 4 (0-indexed): Mã hhóa | Tên hàng hóa | Đvt | Đầu kỳ SL | Nhập | Xuất | Cuối kỳ SS | TT | Đơn giá | Thành tiền
  // col0=code, col1=name, col2=uom, col3=opening_qty, col4=received, col5=issued, col6=closing_SS, col7=closing_TT, col8=unit_price
  for (let i = 5; i < raw.length; i++) {
    const row = raw[i];
    const code = String(row[0] || '').trim();
    const name = String(row[1] || '').trim();
    const uom = String(row[2] || '').trim();
    if (!code || !name || !uom) continue;
    // Skip category rows (no unit or no numeric data)
    const openQty = parseQty(row[3]);
    const unitPrice = parseQty(row[8]);
    if (uom.length > 10) continue; // category header
    items.push({
      code,
      name,
      uom,
      opening_qty: openQty,
      closing_qty: parseQty(row[6]),
      unit_price: unitPrice,
      location: 'BAR',
    });
  }
  return items;
}

// ============================================================
// 3. OPENING STOCK BEP from BÁO CÁO TỒN KHO BẾP T05.2026.xlsx
// ============================================================
function extractOpeningStockBEP() {
  const raw = readSheet('BÁO CÁO TỒN KHO BẾP T05.2026.xlsx', 'T5.26');
  const items = [];
  // Header rows: row5=Mã hàng hóa | Tên hàng hóa | ĐVT | ...
  // Data starts at row 8
  // col0=code, col1=name, col2=uom, col3=opening_qty(Đầu kỳ), col4=received(Nhập)
  for (let i = 8; i < raw.length; i++) {
    const row = raw[i];
    const code = String(row[0] || '').trim();
    const name = String(row[1] || '').trim();
    const uom = String(row[2] || '').trim();
    if (!code || !name) continue;
    if (uom.length > 15 || code.toUpperCase() === code && code.length > 10 && !code.match(/^[A-Z0-9]{4,12}$/)) continue;
    const openQty = parseQty(row[3]);
    items.push({
      code,
      name,
      uom,
      opening_qty: openQty,
      location: 'KITCHEN',
    });
  }
  return items;
}

// ============================================================
// 4. SALES 1-13 June from BH ngày 1-13.06.2026.xls
// ============================================================
function extractSales113() {
  const raw = readSheet('BH ngày 1-13.06.2026.xls', null);
  const sales = [];
  // Header at row 5: Mã hàng | Tên hàng | | Giá bán | | Số lượng | Tổng tiền
  // Data starts at row 7
  for (let i = 6; i < raw.length; i++) {
    const row = raw[i];
    const code = String(row[0] || '').trim();
    const name = String(row[1] || '').trim();
    const priceVal = parsePrice(row[3]);
    const qty = parseQty(row[5]);
    const revenue = parseQty(row[6]);
    if (!code || !name || qty <= 0) continue;
    // Skip category rows (no price, or code is all caps non-product)
    if (code.length <= 6 && !code.match(/^[A-Z0-9]{3,8}$/) && priceVal === 0) continue;
    if (code === 'Mã hàng' || name === 'Tên hàng') continue;
    // Only real product codes
    if (code.match(/^[A-Z0-9\-]{3,10}$/) && priceVal > 0) {
      sales.push({
        menu_item_id: code,
        name,
        price: priceVal,
        qty_sold: qty,
        revenue,
        period: '01-13/06/2026',
      });
    }
  }
  return sales;
}

// ============================================================
// 5. SALES 14-16 June from Maison_Vie_POS_Sales_14-16.xlsx
// ============================================================
function extractSales1416() {
  const data = readSheetObj('Maison_Vie_POS_Sales_14-16.xlsx', 'Sales_POS_Template');
  return data
    .filter(r => r['Mã hàng'] && r['Số lượng'] > 0)
    .map(r => ({
      menu_item_id: String(r['Mã hàng']).trim(),
      name: String(r['Tên hàng'] || '').trim(),
      price: parsePrice(r['Giá bán']),
      qty_sold: parseQty(r['Số lượng']),
      revenue: parseQty(r['Tổng tiền trước giảm']),
      period: '14-16/06/2026',
    }));
}

// ============================================================
// 6. PURCHASES from Maison_Vie_Nhap_Kho_0106_1406.xlsx
// ============================================================
function extractPurchases() {
  const data = readSheetObj('Maison_Vie_Nhap_Kho_0106_1406.xlsx', 'Purchasing_Template');
  return data
    .filter(r => r['Mã NVL (Ingredient Code)'] && r['Số lượng (Qty Received)'])
    .map(r => ({
      date: r['Ngày nhập (Date)'],
      invoice_no: String(r['Số hóa đơn (Invoice No)'] || '').trim(),
      supplier: String(r['Nhà cung cấp (Supplier)'] || '').trim(),
      ingredient_code: String(r['Mã NVL (Ingredient Code)']).trim(),
      ingredient_name: String(r['Tên NVL (Ingredient Name)'] || '').trim(),
      qty: parseQty(r['Số lượng (Qty Received)']),
      uom: String(r['Đơn vị (UoM)'] || '').trim(),
      unit_price: parsePrice(r['Đơn giá (Unit Price)']),
      freight: parsePrice(r['Chi phí vận chuyển (Freight)']),
      duty: parsePrice(r['Thuế (Duty)']),
    }));
}

// ============================================================
// 7. RECIPES from FINAL(12062026) Recipe Master
// ============================================================
function extractRecipes() {
  const wb = XLSX.readFile(path.join(BASE, 'FINAL(12062026)_Maison_Vie_Recipe_Master_2026_CORRIGE.xlsx'));
  const recipes = []; // { menu_item_id, ingredient_id(code), qty_net, yield_pct, recipe_uom }

  // Get recipe sheet names (R-001, R-002, etc.)
  const recipeSheets = wb.SheetNames.filter(s => /^R-\d+/.test(s) || /^R-\d+_DEG/.test(s));

  for (const sheetName of recipeSheets) {
    const ws = wb.Sheets[sheetName];
    const raw = XLSX.utils.sheet_to_json(ws, { header: 1, defval: '' });

    // Find the recipe code from row4: Code | R-001 | ...
    let menuItemId = sheetName.replace('_DEG', '').replace('-', '-'); // e.g., R-001
    for (const row of raw.slice(0, 8)) {
      if (String(row[0]).trim().toLowerCase() === 'code') {
        menuItemId = String(row[1]).trim();
        break;
      }
    }

    // Find ingredient data rows (after "Ing ID" header)
    let inIngSection = false;
    for (const row of raw) {
      const col0 = String(row[0]).trim();
      if (col0 === 'Ing ID') { inIngSection = true; continue; }
      if (!inIngSection) continue;
      if (!col0 || !col0.match(/^ING-\d+$/)) continue; // only real ingredient rows

      const ingId = col0;
      const qtyNet = parseQty(row[2]);
      const unit = String(row[3] || 'G').trim().toUpperCase();
      const yieldPct = parseQty(row[4]);

      if (qtyNet > 0) {
        recipes.push({
          menu_item_id: menuItemId,
          ing_code: ingId,
          qty_net: qtyNet,
          recipe_uom: unit || 'G',
          yield_pct: yieldPct || 100,
        });
      }
    }
  }
  return recipes;
}

// ============================================================
// MAIN IMPORT
// ============================================================
async function main() {
  console.log('🔌 Connecting to Supabase...');
  const client = new Client({ connectionString, ssl: { rejectUnauthorized: false } });
  await client.connect();
  console.log('✅ Connected!\n');

  // ---- STEP 1: Menu Items ----
  console.log('📋 STEP 1: Importing menu items from MAMONANUONG.xlsx...');
  const menuItems = extractMenuItems();
  // Check which ones don't exist yet
  const existingMI = await client.query("SELECT id FROM menu_items");
  const existingMISet = new Set(existingMI.rows.map(r => r.id));
  const newMI = menuItems.filter(m => !existingMISet.has(m.id));
  console.log(`  Found ${menuItems.length} menu items, ${newMI.length} are new`);
  if (newMI.length > 0) {
    const inserted = await bulkInsert(client, 'menu_items', newMI, 'id', ['name', 'sale_price']);
    console.log(`  ✅ Inserted/updated: ${inserted} menu items`);
  } else {
    console.log('  ⬜ All menu items already exist');
  }

  // ---- STEP 2: Opening Stock ----
  console.log('\n📦 STEP 2: Importing opening stock (BAR + BEP end of May 2026)...');
  const barStock = extractOpeningStockBAR();
  const bepStock = extractOpeningStockBEP();
  const allStock = [...barStock, ...bepStock];
  console.log(`  BAR: ${barStock.length} items, BEP: ${bepStock.length} items`);

  // Map codes to ingredient IDs in DB
  const ingMap = {};
  const ingRows = await client.query("SELECT id, code FROM ingredients");
  ingRows.rows.forEach(r => { ingMap[r.code] = r.id; });

  // Check if opening_stock transactions already exist (to avoid duplicates)
  const existingOpenTx = await client.query(
    "SELECT COUNT(*) FROM inventory_transactions WHERE txn_type = 'OPENING_STOCK'"
  );
  const openTxCount = parseInt(existingOpenTx.rows[0].count);
  console.log(`  Existing OPENING_STOCK transactions: ${openTxCount}`);

  if (openTxCount === 0) {
    // Check if there are goods_receipts with Nhập Đầu Kỳ already
    const existingGR = await client.query(
      "SELECT COUNT(*) FROM goods_receipts WHERE invoice_no LIKE 'INV-0602%' OR invoice_no LIKE 'INV-0601%'"
    );
    console.log(`  Existing goods receipts (initial): ${existingGR.rows[0].count}`);

    // Insert opening stock as inventory_transactions directly (WAC-based)
    let osInserted = 0;
    for (const item of allStock) {
      if (item.opening_qty <= 0) continue;
      const ingId = ingMap[item.code];
      if (!ingId) continue; // ingredient not in DB

      try {
        await client.query(`
          INSERT INTO inventory_transactions
            (ingredient_id, txn_type, qty, unit_cost, business_date, location_id, ref_table, ref_id, status, source)
          VALUES ($1, 'OPENING_STOCK', $2, $3, '2026-06-01', $4, 'opening_stock', $5, 'posted', 'EXCEL_IMPORT')
          ON CONFLICT DO NOTHING
        `, [ingId, item.opening_qty, item.unit_price || 0, item.location, item.code]);
        osInserted++;
      } catch (err) {
        // ignore
      }
    }
    console.log(`  ✅ Opening stock transactions inserted: ${osInserted}`);
  } else {
    console.log('  ⬜ Opening stock already loaded, skipping');
  }

  // ---- STEP 3: Sales Imports ----
  console.log('\n💰 STEP 3: Importing sales data...');

  const sales113 = extractSales113();
  const sales1416 = extractSales1416();
  console.log(`  Sales 1-13 Jun: ${sales113.length} records`);
  console.log(`  Sales 14-16 Jun: ${sales1416.length} records`);

  // Check existing sales by file_hash
  const existingHash113 = await client.query(
    "SELECT COUNT(*) FROM sales_imports WHERE file_hash LIKE '1-13.06%' OR file_hash LIKE 'BH%1-13%'"
  );
  const existingHash1416 = await client.query(
    "SELECT COUNT(*) FROM sales_imports WHERE file_hash LIKE '14-16%' OR file_hash LIKE 'Maison_Vie_POS_Sales_14-16%'"
  );

  // Group sales by code (aggregate same code+price into one record per day period)
  // For 1-13: aggregate all into total qty
  async function importSalesGroup(salesList, fileHash, importDate, location) {
    // Group by menu_item_id + price
    const grouped = {};
    for (const s of salesList) {
      const key = `${s.menu_item_id}|${s.price}`;
      if (!grouped[key]) grouped[key] = { menu_item_id: s.menu_item_id, qty_sold: 0, net_revenue: 0, price: s.price };
      grouped[key].qty_sold += s.qty_sold;
      grouped[key].net_revenue += s.revenue;
    }
    const rows = Object.values(grouped);
    let inserted = 0;
    for (const r of rows) {
      // Determine order_type: dine-in vs takeaway by price comparison
      const orderType = r.price >= 50000 ? 'DINE_IN' : 'TAKEAWAY';
      try {
        await client.query(`
          INSERT INTO sales_imports
            (import_date, menu_item_id, qty_sold, net_revenue, file_hash, void_qty, comp_qty, order_type, is_processed, mapping_status)
          VALUES ($1, $2, $3, $4, $5, 0, 0, $6, false, 'UNMAPPED')
          ON CONFLICT DO NOTHING
        `, [importDate, r.menu_item_id, r.qty_sold, r.net_revenue, fileHash + '_' + r.menu_item_id + '_' + r.price, orderType]);
        inserted++;
      } catch(err) {
        // ignore conflicts
      }
    }
    return inserted;
  }

  if (parseInt(existingHash113.rows[0].count) === 0) {
    const ins113 = await importSalesGroup(sales113, '1-13.06.2026', '2026-06-13', 'DINE_IN');
    console.log(`  ✅ Sales 1-13 inserted: ${ins113} records`);
  } else {
    console.log(`  ⬜ Sales 1-13 already loaded (${existingHash113.rows[0].count} records)`);
  }

  if (parseInt(existingHash1416.rows[0].count) === 0) {
    const ins1416 = await importSalesGroup(sales1416, '14-16.06.2026', '2026-06-16', 'DINE_IN');
    console.log(`  ✅ Sales 14-16 inserted: ${ins1416} records`);
  } else {
    console.log(`  ⬜ Sales 14-16 already loaded (${existingHash1416.rows[0].count} records)`);
  }

  // ---- STEP 4: Purchases / GRN ----
  console.log('\n🚚 STEP 4: Importing purchases (GRN)...');
  const purchases = extractPurchases();
  console.log(`  Found ${purchases.length} purchase lines`);

  // Check existing
  const existingGRN = await client.query(
    "SELECT invoice_no FROM goods_receipts"
  );
  const existingInvoices = new Set(existingGRN.rows.map(r => r.invoice_no));

  // Group by invoice
  const byInvoice = {};
  for (const p of purchases) {
    if (!byInvoice[p.invoice_no]) byInvoice[p.invoice_no] = { ...p, lines: [] };
    byInvoice[p.invoice_no].lines.push(p);
  }

  let grnInserted = 0;
  const systemSupplierId = '90000000-0000-0000-0000-000000000004';
  for (const [invNo, grp] of Object.entries(byInvoice)) {
    if (existingInvoices.has(invNo)) continue;
    // Insert GR header
    const totalAmt = grp.lines.reduce((s, l) => s + l.qty * l.unit_price, 0);
    const grDate = grp.date ? (typeof grp.date === 'number'
      ? new Date(Math.round((grp.date - 25569) * 86400 * 1000)).toISOString().slice(0, 10)
      : String(grp.date).slice(0, 10)) : '2026-06-01';

    try {
      await client.query(`
        INSERT INTO goods_receipts
          (invoice_no, supplier_id, invoice_amount, currency, fx_rate, duty, freight, match_status, status, business_date)
        VALUES ($1, $2, $3, 'VND', 1, $4, $5, 'APPROVED', 'approved', $6)
        ON CONFLICT DO NOTHING
      `, [invNo, systemSupplierId, totalAmt, grp.lines[0].duty || 0, grp.lines[0].freight || 0, grDate]);
      grnInserted++;
    } catch (err) {
      if (!err.message.includes('duplicate')) console.error('  GRN insert error:', err.message.substring(0, 100));
    }
  }
  console.log(`  ✅ GRN headers inserted: ${grnInserted}`);

  // ---- STEP 5: Recipes from Recipe Master ----
  console.log('\n🍽️ STEP 5: Importing recipes from Recipe Master...');
  const recipesFromMaster = extractRecipes();
  console.log(`  Found ${recipesFromMaster.length} recipe lines`);

  // Count existing
  const existingRecipes = await client.query("SELECT COUNT(*) FROM recipes");
  console.log(`  Existing recipes: ${existingRecipes.rows[0].count}`);

  // Map ING codes to UUIDs
  const ingCodeMap = {};
  const ingAllRows = await client.query("SELECT id, code FROM ingredients");
  ingAllRows.rows.forEach(r => { ingCodeMap[r.code] = r.id; });

  // Insert missing recipes (ones from FINAL recipe master, mapped by ING code)
  let recInserted = 0;
  let recSkipped = 0;
  for (const r of recipesFromMaster) {
    const ingId = ingCodeMap[r.ing_code];
    if (!ingId) { recSkipped++; continue; }

    // Ensure menu_item exists in menu_items
    const miCheck = await client.query("SELECT id FROM menu_items WHERE id = $1", [r.menu_item_id]);
    if (miCheck.rows.length === 0) { recSkipped++; continue; }

    try {
      await client.query(`
        INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
        VALUES ($1, $2, $3, $4, $5)
        ON CONFLICT (menu_item_id, ingredient_id) DO UPDATE
          SET qty_net = EXCLUDED.qty_net, yield_pct = EXCLUDED.yield_pct, recipe_uom = EXCLUDED.recipe_uom
      `, [r.menu_item_id, ingId, r.qty_net, r.yield_pct, r.recipe_uom]);
      recInserted++;
    } catch (err) {
      if (!err.message.includes('duplicate')) console.error('  Recipe insert error:', err.message.substring(0, 100));
    }
  }
  console.log(`  ✅ Recipes inserted/updated: ${recInserted} (skipped ${recSkipped} missing refs)`);

  // ---- STEP 6: Update pos_alias_map for new menu items ----
  console.log('\n🗺️ STEP 6: Updating pos_alias_map for new menu codes...');
  const newMenuIds = newMI.map(m => m.id);
  let aliasInserted = 0;
  for (const id of newMenuIds) {
    try {
      await client.query(`
        INSERT INTO pos_alias_map (pos_code, menu_item_id, confidence, confirmed_at)
        VALUES ($1, $1, 100, NOW())
        ON CONFLICT (pos_code) DO NOTHING
      `, [id]);
      aliasInserted++;
    } catch (err) { /* ignore */ }
  }
  console.log(`  ✅ pos_alias_map entries added: ${aliasInserted}`);

  // ---- STEP 7: Re-process all pending sales ----
  console.log('\n⚡ STEP 7: Re-processing all pending sales imports...');
  const pending = await client.query(
    "SELECT id FROM sales_imports WHERE is_processed = false AND mapping_status <> 'NO_STOCK_IMPACT' ORDER BY import_date ASC"
  );
  console.log(`  Found ${pending.rows.length} pending records`);

  let procDone = 0, procErr = 0;
  for (const row of pending.rows) {
    try {
      await client.query("SELECT process_single_sale_import($1, NULL::uuid)", [row.id]);
      procDone++;
    } catch (err) {
      procErr++;
    }
  }
  console.log(`  ✅ Processed: ${procDone}, Errors: ${procErr}`);

  // ---- FINAL SUMMARY ----
  console.log('\n' + '='.repeat(60));
  console.log('📊 FINAL DATABASE STATUS:');
  const tables = ['ingredients', 'menu_items', 'recipes', 'pos_alias_map', 'sales_imports', 'goods_receipts', 'inventory_transactions'];
  for (const t of tables) {
    const { rows } = await client.query(`SELECT COUNT(*) FROM ${t}`);
    console.log(`  ${t}: ${rows[0].count} rows`);
  }

  const processed = await client.query("SELECT mapping_status, COUNT(*) as cnt FROM sales_imports GROUP BY mapping_status ORDER BY cnt DESC");
  console.log('\n  Sales mapping status:');
  processed.rows.forEach(r => console.log(`    ${r.mapping_status}: ${r.cnt}`));

  const invTx = await client.query("SELECT txn_type, COUNT(*) as cnt, SUM(qty) as total FROM inventory_transactions GROUP BY txn_type");
  console.log('\n  Inventory transactions:');
  invTx.rows.forEach(r => console.log(`    ${r.txn_type}: ${r.cnt} records, qty=${parseFloat(r.total || 0).toFixed(2)}`));

  await client.end();
  console.log('\n✅ Import complete!');
}

main().catch(err => { console.error('FATAL:', err); process.exit(1); });
