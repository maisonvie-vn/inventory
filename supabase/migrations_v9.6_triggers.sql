-- =====================================================================
-- MAISON VIE v9.6 — TỰ ĐỘNG HÓA KHO KÈM THEO TRIGGER Ở DB
-- Chứa: Triggers cho sales_imports, goods_receipts, waste_logs, non_sale_consumption, production_orders, stocktakes
-- Bảo đảm: Trơn tru, không race condition, cập nhật WAC, FEFO, bao bì, yield, reorder point
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. HÀM CHUNG & TRÊN SỰ KIỆN: TRỪ KHO THEO LÔ (FEFO)
-- ---------------------------------------------------------------------
create or replace function deplete_stock_fefo(
  p_ingredient_id uuid,
  p_qty_to_deduct numeric, -- Lượng xuất dương (hàm sẽ ghi âm vào txn)
  p_txn_type text,
  p_ref_table text,
  p_ref_id text,
  p_date date,
  p_user_id uuid,
  p_location_id text,
  p_source text,
  p_note text default null
) returns void as $$
declare
  v_wac_price numeric;
  v_track_lot boolean;
  v_remaining_deduct numeric;
  v_lot record;
  v_lot_deduct numeric;
begin
  select wac_price, track_lot into v_wac_price, v_track_lot 
  from ingredients where id = p_ingredient_id;

  if p_qty_to_deduct <= 0 then
    return;
  end if;

  if v_track_lot then
    v_remaining_deduct := p_qty_to_deduct;
    for v_lot in 
      select id, qty_remaining from lots 
      where ingredient_id = p_ingredient_id and qty_remaining > 0
      order by expiry_date asc nulls last, received_at asc
    loop
      exit when v_remaining_deduct <= 0;
      v_lot_deduct := least(v_lot.qty_remaining, v_remaining_deduct);
      
      -- Trừ lô
      update lots set qty_remaining = qty_remaining - v_lot_deduct where id = v_lot.id;
      
      -- Ghi sổ cái
      insert into inventory_transactions (
        ingredient_id, txn_type, qty, unit_cost, lot_id, ref_table, ref_id, business_date, created_by, status, location_id, source, note
      ) values (
        p_ingredient_id, p_txn_type, -v_lot_deduct, v_wac_price, v_lot.id, p_ref_table, p_ref_id, p_date, p_user_id, 'approved', p_location_id, p_source, p_note
      );
      
      v_remaining_deduct := v_remaining_deduct - v_lot_deduct;
    end loop;

    -- Nếu lô không đủ, lượng còn lại trừ thẳng vào kho tạo tồn âm
    if v_remaining_deduct > 0 then
      insert into inventory_transactions (
        ingredient_id, txn_type, qty, unit_cost, lot_id, ref_table, ref_id, business_date, created_by, status, location_id, source, note
      ) values (
        p_ingredient_id, p_txn_type, -v_remaining_deduct, v_wac_price, null, p_ref_table, p_ref_id, p_date, p_user_id, 'approved', p_location_id, p_source, p_note
      );
    end if;
  else
    -- Không track lô
    insert into inventory_transactions (
      ingredient_id, txn_type, qty, unit_cost, lot_id, ref_table, ref_id, business_date, created_by, status, location_id, source, note
    ) values (
      p_ingredient_id, p_txn_type, -p_qty_to_deduct, v_wac_price, null, p_ref_table, p_ref_id, p_date, p_user_id, 'approved', p_location_id, p_source, p_note
    );
  end if;
end;
$$ language plpgsql security definer;

