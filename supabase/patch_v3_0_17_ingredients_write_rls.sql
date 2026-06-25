-- ============================================================
-- PATCH v3.0.17 — Update RLS policy for table "ingredients"
-- Allow write permissions (all actions) to:
--   - admin (CFO, Owner)
--   - senior_accountant (Senior Accountant)
--   - restaurant_manager (Restaurant Manager)
-- This fixes the violation error when a restaurant manager manually adds ingredients.
-- ============================================================

-- 1. Drop existing write policy
DROP POLICY IF EXISTS "Allow write ingredients for admin and senior accountant" ON ingredients;
DROP POLICY IF EXISTS "Allow write ingredients for authorized roles" ON ingredients;

-- 2. Create updated write policy to include restaurant_manager
CREATE POLICY "Allow write ingredients for authorized roles"
ON ingredients FOR ALL TO authenticated
USING (get_current_user_role() in ('admin', 'senior_accountant', 'restaurant_manager'))
WITH CHECK (get_current_user_role() in ('admin', 'senior_accountant', 'restaurant_manager'));

SELECT 'INGREDIENTS WRITE POLICY UPDATED SUCCESSFULLY' as status;
