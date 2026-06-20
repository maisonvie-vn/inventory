-- ============================================================
-- PATCH v3.0.1 — Sửa luồng trừ tồn kho tự động
-- Vấn đề:
--   1. Trigger trg_sales_imports_process gọi auth.uid() → NULL khi dùng anon/service key → bỏ qua
--   2. Menu_item f862aa3e (Luis Felipe Chardonnay) có recipe trỏ đến ingredient_id = f862aa3e
--      nhưng ingredient này không map đúng sang inventory
--   3. fetchSupabaseData() không đọc qty_on_hand từ view vào UI state
-- ============================================================

-- PATCH 1: Sửa trigger function, thêm SECURITY DEFINER + bắt lỗi auth.uid()
CREATE OR REPLACE FUNCTION trg_sales_imports_process()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $func$
declare
  v_user_id uuid;
begin
  -- auth.uid() có thể null khi gọi từ service role/trigger context
  v_user_id := coalesce(auth.uid(), null);

  if (TG_OP = 'INSERT') or 
     (TG_OP = 'UPDATE' and new.mapping_status = 'UNMAPPED' and old.mapping_status <> 'UNMAPPED') or 
     (TG_OP = 'UPDATE' and new.is_processed = false and old.is_processed = true) then
    if new.is_processed = false and new.mapping_status <> 'NO_STOCK_IMPACT' then
      perform process_single_sale_import(new.id, v_user_id);
    end if;
  end if;
  return new;
end;
$func$;

-- PATCH 2: Sửa process_single_sale_import để cũng hoạt động khi p_user_id = NULL
CREATE OR REPLACE FUNCTION process_single_sale_import(p_sale_id uuid, p_user_id uuid DEFAULT NULL)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $func$
declare
  r_sale record;
  r_menu record;
  r_recipe record;
  r_child record;
  r_pkg record;
  v_qty_to_deduct numeric;
  v_wac_price numeric;
  v_location_id text;
  v_source text;
  v_mapped_item_id text;
