# KẾ HOẠCH TRIỂN KHAI HỆ THỐNG CRM/ERP INVENTORY – MAISON VIE **v7.0**
### (BẢN NÂNG CẤP CHUYÊN NGHIỆP – ĐÃ SỬA LỖI NGHIỆP VỤ & TỐI ƯU CHI PHÍ)

> **Vai trò biên soạn**: COO / CFO / Kiến trúc sư Dữ liệu Full-Stack
> **Dự án**: Hệ thống CRM/ERP Quản lý Kho & Định mức tự động hóa cho nhà hàng Pháp Maison Vie.
> **Hạ tầng**: Supabase (PostgreSQL / Auth / RLS / pg_cron / Storage) + Vercel (Next.js / React) + GitHub (private).
> **Nguyên tắc nền tảng v7**: *"Database-centric, serverless-thin"* — toàn bộ logic nghiệp vụ nặng nằm trong PostgreSQL, chạy bằng `pg_cron` ngay trong Supabase; Vercel chỉ render UI và API mỏng. Mục tiêu: chính xác về số liệu **và** giữ chi phí vận hành ở mức tối thiểu (~20–25$/tháng, không phát sinh dịch vụ trả phí mới).

---

## 0. CHANGELOG – ĐIỂM KHÁC SO VỚI v6.0

| # | Hạng mục | v6.0 (cũ) | v7.0 (nâng cấp) |
| :-- | :-- | :-- | :-- |
| 1 | Công thức trừ kho | Có hệ số ×1.10 → **đếm trùng hao hụt** | **Bỏ ×1.10**. Variance trở thành công cụ phát hiện thật. |
| 2 | WAC | Chốt cứng 18h30 | **Moving WAC theo từng lần nhập (per-receipt)**; 18h30 chỉ còn là *snapshot báo cáo*. |
| 3 | Phân quyền tài chính | RLS row-level mâu thuẫn | **Lớp VIEW + column privilege**: chỉ CFO/Owner/Admin thấy doanh thu & tiền. |
| 4 | Job hẹn giờ | Không nói cơ chế | **pg_cron + advisory lock + idempotency + watchdog cảnh báo email.** |
| 5 | Nhà cung cấp | Thiếu | Thêm `suppliers`, `supplier_ingredients` (giá, lead time, MOQ, pack size). |
| 6 | Đơn vị tính | Thiếu | Thêm lớp `uom` + `uom_conversions` (mua → tồn → công thức). |
| 7 | Nhận hàng | Bỏ qua | **Goods Receipt + 3-way match** (PO ↔ GRN ↔ Hóa đơn). |
| 8 | Tồn đầu kỳ | Không có | **Kiểm kê khởi tạo** bắt buộc ở Giai đoạn 1. |
| 9 | Auto-PO | `max − tồn` (ngây thơ) | Có lead time, net PO đang mở, MOQ, làm tròn pack, gom theo NCC. |
| 10 | Tiêu thụ ngoài bán | Không có | Thêm `non_sale_consumption` (cơm NV, comp, R&D, training). |
| 11 | Lô/Hạn dùng | Không có | **Lot/Batch + FEFO + cảnh báo HACCP cận date.** |
| 12 | Hàng nhập khẩu | Giá hóa đơn đơn thuần | **Landed cost** (giá + tỷ giá + thuế + cước). |
| 13 | Nhập POS | Upload Excel thủ công | **Giữ nguyên upload thủ công** (theo yêu cầu) nhưng có **dedupe chống nhập trùng**. |
| 14 | Mapping POS | Modal đếm ngược 30s | **Bảng alias học được (persistent)** — khớp 1 lần, tự động mãi mãi. |
| 15 | Đối soát | Mờ nhạt | Phân hệ **Variance + Menu Engineering** đầy đủ. |
| 16 | Bar | Như bếp | Kiểm soát riêng: **chai mở, rót ly (BTG), pour variance.** |
| 17 | Sổ giao dịch | Cho sửa/xóa | **Ledger bất biến (append-only) + bút toán đảo + máy trạng thái khóa sổ.** |

---

## 1. KIẾN TRÚC & NGUYÊN TẮC THIẾT KẾ

