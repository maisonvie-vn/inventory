-- =====================================================================
-- SQL PATCH FOR POS AUDIT & SYNC (GENERATED 2026-06-18T10:03:58.875Z)
-- Adds missing UOMs, 818 ingredients, 854 menu items and recipes.
-- =====================================================================

BEGIN;

-- 0. INSERT MISSING UOMS
INSERT INTO uom (id, name, uom_type) VALUES 
('CUP', 'Cúp/Ly nhỏ', 'COUNT'),
('PLATE', 'Đĩa', 'COUNT'),
('BOWL', 'Bát/Tô', 'COUNT'),
('PAX', 'Khách/Suất', 'COUNT')
ON CONFLICT (id) DO NOTHING;

-- 1. INSERT NEW INGREDIENTS
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'fc539ce1-5824-4520-adaf-da57582000ab', 'B5003', 'Halida,  33cl', 'Halida,  33cl', 'Halida,  33cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'CAN', 'CAN', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2959706f-50a1-48b6-a014-0cb07a8f552f', 'B5006', 'Pilsner - 33cl', 'Pilsner - 33cl', 'Pilsner - 33cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '640c25ae-07e2-4b5d-95e4-cdac86df3cad', 'B5013', 'Carlsberg draught', 'Carlsberg draught', 'Carlsberg draught', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '221f21ec-9db8-4252-b5bd-d0bceb7e62f7', 'B5008', 'Sapporo — bottle 33cl', 'Sapporo — bottle 33cl', 'Sapporo — bottle 33cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '470c968a-16f9-484a-8186-51487626504c', 'M1001', 'Campari Glass', 'Campari Glass', 'Campari Glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'aa86bb4b-9f1f-4dd4-8d82-ba5469c6f3d5', 'M1002', 'Martini Rosso Glass', 'Martini Rosso Glass', 'Martini Rosso Glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f95ccde5-4f05-42f2-8a62-78206140d850', 'M1003', 'Martini Bianco Glass', 'Martini Bianco Glass', 'Martini Bianco Glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '78a09c2f-18ec-4eb5-a3a2-9d92ca6fdd7d', 'M1004', 'Martini Dry Glass', 'Martini Dry Glass', 'Martini Dry Glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '283bdbce-f4ee-4763-8a1e-9e34c7eb4ab5', 'M1005', 'Ricard Glass', 'Ricard Glass', 'Ricard Glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '61779538-553b-4154-9bba-607232a7e506', 'M1006', 'Porto Glass', 'Porto Glass', 'Porto Glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9182a108-7e64-4ed8-a937-6244695f34ca', 'M1007', 'Kir Glass', 'Kir Glass', 'Kir Glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2ba33bd6-1174-415e-9afe-f5a8e11939b1', 'M2001', 'Cointreau', 'Cointreau', 'Cointreau', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '89160b00-35eb-4268-8ba2-881c26e33920', 'M2002', 'Baileys', 'Baileys', 'Baileys', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'aaea1540-9cf4-4971-8be9-6d4755d9651e', 'M2003', 'Grand Marnier', 'Grand Marnier', 'Grand Marnier', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1373c441-433a-429e-97c6-11e194daee54', 'M3001', 'Gordons Gin Glass', 'Gordons Gin Glass', 'Gordons Gin Glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b82d2df4-5a46-46f6-b0e9-1c566a2170c4', 'M3002', 'Russian Vodka Glass', 'Russian Vodka Glass', 'Russian Vodka Glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'fbffb391-4117-4dc4-91a8-de959e2d56b8', 'M3003', 'Johnnie walker red label  glass', 'Johnnie walker red label  glass', 'Johnnie walker red label  glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'caaef60e-7957-41cf-886e-bcceacef84fa', 'M3004', 'Johnnie walker black label glass', 'Johnnie walker black label glass', 'Johnnie walker black label glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9fda9376-9196-416d-92c2-82170fff85dd', 'M3005', 'Chivas regal glass', 'Chivas regal glass', 'Chivas regal glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0c96c8b5-66bc-4d6c-a1db-99c6408cf914', 'M3006', 'J & B rare glass', 'J & B rare glass', 'J & B rare glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '85977081-a7b7-4e49-b7ad-4bb988fb43b5', 'M4001', 'Bacardi white', 'Bacardi white', 'Bacardi white', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '7d5bf817-e32e-466f-9f24-cccb8c572820', 'M5001', 'Hennessy V.S.O.P Glass', 'Hennessy V.S.O.P Glass', 'Hennessy V.S.O.P Glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '04b039ee-2adb-4c87-994b-ae250335de45', 'M5002', 'Remy martin V.S.O.P', 'Remy martin V.S.O.P', 'Remy martin V.S.O.P', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c3b5e811-9f5f-4c78-bc2f-2f93a7caf948', 'M5003', 'Hennessy X.O Glass', 'Hennessy X.O Glass', 'Hennessy X.O Glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '4fd88f2f-60de-4f4a-a702-858ebfcbbaba', 'M5004', 'Framboise', 'Framboise', 'Framboise', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '78c1d4fb-8588-4088-96a3-85a990d3cb1b', 'M5005', 'Prune', 'Prune', 'Prune', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '01ea8e95-628e-41f3-8670-615676275dbe', 'M5006', 'Poire William Glass', 'Poire William Glass', 'Poire William Glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ae524f11-0bc6-41b5-b0f1-a536e2f83fff', 'M6007', 'La Vie 0,5L', 'La Vie 0,5L', 'La Vie 0,5L', 'b3b4e57e-464d-562f-80ec-b216c92d5e88',
      'BOTTLE', 'BOTTLE', 1, 450,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '71bcb761-bfd9-4e86-9a1c-c7ba48985492', 'M7004', 'Lemon Milk', 'Lemon Milk', 'Lemon Milk', 'b3b4e57e-464d-562f-80ec-b216c92d5e88',
      'GLASS', 'GLASS', 1, 450,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd20c3676-06ac-410c-8480-04fe066ec3c2', 'M8003', 'Campari & orange juice', 'Campari & orange juice', 'Campari & orange juice', 'b3b4e57e-464d-562f-80ec-b216c92d5e88',
      'GLASS', 'GLASS', 1, 450,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '36a3184e-efe8-444a-9aa0-f6ccdf588424', 'M8004', 'Campari & soda', 'Campari & soda', 'Campari & soda', 'b3b4e57e-464d-562f-80ec-b216c92d5e88',
      'GLASS', 'GLASS', 1, 450,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '58432f6e-28c4-4126-96d1-88e5fbd5a6fb', 'M9007', 'Vietnamese tea', 'Vietnamese tea', 'Vietnamese tea', 'b3b4e57e-464d-562f-80ec-b216c92d5e88',
      'CUP', 'CUP', 1, 450,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f413d047-e4cb-4b25-939c-9fafc1a6ebe9', 'M9103', 'Red wine glass  CHILE - Luis Felipe', 'Red wine glass  CHILE - Luis Felipe', 'Red wine glass  CHILE - Luis Felipe', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '8e03be83-8290-4853-99fe-253a20eed910', 'M9105', 'Sparkling wine glass', 'Sparkling wine glass', 'Sparkling wine glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '800c7c86-a9da-4465-9e46-100aa1b2f12c', 'M9201', 'Cigarettes Local', 'Cigarettes Local', 'Cigarettes Local', 'b3b4e57e-464d-562f-80ec-b216c92d5e88',
      'PACK', 'PACK', 1, 450,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2d9194a9-762c-4d26-be79-1c02b4ee59fd', 'M9401', 'Amaretto', 'Amaretto', 'Amaretto', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '90f7d7e5-b25d-4e76-9869-3255ef301455', 'M9404', 'Cinzano Dry', 'Cinzano Dry', 'Cinzano Dry', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1f097715-42d3-423d-8d84-4c0bbbb17469', 'M9412', 'Port Cockburns', 'Port Cockburns', 'Port Cockburns', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '888f7db8-e7e4-447c-84ca-5f1880b53e27', 'M9501', 'Absolut 0.7L', 'Absolut 0.7L', 'Absolut 0.7L', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ed8b0f4d-9f84-4ae8-b822-63cbec732670', 'M9502', 'Absolut 1L', 'Absolut 1L', 'Absolut 1L', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '16ecc398-203f-45a7-b106-650b93c67b05', 'M9503', 'Beluga', 'Beluga', 'Beluga', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2788fd48-adc7-46d9-88c8-7169b1252ef5', 'M9504', 'Black vodka', 'Black vodka', 'Black vodka', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '854d7dbe-9a31-45e8-a76d-9fec11143ff0', 'M9505', 'Lua moi 300ml', 'Lua moi 300ml', 'Lua moi 300ml', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '3b9a012f-2e90-4334-97c7-b574e110ee34', 'M9506', 'Lua moi 750ml', 'Lua moi 750ml', 'Lua moi 750ml', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '20628882-8388-4584-a013-8d2ed859e13a', 'M9509', 'Nep moi 700ml', 'Nep moi 700ml', 'Nep moi 700ml', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2f158c26-952e-4c2f-a097-4032ec6e5af4', 'M9510', 'Putinka', 'Putinka', 'Putinka', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '94c082ef-c31c-4bca-a4f3-4554b500f545', 'M9511', 'Russian Vodka Red Label', 'Russian Vodka Red Label', 'Russian Vodka Red Label', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9db40cb7-69ac-4a59-b02b-22fb90f29a66', 'M9601', 'Ballantines', 'Ballantines', 'Ballantines', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '7eebdc68-8da6-47e3-ae7c-736e31fc64d7', 'M9605', 'Ballentines 30', 'Ballentines 30', 'Ballentines 30', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '09cc3c6b-12d8-430c-b532-c76ff650e4d9', 'M9607', 'Chivas 18 years old', 'Chivas 18 years old', 'Chivas 18 years old', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6707f736-1f16-4a1d-ab08-fb8d7fce0d9c', 'M9608', 'Chivas Regal 0.37', 'Chivas Regal 0.37', 'Chivas Regal 0.37', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '8f9ca7e1-5b5a-4aaf-aef4-76335543a559', 'M9610', 'Chivas regal 21 years old', 'Chivas regal 21 years old', 'Chivas regal 21 years old', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9a91ef02-19e6-4059-a9d6-a0cc22d05da1', 'M9613', 'Gin bombay', 'Gin bombay', 'Gin bombay', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '28a1eaed-e0c9-4657-9fc7-dabfc189c338', 'M9614', 'Glenfidich', 'Glenfidich', 'Glenfidich', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '00e4cbbb-d909-40f8-ae7b-69932223dffa', 'M9615', 'Glenfidich 15 years old', 'Glenfidich 15 years old', 'Glenfidich 15 years old', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '83e914fe-2596-4569-9309-1ba6b33881e4', 'M9616', 'Glenfidich 18 years old', 'Glenfidich 18 years old', 'Glenfidich 18 years old', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5facb539-83ca-4cf4-abdd-fe5ed287e34b', 'M9617', 'Glenlivert 18', 'Glenlivert 18', 'Glenlivert 18', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f3e8b010-0418-48fc-b4fb-896113d9a2f4', 'M9618', 'Grants', 'Grants', 'Grants', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e683130a-447c-42e0-aa86-6b62fd73955a', 'M9619', 'Havana club', 'Havana club', 'Havana club', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'dd29b1f0-8893-43bd-9846-201de0557076', 'M9622', 'Jameson', 'Jameson', 'Jameson', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2a8ae897-b196-48c4-abf5-56c3003144ad', 'M9624', 'Johnie Gold label', 'Johnie Gold label', 'Johnie Gold label', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'efc8bb4a-f48e-41a3-868a-453f895d5bc4', 'M9625', 'Johnnie Green Label', 'Johnnie Green Label', 'Johnnie Green Label', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9c5fc135-8b3d-430b-aeff-ccb1b839ff9f', 'M9626', 'Johnnie Walker X.R 21 years', 'Johnnie Walker X.R 21 years', 'Johnnie Walker X.R 21 years', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ef433b5e-7f31-4d5c-a525-6d2d100cdc16', 'M9627', 'Johnny Walker Black label', 'Johnny Walker Black label', 'Johnny Walker Black label', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '55befa44-aa24-4ad5-ace5-f1162c35cc58', 'M9628', 'Johnny Walker Blue label', 'Johnny Walker Blue label', 'Johnny Walker Blue label', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2c7f3096-aa1d-4e70-96c1-7f47b6e4ba35', 'M9630', 'Johnny Walker Double Black 1L', 'Johnny Walker Double Black 1L', 'Johnny Walker Double Black 1L', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b55d5724-f4ef-482f-8742-d69fc965fe74', 'M9631', 'Macallan 18year', 'Macallan 18year', 'Macallan 18year', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '85c2f746-01e9-49d8-9f73-814c7a8a1ae9', 'M9633', 'Platinum label', 'Platinum label', 'Platinum label', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9f0fb79b-f685-428b-9b5e-a2e79416c950', 'M9701', 'Bacardi Gold', 'Bacardi Gold', 'Bacardi Gold', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '07af13dd-f275-413d-9ef5-e120bf4d9f8b', 'M9703', 'Tequila Gold', 'Tequila Gold', 'Tequila Gold', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'bdf385c3-8d90-4c86-8e70-62c5c7b33e8d', 'M9704', 'Tequila Green label white', 'Tequila Green label white', 'Tequila Green label white', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '210654be-82c5-4b03-a1a6-a71b46672b70', 'M9807', 'Hennessy VSOP 0.37', 'Hennessy VSOP 0.37', 'Hennessy VSOP 0.37', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6c0f8e42-1a08-4ba2-b99f-ef2c4883b91e', 'M9810', 'Martell VSOP', 'Martell VSOP', 'Martell VSOP', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '656a9d1e-8314-4508-a24b-c252f4fc26b6', 'M9811', 'Matell XO', 'Matell XO', 'Matell XO', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd129239d-c483-478c-bb67-484e23fc8c13', 'M9813', 'Remy Martin XO', 'Remy Martin XO', 'Remy Martin XO', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c6690943-b112-4148-bfd3-fbecb3d76e58', 'R1101', 'Chef''s salad', 'Chef''s salad', 'Chef''s salad', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '06a3b653-b736-43a6-bc35-4c0779a67be2', 'R1102', 'Nicoise salad with anchovies', 'Nicoise salad with anchovies', 'Nicoise salad with anchovies', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9b203124-b34f-4cbe-917c-5e049bbbf62e', 'R1103', 'Garden vegetables with nuts, orange balsamic dressing', 'Garden vegetables with nuts, orange balsamic dressing', 'Garden vegetables with nuts, orange balsamic dressing', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '8fe0f4ae-8d83-4d92-a8ab-a61c8920b621', 'R1104', 'Chicken caesar salad', 'Chicken caesar salad', 'Chicken caesar salad', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2e979530-655a-44d3-b6a2-0a55ded50c6b', 'R1105', 'Tuna cappaccio with quail egg and sesame oil', 'Tuna cappaccio with quail egg and sesame oil', 'Tuna cappaccio with quail egg and sesame oil', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '53e7a1a1-185f-4dee-869f-b42548d7f794', 'R1106', 'Smoke salmon cucumber black pearl cream', 'Smoke salmon cucumber black pearl cream', 'Smoke salmon cucumber black pearl cream', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '51be2541-185f-499b-9dc7-20445ba95f63', 'R1107', 'Assorted ham, salami and terrine mustard Dijon', 'Assorted ham, salami and terrine mustard Dijon', 'Assorted ham, salami and terrine mustard Dijon', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '38115432-8f3b-4ea9-a484-708922bb0cd3', 'R1108', 'Foie gras salad with quail egg Serano ham', 'Foie gras salad with quail egg Serano ham', 'Foie gras salad with quail egg Serano ham', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b4dd0b6b-fbb8-45c9-8898-069ecc11fa0d', 'R1109', 'Lobster caesar salad', 'Lobster caesar salad', 'Lobster caesar salad', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '71703893-815d-44fc-bcce-628d03e81790', 'R1007', 'Seasonal vegetable soup', 'Seasonal vegetable soup', 'Seasonal vegetable soup', NULL,
      'BOWL', 'BOWL', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2db6c2d7-bb24-4039-a77d-8c6c9752ae8e', 'R2101', 'SIGNATURE Vietnamese buffalo fillet 150gr', 'SIGNATURE Vietnamese buffalo fillet 150gr', 'SIGNATURE Vietnamese buffalo fillet 150gr', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '8f37cd90-4a75-4838-a7d5-95c6c1b59c1c', 'R2102', 'SIGNATURE Pork shank stew with Hanoi beer', 'SIGNATURE Pork shank stew with Hanoi beer', 'SIGNATURE Pork shank stew with Hanoi beer', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'edf49010-38ae-4c76-bd3a-fb9bec7cae00', 'R2103', 'Grilled US beef rib eyes 150 gram', 'Grilled US beef rib eyes 150 gram', 'Grilled US beef rib eyes 150 gram', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '8a40c46e-4c0f-454d-9d04-4e5fdbf65b12', 'R2104', 'Grilled US beef striploin 150 gram', 'Grilled US beef striploin 150 gram', 'Grilled US beef striploin 150 gram', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1553e071-80d1-48e1-803a-0b4516e8a894', 'R2105', 'Grilled US T-bone signature sauce 350gm', 'Grilled US T-bone signature sauce 350gm', 'Grilled US T-bone signature sauce 350gm', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '8cf3b898-6201-4dfa-9ff9-fc163bdac9e4', 'R2106', 'Grilled US beef tenderloin 150 gram', 'Grilled US beef tenderloin 150 gram', 'Grilled US beef tenderloin 150 gram', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '42c28060-7057-4282-93fb-9eff99114ae9', 'R2107', 'Australian Wagyu rib eyes steak MBS 9+ 150gm', 'Australian Wagyu rib eyes steak MBS 9+ 150gm', 'Australian Wagyu rib eyes steak MBS 9+ 150gm', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '04622cd6-e318-46d0-a485-07236266885f', 'R2108', 'Grilled US topblade 180 gram', 'Grilled US topblade 180 gram', 'Grilled US topblade 180 gram', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'daa669ae-e130-46ae-b1a6-d1df7514f980', 'R2109', 'US Short rib boneless Prime Black Angus', 'US Short rib boneless Prime Black Angus', 'US Short rib boneless Prime Black Angus', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '18057bab-867f-4e07-838b-4f9fa99b7530', 'R2110', 'Vietnamese beef fillet signature sauce 150gm', 'Vietnamese beef fillet signature sauce 150gm', 'Vietnamese beef fillet signature sauce 150gm', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '28325307-0dda-4f8f-bc75-27e29dba582e', 'R2111', 'Slow cooked US beef short ribs', 'Slow cooked US beef short ribs', 'Slow cooked US beef short ribs', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '166b0235-7932-4985-a76f-2647ff7d6362', 'R2112', 'Burgundy beef stew mashed potatoes', 'Burgundy beef stew mashed potatoes', 'Burgundy beef stew mashed potatoes', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '139331ad-9c51-4480-98f1-e87f04ee75fe', 'R2113', 'Veal fillet with wild mushroom cream', 'Veal fillet with wild mushroom cream', 'Veal fillet with wild mushroom cream', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '81645fc4-65fb-4706-8814-f9cc439c435f', 'R3101', 'Basa fish fillet with dill butter sauce', 'Basa fish fillet with dill butter sauce', 'Basa fish fillet with dill butter sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '376c98ff-f147-4d2c-bc56-654ad612f905', 'R3102', 'Sea bass Bouilabaisse style', 'Sea bass Bouilabaisse style', 'Sea bass Bouilabaisse style', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f6c3ed0a-85e7-4eb3-8fd3-5e5ada1feebb', 'R3103', 'Pan-fried salmon fillet dry fig sauce', 'Pan-fried salmon fillet dry fig sauce', 'Pan-fried salmon fillet dry fig sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd5076e89-382e-4578-8479-0fd80bc6542d', 'R3104', 'Tuna Rossini with foie foie gras porto wine sauce', 'Tuna Rossini with foie foie gras porto wine sauce', 'Tuna Rossini with foie foie gras porto wine sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ba5ac651-925f-477a-a0ff-31109dc33ed7', 'R3105', 'Steamed cod fish fillet bisque sauce', 'Steamed cod fish fillet bisque sauce', 'Steamed cod fish fillet bisque sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'bff0b037-f8d3-47bc-8974-6cfe6e5ec3d0', 'R4001', 'Pasta with sauce Bolognaise', 'Pasta with sauce Bolognaise', 'Pasta with sauce Bolognaise', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5edf2446-1544-43b8-a940-184d206b3efb', 'R4002', 'Pasta with sauce Carbonara', 'Pasta with sauce Carbonara', 'Pasta with sauce Carbonara', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'cbc1da32-0a7a-4330-8eec-1ddfb587e595', 'R4003', 'Pasta with Grogonzola chesse sauce', 'Pasta with Grogonzola chesse sauce', 'Pasta with Grogonzola chesse sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1d8468e9-f035-4354-b07b-2b9bb7093f4b', 'R4004', 'Pasta with smoked salmon', 'Pasta with smoked salmon', 'Pasta with smoked salmon', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '886070e0-14d2-46d4-a615-5d010387a43e', 'R4005', 'Pasta with tomatoes and shrimps', 'Pasta with tomatoes and shrimps', 'Pasta with tomatoes and shrimps', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'dd13f3f0-d344-4e37-867f-44bce96798aa', 'R4006', 'Pasta with vegetable (vegetarian)', 'Pasta with vegetable (vegetarian)', 'Pasta with vegetable (vegetarian)', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b2a05135-45fb-41e9-b3d2-15dc58a53598', 'R4007', 'Couscous stuffed peppers (vegetarian)', 'Couscous stuffed peppers (vegetarian)', 'Couscous stuffed peppers (vegetarian)', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a725b308-0c18-48a7-8114-ae23d0c9d508', 'R5101', 'Chocolate lava cake coffee whipped cream', 'Chocolate lava cake coffee whipped cream', 'Chocolate lava cake coffee whipped cream', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '81befe8f-5543-4dab-b9f2-ccfc9b233ff2', 'R5102', 'Apple flower fine tart cinnamon ice cream', 'Apple flower fine tart cinnamon ice cream', 'Apple flower fine tart cinnamon ice cream', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '076a53e7-5e96-46b1-9b22-d08d49a8e35c', 'R5003', 'Crepes Suzette flambeed Grand Marnier', 'Crepes Suzette flambeed Grand Marnier', 'Crepes Suzette flambeed Grand Marnier', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '363743b2-e6f2-427a-9dfe-3372fac63055', 'R5004', 'Profiteroles with vanilla ice cream and hot chocolate sauce', 'Profiteroles with vanilla ice cream and hot chocolate sauce', 'Profiteroles with vanilla ice cream and hot chocolate sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1a1991a8-6c09-4c8a-8042-cfbec152ee62', 'R5104', 'Ice Drop 3 scoops of ice cream', 'Ice Drop 3 scoops of ice cream', 'Ice Drop 3 scoops of ice cream', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '8a401711-127b-4ca8-b50a-7bc22aa23ad9', 'R6260001', 'Set Menu 370A', 'Set Menu 370A', 'Set Menu 370A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5b2a082e-adb3-45e7-bbd5-dd96ac5ff74b', 'R6260002', 'Set Menu 370B', 'Set Menu 370B', 'Set Menu 370B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1a0a2a04-dc22-4cfa-b576-0e725768c28b', 'R6260003', 'Set Menu 370C', 'Set Menu 370C', 'Set Menu 370C', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '7c139634-cac9-4277-b32c-a0eb9e51a91b', 'R6260004', 'Set Menu 470A', 'Set Menu 470A', 'Set Menu 470A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd95d948b-772c-446b-9803-118fa0602fa5', 'R6260005', 'Set Menu 470B', 'Set Menu 470B', 'Set Menu 470B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '507e5855-724d-45a9-9245-50f5c908581f', 'R6260006', 'Set Menu 470C', 'Set Menu 470C', 'Set Menu 470C', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '28b10a60-6036-4d41-b28d-c360dc156034', 'R6260007', 'Set Menu 600A', 'Set Menu 600A', 'Set Menu 600A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '622dd9c5-ed53-43ab-a26f-1d2015307701', 'R6260008', 'Set Menu 600B', 'Set Menu 600B', 'Set Menu 600B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2d0e48e3-517e-4420-b04e-52b1bc3949f7', 'R6260009', 'Set Menu 770A', 'Set Menu 770A', 'Set Menu 770A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c7980edc-bfcc-42a9-a775-f47794aead80', 'R6260010', 'Set Menu 770B', 'Set Menu 770B', 'Set Menu 770B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c95d93c9-a74b-487e-bc47-e7c5b4f8574f', 'R6260011', 'Set Menu 970A', 'Set Menu 970A', 'Set Menu 970A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '237a1903-31a3-45a6-abcd-fd88c2e078db', 'R6260012', 'Set Menu 1250', 'Set Menu 1250', 'Set Menu 1250', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '61bcbccb-7b24-4449-8b1c-cf49f05e7d3e', 'R6260013', 'Set Menu 1550', 'Set Menu 1550', 'Set Menu 1550', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a50bf1e1-2c24-4b2d-8e6d-a7f88f54f77d', 'R6260014', 'Set Menu 1800', 'Set Menu 1800', 'Set Menu 1800', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '95a0851e-c20a-4cae-ac9b-12339b2b07cf', 'R6260015', 'Set Menu 2000', 'Set Menu 2000', 'Set Menu 2000', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '82f2ebb3-8f7a-4667-aa94-49744faed2f2', 'R6001', 'Set Lunch1', 'Set Lunch1', 'Set Lunch1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '3ad9b87e-984d-413f-91db-e5fdad66d021', 'R6040', 'Set Lunch2', 'Set Lunch2', 'Set Lunch2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '823531e0-1af0-4a58-be7a-7ceb5aa5aa02', 'R6041', 'Set Lunch3', 'Set Lunch3', 'Set Lunch3', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'dc51e885-e6d7-424c-96e7-32a50965540f', 'R6042', 'Set Lunch4', 'Set Lunch4', 'Set Lunch4', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0acac20c-afde-466a-9ea3-e60f74352326', 'R6043', 'Set Lunch5', 'Set Lunch5', 'Set Lunch5', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '63997b74-297c-4845-8a6f-56d738ee63ec', 'R6044', 'Set Lunch6', 'Set Lunch6', 'Set Lunch6', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '44ddb419-2bfb-43f6-8ffd-1b9d022f68fa', 'R6045', 'Set Lunch7', 'Set Lunch7', 'Set Lunch7', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'febf6881-aa28-46c1-8a89-bcf7f6c08336', 'R6069', 'Set lunch8', 'Set lunch8', 'Set lunch8', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '7b5f2f5c-2811-481f-ad12-f273accb6e85', 'R6046', 'Set Lunch9', 'Set Lunch9', 'Set Lunch9', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2635339f-3af9-4378-8e58-797c4fcdf0c7', 'R6047', 'Set lunch10', 'Set lunch10', 'Set lunch10', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'bc5ff248-88aa-42bc-ac56-6987bfdaac9e', 'V1002', 'Penfolds Koonunga Hill Chardonnay 37.5cl (W)', 'Penfolds Koonunga Hill Chardonnay 37.5cl (W)', 'Penfolds Koonunga Hill Chardonnay 37.5cl (W)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e6fe90b4-c987-4bcc-b487-48f5a5c04141', 'V1003', 'Penfolds Koonunga Hill Shiraz Cabernet Sauvignon 37.5cl (R)', 'Penfolds Koonunga Hill Shiraz Cabernet Sauvignon 37.5cl (R)', 'Penfolds Koonunga Hill Shiraz Cabernet Sauvignon 37.5cl (R)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd46ea25d-aa8e-40f3-9635-d9a2abee59f6', 'V2003', 'Champagne Brut 37.5cl Grande Reserve Brut, Baron Fuente, France', 'Champagne Brut 37.5cl Grande Reserve Brut, Baron Fuente, France', 'Champagne Brut 37.5cl Grande Reserve Brut, Baron Fuente, France', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '4c007f02-edfd-45e7-af92-de9a873beb9d', 'V2004', 'Champagne Jacques Picard, France', 'Champagne Jacques Picard, France', 'Champagne Jacques Picard, France', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2bcca819-02ca-4f26-ac18-c9d48b4c2009', 'V2005', 'Champagne Brut 75cl Baron Fuente Rose Dolores, France', 'Champagne Brut 75cl Baron Fuente Rose Dolores, France', 'Champagne Brut 75cl Baron Fuente Rose Dolores, France', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0b27095b-0b5e-40b6-acd1-086757de4e2d', 'V3001', 'Late Harvest Sauvignon Blanc 37.5cl, Chile', 'Late Harvest Sauvignon Blanc 37.5cl, Chile', 'Late Harvest Sauvignon Blanc 37.5cl, Chile', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ead134b9-32cb-4c1c-b87d-817342c1fb1b', 'V4001', 'Les Pierres Boissy Syrah Merlot - House wine', 'Les Pierres Boissy Syrah Merlot - House wine', 'Les Pierres Boissy Syrah Merlot - House wine', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '04f878e0-f66b-4f01-85bd-e5fd4f493875', 'V4002', 'CHÂTEAU BAUVALLON (Red)', 'CHÂTEAU BAUVALLON (Red)', 'CHÂTEAU BAUVALLON (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'af16595f-5ace-4ac0-aa9e-69682e4ed346', 'V4003', 'La Croix Bacalan Merlot (R)', 'La Croix Bacalan Merlot (R)', 'La Croix Bacalan Merlot (R)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f0a195e6-fd76-4b35-8660-3f84c3db9dbe', 'V4004', 'Château de Villenouvette Reserve', 'Château de Villenouvette Reserve', 'Château de Villenouvette Reserve', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0372ac51-35df-4777-8f40-71c84700644f', 'V4005', 'Georges Duboeuf Pinot Noir', 'Georges Duboeuf Pinot Noir', 'Georges Duboeuf Pinot Noir', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd562e8c1-4780-40a4-85cc-156212c8cc14', 'V4006', 'Collection Privée Rouge (Merlot, Cabernet Sauvignon) _ Bordeaux', 'Collection Privée Rouge (Merlot, Cabernet Sauvignon) _ Bordeaux', 'Collection Privée Rouge (Merlot, Cabernet Sauvignon) _ Bordeaux', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '51cb00ce-f402-4399-98b2-8a58d7b79872', 'V4026', 'Georges Duboeuf Macon Villages', 'Georges Duboeuf Macon Villages', 'Georges Duboeuf Macon Villages', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '64595927-fcf7-4c8e-b343-049219d5e4e4', 'V4010', 'DOURTHE N.1 ROUGE', 'DOURTHE N.1 ROUGE', 'DOURTHE N.1 ROUGE', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'bf2b251d-4103-4b5e-9303-6490ea98a1ce', 'V4011', 'FAMILLE PERRIN Reserve', 'FAMILLE PERRIN Reserve', 'FAMILLE PERRIN Reserve', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b1fd9f9e-3867-4320-925c-c506537c8cd2', 'V4012', 'BOUCHARD PERE ET FILS Bourgogne Pinot Noir «La Vigné»', 'BOUCHARD PERE ET FILS Bourgogne Pinot Noir «La Vigné»', 'BOUCHARD PERE ET FILS Bourgogne Pinot Noir «La Vigné»', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a6339695-a7b1-42a2-8618-21176b04aac4', 'V4013', 'Clarendelle rouge – Inspired by Haut Brion', 'Clarendelle rouge – Inspired by Haut Brion', 'Clarendelle rouge – Inspired by Haut Brion', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '56d3833d-7121-4313-aafd-b82f49b79cef', 'V4015', 'Madiran Château de Crouseilles', 'Madiran Château de Crouseilles', 'Madiran Château de Crouseilles', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '3c56e939-b505-44bd-ad02-8d94d623c4a8', 'V4016', 'Les Hauts de La Gaffeliere, Saint Emilion', 'Les Hauts de La Gaffeliere, Saint Emilion', 'Les Hauts de La Gaffeliere, Saint Emilion', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9cd343b9-d43b-450a-8df9-6a0d5666ba2d', 'V4018', 'Château De Malengin, Baron E. De Rothschild', 'Château De Malengin, Baron E. De Rothschild', 'Château De Malengin, Baron E. De Rothschild', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6f7e35fd-96bc-4001-a21e-5dfb2d5790f8', 'V4019', 'Croix de Carbonnieux Red (by Château Carbonnieux) (Grand Cru Classé)  (red)', 'Croix de Carbonnieux Red (by Château Carbonnieux) (Grand Cru Classé)  (red)', 'Croix de Carbonnieux Red (by Château Carbonnieux) (Grand Cru Classé)  (red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b2a10d06-0a2b-4cdf-81ce-b6b314cbf5ce', 'V4020', 'Le Haut Medoc de Giscours (by Château Giscours) (Grand Cru Classé)', 'Le Haut Medoc de Giscours (by Château Giscours) (Grand Cru Classé)', 'Le Haut Medoc de Giscours (by Château Giscours) (Grand Cru Classé)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '497a0b98-c2f1-42d0-b2eb-c74dcc204217', 'V4021', '2010 CHÂTEAU VIEUX LARTIGUE « Grand Crus»', '2010 CHÂTEAU VIEUX LARTIGUE « Grand Crus»', '2010 CHÂTEAU VIEUX LARTIGUE « Grand Crus»', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1cd3c174-de62-4a83-af77-3b8505c75397', 'V4022', '2010 CHÂTEAU LA MISSION', '2010 CHÂTEAU LA MISSION', '2010 CHÂTEAU LA MISSION', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c524d7fe-87c3-4cfa-93da-b8a7ee1d382d', 'V4023', 'Le Médoc de Cos (by Château Cos d’Estournel Grand Cru Classé)', 'Le Médoc de Cos (by Château Cos d’Estournel Grand Cru Classé)', 'Le Médoc de Cos (by Château Cos d’Estournel Grand Cru Classé)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '609c2fdd-efb6-4f40-942a-666fbd872bbf', 'V4024', 'Domaine De Saint-Guirons by Château Grand Puy Lacoste (Grand Cru Classé)', 'Domaine De Saint-Guirons by Château Grand Puy Lacoste (Grand Cru Classé)', 'Domaine De Saint-Guirons by Château Grand Puy Lacoste (Grand Cru Classé)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6450b351-5d93-47f6-8198-4fe53157e263', 'V4025', 'CLUB ELITE, Château Tour Massac, Margaux', 'CLUB ELITE, Château Tour Massac, Margaux', 'CLUB ELITE, Château Tour Massac, Margaux', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '73dd9a41-4823-47bf-8c2b-87016eafb9d1', 'V5001', 'Les Pierres Boissy Chardonnay  - House wine', 'Les Pierres Boissy Chardonnay  - House wine', 'Les Pierres Boissy Chardonnay  - House wine', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b812832a-8c21-44f7-95f8-65d6ee399ec6', 'V5002', 'La Croix Bacalan Semillon Sauvignon', 'La Croix Bacalan Semillon Sauvignon', 'La Croix Bacalan Semillon Sauvignon', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1e2d5712-ec02-47a4-965f-c3a032cb4cfa', 'V5003', 'Collection Privée Blanc (Sauvignon Blanc) _ Bordeaux', 'Collection Privée Blanc (Sauvignon Blanc) _ Bordeaux', 'Collection Privée Blanc (Sauvignon Blanc) _ Bordeaux', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a241ce7f-f98a-42dc-88e8-41c86cb4501d', 'V5005', 'Bourgogne Aligote, Louis Jadot', 'Bourgogne Aligote, Louis Jadot', 'Bourgogne Aligote, Louis Jadot', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd01e5497-82cf-468a-8ce4-c139d72174fa', 'V5006', 'DOURTHE N.1 BLANC', 'DOURTHE N.1 BLANC', 'DOURTHE N.1 BLANC', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd414d4ef-3168-4f4f-9f05-5b04f132b15d', 'V5007', 'Clarendelle Blanc – Inspired by Haut Brion', 'Clarendelle Blanc – Inspired by Haut Brion', 'Clarendelle Blanc – Inspired by Haut Brion', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f6f71022-40cc-485a-9684-626245ca6f1e', 'V5009', 'WILLIAM FEVRE Petit Chablis', 'WILLIAM FEVRE Petit Chablis', 'WILLIAM FEVRE Petit Chablis', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e38d2857-efdd-4421-8e88-94f20b7829d0', 'V5010', 'Trimbach, Gewurztraminer', 'Trimbach, Gewurztraminer', 'Trimbach, Gewurztraminer', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9b1266e4-7bbb-4229-8096-50ec27bc3742', 'V5011', 'BOUCHARD PERE ET FILS Pouilly Fuisse', 'BOUCHARD PERE ET FILS Pouilly Fuisse', 'BOUCHARD PERE ET FILS Pouilly Fuisse', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1c3d52f5-7901-4cc3-9a6f-bd3dd889f41e', 'V5012', 'Pouilly Fuisse, Domaine J.A. Ferret', 'Pouilly Fuisse, Domaine J.A. Ferret', 'Pouilly Fuisse, Domaine J.A. Ferret', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c3a0b927-83fe-44fa-a629-b233d290ba85', 'V6001', 'ECHEVERRÍA Valle Dorado Sauvignon Blanc (White)', 'ECHEVERRÍA Valle Dorado Sauvignon Blanc (White)', 'ECHEVERRÍA Valle Dorado Sauvignon Blanc (White)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '7b68763a-5be5-4482-822e-4629f946a612', 'V6002', 'ECHEVERRÍA Valle Dorado Cabernet Sauvignon (red)', 'ECHEVERRÍA Valle Dorado Cabernet Sauvignon (red)', 'ECHEVERRÍA Valle Dorado Cabernet Sauvignon (red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6bfc297f-f40a-442f-936a-6148c6246598', 'V6003', 'Baron Philippe de Rothschild Mapu Reserva Merlot (Red)', 'Baron Philippe de Rothschild Mapu Reserva Merlot (Red)', 'Baron Philippe de Rothschild Mapu Reserva Merlot (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5abe8af5-3274-4946-90a1-0a0c933ada35', 'V6004', 'Baron Philippe de Rothschild Mapu Chardonay (White)', 'Baron Philippe de Rothschild Mapu Chardonay (White)', 'Baron Philippe de Rothschild Mapu Chardonay (White)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1a766907-964d-4028-ae3c-6b1fdbf08b8d', 'V6005', 'Santa Digna, Gewurztraminer (White)', 'Santa Digna, Gewurztraminer (White)', 'Santa Digna, Gewurztraminer (White)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'be6c23f9-1803-4d5f-a9c2-55134abe5769', 'V6006', 'Santa Digna, Cabernet Sauvignon (Red)', 'Santa Digna, Cabernet Sauvignon (Red)', 'Santa Digna, Cabernet Sauvignon (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '900e777a-176e-4b22-b7cd-1fef4cd4423c', 'V6007', 'Casillero Del Diablo Reserva Privada Sauvignon Blanc, Concha Y Toro (White)', 'Casillero Del Diablo Reserva Privada Sauvignon Blanc, Concha Y Toro (White)', 'Casillero Del Diablo Reserva Privada Sauvignon Blanc, Concha Y Toro (White)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '14211975-38e3-4c20-a27f-2f59256d2d5c', 'V6008', 'Casillero Del Diablo Reserva Privada Cabernet Syrah, Concha Y Toro (Red)', 'Casillero Del Diablo Reserva Privada Cabernet Syrah, Concha Y Toro (Red)', 'Casillero Del Diablo Reserva Privada Cabernet Syrah, Concha Y Toro (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1f1db200-7e84-4223-9dd9-c6cebb5691bb', 'V6009', 'Cordillera Reserva Privada Shiraz Blend, Miguel Torres (Red)', 'Cordillera Reserva Privada Shiraz Blend, Miguel Torres (Red)', 'Cordillera Reserva Privada Shiraz Blend, Miguel Torres (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9ff8ceaa-6357-4d3c-a332-26eb785f75b9', 'V6010', 'Cordillera, Carménère, Curico, Miguel Torres (Red)', 'Cordillera, Carménère, Curico, Miguel Torres (Red)', 'Cordillera, Carménère, Curico, Miguel Torres (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd3ae1708-09e3-441a-9cdf-015ec62b59fc', 'V6011', 'Château Los Boldos Grand Cru (Red)', 'Château Los Boldos Grand Cru (Red)', 'Château Los Boldos Grand Cru (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a5dc7f47-3770-4171-98db-b23637139cde', 'V7001', 'Bonacosta, Masi (Corvina, Rondinella and Molinara) (Red)', 'Bonacosta, Masi (Corvina, Rondinella and Molinara) (Red)', 'Bonacosta, Masi (Corvina, Rondinella and Molinara) (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '05cdf4c4-8c72-482f-8b5e-61825473dd23', 'V7002', 'Chianti Placido Primavera Selection (bordolese bottle) (Red)', 'Chianti Placido Primavera Selection (bordolese bottle) (Red)', 'Chianti Placido Primavera Selection (bordolese bottle) (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0aec0371-e1ee-4e38-8e39-b44df0424898', 'V7004', 'Passo', 'Passo', 'Passo', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'dd9d7f8f-9bbe-4cc7-838c-b1d31ae98f03', 'V8001', 'Fleur du Cap Chardonnay (White)', 'Fleur du Cap Chardonnay (White)', 'Fleur du Cap Chardonnay (White)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6832ab0e-a1d6-4768-a96f-4d728bd26b38', 'V8002', 'Fleur Du Cap Cabernet Sauvignon (Red)', 'Fleur Du Cap Cabernet Sauvignon (Red)', 'Fleur Du Cap Cabernet Sauvignon (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '24a73226-992f-4973-872d-7329e36a1961', 'V9001', 'Tribu Chardonnay (White)', 'Tribu Chardonnay (White)', 'Tribu Chardonnay (White)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e1a1964a-f64e-4af3-9444-813af4747f00', 'V9002', 'Tribu Pinot Noir (Red)', 'Tribu Pinot Noir (Red)', 'Tribu Pinot Noir (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f75a826e-9f92-4720-bc80-60e7b29df53f', 'V9101', 'Bin 65 Chardonnay, Lindemans (White)', 'Bin 65 Chardonnay, Lindemans (White)', 'Bin 65 Chardonnay, Lindemans (White)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e52167fd-46f1-4bda-91c6-19722b9c2095', 'V9102', 'Bin 40 Merlot, Lindemans (Red)', 'Bin 40 Merlot, Lindemans (Red)', 'Bin 40 Merlot, Lindemans (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '69415b32-6f6e-4545-b089-5d31ea41c3e5', 'V9401', 'Les Domaines Barsalou Grenache Gris Rose, France', 'Les Domaines Barsalou Grenache Gris Rose, France', 'Les Domaines Barsalou Grenache Gris Rose, France', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1a6d0ae8-a91f-4dd9-8650-81c5db1e75d3', 'V9403', 'Château Aumedes Corbières Rosé, France', 'Château Aumedes Corbières Rosé, France', 'Château Aumedes Corbières Rosé, France', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd60d493f-6810-434f-b66b-72da885d937a', 'V9404', 'Tavel Guigal, Rose, France', 'Tavel Guigal, Rose, France', 'Tavel Guigal, Rose, France', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c8b934ec-81d5-4345-a79d-e07b1f7e96e6', '000', 'Open Menu Food', 'Open Menu Food', 'Open Menu Food', NULL,
      'PIECE', 'PIECE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '03f974a0-4555-4d8c-9f5e-01bfc1cb82db', 'NLC1006', 'Top Side', 'Top Side', 'Top Side', NULL,
      'KG', 'KG', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '8afca1f7-cbba-495b-9265-c9dd21498d44', 'NLC3001', 'Foie gras Frozen', 'Foie gras Frozen', 'Foie gras Frozen', '7f22ca72-c04e-5a95-a1b9-64c4e573cb76',
      'KG', 'KG', 1, 0,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'bf2678bb-166f-4cf0-9a96-6637929d9972', 'NLP6001', 'Nguyên liệu chế biến ( ko nhập)', 'Nguyên liệu chế biến ( ko nhập)', 'Nguyên liệu chế biến ( ko nhập)', NULL,
      'PIECE', 'PIECE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f28fc77f-9c3a-44f1-b43e-ad7e32b358cb', 'NLP6002', 'Nguyên liệu chế biến bếp', 'Nguyên liệu chế biến bếp', 'Nguyên liệu chế biến bếp', NULL,
      'PIECE', 'PIECE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '30da0866-7bab-42db-885d-2d2f57724dd9', 'NLP6003', 'Nguyên liệu chế biến bar', 'Nguyên liệu chế biến bar', 'Nguyên liệu chế biến bar', NULL,
      'PIECE', 'PIECE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'aad76daa-51da-4f22-bd29-f4d7d8c7bbb4', 'R6002', 'Set Dinner1', 'Set Dinner1', 'Set Dinner1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f1123909-ab22-48f7-bce2-9c77d31aa7e8', 'M6013', 'Vital (Sparking Water 0.5L)', 'Vital (Sparking Water 0.5L)', 'Vital (Sparking Water 0.5L)', 'b3b4e57e-464d-562f-80ec-b216c92d5e88',
      'BOTTLE', 'BOTTLE', 1, 450,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '37e67ad1-b8ed-4960-95f4-ed5fc6f3717e', 'R6050', 'Set Dinner2', 'Set Dinner2', 'Set Dinner2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'eac6bf1d-7787-4024-ac10-c6e428a5747c', 'V5013', 'CHÂTEAU BAUVALLON (White)', 'CHÂTEAU BAUVALLON (White)', 'CHÂTEAU BAUVALLON (White)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e2b46c9b-e6e4-4f95-86b9-eb62f50986dd', 'V2007', 'Cuvee Jean-Louis Brut', 'Cuvee Jean-Louis Brut', 'Cuvee Jean-Louis Brut', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c0ada809-ec21-405a-a88b-87ef483cf657', 'V6012', 'PAVO REAL Cabernet Sauvignon (Reserva)', 'PAVO REAL Cabernet Sauvignon (Reserva)', 'PAVO REAL Cabernet Sauvignon (Reserva)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b06eae8a-b6f9-4731-8318-917abdf671fa', 'V6014', 'PAVO REAL Cabernet Sauvignon - Carmenere (GR)', 'PAVO REAL Cabernet Sauvignon - Carmenere (GR)', 'PAVO REAL Cabernet Sauvignon - Carmenere (GR)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9532bd3d-c3bf-4bde-abbe-65dee9649ab8', 'V6015', 'PAVO REAL Sauvignon Blanc (Reserva)', 'PAVO REAL Sauvignon Blanc (Reserva)', 'PAVO REAL Sauvignon Blanc (Reserva)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '45ee9c91-59a1-40b2-b60a-8f186891053e', 'V6016', 'PAVO REAL Sauvignon Blanc (Variietals)', 'PAVO REAL Sauvignon Blanc (Variietals)', 'PAVO REAL Sauvignon Blanc (Variietals)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '404dc8e1-d854-49f5-9068-031afb52cf2a', 'V4027', 'Balmontée Bordeaux - Red', 'Balmontée Bordeaux - Red', 'Balmontée Bordeaux - Red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '275ecaf9-e7b6-44d3-85cc-c78df19e3d2e', 'V4028', 'Balmontée Bordeaux Superior - Red', 'Balmontée Bordeaux Superior - Red', 'Balmontée Bordeaux Superior - Red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '4e4fa862-1dee-4127-ae1d-fbb85fdc0deb', 'V2008', 'Torley - Rosé (Sparking)', 'Torley - Rosé (Sparking)', 'Torley - Rosé (Sparking)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5b2d29ee-75da-4574-b60c-5a07b87e692b', 'V6017', 'PAVO REAL Cabernet Sauvignon (Varietals)', 'PAVO REAL Cabernet Sauvignon (Varietals)', 'PAVO REAL Cabernet Sauvignon (Varietals)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b7134d44-0403-4e56-9336-45d20350853f', 'M9515', 'Skyy 90 vodka', 'Skyy 90 vodka', 'Skyy 90 vodka', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '035755b4-2e07-494f-8832-4742ee074ad6', 'M9516', 'Skyy vodka Thuong', 'Skyy vodka Thuong', 'Skyy vodka Thuong', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '30d67a26-58ba-43ab-9e9a-59b5a8e708fd', 'V4029', 'Chateauneauf du-pape', 'Chateauneauf du-pape', 'Chateauneauf du-pape', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '903dc9d4-44f5-446a-b70b-b6e2cdf09387', 'V5014', 'CHÂTEAU LARY (White)', 'CHÂTEAU LARY (White)', 'CHÂTEAU LARY (White)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '3a8c6258-5606-4785-8e81-37dc8ff1e819', 'R6051', 'Set Dinner3', 'Set Dinner3', 'Set Dinner3', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '932a3bc2-204d-444f-9c71-5e6142bfc5d3', 'R6052', 'Set Dinner4', 'Set Dinner4', 'Set Dinner4', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'cd243861-707a-40f6-8a98-463e6f9c0e8e', 'R6053', 'Set Dinner5', 'Set Dinner5', 'Set Dinner5', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a6c3cf34-19e4-4732-962e-983193dfc305', 'R6054', 'Set Dinner6', 'Set Dinner6', 'Set Dinner6', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e3c34cc7-e86e-476b-8062-fd8c4fb2d81c', 'R6055', 'Set Dinner7', 'Set Dinner7', 'Set Dinner7', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '55a31939-2391-497e-b406-b1785655f07b', 'R6056', 'Set Dinner8', 'Set Dinner8', 'Set Dinner8', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '7bab053d-5d9f-46da-9cd9-9b2c1d959a92', 'M9637', 'Appleton White 40%', 'Appleton White 40%', 'Appleton White 40%', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a8ac22a1-c302-4fa9-9d8e-1f71ae4dbac8', 'V6018', 'Montes Alpha Syrah', 'Montes Alpha Syrah', 'Montes Alpha Syrah', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '897277e9-0d8d-4d69-8b0e-1de1d5ed7e47', 'V6019', 'Montes Alpha-M', 'Montes Alpha-M', 'Montes Alpha-M', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '58bc9de6-1e08-4479-9245-fa5e35c28da1', 'V6020', 'Wine of the Month (bottle)', 'Wine of the Month (bottle)', 'Wine of the Month (bottle)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c702fc44-50e9-4fc3-b288-301acdfde118', 'V6021', 'Luis Felipe Gran Reserva Shiraz', 'Luis Felipe Gran Reserva Shiraz', 'Luis Felipe Gran Reserva Shiraz', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c8cecacb-527e-40e5-b92d-98cd1199891e', 'V6022', 'Luis Felipe Gran Reserva Chardonnay', 'Luis Felipe Gran Reserva Chardonnay', 'Luis Felipe Gran Reserva Chardonnay', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a855b72c-24ce-407b-a0dc-815bd7aa8f83', 'V4030', 'Château de Villenouvette Cuvee Marcel', 'Château de Villenouvette Cuvee Marcel', 'Château de Villenouvette Cuvee Marcel', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0ec41e45-a9b7-4f04-9921-50885e85d305', 'R2115', 'Roasted lamb rack with rosemary 3 chops', 'Roasted lamb rack with rosemary 3 chops', 'Roasted lamb rack with rosemary 3 chops', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '572e05e6-6de0-4216-bb16-d643a2420050', 'R6057', 'Set Dinner9', 'Set Dinner9', 'Set Dinner9', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ce35d834-69b3-40ec-93dd-135110367f70', 'R6058', 'Set dinner10', 'Set dinner10', 'Set dinner10', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'bdc3ea21-6869-4d4d-acc1-31f27abc5aeb', 'R6059', 'Set dinner11', 'Set dinner11', 'Set dinner11', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'bd2426a1-69a1-4811-b4f8-fe9a1df40c2b', 'V6023', 'Rios Chie Red', 'Rios Chie Red', 'Rios Chie Red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '33d99a0b-63f2-4b51-a2ea-1c72ec67e5d5', 'V9405', 'Luis Pinel Cinsault Rose', 'Luis Pinel Cinsault Rose', 'Luis Pinel Cinsault Rose', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'cfef8f0c-3574-4cf1-bbbb-ef84ef6cf2e5', 'R6072', 'Set Dinner12', 'Set Dinner12', 'Set Dinner12', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '34d41325-f220-46ce-a408-7f0709954c7c', 'R6073', 'Set Dinner13', 'Set Dinner13', 'Set Dinner13', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2c3436ba-f630-490c-89a7-6d53c1421abb', 'R6084', 'Set dinner14', 'Set dinner14', 'Set dinner14', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '32304cbd-cbe0-4e77-8165-7751f99105f1', 'R6093', 'Set dinner15', 'Set dinner15', 'Set dinner15', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e4b275a9-a53b-4c72-92ed-d4b0da9f3869', 'M9108', 'Wine of the month glass', 'Wine of the month glass', 'Wine of the month glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a12b8eca-3336-466a-8602-80466d5a05b8', 'R1009', 'Mussels soup', 'Mussels soup', 'Mussels soup', NULL,
      'BOWL', 'BOWL', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5404cc41-f5e7-4e2c-a515-76ade87a35c0', 'V6024', 'La Capitana Cabernet Merlot', 'La Capitana Cabernet Merlot', 'La Capitana Cabernet Merlot', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '341e3322-9a66-40cf-bcb7-5d5dfff5cba9', 'V4031', 'Clos Saint Vincent Saint-Emilion Grand Cru', 'Clos Saint Vincent Saint-Emilion Grand Cru', 'Clos Saint Vincent Saint-Emilion Grand Cru', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'dd191c56-0f03-45c7-8d70-bfb48bb75167', 'V4032', 'Chateau Brane Cantenac 2009 - Margeaux Grand Cru Classe', 'Chateau Brane Cantenac 2009 - Margeaux Grand Cru Classe', 'Chateau Brane Cantenac 2009 - Margeaux Grand Cru Classe', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '67aa4b34-7866-408b-8b1a-fa3fbbde84cf', 'V4033', 'Chateau Dauzac  - Beaudaux, Cabernet Sauvignon-Merlot', 'Chateau Dauzac  - Beaudaux, Cabernet Sauvignon-Merlot', 'Chateau Dauzac  - Beaudaux, Cabernet Sauvignon-Merlot', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'fd2c0f9b-09ed-4057-90bd-ef0e151a3cce', 'V5015', 'Châtteau de MeurSault - Bourgone - Chardonay', 'Châtteau de MeurSault - Bourgone - Chardonay', 'Châtteau de MeurSault - Bourgone - Chardonay', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '71debfd7-4d1c-4e22-995c-7ec041d4fd52', 'V2010', 'Delafinca Carta Blance Sparkling Wine', 'Delafinca Carta Blance Sparkling Wine', 'Delafinca Carta Blance Sparkling Wine', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '21554426-21ac-467f-8c9d-f4b50f6abbff', 'V2011', 'BOTTEGA Fragolino Sparkling', 'BOTTEGA Fragolino Sparkling', 'BOTTEGA Fragolino Sparkling', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a1bd8d39-e9cc-42c5-8ad4-620f9c6cb035', 'V6025', 'Marques De Casa Concha Shiraz, CYT, CHILE', 'Marques De Casa Concha Shiraz, CYT, CHILE', 'Marques De Casa Concha Shiraz, CYT, CHILE', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '69eb3c23-1992-4a3f-9d75-15576c0a67c2', 'R2116', 'Braised lamb shank in Cassoulet bean', 'Braised lamb shank in Cassoulet bean', 'Braised lamb shank in Cassoulet bean', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'fd3365fa-0a7f-42c0-92a3-61465620261e', 'V1004', 'Chile Evolucion Cabernet Sauvignon 37.5cl (red)', 'Chile Evolucion Cabernet Sauvignon 37.5cl (red)', 'Chile Evolucion Cabernet Sauvignon 37.5cl (red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c33a03f0-593e-4d8d-8fe6-09daf0c22d74', 'V1005', 'Chile Evolucion Sauvignon Blanc 37.5cl (White)', 'Chile Evolucion Sauvignon Blanc 37.5cl (White)', 'Chile Evolucion Sauvignon Blanc 37.5cl (White)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2193fc80-f882-483e-a347-098a6e127c63', 'R1013', 'Mixed garden salad', 'Mixed garden salad', 'Mixed garden salad', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '333ce1fe-c182-4c74-a146-44be1171619d', 'R1014', 'Cold cut platter 2 Pers', 'Cold cut platter 2 Pers', 'Cold cut platter 2 Pers', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5808f6e7-8489-41d8-9519-09d6c9afadf3', 'R1015', 'Cold cut platter 3 Pers', 'Cold cut platter 3 Pers', 'Cold cut platter 3 Pers', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b9786955-a682-4579-9e1f-b86662386842', 'R1016', 'Cold cut platter 4 Pers', 'Cold cut platter 4 Pers', 'Cold cut platter 4 Pers', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ad3cf4be-0fd1-4087-9830-afd079c369d6', 'R1029', 'Assorted Ham, Salami with Cheese and Pate', 'Assorted Ham, Salami with Cheese and Pate', 'Assorted Ham, Salami with Cheese and Pate', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6d4632a9-83b4-4ffb-bd65-50dbe7b12e86', 'R1017', 'Cucumber and Tomaoes 2 Pers', 'Cucumber and Tomaoes 2 Pers', 'Cucumber and Tomaoes 2 Pers', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '169af989-0cad-4249-938f-60358be2e76a', 'R3106', 'Pan seared Scallops wild mushrooms Royale', 'Pan seared Scallops wild mushrooms Royale', 'Pan seared Scallops wild mushrooms Royale', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'abed9b21-491d-41b3-9c35-ed58b9aee2c6', 'R2117', 'Roast duck fillet orange sauce and seasonal creation', 'Roast duck fillet orange sauce and seasonal creation', 'Roast duck fillet orange sauce and seasonal creation', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f7669ecc-16e6-4373-a26c-5ab4dc000343', 'R2118', 'Fired duck confit thyme sauce', 'Fired duck confit thyme sauce', 'Fired duck confit thyme sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f84f7e0e-7538-405e-9f8c-0c1a12598b8d', 'R2119', 'Roasted chicken fillet tarragon juice', 'Roasted chicken fillet tarragon juice', 'Roasted chicken fillet tarragon juice', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '65eb1b9d-9968-441b-a6f7-048855ba02d1', 'M9638', 'WAKABA  - Sake 15 - bottle 350 ml', 'WAKABA  - Sake 15 - bottle 350 ml', 'WAKABA  - Sake 15 - bottle 350 ml', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c4f79d8d-b25d-42e3-bbe8-b9d9ceb70cd0', 'M9640', 'KOME HAJIME  - Shochu 25% - bottle 500 ml', 'KOME HAJIME  - Shochu 25% - bottle 500 ml', 'KOME HAJIME  - Shochu 25% - bottle 500 ml', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '30ef639c-8591-4b6a-8c5b-90f88634d52a', 'M9641', 'MUGI HAJIME - Shochu 25% - bottle 500 ml', 'MUGI HAJIME - Shochu 25% - bottle 500 ml', 'MUGI HAJIME - Shochu 25% - bottle 500 ml', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '396cb41e-e8a7-4d3d-a710-aec1686826bc', 'M9639', 'ETSUNO HAJIME - Sake 15% - bottle 300 ml', 'ETSUNO HAJIME - Sake 15% - bottle 300 ml', 'ETSUNO HAJIME - Sake 15% - bottle 300 ml', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '511fba33-2fc8-437c-9b34-787d578ab1b9', 'B5011', 'Truc Bach Beer', 'Truc Bach Beer', 'Truc Bach Beer', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '8ab4d5f6-e7bd-47ca-bc60-41856f1568c1', 'NVLC1005', 'Top Side', 'Top Side', 'Top Side', NULL,
      'KG', 'KG', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5944b148-0290-4c47-b68a-0c924dcb54d0', 'NVLC1013', 'Top Sirloin', 'Top Sirloin', 'Top Sirloin', '7f22ca72-c04e-5a95-a1b9-64c4e573cb76',
      'KG', 'KG', 1, 0,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6e4b17fb-bc72-457d-b145-9c7800e60c4b', 'NVLC1014', 'Hanging tender', 'Hanging tender', 'Hanging tender', NULL,
      'KG', 'KG', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'fbe21778-a80f-4b2b-a29a-3f2064cb5cda', 'NVLC1015', 'Local beef', 'Local beef', 'Local beef', '7f22ca72-c04e-5a95-a1b9-64c4e573cb76',
      'KG', 'KG', 1, 0,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e7df034c-95dc-4515-b5e4-c5330060b665', 'NVLC1017', 'Chuck tender', 'Chuck tender', 'Chuck tender', NULL,
      'KG', 'KG', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e7cd5949-4c65-4e73-887b-9854811b11e0', 'NVLC5002', 'Salmon whole', 'Salmon whole', 'Salmon whole', '30c427bf-d412-516b-b5dc-7022fe29971a',
      'KG', 'KG', 1, 0,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a804bac9-bdcb-4fed-87f5-1235388fcff3', 'NVLC5006', 'Sea bass whole', 'Sea bass whole', 'Sea bass whole', '30c427bf-d412-516b-b5dc-7022fe29971a',
      'KG', 'KG', 1, 0,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '573a5712-c955-4bdd-872d-3c5f8c412e06', 'NVLC5016', 'Ca Tra whole', 'Ca Tra whole', 'Ca Tra whole', '30c427bf-d412-516b-b5dc-7022fe29971a',
      'KG', 'KG', 1, 0,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '41b8de62-12c2-4b4f-880a-cc22cbae1c9c', 'NVLC5017', 'Basa fillet', 'Basa fillet', 'Basa fillet', NULL,
      'KG', 'KG', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6c5ee8b0-dacd-494c-a2fb-e32f9dd00f86', 'NVLC5021', 'Lang Fish', 'Lang Fish', 'Lang Fish', '30c427bf-d412-516b-b5dc-7022fe29971a',
      'KG', 'KG', 1, 0,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '37bbe972-ea83-4d29-9bcd-aa33d738c7c3', 'NVLC5025', 'Gouper', 'Gouper', 'Gouper', NULL,
      'KG', 'KG', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'fa96b075-9851-499d-b7c9-6b3a3a570a03', 'NVLC6002', 'Scallope', 'Scallope', 'Scallope', '30c427bf-d412-516b-b5dc-7022fe29971a',
      'KG', 'KG', 1, 0,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'fb27920c-e175-4b7c-a45f-eefc6a67e33e', 'NVLC6003', 'Fresh Musells', 'Fresh Musells', 'Fresh Musells', NULL,
      'KG', 'KG', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f83a222e-4d66-4a85-b6cf-68fb7796fafb', 'NVLC6004', 'Frog leg', 'Frog leg', 'Frog leg', '7f22ca72-c04e-5a95-a1b9-64c4e573cb76',
      'KG', 'KG', 1, 0,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '27393696-97c7-4608-bf1a-a2015af6d4d4', 'NVLC6010', 'Rabit', 'Rabit', 'Rabit', NULL,
      'KG', 'KG', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '7f6a19c2-1b53-45c7-a514-4ffadea54acc', 'NVLC6015', 'Turkey Whole', 'Turkey Whole', 'Turkey Whole', '7f22ca72-c04e-5a95-a1b9-64c4e573cb76',
      'KG', 'KG', 1, 0,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '28e5641a-0471-4fff-a68f-0df8dc15c526', 'B5014', 'Sagota— Alcohol free beer 33cl', 'Sagota— Alcohol free beer 33cl', 'Sagota— Alcohol free beer 33cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'CAN', 'CAN', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd783a1d4-d1cb-460f-b0d5-f86c03bc3f95', 'V1006', 'Just VDP OC Merlot 37.5cl', 'Just VDP OC Merlot 37.5cl', 'Just VDP OC Merlot 37.5cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9a69bb60-216d-4ed6-bd51-019b50ac3304', 'M5007', 'Mirabelle', 'Mirabelle', 'Mirabelle', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c692ea16-3851-4a1a-b191-92e6ff672306', 'V4007', 'Georges Duboeuf Beaujolais Villages', 'Georges Duboeuf Beaujolais Villages', 'Georges Duboeuf Beaujolais Villages', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1a04b32e-cdc2-4663-aec4-cbb574a230d8', 'NVLC7002', 'Veal Sweet Breast', 'Veal Sweet Breast', 'Veal Sweet Breast', '7f22ca72-c04e-5a95-a1b9-64c4e573cb76',
      'KG', 'KG', 1, 0,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5e561cef-ebdb-47f2-b315-442608f4a6f2', 'M3007', 'Ballentines Fineses glass', 'Ballentines Fineses glass', 'Ballentines Fineses glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0eebf93d-7e1c-44da-8141-48a0030e3c2b', 'V5016', 'Sancerre Blance le Barones', 'Sancerre Blance le Barones', 'Sancerre Blance le Barones', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6aaf0e26-0480-43a7-9330-4aa7431b082a', 'V9003', 'Tribu Malbec (Red)', 'Tribu Malbec (Red)', 'Tribu Malbec (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0faf95af-a170-4675-801d-8d72a01c0761', 'V4034', 'Roc Saint Andre (Red)', 'Roc Saint Andre (Red)', 'Roc Saint Andre (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '664d4091-9aaa-4f04-9d24-32230ac1246e', 'V4035', 'Georges Duboeuf Beaujolais Villages Nouveau (Fresh Wine)', 'Georges Duboeuf Beaujolais Villages Nouveau (Fresh Wine)', 'Georges Duboeuf Beaujolais Villages Nouveau (Fresh Wine)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '90d93d81-c0d8-464c-a2e9-be248b25637e', 'M9110', 'Beaujolais Nouveau wine glass', 'Beaujolais Nouveau wine glass', 'Beaujolais Nouveau wine glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '14810daa-f5a8-425e-8ac1-76102c0019ef', 'V7003', 'Masianco Supervenetian, Masi (Pinot Grigio, Verduzzo) (White)', 'Masianco Supervenetian, Masi (Pinot Grigio, Verduzzo) (White)', 'Masianco Supervenetian, Masi (Pinot Grigio, Verduzzo) (White)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c7cca66d-71da-4dad-9a2b-915fef78e59c', 'V9503', 'Chateau Dalat Reserve Merlot 75cl', 'Chateau Dalat Reserve Merlot 75cl', 'Chateau Dalat Reserve Merlot 75cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '188da102-01a4-478d-a086-12ba55e81233', 'V9505', 'Chateau Dalat Special Chardonay 75cl', 'Chateau Dalat Special Chardonay 75cl', 'Chateau Dalat Special Chardonay 75cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '698f3ec4-2fc1-4391-8edc-2267515c900b', 'M9111', 'Jacques Picard glass', 'Jacques Picard glass', 'Jacques Picard glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2dcbd2d1-cafe-44a5-a19c-2bd3c31b667f', 'R2120', 'Boneless chicken thighs stuffed with vegetables', 'Boneless chicken thighs stuffed with vegetables', 'Boneless chicken thighs stuffed with vegetables', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '8b567368-8952-404c-80d9-02640fa2c47b', 'R5105', 'Chocolate sphere salted butter caramel sauce', 'Chocolate sphere salted butter caramel sauce', 'Chocolate sphere salted butter caramel sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '7b933639-694c-4cab-9d94-bf4c404c5dca', 'R1018', 'Cucumber and Tomaoes 3 Pers', 'Cucumber and Tomaoes 3 Pers', 'Cucumber and Tomaoes 3 Pers', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '06bd2c4a-338f-4720-9907-f84c13e12666', 'R1019', 'Cucumber and Tomaoes 4 Pers', 'Cucumber and Tomaoes 4 Pers', 'Cucumber and Tomaoes 4 Pers', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6e63a85e-a7dc-4c36-b28e-86511d006c02', 'R1020', 'French fries', 'French fries', 'French fries', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '492ad96c-8ee8-4024-8852-7a5b3701ac9a', 'R2121', 'Roasted pork fillet mignon cheese sauce', 'Roasted pork fillet mignon cheese sauce', 'Roasted pork fillet mignon cheese sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'baa29d4b-6512-4e19-81ad-bda3f2a1b181', 'R5106', 'Mango ravioli with coconut pudding', 'Mango ravioli with coconut pudding', 'Mango ravioli with coconut pudding', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '3c239219-6809-4ad9-9f4b-0a37668bcd94', 'R5006', 'Cheese platter with walnut bread', 'Cheese platter with walnut bread', 'Cheese platter with walnut bread', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ef74a9ce-3ac9-45c7-99fb-4f7d4872a2f9', 'M6012', 'Aquafina 0.5L', 'Aquafina 0.5L', 'Aquafina 0.5L', 'b3b4e57e-464d-562f-80ec-b216c92d5e88',
      'BOTTLE', 'BOTTLE', 1, 450,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '8b93acb6-32e3-4f53-a5c8-632c9349d78f', 'M3008', 'Creme de cassic glass', 'Creme de cassic glass', 'Creme de cassic glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0fdadd3f-a8ea-48dc-9f75-fbea3d6681c3', 'V6028', '1887 Cabernet Sauvignon', '1887 Cabernet Sauvignon', '1887 Cabernet Sauvignon', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '4633ceb2-c36f-49dc-8c78-6fdc9f88ca6c', 'V6029', '1887 Sauvignon Blanc', '1887 Sauvignon Blanc', '1887 Sauvignon Blanc', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '054fbc0e-7d67-4950-b553-7b94b5e5bcbd', 'R5107', 'Seasonal fresh fruit platter', 'Seasonal fresh fruit platter', 'Seasonal fresh fruit platter', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '67f54d75-3d14-47fb-a633-b46bf9e49774', 'V9506', 'Chateau Dalat Special Merlot 75cl', 'Chateau Dalat Special Merlot 75cl', 'Chateau Dalat Special Merlot 75cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'cd2b1f3a-dfc7-4166-adbf-d6b2e17fc3f7', 'V9507', 'Chateau Dalat Tradition Chardonay 75cl', 'Chateau Dalat Tradition Chardonay 75cl', 'Chateau Dalat Tradition Chardonay 75cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1ac6171a-fe86-4622-921c-17732c91884f', 'R6094', 'Deluxe set menu1', 'Deluxe set menu1', 'Deluxe set menu1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c4234481-a219-4d43-8bf2-b2daf9c0db2e', 'R6095', 'Deluxe set menu2', 'Deluxe set menu2', 'Deluxe set menu2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ffea6d68-abcc-4afb-8fcd-60dc12facb61', 'R6096', 'Deluxe set menu3', 'Deluxe set menu3', 'Deluxe set menu3', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '3503b3eb-13c1-4618-a413-226b8437dfbb', 'M9112', 'Rose wine glass - CHILE', 'Rose wine glass - CHILE', 'Rose wine glass - CHILE', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'cd7cadd5-44db-40b1-ac50-e498b59aa244', 'R6097', 'Deluxe set menu4', 'Deluxe set menu4', 'Deluxe set menu4', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'bffa8ac3-b426-439d-a14c-8ff61043d515', 'R6098', 'Deluxe set menu5', 'Deluxe set menu5', 'Deluxe set menu5', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ab9b9819-db5f-49f2-a131-4c1e841abefe', 'R6099', 'Deluxe set menu6', 'Deluxe set menu6', 'Deluxe set menu6', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '11b24d30-07d3-4ec2-a0a4-f82583169a67', 'R6100', 'Deluxe set menu7', 'Deluxe set menu7', 'Deluxe set menu7', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '86ca2445-abf1-4318-85ea-92a1d76a3fbd', 'R6101', 'Deluxe set menu8', 'Deluxe set menu8', 'Deluxe set menu8', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'fee71ef8-e2e0-44fd-83e4-7ea416df474d', 'R6102', 'Deluxe set menu9', 'Deluxe set menu9', 'Deluxe set menu9', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '09d2f8a4-cc04-45f3-a241-f83c9e196b45', 'M3009', 'Vodka Hanoi glass', 'Vodka Hanoi glass', 'Vodka Hanoi glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '4aa1b738-c6d5-4e55-83f1-4cea6d2c3112', 'R6103', 'Deluxe set menu10', 'Deluxe set menu10', 'Deluxe set menu10', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a9b833f4-c8d6-4224-a4d9-877d73497d31', 'R6104', 'Deluxe set menu11', 'Deluxe set menu11', 'Deluxe set menu11', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '927be72b-3d5b-45da-a12b-1d2d22208386', 'R6105', 'Deluxe set menu12', 'Deluxe set menu12', 'Deluxe set menu12', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b29415c6-165f-4009-bf1d-a97588beaa11', 'R6106', 'Deluxe set menu13', 'Deluxe set menu13', 'Deluxe set menu13', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '49137b92-3b9f-45eb-b412-ec97dd9b51db', 'R6107', 'Deluxe set menu14', 'Deluxe set menu14', 'Deluxe set menu14', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '4c9196f6-1452-4f3b-8616-4a8ff8f74b5f', 'R6108', 'Deluxe set menu15', 'Deluxe set menu15', 'Deluxe set menu15', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e9b2c686-818a-4276-893f-ce482565f628', 'R6109', 'Deluxe set menu16', 'Deluxe set menu16', 'Deluxe set menu16', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '43ce0b02-8c87-4400-b48e-24c00a03ebda', 'R6110', 'Deluxe set menu17', 'Deluxe set menu17', 'Deluxe set menu17', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '46be4de2-3f2d-4868-8a93-ea88f50764b4', 'R6111', 'Deluxe set menu18', 'Deluxe set menu18', 'Deluxe set menu18', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a97e275d-7278-4e51-a2d1-d05d52c8db47', 'R6112', 'Deluxe set menu19', 'Deluxe set menu19', 'Deluxe set menu19', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '3d9e3cf4-2dc1-41af-9dbb-0c6719dd3a61', 'R6113', 'Deluxe set menu20', 'Deluxe set menu20', 'Deluxe set menu20', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '29055f81-646f-47df-bb91-8ee95487599b', 'R6114', 'Deluxe set menu21', 'Deluxe set menu21', 'Deluxe set menu21', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '92263ef7-cbe1-49ca-9a99-13be76fa487f', 'R6115', 'Deluxe set menu22', 'Deluxe set menu22', 'Deluxe set menu22', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c000df4a-868d-49dd-b57d-aa8ed0ac668b', 'R6116', 'Deluxe set menu23', 'Deluxe set menu23', 'Deluxe set menu23', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '03c411a6-7f11-4555-b511-ab9b67bd2026', 'R6117', 'Deluxe set menu24', 'Deluxe set menu24', 'Deluxe set menu24', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a5cd757f-e4a2-4f3b-a9fa-b1ef1c447bbe', 'R6118', 'Deluxe set menu25', 'Deluxe set menu25', 'Deluxe set menu25', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f5b50797-358f-4544-9bcc-9468e85f5496', 'R6119', 'Deluxe set menu26', 'Deluxe set menu26', 'Deluxe set menu26', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'af42afd8-426b-49f8-874c-8414251c7992', 'R6120', 'Deluxe set menu27', 'Deluxe set menu27', 'Deluxe set menu27', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd18a2e6b-cf29-49a3-b0dd-5229b5969410', 'R6121', 'Deluxe set menu28', 'Deluxe set menu28', 'Deluxe set menu28', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '91ca4fc2-ebbc-498a-a956-3069d65770c9', 'R6128', 'Deluxe set menu29', 'Deluxe set menu29', 'Deluxe set menu29', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b04b9725-5ae5-4911-b5ad-34ca6d2b484b', 'R6129', 'Deluxe set menu30', 'Deluxe set menu30', 'Deluxe set menu30', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0c9887e1-03f6-4ad8-846b-d70578758419', 'V1007', 'Vistana Cabernet Sauvignon Merlot 3.75cl', 'Vistana Cabernet Sauvignon Merlot 3.75cl', 'Vistana Cabernet Sauvignon Merlot 3.75cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '72f2bb4e-c3e3-4561-83e1-38ea70852d66', 'R6130', 'Deluxe set menu31', 'Deluxe set menu31', 'Deluxe set menu31', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b6e2ed07-0412-4028-9b4f-de5385907b27', 'M3010', 'Lua moi glass', 'Lua moi glass', 'Lua moi glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '8ac8e6b9-1deb-44fc-8360-e6da38f5a30c', 'R6200', 'US Steak Combo', 'US Steak Combo', 'US Steak Combo', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e4373b80-bf70-47ed-9f2a-e82ef8291261', 'R6201', 'Pork Cuttles Combo', 'Pork Cuttles Combo', 'Pork Cuttles Combo', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '65ce4104-691a-4de7-a4cc-38ac76172cda', 'V2012', 'Montparnasse Brut Vin Mousseux, France', 'Montparnasse Brut Vin Mousseux, France', 'Montparnasse Brut Vin Mousseux, France', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c9136513-484c-4f44-a59a-3fdbc23ad6ca', 'R6202', 'Dong Tao Chicken Feet Combo', 'Dong Tao Chicken Feet Combo', 'Dong Tao Chicken Feet Combo', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6a4d77af-f096-410f-a5b6-7b95a1ac272b', 'R6203', 'Duck Breast Combo', 'Duck Breast Combo', 'Duck Breast Combo', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e7e8b194-77cf-4e3f-9dfc-fb96cfdba92a', 'R6204', 'Salmon Combo', 'Salmon Combo', 'Salmon Combo', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9f5bf658-60d0-4efd-a378-b61ed9a227e8', 'R6205', 'Lamb Stew Combo', 'Lamb Stew Combo', 'Lamb Stew Combo', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd1ede8b8-5241-4f93-88c5-3b2be9349663', 'R6206', 'Chicken Breast Combo', 'Chicken Breast Combo', 'Chicken Breast Combo', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'abe7e71c-066b-420e-9cd5-f2181bafb9e4', 'R6207', 'Pork Tenderloin Combo', 'Pork Tenderloin Combo', 'Pork Tenderloin Combo', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '413d9ebe-21cf-4a61-b397-c378ab5c28dd', 'V4036', 'Légende Bordeaux Rouge 75cl (Red)', 'Légende Bordeaux Rouge 75cl (Red)', 'Légende Bordeaux Rouge 75cl (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2a4811fb-68e5-4c17-a379-3f1f78abf2ae', 'V4037', 'Légende Saint-Émilion 75cl (Red)', 'Légende Saint-Émilion 75cl (Red)', 'Légende Saint-Émilion 75cl (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '3e1bc280-798d-4d36-a18f-2143f7c68f83', 'V4040', 'Chateau Belle Vue, Haut-Médoc- Bordeaux 75cl (Red)', 'Chateau Belle Vue, Haut-Médoc- Bordeaux 75cl (Red)', 'Chateau Belle Vue, Haut-Médoc- Bordeaux 75cl (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '257b662c-37b5-4c11-b09b-6146e3c06bcd', 'V5019', 'Légende Bordeaux Blanc 750ml (White)', 'Légende Bordeaux Blanc 750ml (White)', 'Légende Bordeaux Blanc 750ml (White)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b1561072-dd42-4ba8-aab7-65d6995192c5', 'V6032', 'Sunrise Cabernet Sauvignon, Concha Y Toro 75cl (Red)', 'Sunrise Cabernet Sauvignon, Concha Y Toro 75cl (Red)', 'Sunrise Cabernet Sauvignon, Concha Y Toro 75cl (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '8c28542e-2d18-4f1f-842d-4e5d349b877d', 'V6033', 'Sunrise Chardonay, Concha Y Toro (White)', 'Sunrise Chardonay, Concha Y Toro (White)', 'Sunrise Chardonay, Concha Y Toro (White)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '206ad06d-e761-4fc7-8059-ac83f54c8fd0', 'V3008', 'Montes Late Harvest Gewyztraminer 37.5cl', 'Montes Late Harvest Gewyztraminer 37.5cl', 'Montes Late Harvest Gewyztraminer 37.5cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a82d2a65-861e-4893-bc32-9a8be0ee127e', 'V6030', 'Santa Rita Reserva Cabernet Sauvignon 75cl (Red)', 'Santa Rita Reserva Cabernet Sauvignon 75cl (Red)', 'Santa Rita Reserva Cabernet Sauvignon 75cl (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '752c30d8-46b9-4e73-a59e-3954b81c3103', 'V6031', 'Santa Rita Reserva sauvignon Blanc 75cl (White)', 'Santa Rita Reserva sauvignon Blanc 75cl (White)', 'Santa Rita Reserva sauvignon Blanc 75cl (White)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ea66c4e7-265b-437e-9ee4-45ab3c9c7618', 'V5018', 'Muscadet Sevre et Maine sur Lie- D&F 75cl (White)', 'Muscadet Sevre et Maine sur Lie- D&F 75cl (White)', 'Muscadet Sevre et Maine sur Lie- D&F 75cl (White)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '03a7aa8a-4e95-4326-8cfe-75c5f1d6a2db', 'V5020', 'Chateau La Rose Bellevue Cuvee Tradition 75cl (White)', 'Chateau La Rose Bellevue Cuvee Tradition 75cl (White)', 'Chateau La Rose Bellevue Cuvee Tradition 75cl (White)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '4f4e612b-ab5b-4fc6-a8df-7127e83dcf49', 'V7005', 'Carpineto Chianti Classico Riserva DOCG, Sangiovese- Canaiolo (Red)', 'Carpineto Chianti Classico Riserva DOCG, Sangiovese- Canaiolo (Red)', 'Carpineto Chianti Classico Riserva DOCG, Sangiovese- Canaiolo (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '7b968baa-d2a3-40e4-ad51-f6bbe5225087', 'V7006', 'Carpineto Farnito, Chardonay- Toscana IGT (White)', 'Carpineto Farnito, Chardonay- Toscana IGT (White)', 'Carpineto Farnito, Chardonay- Toscana IGT (White)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '3ef5430d-f346-4ca6-b988-7164194ba779', 'V4038', 'Chateau Puy Razac Grand Cru Merlot- Cabernet 75cl', 'Chateau Puy Razac Grand Cru Merlot- Cabernet 75cl', 'Chateau Puy Razac Grand Cru Merlot- Cabernet 75cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '986a845f-796b-45dd-9d1d-3763dfa4d5a2', 'V4039', 'Les Hauts De Lynch Moussac - Haut Medoc 75cl (Red)', 'Les Hauts De Lynch Moussac - Haut Medoc 75cl (Red)', 'Les Hauts De Lynch Moussac - Haut Medoc 75cl (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '817a4007-ef6a-4238-8ec4-44cd239d9b00', 'M7011', 'Apple juice box', 'Apple juice box', 'Apple juice box', 'b3b4e57e-464d-562f-80ec-b216c92d5e88',
      'GLASS', 'GLASS', 1, 450,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ff4ab1d2-ce30-4360-963f-2ca5c365900d', 'B5009', 'Bitburger - Germany - bottle 33cl', 'Bitburger - Germany - bottle 33cl', 'Bitburger - Germany - bottle 33cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'aa7dd09a-f743-4665-8e5f-10181cbc1157', 'R6087', 'Sandwich Set Menu', 'Sandwich Set Menu', 'Sandwich Set Menu', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2e424303-3116-4fb3-96db-d841a41ff5c1', 'V4041', 'Chateau  Rocher Calon, Montagne Saint Emilion - Red', 'Chateau  Rocher Calon, Montagne Saint Emilion - Red', 'Chateau  Rocher Calon, Montagne Saint Emilion - Red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '74da1a00-9ac7-4fe7-bcb3-9aeeed3015fe', 'V4042', 'Chateau Chantemerle Cru Bourgeois - Red', 'Chateau Chantemerle Cru Bourgeois - Red', 'Chateau Chantemerle Cru Bourgeois - Red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a913aafb-cb15-4805-aea2-64ae8a2b0b38', 'V6036', 'Novas Gran Reserva Cabernet Sauvignon Organic Wine', 'Novas Gran Reserva Cabernet Sauvignon Organic Wine', 'Novas Gran Reserva Cabernet Sauvignon Organic Wine', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a1ea9386-b235-4c1c-af90-e526d807096b', 'V6037', 'Novas Gran Reserva Sauvignon Blanc Organic Wine', 'Novas Gran Reserva Sauvignon Blanc Organic Wine', 'Novas Gran Reserva Sauvignon Blanc Organic Wine', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd3ed8988-e507-4206-aad6-35d80f8bdda6', 'R2001', 'Roasted chicken breast', 'Roasted chicken breast', 'Roasted chicken breast', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5e36d7f4-5c0f-474e-8711-09cb1a3501da', 'R6033', 'Set Menu 10 A', 'Set Menu 10 A', 'Set Menu 10 A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '81300e3c-f771-4ad6-ac02-a3eeb5522f73', 'M6011', 'Vitel (Sparking Water 0.5L)', 'Vitel (Sparking Water 0.5L)', 'Vitel (Sparking Water 0.5L)', 'b3b4e57e-464d-562f-80ec-b216c92d5e88',
      'BOTTLE', 'BOTTLE', 1, 450,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '94750348-b805-4eb6-96f3-33e739ca683e', 'M7013', 'Whisky sour', 'Whisky sour', 'Whisky sour', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0d14fe64-77c7-48f4-9abf-8adcfef9549c', 'M7014', 'Long Island Iced Tea', 'Long Island Iced Tea', 'Long Island Iced Tea', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5fae3099-ef04-4520-84e6-9c227054626e', 'M7016', 'Tequila Sunrise', 'Tequila Sunrise', 'Tequila Sunrise', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f9b04221-cc1b-4b27-a813-dc538013debe', 'M7017', 'Daiquiri', 'Daiquiri', 'Daiquiri', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '00838ddc-d4af-4690-b491-c4fdca976687', 'R1021', 'Olive Platter', 'Olive Platter', 'Olive Platter', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '47bf251b-8467-4d7b-be1a-4bcea528935d', 'R1022', 'Mixed Olive Platter', 'Mixed Olive Platter', 'Mixed Olive Platter', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '182ff248-137e-4ad6-bbcb-8ca2d556f52b', 'R1023', 'Soup bouillabaisse rouille garlic baguette', 'Soup bouillabaisse rouille garlic baguette', 'Soup bouillabaisse rouille garlic baguette', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'db49d7cd-ecf5-450c-9658-4c7265d30b79', 'R1026', 'Frogs legs parsley cream and garlic puree', 'Frogs legs parsley cream and garlic puree', 'Frogs legs parsley cream and garlic puree', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2622008c-f8d9-40d1-95ef-1759e76dce49', 'R1027', 'Pan fried king prawn lobster sauce coriander', 'Pan fried king prawn lobster sauce coriander', 'Pan fried king prawn lobster sauce coriander', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '365f383f-5f69-42f5-89e5-113f523d8ad5', 'R4008', 'Risotto with mushrooms and onions (vegetarian)', 'Risotto with mushrooms and onions (vegetarian)', 'Risotto with mushrooms and onions (vegetarian)', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b8554a28-96c2-4f94-b29b-2ec95730f530', 'R5011', 'Ice cream (1 scoop)', 'Ice cream (1 scoop)', 'Ice cream (1 scoop)', NULL,
      'CUP', 'CUP', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0a2887e3-ec9c-4be7-8465-9e5154817ed3', 'R5012', 'Ice cream (2 scoops)', 'Ice cream (2 scoops)', 'Ice cream (2 scoops)', NULL,
      'CUP', 'CUP', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c3a9df2b-1785-4889-abec-95488c1a65b4', 'M9814', 'Prune', 'Prune', 'Prune', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '97628e74-447c-4046-8af9-91faa26e3aa4', 'M9815', 'Ch Breuil Fine Calvados 70cl', 'Ch Breuil Fine Calvados 70cl', 'Ch Breuil Fine Calvados 70cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0d834ada-e3e6-49b6-805a-879142e9708e', 'M7019', 'Tom Collins', 'Tom Collins', 'Tom Collins', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5358776a-bed3-4358-bd26-eba3cec22318', 'R1028', 'Pan fried duck foie gras with red fruits sauce 80gm', 'Pan fried duck foie gras with red fruits sauce 80gm', 'Pan fried duck foie gras with red fruits sauce 80gm', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '008921b9-503c-4816-9978-a23e1de1ed10', 'R1001', 'Confit gizzards and duck breast salad', 'Confit gizzards and duck breast salad', 'Confit gizzards and duck breast salad', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd103eae4-a05c-48c2-87fa-2920a287be9a', 'R1002', 'Beef Carpaccio with basil', 'Beef Carpaccio with basil', 'Beef Carpaccio with basil', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5335e6ad-331f-48ed-b7c7-3201caff3dc3', 'R1003', 'Warm goat cheese salad and Parma ham', 'Warm goat cheese salad and Parma ham', 'Warm goat cheese salad and Parma ham', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '35ad4804-1e46-4993-b0a7-cc5a20134c30', 'R1004', 'Blinis with smoked salmon', 'Blinis with smoked salmon', 'Blinis with smoked salmon', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6e656680-bb58-4add-9a1b-5c68b42d33e8', 'R1005', 'Goose liver terrine', 'Goose liver terrine', 'Goose liver terrine', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '582b1b5f-cd8b-4892-a5b3-988a3b245775', 'R1006', 'Pan fried foie gras escalope', 'Pan fried foie gras escalope', 'Pan fried foie gras escalope', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e97e6f03-c0a1-4085-a9bb-2a0568812b56', 'R1010', 'Egg blown wild mushroom cream', 'Egg blown wild mushroom cream', 'Egg blown wild mushroom cream', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '87995fa1-3edb-477a-b14f-9e948b8b00b9', 'R1011', 'Burgundy snails (six pcs)', 'Burgundy snails (six pcs)', 'Burgundy snails (six pcs)', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '409d9059-860c-4820-aca4-ef2392b38c83', 'R2002', 'Roasted duck breast with green olives sauce', 'Roasted duck breast with green olives sauce', 'Roasted duck breast with green olives sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a7b3167a-7721-40de-9cce-c78d8318109d', 'R2003', 'Fried duck-leg, calamansi sauce', 'Fried duck-leg, calamansi sauce', 'Fried duck-leg, calamansi sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '12f35c66-3296-41bc-b038-0392f0d0df6a', 'R2004', 'Grilled beef rib eye bordelaise sauce', 'Grilled beef rib eye bordelaise sauce', 'Grilled beef rib eye bordelaise sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2ec8579a-6c13-4dd8-a206-da7e1c1882ff', 'R2005', 'Roasted Australian beef tenderloin', 'Roasted Australian beef tenderloin', 'Roasted Australian beef tenderloin', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '15c673b9-d275-40c0-a7e8-a2069b58479b', 'R2006', 'American Hanging tender', 'American Hanging tender', 'American Hanging tender', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd974ecdb-48de-4f91-98bc-214fcc5f0457', 'R2007', 'Grilled T-bone steak besarnaise sauce', 'Grilled T-bone steak besarnaise sauce', 'Grilled T-bone steak besarnaise sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '284a1348-90c1-4227-9336-fc46a6fd4a42', 'R2008', 'Lamb shank confit with sweet spices', 'Lamb shank confit with sweet spices', 'Lamb shank confit with sweet spices', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '61fb2496-c4e0-479f-acac-57ccf9540ee1', 'R2009', 'Grilled cutlet with Provence''s herbs', 'Grilled cutlet with Provence''s herbs', 'Grilled cutlet with Provence''s herbs', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '24dba49f-d3ec-4a8a-8ab7-a900f8059117', 'R2010', 'Veal tenderloin in apple cider', 'Veal tenderloin in apple cider', 'Veal tenderloin in apple cider', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '42b3bb48-5d26-4620-876d-dc5cff1b1db0', 'R2011', 'Sauteed pork tenderloin with gouda cheese sauce', 'Sauteed pork tenderloin with gouda cheese sauce', 'Sauteed pork tenderloin with gouda cheese sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '47b0bdf9-59d6-495f-a0fa-8f3965ed9d72', 'R2012', 'Local beef fillet with Provencal herbs', 'Local beef fillet with Provencal herbs', 'Local beef fillet with Provencal herbs', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd1e22c97-5e2a-4cf8-96c3-d8d5df1e48fe', 'R2013', 'Chopped beef fillet served with salad and frites', 'Chopped beef fillet served with salad and frites', 'Chopped beef fillet served with salad and frites', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '4de886ae-0eb8-4dd8-b164-4dceae1b1de2', 'R2014', 'Food of the month', 'Food of the month', 'Food of the month', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '12ccd29e-3aa0-42c1-aa83-dfff43e53337', 'R2015', 'American Ribeye Steak 200gram', 'American Ribeye Steak 200gram', 'American Ribeye Steak 200gram', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e2383f26-5c43-429d-a7b4-d690088fb0b9', 'R2016', 'American Ribeye Steak 250gram', 'American Ribeye Steak 250gram', 'American Ribeye Steak 250gram', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '55fc8315-07ad-4bac-815c-335451007ff4', 'R2017', 'American Ribeye Steak 300gram', 'American Ribeye Steak 300gram', 'American Ribeye Steak 300gram', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b1aa5422-37e8-476b-9fe7-f0ff927917fa', 'R2018', 'American KOBE Ribeye Steak 250 gram', 'American KOBE Ribeye Steak 250 gram', 'American KOBE Ribeye Steak 250 gram', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f3ca0a1f-ff6e-4f2e-9b9f-a44b9d6d0385', 'R2019', 'American beef steak', 'American beef steak', 'American beef steak', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '4528d5fb-80f8-4342-80c7-fd092c274ed4', 'R2020', 'Grilled top blade steak', 'Grilled top blade steak', 'Grilled top blade steak', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5be0ab6c-8844-4386-93b1-cc560d65718a', 'R2021', 'Buffalo fillet with spicy sauce', 'Buffalo fillet with spicy sauce', 'Buffalo fillet with spicy sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f9fab401-3d0e-4ea2-9bed-30d949871ec5', 'R3107', 'Pan-fried langouste rock lobster', 'Pan-fried langouste rock lobster', 'Pan-fried langouste rock lobster', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '55fb838b-278d-4983-bfe1-5b2855cad3bb', 'R3001', 'Pan seared Scallops wild mushrooms "Royale"', 'Pan seared Scallops wild mushrooms "Royale"', 'Pan seared Scallops wild mushrooms "Royale"', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd6ee4ed9-378f-470a-bb9b-402fc3e1b4a1', 'R3002', 'Prawns flambéed with Pastis', 'Prawns flambéed with Pastis', 'Prawns flambéed with Pastis', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0ad99c18-b175-49fc-8bfd-f32bb474983e', 'R3003', 'Tilapia fillet breaded with sesame', 'Tilapia fillet breaded with sesame', 'Tilapia fillet breaded with sesame', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '52973d25-4bd8-428a-8712-a5612545782f', 'R3004', 'Roasted Sea bass crusted chorizo', 'Roasted Sea bass crusted chorizo', 'Roasted Sea bass crusted chorizo', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'efe2108a-2a50-4da0-8369-895249455e81', 'R3005', 'Pan seared Norwegian salmon', 'Pan seared Norwegian salmon', 'Pan seared Norwegian salmon', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1504f521-2faa-454d-a058-379c972895e5', 'R3006', 'Black Cod Fish', 'Black Cod Fish', 'Black Cod Fish', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '55677a25-9c8c-4838-b6c9-ab1345f6a79e', 'R5001', 'Haft-cooked dark chocolate cake', 'Haft-cooked dark chocolate cake', 'Haft-cooked dark chocolate cake', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '38d221a2-f005-43f4-8984-f72cf476b028', 'R5002', '"Vacherin" ice cream mint and chocolate', '"Vacherin" ice cream mint and chocolate', '"Vacherin" ice cream mint and chocolate', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0c2c4222-20bb-464c-afab-d020bf7d2d07', 'R5005', 'Fine apple tart, cinnamon ice cream', 'Fine apple tart, cinnamon ice cream', 'Fine apple tart, cinnamon ice cream', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '83329ef4-da99-4bfb-a048-f613e3e2bfa2', 'R5007', 'Fresh Fruit Platter', 'Fresh Fruit Platter', 'Fresh Fruit Platter', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f7161e09-90f2-430a-8f9e-620072d52df3', 'R5008', 'Ice cream (1 scoop)', 'Ice cream (1 scoop)', 'Ice cream (1 scoop)', NULL,
      'CUP', 'CUP', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '87b873ab-440f-461f-a8c5-849e950103fb', 'R5009', 'Ice cream (2 scoops)', 'Ice cream (2 scoops)', 'Ice cream (2 scoops)', NULL,
      'CUP', 'CUP', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0735b3ef-ad8d-4c52-8bc0-8350f079843d', 'R5010', 'Chocolate balls', 'Chocolate balls', 'Chocolate balls', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '82be2748-fb65-4419-a55c-a11d98aa63a6', 'M5008', 'Armagnac', 'Armagnac', 'Armagnac', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '70c70f0a-0364-4b38-99c8-599e0ca158d1', 'M8005', 'Whisky & coke', 'Whisky & coke', 'Whisky & coke', 'b3b4e57e-464d-562f-80ec-b216c92d5e88',
      'GLASS', 'GLASS', 1, 450,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '765007cd-05b4-48dd-b6f1-6a8670799a50', 'V4043', 'Aurore De Dauzac 750- Red', 'Aurore De Dauzac 750- Red', 'Aurore De Dauzac 750- Red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '961151af-59cd-4bd8-8d9d-ffe2653b4bcc', 'V5021', 'Petit Chablis Pas Si Petit 75cl - White', 'Petit Chablis Pas Si Petit 75cl - White', 'Petit Chablis Pas Si Petit 75cl - White', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'bb68a23c-fb86-4d32-bd45-deffd420a6d5', 'R1012', 'Breaded frog''s legs', 'Breaded frog''s legs', 'Breaded frog''s legs', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '60ebbfab-e076-4a82-8e5c-17ee17c8bf29', 'V4044', 'Premiere Note Syrah 75cl', 'Premiere Note Syrah 75cl', 'Premiere Note Syrah 75cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'bd12abf2-7f7a-4ab3-90e3-9c70ac61188f', 'V5022', 'Premiere Note Marsanne 75cl (White)', 'Premiere Note Marsanne 75cl (White)', 'Premiere Note Marsanne 75cl (White)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b1168dfd-925e-42d1-890f-408af903cbc5', 'R6034', 'Set Menu 10B', 'Set Menu 10B', 'Set Menu 10B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f2eeb660-5038-49e6-b8b1-6a6de894d6ce', 'R6035', 'Set Menu 10C', 'Set Menu 10C', 'Set Menu 10C', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ae7d8c8d-d911-4566-95c8-f61d21d9ba85', 'R6028', 'Set Menu 11A', 'Set Menu 11A', 'Set Menu 11A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2e817328-2fa3-41f0-a000-af74414e4b15', 'R6029', 'Set Menu 11B', 'Set Menu 11B', 'Set Menu 11B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0e861b08-f9f5-424f-ae93-38a9bf3e88b6', 'R6036', 'Set menu 11C', 'Set menu 11C', 'Set menu 11C', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6e46e49a-48d0-42df-b3dd-a79696fa811f', 'R6003', 'Set Menu 320760', 'Set Menu 320760', 'Set Menu 320760', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '88afc908-4267-4b18-9028-516da5b7f7c5', 'R6004', 'Set Menu 320760', 'Set Menu 320760', 'Set Menu 320760', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e60e4608-9362-419d-8d12-64e557db2ca6', 'R6005', 'Set Menu 12B1', 'Set Menu 12B1', 'Set Menu 12B1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'cc354a08-e723-4c0b-aa0b-a5480a44ebf0', 'R6006', 'Set Menu 12B2', 'Set Menu 12B2', 'Set Menu 12B2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '50d9ff13-3b64-4342-956e-1a8f2a1b27e5', 'R6060', 'Set menu 12C1', 'Set menu 12C1', 'Set menu 12C1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '87509808-1168-4117-aca6-3212bc9678f5', 'R6030', 'Set Menu 13A', 'Set Menu 13A', 'Set Menu 13A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '486c037a-c221-48a1-afef-62c6759f0f1c', 'R6031', 'Set Menu 13B', 'Set Menu 13B', 'Set Menu 13B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e3af735b-19b0-4d6b-8321-de02581ae7cc', 'R6032', 'Set Menu 13C', 'Set Menu 13C', 'Set Menu 13C', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '57d1406b-9081-44d1-81f7-52facd320628', 'R6067', 'Set menu 13D', 'Set menu 13D', 'Set menu 13D', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5d831a9b-2d1f-4e91-9ca0-a4d7842e991e', 'R6065', 'Set menu 14A1', 'Set menu 14A1', 'Set menu 14A1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e4df8aa8-e53c-48af-a162-fa76fcd05eac', 'R6066', 'Set menu 14A2', 'Set menu 14A2', 'Set menu 14A2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '72881f85-369b-4e75-b9fa-18d4ac207dc8', 'R6007', 'Set Menu 15A1', 'Set Menu 15A1', 'Set Menu 15A1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '3f3006df-3806-4c0d-9183-e83dd9fdc898', 'R5108', 'Birthday cake', 'Birthday cake', 'Birthday cake', NULL,
      'PIECE', 'PIECE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9fbb9c42-0ab1-40e1-961e-00024468472b', 'R1030', 'Salmon Sashimi', 'Salmon Sashimi', 'Salmon Sashimi', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a36e031d-438e-405b-8d0d-6666e6b22ab4', 'R6008', 'Set Menu 15A2', 'Set Menu 15A2', 'Set Menu 15A2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '41466195-9e9a-4ad4-b59e-c43436129d00', 'R6009', 'Set Menu 15B1', 'Set Menu 15B1', 'Set Menu 15B1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '08669aa7-f740-43c9-a30f-28e3ab005909', 'R6010', 'Set Menu 15B2', 'Set Menu 15B2', 'Set Menu 15B2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '94b71c25-5f42-4782-a20f-6f95cd83de0a', 'R6061', 'Set menu 15C1', 'Set menu 15C1', 'Set menu 15C1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5b8ee374-da59-49c8-b7aa-e244af002f41', 'R6076', 'Set menu 15C2', 'Set menu 15C2', 'Set menu 15C2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1f739ea7-c864-473f-95c4-c3a4b9f3ea56', 'R2122', 'Roasted Lamb Leg (Kg)', 'Roasted Lamb Leg (Kg)', 'Roasted Lamb Leg (Kg)', NULL,
      'KG', 'KG', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '7539e852-90c7-48a0-a299-064face0441e', 'R6079', 'Set menu 15D1', 'Set menu 15D1', 'Set menu 15D1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'dddd79e8-d1fd-49d5-9800-b46f3beb1188', 'R6085', 'Set menu 16.89A1', 'Set menu 16.89A1', 'Set menu 16.89A1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '69938337-cd4b-4570-b464-46ddc7881998', 'R6086', 'Set menu 16.89A2', 'Set menu 16.89A2', 'Set menu 16.89A2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd43b3b3e-bc67-4191-a18f-a36312c00651', 'R6011', 'Set Menu 18A1', 'Set Menu 18A1', 'Set Menu 18A1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ad362b51-b061-46fc-8d1b-a44e2247faf6', 'R6012', 'Set Menu 18A2', 'Set Menu 18A2', 'Set Menu 18A2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '31da8859-4f0b-479e-8917-6899260017a3', 'R6013', 'Set Menu 18B1', 'Set Menu 18B1', 'Set Menu 18B1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '35dbc71f-df05-48b9-b13d-88f702f1bfd3', 'R6014', 'Set Menu 18B2', 'Set Menu 18B2', 'Set Menu 18B2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'bbc74a85-a251-4cdb-bbaa-6cf8939d19c6', 'V5023', 'Louis Latour - Bourgogne Chardonnay', 'Louis Latour - Bourgogne Chardonnay', 'Louis Latour - Bourgogne Chardonnay', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9ceca904-cc19-42ce-9c5b-41e43c755440', 'R6015', 'Set Menu 20A1', 'Set Menu 20A1', 'Set Menu 20A1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2389d1a9-e121-4aee-8b13-affaa250905e', 'R6016', 'Set Menu 20A2', 'Set Menu 20A2', 'Set Menu 20A2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '7326faa8-1522-4933-a012-8f0b291339ec', 'R6017', 'Set Menu 20B1', 'Set Menu 20B1', 'Set Menu 20B1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '51be7cd9-26b7-49e0-8950-b966a4e4b948', 'M3011', 'Smirnoff red label glass', 'Smirnoff red label glass', 'Smirnoff red label glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'abd68e06-da87-4831-8d5d-849e95923ebf', 'R6018', 'Set Menu 20B2', 'Set Menu 20B2', 'Set Menu 20B2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '924e8ec7-6955-493e-9311-cf0f05e1b587', 'R6062', 'Set menu 20C1', 'Set menu 20C1', 'Set menu 20C1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6dd671b8-f517-47ce-ac2f-ca1578a4e345', 'B5015', 'Radbuz draught', 'Radbuz draught', 'Radbuz draught', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '8f2eecf9-228f-467c-b03b-39afca81c0f2', 'R6077', 'Set menu 23A1', 'Set menu 23A1', 'Set menu 23A1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a74b2e86-733e-4106-a759-31dd6a8398a8', 'R6078', 'Set menu 23A2', 'Set menu 23A2', 'Set menu 23A2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a81af2fc-5eb0-4ca2-9a7f-c055a300cdb8', 'R6122', 'Set menu 23B1', 'Set menu 23B1', 'Set menu 23B1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '54ddb044-c097-42a5-959b-4273af53d62e', 'R6123', 'Set menu 23B2', 'Set menu 23B2', 'Set menu 23B2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1acae469-5faa-4a21-a272-53f9f390b16e', 'R6124', 'Set menu 23B3', 'Set menu 23B3', 'Set menu 23B3', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '21d6848e-34fd-4975-978f-4ac9e49c388d', 'R6125', 'Set menu 23B4', 'Set menu 23B4', 'Set menu 23B4', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'bf8de422-fb88-4f87-99a7-cd4725fb40cc', 'R6126', 'Set Menu 24A1', 'Set Menu 24A1', 'Set Menu 24A1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b7dcf158-9c51-4e9c-954a-b9092b6ab8ec', 'R6127', 'Set Menu 24A2', 'Set Menu 24A2', 'Set Menu 24A2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c09df863-8998-4356-bffe-ec126f5b5027', 'R6019', 'Set Menu 25A1', 'Set Menu 25A1', 'Set Menu 25A1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c06135f4-ed41-4ea7-91ff-28df6b084f46', 'R6020', 'Set Menu 25A2', 'Set Menu 25A2', 'Set Menu 25A2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e8faaaf2-1000-44e4-bd6d-704a5a354940', 'R6074', 'Set menu 25A3', 'Set menu 25A3', 'Set menu 25A3', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9faf0f9d-2f85-4b80-bd24-5be6f9d5c779', 'R2123', 'Roasted Beef Op Rib (kg)', 'Roasted Beef Op Rib (kg)', 'Roasted Beef Op Rib (kg)', NULL,
      'PIECE', 'PIECE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0d2eb7be-77e5-4e29-911a-1b08446ba782', 'R6021', 'Set Menu 30A1', 'Set Menu 30A1', 'Set Menu 30A1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2d75e7d6-abfa-4368-b2c2-8abcdaea9781', 'V9407', 'Premiere note rose de syrah 75cl', 'Premiere note rose de syrah 75cl', 'Premiere note rose de syrah 75cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2009a3b9-a572-4fbb-af0f-eb6fcf5faa54', 'V4046', 'Cotes Catalanes Domaine Rombeau Merlot - Red', 'Cotes Catalanes Domaine Rombeau Merlot - Red', 'Cotes Catalanes Domaine Rombeau Merlot - Red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0d08e8e9-77d2-455a-92c8-40f88bde684b', 'V4047', 'Domain Rombeau La Cave Secrete - Red', 'Domain Rombeau La Cave Secrete - Red', 'Domain Rombeau La Cave Secrete - Red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ae8f3ffd-9f36-4823-a1c9-88895c5ffebc', 'V4048', 'Chateau Rombeau Elise Vieles Vignes 16% - Red', 'Chateau Rombeau Elise Vieles Vignes 16% - Red', 'Chateau Rombeau Elise Vieles Vignes 16% - Red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5c4a1e4b-b3ef-44c1-b343-a28835323df7', 'V9103', 'Hamilton Island Shiraz (888)', 'Hamilton Island Shiraz (888)', 'Hamilton Island Shiraz (888)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'baa54d98-16da-4653-81c1-5605fe3222dc', 'V9104', 'Hamilton Island Shiraz (389)', 'Hamilton Island Shiraz (389)', 'Hamilton Island Shiraz (389)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ea93db61-f5ea-44e1-aac3-80ddf65abd9f', 'V9105', 'Hamilton Island Cabernet Sauvignon (168)', 'Hamilton Island Cabernet Sauvignon (168)', 'Hamilton Island Cabernet Sauvignon (168)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd63bf040-26a6-47dc-b11a-bfe7ec9b1d42', 'V7007', 'Passimiento Baglio Gibellina (Red)', 'Passimiento Baglio Gibellina (Red)', 'Passimiento Baglio Gibellina (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '3bc015df-8676-419d-8ca1-6c73090a835e', 'R6022', 'Set Menu 30A2', 'Set Menu 30A2', 'Set Menu 30A2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'fa6c940e-ba17-47e0-80e3-edcba71abfdc', 'R6063', 'Set menu 30B1', 'Set menu 30B1', 'Set menu 30B1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'fe69dd3f-0b12-4198-9aed-83657f902f83', 'R6064', 'Set menu 30B2', 'Set menu 30B2', 'Set menu 30B2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5a1d8109-6ed7-4af4-a515-560fbeb3f35d', 'R6023', 'Set Menu 35A1', 'Set Menu 35A1', 'Set Menu 35A1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f1d8cd50-2cbd-4364-8a12-da6b7f5457b1', 'R21031', 'Grilled US beef rib eyes 200 gram', 'Grilled US beef rib eyes 200 gram', 'Grilled US beef rib eyes 200 gram', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '3c021278-dc54-4622-a23b-8030196e0862', 'R21032', 'Grilled US beef rib eyes 300 gram', 'Grilled US beef rib eyes 300 gram', 'Grilled US beef rib eyes 300 gram', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2241eaee-db07-44b2-9c23-e0423decae79', 'R21033', 'Grilled US beef rib eyes 400 gram', 'Grilled US beef rib eyes 400 gram', 'Grilled US beef rib eyes 400 gram', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a0d44d7f-9248-4c47-bfda-41eb9f1e3145', 'R21041', 'Grilled US beef striploin 200 gram', 'Grilled US beef striploin 200 gram', 'Grilled US beef striploin 200 gram', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a83b1b48-ec7c-448c-a5eb-21fa86f29ece', 'R21042', 'Grilled US beef striploin 300 gram', 'Grilled US beef striploin 300 gram', 'Grilled US beef striploin 300 gram', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '4d18df66-2562-4752-b8ab-b154b550c190', 'R21043', 'Grilled US beef striploin 400 gram', 'Grilled US beef striploin 400 gram', 'Grilled US beef striploin 400 gram', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c8169f46-b4d1-45f6-a4fa-b4ecabb5ffbd', 'R21061', 'Grilled US beef tenderloin 200 gram', 'Grilled US beef tenderloin 200 gram', 'Grilled US beef tenderloin 200 gram', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '036d822b-c393-43fa-9e85-56b797f5c128', 'R21062', 'Grilled US beef tenderloin 300 gram', 'Grilled US beef tenderloin 300 gram', 'Grilled US beef tenderloin 300 gram', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '148b7190-e37d-40a8-9046-3d4574f59932', 'R21081', 'Grilled US topblade 300 gram', 'Grilled US topblade 300 gram', 'Grilled US topblade 300 gram', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2ba991e1-6f28-48c1-bb02-bca6d36082ca', 'R21082', 'Grilled US topblade 400 gram', 'Grilled US topblade 400 gram', 'Grilled US topblade 400 gram', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '17d40bd5-b165-4bfc-a1f5-c71c4f9a312d', 'R21021', 'Pigeon wellington foie gras red beetroot truffle jus', 'Pigeon wellington foie gras red beetroot truffle jus', 'Pigeon wellington foie gras red beetroot truffle jus', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '88e52db1-d60c-4777-b12b-98e8319d70a5', 'V9601', 'Belle Ambiance Pinot Noir California', 'Belle Ambiance Pinot Noir California', 'Belle Ambiance Pinot Noir California', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'PIECE', 'PIECE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '02b75ffc-d438-4628-9f60-4779d478f1af', 'V9602', 'Belle Ambiance Pinot Grigio California', 'Belle Ambiance Pinot Grigio California', 'Belle Ambiance Pinot Grigio California', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'PIECE', 'PIECE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a5cb20b0-85fa-42a8-8b8d-a7a2b506ecdb', 'V4049', 'Chateau Badette, Pessac - Saint Emilion GCC', 'Chateau Badette, Pessac - Saint Emilion GCC', 'Chateau Badette, Pessac - Saint Emilion GCC', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'be7bc261-38ed-4903-a50e-0fc1078cd078', 'V4050', 'Mercurey Rouge Louis Latour', 'Mercurey Rouge Louis Latour', 'Mercurey Rouge Louis Latour', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a83d49da-f25a-46df-b523-f9b0c9dd2206', 'V4051', 'Brio de Cantenac Brown,Cabernet Sauvignon', 'Brio de Cantenac Brown,Cabernet Sauvignon', 'Brio de Cantenac Brown,Cabernet Sauvignon', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '625b5cb3-1219-46aa-bb9f-279cf66d8ee6', 'V6047', 'Yali Reserva, Ventisquero - White', 'Yali Reserva, Ventisquero - White', 'Yali Reserva, Ventisquero - White', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a3c99d93-600f-40c7-9a67-907e57f543ee', 'V6043', 'G7 Reserva, Carta Vieja - White', 'G7 Reserva, Carta Vieja - White', 'G7 Reserva, Carta Vieja - White', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f4c7930d-a44d-4066-9f1d-c60512f49513', 'V6045', 'Santa Carolina Vistana - White', 'Santa Carolina Vistana - White', 'Santa Carolina Vistana - White', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '7c8836f5-1141-4e2a-a43c-c59d3c5a53a7', 'V9303', 'Portia Prima, red', 'Portia Prima, red', 'Portia Prima, red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '04555b72-9ff1-4003-98b7-7257a0f5f1c7', 'V6038', 'Santa Ema Teroir Reserva Cabernet Sauvignon (Red)', 'Santa Ema Teroir Reserva Cabernet Sauvignon (Red)', 'Santa Ema Teroir Reserva Cabernet Sauvignon (Red)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '551e33eb-020d-44aa-973a-4f276c822fd3', 'V6039', 'Santa Ema Teroir Reserva Sauvignon Blanc (White)', 'Santa Ema Teroir Reserva Sauvignon Blanc (White)', 'Santa Ema Teroir Reserva Sauvignon Blanc (White)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2a501c28-3e38-4cec-b7c0-579131cfb445', 'V4052', 'Louis Eschenauer Saint Emilion AOC', 'Louis Eschenauer Saint Emilion AOC', 'Louis Eschenauer Saint Emilion AOC', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b303ac41-ede2-4a18-8692-375b88291f99', 'V4053', 'ChaiMas Rouge', 'ChaiMas Rouge', 'ChaiMas Rouge', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ed91daef-b488-4ee6-9237-3e507c9878ee', 'V4054', 'La Pommeraie de Brown, Cabernet Sauvignon', 'La Pommeraie de Brown, Cabernet Sauvignon', 'La Pommeraie de Brown, Cabernet Sauvignon', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '917a0ff0-db9c-49b4-b56a-c0dccae97790', 'V4055', 'Optimum, Fronton', 'Optimum, Fronton', 'Optimum, Fronton', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '714377f6-9a11-4246-9934-39f38f1f0e27', 'V4056', 'Chateau Tabuteau, Lussac - Saint Emilion', 'Chateau Tabuteau, Lussac - Saint Emilion', 'Chateau Tabuteau, Lussac - Saint Emilion', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '26875c42-defa-444a-98fb-5e1f3d9914cc', 'V4057', 'Patriarche, Mercurey - Red', 'Patriarche, Mercurey - Red', 'Patriarche, Mercurey - Red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '7a46af0c-63c5-4435-963b-a8a22bf370d0', 'V4058', 'Côte De Nuits-Villages Louis Latour', 'Côte De Nuits-Villages Louis Latour', 'Côte De Nuits-Villages Louis Latour', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '47c8eb71-3b07-42fb-98fc-e11e546b0e96', 'V5024', 'ChaiMas Blanc Chateau Paul Mas Languedoc', 'ChaiMas Blanc Chateau Paul Mas Languedoc', 'ChaiMas Blanc Chateau Paul Mas Languedoc', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '60294594-9bb7-4fa4-a454-4e66c7f95173', 'V5025', 'Louis Latour - Chablis Burgundy', 'Louis Latour - Chablis Burgundy', 'Louis Latour - Chablis Burgundy', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b1647aaf-68f8-43fe-8ffa-6da6231b475b', 'V6041', 'Santa Ema Reserva Sauvignon Blanc', 'Santa Ema Reserva Sauvignon Blanc', 'Santa Ema Reserva Sauvignon Blanc', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'cf8a19a7-dd0e-48da-ae62-74651cffb085', 'V6042', 'G7 Reserva, Carta Vieja - Red', 'G7 Reserva, Carta Vieja - Red', 'G7 Reserva, Carta Vieja - Red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f42451cf-c46c-4341-8857-e8f58d433ab5', 'V6044', 'Santa Carolina Vistana - Red', 'Santa Carolina Vistana - Red', 'Santa Carolina Vistana - Red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'aa8c954b-19f9-4f93-83d2-8071bfec8fc8', 'V6046', 'Yali Reserva, Ventisquero - Red', 'Yali Reserva, Ventisquero - Red', 'Yali Reserva, Ventisquero - Red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '39344a48-c8e9-43c9-acef-652d8e160114', 'R2124', 'SIGNATURE Roasted pigeon and foie gras mashed peas', 'SIGNATURE Roasted pigeon and foie gras mashed peas', 'SIGNATURE Roasted pigeon and foie gras mashed peas', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ce994360-1d95-452b-b628-37b4bf12b7fe', 'R3108', 'Sole fillet with butter sauce', 'Sole fillet with butter sauce', 'Sole fillet with butter sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '7bc0d53d-82aa-4801-b476-1d709f55080b', 'R6024', 'Set menu 35A2', 'Set menu 35A2', 'Set menu 35A2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1cac6092-9cd3-40fe-ab61-2d80788b2956', 'V4059', 'Domaine de saravel valreas cotes du rhone villages - Red', 'Domaine de saravel valreas cotes du rhone villages - Red', 'Domaine de saravel valreas cotes du rhone villages - Red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c233561d-b499-4fe4-8b34-49dee287fcbd', 'V7008', 'Moscato Luca Bosio - White', 'Moscato Luca Bosio - White', 'Moscato Luca Bosio - White', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2604a421-34fa-46db-954a-5e9c707a516c', 'R6068', 'Set menu 35A3', 'Set menu 35A3', 'Set menu 35A3', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'deb87a37-ddf2-4972-909c-b813aeb19b25', 'R6070', 'Set menu 35A4', 'Set menu 35A4', 'Set menu 35A4', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '45e71dee-f525-48b1-80fe-deb599a61386', 'M6015', 'La Vie Premium 0,4L', 'La Vie Premium 0,4L', 'La Vie Premium 0,4L', 'b3b4e57e-464d-562f-80ec-b216c92d5e88',
      'BOTTLE', 'BOTTLE', 1, 450,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2e0558d0-b21c-4271-9ce5-bd86d4e59406', 'V6048', 'Yali Sauvignon Blanc', 'Yali Sauvignon Blanc', 'Yali Sauvignon Blanc', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1d2cf6e8-532c-4fb2-80ef-f59d00e073eb', 'M96401', 'KOME HAJIME  - Shochu 25% - bottle 750 ml', 'KOME HAJIME  - Shochu 25% - bottle 750 ml', 'KOME HAJIME  - Shochu 25% - bottle 750 ml', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f4816506-acaf-4c3f-985f-6d4352af92a7', 'R6080', 'Set menu 35A5', 'Set menu 35A5', 'Set menu 35A5', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '03cd3556-b019-4e2a-a774-6b334d767786', 'R6025', 'Set Menu 40', 'Set Menu 40', 'Set Menu 40', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '700768bd-6974-4869-8060-5b8c5853dbe3', 'R6027', 'Set Menu 45', 'Set Menu 45', 'Set Menu 45', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '81df188d-19cc-44ae-895c-7a32e282969f', 'R6037', 'Set menu 50', 'Set menu 50', 'Set menu 50', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e0b0ae1e-f938-4926-9503-fb8fe931a4b4', 'V4060', 'F31 Belle Bergere bottle - Red', 'F31 Belle Bergere bottle - Red', 'F31 Belle Bergere bottle - Red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '833a0e82-7b16-429b-955a-5928667359a5', 'V5026', 'F30 Belle Bergere bottle - White', 'F30 Belle Bergere bottle - White', 'F30 Belle Bergere bottle - White', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1e56ba1d-9aec-4830-b057-fd5f3254166a', 'R3109', 'Cold seafood platter for 1 per', 'Cold seafood platter for 1 per', 'Cold seafood platter for 1 per', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9a24db0b-0239-41e2-8cfe-4997aae0ad4e', 'R3110', 'Cold seafood platter for 2 pers', 'Cold seafood platter for 2 pers', 'Cold seafood platter for 2 pers', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '37ee3c8f-4966-4648-be2c-bb0edeb7d738', 'R3111', 'Cold seafood platter for 3 pers', 'Cold seafood platter for 3 pers', 'Cold seafood platter for 3 pers', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9f7de3f4-7379-42a0-903e-a00dca430073', 'R3112', 'Cold seafood platter for 4 pers', 'Cold seafood platter for 4 pers', 'Cold seafood platter for 4 pers', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5fdd4906-1b56-425c-be88-0bbbae632d7e', 'R3113', 'Cold seafood platter for 5 pers', 'Cold seafood platter for 5 pers', 'Cold seafood platter for 5 pers', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd27785a1-77c8-4419-9c67-06599d41d046', 'R3114', 'Cold seafood platter for 6 pers', 'Cold seafood platter for 6 pers', 'Cold seafood platter for 6 pers', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a3cb2afc-8630-4ecb-bc75-241fa8a6b487', 'R3115', 'Fresh Oyster Size L (Pcs)', 'Fresh Oyster Size L (Pcs)', 'Fresh Oyster Size L (Pcs)', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '55a92f7b-328f-447f-8aae-d56cde5789c7', '0001', 'MK', 'MK', 'MK', 'b3b4e57e-464d-562f-80ec-b216c92d5e88',
      'PIECE', 'PIECE', 1, 450,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c210d78e-6f87-48fc-be2d-2da4cb2eeb09', 'V6050', 'Casa Subercaseaux Cab Sauv', 'Casa Subercaseaux Cab Sauv', 'Casa Subercaseaux Cab Sauv', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '61390f1b-c1ed-46cf-9f35-91bd5a1e0c72', 'DE1001', 'Sandwich - Ham and Cheese', 'Sandwich - Ham and Cheese', 'Sandwich - Ham and Cheese', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '10353939-1e14-4aa3-bfea-b1f6bed46f8b', 'DE1002', 'Sandwich -Smoked Salmon', 'Sandwich -Smoked Salmon', 'Sandwich -Smoked Salmon', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'dc845269-5f67-401f-bad5-e3a6bfd9c334', 'DE1003', 'Set Hải Sản Gồm Rượu', 'Set Hải Sản Gồm Rượu', 'Set Hải Sản Gồm Rượu', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '8b6e843b-8dd0-4214-8493-08b91cc5eb2a', 'DE1004', 'Roasted Chicken', 'Roasted Chicken', 'Roasted Chicken', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '4fed5cc2-15b8-423b-9311-9282021feecc', 'DE1005', 'Roasted Chicken with Hanoi Bia Hơi', 'Roasted Chicken with Hanoi Bia Hơi', 'Roasted Chicken with Hanoi Bia Hơi', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'eded7770-5701-4da8-a7f6-e031df509e65', 'V4061', 'Chateau Batailley Red Bottle', 'Chateau Batailley Red Bottle', 'Chateau Batailley Red Bottle', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '22ab80fc-5a1b-4c22-8269-a7924b2e547b', 'B5017', 'Hanoi Bia Hơi 500ml', 'Hanoi Bia Hơi 500ml', 'Hanoi Bia Hơi 500ml', NULL,
      'CAN', 'CAN', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ef3895d7-95b5-4248-bc5f-368e16755a13', 'DE1006', 'Grilled Pork Rib', 'Grilled Pork Rib', 'Grilled Pork Rib', NULL,
      'KG', 'KG', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd8265d7c-bb80-40eb-995f-0a1094a450f1', 'M6016', 'San Benedetto Still Water 0.75L', 'San Benedetto Still Water 0.75L', 'San Benedetto Still Water 0.75L', 'b3b4e57e-464d-562f-80ec-b216c92d5e88',
      'BOTTLE', 'BOTTLE', 1, 450,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c286da1b-6fea-4516-819e-358f75e406c9', 'M96021', 'Ballantines 15', 'Ballantines 15', 'Ballantines 15', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5abc8b34-cc0d-4ea8-a678-3c509e435475', 'M96361', 'Macallan 12 Double Cask', 'Macallan 12 Double Cask', 'Macallan 12 Double Cask', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '151107c9-7726-4e5d-8bb2-35cad0625c73', 'V60081', 'Casillero Del Diablo Syrah', 'Casillero Del Diablo Syrah', 'Casillero Del Diablo Syrah', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '02da491c-582f-4908-924a-5e47b4f1d3d8', 'R1031', 'Terrine Platter', 'Terrine Platter', 'Terrine Platter', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6166430b-b64a-4010-9188-e25b8281654d', 'R5109', 'Banana Flambee Chuối đốt rượu', 'Banana Flambee Chuối đốt rượu', 'Banana Flambee Chuối đốt rượu', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'dfae1433-fd83-48f1-b38c-c781d5bb80b2', 'R3116', 'Ốc Bulot Vùng Burgundy Pháp (Pcs)', 'Ốc Bulot Vùng Burgundy Pháp (Pcs)', 'Ốc Bulot Vùng Burgundy Pháp (Pcs)', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0adde955-04e7-42d1-b619-13b00ed1e608', 'R5110', 'Bưởi da xanh tráng miệng', 'Bưởi da xanh tráng miệng', 'Bưởi da xanh tráng miệng', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '40e410e5-cd49-4078-9906-8d61f0bc9f08', 'R3117', 'Tôm Bắc Cực (Cold Water Shrimp) Kg', 'Tôm Bắc Cực (Cold Water Shrimp) Kg', 'Tôm Bắc Cực (Cold Water Shrimp) Kg', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '76fc1754-5574-431c-bfee-2046a4f07aed', 'V9409', 'La Palma Rose, Chile', 'La Palma Rose, Chile', 'La Palma Rose, Chile', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f19025cf-1477-49e3-99b5-f9334798030b', 'V4066', 'Ronan By Clinet (by Chateau Clinet, Pomerol) Merlot Bordeaux AC- Red', 'Ronan By Clinet (by Chateau Clinet, Pomerol) Merlot Bordeaux AC- Red', 'Ronan By Clinet (by Chateau Clinet, Pomerol) Merlot Bordeaux AC- Red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c070edce-5374-4807-9180-4c378cfe6dc3', 'V4067', 'Maltus, Pezat, Bordeaux Superior - Red', 'Maltus, Pezat, Bordeaux Superior - Red', 'Maltus, Pezat, Bordeaux Superior - Red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '01a136d6-0ab9-4d95-8932-040ef8b45e35', 'V4070', 'Chateau Roc de Candale, Saint Emilion Grand Cru- Red', 'Chateau Roc de Candale, Saint Emilion Grand Cru- Red', 'Chateau Roc de Candale, Saint Emilion Grand Cru- Red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '193fa7d3-26f3-4f36-b354-ba0cd4f02773', 'V4073', 'Chateau Bertineau Saint-Vincent | Pomerol - Bordeaux- Red', 'Chateau Bertineau Saint-Vincent | Pomerol - Bordeaux- Red', 'Chateau Bertineau Saint-Vincent | Pomerol - Bordeaux- Red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '095d3c2e-a60e-4cea-a95b-ad6ddc313a60', 'V5031', 'Louis Latour Ardèche, Chardonnay - White', 'Louis Latour Ardèche, Chardonnay - White', 'Louis Latour Ardèche, Chardonnay - White', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5589e10c-ebe6-4dba-b63d-8d6f063675a8', 'V6051', 'CASAS DEL TOQUI, Barrel Reserva, Cabernet Sauvignon - Red Chile', 'CASAS DEL TOQUI, Barrel Reserva, Cabernet Sauvignon - Red Chile', 'CASAS DEL TOQUI, Barrel Reserva, Cabernet Sauvignon - Red Chile', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a67f8607-9ccf-4fbb-8db1-790db5e32441', 'V6052', 'CASAS DEL TOQUI, Barrel Reserva, Chardonnay - White Chile', 'CASAS DEL TOQUI, Barrel Reserva, Chardonnay - White Chile', 'CASAS DEL TOQUI, Barrel Reserva, Chardonnay - White Chile', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2925323c-3c9a-4fad-8f49-ff32f63abf86', 'V7009', 'Purato, Siccari Appassimento Organic, Terre Siciliane IGP - Red', 'Purato, Siccari Appassimento Organic, Terre Siciliane IGP - Red', 'Purato, Siccari Appassimento Organic, Terre Siciliane IGP - Red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9d3ede25-3e0c-4cd2-b08a-1fcdaf337496', 'V7010', 'Grande Passolo, Salento - Puglia, Primitivo - Negroamaro - Red', 'Grande Passolo, Salento - Puglia, Primitivo - Negroamaro - Red', 'Grande Passolo, Salento - Puglia, Primitivo - Negroamaro - Red', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '212e3e40-d563-49a9-a0e8-c4aca4a08eab', 'V7011', 'Grande Passolo, Piemonte, Chardonnay - White', 'Grande Passolo, Piemonte, Chardonnay - White', 'Grande Passolo, Piemonte, Chardonnay - White', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f57bd524-1f73-4263-93a7-6d02c39bc237', 'V3009', 'De Bortoli, Deen Vat 5, Botrytis Semillon Late Harvest 37.5cl', 'De Bortoli, Deen Vat 5, Botrytis Semillon Late Harvest 37.5cl', 'De Bortoli, Deen Vat 5, Botrytis Semillon Late Harvest 37.5cl', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '05c53914-cd35-4aee-9583-d872134c830d', 'R3118', 'Vẹm Xanh Newzealand (Newzealand Musseles) Kg', 'Vẹm Xanh Newzealand (Newzealand Musseles) Kg', 'Vẹm Xanh Newzealand (Newzealand Musseles) Kg', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2e665cbd-13a2-48ff-9b74-0397a8f6a646', 'R1032', 'Trâu Gác Bếp (110 gram)', 'Trâu Gác Bếp (110 gram)', 'Trâu Gác Bếp (110 gram)', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '564dc822-313e-4c60-9072-44c365c9af10', 'R1033', 'Bò một nắng (110 gram)', 'Bò một nắng (110 gram)', 'Bò một nắng (110 gram)', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '680f8b5c-01c3-4338-9b93-b1ba92a9537e', 'M6017', 'San Benedetto Still Water 0.5L', 'San Benedetto Still Water 0.5L', 'San Benedetto Still Water 0.5L', 'b3b4e57e-464d-562f-80ec-b216c92d5e88',
      'BOTTLE', 'BOTTLE', 1, 450,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '08a9aa22-f578-4aaa-8305-cced44336952', 'M6018', 'San benedetto Still Water 0.65L', 'San benedetto Still Water 0.65L', 'San benedetto Still Water 0.65L', 'b3b4e57e-464d-562f-80ec-b216c92d5e88',
      'BOTTLE', 'BOTTLE', 1, 450,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '7b99ac07-0298-48f4-9405-880d4330e9db', 'M6019', 'San Benedetto Sparking Water 1L', 'San Benedetto Sparking Water 1L', 'San Benedetto Sparking Water 1L', 'b3b4e57e-464d-562f-80ec-b216c92d5e88',
      'BOTTLE', 'BOTTLE', 1, 450,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a6c54259-ea65-49e8-b0f2-30eadfa10dd8', 'R6038', 'Set menu 55', 'Set menu 55', 'Set menu 55', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ca4a1957-5dc6-46a3-9527-2fafbdc70066', 'R6039', 'Set menu 60', 'Set menu 60', 'Set menu 60', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a6cd922d-4adc-4b17-adb0-b3acd2bb81d5', 'R6075', 'Set menu 70', 'Set menu 70', 'Set menu 70', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '03b55c57-c431-4cce-87a6-e1036ea00cc2', 'R6071', 'Set menu 90', 'Set menu 90', 'Set menu 90', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '50cb2d16-b849-42e1-9267-71377a5b9f2d', 'R6081', 'Roasted Pork with Steam rice', 'Roasted Pork with Steam rice', 'Roasted Pork with Steam rice', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '39925684-5c85-4777-b0d6-d6e03787c1a5', 'R6082', 'Pork stew with Steam rice', 'Pork stew with Steam rice', 'Pork stew with Steam rice', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '44f1e891-e8a4-4c55-b0f3-0e556ea838ee', 'R6083', 'Stuffed chicken leg with Steam rice', 'Stuffed chicken leg with Steam rice', 'Stuffed chicken leg with Steam rice', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ccf554dd-4300-4fe4-a2cd-7641a04c810f', 'R7001', 'Multicolor Salad', 'Multicolor Salad', 'Multicolor Salad', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '84d1a11f-b074-4bad-a239-025e2d003af0', 'R7002', 'Green seasonal vegetables soup', 'Green seasonal vegetables soup', 'Green seasonal vegetables soup', NULL,
      'BOWL', 'BOWL', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '736ad530-cc05-4746-819e-ab55c6cff560', 'R7003', 'Breaded pork loin, tomatoes sauce, broccoli and carrot flan', 'Breaded pork loin, tomatoes sauce, broccoli and carrot flan', 'Breaded pork loin, tomatoes sauce, broccoli and carrot flan', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '482afef1-68d4-4a91-989a-5d01d7fe049b', 'R7004', 'Basa fillet roulade southern, broccoli and carrot flan', 'Basa fillet roulade southern, broccoli and carrot flan', 'Basa fillet roulade southern, broccoli and carrot flan', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '331e960a-96e9-4399-9e44-0bc5adbf6dd1', 'R7005', 'Banana crepe, chocolate sauce', 'Banana crepe, chocolate sauce', 'Banana crepe, chocolate sauce', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6b6d0637-f0b2-48f9-bfce-13e5cc57d5d1', 'R7006', 'Regular Vietnamese coffee or green tea', 'Regular Vietnamese coffee or green tea', 'Regular Vietnamese coffee or green tea', 'b3b4e57e-464d-562f-80ec-b216c92d5e88',
      'CUP', 'CUP', 1, 450,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6b1e585d-f1e7-48b8-b207-7010797916fd', 'R6091', 'Set menu (700)', 'Set menu (700)', 'Set menu (700)', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'aa06f794-26c4-4074-88a7-f07a24dd137c', 'R6092', 'Set menu Christmas', 'Set menu Christmas', 'Set menu Christmas', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '333e61b7-cab5-432f-909b-1bdcc9f89797', 'R6131', 'Set Menu 350A', 'Set Menu 350A', 'Set Menu 350A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd5a08882-2385-4406-9a35-8957504986f3', 'R6132', 'Set Menu 350B', 'Set Menu 350B', 'Set Menu 350B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'fe0ebdf8-0760-419e-bd6e-28d8c9d7cc0b', 'R6133', 'Set menu 350C', 'Set menu 350C', 'Set menu 350C', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '97908ac0-7efc-4e90-9235-160a291d16f8', 'R6134', 'Set Menu 430A', 'Set Menu 430A', 'Set Menu 430A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b19a1f5a-f008-497b-ba23-c44f66366334', 'R6135', 'Set Menu 430B', 'Set Menu 430B', 'Set Menu 430B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '412f3157-4647-4f84-922e-088fba9e3398', 'R6154', 'Set Menu 430C', 'Set Menu 430C', 'Set Menu 430C', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c5152ffa-383b-4bde-992c-99515c0d7691', 'R6193', 'Set Menu 500A', 'Set Menu 500A', 'Set Menu 500A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '43640a7f-b2a9-4d9a-8392-e4412e330f12', 'V2013', 'Gemma Di Luma Moscato 75CL', 'Gemma Di Luma Moscato 75CL', 'Gemma Di Luma Moscato 75CL', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'fa95b12d-41e5-43df-8f9b-f5838d8b3562', 'R1110', 'Beef Tartare', 'Beef Tartare', 'Beef Tartare', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '196ec2bc-670a-4940-8c0f-5dc5b5031f08', 'R6194', 'Set Menu 500B', 'Set Menu 500B', 'Set Menu 500B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e4c3e993-bf18-4ef1-a50e-8e6f281fa401', 'R6155', 'Set Menu 510A', 'Set Menu 510A', 'Set Menu 510A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '649b6c1d-fd40-4663-948b-0db76b29f659', 'R61551', 'Set Menu 510B', 'Set Menu 510B', 'Set Menu 510B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '31554b7f-dd72-4a1f-9602-be40b34f8e1c', 'R6136', 'Set Menu 550A', 'Set Menu 550A', 'Set Menu 550A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '3e15180f-3b29-43b1-9e97-6de4ece25394', '001', 'Open Menu Drink', 'Open Menu Drink', 'Open Menu Drink', 'b3b4e57e-464d-562f-80ec-b216c92d5e88',
      'PIECE', 'PIECE', 1, 450,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '103b50f2-cb8d-4e85-aa8a-bb1ff55eea15', 'R6137', 'Set Menu 550B', 'Set Menu 550B', 'Set Menu 550B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b4321738-1629-41f4-b765-e706d7a4612e', 'R6196', 'Set Menu 550C', 'Set Menu 550C', 'Set Menu 550C', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1351bc10-a609-4f21-a72c-7fee962ef8ac', 'R6197', 'Set Menu 550D', 'Set Menu 550D', 'Set Menu 550D', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '57ce4c88-539b-4876-ac17-8d8f76cd5b9c', 'R6198', 'Set Menu 550E', 'Set Menu 550E', 'Set Menu 550E', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '4d11b646-ed60-4599-88b6-ce2efdeb5f00', 'R6151', 'Set Menu 650A', 'Set Menu 650A', 'Set Menu 650A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '97cd7178-49c6-4f8f-aa9b-d669b7231367', 'R6152', 'Set Menu 650B', 'Set Menu 650B', 'Set Menu 650B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '09a37c7e-a04b-46dd-bd05-d14f767783ca', 'R6138', 'Set Menu 710A', 'Set Menu 710A', 'Set Menu 710A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e83844e3-707f-48ca-bed9-4d0b77ba5dc9', 'R6139', 'Set Menu 710B', 'Set Menu 710B', 'Set Menu 710B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0a07b910-da25-4440-937d-566f170457ce', 'R6153', 'Set Menu 710C', 'Set Menu 710C', 'Set Menu 710C', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c9a0d4c8-ba51-4cfe-941d-038f07e8f6d7', 'R6195', 'Set Menu 710D', 'Set Menu 710D', 'Set Menu 710D', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '35732279-a915-48de-8242-214ee4f63193', 'R6147', 'Set Menu 720A', 'Set Menu 720A', 'Set Menu 720A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '97f2549d-215e-48cf-bb4d-53aa85597965', 'R6148', 'Set Menu 720B', 'Set Menu 720B', 'Set Menu 720B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '61ff85a7-581a-4383-aa76-6f5d98a243aa', 'R6149', 'Set Menu 720C', 'Set Menu 720C', 'Set Menu 720C', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c54b848a-86e8-49d3-8650-fd635fa0acb1', 'R6150', 'Set Menu 720D', 'Set Menu 720D', 'Set Menu 720D', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '82003eea-5d75-4ae7-9451-37f964d6cade', 'R61501', 'Set Menu 720E', 'Set Menu 720E', 'Set Menu 720E', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '376d0cf5-a97a-4d67-8fbb-daade0baa303', 'R61502', 'Set Menu 720F', 'Set Menu 720F', 'Set Menu 720F', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '841d5359-16e7-4a3d-8b1e-89bdbe536b32', 'R6199', 'Set Menu 850A', 'Set Menu 850A', 'Set Menu 850A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5162f24c-6bdd-4155-8f9f-a2848f1bd0a8', 'R61991', 'Set Menu 850B', 'Set Menu 850B', 'Set Menu 850B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6325b167-e38a-4c52-94a2-a950c3fe7e8c', 'R61992', 'Set Menu 850C', 'Set Menu 850C', 'Set Menu 850C', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '56052fea-656f-409d-8a37-889eb00c6e4f', 'R6140', 'Set Menu 940', 'Set Menu 940', 'Set Menu 940', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c817912f-bf1c-4ef9-90fe-3f90037e8882', 'R61401', 'Set Menu 950', 'Set Menu 950', 'Set Menu 950', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '72c9dd60-4b0b-478b-84a8-23ed9f14a49c', 'R614011', 'Set Menu 1050', 'Set Menu 1050', 'Set Menu 1050', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '7975c6ad-5ed9-493b-8999-0b27042bf7e3', 'R6141', 'Set Menu 1190', 'Set Menu 1190', 'Set Menu 1190', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b6d0dd9d-0d6d-4324-99f1-1e5576fa961f', 'R61411', 'Set Menu 1200', 'Set Menu 1200', 'Set Menu 1200', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '4cc722dc-b087-406d-be91-37b08e12a43b', 'R6142', 'Set Menu 1500', 'Set Menu 1500', 'Set Menu 1500', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '26c559ee-9da9-49c5-90ad-3f02db976624', 'R6143', 'Set Menu 1800A', 'Set Menu 1800A', 'Set Menu 1800A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f451fd2e-686b-4172-83c0-3af89aebb165', 'R6144', 'Set Menu 2200', 'Set Menu 2200', 'Set Menu 2200', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd1f98c68-0684-4e01-bf73-0fdfdcfb0a71', 'R6145', 'Set Menu 2700', 'Set Menu 2700', 'Set Menu 2700', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '4c13997c-93e6-4d43-9eb1-af1fcf1737a4', 'R6146', 'Set Menu 3300', 'Set Menu 3300', 'Set Menu 3300', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ff6bf0c4-c620-4fe3-8eae-159b04f3686d', 'R60921', 'Set Menu New Year for 2 pers', 'Set Menu New Year for 2 pers', 'Set Menu New Year for 2 pers', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '337b6d13-8b4d-4725-9679-7854ddfdfc81', 'R609212', 'Set Menu New Year for 2 pers with wine', 'Set Menu New Year for 2 pers with wine', 'Set Menu New Year for 2 pers with wine', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c537e856-b30c-4fcd-a397-06afbb867200', 'R609213', 'Valentine set menu for 2 pers', 'Valentine set menu for 2 pers', 'Valentine set menu for 2 pers', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a77ec238-bd63-4726-b92e-09fd2f2b43b2', 'R6156', 'Set Menu Two Courses 1+3 A', 'Set Menu Two Courses 1+3 A', 'Set Menu Two Courses 1+3 A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ce1317fc-ba41-42bc-aca7-0ff9b83590b5', 'R6157', 'Set Menu Two Courses 1+3 B', 'Set Menu Two Courses 1+3 B', 'Set Menu Two Courses 1+3 B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '699c2fd2-aa97-4c5c-a36b-8916d100d47d', 'R6158', 'Set Menu Two Courses 1+3 C', 'Set Menu Two Courses 1+3 C', 'Set Menu Two Courses 1+3 C', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2e6d262c-4496-4fcf-9b7f-d3467fc32f60', 'R6159', 'Set Menu Two Courses 1+3 D', 'Set Menu Two Courses 1+3 D', 'Set Menu Two Courses 1+3 D', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd32e5df1-a94b-420c-8b5d-b9c56ea96866', 'R6160', 'Set Menu Two Courses 1+3 E', 'Set Menu Two Courses 1+3 E', 'Set Menu Two Courses 1+3 E', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1df234ff-3499-4c61-8fea-57f25f18658c', 'R6161', 'Set Menu Two Courses 2+3 A', 'Set Menu Two Courses 2+3 A', 'Set Menu Two Courses 2+3 A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'cd312a9f-cfb0-413b-ae46-7d169d9b4120', 'R6162', 'Set Menu Two Courses 2+3 B', 'Set Menu Two Courses 2+3 B', 'Set Menu Two Courses 2+3 B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '98afd571-f82c-4506-b8f1-bf96dba987af', 'R6163', 'Set Menu Two Courses 2+3 C', 'Set Menu Two Courses 2+3 C', 'Set Menu Two Courses 2+3 C', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '8c9faf8f-9886-4fd2-bffe-dac3a5c56432', 'R6164', 'Set Menu Two Courses 2+3 D', 'Set Menu Two Courses 2+3 D', 'Set Menu Two Courses 2+3 D', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a8d0e492-c612-4079-8e01-9cf2dc54433d', 'V4079', 'Chateau Haut Dambert', 'Chateau Haut Dambert', 'Chateau Haut Dambert', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '8082e764-399f-4461-8353-59f2251c1f0f', 'R6165', 'Set Menu Two Courses 2+3 E', 'Set Menu Two Courses 2+3 E', 'Set Menu Two Courses 2+3 E', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd217ebc8-3cf6-4699-9205-93674eeb4f15', 'V9107', 'Barramundi, Chardonnay - Australia', 'Barramundi, Chardonnay - Australia', 'Barramundi, Chardonnay - Australia', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a7ba56bf-288c-40ff-8345-a58133d3d42d', 'V4080', 'Château Clou Du Pin Bordeaux Supérieur ( Red )', 'Château Clou Du Pin Bordeaux Supérieur ( Red )', 'Château Clou Du Pin Bordeaux Supérieur ( Red )', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f5abd099-fe9e-4630-9ee9-a94971ef4575', 'V5035', 'Château Clou Du Pin Bordeaux Blanc ( White )', 'Château Clou Du Pin Bordeaux Blanc ( White )', 'Château Clou Du Pin Bordeaux Blanc ( White )', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ab4e1ef2-920a-4720-bc97-f65ce1229724', 'M9113', 'Red Wine Glass Chile - Fronterra', 'Red Wine Glass Chile - Fronterra', 'Red Wine Glass Chile - Fronterra', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '547c119f-11cb-44c0-9b8e-1def6ea9bc2c', 'M9114', 'White Wine Glass Chile - Fronterra', 'White Wine Glass Chile - Fronterra', 'White Wine Glass Chile - Fronterra', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f59d5351-d5b2-4469-8a1f-37f1bd5f58ae', 'R1111', 'Garden Vegetables', 'Garden Vegetables', 'Garden Vegetables', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '53b4e91b-db29-4ce5-9fe5-87856d0aac19', 'R1112', 'Baked Beet Salad', 'Baked Beet Salad', 'Baked Beet Salad', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b5e5c737-9b8a-473d-9e0d-e67c790e29a5', 'R1113', 'Cured Salmon Carpaccio', 'Cured Salmon Carpaccio', 'Cured Salmon Carpaccio', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '08d31742-53f4-4a74-8ea0-124fe685fcb3', 'R1114', 'Beef  Carpaccio', 'Beef  Carpaccio', 'Beef  Carpaccio', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '65d926d1-d0ae-4362-af0d-7df2202b8879', 'R1115', 'Seared Ahi Tuna', 'Seared Ahi Tuna', 'Seared Ahi Tuna', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'da6b26c4-b56f-40e2-8566-85f2ba81bd47', 'R1116', 'Slice Scallops', 'Slice Scallops', 'Slice Scallops', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '27a65dac-523f-4aeb-a08b-54851cafdf45', 'R1117', 'Tomato Seafood Soup', 'Tomato Seafood Soup', 'Tomato Seafood Soup', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9ba8a674-c519-4321-b1e7-03c51ee2c49c', 'R1118', 'Dalat Artichoke Soup', 'Dalat Artichoke Soup', 'Dalat Artichoke Soup', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0bba224c-7203-4a09-8590-8cf72eaab2d2', 'R2125', 'Black Angus US Beef Ribeye 150 gram', 'Black Angus US Beef Ribeye 150 gram', 'Black Angus US Beef Ribeye 150 gram', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '218ebf12-4dca-43df-845b-9dfbb0697bdd', 'R2126', 'Black Angus US Beef Ribeye 200 gram', 'Black Angus US Beef Ribeye 200 gram', 'Black Angus US Beef Ribeye 200 gram', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0e8f07c2-ee6d-4054-bc15-1705f7e8643d', 'R2127', 'Black Angus US Beef Ribeye 300 gram', 'Black Angus US Beef Ribeye 300 gram', 'Black Angus US Beef Ribeye 300 gram', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ff000720-abcc-4d6b-999a-f247f83a465d', 'R2129', 'Char Grilled AUS Beef Tenderloin 150 gram', 'Char Grilled AUS Beef Tenderloin 150 gram', 'Char Grilled AUS Beef Tenderloin 150 gram', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'bdc51f44-f0c9-40ad-ba95-3dac5925766d', 'R2130', 'Char Grilled AUS Beef Tenderloin 200 gram', 'Char Grilled AUS Beef Tenderloin 200 gram', 'Char Grilled AUS Beef Tenderloin 200 gram', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '71988111-8d77-4b7c-b2a2-a94395ca943c', 'R2131', 'Char Grilled AUS Beef Tenderloin 300 gram', 'Char Grilled AUS Beef Tenderloin 300 gram', 'Char Grilled AUS Beef Tenderloin 300 gram', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b38f9139-0b3c-4c15-bb01-fc0adb8ac3a7', 'R2132', 'Prime US Chuck Eye Roll 170 gram', 'Prime US Chuck Eye Roll 170 gram', 'Prime US Chuck Eye Roll 170 gram', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1f738bbb-a652-4b22-a7fe-2424232707b9', 'R2133', 'Prime US Chuck Eye Roll 300 gram', 'Prime US Chuck Eye Roll 300 gram', 'Prime US Chuck Eye Roll 300 gram', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd7bbe7ef-2e91-421d-917c-9fdc6fff89e8', 'R2134', 'Australian Wagyu Ribeye MBS 6+ 150 gram', 'Australian Wagyu Ribeye MBS 6+ 150 gram', 'Australian Wagyu Ribeye MBS 6+ 150 gram', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'bc5a7ae3-52c7-4417-a92b-f72807fabc39', 'R2135', 'AUS Lamb Rack with Asian herb 3 chops', 'AUS Lamb Rack with Asian herb 3 chops', 'AUS Lamb Rack with Asian herb 3 chops', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '7428baf8-43a0-496e-8730-8a7204a25261', 'R2136', 'Pan - Fried French Duck Breast', 'Pan - Fried French Duck Breast', 'Pan - Fried French Duck Breast', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0384f8a1-bcf6-47b3-b211-f2130d7f4a1a', 'R2138', 'Braised Beef Cheek with Dalat Red Wine', 'Braised Beef Cheek with Dalat Red Wine', 'Braised Beef Cheek with Dalat Red Wine', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '64989238-10ff-45ba-a6c7-dc82a5ba5542', 'R2137', 'Roasted Iberico Pork Fillet Mignon', 'Roasted Iberico Pork Fillet Mignon', 'Roasted Iberico Pork Fillet Mignon', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '3a5d7132-8715-40a5-b0b3-3202ff40b6ce', 'R2139', 'Chicken rolls with Sapa mushroom', 'Chicken rolls with Sapa mushroom', 'Chicken rolls with Sapa mushroom', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'bc985cc9-4e13-484f-88f1-7888fc57a703', 'R3119', 'Slow cook Octopus', 'Slow cook Octopus', 'Slow cook Octopus', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'eb85e17e-70a2-4160-a139-d3aad609baa1', 'R3120', 'Pan-Fried Norwegian Salmon,Hanoi basil sauce', 'Pan-Fried Norwegian Salmon,Hanoi basil sauce', 'Pan-Fried Norwegian Salmon,Hanoi basil sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2e4a6c7c-6f45-4bad-9950-bd38ad589167', 'R3121', 'Baked Oven Sea bass, creamy curry sauce', 'Baked Oven Sea bass, creamy curry sauce', 'Baked Oven Sea bass, creamy curry sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '4dd1ff05-6793-484f-8621-9ab534a8a294', 'R3122', 'Pan- Fried Balck Cod, Tamarind sauce', 'Pan- Fried Balck Cod, Tamarind sauce', 'Pan- Fried Balck Cod, Tamarind sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9d7374b5-ec82-47a7-8b9c-9f7a33ebc079', 'R3123', 'Pan- Fried Japanese Scallops', 'Pan- Fried Japanese Scallops', 'Pan- Fried Japanese Scallops', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '32359190-3ff1-48c6-9d16-1524f13d814f', 'R3124', 'Tiger Prawns in a tantalizing chili tamarind sauce', 'Tiger Prawns in a tantalizing chili tamarind sauce', 'Tiger Prawns in a tantalizing chili tamarind sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '8641bddf-b1aa-4f56-8bc3-2ecbbab3a1df', 'SI0001', 'Sauteed Mushroom', 'Sauteed Mushroom', 'Sauteed Mushroom', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9d1dc9d6-a4d5-4b60-8971-86a810506e33', 'SI0002', 'Grilled Asparagus', 'Grilled Asparagus', 'Grilled Asparagus', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6921d53b-2853-41fe-ae87-67f1566feb0d', 'SI0003', 'Arugula Salad', 'Arugula Salad', 'Arugula Salad', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '138db707-7286-4a6c-a60a-2781a0302d82', 'SI0004', 'French Fries', 'French Fries', 'French Fries', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f6e62c6f-90b5-4347-afdd-ae1c01269728', 'SI0005', 'Baked Potatoes', 'Baked Potatoes', 'Baked Potatoes', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b7888c2e-c073-4641-b0c3-c3ca32e19602', 'SI0006', 'Mashed Potatoes', 'Mashed Potatoes', 'Mashed Potatoes', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '5b35c06e-af8e-4519-b009-a543b7d8187a', 'SI0007', 'Extra sauce', 'Extra sauce', 'Extra sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '4d68cdc1-951f-416e-9a32-dadbd6731043', 'R5111', 'Tiramisu Coffee Flavoured', 'Tiramisu Coffee Flavoured', 'Tiramisu Coffee Flavoured', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '3c7e1e91-b7ac-42f8-b983-9fedea16ba45', 'R5112', 'Chocolate and Orange Cheese Cake', 'Chocolate and Orange Cheese Cake', 'Chocolate and Orange Cheese Cake', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1efa404b-1209-47d1-9871-1eb8451fca69', 'R1119', 'Pan-Fried Duck Foie Gras 40Gram', 'Pan-Fried Duck Foie Gras 40Gram', 'Pan-Fried Duck Foie Gras 40Gram', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '499b8acd-59b2-485d-91c2-75160a0a4633', 'R2128', 'Black Angus US Beef Ribeye 400 gram', 'Black Angus US Beef Ribeye 400 gram', 'Black Angus US Beef Ribeye 400 gram', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '22c8226a-0788-45be-b1f3-e23fc3724c34', 'R2140', 'Braised Lamb Shank nestled in a bed of couscous', 'Braised Lamb Shank nestled in a bed of couscous', 'Braised Lamb Shank nestled in a bed of couscous', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2783121a-70bd-4206-ab76-4db204b0d5f4', 'M7024', 'Kombucha Dragon fruit', 'Kombucha Dragon fruit', 'Kombucha Dragon fruit', 'b3b4e57e-464d-562f-80ec-b216c92d5e88',
      'GLASS', 'GLASS', 1, 450,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '7edcb47b-636e-42bb-a400-60fa50374b2c', 'R6166', 'Set Menu Two Courses 1+4', 'Set Menu Two Courses 1+4', 'Set Menu Two Courses 1+4', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '3a263cf8-bfc3-4bf9-8f49-73076eaaf737', 'V4084', 'CHATEAU CAP DE FAUGERES Cotes de Castillon', 'CHATEAU CAP DE FAUGERES Cotes de Castillon', 'CHATEAU CAP DE FAUGERES Cotes de Castillon', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '17d4de2e-82f9-40fd-a769-705b802ff7bb', 'V4085', 'JEAN LUC COLOMBO, "LA VIOLETTE" (Syrah) IGP d''Oc', 'JEAN LUC COLOMBO, "LA VIOLETTE" (Syrah) IGP d''Oc', 'JEAN LUC COLOMBO, "LA VIOLETTE" (Syrah) IGP d''Oc', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '752c42e8-1044-4019-8920-8a7c8e3133cc', 'V4086', 'M.CHAPOUTIER CROZES-HERMITAGE LA PETITE RUCHE (Syrah) Rhone', 'M.CHAPOUTIER CROZES-HERMITAGE LA PETITE RUCHE (Syrah) Rhone', 'M.CHAPOUTIER CROZES-HERMITAGE LA PETITE RUCHE (Syrah) Rhone', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '4dffe6e9-123f-466b-955d-570a0f0698be', 'V5036', 'CHÂTEAU MONT-PÉRAT (Sauvignon Blanc-Semillon) Bordeaux', 'CHÂTEAU MONT-PÉRAT (Sauvignon Blanc-Semillon) Bordeaux', 'CHÂTEAU MONT-PÉRAT (Sauvignon Blanc-Semillon) Bordeaux', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f84c76ab-8646-4f49-9562-3f065f8a2ded', 'V7013', 'DRAGA (Merlot) Venezia Giulia IGP', 'DRAGA (Merlot) Venezia Giulia IGP', 'DRAGA (Merlot) Venezia Giulia IGP', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e1b7832f-77dd-4a4a-9fe8-6a30cfa73e85', 'V7014', 'DRAGA (Sauvignon Blanc) Collio', 'DRAGA (Sauvignon Blanc) Collio', 'DRAGA (Sauvignon Blanc) Collio', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '7aa8af2a-37b4-4bfa-9655-68a8dcf8ebc8', 'V6055', 'Ocho Reserva Cabernet Sauvignon', 'Ocho Reserva Cabernet Sauvignon', 'Ocho Reserva Cabernet Sauvignon', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a07dbb23-93ba-4471-bdb7-e1f72adfc5d1', 'R6167', 'Set Menu Two Courses 2+4', 'Set Menu Two Courses 2+4', 'Set Menu Two Courses 2+4', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ab0f3180-17bb-4481-8a7b-57eb7d3ed907', 'R6168', 'Set Menu Two Courses 3+4 A', 'Set Menu Two Courses 3+4 A', 'Set Menu Two Courses 3+4 A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2feee486-8f94-41fc-bfa2-45e6480b501d', 'R6169', 'Set Menu Two Courses 3+4 B', 'Set Menu Two Courses 3+4 B', 'Set Menu Two Courses 3+4 B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6040bbaa-2a65-4a3d-b20d-653a5124f4c7', 'R6170', 'Set Menu Two Courses 3+4 C', 'Set Menu Two Courses 3+4 C', 'Set Menu Two Courses 3+4 C', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0e3cc178-c1d4-4293-b0bb-fc2380d098e4', 'R6171', 'Set Menu Two Courses 3+4 D', 'Set Menu Two Courses 3+4 D', 'Set Menu Two Courses 3+4 D', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '4933bb97-c5fc-4074-8db8-a2625d66512e', 'R6172', 'Set Menu Two Courses 3+4 E', 'Set Menu Two Courses 3+4 E', 'Set Menu Two Courses 3+4 E', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'f55cc877-0303-42d8-8ae2-434d0059b572', 'R6173', 'Set Menu Three Courses 1+2+3 A', 'Set Menu Three Courses 1+2+3 A', 'Set Menu Three Courses 1+2+3 A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ae86a253-d37d-466b-bb4e-29769cdc138f', 'R6174', 'Set Menu Three Courses 1+2+3 B', 'Set Menu Three Courses 1+2+3 B', 'Set Menu Three Courses 1+2+3 B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a3accc56-5651-4f33-8f04-8e18ca715b31', 'V4087', 'Chateau Fleur Cardinale, Saint-Emilion Grand Cru, France', 'Chateau Fleur Cardinale, Saint-Emilion Grand Cru, France', 'Chateau Fleur Cardinale, Saint-Emilion Grand Cru, France', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1359f30d-b174-4f8d-939f-f6ca9b9c004d', 'R60831', 'Hai Nam Chicken Rice', 'Hai Nam Chicken Rice', 'Hai Nam Chicken Rice', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0dcdf4a5-ef7f-4244-9ef8-8b1b03926993', 'R60811', 'Pork rib with Steam rice', 'Pork rib with Steam rice', 'Pork rib with Steam rice', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '7309cd97-7a96-4b9d-8d7b-5cbc440003e9', 'M96402', 'Tamura Shuzojo Kasen Sake 1.8L', 'Tamura Shuzojo Kasen Sake 1.8L', 'Tamura Shuzojo Kasen Sake 1.8L', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e61e4bc6-ed79-49a2-ab15-8ac69e772851', 'R6175', 'Set Menu Three Courses 1+2+3 C', 'Set Menu Three Courses 1+2+3 C', 'Set Menu Three Courses 1+2+3 C', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '4d855577-33d0-4751-8d97-e57fb8b783b1', 'R6176', 'Set Menu Three Courses 1+2+3 D', 'Set Menu Three Courses 1+2+3 D', 'Set Menu Three Courses 1+2+3 D', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'fb23e0ff-1e05-4778-83cf-55593c058562', 'R6177', 'Set Menu Three Courses 1+2+3 E', 'Set Menu Three Courses 1+2+3 E', 'Set Menu Three Courses 1+2+3 E', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c9499cb2-d51a-4691-8b3d-ab7594d01909', 'M3012', 'Jack Daniel Glass', 'Jack Daniel Glass', 'Jack Daniel Glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '18bccb3d-7738-4293-9b14-382c18519504', 'R1120', 'Creamy pumpkin soup', 'Creamy pumpkin soup', 'Creamy pumpkin soup', NULL,
      'BOWL', 'BOWL', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '517ae792-021a-41ea-8f91-9e437317aa20', 'R1123', 'Lobster salad with mango, avocado, and passion fruit dressing', 'Lobster salad with mango, avocado, and passion fruit dressing', 'Lobster salad with mango, avocado, and passion fruit dressing', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '4e55274d-dc43-4b34-9c29-329616724d9a', 'R2143', 'AUS beef tenderloin with green peppercorn sauce and mashed potatoes', 'AUS beef tenderloin with green peppercorn sauce and mashed potatoes', 'AUS beef tenderloin with green peppercorn sauce and mashed potatoes', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '80a47806-8241-4d73-b2fb-284b8c35e748', 'R2146', 'Burgundy-style beef stew with red wine, organic noodles and mushrooms', 'Burgundy-style beef stew with red wine, organic noodles and mushrooms', 'Burgundy-style beef stew with red wine, organic noodles and mushrooms', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '63d9ea26-1199-4a97-8062-95d5a5002248', 'R2147', 'Chicken à la Provençale with mashed potatoes', 'Chicken à la Provençale with mashed potatoes', 'Chicken à la Provençale with mashed potatoes', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0ba2d161-69dd-4709-96c9-1b40e0e6968e', 'R2151', 'Roast Iberico pork tenderloin with apple Calvados sauce and sweet potatoes', 'Roast Iberico pork tenderloin with apple Calvados sauce and sweet potatoes', 'Roast Iberico pork tenderloin with apple Calvados sauce and sweet potatoes', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'abf755cd-aa43-43a4-ae89-f22d0ba839f0', 'R8001', 'Oven-baked stuffed eggplant with lentils and ratatoui le (Vegetarian)', 'Oven-baked stuffed eggplant with lentils and ratatoui le (Vegetarian)', 'Oven-baked stuffed eggplant with lentils and ratatoui le (Vegetarian)', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'e337dff6-cad4-4778-8c20-348f48324eae', 'R8002', 'Grilled vegetable Napoleon with red pepper coulis (Vegetarian)', 'Grilled vegetable Napoleon with red pepper coulis (Vegetarian)', 'Grilled vegetable Napoleon with red pepper coulis (Vegetarian)', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '699b8886-b1c6-4135-838d-eea5a9819954', 'R5115', 'Caramelized apple tart and vanilla ice cream', 'Caramelized apple tart and vanilla ice cream', 'Caramelized apple tart and vanilla ice cream', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'cd4677e4-b75c-4022-9ab2-824fcb3b049f', 'R5116', 'Cream puffs with vani la ice cream and chocolate sauce', 'Cream puffs with vani la ice cream and chocolate sauce', 'Cream puffs with vani la ice cream and chocolate sauce', NULL,
      'PLATE', 'PLATE', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'cc525fc1-9e5d-40f7-9dda-3425d1e24c46', 'R6178', 'Set Menu Three Courses 1+3+4 A', 'Set Menu Three Courses 1+3+4 A', 'Set Menu Three Courses 1+3+4 A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '643221f0-b10c-490c-a75f-0c87f99ccb23', 'R6179', 'Set Menu Three Courses 1+3+4 B', 'Set Menu Three Courses 1+3+4 B', 'Set Menu Three Courses 1+3+4 B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '0ca2e059-313f-4995-bfaf-5b4dfe6ecd7e', 'R6180', 'Set Menu Three Courses 1+3+4 C', 'Set Menu Three Courses 1+3+4 C', 'Set Menu Three Courses 1+3+4 C', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'aafaf7e7-3431-4bdb-95ae-a90b896ecd90', 'R6181', 'Set Menu Three Courses 1+3+4 D', 'Set Menu Three Courses 1+3+4 D', 'Set Menu Three Courses 1+3+4 D', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ef0babb0-5d3a-4147-84c6-388603c3d570', 'R6182', 'Set Menu Three Courses 1+3+4 E', 'Set Menu Three Courses 1+3+4 E', 'Set Menu Three Courses 1+3+4 E', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '06b9850e-279c-446f-ba3a-293ef23a1cb9', 'R6183', 'Set Menu Three Courses 2+3+4 A', 'Set Menu Three Courses 2+3+4 A', 'Set Menu Three Courses 2+3+4 A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '9d533afc-4c70-46dd-9ec9-a392664d32d8', 'R6184', 'Set Menu Three Courses 2+3+4 B', 'Set Menu Three Courses 2+3+4 B', 'Set Menu Three Courses 2+3+4 B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b5645fb9-eaa0-4b51-b20e-d78e6c680077', 'R6185', 'Set Menu Three Courses 2+3+4 C', 'Set Menu Three Courses 2+3+4 C', 'Set Menu Three Courses 2+3+4 C', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '41dfd01c-df00-4965-803c-1eea130c5b9d', 'R6186', 'Set Menu Three Courses 2+3+4 D', 'Set Menu Three Courses 2+3+4 D', 'Set Menu Three Courses 2+3+4 D', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '69c3a124-e27d-477e-adea-a28aed88df49', 'R6187', 'Set Menu Three Courses 2+3+4 E', 'Set Menu Three Courses 2+3+4 E', 'Set Menu Three Courses 2+3+4 E', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '2e29754d-d630-4ecd-807e-056752846747', 'R6188', 'Set Menu Four Courses A', 'Set Menu Four Courses A', 'Set Menu Four Courses A', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c8bb74e7-0cf9-4f5e-aef2-e4bf21b8744c', 'R6189', 'Set Menu Four Courses B', 'Set Menu Four Courses B', 'Set Menu Four Courses B', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1eeb6b1a-d516-4c40-8540-cf7fb390d728', 'R6190', 'Set Menu Four Courses C', 'Set Menu Four Courses C', 'Set Menu Four Courses C', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '13667219-cfdb-45c6-8ae1-0b0b801e4961', 'R6191', 'Set Menu Four Courses D', 'Set Menu Four Courses D', 'Set Menu Four Courses D', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '7f9af003-4422-49c9-82b6-e67f3b942783', 'R6192', 'Set Menu Four Courses E', 'Set Menu Four Courses E', 'Set Menu Four Courses E', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '754a651f-40f5-4baa-a6b6-f08d796a67fd', 'R609214', 'New Year Set Menu', 'New Year Set Menu', 'New Year Set Menu', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b327a01b-a30f-4836-91e6-d8cdca1813fe', 'R6208', 'Dégustation Set Menu 4 to 7 Courses-1', 'Dégustation Set Menu 4 to 7 Courses-1', 'Dégustation Set Menu 4 to 7 Courses-1', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a24522e8-2952-4b22-9679-aec3dbd953b1', 'R6209', 'Dégustation Set Menu 4 to 7 Courses-2', 'Dégustation Set Menu 4 to 7 Courses-2', 'Dégustation Set Menu 4 to 7 Courses-2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '16117fae-9b64-480e-aa72-c516d4f4b7b9', 'R6210', 'Dégustation Set Menu 4 to 7 Courses-3', 'Dégustation Set Menu 4 to 7 Courses-3', 'Dégustation Set Menu 4 to 7 Courses-3', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '1ac59314-8246-4ede-b5fc-7013871c5ec0', 'R6211', 'Dégustation Set Menu 4 to 7 Courses-4', 'Dégustation Set Menu 4 to 7 Courses-4', 'Dégustation Set Menu 4 to 7 Courses-4', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '3548da87-b712-4fd9-92a2-09ad482cd441', 'R6214', 'Dégustation Set Menu 4 to 7 Courses-7', 'Dégustation Set Menu 4 to 7 Courses-7', 'Dégustation Set Menu 4 to 7 Courses-7', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a15e6ff2-9074-44b7-9a04-bf721762adbf', 'R6215', 'Dégustation Set Menu 4 to 7 Courses-8', 'Dégustation Set Menu 4 to 7 Courses-8', 'Dégustation Set Menu 4 to 7 Courses-8', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '68da5199-5dbd-48fb-a6b7-1eb2d1daef1f', 'R6216', 'Dégustation Set Menu 4 to 7 Courses-9', 'Dégustation Set Menu 4 to 7 Courses-9', 'Dégustation Set Menu 4 to 7 Courses-9', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '611da7b3-d03c-49c1-895f-01047172a153', 'R6217', 'Dégustation Set Menu 4 to 7 Courses-10', 'Dégustation Set Menu 4 to 7 Courses-10', 'Dégustation Set Menu 4 to 7 Courses-10', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '22e04e5c-42f2-4911-954a-a1284a53bb90', 'R6219', 'Dégustation Set Menu 4 to 7 Courses-12', 'Dégustation Set Menu 4 to 7 Courses-12', 'Dégustation Set Menu 4 to 7 Courses-12', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '8fec3e06-56b5-4103-ab3b-c7daffd4b5b5', 'R6220', 'Set Menu Two Courses 1+2', 'Set Menu Two Courses 1+2', 'Set Menu Two Courses 1+2', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '60a4548f-e962-47aa-b2f6-7bb243a7f1a5', 'R6221', 'Set Menu Two Courses 1+3 F', 'Set Menu Two Courses 1+3 F', 'Set Menu Two Courses 1+3 F', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '86acaf10-3af2-4db0-bcbe-94dad8548410', 'R6222', 'Set Menu Two Courses 1+3 G', 'Set Menu Two Courses 1+3 G', 'Set Menu Two Courses 1+3 G', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '379ea3d3-1d19-47b4-89cb-8a0bf48976ec', 'R6223', 'Set Menu Two Courses 3+4 F', 'Set Menu Two Courses 3+4 F', 'Set Menu Two Courses 3+4 F', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '50fededc-fb88-4727-ad82-daa4e02a274a', 'R6224', 'Set Menu Two Courses 3+4 G', 'Set Menu Two Courses 3+4 G', 'Set Menu Two Courses 3+4 G', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '44853784-5d4d-4903-9aab-fe637cbcbac4', 'R6225', 'Set Menu Three Courses 1+2+3 F', 'Set Menu Three Courses 1+2+3 F', 'Set Menu Three Courses 1+2+3 F', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '560253e3-6dbe-4655-be74-2db2deeb8ea8', 'R6226', 'Set Menu Three Courses 1+2+3 G', 'Set Menu Three Courses 1+2+3 G', 'Set Menu Three Courses 1+2+3 G', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '74ee0ed7-34e0-45a4-9d9d-5420d317a87c', 'R6227', 'Set Menu Three Courses 1+3+4 F', 'Set Menu Three Courses 1+3+4 F', 'Set Menu Three Courses 1+3+4 F', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '6188649e-514d-4651-8ddc-54007e10d4db', 'R6228', 'Set Menu Three Courses 1+3+4 G', 'Set Menu Three Courses 1+3+4 G', 'Set Menu Three Courses 1+3+4 G', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '033aa680-f36e-4067-8d8d-74b77ce21175', 'R6229', 'Set Menu Three Courses 2+3+4 F', 'Set Menu Three Courses 2+3+4 F', 'Set Menu Three Courses 2+3+4 F', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b5dc9250-10b8-4436-b9dd-5ed5317ccf95', 'R6230', 'Set Menu Three Courses 2+3+4 G', 'Set Menu Three Courses 2+3+4 G', 'Set Menu Three Courses 2+3+4 G', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '46b11775-69b9-43b9-a314-8cbd7c1971b9', 'R6231', 'Set Menu Four Courses F', 'Set Menu Four Courses F', 'Set Menu Four Courses F', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ec7d3d20-1171-461b-bc92-bff52ff3db4d', 'R6232', 'Set Menu Four Courses G', 'Set Menu Four Courses G', 'Set Menu Four Courses G', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'c0448490-b85b-490f-a8e6-08d9182f8084', 'R6233', 'Set Menu Two Courses 2+3 F', 'Set Menu Two Courses 2+3 F', 'Set Menu Two Courses 2+3 F', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd2334933-e985-4afa-9677-04016b7faf31', 'R6234', 'Set Menu Two Courses 2+3 G', 'Set Menu Two Courses 2+3 G', 'Set Menu Two Courses 2+3 G', NULL,
      'PAX', 'PAX', 1, 0,
      5.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, false,
      false, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '34b55cbb-08b7-44e2-bfa8-0ddf43b334b8', 'V2014', 'trống', 'trống', 'trống', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'a08cc101-a114-4de8-ae66-9d26daef9704', 'V2017', 'Pitars Prosecco DOC Extra Dry (Glera · Grave del Friuli DOC — Italy) - Sparkling', 'Pitars Prosecco DOC Extra Dry (Glera · Grave del Friuli DOC — Italy) - Sparkling', 'Pitars Prosecco DOC Extra Dry (Glera · Grave del Friuli DOC — Italy) - Sparkling', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'be02b56c-ef11-4bc2-ad7f-caa138a1447f', 'V9413', 'Dufouleur Père & Fils Pinot Noir Rosé (Vin de France — France)', 'Dufouleur Père & Fils Pinot Noir Rosé (Vin de France — France)', 'Dufouleur Père & Fils Pinot Noir Rosé (Vin de France — France)', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'BOTTLE', 'BOTTLE', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ccc82ab1-426c-4b14-875b-115f51000926', 'M7026', 'Sunset Citrus Cooler', 'Sunset Citrus Cooler', 'Sunset Citrus Cooler', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'd16604b3-89c7-487a-a5a7-3ccf279d8eae', 'M7027', 'Watermelon Cooler', 'Watermelon Cooler', 'Watermelon Cooler', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'fa1b1c28-ac91-454e-b979-6f7fca670c87', 'M7029', 'Pineapple Cooler', 'Pineapple Cooler', 'Pineapple Cooler', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '54abaaa8-2800-4776-bc59-0f70e18358cf', 'M9115', 'Cremaschi Furlotti Chardonnay Chile- Glass', 'Cremaschi Furlotti Chardonnay Chile- Glass', 'Cremaschi Furlotti Chardonnay Chile- Glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '8a64bbc6-2540-4561-860e-67ef68795932', 'M9116', 'Cremaschi Furlotti Sauvignon Blanc Chile-Glass', 'Cremaschi Furlotti Sauvignon Blanc Chile-Glass', 'Cremaschi Furlotti Sauvignon Blanc Chile-Glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'ab56a9b6-2f8f-4028-a5a1-7f2531340492', 'M9117', 'Cremaschi Furlotti Cabernet Sauvignon Chile- Glass', 'Cremaschi Furlotti Cabernet Sauvignon Chile- Glass', 'Cremaschi Furlotti Cabernet Sauvignon Chile- Glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '56418173-1bfb-4e6b-9dc5-e6de19da71df', 'M9118', 'Château Baratet Sauvignon Blanc France Glass', 'Château Baratet Sauvignon Blanc France Glass', 'Château Baratet Sauvignon Blanc France Glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      '644776da-221d-47e4-8dfb-436b2249dbcd', 'M9119', 'Château Baratet Cabernet Sauvignon France Glass', 'Château Baratet Cabernet Sauvignon France Glass', 'Château Baratet Cabernet Sauvignon France Glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;
INSERT INTO ingredients (
      id, code, nom_fr, ten_vi, name_en, purchase_category_id, 
      stock_uom, recipe_uom, stock_to_recipe_factor, tare_weight_grams, 
      tolerance_percent, wac_price, standard_price, yield_rate, 
      min_stock, max_stock, safety_stock, is_import, track_lot, 
      is_beverage, auto_po_group, is_active
    ) VALUES (
      'b2805b6d-e4bc-4889-a4bb-fbb5dc268a62', 'M9120', 'Pitars Prosecco DOC Extra Dry “Sparkling” - Italy Glass', 'Pitars Prosecco DOC Extra Dry “Sparkling” - Italy Glass', 'Pitars Prosecco DOC Extra Dry “Sparkling” - Italy Glass', '5b0ee48b-8e19-5d8f-853a-4056cefff5e5',
      'GLASS', 'GLASS', 1, 450,
      2.0, 0.0, 0.0, 100.0,
      0.0, 0.0, 0.0, false, true,
      true, 'MANUAL_REQUISITION', true
    ) ON CONFLICT (code) DO NOTHING;

-- 2. INSERT NEW MENU ITEMS & RECIPES
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('B5003', 'Halida,  33cl', 35000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('B5003', (SELECT id FROM ingredients WHERE code = 'B5003' LIMIT 1), 1, 100.0, 'CAN')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('B5006', 'Pilsner - 33cl', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('B5006', (SELECT id FROM ingredients WHERE code = 'B5006' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('B5013', 'Carlsberg draught', 40000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('B5013', (SELECT id FROM ingredients WHERE code = 'B5013' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('B5008', 'Sapporo — bottle 33cl', 45000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('B5008', (SELECT id FROM ingredients WHERE code = 'B5008' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M1001', 'Campari Glass', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M1001', (SELECT id FROM ingredients WHERE code = 'M1001' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M1002', 'Martini Rosso Glass', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M1002', (SELECT id FROM ingredients WHERE code = 'M1002' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M1003', 'Martini Bianco Glass', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M1003', (SELECT id FROM ingredients WHERE code = 'M1003' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M1004', 'Martini Dry Glass', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M1004', (SELECT id FROM ingredients WHERE code = 'M1004' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M1005', 'Ricard Glass', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M1005', (SELECT id FROM ingredients WHERE code = 'M1005' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M1006', 'Porto Glass', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M1006', (SELECT id FROM ingredients WHERE code = 'M1006' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M1007', 'Kir Glass', 130000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M1007', (SELECT id FROM ingredients WHERE code = 'M1007' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M2001', 'Cointreau', 100000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M2001', (SELECT id FROM ingredients WHERE code = 'M2001' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M2002', 'Baileys', 100000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M2002', (SELECT id FROM ingredients WHERE code = 'M2002' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M2003', 'Grand Marnier', 100000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M2003', (SELECT id FROM ingredients WHERE code = 'M2003' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M3001', 'Gordons Gin Glass', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M3001', (SELECT id FROM ingredients WHERE code = 'M3001' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M3002', 'Russian Vodka Glass', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M3002', (SELECT id FROM ingredients WHERE code = 'M3002' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M3003', 'Johnnie walker red label  glass', 110000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M3003', (SELECT id FROM ingredients WHERE code = 'M3003' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M3004', 'Johnnie walker black label glass', 110000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M3004', (SELECT id FROM ingredients WHERE code = 'M3004' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M3005', 'Chivas regal glass', 110000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M3005', (SELECT id FROM ingredients WHERE code = 'M3005' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M3006', 'J & B rare glass', 100000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M3006', (SELECT id FROM ingredients WHERE code = 'M3006' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M4001', 'Bacardi white', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M4001', (SELECT id FROM ingredients WHERE code = 'M4001' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M5001', 'Hennessy V.S.O.P Glass', 160000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M5001', (SELECT id FROM ingredients WHERE code = 'M5001' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M5002', 'Remy martin V.S.O.P', 160000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M5002', (SELECT id FROM ingredients WHERE code = 'M5002' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M5003', 'Hennessy X.O Glass', 220000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M5003', (SELECT id FROM ingredients WHERE code = 'M5003' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M5004', 'Framboise', 220000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M5004', (SELECT id FROM ingredients WHERE code = 'M5004' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M5005', 'Prune', 220000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M5005', (SELECT id FROM ingredients WHERE code = 'M5005' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M5006', 'Poire William Glass', 220000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M5006', (SELECT id FROM ingredients WHERE code = 'M5006' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M6007', 'La Vie 0,5L', 20000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M6007', (SELECT id FROM ingredients WHERE code = 'M6007' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M7004', 'Lemon Milk', 80000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M7004', (SELECT id FROM ingredients WHERE code = 'M7004' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M8003', 'Campari & orange juice', 150000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M8003', (SELECT id FROM ingredients WHERE code = 'M8003' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M8004', 'Campari & soda', 150000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M8004', (SELECT id FROM ingredients WHERE code = 'M8004' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9007', 'Vietnamese tea', 25000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9007', (SELECT id FROM ingredients WHERE code = 'M9007' LIMIT 1), 1, 100.0, 'CUP')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9103', 'Red wine glass  CHILE - Luis Felipe', 160000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9103', (SELECT id FROM ingredients WHERE code = 'M9103' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9105', 'Sparkling wine glass', 255000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9105', (SELECT id FROM ingredients WHERE code = 'M9105' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9201', 'Cigarettes Local', 50000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9201', (SELECT id FROM ingredients WHERE code = 'M9201' LIMIT 1), 1, 100.0, 'PACK')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9401', 'Amaretto', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9401', (SELECT id FROM ingredients WHERE code = 'M9401' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9404', 'Cinzano Dry', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9404', (SELECT id FROM ingredients WHERE code = 'M9404' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9412', 'Port Cockburns', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9412', (SELECT id FROM ingredients WHERE code = 'M9412' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9501', 'Absolut 0.7L', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9501', (SELECT id FROM ingredients WHERE code = 'M9501' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9502', 'Absolut 1L', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9502', (SELECT id FROM ingredients WHERE code = 'M9502' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9503', 'Beluga', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9503', (SELECT id FROM ingredients WHERE code = 'M9503' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9504', 'Black vodka', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9504', (SELECT id FROM ingredients WHERE code = 'M9504' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9505', 'Lua moi 300ml', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9505', (SELECT id FROM ingredients WHERE code = 'M9505' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9506', 'Lua moi 750ml', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9506', (SELECT id FROM ingredients WHERE code = 'M9506' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9509', 'Nep moi 700ml', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9509', (SELECT id FROM ingredients WHERE code = 'M9509' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9510', 'Putinka', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9510', (SELECT id FROM ingredients WHERE code = 'M9510' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9511', 'Russian Vodka Red Label', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9511', (SELECT id FROM ingredients WHERE code = 'M9511' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9601', 'Ballantines', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9601', (SELECT id FROM ingredients WHERE code = 'M9601' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9605', 'Ballentines 30', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9605', (SELECT id FROM ingredients WHERE code = 'M9605' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9607', 'Chivas 18 years old', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9607', (SELECT id FROM ingredients WHERE code = 'M9607' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9608', 'Chivas Regal 0.37', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9608', (SELECT id FROM ingredients WHERE code = 'M9608' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9610', 'Chivas regal 21 years old', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9610', (SELECT id FROM ingredients WHERE code = 'M9610' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9613', 'Gin bombay', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9613', (SELECT id FROM ingredients WHERE code = 'M9613' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9614', 'Glenfidich', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9614', (SELECT id FROM ingredients WHERE code = 'M9614' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9615', 'Glenfidich 15 years old', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9615', (SELECT id FROM ingredients WHERE code = 'M9615' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9616', 'Glenfidich 18 years old', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9616', (SELECT id FROM ingredients WHERE code = 'M9616' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9617', 'Glenlivert 18', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9617', (SELECT id FROM ingredients WHERE code = 'M9617' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9618', 'Grants', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9618', (SELECT id FROM ingredients WHERE code = 'M9618' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9619', 'Havana club', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9619', (SELECT id FROM ingredients WHERE code = 'M9619' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9622', 'Jameson', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9622', (SELECT id FROM ingredients WHERE code = 'M9622' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9624', 'Johnie Gold label', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9624', (SELECT id FROM ingredients WHERE code = 'M9624' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9625', 'Johnnie Green Label', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9625', (SELECT id FROM ingredients WHERE code = 'M9625' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9626', 'Johnnie Walker X.R 21 years', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9626', (SELECT id FROM ingredients WHERE code = 'M9626' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9627', 'Johnny Walker Black label', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9627', (SELECT id FROM ingredients WHERE code = 'M9627' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9628', 'Johnny Walker Blue label', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9628', (SELECT id FROM ingredients WHERE code = 'M9628' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9630', 'Johnny Walker Double Black 1L', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9630', (SELECT id FROM ingredients WHERE code = 'M9630' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9631', 'Macallan 18year', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9631', (SELECT id FROM ingredients WHERE code = 'M9631' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9633', 'Platinum label', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9633', (SELECT id FROM ingredients WHERE code = 'M9633' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9701', 'Bacardi Gold', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9701', (SELECT id FROM ingredients WHERE code = 'M9701' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9703', 'Tequila Gold', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9703', (SELECT id FROM ingredients WHERE code = 'M9703' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9704', 'Tequila Green label white', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9704', (SELECT id FROM ingredients WHERE code = 'M9704' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9807', 'Hennessy VSOP 0.37', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9807', (SELECT id FROM ingredients WHERE code = 'M9807' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9810', 'Martell VSOP', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9810', (SELECT id FROM ingredients WHERE code = 'M9810' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9811', 'Matell XO', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9811', (SELECT id FROM ingredients WHERE code = 'M9811' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9813', 'Remy Martin XO', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9813', (SELECT id FROM ingredients WHERE code = 'M9813' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1101', 'Chef''s salad', 160000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1101', (SELECT id FROM ingredients WHERE code = 'R1101' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1102', 'Nicoise salad with anchovies', 110000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1102', (SELECT id FROM ingredients WHERE code = 'R1102' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1103', 'Garden vegetables with nuts, orange balsamic dressing', 130000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1103', (SELECT id FROM ingredients WHERE code = 'R1103' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1104', 'Chicken caesar salad', 130000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1104', (SELECT id FROM ingredients WHERE code = 'R1104' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1105', 'Tuna cappaccio with quail egg and sesame oil', 190000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1105', (SELECT id FROM ingredients WHERE code = 'R1105' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1106', 'Smoke salmon cucumber black pearl cream', 250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1106', (SELECT id FROM ingredients WHERE code = 'R1106' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1107', 'Assorted ham, salami and terrine mustard Dijon', 360000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1107', (SELECT id FROM ingredients WHERE code = 'R1107' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1108', 'Foie gras salad with quail egg Serano ham', 390000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1108', (SELECT id FROM ingredients WHERE code = 'R1108' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1109', 'Lobster caesar salad', 490000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1109', (SELECT id FROM ingredients WHERE code = 'R1109' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1007', 'Seasonal vegetable soup', 50000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1007', (SELECT id FROM ingredients WHERE code = 'R1007' LIMIT 1), 1, 100.0, 'BOWL')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2101', 'SIGNATURE Vietnamese buffalo fillet 150gr', 330000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2101', (SELECT id FROM ingredients WHERE code = 'R2101' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2102', 'SIGNATURE Pork shank stew with Hanoi beer', 230000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2102', (SELECT id FROM ingredients WHERE code = 'R2102' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2103', 'Grilled US beef rib eyes 150 gram', 380000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2103', (SELECT id FROM ingredients WHERE code = 'R2103' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2104', 'Grilled US beef striploin 150 gram', 380000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2104', (SELECT id FROM ingredients WHERE code = 'R2104' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2105', 'Grilled US T-bone signature sauce 350gm', 690000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2105', (SELECT id FROM ingredients WHERE code = 'R2105' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2106', 'Grilled US beef tenderloin 150 gram', 490000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2106', (SELECT id FROM ingredients WHERE code = 'R2106' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2107', 'Australian Wagyu rib eyes steak MBS 9+ 150gm', 1250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2107', (SELECT id FROM ingredients WHERE code = 'R2107' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2108', 'Grilled US topblade 180 gram', 300000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2108', (SELECT id FROM ingredients WHERE code = 'R2108' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2109', 'US Short rib boneless Prime Black Angus', 580000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2109', (SELECT id FROM ingredients WHERE code = 'R2109' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2110', 'Vietnamese beef fillet signature sauce 150gm', 200000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2110', (SELECT id FROM ingredients WHERE code = 'R2110' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2111', 'Slow cooked US beef short ribs', 590000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2111', (SELECT id FROM ingredients WHERE code = 'R2111' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2112', 'Burgundy beef stew mashed potatoes', 280000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2112', (SELECT id FROM ingredients WHERE code = 'R2112' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2113', 'Veal fillet with wild mushroom cream', 390000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2113', (SELECT id FROM ingredients WHERE code = 'R2113' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3101', 'Basa fish fillet with dill butter sauce', 190000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3101', (SELECT id FROM ingredients WHERE code = 'R3101' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3102', 'Sea bass Bouilabaisse style', 300000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3102', (SELECT id FROM ingredients WHERE code = 'R3102' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3103', 'Pan-fried salmon fillet dry fig sauce', 330000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3103', (SELECT id FROM ingredients WHERE code = 'R3103' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3104', 'Tuna Rossini with foie foie gras porto wine sauce', 490000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3104', (SELECT id FROM ingredients WHERE code = 'R3104' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3105', 'Steamed cod fish fillet bisque sauce', 590000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3105', (SELECT id FROM ingredients WHERE code = 'R3105' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R4001', 'Pasta with sauce Bolognaise', 210000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R4001', (SELECT id FROM ingredients WHERE code = 'R4001' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R4002', 'Pasta with sauce Carbonara', 210000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R4002', (SELECT id FROM ingredients WHERE code = 'R4002' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R4003', 'Pasta with Grogonzola chesse sauce', 210000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R4003', (SELECT id FROM ingredients WHERE code = 'R4003' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R4004', 'Pasta with smoked salmon', 295000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R4004', (SELECT id FROM ingredients WHERE code = 'R4004' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R4005', 'Pasta with tomatoes and shrimps', 230000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R4005', (SELECT id FROM ingredients WHERE code = 'R4005' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R4006', 'Pasta with vegetable (vegetarian)', 180000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R4006', (SELECT id FROM ingredients WHERE code = 'R4006' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R4007', 'Couscous stuffed peppers (vegetarian)', 190000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R4007', (SELECT id FROM ingredients WHERE code = 'R4007' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5101', 'Chocolate lava cake coffee whipped cream', 150000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5101', (SELECT id FROM ingredients WHERE code = 'R5101' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5102', 'Apple flower fine tart cinnamon ice cream', 150000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5102', (SELECT id FROM ingredients WHERE code = 'R5102' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5003', 'Crepes Suzette flambeed Grand Marnier', 120000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5003', (SELECT id FROM ingredients WHERE code = 'R5003' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5004', 'Profiteroles with vanilla ice cream and hot chocolate sauce', 150000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5004', (SELECT id FROM ingredients WHERE code = 'R5004' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5104', 'Ice Drop 3 scoops of ice cream', 135000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5104', (SELECT id FROM ingredients WHERE code = 'R5104' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6260001', 'Set Menu 370A', 370000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6260001', (SELECT id FROM ingredients WHERE code = 'R6260001' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6260002', 'Set Menu 370B', 370000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6260002', (SELECT id FROM ingredients WHERE code = 'R6260002' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6260003', 'Set Menu 370C', 370000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6260003', (SELECT id FROM ingredients WHERE code = 'R6260003' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6260004', 'Set Menu 470A', 470000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6260004', (SELECT id FROM ingredients WHERE code = 'R6260004' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6260005', 'Set Menu 470B', 470000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6260005', (SELECT id FROM ingredients WHERE code = 'R6260005' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6260006', 'Set Menu 470C', 470000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6260006', (SELECT id FROM ingredients WHERE code = 'R6260006' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6260007', 'Set Menu 600A', 600000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6260007', (SELECT id FROM ingredients WHERE code = 'R6260007' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6260008', 'Set Menu 600B', 600000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6260008', (SELECT id FROM ingredients WHERE code = 'R6260008' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6260009', 'Set Menu 770A', 770000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6260009', (SELECT id FROM ingredients WHERE code = 'R6260009' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6260010', 'Set Menu 770B', 770000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6260010', (SELECT id FROM ingredients WHERE code = 'R6260010' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6260011', 'Set Menu 970A', 970000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6260011', (SELECT id FROM ingredients WHERE code = 'R6260011' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6260012', 'Set Menu 1250', 1250000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6260012', (SELECT id FROM ingredients WHERE code = 'R6260012' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6260013', 'Set Menu 1550', 1550000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6260013', (SELECT id FROM ingredients WHERE code = 'R6260013' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6260014', 'Set Menu 1800', 1800000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6260014', (SELECT id FROM ingredients WHERE code = 'R6260014' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6260015', 'Set Menu 2000', 2000000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6260015', (SELECT id FROM ingredients WHERE code = 'R6260015' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6001', 'Set Lunch1', 250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6001', (SELECT id FROM ingredients WHERE code = 'R6001' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6040', 'Set Lunch2', 250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6040', (SELECT id FROM ingredients WHERE code = 'R6040' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6041', 'Set Lunch3', 250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6041', (SELECT id FROM ingredients WHERE code = 'R6041' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6042', 'Set Lunch4', 250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6042', (SELECT id FROM ingredients WHERE code = 'R6042' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6043', 'Set Lunch5', 250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6043', (SELECT id FROM ingredients WHERE code = 'R6043' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6044', 'Set Lunch6', 250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6044', (SELECT id FROM ingredients WHERE code = 'R6044' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6045', 'Set Lunch7', 250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6045', (SELECT id FROM ingredients WHERE code = 'R6045' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6069', 'Set lunch8', 250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6069', (SELECT id FROM ingredients WHERE code = 'R6069' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6046', 'Set Lunch9', 250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6046', (SELECT id FROM ingredients WHERE code = 'R6046' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6047', 'Set lunch10', 250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6047', (SELECT id FROM ingredients WHERE code = 'R6047' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V1002', 'Penfolds Koonunga Hill Chardonnay 37.5cl (W)', 750000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V1002', (SELECT id FROM ingredients WHERE code = 'V1002' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V1003', 'Penfolds Koonunga Hill Shiraz Cabernet Sauvignon 37.5cl (R)', 750000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V1003', (SELECT id FROM ingredients WHERE code = 'V1003' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V2001', 'Pierre Larousse Blanc De Blancs Brut 37.5cl, France', 595000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V2001', (SELECT id FROM ingredients WHERE code = 'V2001' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V2003', 'Champagne Brut 37.5cl Grande Reserve Brut, Baron Fuente, France', 1480000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V2003', (SELECT id FROM ingredients WHERE code = 'V2003' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V2004', 'Champagne Jacques Picard, France', 1990000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V2004', (SELECT id FROM ingredients WHERE code = 'V2004' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V2005', 'Champagne Brut 75cl Baron Fuente Rose Dolores, France', 1995000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V2005', (SELECT id FROM ingredients WHERE code = 'V2005' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V3001', 'Late Harvest Sauvignon Blanc 37.5cl, Chile', 1335000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V3001', (SELECT id FROM ingredients WHERE code = 'V3001' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4001', 'Les Pierres Boissy Syrah Merlot - House wine', 430000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4001', (SELECT id FROM ingredients WHERE code = 'V4001' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4002', 'CHÂTEAU BAUVALLON (Red)', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4002', (SELECT id FROM ingredients WHERE code = 'V4002' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4003', 'La Croix Bacalan Merlot (R)', 690000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4003', (SELECT id FROM ingredients WHERE code = 'V4003' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4004', 'Château de Villenouvette Reserve', 1095000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4004', (SELECT id FROM ingredients WHERE code = 'V4004' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4005', 'Georges Duboeuf Pinot Noir', 990000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4005', (SELECT id FROM ingredients WHERE code = 'V4005' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4006', 'Collection Privée Rouge (Merlot, Cabernet Sauvignon) _ Bordeaux', 1055000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4006', (SELECT id FROM ingredients WHERE code = 'V4006' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4026', 'Georges Duboeuf Macon Villages', 728000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4026', (SELECT id FROM ingredients WHERE code = 'V4026' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4010', 'DOURTHE N.1 ROUGE', 1190000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4010', (SELECT id FROM ingredients WHERE code = 'V4010' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4011', 'FAMILLE PERRIN Reserve', 1190000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4011', (SELECT id FROM ingredients WHERE code = 'V4011' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4012', 'BOUCHARD PERE ET FILS Bourgogne Pinot Noir «La Vigné»', 1190000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4012', (SELECT id FROM ingredients WHERE code = 'V4012' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4013', 'Clarendelle rouge – Inspired by Haut Brion', 1895000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4013', (SELECT id FROM ingredients WHERE code = 'V4013' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4015', 'Madiran Château de Crouseilles', 1138000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4015', (SELECT id FROM ingredients WHERE code = 'V4015' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4016', 'Les Hauts de La Gaffeliere, Saint Emilion', 1590000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4016', (SELECT id FROM ingredients WHERE code = 'V4016' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4018', 'Château De Malengin, Baron E. De Rothschild', 1390000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4018', (SELECT id FROM ingredients WHERE code = 'V4018' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4019', 'Croix de Carbonnieux Red (by Château Carbonnieux) (Grand Cru Classé)  (red)', 1588000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4019', (SELECT id FROM ingredients WHERE code = 'V4019' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4020', 'Le Haut Medoc de Giscours (by Château Giscours) (Grand Cru Classé)', 1680000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4020', (SELECT id FROM ingredients WHERE code = 'V4020' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4021', '2010 CHÂTEAU VIEUX LARTIGUE « Grand Crus»', 1688000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4021', (SELECT id FROM ingredients WHERE code = 'V4021' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4022', '2010 CHÂTEAU LA MISSION', 1988000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4022', (SELECT id FROM ingredients WHERE code = 'V4022' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4023', 'Le Médoc de Cos (by Château Cos d’Estournel Grand Cru Classé)', 2990000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4023', (SELECT id FROM ingredients WHERE code = 'V4023' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4024', 'Domaine De Saint-Guirons by Château Grand Puy Lacoste (Grand Cru Classé)', 2690000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4024', (SELECT id FROM ingredients WHERE code = 'V4024' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4025', 'CLUB ELITE, Château Tour Massac, Margaux', 2880000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4025', (SELECT id FROM ingredients WHERE code = 'V4025' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5001', 'Les Pierres Boissy Chardonnay  - House wine', 430000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5001', (SELECT id FROM ingredients WHERE code = 'V5001' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5002', 'La Croix Bacalan Semillon Sauvignon', 690000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5002', (SELECT id FROM ingredients WHERE code = 'V5002' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5003', 'Collection Privée Blanc (Sauvignon Blanc) _ Bordeaux', 1055000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5003', (SELECT id FROM ingredients WHERE code = 'V5003' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5005', 'Bourgogne Aligote, Louis Jadot', 848000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5005', (SELECT id FROM ingredients WHERE code = 'V5005' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5006', 'DOURTHE N.1 BLANC', 1190000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5006', (SELECT id FROM ingredients WHERE code = 'V5006' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5007', 'Clarendelle Blanc – Inspired by Haut Brion', 1390000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5007', (SELECT id FROM ingredients WHERE code = 'V5007' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5008', 'Gustave Lorentz Riesling', 1450000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5008', (SELECT id FROM ingredients WHERE code = 'V5008' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5009', 'WILLIAM FEVRE Petit Chablis', 1390000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5009', (SELECT id FROM ingredients WHERE code = 'V5009' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5010', 'Trimbach, Gewurztraminer', 1590000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5010', (SELECT id FROM ingredients WHERE code = 'V5010' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5011', 'BOUCHARD PERE ET FILS Pouilly Fuisse', 1790000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5011', (SELECT id FROM ingredients WHERE code = 'V5011' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5012', 'Pouilly Fuisse, Domaine J.A. Ferret', 1690000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5012', (SELECT id FROM ingredients WHERE code = 'V5012' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6001', 'ECHEVERRÍA Valle Dorado Sauvignon Blanc (White)', 418000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6001', (SELECT id FROM ingredients WHERE code = 'V6001' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6002', 'ECHEVERRÍA Valle Dorado Cabernet Sauvignon (red)', 418000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6002', (SELECT id FROM ingredients WHERE code = 'V6002' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6003', 'Baron Philippe de Rothschild Mapu Reserva Merlot (Red)', 538000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6003', (SELECT id FROM ingredients WHERE code = 'V6003' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6004', 'Baron Philippe de Rothschild Mapu Chardonay (White)', 538000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6004', (SELECT id FROM ingredients WHERE code = 'V6004' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6005', 'Santa Digna, Gewurztraminer (White)', 895000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6005', (SELECT id FROM ingredients WHERE code = 'V6005' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6006', 'Santa Digna, Cabernet Sauvignon (Red)', 895000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6006', (SELECT id FROM ingredients WHERE code = 'V6006' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6007', 'Casillero Del Diablo Reserva Privada Sauvignon Blanc, Concha Y Toro (White)', 995000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6007', (SELECT id FROM ingredients WHERE code = 'V6007' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6008', 'Casillero Del Diablo Reserva Privada Cabernet Syrah, Concha Y Toro (Red)', 995000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6008', (SELECT id FROM ingredients WHERE code = 'V6008' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6009', 'Cordillera Reserva Privada Shiraz Blend, Miguel Torres (Red)', 1290000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6009', (SELECT id FROM ingredients WHERE code = 'V6009' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6010', 'Cordillera, Carménère, Curico, Miguel Torres (Red)', 1290000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6010', (SELECT id FROM ingredients WHERE code = 'V6010' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6011', 'Château Los Boldos Grand Cru (Red)', 2680000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6011', (SELECT id FROM ingredients WHERE code = 'V6011' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V7001', 'Bonacosta, Masi (Corvina, Rondinella and Molinara) (Red)', 1295000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V7001', (SELECT id FROM ingredients WHERE code = 'V7001' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V7002', 'Chianti Placido Primavera Selection (bordolese bottle) (Red)', 690000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V7002', (SELECT id FROM ingredients WHERE code = 'V7002' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V7004', 'Passo', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V7004', (SELECT id FROM ingredients WHERE code = 'V7004' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V8001', 'Fleur du Cap Chardonnay (White)', 1295000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V8001', (SELECT id FROM ingredients WHERE code = 'V8001' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V8002', 'Fleur Du Cap Cabernet Sauvignon (Red)', 1295000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V8002', (SELECT id FROM ingredients WHERE code = 'V8002' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9001', 'Tribu Chardonnay (White)', 478000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9001', (SELECT id FROM ingredients WHERE code = 'V9001' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9002', 'Tribu Pinot Noir (Red)', 478000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9002', (SELECT id FROM ingredients WHERE code = 'V9002' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9101', 'Bin 65 Chardonnay, Lindemans (White)', 890000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9101', (SELECT id FROM ingredients WHERE code = 'V9101' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9102', 'Bin 40 Merlot, Lindemans (Red)', 890000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9102', (SELECT id FROM ingredients WHERE code = 'V9102' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9401', 'Les Domaines Barsalou Grenache Gris Rose, France', 448000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9401', (SELECT id FROM ingredients WHERE code = 'V9401' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9403', 'Château Aumedes Corbières Rosé, France', 790000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9403', (SELECT id FROM ingredients WHERE code = 'V9403' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9404', 'Tavel Guigal, Rose, France', 1258000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9404', (SELECT id FROM ingredients WHERE code = 'V9404' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('000', 'Open Menu Food', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('000', (SELECT id FROM ingredients WHERE code = '000' LIMIT 1), 1, 100.0, 'PIECE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NLC1006', 'Top Side', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NLC1006', (SELECT id FROM ingredients WHERE code = 'NLC1006' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NLC3001', 'Foie gras Frozen', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NLC3001', (SELECT id FROM ingredients WHERE code = 'NLC3001' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NLP6001', 'Nguyên liệu chế biến ( ko nhập)', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NLP6001', (SELECT id FROM ingredients WHERE code = 'NLP6001' LIMIT 1), 1, 100.0, 'PIECE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NLP6002', 'Nguyên liệu chế biến bếp', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NLP6002', (SELECT id FROM ingredients WHERE code = 'NLP6002' LIMIT 1), 1, 100.0, 'PIECE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NLP6003', 'Nguyên liệu chế biến bar', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NLP6003', (SELECT id FROM ingredients WHERE code = 'NLP6003' LIMIT 1), 1, 100.0, 'PIECE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6002', 'Set Dinner1', 498000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6002', (SELECT id FROM ingredients WHERE code = 'R6002' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M6013', 'Vital (Sparking Water 0.5L)', 30000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M6013', (SELECT id FROM ingredients WHERE code = 'M6013' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6050', 'Set Dinner2', 498000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6050', (SELECT id FROM ingredients WHERE code = 'R6050' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5013', 'CHÂTEAU BAUVALLON (White)', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5013', (SELECT id FROM ingredients WHERE code = 'V5013' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V2007', 'Cuvee Jean-Louis Brut', 528000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V2007', (SELECT id FROM ingredients WHERE code = 'V2007' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6012', 'PAVO REAL Cabernet Sauvignon (Reserva)', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6012', (SELECT id FROM ingredients WHERE code = 'V6012' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6014', 'PAVO REAL Cabernet Sauvignon - Carmenere (GR)', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6014', (SELECT id FROM ingredients WHERE code = 'V6014' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6015', 'PAVO REAL Sauvignon Blanc (Reserva)', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6015', (SELECT id FROM ingredients WHERE code = 'V6015' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6016', 'PAVO REAL Sauvignon Blanc (Variietals)', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6016', (SELECT id FROM ingredients WHERE code = 'V6016' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4027', 'Balmontée Bordeaux - Red', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4027', (SELECT id FROM ingredients WHERE code = 'V4027' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4028', 'Balmontée Bordeaux Superior - Red', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4028', (SELECT id FROM ingredients WHERE code = 'V4028' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V2008', 'Torley - Rosé (Sparking)', 690000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V2008', (SELECT id FROM ingredients WHERE code = 'V2008' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6017', 'PAVO REAL Cabernet Sauvignon (Varietals)', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6017', (SELECT id FROM ingredients WHERE code = 'V6017' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9515', 'Skyy 90 vodka', 1293000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9515', (SELECT id FROM ingredients WHERE code = 'M9515' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9516', 'Skyy vodka Thuong', 455000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9516', (SELECT id FROM ingredients WHERE code = 'M9516' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4029', 'Chateauneauf du-pape', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4029', (SELECT id FROM ingredients WHERE code = 'V4029' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5014', 'CHÂTEAU LARY (White)', 458000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5014', (SELECT id FROM ingredients WHERE code = 'V5014' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6051', 'Set Dinner3', 498000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6051', (SELECT id FROM ingredients WHERE code = 'R6051' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6052', 'Set Dinner4', 498000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6052', (SELECT id FROM ingredients WHERE code = 'R6052' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6053', 'Set Dinner5', 498000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6053', (SELECT id FROM ingredients WHERE code = 'R6053' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6054', 'Set Dinner6', 450000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6054', (SELECT id FROM ingredients WHERE code = 'R6054' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6055', 'Set Dinner7', 498000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6055', (SELECT id FROM ingredients WHERE code = 'R6055' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6056', 'Set Dinner8', 498000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6056', (SELECT id FROM ingredients WHERE code = 'R6056' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9637', 'Appleton White 40%', 415000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9637', (SELECT id FROM ingredients WHERE code = 'M9637' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6018', 'Montes Alpha Syrah', 2000000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6018', (SELECT id FROM ingredients WHERE code = 'V6018' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6019', 'Montes Alpha-M', 3290000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6019', (SELECT id FROM ingredients WHERE code = 'V6019' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6020', 'Wine of the Month (bottle)', 690000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6020', (SELECT id FROM ingredients WHERE code = 'V6020' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6021', 'Luis Felipe Gran Reserva Shiraz', 699000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6021', (SELECT id FROM ingredients WHERE code = 'V6021' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6022', 'Luis Felipe Gran Reserva Chardonnay', 699000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6022', (SELECT id FROM ingredients WHERE code = 'V6022' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4030', 'Château de Villenouvette Cuvee Marcel', 1095000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4030', (SELECT id FROM ingredients WHERE code = 'V4030' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2115', 'Roasted lamb rack with rosemary 3 chops', 460000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2115', (SELECT id FROM ingredients WHERE code = 'R2115' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6057', 'Set Dinner9', 498000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6057', (SELECT id FROM ingredients WHERE code = 'R6057' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6058', 'Set dinner10', 498000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6058', (SELECT id FROM ingredients WHERE code = 'R6058' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6059', 'Set dinner11', 498000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6059', (SELECT id FROM ingredients WHERE code = 'R6059' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6023', 'Rios Chie Red', 595000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6023', (SELECT id FROM ingredients WHERE code = 'V6023' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9405', 'Luis Pinel Cinsault Rose', 490000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9405', (SELECT id FROM ingredients WHERE code = 'V9405' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6072', 'Set Dinner12', 498000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6072', (SELECT id FROM ingredients WHERE code = 'R6072' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6073', 'Set Dinner13', 498000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6073', (SELECT id FROM ingredients WHERE code = 'R6073' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6084', 'Set dinner14', 498000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6084', (SELECT id FROM ingredients WHERE code = 'R6084' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6093', 'Set dinner15', 498000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6093', (SELECT id FROM ingredients WHERE code = 'R6093' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9108', 'Wine of the month glass', 148000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9108', (SELECT id FROM ingredients WHERE code = 'M9108' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1009', 'Mussels soup', 190000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1009', (SELECT id FROM ingredients WHERE code = 'R1009' LIMIT 1), 1, 100.0, 'BOWL')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6024', 'La Capitana Cabernet Merlot', 895000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6024', (SELECT id FROM ingredients WHERE code = 'V6024' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4031', 'Clos Saint Vincent Saint-Emilion Grand Cru', 1215000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4031', (SELECT id FROM ingredients WHERE code = 'V4031' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4032', 'Chateau Brane Cantenac 2009 - Margeaux Grand Cru Classe', 5600000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4032', (SELECT id FROM ingredients WHERE code = 'V4032' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4033', 'Chateau Dauzac  - Beaudaux, Cabernet Sauvignon-Merlot', 2900000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4033', (SELECT id FROM ingredients WHERE code = 'V4033' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5015', 'Châtteau de MeurSault - Bourgone - Chardonay', 990000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5015', (SELECT id FROM ingredients WHERE code = 'V5015' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V2010', 'Delafinca Carta Blance Sparkling Wine', 790000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V2010', (SELECT id FROM ingredients WHERE code = 'V2010' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V2011', 'BOTTEGA Fragolino Sparkling', 790000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V2011', (SELECT id FROM ingredients WHERE code = 'V2011' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6025', 'Marques De Casa Concha Shiraz, CYT, CHILE', 1465000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6025', (SELECT id FROM ingredients WHERE code = 'V6025' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2116', 'Braised lamb shank in Cassoulet bean', 450000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2116', (SELECT id FROM ingredients WHERE code = 'R2116' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V1004', 'Chile Evolucion Cabernet Sauvignon 37.5cl (red)', 250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V1004', (SELECT id FROM ingredients WHERE code = 'V1004' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V1005', 'Chile Evolucion Sauvignon Blanc 37.5cl (White)', 250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V1005', (SELECT id FROM ingredients WHERE code = 'V1005' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1013', 'Mixed garden salad', 110000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1013', (SELECT id FROM ingredients WHERE code = 'R1013' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1014', 'Cold cut platter 2 Pers', 199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1014', (SELECT id FROM ingredients WHERE code = 'R1014' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1015', 'Cold cut platter 3 Pers', 289000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1015', (SELECT id FROM ingredients WHERE code = 'R1015' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1016', 'Cold cut platter 4 Pers', 339000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1016', (SELECT id FROM ingredients WHERE code = 'R1016' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1029', 'Assorted Ham, Salami with Cheese and Pate', 450000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1029', (SELECT id FROM ingredients WHERE code = 'R1029' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1017', 'Cucumber and Tomaoes 2 Pers', 89000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1017', (SELECT id FROM ingredients WHERE code = 'R1017' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3106', 'Pan seared Scallops wild mushrooms Royale', 660000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3106', (SELECT id FROM ingredients WHERE code = 'R3106' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2117', 'Roast duck fillet orange sauce and seasonal creation', 250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2117', (SELECT id FROM ingredients WHERE code = 'R2117' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2118', 'Fired duck confit thyme sauce', 250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2118', (SELECT id FROM ingredients WHERE code = 'R2118' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2119', 'Roasted chicken fillet tarragon juice', 200000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2119', (SELECT id FROM ingredients WHERE code = 'R2119' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9638', 'WAKABA  - Sake 15 - bottle 350 ml', 270000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9638', (SELECT id FROM ingredients WHERE code = 'M9638' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9640', 'KOME HAJIME  - Shochu 25% - bottle 500 ml', 450000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9640', (SELECT id FROM ingredients WHERE code = 'M9640' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9641', 'MUGI HAJIME - Shochu 25% - bottle 500 ml', 565000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9641', (SELECT id FROM ingredients WHERE code = 'M9641' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9639', 'ETSUNO HAJIME - Sake 15% - bottle 300 ml', 450000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9639', (SELECT id FROM ingredients WHERE code = 'M9639' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('B5011', 'Truc Bach Beer', 45000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('B5011', (SELECT id FROM ingredients WHERE code = 'B5011' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC1001', 'Beef Tenderloin', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC1001', (SELECT id FROM ingredients WHERE code = 'NVLC1001' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC1002', 'Rib eye (US)', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC1002', (SELECT id FROM ingredients WHERE code = 'NVLC1002' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC1003', 'Rib eye ( AUS)', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC1003', (SELECT id FROM ingredients WHERE code = 'NVLC1003' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC1004', 'Rib eye (Newzeland)', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC1004', (SELECT id FROM ingredients WHERE code = 'NVLC1004' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC1005', 'Top Side', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC1005', (SELECT id FROM ingredients WHERE code = 'NVLC1005' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC1010', 'T bone', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC1010', (SELECT id FROM ingredients WHERE code = 'NVLC1010' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC1011', 'Top Blade', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC1011', (SELECT id FROM ingredients WHERE code = 'NVLC1011' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC1012', 'Short rib', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC1012', (SELECT id FROM ingredients WHERE code = 'NVLC1012' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC1013', 'Top Sirloin', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC1013', (SELECT id FROM ingredients WHERE code = 'NVLC1013' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC1014', 'Hanging tender', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC1014', (SELECT id FROM ingredients WHERE code = 'NVLC1014' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC1015', 'Local beef', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC1015', (SELECT id FROM ingredients WHERE code = 'NVLC1015' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC1016', 'Chuck roll US', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC1016', (SELECT id FROM ingredients WHERE code = 'NVLC1016' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC1017', 'Chuck tender', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC1017', (SELECT id FROM ingredients WHERE code = 'NVLC1017' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC2001', 'Lamb rack', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC2001', (SELECT id FROM ingredients WHERE code = 'NVLC2001' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC2002', 'Lamb shank', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC2002', (SELECT id FROM ingredients WHERE code = 'NVLC2002' LIMIT 1), 1, 100.0, 'PIECE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC2003', 'Lamb leg', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC2003', (SELECT id FROM ingredients WHERE code = 'NVLC2003' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC2004', 'Lamb tenderloin', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC2004', (SELECT id FROM ingredients WHERE code = 'NVLC2004' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC3001', 'Pork shoulder', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC3001', (SELECT id FROM ingredients WHERE code = 'NVLC3001' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC3002', 'Pork loin', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC3002', (SELECT id FROM ingredients WHERE code = 'NVLC3002' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC3003', 'Pork belly', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC3003', (SELECT id FROM ingredients WHERE code = 'NVLC3003' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC4001', 'Duck leg', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC4001', (SELECT id FROM ingredients WHERE code = 'NVLC4001' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC4002', 'Duck breast', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC4002', (SELECT id FROM ingredients WHERE code = 'NVLC4002' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC4010', 'Chicken leg', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC4010', (SELECT id FROM ingredients WHERE code = 'NVLC4010' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC4011', 'Chicken breast', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC4011', (SELECT id FROM ingredients WHERE code = 'NVLC4011' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC5001', 'Salmon fillet', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC5001', (SELECT id FROM ingredients WHERE code = 'NVLC5001' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC5002', 'Salmon whole', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC5002', (SELECT id FROM ingredients WHERE code = 'NVLC5002' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC5005', 'Sea bass fillet', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC5005', (SELECT id FROM ingredients WHERE code = 'NVLC5005' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC5006', 'Sea bass whole', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC5006', (SELECT id FROM ingredients WHERE code = 'NVLC5006' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC5010', 'Tilapia fillet', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC5010', (SELECT id FROM ingredients WHERE code = 'NVLC5010' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC5015', 'Ca Tra fillet', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC5015', (SELECT id FROM ingredients WHERE code = 'NVLC5015' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC5016', 'Ca Tra whole', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC5016', (SELECT id FROM ingredients WHERE code = 'NVLC5016' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC5017', 'Basa fillet', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC5017', (SELECT id FROM ingredients WHERE code = 'NVLC5017' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC5020', 'Cod fish', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC5020', (SELECT id FROM ingredients WHERE code = 'NVLC5020' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC5021', 'Lang Fish', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC5021', (SELECT id FROM ingredients WHERE code = 'NVLC5021' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC5025', 'Gouper', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC5025', (SELECT id FROM ingredients WHERE code = 'NVLC5025' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC6001', 'Lobster', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC6001', (SELECT id FROM ingredients WHERE code = 'NVLC6001' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC6002', 'Scallope', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC6002', (SELECT id FROM ingredients WHERE code = 'NVLC6002' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC6003', 'Fresh Musells', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC6003', (SELECT id FROM ingredients WHERE code = 'NVLC6003' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC6004', 'Frog leg', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC6004', (SELECT id FROM ingredients WHERE code = 'NVLC6004' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC6005', 'Prawn', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC6005', (SELECT id FROM ingredients WHERE code = 'NVLC6005' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC6006', 'Mussell Meat', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC6006', (SELECT id FROM ingredients WHERE code = 'NVLC6006' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC6007', 'Escargot', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC6007', (SELECT id FROM ingredients WHERE code = 'NVLC6007' LIMIT 1), 1, 100.0, 'PIECE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC6010', 'Rabit', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC6010', (SELECT id FROM ingredients WHERE code = 'NVLC6010' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC6015', 'Turkey Whole', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC6015', (SELECT id FROM ingredients WHERE code = 'NVLC6015' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC7001', 'Veal Tenderloin', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC7001', (SELECT id FROM ingredients WHERE code = 'NVLC7001' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('B5014', 'Sagota— Alcohol free beer 33cl', 40000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('B5014', (SELECT id FROM ingredients WHERE code = 'B5014' LIMIT 1), 1, 100.0, 'CAN')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V1006', 'Just VDP OC Merlot 37.5cl', 250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V1006', (SELECT id FROM ingredients WHERE code = 'V1006' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M5007', 'Mirabelle', 220000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M5007', (SELECT id FROM ingredients WHERE code = 'M5007' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4007', 'Georges Duboeuf Beaujolais Villages', 1090000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4007', (SELECT id FROM ingredients WHERE code = 'V4007' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC7002', 'Veal Sweet Breast', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC7002', (SELECT id FROM ingredients WHERE code = 'NVLC7002' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M3007', 'Ballentines Fineses glass', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M3007', (SELECT id FROM ingredients WHERE code = 'M3007' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5016', 'Sancerre Blance le Barones', 1030000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5016', (SELECT id FROM ingredients WHERE code = 'V5016' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9003', 'Tribu Malbec (Red)', 478000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9003', (SELECT id FROM ingredients WHERE code = 'V9003' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4034', 'Roc Saint Andre (Red)', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4034', (SELECT id FROM ingredients WHERE code = 'V4034' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4035', 'Georges Duboeuf Beaujolais Villages Nouveau (Fresh Wine)', 1090000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4035', (SELECT id FROM ingredients WHERE code = 'V4035' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9110', 'Beaujolais Nouveau wine glass', 250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9110', (SELECT id FROM ingredients WHERE code = 'M9110' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V7003', 'Masianco Supervenetian, Masi (Pinot Grigio, Verduzzo) (White)', 1355000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V7003', (SELECT id FROM ingredients WHERE code = 'V7003' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9503', 'Chateau Dalat Reserve Merlot 75cl', 650000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9503', (SELECT id FROM ingredients WHERE code = 'V9503' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9505', 'Chateau Dalat Special Chardonay 75cl', 650000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9505', (SELECT id FROM ingredients WHERE code = 'V9505' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9111', 'Jacques Picard glass', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9111', (SELECT id FROM ingredients WHERE code = 'M9111' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2120', 'Boneless chicken thighs stuffed with vegetables', 200000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2120', (SELECT id FROM ingredients WHERE code = 'R2120' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC10021', 'Beef steak fuji', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC10021', (SELECT id FROM ingredients WHERE code = 'NVLC10021' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5105', 'Chocolate sphere salted butter caramel sauce', 150000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5105', (SELECT id FROM ingredients WHERE code = 'R5105' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1018', 'Cucumber and Tomaoes 3 Pers', 109000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1018', (SELECT id FROM ingredients WHERE code = 'R1018' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1019', 'Cucumber and Tomaoes 4 Pers', 139000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1019', (SELECT id FROM ingredients WHERE code = 'R1019' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1020', 'French fries', 99000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1020', (SELECT id FROM ingredients WHERE code = 'R1020' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2121', 'Roasted pork fillet mignon cheese sauce', 200000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2121', (SELECT id FROM ingredients WHERE code = 'R2121' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('NVLC60021', 'Scallope (10)', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('NVLC60021', (SELECT id FROM ingredients WHERE code = 'NVLC60021' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5106', 'Mango ravioli with coconut pudding', 135000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5106', (SELECT id FROM ingredients WHERE code = 'R5106' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5006', 'Cheese platter with walnut bread', 360000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5006', (SELECT id FROM ingredients WHERE code = 'R5006' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M6012', 'Aquafina 0.5L', 22000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M6012', (SELECT id FROM ingredients WHERE code = 'M6012' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M3008', 'Creme de cassic glass', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M3008', (SELECT id FROM ingredients WHERE code = 'M3008' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6028', '1887 Cabernet Sauvignon', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6028', (SELECT id FROM ingredients WHERE code = 'V6028' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6029', '1887 Sauvignon Blanc', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6029', (SELECT id FROM ingredients WHERE code = 'V6029' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5107', 'Seasonal fresh fruit platter', 190000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5107', (SELECT id FROM ingredients WHERE code = 'R5107' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9506', 'Chateau Dalat Special Merlot 75cl', 650000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9506', (SELECT id FROM ingredients WHERE code = 'V9506' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9507', 'Chateau Dalat Tradition Chardonay 75cl', 650000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9507', (SELECT id FROM ingredients WHERE code = 'V9507' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6094', 'Deluxe set menu1', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6094', (SELECT id FROM ingredients WHERE code = 'R6094' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6095', 'Deluxe set menu2', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6095', (SELECT id FROM ingredients WHERE code = 'R6095' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6096', 'Deluxe set menu3', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6096', (SELECT id FROM ingredients WHERE code = 'R6096' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9112', 'Rose wine glass - CHILE', 150000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9112', (SELECT id FROM ingredients WHERE code = 'M9112' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6097', 'Deluxe set menu4', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6097', (SELECT id FROM ingredients WHERE code = 'R6097' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6098', 'Deluxe set menu5', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6098', (SELECT id FROM ingredients WHERE code = 'R6098' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6099', 'Deluxe set menu6', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6099', (SELECT id FROM ingredients WHERE code = 'R6099' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6100', 'Deluxe set menu7', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6100', (SELECT id FROM ingredients WHERE code = 'R6100' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6101', 'Deluxe set menu8', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6101', (SELECT id FROM ingredients WHERE code = 'R6101' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6102', 'Deluxe set menu9', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6102', (SELECT id FROM ingredients WHERE code = 'R6102' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M3009', 'Vodka Hanoi glass', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M3009', (SELECT id FROM ingredients WHERE code = 'M3009' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6103', 'Deluxe set menu10', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6103', (SELECT id FROM ingredients WHERE code = 'R6103' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6104', 'Deluxe set menu11', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6104', (SELECT id FROM ingredients WHERE code = 'R6104' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6105', 'Deluxe set menu12', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6105', (SELECT id FROM ingredients WHERE code = 'R6105' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6106', 'Deluxe set menu13', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6106', (SELECT id FROM ingredients WHERE code = 'R6106' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6107', 'Deluxe set menu14', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6107', (SELECT id FROM ingredients WHERE code = 'R6107' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6108', 'Deluxe set menu15', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6108', (SELECT id FROM ingredients WHERE code = 'R6108' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6109', 'Deluxe set menu16', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6109', (SELECT id FROM ingredients WHERE code = 'R6109' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6110', 'Deluxe set menu17', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6110', (SELECT id FROM ingredients WHERE code = 'R6110' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6111', 'Deluxe set menu18', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6111', (SELECT id FROM ingredients WHERE code = 'R6111' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6112', 'Deluxe set menu19', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6112', (SELECT id FROM ingredients WHERE code = 'R6112' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6113', 'Deluxe set menu20', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6113', (SELECT id FROM ingredients WHERE code = 'R6113' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6114', 'Deluxe set menu21', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6114', (SELECT id FROM ingredients WHERE code = 'R6114' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6115', 'Deluxe set menu22', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6115', (SELECT id FROM ingredients WHERE code = 'R6115' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6116', 'Deluxe set menu23', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6116', (SELECT id FROM ingredients WHERE code = 'R6116' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6117', 'Deluxe set menu24', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6117', (SELECT id FROM ingredients WHERE code = 'R6117' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6118', 'Deluxe set menu25', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6118', (SELECT id FROM ingredients WHERE code = 'R6118' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6119', 'Deluxe set menu26', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6119', (SELECT id FROM ingredients WHERE code = 'R6119' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6120', 'Deluxe set menu27', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6120', (SELECT id FROM ingredients WHERE code = 'R6120' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6121', 'Deluxe set menu28', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6121', (SELECT id FROM ingredients WHERE code = 'R6121' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6128', 'Deluxe set menu29', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6128', (SELECT id FROM ingredients WHERE code = 'R6128' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6129', 'Deluxe set menu30', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6129', (SELECT id FROM ingredients WHERE code = 'R6129' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V1007', 'Vistana Cabernet Sauvignon Merlot 3.75cl', 390000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V1007', (SELECT id FROM ingredients WHERE code = 'V1007' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6130', 'Deluxe set menu31', 1199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6130', (SELECT id FROM ingredients WHERE code = 'R6130' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M3010', 'Lua moi glass', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M3010', (SELECT id FROM ingredients WHERE code = 'M3010' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6200', 'US Steak Combo', 390000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6200', (SELECT id FROM ingredients WHERE code = 'R6200' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6201', 'Pork Cuttles Combo', 250000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6201', (SELECT id FROM ingredients WHERE code = 'R6201' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V2012', 'Montparnasse Brut Vin Mousseux, France', 790000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V2012', (SELECT id FROM ingredients WHERE code = 'V2012' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6202', 'Dong Tao Chicken Feet Combo', 220000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6202', (SELECT id FROM ingredients WHERE code = 'R6202' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6203', 'Duck Breast Combo', 250000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6203', (SELECT id FROM ingredients WHERE code = 'R6203' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6204', 'Salmon Combo', 390000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6204', (SELECT id FROM ingredients WHERE code = 'R6204' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6205', 'Lamb Stew Combo', 370000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6205', (SELECT id FROM ingredients WHERE code = 'R6205' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6206', 'Chicken Breast Combo', 250000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6206', (SELECT id FROM ingredients WHERE code = 'R6206' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6207', 'Pork Tenderloin Combo', 250000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6207', (SELECT id FROM ingredients WHERE code = 'R6207' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4036', 'Légende Bordeaux Rouge 75cl (Red)', 1190000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4036', (SELECT id FROM ingredients WHERE code = 'V4036' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4037', 'Légende Saint-Émilion 75cl (Red)', 1790000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4037', (SELECT id FROM ingredients WHERE code = 'V4037' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4040', 'Chateau Belle Vue, Haut-Médoc- Bordeaux 75cl (Red)', 2490000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4040', (SELECT id FROM ingredients WHERE code = 'V4040' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5019', 'Légende Bordeaux Blanc 750ml (White)', 1190000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5019', (SELECT id FROM ingredients WHERE code = 'V5019' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6032', 'Sunrise Cabernet Sauvignon, Concha Y Toro 75cl (Red)', 690000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6032', (SELECT id FROM ingredients WHERE code = 'V6032' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6033', 'Sunrise Chardonay, Concha Y Toro (White)', 690000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6033', (SELECT id FROM ingredients WHERE code = 'V6033' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V3008', 'Montes Late Harvest Gewyztraminer 37.5cl', 1335000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V3008', (SELECT id FROM ingredients WHERE code = 'V3008' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6030', 'Santa Rita Reserva Cabernet Sauvignon 75cl (Red)', 890000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6030', (SELECT id FROM ingredients WHERE code = 'V6030' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6031', 'Santa Rita Reserva sauvignon Blanc 75cl (White)', 890000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6031', (SELECT id FROM ingredients WHERE code = 'V6031' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5018', 'Muscadet Sevre et Maine sur Lie- D&F 75cl (White)', 790000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5018', (SELECT id FROM ingredients WHERE code = 'V5018' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5020', 'Chateau La Rose Bellevue Cuvee Tradition 75cl (White)', 1290000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5020', (SELECT id FROM ingredients WHERE code = 'V5020' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V7005', 'Carpineto Chianti Classico Riserva DOCG, Sangiovese- Canaiolo (Red)', 1690000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V7005', (SELECT id FROM ingredients WHERE code = 'V7005' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V7006', 'Carpineto Farnito, Chardonay- Toscana IGT (White)', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V7006', (SELECT id FROM ingredients WHERE code = 'V7006' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4038', 'Chateau Puy Razac Grand Cru Merlot- Cabernet 75cl', 1990000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4038', (SELECT id FROM ingredients WHERE code = 'V4038' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4039', 'Les Hauts De Lynch Moussac - Haut Medoc 75cl (Red)', 2090000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4039', (SELECT id FROM ingredients WHERE code = 'V4039' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M7011', 'Apple juice box', 75000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M7011', (SELECT id FROM ingredients WHERE code = 'M7011' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('B5009', 'Bitburger - Germany - bottle 33cl', 65000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('B5009', (SELECT id FROM ingredients WHERE code = 'B5009' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6087', 'Sandwich Set Menu', 270000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6087', (SELECT id FROM ingredients WHERE code = 'R6087' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4041', 'Chateau  Rocher Calon, Montagne Saint Emilion - Red', 1375000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4041', (SELECT id FROM ingredients WHERE code = 'V4041' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4042', 'Chateau Chantemerle Cru Bourgeois - Red', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4042', (SELECT id FROM ingredients WHERE code = 'V4042' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6036', 'Novas Gran Reserva Cabernet Sauvignon Organic Wine', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6036', (SELECT id FROM ingredients WHERE code = 'V6036' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6037', 'Novas Gran Reserva Sauvignon Blanc Organic Wine', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6037', (SELECT id FROM ingredients WHERE code = 'V6037' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2001', 'Roasted chicken breast', 200000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2001', (SELECT id FROM ingredients WHERE code = 'R2001' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6033', 'Set Menu 10 A', 350000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6033', (SELECT id FROM ingredients WHERE code = 'R6033' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M6011', 'Vitel (Sparking Water 0.5L)', 56000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M6011', (SELECT id FROM ingredients WHERE code = 'M6011' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M7013', 'Whisky sour', 150000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M7013', (SELECT id FROM ingredients WHERE code = 'M7013' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M7014', 'Long Island Iced Tea', 150000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M7014', (SELECT id FROM ingredients WHERE code = 'M7014' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M7016', 'Tequila Sunrise', 150000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M7016', (SELECT id FROM ingredients WHERE code = 'M7016' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M7017', 'Daiquiri', 150000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M7017', (SELECT id FROM ingredients WHERE code = 'M7017' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1021', 'Olive Platter', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1021', (SELECT id FROM ingredients WHERE code = 'R1021' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1022', 'Mixed Olive Platter', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1022', (SELECT id FROM ingredients WHERE code = 'R1022' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1023', 'Soup bouillabaisse rouille garlic baguette', 150000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1023', (SELECT id FROM ingredients WHERE code = 'R1023' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1026', 'Frogs legs parsley cream and garlic puree', 220000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1026', (SELECT id FROM ingredients WHERE code = 'R1026' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1027', 'Pan fried king prawn lobster sauce coriander', 430000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1027', (SELECT id FROM ingredients WHERE code = 'R1027' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R4008', 'Risotto with mushrooms and onions (vegetarian)', 190000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R4008', (SELECT id FROM ingredients WHERE code = 'R4008' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5011', 'Ice cream (1 scoop)', 48000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5011', (SELECT id FROM ingredients WHERE code = 'R5011' LIMIT 1), 1, 100.0, 'CUP')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5012', 'Ice cream (2 scoops)', 78000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5012', (SELECT id FROM ingredients WHERE code = 'R5012' LIMIT 1), 1, 100.0, 'CUP')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9814', 'Prune', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9814', (SELECT id FROM ingredients WHERE code = 'M9814' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9815', 'Ch Breuil Fine Calvados 70cl', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9815', (SELECT id FROM ingredients WHERE code = 'M9815' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M7019', 'Tom Collins', 150000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M7019', (SELECT id FROM ingredients WHERE code = 'M7019' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1028', 'Pan fried duck foie gras with red fruits sauce 80gm', 480000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1028', (SELECT id FROM ingredients WHERE code = 'R1028' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1001', 'Confit gizzards and duck breast salad', 118000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1001', (SELECT id FROM ingredients WHERE code = 'R1001' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1002', 'Beef Carpaccio with basil', 189000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1002', (SELECT id FROM ingredients WHERE code = 'R1002' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1003', 'Warm goat cheese salad and Parma ham', 238000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1003', (SELECT id FROM ingredients WHERE code = 'R1003' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1004', 'Blinis with smoked salmon', 238000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1004', (SELECT id FROM ingredients WHERE code = 'R1004' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1005', 'Goose liver terrine', 390000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1005', (SELECT id FROM ingredients WHERE code = 'R1005' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1006', 'Pan fried foie gras escalope', 486000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1006', (SELECT id FROM ingredients WHERE code = 'R1006' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1010', 'Egg blown wild mushroom cream', 168000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1010', (SELECT id FROM ingredients WHERE code = 'R1010' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1011', 'Burgundy snails (six pcs)', 178000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1011', (SELECT id FROM ingredients WHERE code = 'R1011' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2002', 'Roasted duck breast with green olives sauce', 218000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2002', (SELECT id FROM ingredients WHERE code = 'R2002' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2003', 'Fried duck-leg, calamansi sauce', 318000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2003', (SELECT id FROM ingredients WHERE code = 'R2003' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2004', 'Grilled beef rib eye bordelaise sauce', 309000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2004', (SELECT id FROM ingredients WHERE code = 'R2004' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2005', 'Roasted Australian beef tenderloin', 438000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2005', (SELECT id FROM ingredients WHERE code = 'R2005' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2006', 'American Hanging tender', 389000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2006', (SELECT id FROM ingredients WHERE code = 'R2006' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2007', 'Grilled T-bone steak besarnaise sauce', 468000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2007', (SELECT id FROM ingredients WHERE code = 'R2007' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2008', 'Lamb shank confit with sweet spices', 428000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2008', (SELECT id FROM ingredients WHERE code = 'R2008' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2009', 'Grilled cutlet with Provence''s herbs', 428000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2009', (SELECT id FROM ingredients WHERE code = 'R2009' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2010', 'Veal tenderloin in apple cider', 399000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2010', (SELECT id FROM ingredients WHERE code = 'R2010' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2011', 'Sauteed pork tenderloin with gouda cheese sauce', 189000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2011', (SELECT id FROM ingredients WHERE code = 'R2011' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2012', 'Local beef fillet with Provencal herbs', 199000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2012', (SELECT id FROM ingredients WHERE code = 'R2012' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2013', 'Chopped beef fillet served with salad and frites', 338000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2013', (SELECT id FROM ingredients WHERE code = 'R2013' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2014', 'Food of the month', 589000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2014', (SELECT id FROM ingredients WHERE code = 'R2014' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2015', 'American Ribeye Steak 200gram', 638000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2015', (SELECT id FROM ingredients WHERE code = 'R2015' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2016', 'American Ribeye Steak 250gram', 738000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2016', (SELECT id FROM ingredients WHERE code = 'R2016' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2017', 'American Ribeye Steak 300gram', 878000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2017', (SELECT id FROM ingredients WHERE code = 'R2017' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2018', 'American KOBE Ribeye Steak 250 gram', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2018', (SELECT id FROM ingredients WHERE code = 'R2018' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2019', 'American beef steak', 550000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2019', (SELECT id FROM ingredients WHERE code = 'R2019' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2020', 'Grilled top blade steak', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2020', (SELECT id FROM ingredients WHERE code = 'R2020' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2021', 'Buffalo fillet with spicy sauce', 280000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2021', (SELECT id FROM ingredients WHERE code = 'R2021' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3107', 'Pan-fried langouste rock lobster', 1190000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3107', (SELECT id FROM ingredients WHERE code = 'R3107' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3001', 'Pan seared Scallops wild mushrooms "Royale"', 568000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3001', (SELECT id FROM ingredients WHERE code = 'R3001' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3002', 'Prawns flambéed with Pastis', 399000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3002', (SELECT id FROM ingredients WHERE code = 'R3002' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3003', 'Tilapia fillet breaded with sesame', 219000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3003', (SELECT id FROM ingredients WHERE code = 'R3003' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3004', 'Roasted Sea bass crusted chorizo', 299000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3004', (SELECT id FROM ingredients WHERE code = 'R3004' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3005', 'Pan seared Norwegian salmon', 289000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3005', (SELECT id FROM ingredients WHERE code = 'R3005' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3006', 'Black Cod Fish', 699000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3006', (SELECT id FROM ingredients WHERE code = 'R3006' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5001', 'Haft-cooked dark chocolate cake', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5001', (SELECT id FROM ingredients WHERE code = 'R5001' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5002', '"Vacherin" ice cream mint and chocolate', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5002', (SELECT id FROM ingredients WHERE code = 'R5002' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5005', 'Fine apple tart, cinnamon ice cream', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5005', (SELECT id FROM ingredients WHERE code = 'R5005' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5007', 'Fresh Fruit Platter', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5007', (SELECT id FROM ingredients WHERE code = 'R5007' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5008', 'Ice cream (1 scoop)', 48000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5008', (SELECT id FROM ingredients WHERE code = 'R5008' LIMIT 1), 1, 100.0, 'CUP')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5009', 'Ice cream (2 scoops)', 78000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5009', (SELECT id FROM ingredients WHERE code = 'R5009' LIMIT 1), 1, 100.0, 'CUP')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5010', 'Chocolate balls', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5010', (SELECT id FROM ingredients WHERE code = 'R5010' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M5008', 'Armagnac', 220000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M5008', (SELECT id FROM ingredients WHERE code = 'M5008' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M8005', 'Whisky & coke', 150000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M8005', (SELECT id FROM ingredients WHERE code = 'M8005' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4043', 'Aurore De Dauzac 750- Red', 2795000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4043', (SELECT id FROM ingredients WHERE code = 'V4043' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5021', 'Petit Chablis Pas Si Petit 75cl - White', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5021', (SELECT id FROM ingredients WHERE code = 'V5021' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1012', 'Breaded frog''s legs', 218000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1012', (SELECT id FROM ingredients WHERE code = 'R1012' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4044', 'Premiere Note Syrah 75cl', 490000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4044', (SELECT id FROM ingredients WHERE code = 'V4044' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5022', 'Premiere Note Marsanne 75cl (White)', 490000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5022', (SELECT id FROM ingredients WHERE code = 'V5022' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6034', 'Set Menu 10B', 350000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6034', (SELECT id FROM ingredients WHERE code = 'R6034' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6035', 'Set Menu 10C', 350000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6035', (SELECT id FROM ingredients WHERE code = 'R6035' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6028', 'Set Menu 11A', 430000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6028', (SELECT id FROM ingredients WHERE code = 'R6028' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6029', 'Set Menu 11B', 550000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6029', (SELECT id FROM ingredients WHERE code = 'R6029' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6036', 'Set menu 11C', 247500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6036', (SELECT id FROM ingredients WHERE code = 'R6036' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6003', 'Set Menu 320760', 320760.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6003', (SELECT id FROM ingredients WHERE code = 'R6003' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6004', 'Set Menu 320760', 320760.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6004', (SELECT id FROM ingredients WHERE code = 'R6004' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6005', 'Set Menu 12B1', 270000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6005', (SELECT id FROM ingredients WHERE code = 'R6005' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6006', 'Set Menu 12B2', 270000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6006', (SELECT id FROM ingredients WHERE code = 'R6006' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6060', 'Set menu 12C1', 270000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6060', (SELECT id FROM ingredients WHERE code = 'R6060' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6030', 'Set Menu 13A', 292500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6030', (SELECT id FROM ingredients WHERE code = 'R6030' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6031', 'Set Menu 13B', 292500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6031', (SELECT id FROM ingredients WHERE code = 'R6031' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6032', 'Set Menu 13C', 292500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6032', (SELECT id FROM ingredients WHERE code = 'R6032' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6067', 'Set menu 13D', 292500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6067', (SELECT id FROM ingredients WHERE code = 'R6067' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6065', 'Set menu 14A1', 315000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6065', (SELECT id FROM ingredients WHERE code = 'R6065' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6066', 'Set menu 14A2', 315000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6066', (SELECT id FROM ingredients WHERE code = 'R6066' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6007', 'Set Menu 15A1', 352500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6007', (SELECT id FROM ingredients WHERE code = 'R6007' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5108', 'Birthday cake', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5108', (SELECT id FROM ingredients WHERE code = 'R5108' LIMIT 1), 1, 100.0, 'PIECE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1030', 'Salmon Sashimi', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1030', (SELECT id FROM ingredients WHERE code = 'R1030' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6008', 'Set Menu 15A2', 337500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6008', (SELECT id FROM ingredients WHERE code = 'R6008' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6009', 'Set Menu 15B1', 337500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6009', (SELECT id FROM ingredients WHERE code = 'R6009' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6010', 'Set Menu 15B2', 337500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6010', (SELECT id FROM ingredients WHERE code = 'R6010' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6061', 'Set menu 15C1', 337500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6061', (SELECT id FROM ingredients WHERE code = 'R6061' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6076', 'Set menu 15C2', 337500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6076', (SELECT id FROM ingredients WHERE code = 'R6076' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2122', 'Roasted Lamb Leg (Kg)', 990000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2122', (SELECT id FROM ingredients WHERE code = 'R2122' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6079', 'Set menu 15D1', 337500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6079', (SELECT id FROM ingredients WHERE code = 'R6079' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6085', 'Set menu 16.89A1', 380000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6085', (SELECT id FROM ingredients WHERE code = 'R6085' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6086', 'Set menu 16.89A2', 380000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6086', (SELECT id FROM ingredients WHERE code = 'R6086' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6011', 'Set Menu 18A1', 405000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6011', (SELECT id FROM ingredients WHERE code = 'R6011' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6012', 'Set Menu 18A2', 405000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6012', (SELECT id FROM ingredients WHERE code = 'R6012' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6013', 'Set Menu 18B1', 405000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6013', (SELECT id FROM ingredients WHERE code = 'R6013' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6014', 'Set Menu 18B2', 405000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6014', (SELECT id FROM ingredients WHERE code = 'R6014' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5023', 'Louis Latour - Bourgogne Chardonnay', 1100000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5023', (SELECT id FROM ingredients WHERE code = 'V5023' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6015', 'Set Menu 20A1', 470000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6015', (SELECT id FROM ingredients WHERE code = 'R6015' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6016', 'Set Menu 20A2', 450000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6016', (SELECT id FROM ingredients WHERE code = 'R6016' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6017', 'Set Menu 20B1', 450000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6017', (SELECT id FROM ingredients WHERE code = 'R6017' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M3011', 'Smirnoff red label glass', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M3011', (SELECT id FROM ingredients WHERE code = 'M3011' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6018', 'Set Menu 20B2', 450000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6018', (SELECT id FROM ingredients WHERE code = 'R6018' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6062', 'Set menu 20C1', 450000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6062', (SELECT id FROM ingredients WHERE code = 'R6062' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('B5015', 'Radbuz draught', 45000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('B5015', (SELECT id FROM ingredients WHERE code = 'B5015' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6077', 'Set menu 23A1', 517500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6077', (SELECT id FROM ingredients WHERE code = 'R6077' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6078', 'Set menu 23A2', 517500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6078', (SELECT id FROM ingredients WHERE code = 'R6078' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6122', 'Set menu 23B1', 517500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6122', (SELECT id FROM ingredients WHERE code = 'R6122' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6123', 'Set menu 23B2', 517500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6123', (SELECT id FROM ingredients WHERE code = 'R6123' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6124', 'Set menu 23B3', 517500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6124', (SELECT id FROM ingredients WHERE code = 'R6124' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6125', 'Set menu 23B4', 517500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6125', (SELECT id FROM ingredients WHERE code = 'R6125' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6126', 'Set Menu 24A1', 552000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6126', (SELECT id FROM ingredients WHERE code = 'R6126' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6127', 'Set Menu 24A2', 552000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6127', (SELECT id FROM ingredients WHERE code = 'R6127' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6019', 'Set Menu 25A1', 587500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6019', (SELECT id FROM ingredients WHERE code = 'R6019' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6020', 'Set Menu 25A2', 587500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6020', (SELECT id FROM ingredients WHERE code = 'R6020' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6074', 'Set menu 25A3', 562500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6074', (SELECT id FROM ingredients WHERE code = 'R6074' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2123', 'Roasted Beef Op Rib (kg)', 3250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2123', (SELECT id FROM ingredients WHERE code = 'R2123' LIMIT 1), 1, 100.0, 'PIECE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6021', 'Set Menu 30A1', 710000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6021', (SELECT id FROM ingredients WHERE code = 'R6021' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9407', 'Premiere note rose de syrah 75cl', 490000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9407', (SELECT id FROM ingredients WHERE code = 'V9407' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4046', 'Cotes Catalanes Domaine Rombeau Merlot - Red', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4046', (SELECT id FROM ingredients WHERE code = 'V4046' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4047', 'Domain Rombeau La Cave Secrete - Red', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4047', (SELECT id FROM ingredients WHERE code = 'V4047' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4048', 'Chateau Rombeau Elise Vieles Vignes 16% - Red', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4048', (SELECT id FROM ingredients WHERE code = 'V4048' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9103', 'Hamilton Island Shiraz (888)', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9103', (SELECT id FROM ingredients WHERE code = 'V9103' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9104', 'Hamilton Island Shiraz (389)', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9104', (SELECT id FROM ingredients WHERE code = 'V9104' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9105', 'Hamilton Island Cabernet Sauvignon (168)', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9105', (SELECT id FROM ingredients WHERE code = 'V9105' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V7007', 'Passimiento Baglio Gibellina (Red)', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V7007', (SELECT id FROM ingredients WHERE code = 'V7007' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6022', 'Set Menu 30A2', 710000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6022', (SELECT id FROM ingredients WHERE code = 'R6022' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6063', 'Set menu 30B1', 710000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6063', (SELECT id FROM ingredients WHERE code = 'R6063' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6064', 'Set menu 30B2', 710000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6064', (SELECT id FROM ingredients WHERE code = 'R6064' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6023', 'Set Menu 35A1', 822500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6023', (SELECT id FROM ingredients WHERE code = 'R6023' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R21031', 'Grilled US beef rib eyes 200 gram', 490000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R21031', (SELECT id FROM ingredients WHERE code = 'R21031' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R21032', 'Grilled US beef rib eyes 300 gram', 730000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R21032', (SELECT id FROM ingredients WHERE code = 'R21032' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R21033', 'Grilled US beef rib eyes 400 gram', 960000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R21033', (SELECT id FROM ingredients WHERE code = 'R21033' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R21041', 'Grilled US beef striploin 200 gram', 490000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R21041', (SELECT id FROM ingredients WHERE code = 'R21041' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R21042', 'Grilled US beef striploin 300 gram', 730000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R21042', (SELECT id FROM ingredients WHERE code = 'R21042' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R21043', 'Grilled US beef striploin 400 gram', 960000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R21043', (SELECT id FROM ingredients WHERE code = 'R21043' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R21061', 'Grilled US beef tenderloin 200 gram', 645000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R21061', (SELECT id FROM ingredients WHERE code = 'R21061' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R21062', 'Grilled US beef tenderloin 300 gram', 950000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R21062', (SELECT id FROM ingredients WHERE code = 'R21062' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R21081', 'Grilled US topblade 300 gram', 490000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R21081', (SELECT id FROM ingredients WHERE code = 'R21081' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R21082', 'Grilled US topblade 400 gram', 650000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R21082', (SELECT id FROM ingredients WHERE code = 'R21082' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R21021', 'Pigeon wellington foie gras red beetroot truffle jus', 490000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R21021', (SELECT id FROM ingredients WHERE code = 'R21021' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9601', 'Belle Ambiance Pinot Noir California', 890000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9601', (SELECT id FROM ingredients WHERE code = 'V9601' LIMIT 1), 1, 100.0, 'PIECE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9602', 'Belle Ambiance Pinot Grigio California', 890000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9602', (SELECT id FROM ingredients WHERE code = 'V9602' LIMIT 1), 1, 100.0, 'PIECE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4049', 'Chateau Badette, Pessac - Saint Emilion GCC', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4049', (SELECT id FROM ingredients WHERE code = 'V4049' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4050', 'Mercurey Rouge Louis Latour', 2550000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4050', (SELECT id FROM ingredients WHERE code = 'V4050' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4051', 'Brio de Cantenac Brown,Cabernet Sauvignon', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4051', (SELECT id FROM ingredients WHERE code = 'V4051' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6047', 'Yali Reserva, Ventisquero - White', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6047', (SELECT id FROM ingredients WHERE code = 'V6047' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6043', 'G7 Reserva, Carta Vieja - White', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6043', (SELECT id FROM ingredients WHERE code = 'V6043' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6045', 'Santa Carolina Vistana - White', 490000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6045', (SELECT id FROM ingredients WHERE code = 'V6045' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9303', 'Portia Prima, red', 1090000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9303', (SELECT id FROM ingredients WHERE code = 'V9303' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6038', 'Santa Ema Teroir Reserva Cabernet Sauvignon (Red)', 890000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6038', (SELECT id FROM ingredients WHERE code = 'V6038' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6039', 'Santa Ema Teroir Reserva Sauvignon Blanc (White)', 890000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6039', (SELECT id FROM ingredients WHERE code = 'V6039' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4052', 'Louis Eschenauer Saint Emilion AOC', 990000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4052', (SELECT id FROM ingredients WHERE code = 'V4052' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4053', 'ChaiMas Rouge', 690000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4053', (SELECT id FROM ingredients WHERE code = 'V4053' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4054', 'La Pommeraie de Brown, Cabernet Sauvignon', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4054', (SELECT id FROM ingredients WHERE code = 'V4054' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4055', 'Optimum, Fronton', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4055', (SELECT id FROM ingredients WHERE code = 'V4055' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4056', 'Chateau Tabuteau, Lussac - Saint Emilion', 1610000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4056', (SELECT id FROM ingredients WHERE code = 'V4056' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4057', 'Patriarche, Mercurey - Red', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4057', (SELECT id FROM ingredients WHERE code = 'V4057' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4058', 'Côte De Nuits-Villages Louis Latour', 1650000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4058', (SELECT id FROM ingredients WHERE code = 'V4058' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5024', 'ChaiMas Blanc Chateau Paul Mas Languedoc', 690000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5024', (SELECT id FROM ingredients WHERE code = 'V5024' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5025', 'Louis Latour - Chablis Burgundy', 1790000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5025', (SELECT id FROM ingredients WHERE code = 'V5025' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6041', 'Santa Ema Reserva Sauvignon Blanc', 890000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6041', (SELECT id FROM ingredients WHERE code = 'V6041' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6042', 'G7 Reserva, Carta Vieja - Red', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6042', (SELECT id FROM ingredients WHERE code = 'V6042' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6044', 'Santa Carolina Vistana - Red', 490000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6044', (SELECT id FROM ingredients WHERE code = 'V6044' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6046', 'Yali Reserva, Ventisquero - Red', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6046', (SELECT id FROM ingredients WHERE code = 'V6046' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2124', 'SIGNATURE Roasted pigeon and foie gras mashed peas', 450000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2124', (SELECT id FROM ingredients WHERE code = 'R2124' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3108', 'Sole fillet with butter sauce', 390000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3108', (SELECT id FROM ingredients WHERE code = 'R3108' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6024', 'Set menu 35A2', 787500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6024', (SELECT id FROM ingredients WHERE code = 'R6024' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4059', 'Domaine de saravel valreas cotes du rhone villages - Red', 1390000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4059', (SELECT id FROM ingredients WHERE code = 'V4059' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V7008', 'Moscato Luca Bosio - White', 875000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V7008', (SELECT id FROM ingredients WHERE code = 'V7008' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6068', 'Set menu 35A3', 787500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6068', (SELECT id FROM ingredients WHERE code = 'R6068' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6070', 'Set menu 35A4', 787500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6070', (SELECT id FROM ingredients WHERE code = 'R6070' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M6015', 'La Vie Premium 0,4L', 20000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M6015', (SELECT id FROM ingredients WHERE code = 'M6015' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6048', 'Yali Sauvignon Blanc', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6048', (SELECT id FROM ingredients WHERE code = 'V6048' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M96401', 'KOME HAJIME  - Shochu 25% - bottle 750 ml', 795000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M96401', (SELECT id FROM ingredients WHERE code = 'M96401' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6080', 'Set menu 35A5', 822500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6080', (SELECT id FROM ingredients WHERE code = 'R6080' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6025', 'Set Menu 40', 940000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6025', (SELECT id FROM ingredients WHERE code = 'R6025' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6027', 'Set Menu 45', 1080000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6027', (SELECT id FROM ingredients WHERE code = 'R6027' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6037', 'Set menu 50', 1175000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6037', (SELECT id FROM ingredients WHERE code = 'R6037' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4060', 'F31 Belle Bergere bottle - Red', 890000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4060', (SELECT id FROM ingredients WHERE code = 'V4060' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5026', 'F30 Belle Bergere bottle - White', 890000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5026', (SELECT id FROM ingredients WHERE code = 'V5026' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3109', 'Cold seafood platter for 1 per', 290000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3109', (SELECT id FROM ingredients WHERE code = 'R3109' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3110', 'Cold seafood platter for 2 pers', 490000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3110', (SELECT id FROM ingredients WHERE code = 'R3110' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3111', 'Cold seafood platter for 3 pers', 660000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3111', (SELECT id FROM ingredients WHERE code = 'R3111' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3112', 'Cold seafood platter for 4 pers', 790000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3112', (SELECT id FROM ingredients WHERE code = 'R3112' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3113', 'Cold seafood platter for 5 pers', 930000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3113', (SELECT id FROM ingredients WHERE code = 'R3113' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3114', 'Cold seafood platter for 6 pers', 1090000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3114', (SELECT id FROM ingredients WHERE code = 'R3114' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3115', 'Fresh Oyster Size L (Pcs)', 110000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3115', (SELECT id FROM ingredients WHERE code = 'R3115' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('0001', 'MK', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('0001', (SELECT id FROM ingredients WHERE code = '0001' LIMIT 1), 1, 100.0, 'PIECE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6050', 'Casa Subercaseaux Cab Sauv', 490000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6050', (SELECT id FROM ingredients WHERE code = 'V6050' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('DE1001', 'Sandwich - Ham and Cheese', 50000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('DE1001', (SELECT id FROM ingredients WHERE code = 'DE1001' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('DE1002', 'Sandwich -Smoked Salmon', 85000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('DE1002', (SELECT id FROM ingredients WHERE code = 'DE1002' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('DE1003', 'Set Hải Sản Gồm Rượu', 1090000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('DE1003', (SELECT id FROM ingredients WHERE code = 'DE1003' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('DE1004', 'Roasted Chicken', 480000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('DE1004', (SELECT id FROM ingredients WHERE code = 'DE1004' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('DE1005', 'Roasted Chicken with Hanoi Bia Hơi', 499000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('DE1005', (SELECT id FROM ingredients WHERE code = 'DE1005' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4061', 'Chateau Batailley Red Bottle', 2350000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4061', (SELECT id FROM ingredients WHERE code = 'V4061' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('B5017', 'Hanoi Bia Hơi 500ml', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('B5017', (SELECT id FROM ingredients WHERE code = 'B5017' LIMIT 1), 1, 100.0, 'CAN')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('DE1006', 'Grilled Pork Rib', 390000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('DE1006', (SELECT id FROM ingredients WHERE code = 'DE1006' LIMIT 1), 1, 100.0, 'KG')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M6016', 'San Benedetto Still Water 0.75L', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M6016', (SELECT id FROM ingredients WHERE code = 'M6016' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M96021', 'Ballantines 15', 2560000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M96021', (SELECT id FROM ingredients WHERE code = 'M96021' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M96361', 'Macallan 12 Double Cask', 3850000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M96361', (SELECT id FROM ingredients WHERE code = 'M96361' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V60081', 'Casillero Del Diablo Syrah', 995000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V60081', (SELECT id FROM ingredients WHERE code = 'V60081' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1031', 'Terrine Platter', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1031', (SELECT id FROM ingredients WHERE code = 'R1031' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5109', 'Banana Flambee Chuối đốt rượu', 99000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5109', (SELECT id FROM ingredients WHERE code = 'R5109' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3116', 'Ốc Bulot Vùng Burgundy Pháp (Pcs)', 25000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3116', (SELECT id FROM ingredients WHERE code = 'R3116' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5110', 'Bưởi da xanh tráng miệng', 290000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5110', (SELECT id FROM ingredients WHERE code = 'R5110' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3117', 'Tôm Bắc Cực (Cold Water Shrimp) Kg', 850000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3117', (SELECT id FROM ingredients WHERE code = 'R3117' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9409', 'La Palma Rose, Chile', 595000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9409', (SELECT id FROM ingredients WHERE code = 'V9409' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4066', 'Ronan By Clinet (by Chateau Clinet, Pomerol) Merlot Bordeaux AC- Red', 1165000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4066', (SELECT id FROM ingredients WHERE code = 'V4066' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4067', 'Maltus, Pezat, Bordeaux Superior - Red', 1665000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4067', (SELECT id FROM ingredients WHERE code = 'V4067' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4070', 'Chateau Roc de Candale, Saint Emilion Grand Cru- Red', 2295000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4070', (SELECT id FROM ingredients WHERE code = 'V4070' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4073', 'Chateau Bertineau Saint-Vincent | Pomerol - Bordeaux- Red', 2795000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4073', (SELECT id FROM ingredients WHERE code = 'V4073' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5031', 'Louis Latour Ardèche, Chardonnay - White', 995000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5031', (SELECT id FROM ingredients WHERE code = 'V5031' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6051', 'CASAS DEL TOQUI, Barrel Reserva, Cabernet Sauvignon - Red Chile', 995000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6051', (SELECT id FROM ingredients WHERE code = 'V6051' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6052', 'CASAS DEL TOQUI, Barrel Reserva, Chardonnay - White Chile', 995000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6052', (SELECT id FROM ingredients WHERE code = 'V6052' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V7009', 'Purato, Siccari Appassimento Organic, Terre Siciliane IGP - Red', 995000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V7009', (SELECT id FROM ingredients WHERE code = 'V7009' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V7010', 'Grande Passolo, Salento - Puglia, Primitivo - Negroamaro - Red', 1465000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V7010', (SELECT id FROM ingredients WHERE code = 'V7010' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V7011', 'Grande Passolo, Piemonte, Chardonnay - White', 1465000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V7011', (SELECT id FROM ingredients WHERE code = 'V7011' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V3009', 'De Bortoli, Deen Vat 5, Botrytis Semillon Late Harvest 37.5cl', 995000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V3009', (SELECT id FROM ingredients WHERE code = 'V3009' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3118', 'Vẹm Xanh Newzealand (Newzealand Musseles) Kg', 650000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3118', (SELECT id FROM ingredients WHERE code = 'R3118' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1032', 'Trâu Gác Bếp (110 gram)', 290000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1032', (SELECT id FROM ingredients WHERE code = 'R1032' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1033', 'Bò một nắng (110 gram)', 290000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1033', (SELECT id FROM ingredients WHERE code = 'R1033' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M6017', 'San Benedetto Still Water 0.5L', 55000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M6017', (SELECT id FROM ingredients WHERE code = 'M6017' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M6018', 'San benedetto Still Water 0.65L', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M6018', (SELECT id FROM ingredients WHERE code = 'M6018' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M6019', 'San Benedetto Sparking Water 1L', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M6019', (SELECT id FROM ingredients WHERE code = 'M6019' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6038', 'Set menu 55', 1237500.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6038', (SELECT id FROM ingredients WHERE code = 'R6038' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6039', 'Set menu 60', 1350000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6039', (SELECT id FROM ingredients WHERE code = 'R6039' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6075', 'Set menu 70', 1575000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6075', (SELECT id FROM ingredients WHERE code = 'R6075' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6071', 'Set menu 90', 2025000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6071', (SELECT id FROM ingredients WHERE code = 'R6071' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6081', 'Roasted Pork with Steam rice', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6081', (SELECT id FROM ingredients WHERE code = 'R6081' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6082', 'Pork stew with Steam rice', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6082', (SELECT id FROM ingredients WHERE code = 'R6082' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6083', 'Stuffed chicken leg with Steam rice', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6083', (SELECT id FROM ingredients WHERE code = 'R6083' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R7001', 'Multicolor Salad', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R7001', (SELECT id FROM ingredients WHERE code = 'R7001' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R7002', 'Green seasonal vegetables soup', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R7002', (SELECT id FROM ingredients WHERE code = 'R7002' LIMIT 1), 1, 100.0, 'BOWL')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R7003', 'Breaded pork loin, tomatoes sauce, broccoli and carrot flan', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R7003', (SELECT id FROM ingredients WHERE code = 'R7003' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R7004', 'Basa fillet roulade southern, broccoli and carrot flan', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R7004', (SELECT id FROM ingredients WHERE code = 'R7004' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R7005', 'Banana crepe, chocolate sauce', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R7005', (SELECT id FROM ingredients WHERE code = 'R7005' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R7006', 'Regular Vietnamese coffee or green tea', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R7006', (SELECT id FROM ingredients WHERE code = 'R7006' LIMIT 1), 1, 100.0, 'CUP')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6091', 'Set menu (700)', 700000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6091', (SELECT id FROM ingredients WHERE code = 'R6091' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6092', 'Set menu Christmas', 1090000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6092', (SELECT id FROM ingredients WHERE code = 'R6092' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6131', 'Set Menu 350A', 350000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6131', (SELECT id FROM ingredients WHERE code = 'R6131' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6132', 'Set Menu 350B', 350000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6132', (SELECT id FROM ingredients WHERE code = 'R6132' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6133', 'Set menu 350C', 350000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6133', (SELECT id FROM ingredients WHERE code = 'R6133' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6134', 'Set Menu 430A', 430000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6134', (SELECT id FROM ingredients WHERE code = 'R6134' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6135', 'Set Menu 430B', 430000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6135', (SELECT id FROM ingredients WHERE code = 'R6135' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6154', 'Set Menu 430C', 430000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6154', (SELECT id FROM ingredients WHERE code = 'R6154' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6193', 'Set Menu 500A', 500000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6193', (SELECT id FROM ingredients WHERE code = 'R6193' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V2013', 'Gemma Di Luma Moscato 75CL', 1055000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V2013', (SELECT id FROM ingredients WHERE code = 'V2013' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1110', 'Beef Tartare', 490000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1110', (SELECT id FROM ingredients WHERE code = 'R1110' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6194', 'Set Menu 500B', 500000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6194', (SELECT id FROM ingredients WHERE code = 'R6194' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4078', 'Chateau Haut Selve Graves - Red', 2000000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4078', (SELECT id FROM ingredients WHERE code = 'V4078' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6155', 'Set Menu 510A', 510000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6155', (SELECT id FROM ingredients WHERE code = 'R6155' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R61551', 'Set Menu 510B', 510000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R61551', (SELECT id FROM ingredients WHERE code = 'R61551' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6136', 'Set Menu 550A', 550000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6136', (SELECT id FROM ingredients WHERE code = 'R6136' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('001', 'Open Menu Drink', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('001', (SELECT id FROM ingredients WHERE code = '001' LIMIT 1), 1, 100.0, 'PIECE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6137', 'Set Menu 550B', 550000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6137', (SELECT id FROM ingredients WHERE code = 'R6137' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6196', 'Set Menu 550C', 550000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6196', (SELECT id FROM ingredients WHERE code = 'R6196' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6197', 'Set Menu 550D', 550000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6197', (SELECT id FROM ingredients WHERE code = 'R6197' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6198', 'Set Menu 550E', 550000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6198', (SELECT id FROM ingredients WHERE code = 'R6198' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6151', 'Set Menu 650A', 650000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6151', (SELECT id FROM ingredients WHERE code = 'R6151' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6152', 'Set Menu 650B', 650000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6152', (SELECT id FROM ingredients WHERE code = 'R6152' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6138', 'Set Menu 710A', 710000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6138', (SELECT id FROM ingredients WHERE code = 'R6138' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6139', 'Set Menu 710B', 710000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6139', (SELECT id FROM ingredients WHERE code = 'R6139' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6153', 'Set Menu 710C', 710000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6153', (SELECT id FROM ingredients WHERE code = 'R6153' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6195', 'Set Menu 710D', 710000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6195', (SELECT id FROM ingredients WHERE code = 'R6195' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6147', 'Set Menu 720A', 720000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6147', (SELECT id FROM ingredients WHERE code = 'R6147' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6148', 'Set Menu 720B', 720000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6148', (SELECT id FROM ingredients WHERE code = 'R6148' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6149', 'Set Menu 720C', 720000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6149', (SELECT id FROM ingredients WHERE code = 'R6149' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6150', 'Set Menu 720D', 720000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6150', (SELECT id FROM ingredients WHERE code = 'R6150' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R61501', 'Set Menu 720E', 720000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R61501', (SELECT id FROM ingredients WHERE code = 'R61501' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R61502', 'Set Menu 720F', 720000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R61502', (SELECT id FROM ingredients WHERE code = 'R61502' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6199', 'Set Menu 850A', 850000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6199', (SELECT id FROM ingredients WHERE code = 'R6199' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R61991', 'Set Menu 850B', 850000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R61991', (SELECT id FROM ingredients WHERE code = 'R61991' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R61992', 'Set Menu 850C', 850000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R61992', (SELECT id FROM ingredients WHERE code = 'R61992' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6140', 'Set Menu 940', 940000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6140', (SELECT id FROM ingredients WHERE code = 'R6140' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R61401', 'Set Menu 950', 950000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R61401', (SELECT id FROM ingredients WHERE code = 'R61401' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R614011', 'Set Menu 1050', 1050000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R614011', (SELECT id FROM ingredients WHERE code = 'R614011' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6141', 'Set Menu 1190', 1190000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6141', (SELECT id FROM ingredients WHERE code = 'R6141' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R61411', 'Set Menu 1200', 1200000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R61411', (SELECT id FROM ingredients WHERE code = 'R61411' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6142', 'Set Menu 1500', 1500000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6142', (SELECT id FROM ingredients WHERE code = 'R6142' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6143', 'Set Menu 1800A', 1800000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6143', (SELECT id FROM ingredients WHERE code = 'R6143' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6144', 'Set Menu 2200', 2200000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6144', (SELECT id FROM ingredients WHERE code = 'R6144' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6145', 'Set Menu 2700', 2700000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6145', (SELECT id FROM ingredients WHERE code = 'R6145' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6146', 'Set Menu 3300', 3300000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6146', (SELECT id FROM ingredients WHERE code = 'R6146' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R60921', 'Set Menu New Year for 2 pers', 1990000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R60921', (SELECT id FROM ingredients WHERE code = 'R60921' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R609212', 'Set Menu New Year for 2 pers with wine', 2790000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R609212', (SELECT id FROM ingredients WHERE code = 'R609212' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R609213', 'Valentine set menu for 2 pers', 1590000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R609213', (SELECT id FROM ingredients WHERE code = 'R609213' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6156', 'Set Menu Two Courses 1+3 A', 365000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6156', (SELECT id FROM ingredients WHERE code = 'R6156' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6157', 'Set Menu Two Courses 1+3 B', 365000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6157', (SELECT id FROM ingredients WHERE code = 'R6157' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6158', 'Set Menu Two Courses 1+3 C', 365000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6158', (SELECT id FROM ingredients WHERE code = 'R6158' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6159', 'Set Menu Two Courses 1+3 D', 365000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6159', (SELECT id FROM ingredients WHERE code = 'R6159' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6160', 'Set Menu Two Courses 1+3 E', 365000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6160', (SELECT id FROM ingredients WHERE code = 'R6160' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6161', 'Set Menu Two Courses 2+3 A', 290000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6161', (SELECT id FROM ingredients WHERE code = 'R6161' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6162', 'Set Menu Two Courses 2+3 B', 290000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6162', (SELECT id FROM ingredients WHERE code = 'R6162' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6163', 'Set Menu Two Courses 2+3 C', 290000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6163', (SELECT id FROM ingredients WHERE code = 'R6163' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6164', 'Set Menu Two Courses 2+3 D', 290000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6164', (SELECT id FROM ingredients WHERE code = 'R6164' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4079', 'Chateau Haut Dambert', 980000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4079', (SELECT id FROM ingredients WHERE code = 'V4079' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6165', 'Set Menu Two Courses 2+3 E', 290000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6165', (SELECT id FROM ingredients WHERE code = 'R6165' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9107', 'Barramundi, Chardonnay - Australia', 1195000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9107', (SELECT id FROM ingredients WHERE code = 'V9107' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9203', 'Kim Crawford, Sauvignon Blanc - New Zealand', 1325000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9203', (SELECT id FROM ingredients WHERE code = 'V9203' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4080', 'Château Clou Du Pin Bordeaux Supérieur ( Red )', 1195000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4080', (SELECT id FROM ingredients WHERE code = 'V4080' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5035', 'Château Clou Du Pin Bordeaux Blanc ( White )', 1195000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5035', (SELECT id FROM ingredients WHERE code = 'V5035' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9113', 'Red Wine Glass Chile - Fronterra', 160000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9113', (SELECT id FROM ingredients WHERE code = 'M9113' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9114', 'White Wine Glass Chile - Fronterra', 160000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9114', (SELECT id FROM ingredients WHERE code = 'M9114' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1111', 'Garden Vegetables', 160000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1111', (SELECT id FROM ingredients WHERE code = 'R1111' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1112', 'Baked Beet Salad', 190000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1112', (SELECT id FROM ingredients WHERE code = 'R1112' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1113', 'Cured Salmon Carpaccio', 250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1113', (SELECT id FROM ingredients WHERE code = 'R1113' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1114', 'Beef  Carpaccio', 250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1114', (SELECT id FROM ingredients WHERE code = 'R1114' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1115', 'Seared Ahi Tuna', 260000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1115', (SELECT id FROM ingredients WHERE code = 'R1115' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1116', 'Slice Scallops', 295000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1116', (SELECT id FROM ingredients WHERE code = 'R1116' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1117', 'Tomato Seafood Soup', 150000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1117', (SELECT id FROM ingredients WHERE code = 'R1117' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1118', 'Dalat Artichoke Soup', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1118', (SELECT id FROM ingredients WHERE code = 'R1118' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2125', 'Black Angus US Beef Ribeye 150 gram', 430000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2125', (SELECT id FROM ingredients WHERE code = 'R2125' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2126', 'Black Angus US Beef Ribeye 200 gram', 550000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2126', (SELECT id FROM ingredients WHERE code = 'R2126' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2127', 'Black Angus US Beef Ribeye 300 gram', 795000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2127', (SELECT id FROM ingredients WHERE code = 'R2127' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2129', 'Char Grilled AUS Beef Tenderloin 150 gram', 495000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2129', (SELECT id FROM ingredients WHERE code = 'R2129' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2130', 'Char Grilled AUS Beef Tenderloin 200 gram', 645000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2130', (SELECT id FROM ingredients WHERE code = 'R2130' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2131', 'Char Grilled AUS Beef Tenderloin 300 gram', 955000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2131', (SELECT id FROM ingredients WHERE code = 'R2131' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2132', 'Prime US Chuck Eye Roll 170 gram', 390000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2132', (SELECT id FROM ingredients WHERE code = 'R2132' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2133', 'Prime US Chuck Eye Roll 300 gram', 595000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2133', (SELECT id FROM ingredients WHERE code = 'R2133' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2134', 'Australian Wagyu Ribeye MBS 6+ 150 gram', 1295000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2134', (SELECT id FROM ingredients WHERE code = 'R2134' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2135', 'AUS Lamb Rack with Asian herb 3 chops', 535000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2135', (SELECT id FROM ingredients WHERE code = 'R2135' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2136', 'Pan - Fried French Duck Breast', 395000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2136', (SELECT id FROM ingredients WHERE code = 'R2136' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2138', 'Braised Beef Cheek with Dalat Red Wine', 330000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2138', (SELECT id FROM ingredients WHERE code = 'R2138' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2137', 'Roasted Iberico Pork Fillet Mignon', 395000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2137', (SELECT id FROM ingredients WHERE code = 'R2137' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2139', 'Chicken rolls with Sapa mushroom', 250000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2139', (SELECT id FROM ingredients WHERE code = 'R2139' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3119', 'Slow cook Octopus', 390000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3119', (SELECT id FROM ingredients WHERE code = 'R3119' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3120', 'Pan-Fried Norwegian Salmon,Hanoi basil sauce', 390000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3120', (SELECT id FROM ingredients WHERE code = 'R3120' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3121', 'Baked Oven Sea bass, creamy curry sauce', 350000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3121', (SELECT id FROM ingredients WHERE code = 'R3121' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3122', 'Pan- Fried Balck Cod, Tamarind sauce', 655000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3122', (SELECT id FROM ingredients WHERE code = 'R3122' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3123', 'Pan- Fried Japanese Scallops', 690000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3123', (SELECT id FROM ingredients WHERE code = 'R3123' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R3124', 'Tiger Prawns in a tantalizing chili tamarind sauce', 490000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R3124', (SELECT id FROM ingredients WHERE code = 'R3124' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('SI0001', 'Sauteed Mushroom', 130000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('SI0001', (SELECT id FROM ingredients WHERE code = 'SI0001' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('SI0002', 'Grilled Asparagus', 130000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('SI0002', (SELECT id FROM ingredients WHERE code = 'SI0002' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('SI0003', 'Arugula Salad', 130000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('SI0003', (SELECT id FROM ingredients WHERE code = 'SI0003' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('SI0004', 'French Fries', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('SI0004', (SELECT id FROM ingredients WHERE code = 'SI0004' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('SI0005', 'Baked Potatoes', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('SI0005', (SELECT id FROM ingredients WHERE code = 'SI0005' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('SI0006', 'Mashed Potatoes', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('SI0006', (SELECT id FROM ingredients WHERE code = 'SI0006' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('SI0007', 'Extra sauce', 130000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('SI0007', (SELECT id FROM ingredients WHERE code = 'SI0007' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5111', 'Tiramisu Coffee Flavoured', 120000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5111', (SELECT id FROM ingredients WHERE code = 'R5111' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5112', 'Chocolate and Orange Cheese Cake', 120000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5112', (SELECT id FROM ingredients WHERE code = 'R5112' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1119', 'Pan-Fried Duck Foie Gras 40Gram', 390000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1119', (SELECT id FROM ingredients WHERE code = 'R1119' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2128', 'Black Angus US Beef Ribeye 400 gram', 1050000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2128', (SELECT id FROM ingredients WHERE code = 'R2128' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2140', 'Braised Lamb Shank nestled in a bed of couscous', 495000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2140', (SELECT id FROM ingredients WHERE code = 'R2140' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M7024', 'Kombucha Dragon fruit', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M7024', (SELECT id FROM ingredients WHERE code = 'M7024' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6166', 'Set Menu Two Courses 1+4', 270000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6166', (SELECT id FROM ingredients WHERE code = 'R6166' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4084', 'CHATEAU CAP DE FAUGERES Cotes de Castillon', 1995000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4084', (SELECT id FROM ingredients WHERE code = 'V4084' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4085', 'JEAN LUC COLOMBO, "LA VIOLETTE" (Syrah) IGP d''Oc', 1095000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4085', (SELECT id FROM ingredients WHERE code = 'V4085' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4086', 'M.CHAPOUTIER CROZES-HERMITAGE LA PETITE RUCHE (Syrah) Rhone', 1595000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4086', (SELECT id FROM ingredients WHERE code = 'V4086' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5036', 'CHÂTEAU MONT-PÉRAT (Sauvignon Blanc-Semillon) Bordeaux', 995000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5036', (SELECT id FROM ingredients WHERE code = 'V5036' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V7013', 'DRAGA (Merlot) Venezia Giulia IGP', 1695000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V7013', (SELECT id FROM ingredients WHERE code = 'V7013' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V7014', 'DRAGA (Sauvignon Blanc) Collio', 1595000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V7014', (SELECT id FROM ingredients WHERE code = 'V7014' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V6055', 'Ocho Reserva Cabernet Sauvignon', 990000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V6055', (SELECT id FROM ingredients WHERE code = 'V6055' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6167', 'Set Menu Two Courses 2+4', 195000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6167', (SELECT id FROM ingredients WHERE code = 'R6167' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6168', 'Set Menu Two Courses 3+4 A', 305000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6168', (SELECT id FROM ingredients WHERE code = 'R6168' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6169', 'Set Menu Two Courses 3+4 B', 305000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6169', (SELECT id FROM ingredients WHERE code = 'R6169' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6170', 'Set Menu Two Courses 3+4 C', 305000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6170', (SELECT id FROM ingredients WHERE code = 'R6170' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6171', 'Set Menu Two Courses 3+4 D', 305000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6171', (SELECT id FROM ingredients WHERE code = 'R6171' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6172', 'Set Menu Two Courses 3+4 E', 305000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6172', (SELECT id FROM ingredients WHERE code = 'R6172' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6173', 'Set Menu Three Courses 1+2+3 A', 455000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6173', (SELECT id FROM ingredients WHERE code = 'R6173' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6174', 'Set Menu Three Courses 1+2+3 B', 455000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6174', (SELECT id FROM ingredients WHERE code = 'R6174' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V4087', 'Chateau Fleur Cardinale, Saint-Emilion Grand Cru, France', 3595000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V4087', (SELECT id FROM ingredients WHERE code = 'V4087' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R60831', 'Hai Nam Chicken Rice', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R60831', (SELECT id FROM ingredients WHERE code = 'R60831' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R60811', 'Pork rib with Steam rice', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R60811', (SELECT id FROM ingredients WHERE code = 'R60811' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M96402', 'Tamura Shuzojo Kasen Sake 1.8L', 2890000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M96402', (SELECT id FROM ingredients WHERE code = 'M96402' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6175', 'Set Menu Three Courses 1+2+3 C', 455000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6175', (SELECT id FROM ingredients WHERE code = 'R6175' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6176', 'Set Menu Three Courses 1+2+3 D', 455000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6176', (SELECT id FROM ingredients WHERE code = 'R6176' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6177', 'Set Menu Three Courses 1+2+3 E', 455000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6177', (SELECT id FROM ingredients WHERE code = 'R6177' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M3012', 'Jack Daniel Glass', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M3012', (SELECT id FROM ingredients WHERE code = 'M3012' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1120', 'Creamy pumpkin soup', 90000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1120', (SELECT id FROM ingredients WHERE code = 'R1120' LIMIT 1), 1, 100.0, 'BOWL')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R1123', 'Lobster salad with mango, avocado, and passion fruit dressing', 595000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R1123', (SELECT id FROM ingredients WHERE code = 'R1123' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2143', 'AUS beef tenderloin with green peppercorn sauce and mashed potatoes', 535000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2143', (SELECT id FROM ingredients WHERE code = 'R2143' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2146', 'Burgundy-style beef stew with red wine, organic noodles and mushrooms', 395000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2146', (SELECT id FROM ingredients WHERE code = 'R2146' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2147', 'Chicken à la Provençale with mashed potatoes', 395000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2147', (SELECT id FROM ingredients WHERE code = 'R2147' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R2151', 'Roast Iberico pork tenderloin with apple Calvados sauce and sweet potatoes', 495000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R2151', (SELECT id FROM ingredients WHERE code = 'R2151' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R8001', 'Oven-baked stuffed eggplant with lentils and ratatoui le (Vegetarian)', 200000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R8001', (SELECT id FROM ingredients WHERE code = 'R8001' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R8002', 'Grilled vegetable Napoleon with red pepper coulis (Vegetarian)', 200000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R8002', (SELECT id FROM ingredients WHERE code = 'R8002' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5115', 'Caramelized apple tart and vanilla ice cream', 155000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5115', (SELECT id FROM ingredients WHERE code = 'R5115' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R5116', 'Cream puffs with vani la ice cream and chocolate sauce', 155000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R5116', (SELECT id FROM ingredients WHERE code = 'R5116' LIMIT 1), 1, 100.0, 'PLATE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6178', 'Set Menu Three Courses 1+3+4 A', 470000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6178', (SELECT id FROM ingredients WHERE code = 'R6178' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6179', 'Set Menu Three Courses 1+3+4 B', 470000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6179', (SELECT id FROM ingredients WHERE code = 'R6179' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6180', 'Set Menu Three Courses 1+3+4 C', 470000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6180', (SELECT id FROM ingredients WHERE code = 'R6180' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6181', 'Set Menu Three Courses 1+3+4 D', 470000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6181', (SELECT id FROM ingredients WHERE code = 'R6181' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6182', 'Set Menu Three Courses 1+3+4 E', 470000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6182', (SELECT id FROM ingredients WHERE code = 'R6182' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6183', 'Set Menu Three Courses 2+3+4 A', 395000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6183', (SELECT id FROM ingredients WHERE code = 'R6183' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6184', 'Set Menu Three Courses 2+3+4 B', 395000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6184', (SELECT id FROM ingredients WHERE code = 'R6184' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6185', 'Set Menu Three Courses 2+3+4 C', 395000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6185', (SELECT id FROM ingredients WHERE code = 'R6185' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6186', 'Set Menu Three Courses 2+3+4 D', 395000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6186', (SELECT id FROM ingredients WHERE code = 'R6186' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6187', 'Set Menu Three Courses 2+3+4 E', 395000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6187', (SELECT id FROM ingredients WHERE code = 'R6187' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6188', 'Set Menu Four Courses A', 550000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6188', (SELECT id FROM ingredients WHERE code = 'R6188' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6189', 'Set Menu Four Courses B', 550000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6189', (SELECT id FROM ingredients WHERE code = 'R6189' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6190', 'Set Menu Four Courses C', 550000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6190', (SELECT id FROM ingredients WHERE code = 'R6190' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6191', 'Set Menu Four Courses D', 550000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6191', (SELECT id FROM ingredients WHERE code = 'R6191' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6192', 'Set Menu Four Courses E', 550000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6192', (SELECT id FROM ingredients WHERE code = 'R6192' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R609214', 'New Year Set Menu', 1690000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R609214', (SELECT id FROM ingredients WHERE code = 'R609214' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6208', 'Dégustation Set Menu 4 to 7 Courses-1', 1199000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6208', (SELECT id FROM ingredients WHERE code = 'R6208' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6209', 'Dégustation Set Menu 4 to 7 Courses-2', 1199000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6209', (SELECT id FROM ingredients WHERE code = 'R6209' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6210', 'Dégustation Set Menu 4 to 7 Courses-3', 1199000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6210', (SELECT id FROM ingredients WHERE code = 'R6210' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6211', 'Dégustation Set Menu 4 to 7 Courses-4', 1199000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6211', (SELECT id FROM ingredients WHERE code = 'R6211' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6214', 'Dégustation Set Menu 4 to 7 Courses-7', 1199000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6214', (SELECT id FROM ingredients WHERE code = 'R6214' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6215', 'Dégustation Set Menu 4 to 7 Courses-8', 1199000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6215', (SELECT id FROM ingredients WHERE code = 'R6215' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6216', 'Dégustation Set Menu 4 to 7 Courses-9', 1199000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6216', (SELECT id FROM ingredients WHERE code = 'R6216' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6217', 'Dégustation Set Menu 4 to 7 Courses-10', 1199000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6217', (SELECT id FROM ingredients WHERE code = 'R6217' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6219', 'Dégustation Set Menu 4 to 7 Courses-12', 1199000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6219', (SELECT id FROM ingredients WHERE code = 'R6219' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6220', 'Set Menu Two Courses 1+2', 255000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6220', (SELECT id FROM ingredients WHERE code = 'R6220' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6221', 'Set Menu Two Courses 1+3 F', 365000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6221', (SELECT id FROM ingredients WHERE code = 'R6221' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6222', 'Set Menu Two Courses 1+3 G', 365000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6222', (SELECT id FROM ingredients WHERE code = 'R6222' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6223', 'Set Menu Two Courses 3+4 F', 305000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6223', (SELECT id FROM ingredients WHERE code = 'R6223' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6224', 'Set Menu Two Courses 3+4 G', 305000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6224', (SELECT id FROM ingredients WHERE code = 'R6224' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6225', 'Set Menu Three Courses 1+2+3 F', 455000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6225', (SELECT id FROM ingredients WHERE code = 'R6225' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6226', 'Set Menu Three Courses 1+2+3 G', 455000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6226', (SELECT id FROM ingredients WHERE code = 'R6226' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6227', 'Set Menu Three Courses 1+3+4 F', 470000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6227', (SELECT id FROM ingredients WHERE code = 'R6227' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6228', 'Set Menu Three Courses 1+3+4 G', 470000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6228', (SELECT id FROM ingredients WHERE code = 'R6228' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6229', 'Set Menu Three Courses 2+3+4 F', 395000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6229', (SELECT id FROM ingredients WHERE code = 'R6229' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6230', 'Set Menu Three Courses 2+3+4 G', 395000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6230', (SELECT id FROM ingredients WHERE code = 'R6230' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6231', 'Set Menu Four Courses F', 550000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6231', (SELECT id FROM ingredients WHERE code = 'R6231' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6232', 'Set Menu Four Courses G', 550000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6232', (SELECT id FROM ingredients WHERE code = 'R6232' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6233', 'Set Menu Two Courses 2+3 F', 290000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6233', (SELECT id FROM ingredients WHERE code = 'R6233' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('R6234', 'Set Menu Two Courses 2+3 G', 290000.0, true, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('R6234', (SELECT id FROM ingredients WHERE code = 'R6234' LIMIT 1), 1, 100.0, 'PAX')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V2014', 'trống', 1950000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V2014', (SELECT id FROM ingredients WHERE code = 'V2014' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V5039', 'Grand Bateau Bordeaux Blanc (by Beychevelle)', 1150000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V5039', (SELECT id FROM ingredients WHERE code = 'V5039' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V2017', 'Pitars Prosecco DOC Extra Dry (Glera · Grave del Friuli DOC — Italy) - Sparkling', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V2017', (SELECT id FROM ingredients WHERE code = 'V2017' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('V9413', 'Dufouleur Père & Fils Pinot Noir Rosé (Vin de France — France)', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('V9413', (SELECT id FROM ingredients WHERE code = 'V9413' LIMIT 1), 1, 100.0, 'BOTTLE')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M7026', 'Sunset Citrus Cooler', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M7026', (SELECT id FROM ingredients WHERE code = 'M7026' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M7027', 'Watermelon Cooler', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M7027', (SELECT id FROM ingredients WHERE code = 'M7027' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M7029', 'Pineapple Cooler', 0.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M7029', (SELECT id FROM ingredients WHERE code = 'M7029' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9115', 'Cremaschi Furlotti Chardonnay Chile- Glass', 160000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9115', (SELECT id FROM ingredients WHERE code = 'M9115' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9116', 'Cremaschi Furlotti Sauvignon Blanc Chile-Glass', 160000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9116', (SELECT id FROM ingredients WHERE code = 'M9116' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9117', 'Cremaschi Furlotti Cabernet Sauvignon Chile- Glass', 160000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9117', (SELECT id FROM ingredients WHERE code = 'M9117' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9118', 'Château Baratet Sauvignon Blanc France Glass', 160000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9118', (SELECT id FROM ingredients WHERE code = 'M9118' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9119', 'Château Baratet Cabernet Sauvignon France Glass', 160000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9119', (SELECT id FROM ingredients WHERE code = 'M9119' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;
INSERT INTO menu_items (id, name, sale_price, is_set_menu, deduction_type)
VALUES ('M9120', 'Pitars Prosecco DOC Extra Dry “Sparkling” - Italy Glass', 270000.0, false, 'RECIPE')
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipes (menu_item_id, ingredient_id, qty_net, yield_pct, recipe_uom)
VALUES ('M9120', (SELECT id FROM ingredients WHERE code = 'M9120' LIMIT 1), 1, 100.0, 'GLASS')
ON CONFLICT (menu_item_id, ingredient_id) DO NOTHING;

COMMIT;
