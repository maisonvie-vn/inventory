-- ============================================================
-- PATCH v3.0.13 — Sửa chỉ số version của các PO tháng này để tránh trùng lặp
-- Vấn đề: Cột version của các PO tháng này bị bằng 1 mặc dù mã PO ghi chỉ số 0002.
-- Giải pháp: Trích xuất chỉ số thực tế từ mã PO (ví dụ 2 từ PO-202606-0002-KIT) và lưu vào cột version.
-- ============================================================

-- Cập nhật cột version chính xác dựa trên chỉ số trong mã PO cho các đơn hàng tháng này
UPDATE purchase_orders
SET version = SUBSTRING(po_no, 11, 4)::integer
WHERE po_no LIKE 'PO-202606-%' AND length(po_no) >= 15;
