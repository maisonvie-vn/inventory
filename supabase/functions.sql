-- MAISON VIE INVENTORY AUTOMATED BACKEND FUNCTIONS
-- Target: PostgreSQL / PL/pgSQL on Supabase
-- Contains: Moving WAC calculation at 18:30, Set Menu decomposition at 22:30, and Auto-PO at 22:40

-- =========================================================================
-- 1. CALCULATE MOVING WAC AT 18:30 (DAILY LOCK & RE-PRICING)
-- =========================================================================

create or replace function calculate_moving_wac(p_date date)
returns void as $$
declare
  r_ing record;
  v_opening_qty numeric(12, 4);
  v_opening_val numeric(12, 2);
  v_purchased_qty numeric(12, 4);
  v_purchased_val numeric(12, 2);
  v_new_wac numeric(12, 2);
begin
  -- Loop through all active ingredients in master
  for r_ing in 
    select id, wac_price, standard_price 
    from ingredients 
    where is_active = true
  loop
    -- 1. Compute opening quantity before today (sum of all approved transactions before p_date)
    select coalesce(sum(qty), 0)
    into v_opening_qty
    from inventory_transactions
    where ingredient_id = r_ing.id
      and created_at::date < p_date
      and status = 'approved';
      
    -- Opening value = opening quantity * yesterday's WAC price
    v_opening_val := v_opening_qty * r_ing.wac_price;
    
    -- 2. Compute purchases made today before 18:30 deadline
    select 
      coalesce(sum(qty), 0), 
      coalesce(sum(qty * unit_price), 0)
    into v_purchased_qty, v_purchased_val
    from inventory_transactions
    where ingredient_id = r_ing.id
      and created_at::date = p_date
      and created_at::time <= '18:30:00'::time
      and type = 'import'
      and status = 'approved';
      
    -- 3. Calculate new Moving WAC
    if (v_opening_qty + v_purchased_qty) > 0 then
      v_new_wac := (v_opening_val + v_purchased_val) / (v_opening_qty + v_purchased_qty);
    else
      -- Fallback to current WAC or standard price if total quantity is 0
      v_new_wac := coalesce(nullif(r_ing.wac_price, 0), r_ing.standard_price);
    end if;
    
    -- 4. Update the WAC price of the ingredient in Master (affects future consumption costing)
    update ingredients
    set wac_price = round(v_new_wac, 2)
    where id = r_ing.id;
  end loop;
end;
$$ language plpgsql security definer;

-- =========================================================================
-- 2. DECOMPOSE SET/TASTING MENU & AUTO-DEDUCT STOCK AT 22:30
-- =========================================================================

create or replace function process_daily_consumption(p_date date, p_user_id uuid)
returns void as $$
declare
  r_sale record;
  r_child record;
  r_recipe record;
  r_waste record;
  v_qty_to_deduct numeric(12, 4);
  v_wac_price numeric(12, 2);
  v_note text;
begin
  -- 1. Loop through sales imported for the given date that are not yet processed
  for r_sale in 
    select s.id, s.menu_item_id, s.qty_sold, m.is_set_menu, m.name 
    from sales_imports s
    join menu_items m on s.menu_item_id = m.id
    where s.import_date = p_date and s.is_processed = false
  loop
    if r_sale.is_set_menu then
      -- 1A. Set Menu / Tasting Menu: Decompose into children (sub-dishes)
      for r_child in 
        select child_menu_item_id, portion_ratio 
        from set_menu_items 
        where parent_menu_item_id = r_sale.menu_item_id
      loop
        -- For each child menu item, fetch the recipe ingredients
        for r_recipe in 
          select ingredient_id, qty_eff 
          from recipes 
          where menu_item_id = r_child.child_menu_item_id
        loop
          -- Apply portion scaling (e.g. 70% for tasting portions) and 10% wastage buffer
          v_qty_to_deduct := r_recipe.qty_eff * r_child.portion_ratio * r_sale.qty_sold * 1.10;
          
          -- Read current chốt WAC price (calculated at 18:30)
          select wac_price into v_wac_price from ingredients where id = r_recipe.ingredient_id;
          
          v_note := 'Trừ kho lý thuyết Set Menu: ' || r_sale.name || ' (Phân rã: ' || r_child.child_menu_item_id || ' x' || (r_child.portion_ratio*100)::integer || '%)';
          
          -- Insert transaction of type 'consumption' (negative qty)
          insert into inventory_transactions (
            ingredient_id, type, qty, unit_price, status, reference_id, note, created_by, created_at
          ) values (
            r_recipe.ingredient_id, 'consumption', -v_qty_to_deduct, v_wac_price, 'approved', r_sale.id::varchar, v_note, p_user_id, p_date::timestamp + '22:30:00'::interval
          );
        end loop;
      end loop;
    else
      -- 1B. À La Carte dish: Deduct based on standard recipe directly
      for r_recipe in 
        select ingredient_id, qty_eff 
        from recipes 
        where menu_item_id = r_sale.menu_item_id
      loop
        -- Apply standard 10% wastage buffer
        v_qty_to_deduct := r_recipe.qty_eff * r_sale.qty_sold * 1.10;
        
        select wac_price into v_wac_price from ingredients where id = r_recipe.ingredient_id;
        
        v_note := 'Trừ kho lý thuyết À La Carte: ' || r_sale.name;
        
        insert into inventory_transactions (
          ingredient_id, type, qty, unit_price, status, reference_id, note, created_by, created_at
        ) values (
          r_recipe.ingredient_id, 'consumption', -v_qty_to_deduct, v_wac_price, 'approved', r_sale.id::varchar, v_note, p_user_id, p_date::timestamp + '22:30:00'::interval
        );
      end loop;
    end if;
    
    -- Mark this POS record as processed
    update sales_imports set is_processed = true where id = r_sale.id;
  end loop;

  -- 2. Aggregate Shift Waste Logs entered by Sous Chefs and approved by Managers
  for r_waste in 
    select w.id, w.ingredient_id, w.qty, w.reason
    from waste_logs w
    where w.created_at::date = p_date and w.status = 'approved' and w.is_processed = false
  loop
    select wac_price into v_wac_price from ingredients where id = r_waste.ingredient_id;
    
    -- Insert transaction of type 'waste' (negative qty)
    insert into inventory_transactions (
      ingredient_id, type, qty, unit_price, status, reference_id, note, created_by, created_at
    ) values (
      r_waste.ingredient_id, 'waste', -r_waste.qty, v_wac_price, 'approved', r_waste.id::varchar, 'Hao phí bếp (Waste Log): ' || r_waste.reason, p_user_id, p_date::timestamp + '22:30:00'::interval
    );
    
    -- Mark waste log as processed
    update waste_logs set is_processed = true where id = r_waste.id;
  end loop;
