-- ============================================================
-- PATCH v3.0.14 — Sửa lỗi real-time badges thông báo PO chờ duyệt
-- Vấn đề:
--   1. Bảng profiles trống trong sandbox/dev DB, dẫn đến insert into notification_badges từ profiles select 0 dòng.
--   2. Ràng buộc khóa ngoại của profiles.id tham chiếu auth.users.id yêu cầu phải có user trong auth.users trước.
--   3. Điều kiện p.id <> r_po.requested_by bị trả về NULL khi r_po.requested_by là NULL (chạy sandbox ẩn danh), chặn đứng việc tạo badge.
-- Giải pháp:
--   1. Seed 9 users sandbox vào bảng auth.users.
--   2. Seed/Cập nhật 9 profiles tương ứng với 9 vai trò sandbox để luôn có user nhận badge.
--   3. Thay thế `p.id <> r_po.requested_by` bằng `p.id is distinct from r_po.requested_by` để hoạt động đúng cả khi requested_by là NULL.
-- ============================================================

-- 1. Seeding auth.users cho môi trường Sandbox
INSERT INTO auth.users (id, email, aud, role, is_sso_user, is_anonymous, created_at, updated_at) VALUES
('90000000-0000-0000-0000-000000000001', 'cfo@maisonvie.vn', 'authenticated', 'authenticated', false, false, now(), now()),
('90000000-0000-0000-0000-000000000002', 'manager@maisonvie.vn', 'authenticated', 'authenticated', false, false, now(), now()),
('90000000-0000-0000-0000-000000000003', 'chef@maisonvie.vn', 'authenticated', 'authenticated', false, false, now(), now()),
('90000000-0000-0000-0000-000000000004', 'senior@maisonvie.vn', 'authenticated', 'authenticated', false, false, now(), now()),
('90000000-0000-0000-0000-000000000005', 'foh@maisonvie.vn', 'authenticated', 'authenticated', false, false, now(), now()),
('90000000-0000-0000-0000-000000000006', 'sous@maisonvie.vn', 'authenticated', 'authenticated', false, false, now(), now()),
('90000000-0000-0000-0000-000000000007', 'junior@maisonvie.vn', 'authenticated', 'authenticated', false, false, now(), now()),
('90000000-0000-0000-0000-000000000008', 'bar_supervisor@maisonvie.vn', 'authenticated', 'authenticated', false, false, now(), now()),
('90000000-0000-0000-0000-000000000009', 'bartender@maisonvie.vn', 'authenticated', 'authenticated', false, false, now(), now())
ON CONFLICT (id) DO NOTHING;

-- 2. Seeding/Cập nhật profiles tương ứng
INSERT INTO public.profiles (id, username, full_name, role) VALUES
('90000000-0000-0000-0000-000000000001', 'cfo', 'Quản trị viên (CFO)', 'admin'),
('90000000-0000-0000-0000-000000000002', 'manager', 'Quản lý Nhà hàng', 'restaurant_manager'),
('90000000-0000-0000-0000-000000000003', 'chef', 'Bếp trưởng', 'head_chef'),
('90000000-0000-0000-0000-000000000004', 'senior_accountant', 'Kế toán kho cấp cao', 'senior_accountant'),
('90000000-0000-0000-0000-000000000005', 'foh_supervisor', 'Giám sát Sảnh', 'foh_supervisor'),
('90000000-0000-0000-0000-000000000006', 'sous_chef', 'Bếp phó', 'sous_chef'),
('90000000-0000-0000-0000-000000000007', 'junior_accountant', 'Thủ kho / Kế toán phụ', 'junior_accountant'),
('90000000-0000-0000-0000-000000000008', 'bar_supervisor', 'Trưởng Bar / Giám sát', 'BAR_SUPERVISOR'),
('90000000-0000-0000-0000-000000000009', 'bartender', 'Nhân viên Bar (Bartender)', 'BARTENDER')
ON CONFLICT (id) DO UPDATE SET 
  role = EXCLUDED.role,
  full_name = EXCLUDED.full_name,
  username = EXCLUDED.username;

-- 3. Cập nhật RPC submit_po_for_approval
CREATE OR REPLACE FUNCTION submit_po_for_approval(p_po_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
declare
  r_po       record;
  v_role     text;
begin
  v_role := get_current_user_role();
  select * into r_po from purchase_orders where id = p_po_id;

  if r_po is null then raise exception 'PO không tồn tại'; end if;
  if r_po.status <> 'DRAFT' then raise exception 'Chỉ DRAFT mới submit được'; end if;

  update purchase_orders
  set status = 'PENDING_APPROVAL', requested_by = coalesce(r_po.requested_by, auth.uid())
  where id = p_po_id;

  -- Tạo badge thông báo cho Manager + Senior Accountant + Admin (không phải người tạo)
  insert into notification_badges(user_id, badge_type, ref_table, ref_id, scope_location, metadata)
  select
    p.id, 'PO_PENDING_APPROVAL', 'purchase_orders', p_po_id::text,
    r_po.location_id,
    jsonb_build_object('po_no', r_po.po_no, 'total_value', r_po.total_value, 'supplier_id', r_po.supplier_id)
  from profiles p
  where p.role in ('admin','restaurant_manager','senior_accountant')
    and p.id is distinct from r_po.requested_by  -- Hỗ trợ đúng khi requested_by là NULL hoặc khác người phê duyệt
  on conflict do nothing;
end $$;

revoke execute on function submit_po_for_approval from public;
grant execute on function submit_po_for_approval to authenticated;
grant execute on function submit_po_for_approval to anon;
