-- Direct 1:1 items catalog synchronization
BEGIN;

-- 1. Insert Ingredients
INSERT INTO ingredients (id, code, nom_fr, ten_vi, name_en, purchase_category_id, stock_uom, recipe_uom, stock_to_recipe_factor, wac_price, standard_price, yield_rate, is_beverage) VALUES ('B5001', 'B5001', 'Heineken - 33cl', 'Heineken - 33cl', 'Heineken - 33cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5', 'BOTTLE', 'BOTTLE', 1, 14375.0, 14375.0, 100.0, true) ON CONFLICT (id) DO NOTHING;
INSERT INTO ingredients (id, code, nom_fr, ten_vi, name_en, purchase_category_id, stock_uom, recipe_uom, stock_to_recipe_factor, wac_price, standard_price, yield_rate, is_beverage) VALUES ('B5002', 'B5002', 'Tiger - 33cl', 'Tiger - 33cl', 'Tiger - 33cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5', 'BOTTLE', 'BOTTLE', 1, 11625.0, 11625.0, 100.0, true) ON CONFLICT (id) DO NOTHING;
INSERT INTO ingredients (id, code, nom_fr, ten_vi, name_en, purchase_category_id, stock_uom, recipe_uom, stock_to_recipe_factor, wac_price, standard_price, yield_rate, is_beverage) VALUES ('B5004', 'B5004', 'Beer 333 - 33cl', 'Beer 333 - 33cl', 'Beer 333 - 33cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5', 'CAN', 'CAN', 1, 9792.0, 9792.0, 100.0, true) ON CONFLICT (id) DO NOTHING;
INSERT INTO ingredients (id, code, nom_fr, ten_vi, name_en, purchase_category_id, stock_uom, recipe_uom, stock_to_recipe_factor, wac_price, standard_price, yield_rate, is_beverage) VALUES ('B5005', 'B5005', 'Saigon beer - bottle 33cl', 'Saigon beer - bottle 33cl', 'Saigon beer - bottle 33cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5', 'BOTTLE', 'BOTTLE', 1, 10750.0, 10750.0, 100.0, true) ON CONFLICT (id) DO NOTHING;
INSERT INTO ingredients (id, code, nom_fr, ten_vi, name_en, purchase_category_id, stock_uom, recipe_uom, stock_to_recipe_factor, wac_price, standard_price, yield_rate, is_beverage) VALUES ('B5007', 'B5007', 'Sapporo draught', 'Sapporo draught', 'Sapporo draught', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5', 'GLASS', 'GLASS', 1, 16436.0, 16436.0, 100.0, true) ON CONFLICT (id) DO NOTHING;
INSERT INTO ingredients (id, code, nom_fr, ten_vi, name_en, purchase_category_id, stock_uom, recipe_uom, stock_to_recipe_factor, wac_price, standard_price, yield_rate, is_beverage) VALUES ('B5010', 'B5010', 'Hanoi - bottle 33cl', 'Hanoi - bottle 33cl', 'Hanoi - bottle 33cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5', 'BOTTLE', 'BOTTLE', 1, 9750.0, 9750.0, 100.0, true) ON CONFLICT (id) DO NOTHING;
INSERT INTO ingredients (id, code, nom_fr, ten_vi, name_en, purchase_category_id, stock_uom, recipe_uom, stock_to_recipe_factor, wac_price, standard_price, yield_rate, is_beverage) VALUES ('B5012', 'B5012', 'Hanoi - can', 'Hanoi - can', 'Hanoi - can', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5', 'CAN', 'CAN', 1, 9833.0, 9833.0, 100.0, true) ON CONFLICT (id) DO NOTHING;
INSERT INTO ingredients (id, code, nom_fr, ten_vi, name_en, purchase_category_id, stock_uom, recipe_uom, stock_to_recipe_factor, wac_price, standard_price, yield_rate, is_beverage) VALUES ('M9203', 'M9203', 'Cigar Havana', 'Cigar Havana', 'Cigar Havana', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5', 'PACK', 'PACK', 1, 300000.0, 300000.0, 100.0, true) ON CONFLICT (id) DO NOTHING;
INSERT INTO ingredients (id, code, nom_fr, ten_vi, name_en, purchase_category_id, stock_uom, recipe_uom, stock_to_recipe_factor, wac_price, standard_price, yield_rate, is_beverage) VALUES ('M6001', 'M6001', 'Coke', 'Coke', 'Coke', 'b3b4e57e-464d-562f-80ec-b216c92d5e88', 'CAN', 'CAN', 1, 8125.0, 8125.0, 100.0, true) ON CONFLICT (id) DO NOTHING;
INSERT INTO ingredients (id, code, nom_fr, ten_vi, name_en, purchase_category_id, stock_uom, recipe_uom, stock_to_recipe_factor, wac_price, standard_price, yield_rate, is_beverage) VALUES ('M6002', 'M6002', 'Soda', 'Soda', 'Soda', 'b3b4e57e-464d-562f-80ec-b216c92d5e88', 'CAN', 'CAN', 1, 5304.0, 5304.0, 100.0, true) ON CONFLICT (id) DO NOTHING;
INSERT INTO ingredients (id, code, nom_fr, ten_vi, name_en, purchase_category_id, stock_uom, recipe_uom, stock_to_recipe_factor, wac_price, standard_price, yield_rate, is_beverage) VALUES ('M6004', 'M6004', 'Sprite', 'Sprite', 'Sprite', 'b3b4e57e-464d-562f-80ec-b216c92d5e88', 'CAN', 'CAN', 1, 7462.0, 7462.0, 100.0, true) ON CONFLICT (id) DO NOTHING;
INSERT INTO ingredients (id, code, nom_fr, ten_vi, name_en, purchase_category_id, stock_uom, recipe_uom, stock_to_recipe_factor, wac_price, standard_price, yield_rate, is_beverage) VALUES ('M6006', 'M6006', 'Diet Coke', 'Diet Coke', 'Diet Coke', 'b3b4e57e-464d-562f-80ec-b216c92d5e88', 'CAN', 'CAN', 1, 8541.0, 8541.0, 100.0, true) ON CONFLICT (id) DO NOTHING;
INSERT INTO ingredients (id, code, nom_fr, ten_vi, name_en, purchase_category_id, stock_uom, recipe_uom, stock_to_recipe_factor, wac_price, standard_price, yield_rate, is_beverage) VALUES ('M6008', 'M6008', 'La Vie 1,5 L', 'La Vie 1,5 L', 'La Vie 1,5 L', 'b3b4e57e-464d-562f-80ec-b216c92d5e88', 'BOTTLE', 'BOTTLE', 1, 6666.0, 6666.0, 100.0, true) ON CONFLICT (id) DO NOTHING;
INSERT INTO ingredients (id, code, nom_fr, ten_vi, name_en, purchase_category_id, stock_uom, recipe_uom, stock_to_recipe_factor, wac_price, standard_price, yield_rate, is_beverage) VALUES ('M6010', 'M6010', 'S.Pellegrino (Sparkling water 0.5L)', 'S.Pellegrino (Sparkling water 0.5L)', 'S.Pellegrino (Sparkling water 0.5L)', 'b3b4e57e-464d-562f-80ec-b216c92d5e88', 'BOTTLE', 'BOTTLE', 1, 36300.0, 36300.0, 100.0, true) ON CONFLICT (id) DO NOTHING;
INSERT INTO ingredients (id, code, nom_fr, ten_vi, name_en, purchase_category_id, stock_uom, recipe_uom, stock_to_recipe_factor, wac_price, standard_price, yield_rate, is_beverage) VALUES ('M6020', 'M6020', 'Maison Vie, mineral water bottle 0,52L', 'Maison Vie, mineral water bottle 0,52L', 'Maison Vie, mineral water bottle 0,52L', 'b3b4e57e-464d-562f-80ec-b216c92d5e88', 'BOTTLE', 'BOTTLE', 1, 3561.84, 3561.84, 100.0, true) ON CONFLICT (id) DO NOTHING;

-- 2. Insert Recipes for Direct Soft Drinks and Cigar
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('M9203', 'M9203', 1.0000, 100.00, 'PACK') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('M6001', 'M6001', 1.0000, 100.00, 'CAN') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('M6002', 'M6002', 1.0000, 100.00, 'CAN') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('M6004', 'M6004', 1.0000, 100.00, 'CAN') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('M6006', 'M6006', 1.0000, 100.00, 'CAN') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('M6008', 'M6008', 1.0000, 100.00, 'BOTTLE') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('M6010', 'M6010', 1.0000, 100.00, 'BOTTLE') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('M6020', 'M6020', 1.0000, 100.00, 'BOTTLE') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;

-- 3. Insert POS Alias Map
INSERT INTO pos_alias_map (pos_code, menu_item_id, confidence) VALUES ('B5001', 'B5001', 100.00) ON CONFLICT (pos_code) DO NOTHING;
INSERT INTO pos_alias_map (pos_code, menu_item_id, confidence) VALUES ('B5002', 'B5002', 100.00) ON CONFLICT (pos_code) DO NOTHING;
INSERT INTO pos_alias_map (pos_code, menu_item_id, confidence) VALUES ('B5004', 'B5004', 100.00) ON CONFLICT (pos_code) DO NOTHING;
INSERT INTO pos_alias_map (pos_code, menu_item_id, confidence) VALUES ('B5005', 'B5005', 100.00) ON CONFLICT (pos_code) DO NOTHING;
INSERT INTO pos_alias_map (pos_code, menu_item_id, confidence) VALUES ('B5007', 'B5007', 100.00) ON CONFLICT (pos_code) DO NOTHING;
INSERT INTO pos_alias_map (pos_code, menu_item_id, confidence) VALUES ('B5010', 'B5010', 100.00) ON CONFLICT (pos_code) DO NOTHING;
INSERT INTO pos_alias_map (pos_code, menu_item_id, confidence) VALUES ('B5012', 'B5012', 100.00) ON CONFLICT (pos_code) DO NOTHING;
INSERT INTO pos_alias_map (pos_code, menu_item_id, confidence) VALUES ('M9203', 'M9203', 100.00) ON CONFLICT (pos_code) DO NOTHING;
INSERT INTO pos_alias_map (pos_code, menu_item_id, confidence) VALUES ('M6001', 'M6001', 100.00) ON CONFLICT (pos_code) DO NOTHING;
INSERT INTO pos_alias_map (pos_code, menu_item_id, confidence) VALUES ('M6002', 'M6002', 100.00) ON CONFLICT (pos_code) DO NOTHING;
INSERT INTO pos_alias_map (pos_code, menu_item_id, confidence) VALUES ('M6004', 'M6004', 100.00) ON CONFLICT (pos_code) DO NOTHING;
INSERT INTO pos_alias_map (pos_code, menu_item_id, confidence) VALUES ('M6006', 'M6006', 100.00) ON CONFLICT (pos_code) DO NOTHING;
INSERT INTO pos_alias_map (pos_code, menu_item_id, confidence) VALUES ('M6008', 'M6008', 100.00) ON CONFLICT (pos_code) DO NOTHING;
INSERT INTO pos_alias_map (pos_code, menu_item_id, confidence) VALUES ('M6010', 'M6010', 100.00) ON CONFLICT (pos_code) DO NOTHING;
INSERT INTO pos_alias_map (pos_code, menu_item_id, confidence) VALUES ('M6020', 'M6020', 100.00) ON CONFLICT (pos_code) DO NOTHING;

-- 4. Insert Ingredient Departments
INSERT INTO ingredient_departments (ingredient_id, department, usage_context, is_primary) VALUES ('B5001', 'BAR', 'BEVERAGE', true) ON CONFLICT (ingredient_id, department) DO NOTHING;
INSERT INTO ingredient_departments (ingredient_id, department, usage_context, is_primary) VALUES ('B5002', 'BAR', 'BEVERAGE', true) ON CONFLICT (ingredient_id, department) DO NOTHING;
INSERT INTO ingredient_departments (ingredient_id, department, usage_context, is_primary) VALUES ('B5004', 'BAR', 'BEVERAGE', true) ON CONFLICT (ingredient_id, department) DO NOTHING;
INSERT INTO ingredient_departments (ingredient_id, department, usage_context, is_primary) VALUES ('B5005', 'BAR', 'BEVERAGE', true) ON CONFLICT (ingredient_id, department) DO NOTHING;
INSERT INTO ingredient_departments (ingredient_id, department, usage_context, is_primary) VALUES ('B5007', 'BAR', 'BEVERAGE', true) ON CONFLICT (ingredient_id, department) DO NOTHING;
INSERT INTO ingredient_departments (ingredient_id, department, usage_context, is_primary) VALUES ('B5010', 'BAR', 'BEVERAGE', true) ON CONFLICT (ingredient_id, department) DO NOTHING;
INSERT INTO ingredient_departments (ingredient_id, department, usage_context, is_primary) VALUES ('B5012', 'BAR', 'BEVERAGE', true) ON CONFLICT (ingredient_id, department) DO NOTHING;
INSERT INTO ingredient_departments (ingredient_id, department, usage_context, is_primary) VALUES ('M9203', 'BAR', 'BEVERAGE', true) ON CONFLICT (ingredient_id, department) DO NOTHING;
INSERT INTO ingredient_departments (ingredient_id, department, usage_context, is_primary) VALUES ('M6001', 'BAR', 'BEVERAGE', true) ON CONFLICT (ingredient_id, department) DO NOTHING;
INSERT INTO ingredient_departments (ingredient_id, department, usage_context, is_primary) VALUES ('M6002', 'BAR', 'BEVERAGE', true) ON CONFLICT (ingredient_id, department) DO NOTHING;
INSERT INTO ingredient_departments (ingredient_id, department, usage_context, is_primary) VALUES ('M6004', 'BAR', 'BEVERAGE', true) ON CONFLICT (ingredient_id, department) DO NOTHING;
INSERT INTO ingredient_departments (ingredient_id, department, usage_context, is_primary) VALUES ('M6006', 'BAR', 'BEVERAGE', true) ON CONFLICT (ingredient_id, department) DO NOTHING;
INSERT INTO ingredient_departments (ingredient_id, department, usage_context, is_primary) VALUES ('M6008', 'BAR', 'BEVERAGE', true) ON CONFLICT (ingredient_id, department) DO NOTHING;
INSERT INTO ingredient_departments (ingredient_id, department, usage_context, is_primary) VALUES ('M6010', 'BAR', 'BEVERAGE', true) ON CONFLICT (ingredient_id, department) DO NOTHING;
INSERT INTO ingredient_departments (ingredient_id, department, usage_context, is_primary) VALUES ('M6020', 'BAR', 'BEVERAGE', true) ON CONFLICT (ingredient_id, department) DO NOTHING;

COMMIT;
