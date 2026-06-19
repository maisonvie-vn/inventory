const { createClient } = require('@supabase/supabase-js');

// Use the anon key (same as the app)
const supabaseUrl = 'https://vtbrohaccikrhgcpjvec.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0YnJvaGFjY2lrcmhnY3BqdmVjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE0MjU2NjcsImV4cCI6MjA5NzAwMTY2N30.Qwayde5UfnpX4i7a3aXlsL2Lw4CT47d4C_mngM5a6uk';

const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function run() {
  // 1. Test fetching inventory_transactions as anon user
  const { data: txData, error: txError } = await supabase
    .from('inventory_transactions')
    .select('*')
    .limit(5);
  
  console.log('=== inventory_transactions (anon, limit 5) ===');
  if (txError) {
    console.log('ERROR:', txError.message, txError.code);
  } else {
    console.log(`Fetched ${txData?.length} rows`);
    txData?.forEach(r => console.log(`  id=${r.id} | txn=${r.txn_type} | source=${r.source} | status=${r.status}`));
  }

  // 2. Count all transactions visible to anon
  const { count, error: countError } = await supabase
    .from('inventory_transactions')
    .select('*', { count: 'exact', head: true });
  
  console.log(`\n=== Total inventory_transactions visible to anon: ${count} (error: ${countError?.message}) ===`);

  // 3. Check OPENING_BALANCE specifically
  const { data: openData, error: openError } = await supabase
    .from('inventory_transactions')
    .select('id, ingredient_id, txn_type, qty, status, source, business_date')
    .eq('source', 'OPENING_BALANCE')
    .limit(5);
  
  console.log(`\n=== OPENING_BALANCE txns visible to anon: ${openData?.length} (error: ${openError?.message}) ===`);
  openData?.forEach(r => console.log(`  id=${r.id} | qty=${r.qty} | date=${r.business_date}`));

  // 4. Check v_inventory_finance as anon
  const { data: viewData, error: viewError } = await supabase
    .from('v_inventory_finance')
    .select('*')
    .eq('ingredient_code', 'V6056');
  
  console.log(`\n=== v_inventory_finance V6056 (anon): ===`);
  if (viewError) console.log('ERROR:', viewError.message);
  else viewData?.forEach(r => console.log(`  qty_on_hand=${r.qty_on_hand} | stock_value=${r.stock_value_vnd}`));
  
  // 5. What views can anon access?
  const { data: v1, error: e1 } = await supabase.from('v_inventory_ops').select('*').limit(1);
  console.log(`\nv_inventory_ops: ${v1?.length ?? 0} rows (error: ${e1?.message})`);
  
  const { data: v2, error: e2 } = await supabase.from('v_inventory_cost').select('*').limit(1);
  console.log(`v_inventory_cost: ${v2?.length ?? 0} rows (error: ${e2?.message})`);
}

run().catch(console.error);
