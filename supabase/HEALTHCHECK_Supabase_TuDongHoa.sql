-- =====================================================================
-- MAISON VIE — HEALTH-CHECK HỆ THỐNG TỰ ĐỘNG HÓA & PRODUCTION
-- SQL Script dùng để kiểm tra tính toàn vẹn của Database trên Supabase
-- =====================================================================

create or replace function public.run_supabase_health_check()
returns table (
  category text,
  item_name text,
  status text,
  message text
) as $$
begin
  -- 1. KIỂM TRA EXTENSIONS
  category := 'EXTENSION';
  
  item_name := 'pg_cron';
  if exists (select 1 from pg_extension where extname = 'pg_cron') then
    status := 'OK'; message := 'Extension pg_cron đã bật.';
  else
    status := 'WARNING'; message := 'Extension pg_cron CHƯA bật. Cron jobs định kỳ sẽ không hoạt động.';
  end if;
  return next;

  item_name := 'pg_net';
  if exists (select 1 from pg_extension where extname = 'pg_net') then
    status := 'OK'; message := 'Extension pg_net đã bật.';
  else
    status := 'WARNING'; message := 'Extension pg_net CHƯA bật. Hàm send_email sẽ không chạy được.';
  end if;
  return next;

  item_name := 'pgcrypto';
  if exists (select 1 from pg_extension where extname = 'pgcrypto') then
    status := 'OK'; message := 'Extension pgcrypto đã bật.';
  else
    status := 'ERROR'; message := 'Extension pgcrypto CHƯA bật. Thiếu hàm sinh UUID và mã hóa.';
  end if;
  return next;

  -- 2. KIỂM TRA CẤU TRÚC BẢNG (TABLES)
  category := 'TABLE';
  
  declare
    t_name text;
    tables_list text[] := array[
      'profiles', 'uom', 'uom_conversions', 'purchase_categories', 'ingredients', 
      'suppliers', 'supplier_ingredients', 'menu_items', 'set_menu_items', 'recipes', 
      'purchase_orders', 'po_lines', 'goods_receipts', 'grn_lines', 'lots', 
      'inventory_transactions', 'waste_logs', 'sales_imports', 'non_sale_consumption', 
      'pos_alias_map', 'stock_takes', 'stock_take_lines', 'daily_close', 'audit_log',
      'locations', 'bar_bottle_calibration', 'bar_counts', 'daily_stock_movement', 
      'order_documents', 'ingredient_departments', 'takeaway_packaging_map', 'menu_prices', 
      'app_settings', 'app_settings_history', 'seasonal_profiles', 'production_orders', 
      'production_inputs', 'inventory_snapshots', 'inventory_period_close'
    ];
  begin
    foreach t_name in array tables_list loop
      item_name := t_name;
      if exists (select 1 from information_schema.tables where table_schema = 'public' and table_name = t_name) then
        status := 'OK'; message := 'Bảng tồn tại.';
      else
        status := 'ERROR'; message := 'Bảng thiếu trong schema public!';
      end if;
      return next;
    end loop;
  end;

  -- 3. KIỂM TRA ROW LEVEL SECURITY (RLS)
  category := 'RLS';
  
  declare
    t_name text;
    rls_enabled boolean;
    tables_list text[] := array[
      'profiles', 'uom', 'uom_conversions', 'purchase_categories', 'ingredients', 
      'suppliers', 'supplier_ingredients', 'menu_items', 'set_menu_items', 'recipes', 
      'purchase_orders', 'po_lines', 'goods_receipts', 'grn_lines', 'lots', 
      'inventory_transactions', 'waste_logs', 'sales_imports', 'non_sale_consumption', 
      'pos_alias_map', 'stock_takes', 'stock_take_lines', 'daily_close', 'audit_log',
      'locations', 'bar_bottle_calibration', 'bar_counts', 'daily_stock_movement', 
      'order_documents', 'ingredient_departments', 'takeaway_packaging_map', 'menu_prices', 
      'app_settings', 'app_settings_history', 'seasonal_profiles', 'production_orders', 
      'production_inputs', 'inventory_snapshots', 'inventory_period_close'
    ];
  begin
    foreach t_name in array tables_list loop
      item_name := t_name;
      select relrowsecurity into rls_enabled from pg_class where relname = t_name and relnamespace = 'public'::regnamespace;
      if rls_enabled then
        status := 'OK'; message := 'RLS đã được kích hoạt (true).';
      else
        status := 'ERROR'; message := 'RLS CHƯA bật! Rủi ro bảo mật dữ liệu cao.';
      end if;
      return next;
    end loop;
  end;

  -- 4. KIỂM TRA TRIGGERS TỰ ĐỘNG HÓA
  category := 'TRIGGER';
  
  declare
    trg_record record;
    trg_list table (t_name text, trg_name text) := values
      ('sales_imports', 'trg_sales_imports_process_trigger'),
      ('goods_receipts', 'trg_goods_receipt_approve_trigger'),
      ('waste_logs', 'trg_waste_logs_process_trigger'),
      ('non_sale_consumption', 'trg_non_sale_consumption_trigger'),
      ('production_orders', 'trg_production_orders_trigger'),
      ('stocktakes', 'trg_stocktakes_post_trigger');
  begin
    for trg_record in select * from trg_list loop
      item_name := trg_record.trg_name || ' on ' || trg_record.t_name;
      if exists (
        select 1 from pg_trigger t
        join pg_class c on t.tgrelid = c.oid
        where c.relname = trg_record.t_name and t.tgname = trg_record.trg_name
      ) then
        status := 'OK'; message := 'Trigger đã hoạt động.';
      else
        status := 'ERROR'; message := 'Trigger thiếu hoặc chưa gán vào bảng!';
      end if;
      return next;
    end loop;
  end;

  -- 5. KIỂM TRA VIEWS BẢO MẬT & KHO
  category := 'VIEW';
  
  declare
    v_name text;
    views_list text[] := array[
      'v_inventory_ops', 'v_inventory_cost', 'v_inventory_finance', 
      'v_stock_on_hand', 'v_fefo_lots'
    ];
  begin
    foreach v_name in array views_list loop
      item_name := v_name;
      if exists (select 1 from information_schema.views where table_schema = 'public' and table_name = v_name) then
        status := 'OK'; message := 'View bảo mật tồn tại.';
      else
        status := 'ERROR'; message := 'View thiếu hoặc lỗi compile!';
      end if;
      return next;
    end loop;
  end;

  -- 6. KIỂM TRA VAULT SECRETS
  category := 'VAULT';
  item_name := 'RESEND_API_KEY';
  if exists (
    select 1 from pg_tables where tablename = 'decrypted_secrets' and table_schema = 'vault'
  ) and exists (
    select 1 from vault.decrypted_secrets where name = 'RESEND_API_KEY'
  ) then
    status := 'OK'; message := 'Khóa RESEND_API_KEY tồn tại trong Vault.';
  else
    status := 'WARNING'; message := 'Khóa RESEND_API_KEY chưa nạp vào Vault. Hệ thống sẽ không thể gửi email báo cáo/cảnh báo.';
  end if;
  return next;

  -- 7. KIỂM TRA CRON JOBS LẬP LỊCH
  category := 'CRON';
  declare
    cron_record record;
    cron_jobs text[] := array['auto_close', 'variance_nightly', 'auto_po', 'lowstock_email', 'expiry_alert', 'po_aging', 'daily_report', 'weekly_report', 'monthly_partition', 'storage_cleanup'];
  begin
    if exists (select 1 from pg_tables where tablename = 'job' and table_schema = 'cron') then
      foreach t_name in array cron_jobs loop
        item_name := 'Job: ' || t_name;
        if exists (select 1 from cron.job where jobname = t_name) then
          status := 'OK'; message := 'Cron job đã được lên lịch chạy UTC.';
        else
          status := 'WARNING'; message := 'Cron job chưa được đăng ký trong cron.job!';
        end if;
        return next;
      end loop;
    else
      status := 'WARNING'; message := 'Schema cron chưa sẵn sàng để kiểm tra job.';
    end if;
  end;

end;
$$ language plpgsql security definer;

-- Cách chạy: SELECT * FROM run_supabase_health_check();
