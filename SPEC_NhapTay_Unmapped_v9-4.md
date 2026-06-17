# PHỤ LỤC ĐẶC TẢ (cho đội code) — HÀNG BÁN CHƯA CÓ CÔNG THỨC + NHẬP LIỆU THỦ CÔNG
### Maison Vie v9.4 · bổ trợ cho §14 của IMPLEMENTATION_PLAN

---

## 0. NGUYÊN TẮC XUYÊN SUỐT (đọc trước khi build)
1. **Một engine duy nhất.** Mọi giao dịch (POS import, bán tay, nhập tay, xuất tay) đi qua **cùng** hàm trừ kho/WAC/ghi sổ. Form chỉ là "đầu vào" khác nhau.
2. **Gắn `source`** mọi giao dịch: `POS`, `POS_RESOLVED`, `POS_ADHOC`, `MANUAL_SALE`, `MANUAL_GRN`, `MANUAL_ISSUE`, `ADMIN_ADJ`, `ADMIN_IMPORT`. Dùng để báo cáo variance & truy nguồn, không đổ oan.
3. **Sổ cái bất biến.** Sửa sai = **bút toán đảo (reversal)**, KHÔNG sửa/xóa lịch sử.
4. **Idempotent.** Mọi thao tác có thể chạy lại mà không trừ trùng (xem index ở §A.3).
5. **Qua RLS + audit_log.** Không có đường ghi nào "lách" phân quyền.

---

## A. TAB "HÀNG BÁN CHƯA CÓ CÔNG THỨC" (Unmapped sales worklist)

### A.1. Hành vi import (sửa lỗi popup chớp-tắt)
Khi import POS, **mỗi dòng**:
- Khớp `pos_alias_map → recipe` ⇒ `mapping_status='MAPPED'`, **trừ kho ngay**, ghi `inventory_transactions` (source=`POS`).
- Không khớp ⇒ **vẫn ghi doanh thu**, `mapping_status='UNMAPPED'`, **không trừ kho**, để trong worklist.

> ❌ BỎ popup chọn nguyên liệu hiện-rồi-tắt. ✅ Dòng chưa khớp nằm trong **tab bền**, xử lý theo nhịp người dùng.

### A.2. Giao diện tab
**Tiêu đề:** "Hàng bán chưa có công thức (chưa trừ kho)" + badge đếm số mã.
**Gom theo `pos_item_code`** (mỗi món một dòng, KHÔNG liệt kê từng lần bán):

| Cột | Nội dung |
| :-- | :-- |
| Tên món POS | vd "Ốc Bulot", "Súp Vẹm", "Mixed Salad" |
| Mã POS | mã thô từ máy POS |
| Số lần / Tổng SL | vd 5 lần · 23 phần |
| Khoảng ngày | lần đầu → gần nhất |
| Doanh thu liên quan | tổng tiền các dòng này |
| **Hành động** | 3 nút (dưới) |

**3 nút hành động / mỗi món:**
1. **[Tạo công thức + ánh xạ]** — mở trình dựng BOM (nguyên liệu + định lượng/phần) **và** tạo `pos_alias_map(pos_item_code → recipe)`. Lưu xong ⇒ **reprocess** tất cả dòng treo của món (§A.3). Dùng cho món **lặp lại**.
   - Biến thể: **[Gán vào công thức có sẵn]** — nếu chỉ là tên khác ("Mixed Salad Lg" → "Mixed Salad"), chỉ tạo alias trỏ tới recipe đã có.
2. **[Khai tiêu hao 1 lần]** — món ad-hoc không lặp: nhập nguyên liệu đã dùng cho **các dòng này thôi**, trừ kho 1 lần, KHÔNG tạo công thức vĩnh viễn.
3. **[Không ảnh hưởng kho]** — `NO_STOCK_IMPACT` (phí dịch vụ, phụ thu...). Đánh dấu xong, biến mất khỏi worklist.

**Cảnh báo nổi:** badge trên Dashboard + dòng trong `daily_report`: "N dòng bán chưa ánh xạ". Unmapped = rò rỉ variance thầm lặng.