begin
  select * into r_sale from sales_imports where id = p_sale_id;
  if r_sale is null or r_sale.is_processed then
    return;
  end if;

  -- Clean up any existing transactions for this sale import before reprocessing
  delete from inventory_transactions
  where ref_table = 'sales_imports' and ref_id = p_sale_id::text;

  -- Resolve POS code to recipe/menu_item code using pos_alias_map
  select menu_item_id into v_mapped_item_id
  from pos_alias_map
  where pos_code = r_sale.menu_item_id;

  if v_mapped_item_id is null then
    v_mapped_item_id := r_sale.menu_item_id;
  end if;

  select * into r_menu from menu_items where id = v_mapped_item_id;
  if r_menu is null then
    update sales_imports set mapping_status = 'UNMAPPED' where id = p_sale_id;
    return;
  end if;

  v_source := case when r_sale.file_hash is null then 'MANUAL_SALE' else 'POS' end;

  -- NON_STOCK
  if r_menu.deduction_type = 'NON_STOCK' then
    update sales_imports set mapping_status = 'NO_STOCK_IMPACT', is_processed = true where id = p_sale_id;
    return;
  end if;

  -- DIRECT (1:1)
  if r_menu.deduction_type = 'DIRECT' then
    declare
      v_ing_id uuid;
      v_wac numeric;
    begin
      select i.id, i.wac_price into v_ing_id, v_wac
      from ingredients i
      where i.id::text = v_mapped_item_id or i.code = v_mapped_item_id
      limit 1;

      if v_ing_id is null then
        update sales_imports set mapping_status = 'UNMAPPED' where id = p_sale_id;
        return;
      end if;

      v_location_id := case when (select is_beverage from ingredients where id = v_ing_id) then 'BAR' else 'KITCHEN' end;
      v_qty_to_deduct := r_sale.qty_sold - coalesce(r_sale.void_qty,0) - coalesce(r_sale.comp_qty,0);
      
      if v_qty_to_deduct > 0 then
        perform deplete_stock_fefo(
          v_ing_id, v_qty_to_deduct, 'SALE_DEPLETION', 'sales_imports', r_sale.id::varchar, r_sale.import_date, p_user_id, v_location_id, v_source
        );
      end if;

      if coalesce(r_sale.comp_qty,0) > 0 then
        perform deplete_stock_fefo(
          v_ing_id, r_sale.comp_qty, 'NON_SALE', 'sales_imports', r_sale.id::varchar, r_sale.import_date, p_user_id, v_location_id, v_source, 'COMP món tặng'
        );
      end if;

      update sales_imports set mapping_status = 'MAPPED', is_processed = true where id = p_sale_id;
      return;
    end;
  end if;

  -- RECIPE (BOM)
  if r_menu.deduction_type = 'RECIPE' then
    if r_menu.is_set_menu then
      if not exists (select 1 from set_menu_items where parent_menu_item_id = v_mapped_item_id) then
        update sales_imports set mapping_status = 'UNMAPPED' where id = p_sale_id;
        return;
      end if;

      for r_child in select * from set_menu_items where parent_menu_item_id = v_mapped_item_id loop
        for r_recipe in 
          select r.*, i.stock_to_recipe_factor, i.is_beverage
          from recipes r
          join ingredients i on r.ingredient_id = i.id
          where r.menu_item_id = r_child.child_menu_item_id
        loop
          v_location_id := case when r_recipe.is_beverage then 'BAR' else 'KITCHEN' end;
          v_qty_to_deduct := (r_recipe.qty_eff * r_child.portion_ratio * (r_sale.qty_sold - coalesce(r_sale.void_qty,0) - coalesce(r_sale.comp_qty,0))) / r_recipe.stock_to_recipe_factor;
          
          if v_qty_to_deduct > 0 then
            perform deplete_stock_fefo(
              r_recipe.ingredient_id, v_qty_to_deduct, 'SALE_DEPLETION', 'sales_imports', r_sale.id::varchar, r_sale.import_date, p_user_id, v_location_id, v_source
            );
          end if;

          if coalesce(r_sale.comp_qty,0) > 0 then
            v_qty_to_deduct := (r_recipe.qty_eff * r_child.portion_ratio * r_sale.comp_qty) / r_recipe.stock_to_recipe_factor;
            perform deplete_stock_fefo(
              r_recipe.ingredient_id, v_qty_to_deduct, 'NON_SALE', 'sales_imports', r_sale.id::varchar, r_sale.import_date, p_user_id, v_location_id, v_source, 'COMP món tặng'
            );
          end if;
        end loop;
      end loop;
    else
      if not exists (select 1 from recipes where menu_item_id = v_mapped_item_id) then
        update sales_imports set mapping_status = 'UNMAPPED' where id = p_sale_id;
        return;
      end if;

      for r_recipe in 
        select r.*, i.stock_to_recipe_factor, i.is_beverage
        from recipes r
        join ingredients i on r.ingredient_id = i.id
        where r.menu_item_id = v_mapped_item_id
      loop
        v_location_id := case when r_recipe.is_beverage then 'BAR' else 'KITCHEN' end;
        v_qty_to_deduct := (r_recipe.qty_eff * (r_sale.qty_sold - coalesce(r_sale.void_qty,0) - coalesce(r_sale.comp_qty,0))) / r_recipe.stock_to_recipe_factor;

        if v_qty_to_deduct > 0 then
          perform deplete_stock_fefo(
            r_recipe.ingredient_id, v_qty_to_deduct, 'SALE_DEPLETION', 'sales_imports', r_sale.id::varchar, r_sale.import_date, p_user_id, v_location_id, v_source
          );
        end if;

        if coalesce(r_sale.comp_qty,0) > 0 then
          v_qty_to_deduct := (r_recipe.qty_eff * r_sale.comp_qty) / r_recipe.stock_to_recipe_factor;
          perform deplete_stock_fefo(
            r_recipe.ingredient_id, v_qty_to_deduct, 'NON_SALE', 'sales_imports', r_sale.id::varchar, r_sale.import_date, p_user_id, v_location_id, v_source, 'COMP món tặng'
          );
        end if;
      end loop;
    end if;

    -- Trừ bao bì mang về nếu order_type = TAKEAWAY
    if r_sale.order_type = 'TAKEAWAY' then
      for r_pkg in 
        select m.*, i.is_beverage
        from takeaway_packaging_map m
        join ingredients i on m.packaging_id = i.id
        where m.pos_item_code = r_sale.menu_item_id
      loop
        v_qty_to_deduct := r_pkg.qty_per_unit * (r_sale.qty_sold - coalesce(r_sale.void_qty,0));
        v_location_id := case when r_pkg.is_beverage then 'BAR' else 'KITCHEN' end;

        if v_qty_to_deduct > 0 then
          perform deplete_stock_fefo(
            r_pkg.packaging_id, v_qty_to_deduct, 'SALE_DEPLETION', 'sales_imports', r_sale.id::varchar, r_sale.import_date, p_user_id, v_location_id, v_source, 'Trừ bao bì takeaway'
          );
        end if;
      end loop;
    end if;

    update sales_imports set mapping_status = 'MAPPED', is_processed = true where id = p_sale_id;
  end if;
end;
$func$;

-- PATCH 3: RPC để tái xử lý toàn bộ sales_imports chưa processed (dọn dẹp tồn đọng)
CREATE OR REPLACE FUNCTION reprocess_unprocessed_sales(p_date date DEFAULT NULL)
RETURNS table(processed int, failed int, unmapped int)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $func$
declare
  v_processed int := 0;
  v_failed int := 0;
  v_unmapped int := 0;
  r record;
begin
  for r in 
    select id, mapping_status from sales_imports
    where is_processed = false 
      and mapping_status <> 'NO_STOCK_IMPACT'
      and (p_date is null or import_date = p_date)
    order by import_date asc
  loop
    begin
      perform process_single_sale_import(r.id, null);
      -- Kiểm tra kết quả
      if exists (select 1 from sales_imports where id = r.id and mapping_status = 'UNMAPPED') then
        v_unmapped := v_unmapped + 1;
      else
        v_processed := v_processed + 1;
      end if;
    exception when others then
      v_failed := v_failed + 1;
    end;
  end loop;
  
  return query select v_processed, v_failed, v_unmapped;
end;
$func$;

-- PATCH 4: Thêm RPC lấy tồn kho realtime theo location (dùng trong UI)
CREATE OR REPLACE FUNCTION get_stock_levels(p_location_id text DEFAULT NULL)
RETURNS table(ingredient_id uuid, qty_on_hand numeric, location_id text)
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = public
AS $func$
  SELECT 
    s.ingredient_id,
    s.qty_on_hand,
    s.location_id
  FROM v_stock_on_hand s
  WHERE (p_location_id IS NULL OR s.location_id = p_location_id);
$func$;

-- PATCH 5: Chạy reprocess ngay cho tất cả sales_imports chưa xử lý
SELECT * FROM reprocess_unprocessed_sales();