**1.1. Phân tầng theo chi phí (cost-aware layering).**
- **Tầng dữ liệu + nghiệp vụ (Supabase/Postgres)**: chứa schema, RLS, **toàn bộ hàm tính toán** (WAC, trừ kho, Auto-PO, variance) viết bằng **PL/pgSQL**, và các job chạy bằng **`pg_cron`** *ngay trong database*. → Không cần Edge Function trả phí theo lượt gọi, không cần scheduler bên thứ ba.
- **Tầng giao diện (Vercel/Next.js)**: chỉ render UI + một số API route mỏng có kiểm tra auth. **Việc đọc/parse file Excel POS được thực hiện ngay trên trình duyệt** (thư viện SheetJS), chỉ gửi JSON đã cấu trúc về Supabase qua RPC. → Giảm tối đa thời gian thực thi serverless (phần bị tính tiền của Vercel).
- **Tầng mã nguồn (GitHub private)**: CI nhẹ, deploy qua tích hợp Git gốc của Vercel (không tốn phút Actions).

**1.2. Nguyên tắc toàn vẹn dữ liệu.** Mọi thay đổi tồn kho đi qua **một sổ cái duy nhất, append-only** (`inventory_transactions`). Sửa sai = ghi **bút toán đảo**, không bao giờ UPDATE/DELETE bản ghi gốc. Đây là nền tảng để Dashboard tài chính và kiểm toán tin cậy được.

**1.3. Nguyên tắc một nguồn sự thật cho hao hụt.** Tồn lý thuyết **không** được "đoán trước" hao hụt. Hao hụt chỉ đến từ ba nguồn *được ghi nhận thật*: `waste_logs`, `non_sale_consumption`, và yield sơ chế cố định trong công thức. Phần còn lại lệch ra khi kiểm kê chính là **variance cần điều tra** — đó mới là giá trị cốt lõi của hệ thống.

---

## 2. THIẾT KẾ CSDL PHẲNG NÂNG CẤP

### 2.1. Nhóm Master (danh mục gốc)

```sql
-- Đơn vị tính & quy đổi (MỚI – fix lỗi #6)
create table uom (
  id            text primary key,          -- 'KG','G','L','ML','BOTTLE','CASE','PIECE'
  name          text not null,
  uom_type      text not null              -- 'WEIGHT','VOLUME','COUNT'
);

create table uom_conversions (
  from_uom      text references uom(id),
  to_uom        text references uom(id),
  factor        numeric not null,          -- 1 from_uom = factor * to_uom
  primary key (from_uom, to_uom)
);
-- VD: ('KG','G',1000), ('CASE','BOTTLE',6), ('L','ML',1000)

-- Nhà cung cấp (MỚI – fix lỗi #5)
create table suppliers (
  id            uuid primary key default gen_random_uuid(),
  name          text not null,
  category_id   uuid references purchase_categories(id),
  contact       jsonb,
  lead_time_days int not null default 1,    -- phục vụ Auto-PO
  cutoff_time   time,                       -- giờ chốt nhận đơn trong ngày
  is_active     boolean default true
);

-- Giá & điều kiện theo từng NCC (MỚI)
create table supplier_ingredients (
  supplier_id     uuid references suppliers(id),
  ingredient_id   uuid references ingredients(id),
  purchase_uom    text references uom(id),  -- đơn vị MUA (CASE, KG...)
  pack_size       numeric not null default 1, -- 1 đơn vị mua = pack_size stock_uom
  moq             numeric not null default 1, -- số lượng đặt tối thiểu (theo purchase_uom)
  last_price_fx   numeric,                  -- giá theo ngoại tệ gốc (nếu nhập khẩu)
  currency        text default 'VND',
  is_preferred    boolean default false,    -- NCC ưu tiên khi Auto-PO
  primary key (supplier_id, ingredient_id)
);

-- Nguyên vật liệu (CẬP NHẬT)
create table ingredients (
  id            uuid primary key default gen_random_uuid(),
  code          text unique not null,       -- ING-011...
  name          text not null,
  category_id   uuid references purchase_categories(id),
  stock_uom     text references uom(id),    -- đơn vị TỒN chuẩn
  recipe_uom    text references uom(id),    -- đơn vị dùng trong công thức
  wac_price     numeric default 0,          -- giá vốn bình quân gia quyền (landed)
  min_stock     numeric default 0,
  max_stock     numeric default 0,
  safety_stock  numeric default 0,          -- MỚI: tồn an toàn cho Auto-PO
  is_import     boolean default false,      -- MỚI: cờ hàng nhập khẩu (landed cost)
  track_lot     boolean default false,      -- MỚI: bật theo dõi lô/hạn (FEFO)
  is_beverage   boolean default false,      -- MỚI: phân loại bar
  auto_po_group text default 'MANUAL_REQUISITION' -- 'AUTO_PO' | 'MANUAL_REQUISITION'
);
```

