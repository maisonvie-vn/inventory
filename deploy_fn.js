const { Client } = require('pg');
const fs = require('fs');
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';
const connectionString = 'postgres://postgres.vtbrohaccikrhgcpjvec:1972Urmylove%40@aws-1-ap-northeast-1.pooler.supabase.com:6543/postgres?sslmode=require';

async function run() {
  const client = new Client({ connectionString });
  try {
    await client.connect();
    console.log('✅ Connected');

    // Execute the SQL function
    const sql = fs.readFileSync('./supabase/fn_period_stock_summary.sql', 'utf8');
    await client.query(sql);
    console.log('✅ Function get_period_stock_summary created');

    // Test the function for June 2026
    const { rows: sample } = await client.query(`
      SELECT ingredient_code, ten_vi, opening_qty, in_qty, out_qty, closing_qty, closing_value
      FROM get_period_stock_summary('2026-06-01', '2026-06-30')
      WHERE closing_qty != 0
      ORDER BY closing_value DESC
      LIMIT 15;
    `);
    console.log('\n=== Period stock summary for T06/2026 (top 15) ===');
    sample.forEach(r => console.log(`  ${r.ingredient_code} | ${r.ten_vi?.substring(0,30)} | open=${parseFloat(r.opening_qty).toFixed(2)} | in=${parseFloat(r.in_qty).toFixed(2)} | out=${parseFloat(r.out_qty).toFixed(2)} | close=${parseFloat(r.closing_qty).toFixed(2)} | value=${parseInt(r.closing_value||0).toLocaleString()}`));

    // Check V6056 specifically
    const { rows: montGras } = await client.query(`
      SELECT * FROM get_period_stock_summary('2026-06-01', '2026-06-30')
      WHERE ingredient_code = 'V6056';
    `);
    console.log('\n=== V6056 MontGras period summary ===');
    montGras.forEach(r => console.log(JSON.stringify(r)));

  } catch (err) {
    console.error("Failed:", err.message);
  } finally {
    await client.end();
  }
}

run();
