-- MAISON VIE INVENTORY AUTOMATED BACKEND FUNCTIONS **v8.0**
-- Target: PostgreSQL / PL/pgSQL on Supabase
-- Contains: approve_goods_receipt (WAC per-receipt & negative protection), process_daily_consumption (FEFO stock depletion), generate_auto_po (forecasted PO)

-- =========================================================================
-- 1. APPROVE GOODS RECEIPT (WAC PER-RECEIPT & LANDED COST & NEGATIVE PROTECTION)
-- =========================================================================

create or replace function approve_goods_receipt(p_grn_id uuid, p_user_id uuid)
returns void as $$
declare
  r_grn record;
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
  v_track_lot boolean;
  v_standard_price numeric(12, 2);
  v_po_fully_received boolean;
begin
  -- 1. Fetch Goods Receipt Details
  select * into r_grn from goods_receipts where id = p_grn_id;
  if r_grn is null then
    raise exception 'Goods Receipt với ID % không tồn tại.', p_grn_id;
  end if;
  if r_grn.status = 'approved' then
    return; -- Đã duyệt rồi thì bỏ qua
  end if;

  -- 2. Tính tổng giá trị hàng chưa phân bổ thuế/cước (VND) để phân bổ tỷ trọng
  select coalesce(sum(qty_received * unit_price_fx), 0) * r_grn.fx_rate
  into v_total_val_vnd
  from grn_lines
  where grn_id = p_grn_id;

  -- 3. Duyệt từng dòng hàng nhận để tính Landed Cost và cập nhật WAC
  for r_line in 
    select gl.*, i.wac_price, i.standard_price, i.track_lot
    from grn_lines gl
    join ingredients i on gl.ingredient_id = i.id
    where gl.grn_id = p_grn_id
  loop
    -- Lấy quy cách đóng gói pack_size từ bảng giá nhà cung cấp
    select coalesce(pack_size, 1) into v_pack_size
    from supplier_ingredients
    where supplier_id = r_grn.supplier_id and ingredient_id = r_line.ingredient_id;

    v_qty_received_stock_uom := r_line.qty_received * v_pack_size;
    v_line_val_vnd := r_line.qty_received * r_line.unit_price_fx * r_grn.fx_rate;

    -- Phân bổ thuế & cước vận chuyển theo tỷ trọng giá trị hàng hóa
    if v_total_val_vnd > 0 then
      v_duty_allocated := r_grn.duty * (v_line_val_vnd / v_total_val_vnd);
      v_freight_allocated := r_grn.freight * (v_line_val_vnd / v_total_val_vnd);
    else
      v_duty_allocated := 0;
      v_freight_allocated := 0;
    end if;

    -- Landed cost trên một đơn vị tồn (stock_uom)
    v_landed_unit_cost := (v_line_val_vnd + v_duty_allocated + v_freight_allocated) / v_qty_received_stock_uom;

    -- Cập nhật landed cost vào grn_lines để kế toán đối soát
    update grn_lines 
    set landed_unit_cost = round(v_landed_unit_cost, 2)
    where grn_id = p_grn_id and ingredient_id = r_line.ingredient_id;

    -- Lấy tồn kho hiện tại (chỉ gom các phiếu approved)
    select coalesce(sum(qty), 0)
    into v_current_qty
    from inventory_transactions
    where ingredient_id = r_line.ingredient_id and status = 'approved';

    -- [BẢO VỆ TỒN ÂM]: Nếu kho đang bị âm do ghi sổ trễ, coi như tồn hiện tại = 0 để tránh giá vốn ảo
    v_adjusted_qty := greatest(v_current_qty, 0.0000);
    v_current_wac := r_line.wac_price;

    -- Ghi nhận cảnh báo tồn âm nếu thực tế bị âm
    if v_current_qty < 0 then
      insert into audit_log (actor, action, entity, entity_id, before_data, after_data)
      values (
        p_user_id, 
        'NEGATIVE_STOCK_WAC_ADJUSTED', 
        'ingredients', 
        r_line.ingredient_id, 
        jsonb_build_object('qty_on_hand', v_current_qty, 'wac_before', v_current_wac), 
        jsonb_build_object('adjusted_qty', v_adjusted_qty, 'landed_cost', v_landed_unit_cost)
      );
    end if;

    -- Tính Moving WAC mới
    if (v_adjusted_qty + v_qty_received_stock_uom) > 0 then
      v_new_wac := (v_adjusted_qty * v_current_wac + v_qty_received_stock_uom * v_landed_unit_cost) / (v_adjusted_qty + v_qty_received_stock_uom);
    else
      v_new_wac := v_landed_unit_cost;
    end if;

    -- Cập nhật giá WAC mới vào Master
    update ingredients
    set wac_price = round(v_new_wac, 2),
        standard_price = round(v_landed_unit_cost, 2) -- Cập nhật giá chuẩn theo lần mua gần nhất
    where id = r_line.ingredient_id;

    -- Tạo lô hàng mới (lots) nếu bật theo dõi FEFO
    v_lot_id := null;
    if r_line.track_lot then
      insert into lots (ingredient_id, grn_id, qty_remaining, expiry_date)
      -- Mặc định hạn sử dụng là 30 ngày nếu không có thông tin (có thể cập nhật sau)
      values (r_line.ingredient_id, p_grn_id, v_qty_received_stock_uom, current_date + interval '30 days')
      returning id into v_lot_id;
    end if;

    -- Ghi sổ cái giao dịch nhập hàng (IMPORT)
    insert into inventory_transactions (
      ingredient_id, txn_type, qty, unit_cost, lot_id, ref_table, ref_id, business_date, created_by, status
    ) values (
      r_line.ingredient_id, 
      'IMPORT', 
      v_qty_received_stock_uom, 
      round(v_landed_unit_cost, 2), 
      v_lot_id, 
      'goods_receipts', 
      p_grn_id::varchar, 
      coalesce(r_grn.business_date, current_date), 
      p_user_id,
      'approved'
    );

    -- Cập nhật số lượng đã nhận ở PO tương ứng (nếu có PO liên kết)
    if r_grn.po_id is not null then
      update po_lines
      set qty_received = qty_received + r_line.qty_received
      where po_id = r_grn.po_id and ingredient_id = r_line.ingredient_id;
    end if;
  end loop;

  -- 4. Đổi trạng thái Goods Receipt thành APPROVED
  update goods_receipts
  set status = 'approved',
      match_status = 'APPROVED',
      approved_by = p_user_id
  where id = p_grn_id;

  -- 5. Cập nhật trạng thái của PO liên kết nếu đã nhận đủ hàng
  if r_grn.po_id is not null then
    select not exists (
      select 1 from po_lines 
      where po_id = r_grn.po_id and qty_received < qty_ordered
    ) into v_po_fully_received;

    if v_po_fully_received then
      update purchase_orders set status = 'RECEIVED' where id = r_grn.po_id;
    else
      update purchase_orders set status = 'PARTIAL' where id = r_grn.po_id;
    end if;
  end if;
