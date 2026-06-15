# KẾ HOẠCH TRIỂN KHAI HỆ THỐNG CRM/ERP INVENTORY – MAISON VIE **v8.0**
### (BẢN NÂNG CẤP CHUYÊN NGHIỆP – TỐI ƯU HÓA NGHIỆP VỤ & SỬA LỖI ĐƠN VỊ, GIÁ VỐN ÂM, HAO HỤT)

> **Vai trò biên soạn**: COO / CFO / Kiến trúc sư Dữ liệu Full-Stack
> **Dự án**: Hệ thống CRM/ERP Quản lý Kho & Định mức tự động hóa cho nhà hàng Pháp Maison Vie.
> **Hạ tầng**: Supabase (PostgreSQL / Auth / RLS / pg_cron / Storage) + Vercel (Next.js / React) + GitHub (private).
> **Nguyên tắc nền tảng v8**: *"Database-centric, serverless-thin"* — toàn bộ logic nghiệp vụ nặng nằm trong PostgreSQL, chạy bằng `pg_cron` ngay trong Supabase; Vercel chỉ render UI và API mỏng. Mục tiêu: chính xác về số liệu **và** giữ chi phí vận hành ở mức tối thiểu (~20–25$/tháng, không phát sinh dịch vụ trả phí mới).

---

## 0. CHANGELOG – ĐIỂM KHÁC BIỆT CỦA BẢN v8.0 SO VỚI v7.0 & v6.0

| # | Hạng mục | v6.0 (Cũ) | v7.0 (Nâng cấp) | v8.0 (Hiện tại - Sửa lỗi & Tối ưu hóa) |
| :-- | :-- | :-- | :-- | :-- |
| 1 | **Quy đổi đơn vị tính (UoM)** | Thiếu quy đổi, gõ tự do trên Excel. | Thêm bảng `uom` + `uom_conversions` toàn cục (VD: Case $\to$ Bottle). | **Chuyển đơn vị relative về cục bộ**: Quy đổi Thùng/Hộp sang Tồn ở `supplier_ingredients.pack_size`; Quy đổi Tồn sang Công thức ở `ingredients.stock_to_recipe_factor`. Bảng `uom_conversions` chỉ lưu tỷ lệ chuẩn (KG $\to$ G, L $\to$ ML). |
| 2 | **Tính toán Moving WAC** | Chốt cứng lúc 18h30. | Tính di động theo từng lần nhập (per-receipt). | **Bảo vệ khi tồn kho âm**: Công thức WAC áp dụng `adjusted_qty = max(qty_on_hand, 0)` khi tính toán. Bắn log cảnh báo nếu trễ hạn nhập liệu gây tồn âm. |
| 3 | **Hệ số trừ kho & Hao hụt** | Nhân hệ số $\times 1.10$ để tự bù hao phí. | Bỏ hệ số $\times 1.10$. Variance là sai lệch vật lý thực tế. | **Lọc nhiễu Variance (Tolerance Threshold)**: Thêm `tolerance_percent` theo phân nhóm nguyên liệu ABC để tránh cảnh báo rác từ gia vị phụ (hành, tỏi, muối). |
| 4 | **Đo lường rượu quầy Bar** | Quản lý giống bếp thông thường. | Kiểm soát riêng: chai mở, rót ly (BTG), pour variance. | **Cân điện tử + Trọng lượng vỏ chai (`tare_weight_grams`)**: Tính toán chính xác lượng rượu còn lại bằng cân điện tử, loại bỏ việc ước lượng thủ công bằng mắt. |
| 5 | **Đào tạo nhân sự** | Không rõ thời gian. | Đào tạo kế toán phụ ở Tuần 3-4 (Giai đoạn 2). | **Đào tạo sớm ngay Tuần 1 (Giai đoạn 1)**: Nhân sự cần biết nhập hóa đơn/kiểm kho trước khi nạp tồn đầu kỳ. |
| 6 | **Thời gian chạy song song** | Không có chạy song song. | Chạy song song 2 tuần (Tuần 9-10). | **Kéo dài chạy song song lên 4 tuần (Tuần 9-12)**: Đảm bảo độ ổn định và khớp hoàn toàn mã POS trước khi tắt Excel. |
| 7 | **Phân quyền tài chính** | RLS row-level mâu thuẫn. | Phân tách VIEW tài chính: `v_inventory_ops/cost/finance`. | **Bảo mật phân quyền VIEW nâng cao**: Kết hợp phân quyền VIEW cấp cơ sở dữ liệu và bảo mật ở tầng Next.js Server (Server Actions) để đảm bảo không thể bypass dữ liệu tiền tệ. |
| 8 | **Job hẹn giờ** | Không nói cơ chế. | pg_cron + advisory lock + idempotency + watchdog email. | pg_cron + advisory lock + idempotency + watchdog email (giữ nguyên). |
| 9 | **Goods Receipt** | Bỏ qua. | Goods Receipt + 3-way match (PO ↔ GRN ↔ Hóa đơn). | Goods Receipt + 3-way match (PO ↔ GRN ↔ Hóa đơn) (giữ nguyên). |

