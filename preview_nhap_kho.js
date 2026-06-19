const XLSX = require('xlsx');
const { Client } = require('pg');
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';
const conn = 'postgres://postgres.vtbrohaccikrhgcpjvec:1972Urmylove%40@aws-1-ap-northeast-1.pooler.supabase.com:6543/postgres?sslmode=require';

const filePath = 'D:\\Invenroty\\Maison_Vie_Nhap_Kho_0106_1406.xlsx';

async function run() {
  const wb = XLSX.readFile(filePath);
  console.log('=== Sheets trong file ===');
  wb.SheetNames.forEach((s, i) => console.log(`  [${i}] ${s}`));

  // Read first sheet
  const ws = wb.Sheets[wb.SheetNames[0]];
  const rows = XLSX.utils.sheet_to_json(ws, { header: 1, defval: null });

  console.log(`\nTotal rows: ${rows.length}`);

  // Show first 10 rows to understand structure
  console.log('\n=== 10 dòng đầu ===');
  for (let i = 0; i < Math.min(10, rows.length); i++) {
    const r = rows[i];
    if (r && r.some(v => v !== null)) {
      console.log(`Row ${i}: ${JSON.stringify(r).substring(0, 120)}`);
    }
  }

  // Find header row
  let headerRow = -1;
  for (let i = 0; i < Math.min(15, rows.length); i++) {
    const rowStr = (rows[i]||[]).join('|').toLowerCase();
    if (rowStr.includes('mã') || rowStr.includes('code') || rowStr.includes('ngày') || rowStr.includes('date')) {
      headerRow = i;
      console.log(`\nHeader at row ${i}: ${rows[i].filter(v=>v!==null).join(' | ')}`);
      break;
    }
  }

  // Count data rows
  let dataCount = 0;
  for (let i = (headerRow >= 0 ? headerRow + 1 : 1); i < rows.length; i++) {
    if (rows[i] && rows[i].some(v => v !== null && v !== '')) dataCount++;
  }
  console.log(`\nData rows (after header): ${dataCount}`);

  // Show last row
  for (let i = rows.length - 1; i >= 0; i--) {
    if (rows[i] && rows[i].some(v => v !== null && v !== '')) {
      console.log(`Last data row ${i}: ${JSON.stringify(rows[i]).substring(0, 150)}`);
      break;
    }
  }

  // Check if already imported (by cross-referencing with DB)
  const client = new Client({ connectionString: conn });
  await client.connect();

  // Check goods_receipts for any matching data
  const { rows: grnCheck } = await client.query(`
    SELECT COUNT(*) as cnt, MAX(business_date) as latest
    FROM goods_receipts
    WHERE business_date BETWEEN '2026-06-01' AND '2026-06-14'
    AND supplier_id IS NOT NULL;
  `);
  console.log(`\n=== Goods receipts trong DB (01/06-14/06) ===`);
  console.log(`  Count: ${grnCheck[0].cnt} | Latest: ${grnCheck[0].latest}`);

  // Check if purchase_orders has any between these dates
  const { rows: poCheck } = await client.query(`
    SELECT COUNT(*) as cnt, MAX(created_at) as latest
    FROM purchase_orders
    WHERE created_at >= '2026-06-01';
  `);
  console.log(`\n=== Purchase orders trong DB (từ 01/06) ===`);
  console.log(`  Count: ${poCheck[0].cnt}`);

  await client.end();
}
run().catch(console.error);