end;
$$ language plpgsql security definer;

-- =========================================================================
-- 2. DECOMPOSE SET/TASTING MENU & STOCK DEPLETION BY FEFO AT 22:30
-- =========================================================================

create or replace function process_daily_consumption(p_date date, p_user_id uuid)
returns void as $$
declare
  r_sale record;
  r_child record;
  r_recipe record;
  r_waste record;
  r_non_sale record;
  v_qty_to_deduct numeric(12, 4);
  v_wac_price numeric(12, 2);
  v_note text;
  v_lot record;
  v_lot_deduct numeric(12, 4);
  v_remaining_deduct numeric(12, 4);
begin
  -- 1. Loop through sales imported for the given date that are not yet processed
  for r_sale in 
    select s.id, s.menu_item_id, s.qty_sold, s.void_qty, s.comp_qty, m.is_set_menu, m.name 
    from sales_imports s
    join menu_items m on s.menu_item_id = m.id
    where s.import_date = p_date and s.is_processed = false
  loop
    -- Chỉ tính số lượng thực bán (loại bỏ void_qty và comp_qty để trừ kho riêng)
    -- comp_qty (tặng khách) sẽ được hạch toán riêng vào Non-sale Consumption để kiểm soát thất thoát
    if (r_sale.qty_sold - r_sale.void_qty - r_sale.comp_qty) <= 0 then
      update sales_imports set is_processed = true where id = r_sale.id;
      continue;
    end if;

    if r_sale.is_set_menu then
      -- 1A. Set Menu / Tasting Menu: Phân rã theo portion_ratio
      for r_child in 
        select child_menu_item_id, portion_ratio 
        from set_menu_items 
        where parent_menu_item_id = r_sale.menu_item_id
      loop
        -- Quét các nguyên liệu trong công thức của món con
        for r_recipe in 
          select r.ingredient_id, r.qty_eff, i.stock_to_recipe_factor, i.wac_price, i.track_lot
          from recipes r
          join ingredients i on r.ingredient_id = i.id
          where r.menu_item_id = r_child.child_menu_item_id
        loop
          -- Tính lượng cần trừ (lượng thô quy về stock_uom, không nhân thêm hệ số 1.10 hao hụt ảo)
          v_qty_to_deduct := (r_recipe.qty_eff * r_child.portion_ratio * (r_sale.qty_sold - r_sale.void_qty - r_sale.comp_qty)) / r_recipe.stock_to_recipe_factor;
          v_wac_price := r_recipe.wac_price;
          v_note := 'Trừ kho bán hàng (Set Menu): ' || r_sale.name || ' -> Phân rã: ' || r_child.child_menu_item_id;

          -- Xử lý xuất kho theo FEFO (nếu track_lot = true)
          if r_recipe.track_lot then
            v_remaining_deduct := v_qty_to_deduct;
            for v_lot in 
              select id, qty_remaining 
              from lots 
              where ingredient_id = r_recipe.ingredient_id and qty_remaining > 0
              order by expiry_date asc nulls last, received_at asc
            loop
              exit when v_remaining_deduct <= 0;
              v_lot_deduct := least(v_lot.qty_remaining, v_remaining_deduct);
              
              -- Trừ số lượng ở lô
              update lots set qty_remaining = qty_remaining - v_lot_deduct where id = v_lot.id;
              
              -- Ghi giao dịch kho gắn với lô
              insert into inventory_transactions (
                ingredient_id, txn_type, qty, unit_cost, lot_id, ref_table, ref_id, business_date, created_by, status
              ) values (
                r_recipe.ingredient_id, 'SALE_DEPLETION', -v_lot_deduct, v_wac_price, v_lot.id, 'sales_imports', r_sale.id::varchar, p_date, p_user_id, 'approved'
              );
              v_remaining_deduct := v_remaining_deduct - v_lot_deduct;
            end loop;

            -- Nếu lô không đủ trừ, lượng còn thiếu trừ thẳng vào kho chung (lot_id = null) tạo tồn âm
            if v_remaining_deduct > 0 then
              insert into inventory_transactions (
                ingredient_id, txn_type, qty, unit_cost, lot_id, ref_table, ref_id, business_date, created_by, status
              ) values (
                r_recipe.ingredient_id, 'SALE_DEPLETION', -v_remaining_deduct, v_wac_price, null, 'sales_imports', r_sale.id::varchar, p_date, p_user_id, 'approved'
              );
            end if;
          else
            -- Không theo dõi lô: Ghi 1 dòng giao dịch duy nhất
            insert into inventory_transactions (
              ingredient_id, txn_type, qty, unit_cost, lot_id, ref_table, ref_id, business_date, created_by, status
            ) values (
              r_recipe.ingredient_id, 'SALE_DEPLETION', -v_qty_to_deduct, v_wac_price, null, 'sales_imports', r_sale.id::varchar, p_date, p_user_id, 'approved'
            );
          end if;
        end loop;
      end loop;
    else
      -- 1B. À La Carte Món đơn: Trừ trực tiếp theo định mức công thức
      for r_recipe in 
        select r.ingredient_id, r.qty_eff, i.stock_to_recipe_factor, i.wac_price, i.track_lot
        from recipes r
        join ingredients i on r.ingredient_id = i.id
        where r.menu_item_id = r_sale.menu_item_id
      loop
        v_qty_to_deduct := (r_recipe.qty_eff * (r_sale.qty_sold - r_sale.void_qty - r_sale.comp_qty)) / r_recipe.stock_to_recipe_factor;
        v_wac_price := r_recipe.wac_price;
        v_note := 'Trừ kho bán hàng (À La Carte): ' || r_sale.name;

        -- FEFO
        if r_recipe.track_lot then
          v_remaining_deduct := v_qty_to_deduct;
          for v_lot in 
            select id, qty_remaining 
            from lots 
            where ingredient_id = r_recipe.ingredient_id and qty_remaining > 0
            order by expiry_date asc nulls last, received_at asc
          loop
            exit when v_remaining_deduct <= 0;
            v_lot_deduct := least(v_lot.qty_remaining, v_remaining_deduct);
            
            update lots set qty_remaining = qty_remaining - v_lot_deduct where id = v_lot.id;
            
            insert into inventory_transactions (
              ingredient_id, txn_type, qty, unit_cost, lot_id, ref_table, ref_id, business_date, created_by, status
            ) values (
              r_recipe.ingredient_id, 'SALE_DEPLETION', -v_lot_deduct, v_wac_price, v_lot.id, 'sales_imports', r_sale.id::varchar, p_date, p_user_id, 'approved'
            );
            v_remaining_deduct := v_remaining_deduct - v_lot_deduct;
          end loop;

          if v_remaining_deduct > 0 then
            insert into inventory_transactions (
              ingredient_id, txn_type, qty, unit_cost, lot_id, ref_table, ref_id, business_date, created_by, status
            ) values (
              r_recipe.ingredient_id, 'SALE_DEPLETION', -v_remaining_deduct, v_wac_price, null, 'sales_imports', r_sale.id::varchar, p_date, p_user_id, 'approved'
            );
          end if;
        else
          insert into inventory_transactions (
            ingredient_id, txn_type, qty, unit_cost, lot_id, ref_table, ref_id, business_date, created_by, status
          ) values (
            r_recipe.ingredient_id, 'SALE_DEPLETION', -v_qty_to_deduct, v_wac_price, null, 'sales_imports', r_sale.id::varchar, p_date, p_user_id, 'approved'
          );
        end if;
      end loop;
    end if;

    -- Đánh dấu dòng bán hàng POS đã xử lý
    update sales_imports set is_processed = true where id = r_sale.id;
  end loop;

  -- 2. Xử lý Waste Logs (Nhật ký hủy hỏng) đã được duyệt
  for r_waste in 
    select w.id, w.ingredient_id, w.qty, w.reason, i.wac_price, i.track_lot
    from waste_logs w
    join ingredients i on w.ingredient_id = i.id
    where w.created_at::date = p_date and w.status = 'approved' and w.is_processed = false
  loop
    v_qty_to_deduct := r_waste.qty;
    v_wac_price := r_waste.wac_price;

    -- FEFO cho Waste
    if r_waste.track_lot then
      v_remaining_deduct := v_qty_to_deduct;
      for v_lot in 
        select id, qty_remaining 
        from lots 
        where ingredient_id = r_waste.ingredient_id and qty_remaining > 0
        order by expiry_date asc nulls last, received_at asc
      loop
        exit when v_remaining_deduct <= 0;
        v_lot_deduct := least(v_lot.qty_remaining, v_remaining_deduct);
        
        update lots set qty_remaining = qty_remaining - v_lot_deduct where id = v_lot.id;
        
        insert into inventory_transactions (
          ingredient_id, txn_type, qty, unit_cost, lot_id, ref_table, ref_id, business_date, created_by, status
        ) values (
          r_waste.ingredient_id, 'WASTE', -v_lot_deduct, v_wac_price, v_lot.id, 'waste_logs', r_waste.id::varchar, p_date, p_user_id, 'approved'
        );
        v_remaining_deduct := v_remaining_deduct - v_lot_deduct;
      end loop;

      if v_remaining_deduct > 0 then
        insert into inventory_transactions (
          ingredient_id, txn_type, qty, unit_cost, lot_id, ref_table, ref_id, business_date, created_by, status
        ) values (
          r_waste.ingredient_id, 'WASTE', -v_remaining_deduct, v_wac_price, null, 'waste_logs', r_waste.id::varchar, p_date, p_user_id, 'approved'
        );
      end if;
    else
      insert into inventory_transactions (
        ingredient_id, txn_type, qty, unit_cost, lot_id, ref_table, ref_id, business_date, created_by, status
      ) values (
        r_waste.ingredient_id, 'WASTE', -v_qty_to_deduct, v_wac_price, null, 'waste_logs', r_waste.id::varchar, p_date, p_user_id, 'approved'
      );
    end if;

    update waste_logs set is_processed = true where id = r_waste.id;
  end loop;

  -- 3. Xử lý Tiêu thụ ngoài bán hàng (Non-sale Consumption)
  for r_non_sale in 
    select ns.id, ns.ingredient_id, ns.qty, ns.consumption_type, i.wac_price, i.track_lot
    from non_sale_consumption ns
    join ingredients i on ns.ingredient_id = i.id
    where ns.business_date = p_date
      and not exists (
        select 1 from inventory_transactions 
        where ref_table = 'non_sale_consumption' and ref_id = ns.id::varchar
      )
  loop
    v_qty_to_deduct := r_non_sale.qty;
    v_wac_price := r_non_sale.wac_price;

    -- FEFO cho Non-Sale
    if r_non_sale.track_lot then
      v_remaining_deduct := v_qty_to_deduct;
      for v_lot in 
        select id, qty_remaining 
        from lots 
        where ingredient_id = r_non_sale.ingredient_id and qty_remaining > 0
        order by expiry_date asc nulls last, received_at asc
      loop
        exit when v_remaining_deduct <= 0;
        v_lot_deduct := least(v_lot.qty_remaining, v_remaining_deduct);
        
        update lots set qty_remaining = qty_remaining - v_lot_deduct where id = v_lot.id;
        
        insert into inventory_transactions (
          ingredient_id, txn_type, qty, unit_cost, lot_id, ref_table, ref_id, business_date, created_by, status
        ) values (
          r_non_sale.ingredient_id, 'NON_SALE', -v_lot_deduct, v_wac_price, v_lot.id, 'non_sale_consumption', r_non_sale.id::varchar, p_date, p_user_id, 'approved'
        );
        v_remaining_deduct := v_remaining_deduct - v_lot_deduct;
      end loop;

      if v_remaining_deduct > 0 then
        insert into inventory_transactions (
          ingredient_id, txn_type, qty, unit_cost, lot_id, ref_table, ref_id, business_date, created_by, status
        ) values (
          r_non_sale.ingredient_id, 'NON_SALE', -v_remaining_deduct, v_wac_price, null, 'non_sale_consumption', r_non_sale.id::varchar, p_date, p_user_id, 'approved'
        );
      end if;
    else
      insert into inventory_transactions (
        ingredient_id, txn_type, qty, unit_cost, lot_id, ref_table, ref_id, business_date, created_by, status
      ) values (
        r_non_sale.ingredient_id, 'NON_SALE', -v_qty_to_deduct, v_wac_price, null, 'non_sale_consumption', r_non_sale.id::varchar, p_date, p_user_id, 'approved'
      );
    end if;
  end loop;

  -- Ghi nhận trạng thái daily_close
  insert into daily_close (business_date, status)
  values (p_date, 'CONSUMPTION_DONE')
  on conflict (business_date) do update set status = 'CONSUMPTION_DONE';