### 2.2. Nhóm Công thức & Món

`menu_items`, `set_menu_items`, `recipes` giữ cấu trúc v6 nhưng `recipes` bổ sung:
- `qty_net` (lượng tịnh), `yield_rate` (%), **`recipe_uom`** rõ ràng để quy đổi đúng đơn vị.
- **Bỏ mọi tham số "bù hao 10%"** khỏi recipe — hao bù không thuộc về định mức.

### 2.3. Nhóm Giao dịch (transactional)

```sql
-- SỔ CÁI BẤT BIẾN (CẬP NHẬT – fix lỗi #17)
create table inventory_transactions (
  id            bigint generated always as identity primary key,
  ingredient_id uuid references ingredients(id),
  txn_type      text not null,   -- 'IMPORT','SALE_DEPLETION','WASTE','NON_SALE','STOCK_TAKE_ADJ','REVERSAL'
  qty           numeric not null,           -- theo stock_uom (âm = xuất)
  unit_cost     numeric,                    -- WAC tại thời điểm ghi
  lot_id        uuid,                       -- liên kết lô (nếu track_lot)
  ref_table     text, ref_id bigint,        -- nguồn gốc (grn, sales_import, waste_log...)
  reverses_id   bigint references inventory_transactions(id), -- bút toán đảo trỏ về gốc
  business_date date not null,              -- ngày kế toán
  created_at    timestamptz default now(),
  created_by    uuid references profiles(id)
);
-- KHÔNG cấp quyền UPDATE/DELETE cho bất kỳ role nào trên bảng này.

-- Đơn đặt hàng (MỚI)
create table purchase_orders (
  id uuid primary key default gen_random_uuid(),
  supplier_id uuid references suppliers(id),
  status text default 'OPEN',  -- 'OPEN','PARTIAL','RECEIVED','CLOSED','CANCELLED'
  source text default 'AUTO_PO', -- 'AUTO_PO','MANUAL_REQUISITION'
  expected_date date,
  created_at timestamptz default now()
);
create table po_lines (
  po_id uuid references purchase_orders(id),
  ingredient_id uuid references ingredients(id),
  qty_ordered numeric, qty_received numeric default 0,
  purchase_uom text references uom(id)
);

-- NHẬN HÀNG + 3-WAY MATCH (MỚI – fix lỗi #7)
create table goods_receipts (
  id uuid primary key default gen_random_uuid(),
  po_id uuid references purchase_orders(id),  -- null nếu mua chợ/khẩn
  supplier_id uuid references suppliers(id),
  invoice_no text, invoice_amount numeric, currency text default 'VND',
  fx_rate numeric default 1, duty numeric default 0, freight numeric default 0, -- landed cost
  match_status text default 'PENDING', -- 'PENDING','MATCHED','VARIANCE','APPROVED'
  status text default 'pending',       -- workflow duyệt
  received_by uuid, approved_by uuid, business_date date
);
create table grn_lines (
  grn_id uuid references goods_receipts(id),
  ingredient_id uuid references ingredients(id),
  qty_received numeric, purchase_uom text,
  unit_price_fx numeric,
  landed_unit_cost numeric  -- tính khi duyệt: (giá*fx + phân bổ duty+freight)/qty_stock_uom
);

-- LÔ/HẠN DÙNG cho FEFO (MỚI – fix lỗi #11)
create table lots (
  id uuid primary key default gen_random_uuid(),
  ingredient_id uuid references ingredients(id),
  grn_id uuid references goods_receipts(id),
  qty_remaining numeric, expiry_date date,
  received_at timestamptz default now()
);

-- TIÊU THỤ NGOÀI BÁN HÀNG (MỚI – fix lỗi #10)
create table non_sale_consumption (
  id bigint generated always as identity primary key,
  ingredient_id uuid references ingredients(id),
  qty numeric, consumption_type text, -- 'STAFF_MEAL','COMP','R&D','TRAINING','EVENT'
  business_date date, created_by uuid, note text
);

-- BẢNG ALIAS HỌC ĐƯỢC (MỚI – fix lỗi #14)
create table pos_alias_map (
  pos_code text primary key,        -- mã/tên xuất hiện trong file POS
  menu_item_id uuid references menu_items(id),
  confidence numeric default 100,
  confirmed_by uuid, confirmed_at timestamptz default now()
);

-- KIỂM KÊ (MỚI – phục vụ tồn đầu kỳ #8 + cycle count #15)
create table stock_takes (
  id uuid primary key default gen_random_uuid(),
  take_type text, -- 'OPENING','FULL','CYCLE'
  business_date date, status text default 'OPEN', -- 'OPEN','COUNTING','POSTED'
  frozen_snapshot jsonb -- chốt tồn lý thuyết tại thời điểm đếm (chống race)
);
create table stock_take_lines (
  take_id uuid references stock_takes(id),
  ingredient_id uuid references ingredients(id),
  qty_physical numeric, qty_theoretical numeric, variance numeric
);

-- KHÓA SỔ NGÀY – máy trạng thái (MỚI – fix lỗi #17)
create table daily_close (
  business_date date primary key,
  status text default 'OPEN', -- 'OPEN','WAC_DONE','CONSUMPTION_DONE','PO_DONE','LOCKED'
  locked_at timestamptz, locked_by uuid
);

-- NHẬT KÝ KIỂM TOÁN (MỚI)
create table audit_log (
  id bigint generated always as identity primary key,
  actor uuid, action text, entity text, entity_id text,
  before_data jsonb, after_data jsonb, at timestamptz default now()
);
```