end;
$$ language plpgsql security definer;

-- =========================================================================
-- 3. FILTER INGREDIENTS & GENERATE AUTO-PO AT 22:40
-- =========================================================================

create or replace function generate_auto_po(p_date date, p_user_id uuid)
returns table (po_number_out varchar, category_name varchar, items_count integer) as $$
declare
  r_ing record;
  v_stock numeric(12, 4);
  v_po_qty numeric(12, 4);
  v_po_id uuid;
  v_po_num varchar;
  v_cat_code varchar;
  v_cat_name varchar;
  v_detail_count integer := 0;
begin
  -- Create temporary table to collect ingredients requiring order
  create temp table temp_po_items (
    ingredient_id varchar(50),
    cat_code varchar(50),
    cat_name varchar(100),
    po_qty numeric(12, 4),
    price numeric(12, 2)
  ) on commit drop;

  -- 1. Scan and calculate current stock levels for ingredients in the 'AUTO_PO' group
  for r_ing in 
    select i.id, i.min_stock, i.max_stock, i.standard_price, c.code as cat_code, c.name as cat_name
    from ingredients i
    join purchase_categories c on i.purchase_category_id = c.id
    where i.is_active = true and i.auto_po_group = 'AUTO_PO'
  loop
    -- Calculate current stock as the sum of all approved transaction quantities
    select coalesce(sum(qty), 0)
    into v_stock
    from inventory_transactions
    where ingredient_id = r_ing.id and status = 'approved';
    
    -- If stock falls below the minimum threshold, order up to max stock
    if v_stock < r_ing.min_stock then
      v_po_qty := r_ing.max_stock - v_stock;
      if v_po_qty > 0 then
        insert into temp_po_items (ingredient_id, cat_code, cat_name, po_qty, price)
        values (r_ing.id, r_ing.cat_code, r_ing.cat_name, v_po_qty, r_ing.standard_price);
      end if;
    end if;
  end loop;

  -- 2. Create Purchase Orders grouped by vendor category
  for v_cat_code, v_cat_name in 
    select distinct cat_code, cat_name from temp_po_items
  loop
    -- PO number format: PO-YYYYMMDD-CATCODE (e.g. PO-20260614-THIT)
    v_po_num := 'PO-' || to_char(p_date, 'YYYYMMDD') || '-' || v_cat_code;
    
    -- Ensure PO doesn't already exist for this date/category
    select id into v_po_id from purchase_orders where po_number = v_po_num;
    
    if v_po_id is null then
      insert into purchase_orders (po_number, category_code, order_date, status)
      values (v_po_num, v_cat_code, p_date, 'draft')
      returning id into v_po_id;
    end if;
    
    -- Insert PO details
    v_detail_count := 0;
    for r_ing in 
      select ingredient_id, po_qty, price 
      from temp_po_items 
      where cat_code = v_cat_code
    loop
      if not exists (
        select 1 from purchase_order_details 
        where purchase_order_id = v_po_id and ingredient_id = r_ing.ingredient_id
      ) then
        insert into purchase_order_details (purchase_order_id, ingredient_id, qty_ordered, unit_price)
        values (v_po_id, r_ing.ingredient_id, r_ing.po_qty, r_ing.price);
        v_detail_count := v_detail_count + 1;
      end if;
    end loop;
    
    -- Return PO metadata to the caller
    if v_detail_count > 0 then
      po_number_out := v_po_num;
      category_name := v_cat_name;
      items_count := v_detail_count;
      return next;
    end if;
  end loop;
end;
$$ language plpgsql security definer;
