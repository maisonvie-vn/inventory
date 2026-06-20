-- ============================================================
-- PATCH v3.0.6 — RLS Policies cho bảng suppliers
-- Vấn đề: 
--   1. Không có SELECT policy cho authenticated users -> Staff đăng nhập không lấy được danh sách NCC.
--   2. Không có INSERT/UPDATE/DELETE policy cho Admin/Kế toán -> Không thể thêm/sửa NCC.
-- ============================================================

-- 1. Cho phép tất cả authenticated users xem danh sách nhà cung cấp
DROP POLICY IF EXISTS "Allow select suppliers for authenticated users" ON suppliers;
CREATE POLICY "Allow select suppliers for authenticated users"
  ON suppliers FOR SELECT TO authenticated
  USING (true);

-- 2. Cho phép Admin và Kế toán quản lý (thêm/sửa/xóa) nhà cung cấp
DROP POLICY IF EXISTS "Allow manage suppliers for admin and accountants" ON suppliers;
CREATE POLICY "Allow manage suppliers for admin and accountants"
  ON suppliers FOR ALL TO authenticated
  USING (get_current_user_role() in ('admin', 'senior_accountant', 'restaurant_manager'))
  WITH CHECK (get_current_user_role() in ('admin', 'senior_accountant', 'restaurant_manager'));