end;
$$ language plpgsql security definer;

-- =========================================================================
-- 3. FILTER INGREDIENTS & GENERATE FORECASTED AUTO-PO AT 22:40
-- =========================================================================

create or replace function generate_auto_po(p_date date, p_user_id uuid)
returns table (po_number_out varchar, supplier_name varchar, items_count integer) as $$
declare
  r_ing record;
  v_stock numeric(12, 4);
  v_po_pending_qty numeric(12, 4);
  v_avg_daily_consumption numeric(12, 4);
  v_forecasted_lead_consumption numeric(12, 4);
  v_projected_on_hand numeric(12, 4);
  v_qty_raw numeric(12, 4);
  v_qty_to_order_stock_uom numeric(12, 4);
  v_qty_to_order_purchase_uom numeric(12, 4);
  v_po_id uuid;
  v_po_num varchar;
  v_detail_count integer;
begin
  -- Tạo bảng tạm gom các dòng cần đặt
  create temp table temp_auto_po_items (
    ingredient_id varchar(50),
    supplier_id uuid,
    purchase_uom text,
    pack_size numeric,
    moq numeric,
    qty_ordered_purchase_uom numeric,
    unit_price_fx numeric(12, 2)
  ) on commit drop;

  -- 1. Quét toàn bộ nguyên vật liệu thuộc nhóm AUTO_PO
  for r_ing in 
    select 
      i.id, i.safety_stock, i.max_stock, i.standard_price,
      si.supplier_id, si.purchase_uom, si.pack_size, si.moq, s.lead_time_days, s.name as supplier_name
    from ingredients i
    join supplier_ingredients si on i.id = si.ingredient_id and si.is_preferred = true
    join suppliers s on si.supplier_id = s.id
    where i.is_active = true and i.auto_po_group = 'AUTO_PO'
  loop
    -- A. Tính tồn kho lý thuyết hiện tại (stock_uom)
    select coalesce(sum(qty), 0)
    into v_stock
    from inventory_transactions
    where ingredient_id = r_ing.id and status = 'approved';

    -- B. Tính số lượng PO đang mở chưa giao về trước lead time (stock_uom)
    select coalesce(sum((pl.qty_ordered - pl.qty_received) * si.pack_size), 0)
    into v_po_pending_qty
    from po_lines pl
    join purchase_orders po on pl.po_id = po.id
    join supplier_ingredients si on po.supplier_id = si.supplier_id and pl.ingredient_id = si.ingredient_id
    where pl.ingredient_id = r_ing.id 
      and po.status in ('OPEN', 'PARTIAL');

    -- C. Tính trung bình tiêu thụ hàng ngày trong 14 ngày qua (chỉ tính lượng xuất)
    select coalesce(-sum(qty) / 14.0, 0)
    into v_avg_daily_consumption
    from inventory_transactions
    where ingredient_id = r_ing.id
      and txn_type in ('SALE_DEPLETION', 'WASTE', 'NON_SALE')
      and business_date >= p_date - 14
      and business_date < p_date;

    -- Dự báo tiêu thụ trong thời gian lead time
    v_forecasted_lead_consumption := v_avg_daily_consumption * r_ing.lead_time_days;

    -- D. Tồn kho ước tính (Projected On-Hand)
    v_projected_on_hand := v_stock + v_po_pending_qty - v_forecasted_lead_consumption;

    -- E. Nếu tồn kho ước tính dưới ngưỡng an toàn (safety_stock), tiến hành đặt hàng
    if v_projected_on_hand < r_ing.safety_stock then
      v_qty_raw := r_ing.max_stock - v_projected_on_hand;
      
      -- Phải đạt tối thiểu MOQ (quy đổi về stock_uom)
      v_qty_to_order_stock_uom := greatest(v_qty_raw, r_ing.moq * r_ing.pack_size);

      -- Làm tròn theo quy cách đóng gói pack_size (Thùng/Hộp)
      v_qty_to_order_purchase_uom := ceil(v_qty_to_order_stock_uom / r_ing.pack_size);

      insert into temp_auto_po_items (
        ingredient_id, supplier_id, purchase_uom, pack_size, moq, qty_ordered_purchase_uom, unit_price_fx
      ) values (
        r_ing.id, r_ing.supplier_id, r_ing.purchase_uom, r_ing.pack_size, r_ing.moq, v_qty_to_order_purchase_uom, r_ing.standard_price
      );
    end if;
  end loop;

  -- 2. Tạo đơn PO gom nhóm theo Nhà cung cấp
  for po_number_out, supplier_name, v_po_id in 
    select 
      'PO-' || to_char(p_date, 'YYYYMMDD') || '-' || upper(substring(s.name from 1 for 4)),
      s.name,
      gen_random_uuid() -- Generate temporary uuid to insert
    from temp_auto_po_items t
    join suppliers s on t.supplier_id = s.id
    group by s.name, s.id
  loop
    -- Tạo mới PO nếu chưa có cho NCC trong ngày hôm nay
    select id into v_po_id 
    from purchase_orders 
    where po_number = po_number_out;

    if v_po_id is null then
      insert into purchase_orders (id, po_number, supplier_id, status, source, expected_date)
      select 
        gen_random_uuid(), 
        po_number_out,
        s.id, 
        'OPEN', 
        'AUTO_PO', 
        p_date + (s.lead_time_days || ' days')::interval
      from suppliers s
      where s.name = supplier_name
      returning id, po_number into v_po_id, po_number_out;
    end if;

    -- Thêm chi tiết PO
    v_detail_count := 0;
    for r_ing in 
      select ingredient_id, qty_ordered_purchase_uom, purchase_uom
      from temp_auto_po_items t
      join suppliers s on t.supplier_id = s.id
      where s.name = supplier_name
    loop
      if not exists (
        select 1 from po_lines 
        where po_id = v_po_id and ingredient_id = r_ing.ingredient_id
      ) then
        insert into po_lines (po_id, ingredient_id, qty_ordered, qty_received, purchase_uom)
        values (v_po_id, r_ing.ingredient_id, r_ing.qty_ordered_purchase_uom, 0.0000, r_ing.purchase_uom);
        v_detail_count := v_detail_count + 1;
      end if;
    end loop;

    if v_detail_count > 0 then
      items_count := v_detail_count;
      return next;
    end if;
  end loop;

  -- Ghi nhận daily_close
  insert into daily_close (business_date, status)
  values (p_date, 'PO_DONE')
  on conflict (business_date) do update set status = 'PO_DONE';