---

## 1. KIẾN TRÚC & NGUYÊN TẮC THIẾT KẾ

**1.1. Phân tầng theo chi phí (cost-aware layering).**
- **Tầng dữ liệu + nghiệp vụ (Supabase/Postgres)**: chứa schema, RLS, **toàn bộ hàm tính toán** (WAC, trừ kho, Auto-PO, variance) viết bằng **PL/pgSQL**, và các job chạy bằng **`pg_cron`** *ngay trong database*. → Không cần Edge Function trả phí theo lượt gọi, không cần scheduler bên thứ ba.
- **Tầng giao diện (Vercel/Next.js)**: chỉ render UI + các API route/Server Actions mỏng có kiểm tra auth nghiêm ngặt. **Việc đọc/parse file Excel POS được thực hiện ngay trên trình duyệt** (thư viện SheetJS), chỉ gửi JSON đã cấu trúc về Supabase qua RPC. → Giảm tối đa thời gian thực thi serverless (phần dễ bị tính tiền của Vercel).
- **Tầng mã nguồn (GitHub private)**: CI nhẹ, deploy qua tích hợp Git gốc của Vercel (không tốn phút Actions).

**1.2. Nguyên tắc toàn vẹn dữ liệu.** Mọi thay đổi tồn kho đi qua **một sổ cái duy nhất, append-only** (`inventory_transactions`). Sửa sai = ghi **bút toán đảo**, không bao giờ UPDATE/DELETE bản ghi gốc. Đây là nền tảng để Dashboard tài chính và kiểm toán tin cậy được.

**1.3. Nguyên tắc một nguồn sự thật cho hao hụt.** Tồn lý thuyết **không** được "đoán trước" hao hụt. Hao hụt chỉ đến từ ba nguồn *được ghi nhận thật*: `waste_logs`, `non_sale_consumption`, và yield sơ chế cố định trong công thức. Phần còn lại lệch ra khi kiểm kê chính là **variance cần điều tra** — đó mới là giá trị cốt lõi của hệ thống.

---

## 2. THIẾT KẾ CSDL PHẲNG NÂNG CẤP (v8.0)

### 2.1. Nhóm Master (danh mục gốc)