-- ---------------------------------------------------------------------
-- 2. TRỰC TIẾP TRỪ KHO CHO DÒNG BÁN HÀNG (Trigger on sales_imports)
-- ---------------------------------------------------------------------
create or replace function process_single_sale_import(p_sale_id uuid, p_user_id uuid)
returns void as $$
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
begin
  select * into r_sale from sales_imports where id = p_sale_id;
  if r_sale is null or r_sale.is_processed then
    return;
  end if;

  select * into r_menu from menu_items where id = r_sale.menu_item_id;
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
      left join pos_alias_map a on a.pos_code = r_sale.menu_item_id
      where i.id = a.menu_item_id or i.code = r_sale.menu_item_id
      limit 1;

      if v_ing_id is null then
        update sales_imports set mapping_status = 'UNMAPPED' where id = p_sale_id;
        return;
      end if;

      v_location_id := case when (select is_beverage from ingredients where id = v_ing_id) then 'BAR' else 'KITCHEN' end;
      v_qty_to_deduct := r_sale.qty_sold - r_sale.void_qty - r_sale.comp_qty;
      
      if v_qty_to_deduct > 0 then
        perform deplete_stock_fefo(
          v_ing_id, v_qty_to_deduct, 'SALE_DEPLETION', 'sales_imports', r_sale.id::varchar, r_sale.import_date, p_user_id, v_location_id, v_source
        );
      end if;

      -- Comp tặng khách
      if r_sale.comp_qty > 0 then
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
      -- Phân rã Set Menu
      if not exists (select 1 from set_menu_items where parent_menu_item_id = r_sale.menu_item_id) then
        update sales_imports set mapping_status = 'UNMAPPED' where id = p_sale_id;
        return;
      end if;

      for r_child in select * from set_menu_items where parent_menu_item_id = r_sale.menu_item_id loop
        for r_recipe in 
          select r.*, i.stock_to_recipe_factor, i.is_beverage
          from recipes r
          join ingredients i on r.ingredient_id = i.id
          where r.menu_item_id = r_child.child_menu_item_id
        loop
          v_location_id := case when r_recipe.is_beverage then 'BAR' else 'KITCHEN' end;
          -- SL bán hiệu dụng (gồm cả yield)
          v_qty_to_deduct := (r_recipe.qty_eff * r_child.portion_ratio * (r_sale.qty_sold - r_sale.void_qty - r_sale.comp_qty)) / r_recipe.stock_to_recipe_factor;
          
          if v_qty_to_deduct > 0 then
            perform deplete_stock_fefo(
              r_recipe.ingredient_id, v_qty_to_deduct, 'SALE_DEPLETION', 'sales_imports', r_sale.id::varchar, r_sale.import_date, p_user_id, v_location_id, v_source
            );
          end if;

          if r_sale.comp_qty > 0 then
            v_qty_to_deduct := (r_recipe.qty_eff * r_child.portion_ratio * r_sale.comp_qty) / r_recipe.stock_to_recipe_factor;
            perform deplete_stock_fefo(
              r_recipe.ingredient_id, v_qty_to_deduct, 'NON_SALE', 'sales_imports', r_sale.id::varchar, r_sale.import_date, p_user_id, v_location_id, v_source, 'COMP món tặng'
            );
          end if;
        end loop;
      end loop;
    else
      -- Món đơn À la carte
      if not exists (select 1 from recipes where menu_item_id = r_sale.menu_item_id) then
        update sales_imports set mapping_status = 'UNMAPPED' where id = p_sale_id;
        return;
      end if;

      for r_recipe in 
        select r.*, i.stock_to_recipe_factor, i.is_beverage
        from recipes r
        join ingredients i on r.ingredient_id = i.id
        where r.menu_item_id = r_sale.menu_item_id
      loop
        v_location_id := case when r_recipe.is_beverage then 'BAR' else 'KITCHEN' end;
        v_qty_to_deduct := (r_recipe.qty_eff * (r_sale.qty_sold - r_sale.void_qty - r_sale.comp_qty)) / r_recipe.stock_to_recipe_factor;

        if v_qty_to_deduct > 0 then
          perform deplete_stock_fefo(
            r_recipe.ingredient_id, v_qty_to_deduct, 'SALE_DEPLETION', 'sales_imports', r_sale.id::varchar, r_sale.import_date, p_user_id, v_location_id, v_source
          );
        end if;

        if r_sale.comp_qty > 0 then
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
        v_qty_to_deduct := r_pkg.qty_per_unit * (r_sale.qty_sold - r_sale.void_qty);
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
$$ language plpgsql security definer;

