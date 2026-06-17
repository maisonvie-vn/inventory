-- Sync Tonic (M6003) POS mapping and recipe
BEGIN;

INSERT INTO pos_alias_map (pos_code, menu_item_id, confidence) VALUES ('M6003', 'M6003', 100.00) ON CONFLICT (pos_code) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('M6003', 'M6003', 1.0000, 100.00, 'CAN') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO ingredient_departments (ingredient_id, department, usage_context, is_primary) VALUES ('M6003', 'BAR', 'BEVERAGE', true) ON CONFLICT (ingredient_id, department) DO NOTHING;

COMMIT;
