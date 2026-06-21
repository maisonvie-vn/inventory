-- ============================================================
-- PATCH: Add UPDATE/INSERT policy for purchase_orders for anon
-- Vì app không dùng Supabase Auth (role = anon)
-- Policy hiện tại chỉ có SELECT cho anon, thiếu UPDATE
-- ============================================================

-- Thêm policy UPDATE cho anon (để hủy, rút lại PO)
DROP POLICY IF EXISTS "anon_update_purchase_orders" ON purchase_orders;
CREATE POLICY "anon_update_purchase_orders"
  ON purchase_orders FOR UPDATE
  USING (true)
  WITH CHECK (true);

-- Thêm policy INSERT cho anon (để tạo PO mới)
DROP POLICY IF EXISTS "anon_insert_purchase_orders" ON purchase_orders;
CREATE POLICY "anon_insert_purchase_orders"
  ON purchase_orders FOR INSERT
  WITH CHECK (true);

-- Xác nhận tất cả policies
SELECT policyname, cmd FROM pg_policies WHERE tablename = 'purchase_orders' ORDER BY cmd;
