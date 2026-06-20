-- ============================================================
-- PATCH v3.0.9 — Bổ sung supplier_id vào view v_order_worklist_ops
-- Sửa lỗi: Dropdown NCC ưu tiên không hiển thị và không tạo được PO tự động
-- ============================================================

create or replace view v_order_worklist_ops as
select
  ingredient_id,
  code,
  name,
  nom_fr,
  stock_uom,
  location_id,
  current_stock,
  reorder_point,
  safety_stock,
  avg_daily_usage,
  lead_time_days,
  alert_level,
  days_of_cover,
  supplier_name,
  purchase_uom,
  pack_size,
  moq,
  par_level,
  net_open_po_qty,
  suggested_order_qty,
  supplier_id -- MỚI: Thêm supplier_id ở cuối để tránh lỗi đổi tên cột của view trong Postgres
from v_order_worklist;

grant select on v_order_worklist_ops to authenticated;

-- Đảm bảo quyền thực thi hàm get_order_worklist_finance cho người dùng đã xác thực
grant execute on function get_order_worklist_finance() to authenticated;
