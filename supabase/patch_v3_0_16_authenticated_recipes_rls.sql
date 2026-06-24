-- 🚀 Nâng cấp phân quyền SELECT cho bảng recipes đối với user authenticated
-- Giúp các vai trò đã đăng nhập (admin, accountant, chef, manager) có thể đọc công thức món ăn để tính toán Food Cost chính xác.

DROP POLICY IF EXISTS "authenticated_select_recipes" ON recipes;
CREATE POLICY "authenticated_select_recipes" ON recipes
  FOR SELECT TO authenticated
  USING (true);
