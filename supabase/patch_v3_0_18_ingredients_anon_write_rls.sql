-- ============================================================
-- PATCH v3.0.18 — Add write policies for anon on ingredients table
-- Purpose: Support sandbox login mode (password: 'sandbox')
--          where the client connection is unauthenticated (anon role).
-- ============================================================

-- 1. Drop existing write policies for anon if any
DROP POLICY IF EXISTS anon_write_ingredients ON ingredients;
DROP POLICY IF EXISTS anon_update_ingredients ON ingredients;
DROP POLICY IF EXISTS anon_delete_ingredients ON ingredients;

-- 2. Create insert, update, delete policies for anon
CREATE POLICY anon_write_ingredients ON ingredients
  FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY anon_update_ingredients ON ingredients
  FOR UPDATE TO anon USING (true) WITH CHECK (true);

CREATE POLICY anon_delete_ingredients ON ingredients
  FOR DELETE TO anon USING (true);

SELECT 'INGREDIENTS ANON WRITE POLICIES APPLIED OK' as status;