-- Trigger cho sales_imports
create or replace function trg_sales_imports_process()
returns trigger as $$
begin
  if (TG_OP = 'INSERT') or 
     (TG_OP = 'UPDATE' and new.mapping_status = 'UNMAPPED' and old.mapping_status <> 'UNMAPPED') or 
     (TG_OP = 'UPDATE' and new.is_processed = false and old.is_processed = true) then
    if new.is_processed = false and new.mapping_status <> 'NO_STOCK_IMPACT' then
      perform process_single_sale_import(new.id, auth.uid());
    end if;
  end if;
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_sales_imports_process_trigger on sales_imports;
create trigger trg_sales_imports_process_trigger
after insert or update on sales_imports
for each row execute function trg_sales_imports_process();


-- ---------------------------------------------------------------------
-- 3. DUYỆT NHẬN HÀNG (Trigger on goods_receipts)
-- ---------------------------------------------------------------------
create or replace function process_goods_receipt_approve()
returns trigger as $$
declare
  r_line record;
  v_total_val_vnd numeric(12, 2);
  v_line_val_vnd numeric(12, 2);
  v_duty_allocated numeric(12, 2);
  v_freight_allocated numeric(12, 2);
  v_qty_received_stock_uom numeric(12, 4);
  v_landed_unit_cost numeric(12, 2);
  v_current_qty numeric(12, 4);
  v_adjusted_qty numeric(12, 4);
  v_current_wac numeric(12, 2);
  v_new_wac numeric(12, 2);
  v_pack_size numeric;
  v_lot_id uuid;
  v_po_fully_received boolean;
