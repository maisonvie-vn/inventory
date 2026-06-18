-- Sync Cocktail Sangria (M7020) recipe and POS mapping
BEGIN;

-- Insert pos_alias_map for M7020
INSERT INTO pos_alias_map (pos_code, menu_item_id, confidence) VALUES ('M7020', 'M7020', 100.00) ON CONFLICT (pos_code) DO NOTHING;

-- Insert recipes (BOM) for M7020
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('M7020', '55a6e0c8-b2e5-40a3-ba73-65d3640b6adb', 15.0000, 100.00, 'ML') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('M7020', '74d13a14-84d8-4220-9ae9-103bc12a079d', 15.0000, 100.00, 'ML') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('M7020', '90da7614-aa09-4e09-b3ec-24dec41cda04', 120.0000, 100.00, 'ML') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('M7020', '42126737-37d6-4598-9ef0-0add4e120112', 0.0300, 100.00, 'L') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('M7020', '1b12c310-56a8-4921-b132-9791a01ed99d', 50.0000, 100.00, 'G') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;

COMMIT;