```sql
-- Đơn vị tính (MỚI v8.0)
create table uom (
  id            text primary key,          -- 'KG','G','L','ML','BOTTLE','CASE','PIECE'
  name          text not null,
  uom_type      text not null              -- 'WEIGHT','VOLUME','COUNT'
);

-- Chỉ dùng cho các quy đổi chuẩn quốc tế có tỷ lệ cố định (VD: KG->G, L->ML)
-- KHÔNG DÙNG quy đổi CASE->BOTTLE tại đây vì thùng của mỗi sản phẩm có số chai khác nhau.
create table uom_conversions (
  from_uom      text references uom(id),
  to_uom        text references uom(id),
  factor        numeric not null,          -- 1 from_uom = factor * to_uom
  primary key (from_uom, to_uom)
);

-- Nhà cung cấp
create table suppliers (
  id            uuid primary key default gen_random_uuid(),
  name          text not null,
  category_id   uuid references purchase_categories(id),
  contact       jsonb,
  lead_time_days int not null default 1,    -- phục vụ Auto-PO
  cutoff_time   time,                       -- giờ chốt nhận đơn trong ngày
  is_active     boolean default true
);

-- Giá & điều kiện theo từng NCC (CẬP NHẬT v8.0)
create table supplier_ingredients (
  supplier_id     uuid references suppliers(id),
  ingredient_id   uuid references ingredients(id),
  purchase_uom    text references uom(id),    -- đơn vị MUA (CASE, BOX, KG...)
  pack_size       numeric not null default 1, -- Quy đổi Mua -> Tồn: 1 đơn vị mua = pack_size stock_uom (VD: 1 CASE bia = 24 BOTTLE)
  moq             numeric not null default 1, -- số lượng đặt tối thiểu (theo purchase_uom)
  last_price_fx   numeric,                    -- giá theo ngoại tệ gốc (nếu nhập khẩu)
  currency        text default 'VND',
  is_preferred    boolean default false,    -- NCC ưu tiên khi Auto-PO
  primary key (supplier_id, ingredient_id)
);

-- Nguyên vật liệu (CẬP NHẬT v8.0)
create table ingredients (
  id            uuid primary key default gen_random_uuid(),
  code          text unique not null,       -- ING-011...
  name          text not null,
  category_id   uuid references purchase_categories(id),
  stock_uom     text references uom(id),    -- đơn vị TỒN chuẩn (BOTTLE, KG...)
  recipe_uom    text references uom(id),    -- đơn vị dùng trong công thức (ML, G...)
  stock_to_recipe_factor numeric not null default 1, -- MỚI v8.0: Quy đổi Tồn -> Công thức (VD: 1 BOTTLE rượu = 750 ML, 1 quả trứng = 50 G)
  tare_weight_grams numeric default 0,      -- MỚI v8.0: Trọng lượng vỏ chai rỗng (dành riêng cho rượu Bar dùng cân điện tử)
  tolerance_percent numeric default 5.0,    -- MỚI v8.0: Ngưỡng sai lệch cho phép (%) khi đối soát Variance (tránh nhiễu nhóm gia vị)
  wac_price     numeric default 0,          -- giá vốn bình quan gia quyền (landed)
  min_stock     numeric default 0,
  max_stock     numeric default 0,
  safety_stock  numeric default 0,          -- tồn an toàn cho Auto-PO
  is_import     boolean default false,      -- cờ hàng nhập khẩu (landed cost)
  track_lot     boolean default false,      -- bật theo dõi lô/hạn (FEFO)
  is_beverage   boolean default false,      -- phân loại bar (bật tính năng Pour Variance)
  auto_po_group text default 'MANUAL_REQUISITION' -- 'AUTO_PO' | 'MANUAL_REQUISITION'
);
```

### 2.2. Nhóm Công thức & Món

`menu_items`, `set_menu_items`, `recipes` giữ cấu trúc v6 nhưng bổ sung:
- `qty_net` (lượng tịnh), `yield_rate` (%), **`recipe_uom`** rõ ràng để quy đổi đúng đơn vị.
- **Bỏ mọi tham số "bù hao 10%"** khỏi recipe — hao bù không thuộc về định mức mà thuộc về giám sát sai lệch (Variance).
- Quy đổi từ đơn vị công thức (`recipe_uom`) về đơn vị tồn kho (`stock_uom`) khi trừ kho:
  $$\text{Lượng quy đổi tồn} = \frac{\text{Lượng công thức}}{\text{stock\_to\_recipe\_factor}}$$

### 2.3. Nhóm Giao dịch (transactional)

```sql
-- SỔ CÁI BẤT BIẾN
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

-- Đơn đặt hàng
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

-- NHẬN HÀNG + 3-WAY MATCH
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

-- LÔ/HẠN DÙNG cho FEFO
create table lots (
  id uuid primary key default gen_random_uuid(),
  ingredient_id uuid references ingredients(id),
  grn_id uuid references goods_receipts(id),
  qty_remaining numeric, expiry_date date,
  received_at timestamptz default now()
);

-- TIÊU THỤ NGOÀI BÁN HÀNG
create table non_sale_consumption (
  id bigint generated always as identity primary key,
  ingredient_id uuid references ingredients(id),
  qty numeric, consumption_type text, -- 'STAFF_MEAL','COMP','R&D','TRAINING','EVENT'
  business_date date, created_by uuid, note text
);

-- BẢNG ALIAS HỌC ĐƯỢC
create table pos_alias_map (
  pos_code text primary key,        -- mã/tên xuất hiện trong file POS
  menu_item_id uuid references menu_items(id),
  confidence numeric default 100,
  confirmed_by uuid, confirmed_at timestamptz default now()
);

-- KIỂM KÊ
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

-- KHÓA SỔ NGÀY – máy trạng thái
create table daily_close (
  business_date date primary key,
  status text default 'OPEN', -- 'OPEN','WAC_DONE','CONSUMPTION_DONE','PO_DONE','LOCKED'
  locked_at timestamptz, locked_by uuid
);

-- NHẬT KÝ KIỂM TOÁN
create table audit_log (
  id bigint generated always as identity primary key,
  actor uuid, action text, entity text, entity_id text,
  before_data jsonb, after_data jsonb, at timestamptz default now()
);
```