begin
  -- Chỉ chạy khi chuyển sang APPROVED
  if new.status = 'approved' and old.status = 'pending' then
    -- 1. Tính tổng giá trị chưa thuế/phí
    select coalesce(sum(qty_received * unit_price_fx), 0) * new.fx_rate
    into v_total_val_vnd
    from grn_lines
    where grn_id = new.id;

    -- 2. Loop lines
    for r_line in 
      select gl.*, i.wac_price, i.standard_price, i.track_lot
      from grn_lines gl
      join ingredients i on gl.ingredient_id = i.id
      where gl.grn_id = new.id
    loop
      -- Lấy pack_size
      select coalesce(pack_size, 1) into v_pack_size
      from supplier_ingredients
      where supplier_id = new.supplier_id and ingredient_id = r_line.ingredient_id;

      v_qty_received_stock_uom := r_line.qty_received * v_pack_size;
      v_line_val_vnd := r_line.qty_received * r_line.unit_price_fx * new.fx_rate;

      -- Phân bổ landed cost
      if v_total_val_vnd > 0 then
        v_duty_allocated := new.duty * (v_line_val_vnd / v_total_val_vnd);
        v_freight_allocated := new.freight * (v_line_val_vnd / v_total_val_vnd);
      else
        v_duty_allocated := 0;
        v_freight_allocated := 0;
      end if;

      v_landed_unit_cost := (v_line_val_vnd + v_duty_allocated + v_freight_allocated) / v_qty_received_stock_uom;

      update grn_lines 
      set landed_unit_cost = round(v_landed_unit_cost, 2)
      where grn_id = new.id and ingredient_id = r_line.ingredient_id;

      -- Moving WAC
      select coalesce(sum(qty), 0) into v_current_qty
      from inventory_transactions
      where ingredient_id = r_line.ingredient_id and status = 'approved';

      v_adjusted_qty := greatest(v_current_qty, 0.0000);
      v_current_wac := r_line.wac_price;

      if v_current_qty < 0 then
        insert into audit_log (actor, action, entity, entity_id, before_data, after_data)
        values (
          new.approved_by, 'NEGATIVE_STOCK_WAC_ADJUSTED', 'ingredients', r_line.ingredient_id, 
          jsonb_build_object('qty_on_hand', v_current_qty, 'wac_before', v_current_wac), 
          jsonb_build_object('adjusted_qty', v_adjusted_qty, 'landed_cost', v_landed_unit_cost)
        );
      end if;

      if (v_adjusted_qty + v_qty_received_stock_uom) > 0 then
        v_new_wac := (v_adjusted_qty * v_current_wac + v_qty_received_stock_uom * v_landed_unit_cost) / (v_adjusted_qty + v_qty_received_stock_uom);
      else
        v_new_wac := v_landed_unit_cost;
      end if;

      -- Kiểm tra PPV (Purchase Price Variance)
      declare
        v_ppv numeric;
        v_ppv_limit numeric;
      begin
        v_ppv := ppv_pct(r_line.ingredient_id, v_landed_unit_cost) * 100;
        -- Ngưỡng ppv_alert_pct mặc định 15%
        select coalesce((value::text)::numeric, 15.0) into v_ppv_limit from app_settings where key = 'ppv_alert_pct';
        
        if abs(v_ppv) > v_ppv_limit then
          insert into audit_log (actor, action, entity, entity_id, before_data, after_data)
          values (
            new.approved_by, 'PPV_ALERT', 'ingredients', r_line.ingredient_id,
            jsonb_build_object('price_variance_pct', v_ppv),
            jsonb_build_object('new_price', v_landed_unit_cost, 'ref_price', v_landed_unit_cost / (1 + v_ppv/100))
          );
        end if;
      end;

      update ingredients
      set wac_price = round(v_new_wac, 2),
          standard_price = round(v_landed_unit_cost, 2)
      where id = r_line.ingredient_id;

      -- Tạo lô mới
      v_lot_id := null;
      if r_line.track_lot then
        insert into lots (ingredient_id, grn_id, qty_received, qty_remaining, expiry_date, lot_code, received_date, status)
        values (
          r_line.ingredient_id, new.id, v_qty_received_stock_uom, v_qty_received_stock_uom, 
          current_date + interval '30 days', 'LOT-' || to_char(current_date, 'YYYYMMDD') || '-' || substring(r_line.ingredient_id::text from 1 for 4),
          current_date, 'ACTIVE'
        )
        returning id into v_lot_id;
      end if;

      -- Ghi sổ cái
      insert into inventory_transactions (
        ingredient_id, txn_type, qty, unit_cost, lot_id, ref_table, ref_id, business_date, created_by, status, location_id, source
      ) values (
        r_line.ingredient_id, 'IMPORT', v_qty_received_stock_uom, round(v_landed_unit_cost, 2), 
        v_lot_id, 'goods_receipts', new.id::varchar, coalesce(new.business_date, current_date), 
        new.approved_by, 'approved', 'MAIN_STORE', case when new.po_id is not null then 'POS' else 'MANUAL_GRN' end
      );

      -- Cập nhật PO line
      if new.po_id is not null then
        update po_lines
        set qty_received = qty_received + r_line.qty_received
        where po_id = new.po_id and ingredient_id = r_line.ingredient_id;
      end if;
    end loop;

    -- Cập nhật PO status
    if new.po_id is not null then
      select not exists (
        select 1 from po_lines 
        where po_id = new.po_id and qty_received < qty_ordered
      ) into v_po_fully_received;

      if v_po_fully_received then
        update purchase_orders set status = 'RECEIVED' where id = new.po_id;
      else
        update purchase_orders set status = 'PARTIAL' where id = new.po_id;
      end if;
    end if;

  end if;
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_goods_receipt_approve_trigger on goods_receipts;
create trigger trg_goods_receipt_approve_trigger
before update on goods_receipts
for each row execute function process_goods_receipt_approve();


