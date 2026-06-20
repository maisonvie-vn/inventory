-- ============================================================
-- PATCH v3.0.7 — RLS Policies cho bảng suppliers (Mở rộng quyền cho tất cả nhân viên)
-- Vấn đề: 
--   - Người dùng (như Bếp trưởng, Bar Supervisor, Thủ kho...) khi thêm NCC 
--     bị báo lỗi "new row violates row-level security policy for table suppliers".
-- Giải pháp:
--   - Cho phép tất cả các tài khoản nhân viên đã đăng nhập (authenticated) 
--     được quyền xem và quản lý (Thêm/Sửa/Kích hoạt) nhà cung cấp.
-- ============================================================

-- 1. Xóa các policy cũ của bảng suppliers để làm sạch
DROP POLICY IF EXISTS "Allow select suppliers for authenticated users" ON suppliers;
DROP POLICY IF EXISTS "Allow manage suppliers for admin and accountants" ON suppliers;
DROP POLICY IF EXISTS "Allow manage suppliers for all authenticated users" ON suppliers;
DROP POLICY IF EXISTS "anon_read_suppliers" ON suppliers;

-- 2. Cho phép tất cả authenticated users (các tài khoản đã đăng nhập) xem danh sách nhà cung cấp
CREATE POLICY "Allow select suppliers for authenticated users"
  ON suppliers FOR SELECT TO authenticated
  USING (true);

-- 3. Cho phép tất cả authenticated users thêm/sửa/xóa nhà cung cấp
CREATE POLICY "Allow manage suppliers for all authenticated users"
  ON suppliers FOR ALL TO authenticated
  USING (true)
  WITH CHECK (true);

-- 4. Cho phép khách (anon) xem danh sách nếu cần thiết cho PWA
CREATE POLICY "anon_read_suppliers" 
  ON suppliers FOR SELECT TO anon
  USING (true);