---

## 3. MA TRẬN PHÂN QUYỀN 7 CẤP + LỚP TÀI CHÍNH NÂNG CAO

**Bảo mật lớp tài chính (fix lỗi RLS cột):**
RLS của Postgres lọc theo *dòng*, không giấu được *cột*. v8.0 tách dữ liệu thành **ba VIEW nghiệp vụ** kết hợp bảo mật tầng Server (Next.js Server Actions):

- **`v_inventory_ops`** (vận hành, **không có** cột tiền: WAC, giá trị VND, doanh thu) → cho Cấp 2, 3, 5, 6, 7.
- **`v_inventory_finance`** (đầy đủ doanh thu + giá trị tiền) → **chỉ** Cấp 1 (CFO/Owner).
- **`v_inventory_cost`** (có WAC/giá vốn nhưng **không có doanh thu**) → Cấp 4 (Kế toán cần giá vốn để đối soát WAC & xuất PO, nhưng không thấy doanh thu).

**Bảo mật triển khai:**
1. Thu hồi quyền đọc trực tiếp trên bảng gốc từ role người dùng: `REVOKE SELECT ON TABLE ingredients, inventory_transactions FROM authenticated;`.
2. Cấp quyền SELECT trên các VIEW tương ứng cho các role cụ thể.
3. Với các truy vấn trên UI, Next.js Server Actions sẽ đóng vai trò trung gian xác thực Session trước khi dùng Service Role để kéo dữ liệu từ VIEW phù hợp, đảm bảo người dùng không thể gọi API trực tiếp để bypass cấu trúc VIEW.

| Cấp | Vai trò | VIEW được cấp | SELECT | INSERT | UPDATE | DELETE | Quyền hạn |
| :-- | :-- | :-- | :-: | :-: | :-: | :-: | :-- |
| **1** | Admin (CFO/Owner) | `v_inventory_finance` | ✔ tất cả | ✔ | ✔ | ✔ | **Duy nhất** thấy doanh thu, giá trị kho VND, Food Cost %, biến động tiền. |
| **2** | Quản lý NH | `v_inventory_ops` | Số lượng (không tiền) | Giao dịch | Giao dịch | ✘ | Vận hành kho, duyệt waste giá trị lớn (duyệt theo *số lượng*, không thấy tiền). |
| **3** | Bếp trưởng | `v_inventory_ops` (lọc kho bếp) | Tiêu thụ bếp | Định mức | Đề xuất | ✘ | Sửa công thức. Không thấy tiền. Mọi sửa đổi `yield_rate` chỉ ở dạng **Đề xuất** chờ Cấp 1/Cấp 4 duyệt. |
| **4** | KT kho cấp cao | `v_inventory_cost` | Số lượng + **giá vốn** (không doanh thu) | PO, WAC, GRN | PO, WAC, GRN | ✘ | Đối soát WAC, 3-way match, duyệt Auto-PO, duyệt đề xuất thay đổi định mức sơ chế. |
| **5** | Giám sát Sảnh | `v_inventory_ops` (menu/POS) | Menu/POS | ✘ | ✘ | ✘ | Đối chiếu mã POS lỗi. Không tiền, không NVL. |
| **6** | Bếp phó | `v_inventory_ops` (khai báo) | Khai báo | Waste, Manual PO, Non-sale | ✘ | ✘ | Tạo waste log, requisition hàng chợ, khai cơm NV/R&D. |
| **7** | Thủ kho/KT phụ | `v_inventory_ops` (xem) | Xem | Hóa đơn `pending` | ✘ | ✘ | Nhập hóa đơn mua lẻ chờ Cấp 4 duyệt. Kiểm kho thực tế. |

---

## 4. LOGIC NGHIỆP VỤ ĐÃ TỐI ƯU HÓA (v8.0)

### A. Tính Moving WAC có bảo vệ "Tồn kho âm" + Landed Cost