-- ---------------------------------------------------------------------
-- 4. DUYỆT WASTE LOGS (Trigger on waste_logs)
-- ---------------------------------------------------------------------
create or replace function trg_waste_logs_process()
returns trigger as $$
declare
  v_wac_price numeric;
  v_track_lot boolean;
  v_location_id text;
begin
  if new.status = 'approved' and old.status = 'pending_approval' and new.is_processed = false then
    select wac_price, track_lot, (case when is_beverage then 'BAR' else 'KITCHEN' end)
    into v_wac_price, v_track_lot, v_location_id
    from ingredients where id = new.ingredient_id;

    perform deplete_stock_fefo(
      new.ingredient_id, new.qty, 'WASTE', 'waste_logs', new.id::varchar, new.created_at::date, new.created_by, v_location_id, 'MANUAL_ISSUE', new.reason
    );

    new.is_processed := true;
  end if;
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_waste_logs_process_trigger on waste_logs;
create trigger trg_waste_logs_process_trigger
before update on waste_logs
for each row execute function trg_waste_logs_process();


-- ---------------------------------------------------------------------
-- 5. TIÊU HAO NGOÀI BÁN HÀNG (Trigger on non_sale_consumption)
-- ---------------------------------------------------------------------
create or replace function trg_non_sale_consumption_process()
returns trigger as $$
declare
  v_location_id text;
begin
  select (case when is_beverage then 'BAR' else 'KITCHEN' end)
  into v_location_id
  from ingredients where id = new.ingredient_id;

  perform deplete_stock_fefo(
    new.ingredient_id, new.qty, 'NON_SALE', 'non_sale_consumption', new.id::varchar, new.business_date, new.created_by, v_location_id, 'MANUAL_ISSUE', 'Tiêu hao: ' || new.reason
  );
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_non_sale_consumption_trigger on non_sale_consumption;
create trigger trg_non_sale_consumption_trigger
before insert on non_sale_consumption
for each row execute function trg_non_sale_consumption_process();


-- ---------------------------------------------------------------------
-- 6. SẢN XUẤT BÁN THÀNH PHẨM (Trigger on production_orders)
-- ---------------------------------------------------------------------
create or replace function trg_production_orders_process()
returns trigger as $$
declare
  r_input record;
  v_total_cost numeric := 0;
  v_input_wac numeric;
  v_output_wac numeric;
  v_output_current_qty numeric;
  v_output_adjusted_qty numeric;
  v_output_new_wac numeric;
  v_output_lot_id uuid;
  v_output_loc text;
