-- ============================================================
-- PATCH v3.0.19 — Grant execute permissions on RPCs to anon
-- Purpose: Support sandbox login mode (password: 'sandbox')
--          where the client connection is unauthenticated (anon role)
--          but needs to load dashboard, worklists, alerts, and POs.
-- ============================================================

GRANT EXECUTE ON FUNCTION get_order_worklist_finance() TO anon;
GRANT EXECUTE ON FUNCTION set_preferred_supplier(uuid, uuid) TO anon;
GRANT EXECUTE ON FUNCTION approve_po(uuid, boolean, text) TO anon;
GRANT EXECUTE ON FUNCTION acknowledge_stock_alert(uuid, text, text) TO anon;
GRANT EXECUTE ON FUNCTION get_stock_alerts_finance() TO anon;

SELECT 'SANDBOX RPC GRANTS APPLIED OK' as status;
