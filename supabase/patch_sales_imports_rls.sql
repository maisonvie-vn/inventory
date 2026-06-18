-- =========================================================================
-- MAISON VIE v9.6 — PATCH SALES_IMPORTS RLS POLICIES
-- Run this in your Supabase SQL Editor to allow authenticated staff members
-- to upload, select, and overwrite POS Sales records from the frontend.
-- =========================================================================

BEGIN;

-- 1. Enable Row Level Security
ALTER TABLE sales_imports ENABLE ROW LEVEL SECURITY;

-- 2. Drop existing policies to prevent duplicates
DROP POLICY IF EXISTS "Allow select sales_imports for all staff" ON sales_imports;
DROP POLICY IF EXISTS "Allow insert sales_imports for all staff" ON sales_imports;
DROP POLICY IF EXISTS "Allow delete sales_imports for all staff" ON sales_imports;

-- 3. Create SELECT policy for all authenticated users
CREATE POLICY "Allow select sales_imports for all staff"
ON sales_imports FOR SELECT TO authenticated
USING (true);

-- 4. Create INSERT policy for admin, restaurant_manager, and senior_accountant
CREATE POLICY "Allow insert sales_imports for all staff"
ON sales_imports FOR INSERT TO authenticated
WITH CHECK (get_current_user_role() IN ('admin', 'restaurant_manager', 'senior_accountant'));

-- 5. Create DELETE policy for admin, restaurant_manager, and senior_accountant
CREATE POLICY "Allow delete sales_imports for all staff"
ON sales_imports FOR DELETE TO authenticated
USING (get_current_user_role() IN ('admin', 'restaurant_manager', 'senior_accountant'));

COMMIT;