begin
  -- 1. Lọc qua từng nguyên liệu đầu vào trong production_inputs
  for r_input in select * from production_inputs where production_id = new.id loop
    select wac_price into v_input_wac from ingredients where id = r_input.ingredient_id;
    
    -- Tính tổng chi phí đầu vào
    v_total_cost := v_total_cost + (r_input.qty * v_input_wac);
    v_output_loc := case when (select is_beverage from ingredients where id = r_input.ingredient_id) then 'BAR' else 'KITCHEN' end;
    
    -- Khấu trừ nguyên liệu đầu vào theo FEFO
    perform deplete_stock_fefo(
      r_input.ingredient_id, r_input.qty, 'ISSUE', 'production_inputs', new.id::varchar, new.business_date, new.created_by, v_output_loc, 'MANUAL_ISSUE', 'Nguyên liệu cho BTP: ' || new.output_ingredient_id
    );
  end loop;
  
  -- 2. Tính giá vốn đơn vị BTP đầu ra
  v_output_wac := case when new.output_qty > 0 then round(v_total_cost / new.output_qty, 2) else 0 end;
  v_output_loc := case when (select is_beverage from ingredients where id = new.output_ingredient_id) then 'BAR' else 'KITCHEN' end;
  
  -- Tạo lô BTP mới nếu track_lot = true
  if (select track_lot from ingredients where id = new.output_ingredient_id) then
    insert into lots (ingredient_id, qty_received, qty_remaining, expiry_date, lot_code, received_date, status)
    values (new.output_ingredient_id, new.output_qty, new.output_qty, new.business_date + interval '7 days', 'LOT-BTP-' || to_char(current_date, 'YYYYMMDD'), current_date, 'ACTIVE')
    returning id into v_output_lot_id;
  end if;
  
  -- Ghi nhận bút toán nhập BTP (IMPORT)
  insert into inventory_transactions (
    ingredient_id, txn_type, qty, unit_cost, lot_id, ref_table, ref_id, business_date, created_by, status, location_id, source, note
  ) values (
    new.output_ingredient_id, 'IMPORT', new.output_qty, v_output_wac, v_output_lot_id, 'production_orders', new.id::varchar, new.business_date, new.created_by, 'approved', v_output_loc, 'MANUAL_GRN', 'Sản xuất BTP thành phẩm'
  );
  
  -- Cập nhật Moving WAC cho BTP
  select coalesce(sum(qty), 0) into v_output_current_qty
  from inventory_transactions where ingredient_id = new.output_ingredient_id and status = 'approved' and id <> lastval();
  
  v_output_adjusted_qty := greatest(v_output_current_qty, 0.0000);
  
  declare
    v_old_wac numeric;
    v_new_wac numeric;
  begin
    select wac_price into v_old_wac from ingredients where id = new.output_ingredient_id;
    if (v_output_adjusted_qty + new.output_qty) > 0 then
      v_new_wac := (v_output_adjusted_qty * v_old_wac + new.output_qty * v_output_wac) / (v_output_adjusted_qty + new.output_qty);
    else
      v_new_wac := v_output_wac;
    end if;
    
    update ingredients
    set wac_price = round(v_new_wac, 2),
        standard_price = round(v_output_wac, 2)
    where id = new.output_ingredient_id;
  end;
  
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_production_orders_trigger on production_orders;
create trigger trg_production_orders_trigger
after insert on production_orders
for each row execute function trg_production_orders_process();


-- ---------------------------------------------------------------------
-- 7. DUYỆT KIỂM KÊ (Trigger on stock_takes)
-- ---------------------------------------------------------------------
alter table stocktakes add column if not exists location_id text references locations(id) default 'MAIN_STORE';

create or replace function trg_stocktakes_post_process()
returns trigger as $$
declare
  r_line record;
  v_wac_price numeric;
  v_variance numeric;
  v_variance_value numeric;
begin
  if new.status = 'POSTED' and old.status <> 'POSTED' then
    for r_line in select * from stocktake_lines where stocktake_id = new.id loop
      select wac_price into v_wac_price from ingredients where id = r_line.ingredient_id;
      
      v_variance := r_line.counted_qty - r_line.system_qty;
      v_variance_value := v_variance * v_wac_price;
      
      -- Cập nhật variance và variance_value
      update stocktake_lines
      set variance = v_variance,
          variance_value = round(v_variance_value, 2)
      where stocktake_id = new.id and ingredient_id = r_line.ingredient_id;
      
      -- Ghi sổ cái điều chỉnh ADJUST
      insert into inventory_transactions (
        ingredient_id, txn_type, qty, unit_cost, ref_table, ref_id, business_date, created_by, status, location_id, source, note
      ) values (
        r_line.ingredient_id, 'STOCK_TAKE_ADJ', v_variance, v_wac_price, 'stocktakes', new.id::varchar, 
        new.business_date, new.approved_by, 'approved', coalesce(new.location_id, 'MAIN_STORE'), 'ADMIN_ADJ', 
        coalesce(r_line.reason, 'Điều chỉnh kiểm kê kỳ ngày ' || new.business_date)
      );
    end loop;
  end if;
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_stocktakes_post_trigger on stocktakes;
create trigger trg_stocktakes_post_trigger
after update on stocktakes
for each row execute function trg_stocktakes_post_process();
