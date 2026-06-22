/**
 * run_patch.js — CLI tool to run a database SQL patch on Supabase
 * Usage:
 *   node run_patch.js <path_to_sql_file>
 * Example:
 *   node run_patch.js supabase/patch_v3_0_15_rls_badges_anon.sql
 */

const { Client } = require('pg');
const fs = require('fs');
const path = require('path');

// Disable TLS unauthorized checking for direct pooler connection (Supabase self-signed certs)
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

const DB_URL = process.env.DB_URL || 'postgres://postgres.vtbrohaccikrhgcpjvec:1972Urmylove%40@aws-1-ap-northeast-1.pooler.supabase.com:6543/postgres?sslmode=require';

const sqlRelativePath = process.argv[2];
if (!sqlRelativePath) {
  console.error('\n❌ Error: Please specify the SQL patch file to run.');
  console.error('Usage: node run_patch.js <path_to_sql_file>');
  console.error('Example: node run_patch.js supabase/patch_v3_0_15_rls_badges_anon.sql\n');
  process.exit(1);
}

const absolutePath = path.resolve(process.cwd(), sqlRelativePath);
if (!fs.existsSync(absolutePath)) {
  console.error(`\n❌ Error: File not found at path "${absolutePath}"\n`);
  process.exit(1);
}

async function runPatch() {
  console.log(`\n🚀 Applying database patch: ${sqlRelativePath}`);
  
  const client = new Client({
    connectionString: DB_URL,
    ssl: { rejectUnauthorized: false }
  });

  try {
    console.log('⏳ Connecting to Supabase PostgreSQL database...');
    await client.connect();
    console.log('✅ Connected successfully!');
    
    console.log('⏳ Reading SQL file...');
    const sql = fs.readFileSync(absolutePath, 'utf8');
    
    console.log('⏳ Executing SQL patch...');
    await client.query(sql);
    console.log('✅ SQL PATCH APPLIED SUCCESSFULLY!\n');
  } catch (err) {
    console.error('\n❌ SQL PATCH FAILED!');
    console.error('Error details:', err.message || err);
    process.exit(1);
  } finally {
    await client.end();
  }
}

runPatch();
