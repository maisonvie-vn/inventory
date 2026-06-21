-- ============================================================
-- PATCH: Fix RLS policies for supplier_ingredients & supplier_prices
-- Run this in Supabase SQL Editor
-- ============================================================

-- === supplier_ingredients ===
-- Drop existing policies (if any) to avoid duplicates
DROP POLICY IF EXISTS "Allow read supplier_ingredients" ON supplier_ingredients;
DROP POLICY IF EXISTS "Allow insert supplier_ingredients" ON supplier_ingredients;
DROP POLICY IF EXISTS "Allow update supplier_ingredients" ON supplier_ingredients;
DROP POLICY IF EXISTS "Allow delete supplier_ingredients" ON supplier_ingredients;

-- Mở toàn bộ quyền (khớp với pattern của app - không dùng Supabase Auth)
CREATE POLICY "Allow read supplier_ingredients"   ON supplier_ingredients FOR SELECT USING (true);
CREATE POLICY "Allow insert supplier_ingredients"  ON supplier_ingredients FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow update supplier_ingredients"  ON supplier_ingredients FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "Allow delete supplier_ingredients"  ON supplier_ingredients FOR DELETE USING (true);

-- === supplier_prices (nếu có bảng này) ===
DROP POLICY IF EXISTS "Allow read supplier_prices" ON supplier_prices;
DROP POLICY IF EXISTS "Allow insert supplier_prices" ON supplier_prices;
DROP POLICY IF EXISTS "Allow update supplier_prices" ON supplier_prices;
DROP POLICY IF EXISTS "Allow delete supplier_prices" ON supplier_prices;

CREATE POLICY "Allow read supplier_prices"   ON supplier_prices FOR SELECT USING (true);
CREATE POLICY "Allow insert supplier_prices"  ON supplier_prices FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow update supplier_prices"  ON supplier_prices FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "Allow delete supplier_prices"  ON supplier_prices FOR DELETE USING (true);

-- Xác nhận
SELECT schemaname, tablename, policyname, cmd
FROM pg_policies
WHERE tablename IN ('supplier_ingredients', 'supplier_prices')
ORDER BY tablename, cmd;
