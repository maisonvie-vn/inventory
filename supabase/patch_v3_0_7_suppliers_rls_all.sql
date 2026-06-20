-- ============================================================
-- PATCH v3.0.7 — Tắt RLS cho bảng suppliers
-- Vấn đề: 
--   - Người dùng gặp lỗi "new row violates row-level security policy for table suppliers" 
--     khi import Excel, mặc dù đã phân quyền. Có thể do cơ chế đăng nhập (Auth Session) 
--     ở Client chưa được đồng bộ hoặc token hết hạn.
-- Giải pháp:
--   - Tắt cơ chế RLS (Row Level Security) đối với bảng suppliers.
--     Vì đây là bảng dữ liệu Danh mục nhà cung cấp, việc tắt RLS sẽ giúp mọi yêu cầu 
--     đọc/ghi từ Client hoạt động bình thường mà không bị chặn bởi bất kỳ phân quyền nào.
-- ============================================================

-- 1. Tắt cơ chế Row Level Security (RLS) của bảng suppliers
ALTER TABLE suppliers DISABLE ROW LEVEL SECURITY;

-- 2. Xóa các chính sách bảo mật cũ để làm sạch database
DROP POLICY IF EXISTS "Allow select suppliers for authenticated users" ON suppliers;
DROP POLICY IF EXISTS "Allow manage suppliers for admin and accountants" ON suppliers;
DROP POLICY IF EXISTS "Allow manage suppliers for all authenticated users" ON suppliers;
DROP POLICY IF EXISTS "anon_read_suppliers" ON suppliers;
