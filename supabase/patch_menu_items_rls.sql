-- =========================================================================
-- MAISON VIE v9.6 — PATCH MENU_ITEMS & SET_MENU_ITEMS RLS POLICIES
-- Run this in your Supabase SQL Editor to allow authenticated staff members
-- to select, and authorized roles to upsert menu items.
-- =========================================================================

BEGIN;

-- 1. Enable Row Level Security
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE set_menu_items ENABLE ROW LEVEL SECURITY;

-- 2. Drop existing policies to prevent duplicates
DROP POLICY IF EXISTS "Allow select menu_items for all staff" ON menu_items;
DROP POLICY IF EXISTS "Allow write menu_items for authorized staff" ON menu_items;
DROP POLICY IF EXISTS "Allow select set_menu_items for all staff" ON set_menu_items;
DROP POLICY IF EXISTS "Allow write set_menu_items for authorized staff" ON set_menu_items;

-- 3. Create SELECT policy for all authenticated users
CREATE POLICY "Allow select menu_items for all staff"
ON menu_items FOR SELECT TO authenticated
USING (true);

-- 4. Create INSERT/UPDATE/DELETE policy for admin, restaurant_manager, and senior_accountant
CREATE POLICY "Allow write menu_items for authorized staff"
ON menu_items FOR ALL TO authenticated
USING (get_current_user_role() IN ('admin', 'restaurant_manager', 'senior_accountant'))
WITH CHECK (get_current_user_role() IN ('admin', 'restaurant_manager', 'senior_accountant'));

-- 5. Create SELECT policy for set_menu_items
CREATE POLICY "Allow select set_menu_items for all staff"
ON set_menu_items FOR SELECT TO authenticated
USING (true);

-- 6. Create INSERT/UPDATE/DELETE policy for set_menu_items
CREATE POLICY "Allow write set_menu_items for authorized staff"
ON set_menu_items FOR ALL TO authenticated
USING (get_current_user_role() IN ('admin', 'restaurant_manager', 'senior_accountant'))
WITH CHECK (get_current_user_role() IN ('admin', 'restaurant_manager', 'senior_accountant'));

COMMIT;
