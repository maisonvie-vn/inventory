const XLSX = require('xlsx');
const { Client } = require('pg');
const path = require('path');
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';
const connectionString = 'postgres://postgres.vtbrohaccikrhgcpjvec:1972Urmylove%40@aws-1-ap-northeast-1.pooler.supabase.com:6543/postgres?sslmode=require';
const BASE = 'D:\\Invenroty';

function parseQty(v) {
  if (!v && v !== 0) return 0;
  const n = parseFloat(String(v).replace(/[^0-9.\-]/g, ''));
  return isNaN(n) ? 0 : n;
}
function parseDate(v) {
  if (!v) return '2026-06-01';
  if (typeof v === 'number') {
    const d = new Date(Math.round((v - 25569) * 86400 * 1000));
    return d.toISOString().slice(0, 10);
  }
  return String(v).slice(0, 10);
}

async function main() {
  const client = new Client({ connectionString, ssl: { rejectUnauthorized: false } });
  await client.connect();
  console.log('✅ Connected!');

  // Build ingredient map
  const ingRows = await client.query("SELECT id, code, is_beverage FROM ingredients");
  const ingMap = {};
  const isBeverageMap = {};
  ingRows.rows.forEach(r => { 
    ingMap[r.code] = r.id;
    isBeverageMap[r.id] = r.is_beverage;
  });

  // ===================================================================
  // Import purchases
  // ===================================================================
  console.log('\n🚚 Importing purchase receipts...');
  const purchWb = XLSX.readFile(path.join(BASE, 'Maison_Vie_Nhap_Kho_0106_1406.xlsx'));
  const purchWs = purchWb.Sheets['Purchasing_Template'];
  const purchData = XLSX.utils.sheet_to_json(purchWs, { defval: '' });
  console.log(`  ${purchData.length} purchase lines`);

  // Delete the 2 test records we just inserted
  await client.query("DELETE FROM inventory_transactions WHERE ref_id IN ('GRN_INV-0604-AN_B5004', 'GRN_INV-0604-AN_B5004_v2')");

  let purchInserted = 0, purchNotFound = 0, purchErr = 0;
  for (const row of purchData) {
    const code = String(row['Mã NVL (Ingredient Code)'] || '').trim();
    const qty = parseQty(row['Số lượng (Qty Received)']);
    const unitPrice = parseQty(row['Đơn giá (Unit Price)']);
    const invoiceNo = String(row['Số hóa đơn (Invoice No)'] || '').trim();
    const bizDate = parseDate(row['Ngày nhập (Date)']);

    if (!code || qty <= 0) continue;
    const ingId = ingMap[code];
    if (!ingId) { purchNotFound++; continue; }

    // Determine location: beverage → BAR, kitchen → KITCHEN, else MAIN_STORE
    const isBev = isBeverageMap[ingId];
    const location = isBev === true ? 'BAR' : (code.startsWith('NLP') || code.startsWith('NVLC') ? 'KITCHEN' : 'MAIN_STORE');
    const refId = `GRN_${invoiceNo}_${code}`;

    try {
      await client.query(`
        INSERT INTO inventory_transactions
          (ingredient_id, txn_type, qty, unit_cost, business_date, location_id, ref_table, ref_id, status, note)
        VALUES ($1, 'IMPORT', $2, $3, $4, $5, 'grn', $6, 'posted', $7)
        ON CONFLICT DO NOTHING
      `, [ingId, qty, unitPrice, bizDate, location, refId, `Nhập kho ${invoiceNo}`]);
      purchInserted++;
    } catch (err) {
      purchErr++;
      if (purchErr <= 5) console.error(`  err ${code}:`, err.message.substring(0, 80));
    }

    // Update WAC price
    if (unitPrice > 0) {
      await client.query(
        "UPDATE ingredients SET wac_price = $1 WHERE id = $2 AND wac_price = 0",
        [unitPrice, ingId]
      ).catch(() => {});
    }
  }
  console.log(`  ✅ Purchases: inserted=${purchInserted}, not_found=${purchNotFound}, errors=${purchErr}`);

  // ===================================================================
  // Show corrected stock levels
  // ===================================================================
  const stockCheck = await client.query(`
    SELECT 
      i.code, i.ten_vi, i.wac_price,
      SUM(CASE WHEN it.txn_type = 'IMPORT' THEN it.qty ELSE 0 END) as total_in,
      ABS(SUM(CASE WHEN it.txn_type = 'SALE_DEPLETION' THEN it.qty ELSE 0 END)) as total_sold,
      SUM(it.qty) as net_stock
    FROM ingredients i
    LEFT JOIN inventory_transactions it ON it.ingredient_id = i.id
    WHERE i.code IN ('B5001','B5004','B5005','B5007','B5010','B5012','B5016',
                     'M6001','M6002','M6004','M6008','M6009',
                     'NLP60033','NLP60034','NLP60031','NLP60032','NLP60041')
    GROUP BY i.code, i.ten_vi, i.wac_price
    ORDER BY net_stock ASC
  `);

  console.log('\n📊 Current Stock Levels:');
  console.log('  Status | Code         | Name                     | Nhập   | Bán    | Tồn kho | WAC/đv');
  stockCheck.rows.forEach(r => {
    const net = parseFloat(r.net_stock || 0);
    const status = net < 0 ? '⚠️ ÂM' : net < 10 ? '🟡 ÍT' : '✅    ';
    console.log(`  ${status} | ${r.code.padEnd(12)} | ${(r.ten_vi||'').substring(0,24).padEnd(24)} | ${parseFloat(r.total_in||0).toFixed(0).padStart(5)} | ${parseFloat(r.total_sold||0).toFixed(0).padStart(5)} | ${net.toFixed(1).padStart(7)} | ${Number(r.wac_price).toLocaleString('vi')}`);
  });

  // ===================================================================
  // Final summary
  // ===================================================================
  console.log('\n' + '='.repeat(70));
  console.log('📊 TRẠNG THÁI CUỐI CÙNG:');

  const txFinal = await client.query(`
    SELECT txn_type, COUNT(*) cnt, SUM(qty) total FROM inventory_transactions GROUP BY txn_type
  `);
  console.log('\n  Giao dịch tồn kho:');
  txFinal.rows.forEach(r => console.log(`    ${r.txn_type}: ${r.cnt} giao dịch | qty = ${parseFloat(r.total||0).toFixed(1)}`));

  const salesFinal = await client.query(`
    SELECT mapping_status, COUNT(*) cnt FROM sales_imports GROUP BY mapping_status ORDER BY cnt DESC
  `);
  console.log('\n  Bán hàng:');
  salesFinal.rows.forEach(r => console.log(`    ${r.mapping_status}: ${r.cnt}`));

  const totalRows = await client.query(`
    SELECT 'ingredients' as t, COUNT(*) c FROM ingredients
    UNION ALL SELECT 'menu_items', COUNT(*) FROM menu_items
    UNION ALL SELECT 'recipes', COUNT(*) FROM recipes
    UNION ALL SELECT 'sales_imports', COUNT(*) FROM sales_imports
    UNION ALL SELECT 'inventory_transactions', COUNT(*) FROM inventory_transactions
  `);
  console.log('\n  Bảng dữ liệu:');
  totalRows.rows.forEach(r => console.log(`    ${r.t}: ${r.c}`));

  await client.end();
  console.log('\n✅ HOÀN THÀNH!');
}
main().catch(err => { console.error('FATAL:', err); process.exit(1); });
