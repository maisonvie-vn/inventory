-- ============================================================
-- PATCH v3.0.10 — Bổ sung khóa ngoại fk_po_lines_ing_uuid (ingredient_id -> ingredients)
-- Sửa lỗi: Truy vấn liên kết po_lines và ingredients thất bại trên API Supabase
-- ============================================================

-- Thêm khóa ngoại cho bảng po_lines để Supabase PostgREST tự động nhận dạng mối quan hệ
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 
    FROM pg_constraint 
    WHERE conname = 'po_lines_ingredient_id_fkey'
  ) THEN
    ALTER TABLE po_lines 
    ADD CONSTRAINT po_lines_ingredient_id_fkey 
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(id);
  END IF;
END $$;
