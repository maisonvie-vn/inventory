-- ============================================================
-- PATCH v3.0.8 — Sửa RPC đặt Nhà cung cấp ưu tiên nhanh từ UI
-- Sửa lỗi: null value in column "valid_from" of relation "supplier_prices" violates not-null constraint
-- ============================================================

CREATE OR REPLACE FUNCTION set_preferred_supplier(
  p_ingredient_id uuid,
  p_supplier_id   uuid
) RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
begin
  -- 1. Tắt is_preferred của tất cả các dòng khác của ingredient này
  update supplier_prices
  set is_preferred = false
  where ingredient_id = p_ingredient_id;

  -- 2. Nếu đã có dòng (ingredient_id, supplier_id) thì set is_preferred = true
  update supplier_prices
  set is_preferred = true
  where ingredient_id = p_ingredient_id and supplier_id = p_supplier_id;

  -- 3. Nếu chưa có thì chèn dòng mới với giá mặc định = 0 và valid_from = now()
  if not found then
    insert into supplier_prices (ingredient_id, supplier_id, is_preferred, price, uom, pack_size, moq, valid_from)
    values (
      p_ingredient_id,
      p_supplier_id,
      true,
      0,
      coalesce((select stock_uom from ingredients where id = p_ingredient_id), 'UNIT'),
      1,
      1,
      now()
    );
  end if;
end $$;

revoke execute on function set_preferred_supplier from public;
grant execute on function set_preferred_supplier to authenticated;