### A.3. SQL — trạng thái, chống trừ trùng, hàm reprocess
```sql
-- (1) trạng thái trên dòng bán (đã nêu §14, nhắc lại)
alter table sale_lines add column if not exists
  mapping_status text not null default 'MAPPED'
  check (mapping_status in ('MAPPED','UNMAPPED','RESOLVED','NO_STOCK_IMPACT'));

-- (2) KHÓA CHỐNG TRỪ TRÙNG (idempotency) — mấu chốt để reprocess an toàn
create unique index if not exists ux_invtxn_ref
  on inventory_transactions (ref_type, ref_id, ingredient_id)
  where ref_type is not null;

-- (3) View worklist
create or replace view v_unmapped_sales as
select pos_item_code,
       min(business_date) as first_seen,
       max(business_date) as last_seen,
       count(*)           as line_count,
       sum(qty)           as total_qty,
       sum(line_amount)   as total_revenue
from sale_lines
where mapping_status = 'UNMAPPED'
group by pos_item_code
order by total_revenue desc;

-- (4) REPROCESS sau khi tạo công thức/alias cho 1 mã — IDEMPOTENT
create or replace function resolve_unmapped_item(p_pos_item_code text)
returns int
language plpgsql security definer set search_path=public as $func$
declare v_n int;
begin
  -- trừ kho theo công thức cho mọi dòng UNMAPPED của mã này
  insert into inventory_transactions
        (ingredient_id, qty_change, direction, source, ref_type, ref_id, created_at)
  select r.ingredient_id,
         -(sl.qty * r.qty_per_serving), 'OUT', 'POS_RESOLVED', 'SALE_LINE', sl.id, now()
  from sale_lines sl
  join pos_alias_map a on a.pos_item_code = sl.pos_item_code
  join recipes       r on r.menu_item_code = a.menu_item_code
  where sl.pos_item_code = p_pos_item_code
    and sl.mapping_status = 'UNMAPPED'
  on conflict (ref_type, ref_id, ingredient_id) do nothing;   -- chống trừ trùng

  -- (tuỳ chọn) trừ bao bì nếu TAKEAWAY — theo takeaway_packaging_map
  insert into inventory_transactions
        (ingredient_id, qty_change, direction, source, ref_type, ref_id, created_at)
  select m.packaging_id,
         -(sl.qty * m.qty_per_unit), 'OUT', 'POS_RESOLVED', 'SALE_LINE_PKG', sl.id, now()
  from sale_lines sl
  join takeaway_packaging_map m on m.pos_item_code = sl.pos_item_code
  where sl.pos_item_code = p_pos_item_code
    and sl.mapping_status = 'UNMAPPED'
    and sl.order_type = 'TAKEAWAY'
  on conflict (ref_type, ref_id, ingredient_id) do nothing;

  update sale_lines set mapping_status='RESOLVED'
  where pos_item_code = p_pos_item_code and mapping_status='UNMAPPED';
  get diagnostics v_n = row_count;
  return v_n;   -- số dòng đã xử lý
end; $func$;

-- (5) Khai tiêu hao 1 lần cho danh sách dòng (món ad-hoc)
--     p_lines = các sale_line_id;  p_consume = [{ingredient_id, qty}, ...]
create or replace function consume_adhoc(p_line_ids bigint[], p_consume jsonb)
returns void language plpgsql security definer set search_path=public as $func$
begin
  insert into inventory_transactions
        (ingredient_id, qty_change, direction, source, ref_type, ref_id, created_at)
  select (c->>'ingredient_id'),
         -((c->>'qty')::numeric), 'OUT', 'POS_ADHOC', 'SALE_LINE', lid, now()
  from unnest(p_line_ids) lid
  cross join jsonb_array_elements(p_consume) c
  on conflict (ref_type, ref_id, ingredient_id) do nothing;

  update sale_lines set mapping_status='RESOLVED' where id = any(p_line_ids);
end; $func$;
```

---

## B. FORM "BÁN THỦ CÔNG" (source = MANUAL_SALE)
Ví dụ: 3 Mix salad · 10 ốc Bulot · 3 Coke · 7 bia tươi.

**Trường nhập:**
| Trường | Ghi chú |
| :-- | :-- |
| Ngày bán | mặc định hôm nay |
| Kênh `order_type` | Tại chỗ / Mang về |
| Dòng (nhiều) | tìm món (theo tên/menu) · SL · (giá tự lấy từ `menu_prices` theo kênh, cho sửa) |

**Luồng lưu:** mỗi dòng → **cùng engine** map+trừ kho như POS. Món có công thức ⇒ trừ ngay (source=`MANUAL_SALE`). Món **chưa có công thức** ⇒ vào đúng **worklist §A** (UNMAPPED) — không chặn người dùng.