WAC được tính lại ngay tại mỗi lần duyệt Goods Receipt.
Để tránh lỗi toán học khi **tồn kho lý thuyết bị âm** (do kế toán nhập hóa đơn trễ hơn thực tế xuất bán), công thức tính WAC mới được tối ưu hóa như sau:

```
adjusted_qty_on_hand = max(qty_tồn_hiện_tại, 0)

landed_unit_cost = (qty_nhập * unit_price_fx * fx_rate + phân_bổ_duty + phân_bổ_freight)
                   / (qty_nhập * pack_size)

new_wac = (adjusted_qty_on_hand * wac_hiện_tại + (qty_nhập * pack_size) * landed_unit_cost)
           / (adjusted_qty_on_hand + (qty_nhập * pack_size))
```

- **Bảo vệ số âm**: Nếu `qty_tồn_hiện_tại < 0`, hệ thống coi như tồn kho bằng 0 để tính WAC theo giá lô mới nhất, tránh đẩy giá vốn tăng ảo hoặc lỗi chia cho 0. Đồng thời ghi nhận cảnh báo "Nhập liệu trễ hạn" vào `audit_log`.
- `phân_bổ_duty/freight`: chia thuế nhập & cước theo tỷ trọng giá trị từng dòng GRN.
- Hàng nhập (`is_import = true`) lưu cả `currency` + `fx_rate` để truy vết.
- **18h30 chỉ còn là mốc snapshot báo cáo** (`daily_close.status = WAC_DONE`): chụp lại giá trị tồn để dựng báo cáo ngày, không dùng để định giá giao dịch phát sinh.

### B. Trừ kho tự động 22h30 – Công thức loại bỏ hao hụt ảo

Công thức tính tồn lý thuyết cuối ngày:

```
-- Phần 1: Trừ theo doanh số bán (đã phân rã Set Menu theo portion_ratio)
gross_qty = (qty_net / (yield_rate / 100)) / stock_to_recipe_factor
sale_depletion = Σ ( gross_qty * qty_sold_đã_loại_void_comp )

-- Phần 2: Hao hụt THỰC được ghi nhận (không ước lượng)
waste = Σ waste_logs (đã duyệt, trong ngày)
non_sale = Σ non_sale_consumption (cơm NV, comp, R&D, training, event)

-- Tổng tiêu thụ lý thuyết trong ngày
theoretical_consumption = sale_depletion + waste + non_sale

-- Tồn lý thuyết cuối ngày
closing_theoretical = opening + receipts − theoretical_consumption
```

Trừ kho theo **FEFO**: nếu `track_lot = true`, trừ lần lượt từ lô có `expiry_date` sớm nhất.

### C. Đặt hàng tự động (Auto-PO) 22h40 có kiểm soát

```
projected_on_hand = tồn_lý_thuyết_hiện_tại
                    + Σ PO_đang_mở_về_trước_lead_time
                    − dự_báo_tiêu_thụ_trong_lead_time

Nếu projected_on_hand < safety_stock  →  kích hoạt đặt hàng:
  order_up_to   = max_stock
  qty_raw       = order_up_to − projected_on_hand
  qty_final     = roundup_to_pack( max(qty_raw, moq), pack_size )
```

- **Net trừ PO đang mở** → không đặt trùng hàng đang trên đường giao.
- **Tôn trọng MOQ + pack_size** của từng NCC → tự động làm tròn lên theo Thùng/Hộp.
- Gom theo **`supplier_id` (NCC ưu tiên)** → mỗi NCC một file PO độc lập tải về lúc 7h00 sáng.
- `dự_báo_tiêu_thụ` giai đoạn đầu = trung bình động 14 ngày của NVL đó.

### D. Mapping POS học được (Persistent Mapping)

1. Khi kế toán upload Excel POS (parse **trình duyệt** qua SheetJS):
   - Tra `pos_alias_map`: mã đã từng khớp trước đó → **tự gán 100%, không hỏi lại** 🟢.
   - Mã mới → chạy Levenshtein gợi ý 🟡 kèm % (vd "Angus Ribeye – 92%"), kế toán xác nhận **một lần duy nhất** → ghi vào `pos_alias_map` để lần sau tự khớp.
2. **Không dùng cơ chế đếm ngược 30 giây** để tránh rủi ro tự động lưu sai lệch. Kế toán chủ động bấm **"Chốt ghi sổ"**.
3. Mỗi file có `file_hash`; **upload trùng bị chặn** → chống trừ kho hai lần do lỗi thao tác thủ công.

