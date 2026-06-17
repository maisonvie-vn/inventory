-- 1. Alter sales_imports to add mapping_status
alter table sales_imports add column if not exists mapping_status text not null default 'MAPPED'
  check (mapping_status in ('MAPPED','UNMAPPED','RESOLVED','NO_STOCK_IMPACT'));

-- 2. Create unique index on inventory_transactions for idempotency
create unique index if not exists ux_invtxn_ref
  on inventory_transactions (ref_table, ref_id, ingredient_id)
  where ref_table is not null;

-- 3. Create view v_unmapped_sales
create or replace view v_unmapped_sales as
select menu_item_id as pos_item_code,
       min(import_date) as first_seen,
       max(import_date) as last_seen,
       count(*)           as line_count,
       sum(qty_sold)      as total_qty,
       sum(net_revenue)   as total_revenue
from sales_imports
where mapping_status = 'UNMAPPED'
group by menu_item_id;

-- 4. Reprocess function after mapping a POS item
create or replace function resolve_unmapped_item(p_pos_item_code text)
returns int
language plpgsql security definer set search_path=public as $func$
declare v_n int;
begin
  -- Trừ kho theo công thức cho mọi dòng UNMAPPED của mã này
  insert into inventory_transactions
        (ingredient_id, qty, txn_type, ref_table, ref_id, business_date, status, created_at)
  select r.ingredient_id,
         -(sl.qty_sold * r.qty_eff / i.stock_to_recipe_factor), 'SALE_DEPLETION', 'sales_imports', sl.id::text, sl.import_date, 'approved', now()
  from sales_imports sl
  join pos_alias_map a on a.pos_code = sl.menu_item_id
  join recipes       r on r.menu_item_id = a.menu_item_id
  join ingredients   i on r.ingredient_id = i.id
  where sl.menu_item_id = p_pos_item_code
    and sl.mapping_status = 'UNMAPPED'
  on conflict (ref_table, ref_id, ingredient_id) do nothing;

  -- Trừ bao bì nếu TAKEAWAY — theo takeaway_packaging_map
  insert into inventory_transactions
        (ingredient_id, qty, txn_type, ref_table, ref_id, business_date, status, created_at)
  select m.packaging_id,
         -(sl.qty_sold * m.qty_per_unit), 'SALE_DEPLETION', 'sales_imports', sl.id::text, sl.import_date, 'approved', now()
  from sales_imports sl
  join takeaway_packaging_map m on m.pos_item_code = sl.menu_item_id
  join ingredients            i on m.packaging_id = i.id
  where sl.menu_item_id = p_pos_item_code
    and sl.mapping_status = 'UNMAPPED'
    and sl.order_type = 'TAKEAWAY'
  on conflict (ref_table, ref_id, ingredient_id) do nothing;

  update sales_imports set mapping_status='RESOLVED', is_processed=true
  where menu_item_id = p_pos_item_code and mapping_status='UNMAPPED';
  get diagnostics v_n = row_count;
  return v_n;
end; $func$;

-- 5. Ad-hoc consumption function
create or replace function consume_adhoc(p_line_ids uuid[], p_consume jsonb)
returns void language plpgsql security definer set search_path=public as $func$
begin
  insert into inventory_transactions
        (ingredient_id, qty, txn_type, ref_table, ref_id, business_date, status, created_at)
  select (c->>'ingredient_id'),
         -((c->>'qty')::numeric), 'NON_SALE', 'sales_imports', lid::text, sl.import_date, 'approved', now()
  from unnest(p_line_ids) lid
  join sales_imports sl on sl.id = lid
  cross join jsonb_array_elements(p_consume) c
  on conflict (ref_table, ref_id, ingredient_id) do nothing;

  update sales_imports set mapping_status='RESOLVED', is_processed=true where id = any(p_line_ids);
end; $func$;

-- 6. Placeholder functions for cron jobs to prevent pg_cron failures
create or replace function public.auto_close_day() returns void language plpgsql as $$ begin null; end; $$;
create or replace function public.compute_variance() returns void language plpgsql as $$ begin null; end; $$;
create or replace function public.generate_auto_po() returns void language plpgsql as $$ begin null; end; $$;
create or replace function public.send_expiry_alert() returns void language plpgsql as $$ begin null; end; $$;
create or replace function public.flag_overdue_po() returns void language plpgsql as $$ begin null; end; $$;
create or replace function public.send_daily_report() returns void language plpgsql as $$ begin null; end; $$;
create or replace function public.send_weekly_report() returns void language plpgsql as $$ begin null; end; $$;
create or replace function public.create_next_month_partition() returns void language plpgsql as $$ begin null; end; $$;
create or replace function public.cleanup_old_uploads() returns void language plpgsql as $$ begin null; end; $$;