**Chống trừ trùng (BẮT BUỘC):** trước khi lưu, **cảnh báo** nếu `(ngày × món)` đã có dữ liệu từ POS import. Quy tắc: một `(business_date, item)` chỉ **một nguồn** (manual *hoặc* import). Cho phép ghi đè có chủ đích nhưng phải cảnh báo.

---

## C. FORM "NHẬP KHO THỦ CÔNG" (source = MANUAL_GRN)
Song song với import Excel mua hàng.

**Trường nhập:**
| Trường | Ghi chú |
| :-- | :-- |
| Nhà cung cấp · Số hóa đơn · Ngày nhận | bắt buộc |
| (tuỳ chọn) Gắn PO | để 3-way match nếu có |
| Dòng (nhiều) | mã NVL · SL · đơn vị · đơn giá · cước VC · thuế |

**Luồng lưu:** tạo `goods_receipts` → `grn_lines` → `lots` → `inventory_transactions` (IN) → **phân bổ landed cost + cập nhật Moving WAC** (đúng công thức §2 nhật ký 16/06). source=`MANUAL_GRN`.
**Chống trùng:** dedup theo `(supplier_id, invoice_no)` — không nhập 2 lần cùng hóa đơn.

---

## D. FORM "XUẤT KHO THỦ CÔNG" (source = MANUAL_ISSUE) — HỎI LÝ DO
**Trường nhập:** Ngày · **Lý do** (bắt buộc) · Dòng (mã · SL · location · ghi chú).

**Định tuyến theo lý do → đúng sổ:**
| Lý do | Ghi vào | Ghi chú |
| :-- | :-- | :-- |
| Hủy/Hỏng | `waste_logs` + txn OUT | hàng giá trị cao (rượu) có thể cần duyệt |
| Cơm NV / Biếu / Test | `non_sale_consumption` + txn OUT | |
| Chuyển kho | `stock_transfers` (**2 chân**: OUT nguồn + IN đích) | cân bằng |
| Sản xuất BTP | production + txn OUT (nguyên liệu) / IN (BTP) | |
| Điều chỉnh | `stock_adjustments` (STOCK_TAKE_ADJ) | reversal, không sửa lịch sử |

---

## E. MA TRẬN QUYỀN (ai được nhập tay)
| Hành động | Owner/CFO/Admin | Manager | Thủ kho | Kế toán | Chef | Bar |
| :-- | :--: | :--: | :--: | :--: | :--: | :--: |
| Giải quyết Unmapped / tạo công thức | ✔ | ✔ | – | ✔ | ✔(bếp) | ✔(bar) |
| Bán thủ công | ✔ | ✔ | – | ✔ | – | ✔(bar) |
| Nhập kho thủ công (GRN) | ✔ | ✔ | ✔ | ✔ | – | – |
| Xuất kho thủ công | ✔ | ✔ | ✔ | – | ✔(bếp) | ✔(bar) |
*(Bar/Chef chỉ thao tác trong scope bộ phận của mình — §C.6.)*

---

## F. CHECKLIST NGHIỆM THU (dev tự kiểm)
1. Import POS có dòng lạ ("Ốc Bulot") → **không đóng popup mất**, dòng vào tab Unmapped, doanh thu vẫn ghi, **chưa trừ kho**.
2. Bấm **[Tạo công thức]** cho Ốc Bulot → tất cả dòng treo của nó **được trừ kho**, chuyển `RESOLVED`; chạy lại reprocess **không trừ trùng** (nhờ `ux_invtxn_ref`).
3. **[Khai 1 lần]** trừ đúng nguyên liệu đã nhập, dòng chuyển `RESOLVED`.
4. **[Không ảnh hưởng kho]** → dòng rời worklist, không sinh txn.
5. Bán thủ công 7 bia tươi → trừ kho theo công thức, `source=MANUAL_SALE`; nếu (ngày×bia) đã có từ POS → **cảnh báo trùng**.
6. Nhập kho thủ công → WAC cập nhật đúng landed cost; nhập lại cùng số HĐ → **chặn trùng**.
7. Xuất kho thủ công mỗi lý do → ghi đúng sổ tương ứng + txn OUT; chuyển kho sinh **2 chân**.
8. Mọi thao tác trên hiện trong `audit_log` với `source` đúng; sửa sai chỉ bằng **reversal**.
9. Badge "N dòng chưa ánh xạ" hiện trên Dashboard + email `daily_report`.
