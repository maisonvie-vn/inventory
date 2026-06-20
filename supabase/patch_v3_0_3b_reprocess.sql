-- PATCH v3.0.3b — Reset và reprocess toàn bộ sales với recipe đúng
-- Chạy với SECURITY DEFINER để bypass RLS

-- Bước 1: Xóa toàn bộ SALE_DEPLETION từ sales_imports (sai recipe cũ)
DELETE FROM inventory_transactions
WHERE ref_table = 'sales_imports'
  AND txn_type = 'SALE_DEPLETION';

-- Bước 2: Reset is_processed = false cho MAPPED sales
UPDATE sales_imports
SET is_processed = false
WHERE mapping_status = 'MAPPED'
  AND is_processed = true;

-- Bước 3: Reprocess tất cả
SELECT * FROM reprocess_unprocessed_sales(NULL);

-- Bước 4: Kiểm tra kết quả
SELECT 
  (SELECT COUNT(*) FROM sales_imports WHERE is_processed = true AND mapping_status = 'MAPPED') as processed_ok,
  (SELECT COUNT(*) FROM sales_imports WHERE is_processed = false) as still_pending,
  (SELECT COUNT(*) FROM inventory_transactions WHERE txn_type = 'SALE_DEPLETION') as depletion_txns,
  (SELECT COALESCE(SUM(qty),0) FROM inventory_transactions 
   WHERE ingredient_id = 'f862aa3e-631d-4569-935f-350e05374838' AND status = 'approved') as luis_felipe_stock;