### E. FEFO / Lô – Hạn dùng + HACCP

- Mỗi lần nhận hàng tạo `lots` với `expiry_date`.
- Job sáng quét lô **cận date** (vd còn ≤ 2 ngày) → cảnh báo email cho Bếp phó/Quản lý + ưu tiên xuất lô cận date trước.
- Truy xuất nguồn gốc theo lô phục vụ an toàn thực phẩm (HACCP) cho thực phẩm tươi sống giá trị cao (Cá tuyết, Bò Mỹ).

### F. Báo cáo Variance thông minh (Lọc nhiễu theo ngưỡng Tolerance)

- **Ngưỡng sai lệch (`tolerance_percent`)**: Hệ thống áp dụng lọc sai lệch theo phân loại ABC của nguyên liệu để tránh làm phiền quản lý bởi các sai lệch nhỏ của gia vị:
  - **Nhóm A (Giá trị cao - Rượu mạnh, Thịt bò...)**: `tolerance_percent` = 1% - 2%.
  - **Nhóm B (Trung bình - Rau củ quả, sữa...)**: `tolerance_percent` = 5%.
  - **Nhóm C (Giá trị thấp - Muối, tiêu, gia vị khô...)**: `tolerance_percent` = 10% - 15%.
- Báo cáo Variance chỉ hiển thị **Cảnh báo đỏ** nếu `% lệch thực tế > tolerance_percent`. Các sai lệch nhỏ dưới ngưỡng chỉ được lưu trữ để phân tích xu hướng dài hạn mà không bắn cảnh báo khẩn cấp.

### G. Kiểm soát Bar riêng biệt bằng Cân điện tử

- **Cân chai mở**: Để đo lường chính xác lượng rượu còn lại của các chai rượu đang mở:
  - Thủ bar đặt chai rượu lên cân điện tử, nhập số gram thực tế vào hệ thống.
  - Hệ thống tính toán lượng rượu còn lại:
    $$\text{Lượng rượu còn lại (ML)} = \frac{\text{Trọng lượng cân thực tế (g)} - \text{tare\_weight\_grams}}{\text{Tỷ trọng rượu (mặc định 1.0 hoặc cấu hình riêng)}}$$
  - So sánh dung tích thực tế này với số lượng lý thuyết để tính **Pour Variance** của khu vực bar (rót quá tay BTG, uống trộm).

### H. Goods Receipt 3-way match & Quy trình duyệt yield sơ chế

- Khi nhận hàng: khớp **PO ↔ GRN ↔ Hóa đơn**. Lệch số lượng/giá → trạng thái `VARIANCE`, chặn ghi tăng kho cho đến khi Cấp 4 duyệt. Chỉ khi `APPROVED` mới ghi sổ `inventory_transactions (IMPORT)` + cập nhật WAC + tạo `lots`.
- **Duyệt Yield**: Bếp trưởng (Cấp 3) chỉ có quyền gửi **Đề xuất điều chỉnh `yield_rate`**. Đề xuất này phải qua Cấp 1 (Owner/CFO) hoặc Cấp 4 (Kế toán trưởng) phê duyệt để tránh việc bếp trưởng tăng định mức hao hụt sơ chế nhằm che đậy việc làm mất mát nguyên liệu.

### I. Khóa sổ ngày – máy trạng thái

`OPEN → WAC_DONE (18h30) → CONSUMPTION_DONE (22h30) → PO_DONE (22h40) → LOCKED`. Sau `LOCKED`, **không cho backdating** (ghi sổ lùi ngày); sửa sai bắt buộc qua **bút toán đảo** vào ngày hiện tại.

---

## 5. ĐỘ TIN CẬY VẬN HÀNH JOB (SUPABASE `pg_cron`)

- Lập lịch tự động bằng `pg_cron` (18:30 / 22:30 / 22:40 theo timezone Asia/Ho_Chi_Minh).
- Chống chạy trùng bằng `pg_advisory_xact_lock(business_date)`: đảm bảo hai tiến trình không xử lý trừ kho cùng lúc.
- Idempotency: Kiểm tra trạng thái `daily_close.status` trước khi chạy, đảm bảo mỗi bước chỉ chạy duy nhất 1 lần trong ngày.
- Watchdog: Job lúc 23h00 quét kiểm tra xem toàn bộ các bước trong ngày đã hoàn thành chưa, nếu phát hiện lỗi sẽ gửi email khẩn cấp qua Resend API (Free 3.000 email/tháng).

