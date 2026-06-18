
-- PATCH FOR STRAWBERRY INGREDIENTS IN DESSERT & STEAK RECIPES (18/06/2026)
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('R-021', '8e8ee667-7a5b-443d-8423-68dfa0e8f1c6', 0.015, 100.0, 'G') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('R-021', 'fd572f2a-6d16-48b9-b600-21cebc6618e3', 0.01, 100.0, 'G') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('R-022', '8e8ee667-7a5b-443d-8423-68dfa0e8f1c6', 0.01, 100.0, 'G') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('R-023', '8e8ee667-7a5b-443d-8423-68dfa0e8f1c6', 0.02, 100.0, 'G') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('R-024', '8e8ee667-7a5b-443d-8423-68dfa0e8f1c6', 0.015, 100.0, 'G') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('R-025', '8e8ee667-7a5b-443d-8423-68dfa0e8f1c6', 0.01, 100.0, 'G') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('R-025', 'fd572f2a-6d16-48b9-b600-21cebc6618e3', 0.01, 100.0, 'G') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('R-028', '8e8ee667-7a5b-443d-8423-68dfa0e8f1c6', 0.005, 100.0, 'G') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom) VALUES ('R-028', 'fd572f2a-6d16-48b9-b600-21cebc6618e3', 0.005, 100.0, 'G') ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
