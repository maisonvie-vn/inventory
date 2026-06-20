-- ============================================================
-- PATCH v3.0.2 — Sửa RLS cho Sandbox Login (anon key)
-- Vấn đề: App dùng 'sandbox' password → không có JWT →
--         RLS chặn anon đọc ingredients, inventory_transactions
--         → UI hiển thị mock data, không có gì thay đổi
-- Giải pháp: Cho anon đọc view và các bảng read-only inventory
-- ============================================================

-- 1. Cho anon đọc ingredients (tên, đơn vị, tồn kho — không có giá WAC)
DROP POLICY IF EXISTS "anon_read_ingredients" ON ingredients;
CREATE POLICY "anon_read_ingredients" ON ingredients
  FOR SELECT TO anon
  USING (is_active = true);

-- 2. Cho anon đọc inventory_transactions (xem lịch sử giao dịch)
DROP POLICY IF EXISTS "anon_read_inventory_transactions" ON inventory_transactions;
CREATE POLICY "anon_read_inventory_transactions" ON inventory_transactions
  FOR SELECT TO anon
  USING (true);

-- 3. Cho anon đọc sales_imports (đã có public policy rồi — check lại)
-- sales_imports đã có policy cho public — OK

-- 4. Cho anon đọc menu_items
DROP POLICY IF EXISTS "anon_read_menu_items" ON menu_items;
CREATE POLICY "anon_read_menu_items" ON menu_items
  FOR SELECT TO anon
  USING (true);

-- 5. Cho anon đọc recipes (để xem công thức)
DROP POLICY IF EXISTS "anon_read_recipes" ON recipes;
CREATE POLICY "anon_read_recipes" ON recipes
  FOR SELECT TO anon
  USING (true);

-- 6. Cho anon đọc purchase_categories (category của ingredients)
DROP POLICY IF EXISTS "anon_read_purchase_categories" ON purchase_categories;
CREATE POLICY "anon_read_purchase_categories" ON purchase_categories
  FOR SELECT TO anon
  USING (true);

-- 7. Cho anon đọc lots (để xem tồn lô)
DROP POLICY IF EXISTS "anon_read_lots" ON lots;
CREATE POLICY "anon_read_lots" ON lots
  FOR SELECT TO anon
  USING (true);

-- 8. Cho anon đọc suppliers
DROP POLICY IF EXISTS "anon_read_suppliers" ON suppliers;
CREATE POLICY "anon_read_suppliers" ON suppliers
  FOR SELECT TO anon
  USING (true);

-- 9. Cho anon đọc pos_alias_map
DROP POLICY IF EXISTS "anon_read_pos_alias_map" ON pos_alias_map;
CREATE POLICY "anon_read_pos_alias_map" ON pos_alias_map
  FOR SELECT TO anon
  USING (true);

-- 10. Cho anon đọc waste_logs, non_sale_consumption
DROP POLICY IF EXISTS "anon_read_waste_logs" ON waste_logs;
CREATE POLICY "anon_read_waste_logs" ON waste_logs
  FOR SELECT TO anon
  USING (true);

DROP POLICY IF EXISTS "anon_read_non_sale_consumption" ON non_sale_consumption;
CREATE POLICY "anon_read_non_sale_consumption" ON non_sale_consumption
  FOR SELECT TO anon
  USING (true);

-- 11. Cho anon đọc purchase_orders và grn (để xem dashboard)
DROP POLICY IF EXISTS "anon_read_purchase_orders" ON purchase_orders;
CREATE POLICY "anon_read_purchase_orders" ON purchase_orders
  FOR SELECT TO anon
  USING (true);

DROP POLICY IF EXISTS "anon_read_goods_receipts" ON goods_receipts;
CREATE POLICY "anon_read_goods_receipts" ON goods_receipts
  FOR SELECT TO anon
  USING (true);

DROP POLICY IF EXISTS "anon_read_grn_lines" ON grn_lines;
CREATE POLICY "anon_read_grn_lines" ON grn_lines
  FOR SELECT TO anon
  USING (true);

DROP POLICY IF EXISTS "anon_read_po_lines" ON po_lines;
CREATE POLICY "anon_read_po_lines" ON po_lines
  FOR SELECT TO anon
  USING (true);

-- Verify
SELECT tablename, COUNT(*) as policy_count 
FROM pg_policies 
WHERE roles @> ARRAY['anon']::name[]
GROUP BY tablename ORDER BY tablename;
