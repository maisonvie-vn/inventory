-- ============================================================
-- RPC: get_period_stock_summary
-- Trả về tồn đầu kỳ / nhập kỳ / xuất kỳ / tồn cuối kỳ
-- cho tất cả nguyên liệu trong một khoảng thời gian
-- SECURITY DEFINER: bypass RLS trên inventory_transactions
-- ============================================================
CREATE OR REPLACE FUNCTION get_period_stock_summary(
  p_start_date date,
  p_end_date   date
)
RETURNS TABLE (
  ingredient_id     uuid,
  ingredient_code   text,
  ten_vi            text,
  nom_fr            text,
  category          text,
  stock_uom         text,
  wac_price         numeric,
  opening_qty       numeric,
  in_qty            numeric,
  out_qty           numeric,
  closing_qty       numeric,
  closing_value     numeric,
  adj_qty           numeric,
  is_beverage       boolean
) LANGUAGE SQL SECURITY DEFINER STABLE AS $$
  SELECT
    i.id                                AS ingredient_id,
    i.code                              AS ingredient_code,
    i.ten_vi,
    i.nom_fr,
    COALESCE(pc.name, 'Khác')           AS category,
    i.stock_uom,
    i.wac_price,
    -- Tồn đầu kỳ: tổng tất cả giao dịch TRƯỚC p_start_date
    COALESCE(SUM(CASE
      WHEN it.business_date < p_start_date AND it.status = 'approved'
      THEN it.qty ELSE 0
    END), 0)                            AS opening_qty,
    -- Nhập trong kỳ (IMPORT / TRANSFER_IN / STOCK_TAKE_ADJ dương)
    COALESCE(SUM(CASE
      WHEN it.business_date >= p_start_date AND it.business_date <= p_end_date
        AND it.status = 'approved'
        AND it.txn_type IN ('IMPORT', 'TRANSFER_IN')
      THEN it.qty ELSE 0
    END), 0)                            AS in_qty,
    -- Xuất trong kỳ (SALE_DEPLETION, WASTE, NON_SALE, TRANSFER_OUT, ISSUE)
    COALESCE(SUM(CASE
      WHEN it.business_date >= p_start_date AND it.business_date <= p_end_date
        AND it.status = 'approved'
        AND it.txn_type IN ('SALE_DEPLETION','WASTE','NON_SALE','TRANSFER_OUT','ISSUE')
      THEN ABS(it.qty) ELSE 0
    END), 0)                            AS out_qty,
    -- Tồn cuối kỳ (net của tất cả giao dịch đến hết p_end_date)
    COALESCE(SUM(CASE
      WHEN it.business_date <= p_end_date AND it.status = 'approved'
      THEN it.qty ELSE 0
    END), 0)                            AS closing_qty,
    -- Giá trị tồn cuối
    COALESCE(SUM(CASE
      WHEN it.business_date <= p_end_date AND it.status = 'approved'
      THEN it.qty ELSE 0
    END), 0) * i.wac_price              AS closing_value,
    -- Điều chỉnh kiểm kê trong kỳ
    COALESCE(SUM(CASE
      WHEN it.business_date >= p_start_date AND it.business_date <= p_end_date
        AND it.status = 'approved'
        AND it.txn_type = 'STOCK_TAKE_ADJ'
      THEN it.qty ELSE 0
    END), 0)                            AS adj_qty,
    i.is_beverage
  FROM ingredients i
  LEFT JOIN inventory_transactions it ON it.ingredient_id = i.id
  LEFT JOIN purchase_categories pc ON pc.id = i.purchase_category_id
  WHERE i.is_active = true OR i.is_active IS NULL
  GROUP BY i.id, i.code, i.ten_vi, i.nom_fr, pc.name, i.stock_uom, i.wac_price, i.is_beverage
  ORDER BY i.is_beverage, pc.name, i.code;
$$;

-- Grant execute to authenticated role
GRANT EXECUTE ON FUNCTION get_period_stock_summary(date, date) TO authenticated;
GRANT EXECUTE ON FUNCTION get_period_stock_summary(date, date) TO anon;