---

## 6. TỐI ƯU CHI PHÍ VẬN HÀNH (Khuyến nghị Supabase Pro)

- **Supabase**: Khuyến nghị mạnh mẽ nâng cấp lên gói **Pro (~25$/tháng)**. Gói Free rất rủi ro cho nhà hàng do dự án sẽ bị pause tự động sau 7 ngày không hoạt động, không có PITR (Point-in-Time Recovery) bảo vệ dữ liệu tài chính, và giới hạn hiệu năng `pg_cron`.
- **Vercel**: Dùng gói Pro (~20$/tháng) để phục vụ giao diện CRM.
- **Tối ưu Compute**: Logic nặng viết bằng PL/pgSQL chạy trực tiếp trong Database, giảm tải hoàn toàn cho Serverless Functions của Vercel. Dùng Connection Pooler (Supavisor) ở chế độ transaction để tránh cạn kiệt connection.

---

## 7. KẾ HOẠCH 90 NGÀY ĐÃ ĐIỀU CHỈNH (v8.0)

### Giai đoạn 1 (Tuần 1–2): Cấu trúc + Đào tạo sớm + Tồn đầu kỳ + Pilot nhóm giá trị cao
1. Triển khai schema phẳng v8.0, RLS, VIEW tài chính, `pg_cron` trên Supabase.
2. **Đào tạo sớm cho Kế toán phụ (Cấp 7)** về quy trình nhập hóa đơn và kiểm kho thực tế.
3. **Kiểm kê vật lý toàn bộ để nạp tồn đầu kỳ** (`stock_takes type=OPENING`) — đây là điều kiện bắt buộc để kích hoạt hệ thống.
4. Pilot nhóm Pareto giá trị cao: Bò nhập khẩu, cá tuyết, cá hồi và 1 mã rượu mạnh tại bar.
5. Chạy thử nghiệm trình duyệt đọc file Excel POS của 13 ngày đầu tháng 6.

### Giai đoạn 2 (Tuần 3–4): WAC chống tồn âm, Waste, Non-sale, Landed cost
1. Hoàn thiện UI Waste Log (tablet) cho Bếp phó + form khai báo **non-sale** (cơm NV, comp, R&D).
2. Kiểm thử logic Moving WAC có xử lý bảo vệ tồn kho âm và Landed Cost.

### Giai đoạn 3 (Tuần 5–6): Set Menu, Trừ kho công thức mới, FEFO, Lọc nhiễu Variance
1. Đưa phân rã Tasting Menu và công thức trừ kho đã loại bỏ hệ số `1.10` vào chạy thật.
2. Kiểm thử báo cáo Variance lọc nhiễu theo ngưỡng `tolerance_percent` của nhóm Beef & Fish.
3. Bật FEFO và email cảnh báo khi lệch đỏ vượt ngưỡng cho phép.

### Giai đoạn 4 (Tuần 7–8): Suppliers, Auto-PO, 3-way match, Mapping học
1. Nạp danh mục `suppliers`, MOQ, pack size, thời gian giao hàng.
2. Bật tính năng Auto-PO gom đơn theo NCC và quy trình duyệt GRN 3-way match.
3. Triển khai mapping POS học lỗi (persistent map).

### Giai đoạn 5 (Tuần 9–12): Vận hành song song 4 tuần + Hiệu chỉnh định mức + Kiểm Bar cân điện tử
1. **Vận hành song song hệ thống cũ và mới trong vòng 4 tuần** để đảm bảo nhân viên quen tay và phát hiện toàn bộ các mã POS chưa map.
2. Bật phân hệ kiểm soát Bar sử dụng cân điện tử (`tare_weight_grams`).
3. Quy trình đề xuất và duyệt thay đổi `yield_rate` thực tế.
4. Kiểm thử watchdog job và bảo mật VIEW Next.js Server.

### Giai đoạn 6 (Tuần 13–14): Đóng gói, Video SOP & Bàn giao
1. Quay video SOP chi tiết cho 3 nhóm vai trò (Kế toán / Thủ kho-Bếp phó / CFO-Owner).
2. Đóng gói mã nguồn lên GitHub private và cấu hình sao lưu DB hàng tuần.
3. Chính thức đóng file Excel cũ và bàn giao toàn bộ hệ thống.

---
*Hết bản v8.0.*
