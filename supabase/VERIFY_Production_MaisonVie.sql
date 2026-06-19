-- =====================================================================
-- MAISON VIE — KIỂM THỬ TỰ ĐỘNG HÓA & TRÌNH DUYỆT BÚT TOÁN (VERIFY SCRIPT)
-- Đảm bảo: Triggers hoạt động, Moving WAC chính xác, Landed Cost phân bổ đều, FEFO hoạt động
-- Lưu ý: Thực hiện kiểm thử trong Transaction và ROLLBACK để không bẩn DB chạy thật.
-- =====================================================================

DO $$
DECLARE
  v_test_ing_id uuid;
  v_grn_id uuid;
  v_lot_count int;
  v_txn_count int;
  v_wac numeric;
  v_landed_cost numeric;
  v_remaining numeric;
  v_verify_failed boolean := false;
BEGIN
  RAISE NOTICE '=== KHỞI CHẠY KIỂM THỬ HỆ THỐNG MỘT CỬA (PRODUCTION CHECKPOINT) ===';

  -- 1. Tạo dữ liệu giả lập cho nguyên liệu
  INSERT INTO ingredients (
    code, ten_vi, nom_fr, name_en, stock_uom, wac_price, standard_price, track_lot, yield_rate
  ) VALUES (
    'ING-TEST-VERIFY', 'Nguyên Liệu Kiểm Thử', 'Ing Test Verify', 'Ing Test Verify', 'KG', 100000, 100000, true, 100.00
  ) RETURNING id INTO v_test_ing_id;

  RAISE NOTICE '1. Tạo NVL kiểm thử thành công: %', v_test_ing_id;

  -- 2. Tạo chứng từ Goods Receipt (GRN) để kiểm tra Landed Cost & Trigger nhập kho
  INSERT INTO goods_receipts (
    supplier_id, invoice_no, invoice_amount, fx_rate, duty, freight, status, match_status, business_date, approved_by
  ) VALUES (
    '90000000-0000-0000-0000-000000000001', -- An Nam Supplier
    'INV-TEST-9999',
    1000000, -- Tổng hóa đơn
    1.0,
    50000,   -- Thuế NK
    50000,   -- Cước vận chuyển
    'pending',
    'APPROVED',
    current_date,
    '00000000-0000-0000-0000-000000000000'::uuid
  ) RETURNING id INTO v_grn_id;

  -- Tạo dòng line cho GRN
  INSERT INTO grn_lines (
    grn_id, ingredient_id, qty_received, purchase_uom, unit_price_fx
  ) VALUES (
    v_grn_id, v_test_ing_id, 10.0000, 'kg', 90000
  );

  -- 3. Phê duyệt nhận hàng để kích hoạt trigger trg_goods_receipt_approve_trigger
  UPDATE goods_receipts
  SET status = 'approved'
  WHERE id = v_grn_id;

  -- Kiểm tra Landed Cost đơn giá nhập kho
  -- Công thức Landed Cost: (qty * price * fx + (duty + freight) * proportion) / qty
  -- Ở đây: (10 * 90000 * 1.0 + (50000 + 50000) * 1.0) / 10 = (900000 + 100000) / 10 = 100000đ
  SELECT landed_unit_cost INTO v_landed_cost
  FROM grn_lines
  WHERE grn_id = v_grn_id AND ingredient_id = v_test_ing_id;

  IF v_landed_cost <> 100000 THEN
    RAISE WARNING '-> THẤT BẠI: Tính Landed Cost sai. Thực tế: %, Kỳ vọng: 100000', v_landed_cost;
    v_verify_failed := true;
  ELSE
    RAISE NOTICE '-> THÀNH CÔNG: Landed Cost phân bổ chính xác: %đ/kg', v_landed_cost;
  END IF;

  -- Kiểm tra WAC di động (Moving WAC)
  -- WAC mới: (0 * 100000 (tồn cũ = 0) + 10 * 100000 (nhập mới)) / 10 = 100000đ
  SELECT wac_price INTO v_wac
  FROM ingredients
  WHERE id = v_test_ing_id;

  IF v_wac <> 100000 THEN
    RAISE WARNING '-> THẤT BẠI: Cập nhật Moving WAC sai. Thực tế: %, Kỳ vọng: 100000', v_wac;
    v_verify_failed := true;
  ELSE
    RAISE NOTICE '-> THÀNH CÔNG: Moving WAC cập nhật chính xác: %đ/kg', v_wac;
  END IF;

  -- Kiểm tra xem Lô (Lots) đã tự động sinh chưa
  SELECT count(*), coalesce(sum(qty_remaining), 0) INTO v_lot_count, v_remaining
  FROM lots
  WHERE ingredient_id = v_test_ing_id;

  IF v_lot_count <> 1 OR v_remaining <> 10.0000 THEN
    RAISE WARNING '-> THẤT BẠI: Tự động tạo lô kiểm hàng (lots) sai. Số lô: %, Số lượng: %', v_lot_count, v_remaining;
    v_verify_failed := true;
  ELSE
    RAISE NOTICE '-> THÀNH CÔNG: Lô hàng FEFO được tạo đúng: % lô, tổng lượng % kg', v_lot_count, v_remaining;
  END IF;

  -- 4. Thực hiện khấu trừ kho bằng FEFO (deplete_stock_fefo) thông qua non_sale_consumption
  INSERT INTO non_sale_consumption (
    ingredient_id, qty, business_date, reason, consumption_type, created_by, note
  ) VALUES (
    v_test_ing_id, 4.0000, current_date, 'TRAINING', 'TRAINING', '00000000-0000-0000-0000-000000000000'::uuid, 'Mẫu thử cho lớp học bar'
  );

  -- Kiểm tra lượng còn lại trong lô
  SELECT sum(qty_remaining) INTO v_remaining
  FROM lots
  WHERE ingredient_id = v_test_ing_id;

  IF v_remaining <> 6.0000 THEN
    RAISE WARNING '-> THẤT BẠI: Trừ lô FEFO bị sai. Lượng còn lại thực tế: %, Kỳ vọng: 6.0000', v_remaining;
    v_verify_failed := true;
  ELSE
    RAISE NOTICE '-> THÀNH CÔNG: Trừ lô FEFO hoạt động chuẩn xác. Lượng còn lại: % kg', v_remaining;
  END IF;

  -- Kiểm tra sổ cái inventory_transactions
  SELECT count(*) INTO v_txn_count
  FROM inventory_transactions
  WHERE ingredient_id = v_test_ing_id;

  -- Kỳ vọng 2 giao dịch: 1 IMPORT (+10) và 1 NON_SALE (-4)
  IF v_txn_count <> 2 THEN
    RAISE WARNING '-> THẤT BẠI: Sổ cái ghi nhận sai số lượng giao dịch. Giao dịch thực tế: %', v_txn_count;
    v_verify_failed := true;
  ELSE
    RAISE NOTICE '-> THÀNH CÔNG: Sổ cái ghi nhận đầy đủ 2 bút toán: IMPORT (+10) và NON_SALE (-4)';
  END IF;

  -- 5. KẾT LUẬN & ĐẶT CHECKPOINT VERIFY = 0
  IF v_verify_failed THEN
    RAISE EXCEPTION '=== THẤT BẠI: Hệ thống tự động hóa có lỗi! Hủy bỏ giao dịch. ===';
  ELSE
    RAISE NOTICE '=== THÀNH CÔNG: Checkpoint verify = 0. Mọi bài kiểm tra đã vượt qua! ===';
  END IF;

  -- Luôn ROLLBACK để dữ liệu kiểm thử không đi vào cơ sở dữ liệu thật
  RAISE NOTICE '=== HỦY BỎ TRANSACTION (ROLLBACK) ĐỂ GIỮ DB SẠCH SẼ ===';
  RAISE EXCEPTION 'ROLLBACK_REQUIRED';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLERRM = 'ROLLBACK_REQUIRED' THEN
      RAISE NOTICE '-> Giao dịch đã được hủy thành công (Rollback OK).';
    ELSE
      RAISE EXCEPTION 'Lỗi ngoài dự kiến: %', SQLERRM;
    END IF;
END $$;
