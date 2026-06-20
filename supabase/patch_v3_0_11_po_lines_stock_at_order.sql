-- ============================================================
-- PATCH v3.0.11 — Ghi nhận tồn kho thực tế khi tạo PO
-- Vấn đề: Cột stock_at_order của po_lines trống (bằng 0 hoặc NULL)
-- Giải pháp:
--   1. Cập nhật RPC create_po_from_worklist để tự động điền stock_at_order từ v_stock_on_hand
--   2. Cập nhật dữ liệu cũ cho các po_lines đã tồn tại dựa trên số tồn hiện tại
-- ============================================================

-- 1. Cập nhật RPC create_po_from_worklist
CREATE OR REPLACE FUNCTION create_po_from_worklist(
  p_supplier_id  uuid,
  p_location_id  text,
  p_lines        jsonb,          -- [{ingredient_id, suggested_qty, unit_price, uom, moq, pack_size}]
  p_notes        text default null
) RETURNS uuid LANGUAGE plpgsql SECURITY DEFINER AS $$
declare
  v_po_id        uuid;
  v_po_no        text;
  v_total        numeric := 0;
  v_line         jsonb;
  v_seq          int;
  v_role         text;
begin
  v_role := get_current_user_role();
  -- Cho phép Chef và Bar Supervisor tạo yêu cầu PO
  if v_role not in ('admin','restaurant_manager','senior_accountant','junior_accountant','head_chef','BAR_SUPERVISOR') then
    raise exception 'Không đủ quyền tạo PO';
  end if;

  -- Sinh số PO
  select coalesce(max(version), 0) + 1 into v_seq
  from purchase_orders
  where date_trunc('month', created_at) = date_trunc('month', now());
  v_po_no := 'PO-' || to_char(now(), 'YYYYMM') || '-' || lpad(v_seq::text, 4, '0')
             || '-' || upper(left(p_location_id, 3));

  -- Tính tổng giá trị
  for v_line in select * from jsonb_array_elements(p_lines) loop
    v_total := v_total
      + coalesce((v_line->>'suggested_qty')::numeric, 0)
      * coalesce((v_line->>'unit_price')::numeric, 0);
  end loop;

  -- Tạo PO header
  insert into purchase_orders(
    supplier_id, location_id, status, po_no, po_number,
    total_value, notes, requested_by, created_by, is_manual, source
  ) values (
    p_supplier_id, p_location_id, 'DRAFT', v_po_no, v_po_no,
    round(v_total, 0), p_notes, auth.uid(), auth.uid(), true, 'MANUAL_REQUISITION'
  ) returning id into v_po_id;

  -- Tạo PO lines
  for v_line in select * from jsonb_array_elements(p_lines) loop
    insert into po_lines(
      po_id, ingredient_id,
      qty, qty_ordered, uom, purchase_uom,
      unit_price,
      suggested_qty, moq_applied, pack_size_applied,
      estimated_value,
      stock_at_order
    ) values (
      v_po_id,
      (v_line->>'ingredient_id')::uuid,
      (v_line->>'suggested_qty')::numeric,
      (v_line->>'suggested_qty')::numeric,
      v_line->>'uom',
      v_line->>'uom',
      (v_line->>'unit_price')::numeric,
      (v_line->>'suggested_qty')::numeric,
      (v_line->>'moq')::numeric,
      (v_line->>'pack_size')::numeric,
      (v_line->>'suggested_qty')::numeric * coalesce((v_line->>'unit_price')::numeric, 0),
      coalesce((
        select qty_on_hand
        from v_stock_on_hand
        where ingredient_id = (v_line->>'ingredient_id')::uuid
          and location_id = p_location_id
      ), 0)
    );
  end loop;

  return v_po_id;
end $$;

-- 2. Cập nhật dữ liệu cho các dòng po_lines cũ bị NULL hoặc 0
update po_lines pl
set stock_at_order = coalesce((
  select qty_on_hand
  from v_stock_on_hand s
  join purchase_orders po on po.id = pl.po_id
  where s.ingredient_id = pl.ingredient_id
    and s.location_id = po.location_id
), 0)
where pl.stock_at_order is null or pl.stock_at_order = 0;
