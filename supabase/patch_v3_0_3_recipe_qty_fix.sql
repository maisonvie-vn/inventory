-- ============================================================
-- PATCH v3.0.3 — Sửa recipe qty_net cho wine bottle items
-- Vấn đề: qty_net = 1 ML (sai) → qty_eff = 1/750 bottle per sale
--         Đúng ra: bán 1 chai = trừ 750 ML = 1 bottle
-- Fix: qty_net = 750 (ML) cho tất cả wine bottle recipes
-- ============================================================

-- TRƯỚC KHI SỬA: Kiểm tra số lượng affected
DO $$
DECLARE v_count int;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM recipes r
  JOIN ingredients i ON i.id = r.ingredient_id
  WHERE i.stock_uom = 'BOTTLE'
    AND i.recipe_uom = 'ML'
    AND r.qty_net = 1;
  
  RAISE NOTICE 'Sẽ cập nhật % recipes (qty_net 1ML → 750ML)', v_count;
END;
$$;

-- FIX: Cập nhật qty_net = 750 (1 bottle đầy đủ) cho tất cả wine bottle recipes
UPDATE recipes r
SET qty_net = 750
FROM ingredients i
WHERE r.ingredient_id = i.id
  AND i.stock_uom = 'BOTTLE'
  AND i.recipe_uom = 'ML'
  AND r.qty_net = 1;

-- Kiểm tra kết quả sau fix
SELECT 
  COUNT(*) as recipes_fixed,
  MIN(r.qty_eff) as qty_eff_min,
  MAX(r.qty_eff) as qty_eff_max
FROM recipes r
JOIN ingredients i ON i.id = r.ingredient_id
WHERE i.stock_uom = 'BOTTLE'
  AND i.recipe_uom = 'ML'
  AND r.qty_net = 750;

-- Xác nhận V6027 đã đúng
SELECT 
  m.name,
  r.qty_net, r.qty_eff, i.stock_to_recipe_factor,
  (r.qty_eff / i.stock_to_recipe_factor) as bottles_deducted_per_sale
FROM recipes r
JOIN ingredients i ON i.id = r.ingredient_id
JOIN menu_items m ON m.id = r.menu_item_id
WHERE r.menu_item_id IN ('V6027', 'V6049', 'V6057', 'V8001')
ORDER BY m.id;
