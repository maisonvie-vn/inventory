-- Write policies for anon (sandbox login support)
DROP POLICY IF EXISTS anon_write_inventory_transactions ON inventory_transactions;
CREATE POLICY anon_write_inventory_transactions ON inventory_transactions
  FOR INSERT TO anon WITH CHECK (true);

DROP POLICY IF EXISTS anon_write_waste_logs ON waste_logs;
CREATE POLICY anon_write_waste_logs ON waste_logs
  FOR INSERT TO anon WITH CHECK (true);

DROP POLICY IF EXISTS anon_update_waste_logs ON waste_logs;
CREATE POLICY anon_update_waste_logs ON waste_logs
  FOR UPDATE TO anon USING (true);

DROP POLICY IF EXISTS anon_write_non_sale_consumption ON non_sale_consumption;
CREATE POLICY anon_write_non_sale_consumption ON non_sale_consumption
  FOR INSERT TO anon WITH CHECK (true);

DROP POLICY IF EXISTS anon_write_goods_receipts ON goods_receipts;
CREATE POLICY anon_write_goods_receipts ON goods_receipts
  FOR INSERT TO anon WITH CHECK (true);

DROP POLICY IF EXISTS anon_update_goods_receipts ON goods_receipts;
CREATE POLICY anon_update_goods_receipts ON goods_receipts
  FOR UPDATE TO anon USING (true);

DROP POLICY IF EXISTS anon_write_grn_lines ON grn_lines;
CREATE POLICY anon_write_grn_lines ON grn_lines
  FOR INSERT TO anon WITH CHECK (true);

SELECT 'WRITE POLICIES FOR ANON APPLIED OK' as status;