end;
$$ language plpgsql security definer;

-- =========================================================================
-- 4. AUTOMATION JOBS SCHEDULING (pg_cron v8.0)
-- =========================================================================

-- Note: We enable pg_cron extension and schedule the daily inventory jobs.
-- Since Supabase servers run in UTC, we convert ICT (Asia/Ho_Chi_Minh) times to UTC:
-- 1. WAC snapshot close: 18:30 ICT -> 11:30 UTC
-- 2. Daily Stock depletion (FEFO): 22:30 ICT -> 15:30 UTC
-- 3. Auto-PO: 22:40 ICT -> 15:40 UTC
-- 4. Watchdog alert: 23:00 ICT -> 16:00 UTC

-- Enable cron extension (requires superuser, usually enabled in Supabase by default)
create extension if not exists pg_cron;

-- Unschedule existing jobs to avoid duplication/errors
select cron.unschedule('daily-wac-snapshot-job') where exists (select 1 from cron.job where jobname = 'daily-wac-snapshot-job');
select cron.unschedule('daily-consumption-depletion-job') where exists (select 1 from cron.job where jobname = 'daily-consumption-depletion-job');
select cron.unschedule('daily-auto-po-job') where exists (select 1 from cron.job where jobname = 'daily-auto-po-job');
select cron.unschedule('daily-watchdog-job') where exists (select 1 from cron.job where jobname = 'daily-watchdog-job');

