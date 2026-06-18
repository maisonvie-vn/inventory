-- =====================================================================
-- MAISON VIE v9.6 — FIX MISSING PRIMARY KEY & UNIQUE CONSTRAINTS
-- Run this script in the Supabase SQL Editor to resolve:
-- "ERROR: 42P10: there is no unique or exclusion constraint matching the ON CONFLICT specification"
-- =====================================================================

BEGIN;

-- 1. Restore Primary Key on ingredients(id)
-- During the migration, the old primary key on the text column was dropped
-- but because the migration script had idempotent guards, if it crashed/re-run, 
-- the primary key on the new uuid 'id' column might have been skipped.
ALTER TABLE ingredients DROP CONSTRAINT IF EXISTS ingredients_pkey;
ALTER TABLE ingredients ADD PRIMARY KEY (id);

-- 2. Restore Unique Constraint on recipes(menu_item_id, ingredient_id)
-- When the old text column 'ingredient_id' was dropped from recipes,
-- PostgreSQL automatically dropped the UNIQUE constraint on (menu_item_id, ingredient_id).
-- We need to restore it so ON CONFLICT (menu_item_id, ingredient_id) can match in seed.sql.
ALTER TABLE recipes DROP CONSTRAINT IF EXISTS recipes_menu_item_id_ingredient_id_key;
ALTER TABLE recipes ADD CONSTRAINT recipes_menu_item_id_ingredient_id_key UNIQUE (menu_item_id, ingredient_id);

COMMIT;
