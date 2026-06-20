-- ============================================================
-- PATCH v3.0.4 — Cấp quyền xem/tạo PO cho Chef & Bar Supervisor
-- Vấn đề: 
--   1. RPC create_po_from_worklist chặn role 'head_chef' và 'BAR_SUPERVISOR' -> Chef không thể đặt hàng.
--   2. RLS SELECT policy trên purchase_orders chặn Chef/BarSupervisor -> Không xem được PO nháp vừa tạo để gửi duyệt.
--   3. RLS SELECT policy trên po_lines trống -> Không xem được chi tiết dòng hàng của PO.
-- ============================================================

-- 1. Cập nhật RPC create_po_from_worklist để cho phép Chef và Bar Supervisor tạo PO nháp
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
      estimated_value
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
      (v_line->>'suggested_qty')::numeric * coalesce((v_line->>'unit_price')::numeric, 0)
    );
  end loop;

  return v_po_id;
end $$;

-- 2. Cập nhật RLS SELECT policy trên purchase_orders
DROP POLICY IF EXISTS "Allow select PO for accountants, managers, admin" ON purchase_orders;
CREATE POLICY "Allow select PO for accountants, managers, admin"
  ON purchase_orders FOR SELECT TO authenticated
  USING (get_current_user_role() in ('admin', 'senior_accountant', 'restaurant_manager', 'junior_accountant', 'head_chef', 'BAR_SUPERVISOR'));

-- 3. Thêm RLS SELECT policy trên po_lines cho tất cả authenticated users
DROP POLICY IF EXISTS "Allow select po_lines for all authenticated users" ON po_lines;
CREATE POLICY "Allow select po_lines for all authenticated users"
  ON po_lines FOR SELECT TO authenticated
  USING (true);