-- 1. Job 18:30 ICT (11:30 UTC): Tính WAC và chụp snapshot (WAC_DONE)
select cron.schedule(
    'daily-wac-snapshot-job',
    '30 11 * * *',
    $$
    insert into daily_close (business_date, status)
    values (current_date, 'WAC_DONE')
    on conflict (business_date) do update set status = 'WAC_DONE';
    $$
);

-- 2. Job 22:30 ICT (15:30 UTC): Trừ kho tự động theo FEFO (CONSUMPTION_DONE)
select cron.schedule(
    'daily-consumption-depletion-job',
    '30 15 * * *',
    $$
    select process_daily_consumption(current_date, '00000000-0000-0000-0000-000000000000'::uuid);
    $$
);

-- 3. Job 22:40 ICT (15:40 UTC): Tự động đặt hàng Auto-PO (PO_DONE)
select cron.schedule(
    'daily-auto-po-job',
    '40 15 * * *',
    $$
    select * from generate_auto_po(current_date, '00000000-0000-0000-0000-000000000000'::uuid);
    $$
);

-- 4. Job 23:00 ICT (16:00 UTC): Watchdog kiểm tra trạng thái khóa sổ ngày
select cron.schedule(
    'daily-watchdog-job',
    '00 16 * * *',
    $$
    declare
        v_status text;
    begin
        select status into v_status from daily_close where business_date = current_date;
        if v_status is null or v_status <> 'PO_DONE' then
            insert into audit_log (actor, action, entity, entity_id, before_data, after_data)
            values (
                '00000000-0000-0000-0000-000000000000'::uuid,
                'WATCHDOG_ALERT_DAILY_CLOSE_FAILED',
                'daily_close',
                current_date::varchar,
                null,
                jsonb_build_object('current_status', v_status, 'error', 'Hệ thống chưa hoàn thành khóa sổ tự động cuối ngày. Yêu cầu kiểm tra tiến trình.')
            );
        end if;
    end;
    $$
);

