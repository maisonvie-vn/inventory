/**
 * run_migration.js — Chạy migration v3.0 lên Supabase Production
 * Dùng kết nối trực tiếp qua Supabase DB URL (Service Role)
 * 
 * Cách dùng:
 *   $env:DB_URL="postgresql://postgres.vtbrohaccikrhgcpjvec:[PASSWORD]@aws-0-ap-northeast-1.pooler.supabase.com:5432/postgres"
 *   node run_migration.js
 */

const { Client } = require('pg');
const fs = require('fs');
const path = require('path');

// Lấy DB_URL từ env hoặc args
const DB_URL = process.env.DB_URL || process.argv[2];

if (!DB_URL || DB_URL.includes('[PASSWORD]')) {
  console.error('\n❌ Cần cung cấp DB_URL với mật khẩu thực!\n');
  console.error('Cách lấy DB password:');
  console.error('  1. Vào https://supabase.com/dashboard/project/vtbrohaccikrhgcpjvec/settings/database');
  console.error('  2. Mục "Connection string" → Mode: URI → chép toàn bộ');
  console.error('\nCách chạy (PowerShell):');
  console.error('  $env:DB_URL="postgresql://postgres.vtbrohaccikrhgcpjvec:YOUR_PASSWORD@aws-0-ap-northeast-1.pooler.supabase.com:5432/postgres"');
  console.error('  node run_migration.js\n');
  process.exit(1);
}

const MIGRATION_FILE = path.join(__dirname, 'supabase', 'v3_0_migration.sql');

async function runMigration() {
  console.log('\n🚀 MAISON VIE v3.0 MIGRATION\n');
  console.log('📄 File:', MIGRATION_FILE);
  console.log('🔗 Project: vtbrohaccikrhgcpjvec (maisonvie-inventory)\n');

  const client = new Client({
    connectionString: DB_URL,
    ssl: { rejectUnauthorized: false },
    // Timeout dài hơn cho migration lớn
    connectionTimeoutMillis: 30000,
    statement_timeout: 120000,
  });

  try {
    console.log('⏳ Đang kết nối Supabase...');
    await client.connect();
    console.log('✅ Kết nối thành công!\n');

    // Đọc file SQL
    const sql = fs.readFileSync(MIGRATION_FILE, 'utf8');

    console.log('⏳ Đang chạy migration (có thể mất 30-60 giây)...\n');

    // Bắt các NOTICE messages (checkpoint output)
    client.on('notice', (msg) => {
      if (msg.message) {
        console.log('  ℹ️', msg.message);
      }
    });

    await client.query(sql);

    console.log('\n✅ MIGRATION HOÀN TẤT!\n');
    console.log('Bước tiếp theo:');
    console.log('  1. Kiểm tra bảng mới: notification_badges, push_subscriptions, stock_alert_acks');
    console.log('  2. Kiểm tra view: v_stock_alerts, v_order_worklist_ops');
    console.log('  3. Kiểm tra trigger: trg_refresh_reorder_txn, trg_po_audit_trigger');
    console.log('  4. Thêm VAPID key vào .env.local (xem hướng dẫn bên dưới)\n');

  } catch (err) {
    console.error('\n❌ MIGRATION THẤT BẠI!\n');
    console.error('Lỗi:', err.message);
    
    // Gợi ý xử lý lỗi phổ biến
    if (err.message.includes('ingredient_departments')) {
      console.error('\n💡 Gợi ý: Bảng ingredient_departments chưa có.');
      console.error('   Cần chạy v9-6_01_schema.sql trước, hoặc điều chỉnh migration.');
    } else if (err.message.includes('v_stock_on_hand')) {
      console.error('\n💡 Gợi ý: View v_stock_on_hand chưa có.');
      console.error('   Cần chạy migrations_v9.6_triggers.sql trước.');
    } else if (err.message.includes('seasonal_profiles')) {
      console.error('\n💡 Gợi ý: Bảng seasonal_profiles chưa có — function sẽ dùng multiplier = 1.0 mặc định.');
    } else if (err.message.includes('permission denied')) {
      console.error('\n💡 Gợi ý: Dùng password của postgres (Superuser), không phải anon key.');
    } else if (err.message.includes('already exists')) {
      console.error('\n💡 Gợi ý: Migration đã chạy một phần. Script có IF NOT EXISTS nên thường an toàn.');
    }
    
    process.exit(1);
  } finally {
    await client.end();
  }
}

runMigration();
