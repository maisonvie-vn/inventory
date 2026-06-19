const { Client } = require('pg');
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';
const client = new Client({
  connectionString: 'postgres://postgres.vtbrohaccikrhgcpjvec:1972Urmylove%40@aws-1-ap-northeast-1.pooler.supabase.com:6543/postgres?sslmode=require',
  ssl: { rejectUnauthorized: false }
});

client.connect().then(async () => {
  // FIX 1: Set is_set_menu = false for all menus that now have direct recipes
  // (They have recipes in the recipes table, so they should be processed as RECIPE type, not SET_MENU)
  const fix1 = await client.query(`
    UPDATE menu_items
    SET is_set_menu = false
    WHERE id IN (
      SELECT DISTINCT menu_item_id FROM recipes
    )
    AND is_set_menu = true
    AND NOT EXISTS (
      SELECT 1 FROM set_menu_items WHERE parent_menu_item_id = menu_items.id
    )
  `);
  console.log(`✅ Fixed is_set_menu=false for ${fix1.rowCount} items that have direct recipes`);

  // FIX 2: Beverages/cocktails that shouldn't track recipes
  const cocktails = ['M5006', 'M7014', 'M9117', 'M8003', 'M5001'];
  for (const code of cocktails) {
    await client.query(
      "UPDATE menu_items SET deduction_type = 'NON_STOCK' WHERE id = $1",
      [code]
    ).catch(() => {});
  }
  console.log(`✅ Marked ${cocktails.length} cocktails/spirits as NON_STOCK`);

  // FIX 3: Re-process ALL remaining UNMAPPED
  const pending = await client.query(`
    SELECT id FROM sales_imports
    WHERE is_processed = false AND mapping_status = 'UNMAPPED'
    ORDER BY import_date
  `);
  console.log(`\n⚡ Re-processing ${pending.rows.length} pending UNMAPPED sales...`);

  let done = 0, err = 0;
  for (const row of pending.rows) {
    try {
      await client.query("SELECT process_single_sale_import($1, NULL::uuid)", [row.id]);
      done++;
    } catch (e) { err++; }
  }
  console.log(`  ✅ Processed: ${done}, Errors: ${err}`);

  // FINAL STATUS
  const status = await client.query(`
    SELECT mapping_status, COUNT(*) cnt, SUM(qty_sold) total_qty
    FROM sales_imports GROUP BY mapping_status ORDER BY cnt DESC
  `);
  console.log('\n📊 FINAL SALES STATUS:');
  status.rows.forEach(r => {
    const pct = Math.round(parseInt(r.cnt) / 888 * 100);
    console.log(`  ${r.mapping_status}: ${r.cnt} records (${pct}%) | ${r.total_qty} qty`);
  });

  const txCount = await client.query("SELECT txn_type, COUNT(*) cnt FROM inventory_transactions GROUP BY txn_type ORDER BY cnt DESC");
  console.log('\n📦 INVENTORY TRANSACTIONS:');
  txCount.rows.forEach(r => console.log(`  ${r.txn_type}: ${r.cnt}`));

  // Still unmapped?
  const still = await client.query(`
    SELECT si.menu_item_id, mi.name, mi.deduction_type, mi.is_set_menu,
           COUNT(*) cnt,
           EXISTS(SELECT 1 FROM recipes r WHERE r.menu_item_id = si.menu_item_id) as has_recipe
    FROM sales_imports si
    LEFT JOIN menu_items mi ON mi.id = si.menu_item_id
    WHERE si.is_processed = false AND si.mapping_status = 'UNMAPPED'
    GROUP BY si.menu_item_id, mi.name, mi.deduction_type, mi.is_set_menu
    ORDER BY cnt DESC LIMIT 20
  `);
  if (still.rows.length > 0) {
    console.log(`\n⚠️  Còn ${still.rows.length} loại chưa xử lý (user sẽ mapping sau):`);
    still.rows.forEach(r => console.log(
      `  [${r.menu_item_id}] ${(r.name||'?').substring(0,40)} | type=${r.deduction_type} | set=${r.is_set_menu} | recipe=${r.has_recipe} | cnt=${r.cnt}`
    ));
  }

  await client.end();
  console.log('\n✅ HOÀN THÀNH!');
}).catch(console.error);