-- =========================================================================
-- v9.0 FUNCTIONS (INTERNAL TRANSFER & DAILY MOVEMENT CONFIRMATION)
-- =========================================================================

-- 1. Record internal transfers between locations
create or replace function record_internal_transfer(
  p_src_loc text,
  p_dest_loc text,
  p_ing_id varchar,
  p_qty numeric,
  p_user_id uuid,
  p_date date,
  p_note text
)
returns uuid as $$
declare
  v_transfer_id uuid;
  v_wac numeric(12, 2);
begin
  -- Validate quantity
  if p_qty <= 0 then
    raise exception 'Số lượng chuyển kho phải lớn hơn 0.';
  end if;

  -- Validate locations
  if p_src_loc = p_dest_loc then
    raise exception 'Kho nguồn và kho đích không được trùng nhau.';
  end if;

  -- Fetch current WAC for this ingredient
  select wac_price into v_wac from ingredients where id = p_ing_id;

  -- Generate unique transfer_id
  v_transfer_id := gen_random_uuid();

  -- 1. Insert TRANSFER_OUT (negative quantity)
  insert into inventory_transactions (
    ingredient_id, txn_type, qty, unit_cost, location_id, transfer_id, business_date, status, created_by, note
  ) values (
    p_ing_id, 'TRANSFER_OUT', -p_qty, v_wac, p_src_loc, v_transfer_id, p_date, 'approved', p_user_id, p_note
  );

  -- 2. Insert TRANSFER_IN (positive quantity)
  insert into inventory_transactions (
    ingredient_id, txn_type, qty, unit_cost, location_id, transfer_id, business_date, status, created_by, note
  ) values (
    p_ing_id, 'TRANSFER_IN', p_qty, v_wac, p_dest_loc, v_transfer_id, p_date, 'approved', p_user_id, p_note
  );

  return v_transfer_id;
