-- Sync Cocktail Sangria (M7020) recipe and POS mapping
BEGIN;

-- Insert pos_alias_map for M7020
INSERT INTO pos_alias_map (pos_code, menu_item_id, confidence) VALUES ('M7020', 'M7020', 100.00) ON CONFLICT (pos_code) DO NOTHING;

-- Insert recipes (BOM) for M7020
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('M7020', 'M9801', 15.0000, 100.00, 'ML') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('M7020', 'ING-072', 15.0000, 100.00, 'ML') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('M7020', 'ING-115', 120.0000, 100.00, 'ML') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('M7020', 'ING-110', 0.0300, 100.00, 'L') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('M7020', 'ING-049', 50.0000, 100.00, 'G') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;

COMMIT;
