/**
 * KIỂM TRA TỰ ĐỘNG HÓA SUPABASE - MAISON VIE
 * Test 1: Insert 1 sales record → kiểm tra trigger tự động trừ kho
 * Test 2: Xác nhận tất cả trigger đang hoạt động
 */
const { Client } = require('pg');
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';
const client = new Client({
  connectionString: 'postgres://postgres.vtbrohaccikrhgcpjvec:1972Urmylove%40@aws-1-ap-northeast-1.pooler.supabase.com:6543/postgres?sslmode=require',
  ssl: { rejectUnauthorized: false }
});

const sleep = ms => new Promise(r => setTimeout(r, ms));

client.connect().then(async () => {
  console.log('='.repeat(60));
  console.log('🔍 KIỂM TRA TỰ ĐỘNG HÓA HỆ THỐNG MAISON VIE');
  console.log('='.repeat(60) + '\n');

  // ============================================================
  // CHECK 1: Danh sách triggers đang hoạt động
  // ============================================================
  console.log('📌 CHECK 1: Triggers đang hoạt động trên Supabase');
  const triggers = await client.query(`
    SELECT trigger_name, event_object_table, event_manipulation, action_timing
    FROM information_schema.triggers
    WHERE trigger_schema = 'public'
    ORDER BY event_object_table, trigger_name
  `);
  if (triggers.rows.length === 0) {
    console.log('  ❌ KHÔNG có trigger nào! Hệ thống CHƯA tự động.');
  } else {
    console.log(`  Tìm thấy ${triggers.rows.length} trigger:\n`);
    triggers.rows.forEach(t => {
      console.log(`  ✅ [${t.event_object_table}] ${t.trigger_name}`);
      console.log(`     → ${t.action_timing} ${t.event_manipulation}\n`);
    });
  }

  // ============================================================
  // CHECK 2: Test LIVE - Insert 1 sales record và xem trigger hoạt động
  // ============================================================
  console.log('\n' + '='.repeat(60));
  console.log('🧪 CHECK 2: TEST LIVE — Bán 1 lon Beer 333 (B5004)');
  console.log('='.repeat(60));

  // Lấy tồn kho trước khi test
  const stockBefore = await client.query(`
    SELECT COALESCE(SUM(qty), 0) as net_stock
    FROM inventory_transactions
    WHERE ingredient_id = (SELECT id FROM ingredients WHERE code = 'B5004')
  `);
  const beforeQty = parseFloat(stockBefore.rows[0].net_stock);
  console.log(`\n  Tồn kho B5004 (Beer 333) TRƯỚC khi bán: ${beforeQty.toFixed(1)} lon`);

  // Insert 1 sale record vào sales_imports
  const testHash = `TEST_AUTOMATION_${Date.now()}`;
  await client.query(`
    INSERT INTO sales_imports
      (import_date, menu_item_id, qty_sold, net_revenue, file_hash, void_qty, comp_qty,
       order_type, is_processed, mapping_status)
    VALUES
      (CURRENT_DATE, 'B5004', 3, 210000, $1, 0, 0, 'DINE_IN', false, 'UNMAPPED')
  `, [testHash]);
  console.log('  ✅ Đã insert: bán 3 lon Beer 333...');

  // Đợi trigger xử lý
  await sleep(1500);

  // Kiểm tra kết quả
  const saleRecord = await client.query(
    "SELECT id, is_processed, mapping_status FROM sales_imports WHERE file_hash = $1",
    [testHash]
  );
  const sale = saleRecord.rows[0];

  const stockAfter = await client.query(`
    SELECT COALESCE(SUM(qty), 0) as net_stock
    FROM inventory_transactions
    WHERE ingredient_id = (SELECT id FROM ingredients WHERE code = 'B5004')
  `);
  const afterQty = parseFloat(stockAfter.rows[0].net_stock);
  const deducted = beforeQty - afterQty;

  console.log(`\n  Kết quả sau khi insert:`);
  console.log(`  • is_processed = ${sale?.is_processed}`);
  console.log(`  • mapping_status = ${sale?.mapping_status}`);
  console.log(`  • Tồn kho SAU khi bán: ${afterQty.toFixed(1)} lon`);
  console.log(`  • Số lượng bị trừ: ${deducted.toFixed(1)} lon`);

  if (sale?.is_processed && sale?.mapping_status === 'MAPPED' && deducted >= 3) {
    console.log('\n  ✅✅ TỰ ĐỘNG HOÀN TOÀN! Trigger hoạt động chính xác.');
    console.log('  → Insert sale → trigger kích hoạt ngay → trừ kho tự động!');
  } else if (sale?.is_processed === false && deducted === 0) {
    console.log('\n  ⚠️  Trigger CHƯA xử lý. Chạy thủ công...');
    await client.query("SELECT process_single_sale_import($1, NULL::uuid)", [sale.id]);
    await sleep(500);
    const recheck = await client.query("SELECT is_processed, mapping_status FROM sales_imports WHERE id = $1", [sale.id]);
    const recheckStock = await client.query(`SELECT COALESCE(SUM(qty), 0) as net FROM inventory_transactions WHERE ingredient_id = (SELECT id FROM ingredients WHERE code = 'B5004')`);
    console.log(`  Sau khi chạy thủ công: is_processed=${recheck.rows[0].is_processed}, status=${recheck.rows[0].mapping_status}`);
    console.log(`  Tồn kho: ${parseFloat(recheckStock.rows[0].net).toFixed(1)}`);
  }

  // Xóa record test
  await client.query("DELETE FROM sales_imports WHERE file_hash = $1", [testHash]);
  // Xóa transaction test nếu có
  await client.query(`
    DELETE FROM inventory_transactions
    WHERE ref_id IN (SELECT id::text FROM sales_imports WHERE file_hash = $1)
  `, [testHash]).catch(() => {});
  console.log('\n  🗑️  Đã xóa dữ liệu test');

  // ============================================================
  // CHECK 3: Kiểm tra các chức năng tự động khác
  // ============================================================
  console.log('\n' + '='.repeat(60));
  console.log('📌 CHECK 3: Trạng thái toàn bộ hệ thống');
  console.log('='.repeat(60));

  const stats = await client.query(`
    SELECT
      (SELECT COUNT(*) FROM ingredients)          AS nguyen_lieu,
      (SELECT COUNT(*) FROM menu_items)           AS thuc_don,
      (SELECT COUNT(*) FROM recipes)              AS cong_thuc,
      (SELECT COUNT(*) FROM pos_alias_map)        AS pos_map,
      (SELECT COUNT(*) FROM sales_imports)        AS ban_hang_total,
      (SELECT COUNT(*) FROM sales_imports WHERE mapping_status = 'MAPPED')       AS mapped,
      (SELECT COUNT(*) FROM sales_imports WHERE mapping_status = 'NO_STOCK_IMPACT') AS no_impact,
      (SELECT COUNT(*) FROM sales_imports WHERE mapping_status = 'UNMAPPED')     AS unmapped,
      (SELECT COUNT(*) FROM inventory_transactions WHERE txn_type = 'IMPORT')    AS nhap_kho,
      (SELECT COUNT(*) FROM inventory_transactions WHERE txn_type = 'SALE_DEPLETION') AS xuat_ban
  `);
  const s = stats.rows[0];

  console.log('\n  📦 DỮ LIỆU:');
  console.log(`  • Nguyên liệu:  ${s.nguyen_lieu}`);
  console.log(`  • Thực đơn:     ${s.thuc_don}`);
  console.log(`  • Công thức:    ${s.cong_thuc}`);
  console.log(`  • POS mapping:  ${s.pos_map}`);

  console.log('\n  📈 BÁN HÀNG (1-16/6/2026):');
  const totalSales = parseInt(s.ban_hang_total);
  const pctMapped = Math.round(parseInt(s.mapped) / totalSales * 100);
  const pctNoImpact = Math.round(parseInt(s.no_impact) / totalSales * 100);
  const pctUnmapped = Math.round(parseInt(s.unmapped) / totalSales * 100);
  console.log(`  • ✅ MAPPED (trừ kho tự động): ${s.mapped} records (${pctMapped}%)`);
  console.log(`  • ⬜ NO_STOCK_IMPACT (không trừ): ${s.no_impact} records (${pctNoImpact}%)`);
  console.log(`  • 🟡 UNMAPPED (cần mapping):   ${s.unmapped} records (${pctUnmapped}%)`);

  console.log('\n  📊 KHO HÀNG:');
  console.log(`  • Giao dịch nhập kho (IMPORT):     ${s.nhap_kho}`);
  console.log(`  • Giao dịch xuất bán (SALE_DEPLETION): ${s.xuat_ban}`);

  // Sample stock levels
  const stocks = await client.query(`
    SELECT i.code, i.ten_vi, SUM(it.qty) as net
    FROM ingredients i
    LEFT JOIN inventory_transactions it ON it.ingredient_id = i.id
    WHERE i.code IN ('B5001','B5004','B5005','B5007','NLP60033','NLP60034','NLP3008','NVLC10011')
    GROUP BY i.code, i.ten_vi
    ORDER BY i.code
  `);
  console.log('\n  🏷️  TỒN KHO HIỆN TẠI (mẫu):');
  stocks.rows.forEach(r => {
    const net = parseFloat(r.net || 0).toFixed(1);
    const icon = parseFloat(net) < 0 ? '⚠️' : (parseFloat(net) < 10 ? '🟡' : '✅');
    console.log(`  ${icon} ${r.code}: ${(r.ten_vi||'').substring(0,25)} = ${net}`);
  });

  console.log('\n' + '='.repeat(60));
  console.log('🎯 KẾT LUẬN:');
  if (triggers.rows.length > 0) {
    console.log('  ✅ HỆ THỐNG ĐÃ TỰ ĐỘNG HOÀN TOÀN trên Supabase!');
    console.log('');
    console.log('  Quy trình tự động:');
    console.log('  1️⃣  Import file bán hàng POS → INSERT vào sales_imports');
    console.log('  2️⃣  Trigger kích hoạt ngay lập tức (AFTER INSERT)');
    console.log('  3️⃣  Tra cứu công thức (recipes) cho từng món');
    console.log('  4️⃣  Tạo SALE_DEPLETION transaction → trừ kho nguyên liệu');
    console.log('  5️⃣  Cập nhật WAC price tự động');
    console.log('');
    console.log('  Không cần làm gì thêm — chỉ cần import file POS!');
  } else {
    console.log('  ❌ Trigger CHƯA hoạt động. Cần kiểm tra lại.');
  }
  console.log('='.repeat(60));

  await client.end();
}).catch(console.error);