end;
$$ language plpgsql security definer;


-- 2. Confirm daily movement imports or issues for location, chốt sổ snapshot khi cả 2 confirmed
create or replace function confirm_daily_movement(
  p_date date,
  p_loc_id text,
  p_type text, -- 'IMPORT' or 'ISSUE'
  p_user_id uuid
)
returns void as $$
declare
  v_imports_confirmed boolean;
  v_issues_confirmed boolean;
  v_snapshot jsonb;
begin
  if p_type = 'IMPORT' then
    insert into daily_stock_movement (business_date, location_id, imports_confirmed, imports_confirmed_by, imports_confirmed_at)
    values (p_date, p_loc_id, true, p_user_id, now())
    on conflict (business_date, location_id) do update set
      imports_confirmed = true,
      imports_confirmed_by = p_user_id,
      imports_confirmed_at = now();
  elsif p_type = 'ISSUE' then
    insert into daily_stock_movement (business_date, location_id, issues_confirmed, issues_confirmed_by, issues_confirmed_at)
    values (p_date, p_loc_id, true, p_user_id, now())
    on conflict (business_date, location_id) do update set
      issues_confirmed = true,
      issues_confirmed_by = p_user_id,
      issues_confirmed_at = now();
  else
    raise exception 'Loại xác nhận không hợp lệ. Phải là IMPORT hoặc ISSUE.';
  end if;

  -- Check if both are confirmed now to build closing snapshot
  select imports_confirmed, issues_confirmed into v_imports_confirmed, v_issues_confirmed
  from daily_stock_movement
  where business_date = p_date and location_id = p_loc_id;

  if v_imports_confirmed = true and v_issues_confirmed = true then
    -- Generate snapshot of stock on hand for this location
    select jsonb_object_agg(ingredient_id, qty_on_hand) into v_snapshot
    from v_stock_on_hand
    where location_id = p_loc_id;

    update daily_stock_movement
    set closing_snapshot = v_snapshot,
        status = 'CLOSED'
    where business_date = p_date and location_id = p_loc_id;
  end if;
end;
$$ language plpgsql security definer;