`waste_logs`, `sales_imports` giữ như v6; `sales_imports` thêm cột `file_hash` (chống nhập trùng) và `void_qty`/`comp_qty` để loại giao dịch hủy/khuyến mãi khỏi phần trừ kho bán hàng.

---

## 3. MA TRẬN PHÂN QUYỀN 7 CẤP + LỚP TÀI CHÍNH

**Nguyên tắc mới (fix lỗi #3):** RLS của Postgres chỉ lọc theo *dòng*, không giấu được *cột tiền*. Vì vậy v7 tách dữ liệu thành **hai lớp truy cập qua VIEW**:

- **`v_inventory_ops`** (vận hành, **không có** cột tiền: WAC, giá trị VND, doanh thu) → cho Cấp 2, 3, 5, 6, 7.
- **`v_inventory_finance`** (đầy đủ doanh thu + giá trị tiền) → **chỉ** Cấp 1.
- **`v_inventory_cost`** (có WAC/giá vốn nhưng **không có doanh thu**) → Cấp 4 (kế toán cần giá vốn để đối soát WAC & xuất PO, nhưng **không thấy doanh thu**).

> *Giả định cần bạn xác nhận:* theo yêu cầu "chỉ CFO/Owner/Admin biết **doanh thu**", tôi diễn giải: **doanh thu & lợi nhuận/Food Cost quy ra tiền = chỉ Cấp 1**; còn **giá vốn/WAC** vẫn mở cho Cấp 4 (nếu không, kế toán không thể làm WAC & Auto-PO). Nếu bạn muốn giấu cả giá vốn khỏi Cấp 4, chỉ cần đổi `v_inventory_cost` → ẩn nốt cột WAC.

| Cấp | Vai trò | VIEW được cấp | SELECT | INSERT | UPDATE | DELETE | Quyền hạn |
| :-- | :-- | :-- | :-: | :-: | :-: | :-: | :-- |
| **1** | Admin (CFO/Owner) | `v_inventory_finance` | ✔ tất cả | ✔ | ✔ | ✔ | **Duy nhất** thấy doanh thu, giá trị kho VND, Food Cost %, biến động tiền. |
| **2** | Quản lý NH | `v_inventory_ops` | Số lượng (không tiền) | Giao dịch | Giao dịch | ✘ | Vận hành kho, duyệt waste giá trị lớn (duyệt theo *số lượng*, không thấy tiền). |
| **3** | Bếp trưởng | `v_inventory_ops` (lọc kho bếp) | Tiêu thụ bếp | Định mức | Định mức | ✘ | Sửa `recipes`, `yield_rate`. Không thấy tiền. |
| **4** | KT kho cấp cao | `v_inventory_cost` | Số lượng + **giá vốn** (không doanh thu) | PO, WAC, GRN | PO, WAC, GRN | ✘ | Đối soát WAC, 3-way match, duyệt Auto-PO. |
| **5** | Giám sát Sảnh | `v_inventory_ops` (menu/POS) | Menu/POS | ✘ | ✘ | ✘ | Đối chiếu mã POS lỗi. Không tiền, không NVL. |
| **6** | Bếp phó | `v_inventory_ops` (khai báo) | Khai báo | Waste, Manual PO, Non-sale | ✘ | ✘ | Tạo waste log, requisition hàng chợ, khai cơm NV/R&D. |
| **7** | Thủ kho/KT phụ | `v_inventory_ops` (xem) | Xem | Hóa đơn `pending` | ✘ | ✘ | Nhập hóa đơn mua lẻ chờ Cấp 4 duyệt. |

RLS thực thi bằng `auth.jwt() ->> 'role'`; quyền truy cập VIEW cấp bằng `GRANT SELECT ON v_xxx TO role_yyy` và thu hồi quyền trực tiếp trên bảng gốc.

---

## 4. LOGIC NGHIỆP VỤ ĐÃ SỬA & NÂNG CẤP

### A. Moving WAC theo từng lần nhập + Landed Cost (fix #2, #12)

WAC **được tính lại ngay tại mỗi lần duyệt Goods Receipt**, không chờ 18h30:

```
landed_unit_cost = (qty * unit_price_fx * fx_rate + phân_bổ_duty + phân_bổ_freight)
                   / qty_quy_đổi_về_stock_uom

new_wac = (qty_tồn * wac_hiện_tại + qty_nhập * landed_unit_cost)
          / (qty_tồn + qty_nhập)
```

- `phân_bổ_duty/freight`: chia thuế nhập & cước theo tỷ trọng giá trị từng dòng GRN.
- Hàng nhập (`is_import = true`) lưu cả `currency` + `fx_rate` để truy vết.
- **18h30 chỉ còn là mốc snapshot báo cáo** (`daily_close.status = WAC_DONE`): chụp lại giá trị tồn để dựng báo cáo, **không** dùng để định giá giao dịch.

### B. Trừ kho tự động 22h30 – CÔNG THỨC ĐÃ SỬA (fix #1, #10)

> **Thay đổi cốt lõi: BỎ hệ số ×1.10.** Tồn lý thuyết không tự "đoán" hao hụt nữa.

```
-- Phần 1: Trừ theo doanh số bán (đã phân rã Set Menu theo portion_ratio)
gross_qty = qty_net / (yield_rate / 100)        -- quy đổi qua recipe_uom → stock_uom
sale_depletion = Σ ( gross_qty * qty_sold_đã_loại_void_comp )

-- Phần 2: Hao hụt THỰC được ghi nhận (không phải ước lượng)
waste = Σ waste_logs (đã duyệt, trong ngày)
non_sale = Σ non_sale_consumption (cơm NV, comp, R&D, training, event)

-- Tổng tiêu thụ lý thuyết trong ngày
theoretical_consumption = sale_depletion + waste + non_sale

-- Tồn lý thuyết cuối ngày
closing_theoretical = opening + receipts − theoretical_consumption
```

**Variance** (chỉ lộ ra khi kiểm kê) `= closing_theoretical − qty_physical`. Phần lệch này **chính là** thứ cần điều tra (over-portion, rơi vãi không ghi, thất thoát). Hệ số 1.10 cũ đã che mất đúng tín hiệu này — nay đã loại bỏ.

Trừ kho theo **FEFO**: nếu `track_lot = true`, trừ lần lượt từ lô có `expiry_date` sớm nhất.

### C. Auto-PO 22h40 – CÔNG THỨC NÂNG CẤP (fix #9)

```
projected_on_hand = tồn_lý_thuyết_hiện_tại
                    + Σ PO_đang_mở_về_trước_lead_time
                    − dự_báo_tiêu_thụ_trong_lead_time

Nếu projected_on_hand < safety_stock  →  kích hoạt đặt hàng:
  order_up_to   = max_stock
  qty_raw       = order_up_to − projected_on_hand
  qty_final     = roundup_to_pack( max(qty_raw, moq_nếu_kích_hoạt), pack_size )
```

- **Net trừ PO đang mở** → không đặt trùng.
- **Tôn trọng MOQ + pack_size** của từng NCC → không ra số lẻ vô nghĩa.
- Gom theo **`supplier_id` (NCC ưu tiên)**, không gom theo danh mục, → mỗi NCC một file PO độc lập tải về lúc 7h00 sáng.
- `dự_báo_tiêu_thụ` giai đoạn đầu = trung bình động 14 ngày; có thể nâng cấp gắn số đặt bàn sau.

### D. Mapping POS học được – BỎ modal đếm ngược (fix #14)

1. Khi kế toán upload Excel POS (parse **ngay trên trình duyệt** bằng SheetJS):
   - Tra `pos_alias_map`: mã đã từng khớp → **tự gán 100%, không hỏi lại** 🟢.
   - Mã mới → chạy Levenshtein gợi ý 🟡 kèm % (vd "Angus Ribeye – 92%"), kế toán xác nhận **một lần** → ghi vào `pos_alias_map` để **mãi mãi tự khớp**.
2. **Bỏ countdown 30 giây** (rủi ro auto-commit sai dữ liệu tài chính). Người dùng chủ động bấm **"Chốt ghi sổ"**.
3. Mỗi file có `file_hash`; **upload trùng bị chặn** → chống trừ kho hai lần (rất quan trọng vì giữ quy trình thủ công).

### E. FEFO / Lô – Hạn dùng + HACCP (fix #11)

- Mỗi lần nhận hàng tạo `lots` với `expiry_date`.
- Job sáng quét lô **cận date** (vd còn ≤ 2 ngày) → cảnh báo email cho Bếp phó/Quản lý + đánh dấu ưu tiên dùng.
- Truy xuất nguồn gốc theo lô phục vụ an toàn thực phẩm (HACCP) — đặc biệt cho cá/bò nhập giá trị cao.

### F. Variance & Menu Engineering (fix #15)

- **Variance report** theo từng mã: tồn lý thuyết vs vật lý, top mã lệch lớn nhất, xu hướng tuần, quy ra tiền (**chỉ Cấp 1/Cấp 4 theo phân quyền**).
- **Menu Engineering**: ghép `recipes` × `wac_price` × doanh số → ma trận **Stars / Plowhorses / Puzzles / Dogs** (độ phổ biến × biên lợi nhuận) giúp Owner quyết định giữ/bỏ/định giá lại món. Dữ liệu đã có sẵn → gần như miễn phí về hạ tầng.

### G. Kiểm soát Bar/Đồ uống riêng (fix #16)

- Phân biệt **chai nguyên** vs **chai đang mở**; rượu theo niên vụ.
- Theo dõi **rót theo ly (BTG)** & **pour variance** của rượu mạnh (khu vực thất thoát cao nhất): so dung tích lý thuyết đã rót vs lượng giảm thực của chai.

### H. Goods Receipt 3-way match (fix #7)

Khi nhận hàng: khớp **PO ↔ GRN ↔ Hóa đơn**. Lệch số lượng/giá → trạng thái `VARIANCE`, chặn ghi tăng kho cho đến khi Cấp 4 duyệt. Chỉ khi `APPROVED` mới sinh `inventory_transactions (IMPORT)` + cập nhật WAC + tạo `lots`.

### I. Khóa sổ ngày – máy trạng thái (fix #17)

`OPEN → WAC_DONE (18h30) → CONSUMPTION_DONE (22h30) → PO_DONE (22h40) → LOCKED`. Sau `LOCKED`, **không cho backdating**; sửa sai chỉ qua **bút toán đảo** vào ngày hiện tại. Khóa sổ tháng tương tự để bảo vệ số liệu kế toán.

---

## 5. ĐỘ TIN CẬY VẬN HÀNH JOB (fix #4)

| Cơ chế | Cách làm trên Supabase | Mục đích |
| :-- | :-- | :-- |
| Lập lịch | `pg_cron` (18:30 / 22:30 / 22:40, theo timezone Asia/Ho_Chi_Minh) | Không cần scheduler ngoài. |
| Chống chạy trùng | `pg_advisory_xact_lock(business_date)` | Hai tiến trình không trừ kho cùng lúc. |
| Idempotency | Kiểm `daily_close.status` trước khi chạy; mỗi ngày mỗi bước **chỉ chạy 1 lần** | Job lỡ chạy lại không trừ kho gấp đôi. |
| Watchdog | Job 23h00 kiểm "các bước đã `DONE` chưa?" → nếu thiếu, **gửi email cảnh báo** | Phát hiện job fail im lặng. |
| Cảnh báo | Resend (free 3.000 email/tháng) hoặc SMTP Supabase | Không phát sinh dịch vụ trả phí. |

---

## 6. TỐI ƯU CHI PHÍ VẬN HÀNH (≤ 25$/tháng, không phát sinh dịch vụ mới)

### 6.1. Supabase
1. **Dùng `pg_cron` thay mọi scheduler** → 0đ thêm.
2. **Logic nặng viết bằng PL/pgSQL chạy trong DB**, hạn chế Edge Functions (Edge Functions tính theo lượt gọi).
3. **Parse Excel POS trên trình duyệt** (SheetJS) → chỉ gửi JSON về DB → tiết kiệm cả compute Vercel lẫn Supabase. File gốc (nếu lưu) nén lại, **đặt retention tự xóa** sau N ngày để không tốn Storage.
4. **Partition `inventory_transactions` theo tháng** + tách/nén partition cũ → DB gọn, backup nhanh, không phải nâng tier vì phình dữ liệu.
5. **Dùng connection pooler (Supavisor – transaction mode)** cho serverless → tránh cạn connection mà không cần scale compute.
6. **Hạn chế Realtime** chỉ ở màn hình mapping/dashboard thực sự cần (Realtime tính theo message).
7. **Backup**: Pro đã kèm daily backup + PITR 7 ngày → đủ; thêm 1 bản `pg_dump` hằng tuần lưu lên GitHub (free) làm bản dự phòng nguội.

### 6.2. Vercel
1. **Dashboard dùng ISR** (revalidate mỗi vài phút) thay vì luôn dynamic → giảm số lần gọi function.
2. **Không dùng Vercel Cron** (đã có `pg_cron`) → tiết kiệm invocation.
3. **Tắt Image Optimization** nếu không cần (tính phí riêng); phục vụ asset tĩnh.
4. **Function ngắn gọn**, đẩy compute về DB.
5. **Preview deploy** qua tích hợp Git gốc (không tốn phút GitHub Actions).

### 6.3. GitHub (Free)
- Private repo + Actions chỉ chạy lint/test nhẹ; deploy do Vercel lo.
- Dùng GitHub làm nơi lưu **bản dump DB hằng tuần** (artifact/release) → lớp backup miễn phí thứ hai.

### 6.4. Ước tính chi phí

| Hạng mục | Tier | Chi phí/tháng |
| :-- | :-- | :-- |
| Vercel | Pro | ~20$ |
| Supabase | Pro *(khuyến nghị, xem cảnh báo §8)* | ~25$ |
| GitHub | Free | 0$ |
| Email cảnh báo | Resend Free | 0$ |
| **Tổng** | | **~20–45$** tùy chọn Supabase Free/Pro |

---

## 7. KẾ HOẠCH 90 NGÀY (ĐÃ HIỆU CHỈNH)

### Giai đoạn 1 (Tuần 1–2): Cấu trúc + **Tồn đầu kỳ** + Pilot giá trị cao
1. Triển khai schema phẳng v7, RLS, lớp VIEW tài chính, `pg_cron`.
2. **Kiểm kê vật lý toàn bộ để nạp tồn đầu kỳ** (`stock_takes type=OPENING`) — *điều kiện tiên quyết*, không có thì không chạy được tồn lý thuyết.
3. Pilot nhóm Pareto giá trị cao: `ING-011` Trâu VN, `ING-093` Ribeye Angus US, `ING-003` Cá tuyết đen, `ING-007` Cá hồi Na Uy + 1 mã bar đắt tiền.
4. Test parse file POS thực tế **trên trình duyệt** (13 ngày đầu tháng 6).

### Giai đoạn 2 (Tuần 3–4): WAC per-receipt, Waste, Non-sale, Landed cost
1. Hoàn thiện UI Waste Log (tablet) cho Bếp phó + form **non-sale** (cơm NV/comp/R&D).
2. Kiểm thử WAC per-receipt + landed cost cho hàng nhập.
3. Đào tạo KT phụ nhập hóa đơn `pending`. **(Đào tạo bắt đầu sớm, kéo dài liên tục.)**

### Giai đoạn 3 (Tuần 5–6): Set Menu, Trừ kho công thức MỚI, FEFO
1. Đưa phân rã Tasting Menu + **công thức trừ kho đã bỏ ×1.10** vào chạy thật.
2. Theo dõi **variance thật** sau mỗi ca với nhóm Beef & Fish.
3. Bật FEFO + cảnh báo cận date; cảnh báo email khi variance âm vượt 5%.

### Giai đoạn 4 (Tuần 7–8): Suppliers, Auto-PO, 3-way match, Mapping học
1. Nạp `suppliers`, lead time, MOQ, pack size; **tính `min/max/safety` từ lịch sử tiêu thụ** (không đoán tay) cho 347 mã.
2. Cấu hình Auto-PO 22h40 gom theo NCC + GRN 3-way match.
3. Triển khai `pos_alias_map` (học một lần, tự khớp mãi).

### Giai đoạn 5 (Tuần 9–10): Variance, Menu Engineering, Bar, chạy song song
1. Vận hành song song Excel cũ ↔ CRM mới.
2. Bật phân hệ Variance + Menu Engineering + kiểm soát Bar (chai mở/BTG).
3. Hiệu chỉnh `yield_rate` thực tế từ dữ liệu variance (cẩn trọng để không che giấu thất thoát).
4. Test watchdog job + tải cao điểm.

### Giai đoạn 6 (Tuần 11–12): SOP, đóng gói, bàn giao
1. Quay SOP video theo vai trò (KT / Thủ kho-Bếp phó / CFO-Owner).
2. Đóng gói mã nguồn lên GitHub private + thiết lập backup tuần.
3. Bàn giao hạ tầng, khóa sổ Excel cũ.

---

## 8. PHẢN BIỆN BỔ SUNG & RỦI RO CÒN LẠI

1. **Supabase Free tier rất rủi ro cho production.** Nếu 20$ hiện tại là *Vercel Pro* còn Supabase đang **Free**: dự án sẽ **tự pause sau 7 ngày ít hoạt động**, **không có PITR**, `pg_cron`/backup hạn chế. Một nhà hàng vận hành hằng đêm **không nên** chạy trên Free. Khuyến nghị mạnh: nâng Supabase Pro (~25$) — đây là khoản bảo hiểm cho toàn bộ số liệu tài chính.
2. **Chống nhập trùng file POS** là sống còn khi giữ upload thủ công: bắt buộc `file_hash` + chặn re-upload, nếu không một cú upload đúp = trừ kho đúp.
3. **Đóng băng tồn khi kiểm kê** (`frozen_snapshot`): nếu vừa đếm vừa có giao dịch chạy, variance sẽ sai. Phải chốt snapshot tồn lý thuyết tại thời điểm bắt đầu đếm.
4. **Chính sách tồn âm**: khi tồn lý thuyết < 0 (bán/xuất nhiều hơn ghi nhận nhập), hệ thống phải cảnh báo và chặn Auto-PO tính sai, không âm thầm bỏ qua.
5. **Cycle counting theo ABC**: nhóm A (bò/cá/rượu đắt) đếm **hằng ngày**, nhóm B tuần, nhóm C tháng — thay vì full count tốn nhân lực. Tận dụng `stock_takes type=CYCLE`.
6. **Vòng hiệu chỉnh `yield_rate`** là con dao hai lưỡi: chỉnh yield theo variance giúp chính xác hơn, **nhưng** nếu chỉnh quá tay sẽ "hợp thức hóa" thất thoát thành hao hụt hợp lệ. Cần Cấp 1 phê duyệt mọi thay đổi yield > ngưỡng.
7. **Loại void/comp khỏi POS**: khi parse doanh số, phải loại giao dịch hủy/khuyến mãi khỏi `sale_depletion`, nếu không trừ kho sai theo hướng thừa.
8. **Đa tiền tệ cho landed cost**: lưu `currency + fx_rate + giá VND quy đổi` để truy vết, tránh nhầm khi tỷ giá biến động giữa lúc đặt và lúc nhận.
9. **Rủi ro lớn nhất không nằm ở kỹ thuật mà ở con người**: quy trình thủ công (upload, waste log, non-sale) chỉ chính xác khi nhân sự nhập **kỷ luật và đúng thời điểm**. SOP video + kiểm tra tuân thủ trong giai đoạn chạy song song quan trọng ngang phần code.
10. **Định hướng tương lai (không làm bây giờ)**: khi quy trình thủ công ổn định, bước nâng cấp giá trị nhất tiếp theo vẫn là **kết nối API POS** để xóa hẳn thao tác upload — nên thiết kế `sales_imports` đủ tổng quát để sau này cắm API vào mà không phải đập đi xây lại.

---

*Hết bản v7.0. Các khối SQL ở trên là bản phác kiến trúc (schema sketch) — khi vào code thực tế cần bổ sung index, constraint, trigger kiểm tra và policy RLS chi tiết cho từng VIEW.*
