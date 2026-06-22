-- ============================================================
-- PATCH v3.0.16 — Tạo view kiểm tra PO quá hạn (Aging POs)
-- Định nghĩa quá hạn: PO ở trạng thái APPROVED hoặc PENDING_APPROVAL
-- có thời gian tạo quá 3 ngày (expected lead time).
-- ============================================================

CREATE OR REPLACE VIEW public.v_aging_purchase_orders AS
SELECT 
  po.id,
  po.po_no,
  po.po_number,
  po.status,
  po.created_at,
  po.total_value,
  po.supplier_id,
  s.name as supplier_name,
  po.location_id
FROM public.purchase_orders po
LEFT JOIN public.suppliers s ON po.supplier_id = s.id
WHERE po.status IN ('APPROVED', 'PENDING_APPROVAL')
  AND po.created_at < now() - INTERVAL '3 days';

-- Phân quyền SELECT trên view cho vai trò authenticated và anon
GRANT SELECT ON public.v_aging_purchase_orders TO authenticated;
GRANT SELECT ON public.v_aging_purchase_orders TO anon;
