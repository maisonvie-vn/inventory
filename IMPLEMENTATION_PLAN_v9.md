# KẾ HOẠCH TRIỂN KHAI HỆ THỐNG CRM/ERP INVENTORY – MAISON VIE **v9.0**
### (BỔ SUNG MODULE BAR ĐỘC LẬP + CỔNG ĐĂNG NHẬP BAR RIÊNG + BÁO CÁO TỒN CUỐI NGÀY & XUẤT PDF ĐẶT HÀNG THEO MỨC CẢNH BÁO)

> **Vai trò biên soạn**: COO / CFO / Kiến trúc sư Dữ liệu Full-Stack
> **Hạ tầng**: Supabase (PostgreSQL / Auth / RLS / pg_cron / Storage) + Vercel (Next.js / React) + GitHub (private).
> **Nguyên tắc nền tảng (giữ từ v8)**: *"Database-centric, serverless-thin"* — logic nặng nằm trong PostgreSQL, chạy bằng `pg_cron`. **Bổ sung v9**: PDF đặt hàng được **render ngay trên trình duyệt** (pdfmake/react-pdf) rồi lưu Storage → không tốn compute server, đúng triết lý tối ưu chi phí.

---

## 0. CHANGELOG v8.0 → v9.0

| # | Hạng mục | v8.0 | v9.0 (Bổ sung) |
| :-- | :-- | :-- | :-- |
| A | **Mô hình kho** | Tồn tổng đơn lẻ (1 kho ngầm định) | **Thêm chiều Địa điểm/Bộ phận** (`locations`: KHO TỔNG / BẾP / BAR) + giao dịch **chuyển kho nội bộ (TRANSFER)**. Nền tảng để tách Bar và làm luồng Nhập/Xuất theo bộ phận. |
| B | **Module Bar** | Cân điện tử + density 1.0 | **Hiệu chuẩn 2 điểm cân (full/empty weight) — bỏ giả định density**; thêm **BOM cocktail, BTG rượu vang, bia tươi**, theo dõi **vỡ/đổ/comp** riêng cho bar. |
| C | **Đăng nhập Bar** | Không có vai trò Bar riêng | **Cổng đăng nhập Bar độc lập** (`/bar`) với vai trò `BAR_SUPERVISOR` & `BARTENDER`, **PIN cá nhân trên tablet dùng chung** để quy trách nhiệm từng người. *Vẫn dùng chung 1 hệ thống/1 DB — không tạo silo.* |
| D | **Nhập/Xuất/Tồn cuối ngày** | Trừ kho lý thuyết tự động 22h30 | **Thêm luồng vật lý theo bộ phận**: xác nhận "đã nhập / đã xuất trong ngày" → **chốt tồn cuối ngày** → **xuất PDF đặt hàng theo mức cảnh báo (đỏ/vàng/xanh)**. |
| E | **Đặt hàng** | Auto-PO 22h40 tự gửi (blind) | **Hợp nhất**: Auto-PO trở thành **bản nháp** → bộ phận xác nhận tồn → **duyệt → xuất PDF** mới gửi. Bỏ rủi ro tự gửi mù. |
| F | **Mức cảnh báo đặt hàng** | So tồn vs min tĩnh | **Cảnh báo theo nhu cầu** (projected tồn tại kỳ giao kế tiếp), không chỉ so min cứng. |
| G | **Chứng từ PDF** | — | `order_documents` **bất biến, có số chứng từ + người duyệt + hash** lưu Storage (chứng từ mua hàng, không xóa tùy tiện). |

---

## 1. SCHEMA BỔ SUNG v9.0

### 1.1. Chiều Địa điểm & Chuyển kho nội bộ (nền tảng cho Bar + luồng Nhập/Xuất)

```sql
-- ĐỊA ĐIỂM / BỘ PHẬN (MỚI v9)
create table locations (
  id          text primary key,     -- 'MAIN_STORE','KITCHEN','BAR'
  name        text not null,
  loc_type    text not null,        -- 'STORE' (kho) | 'STATION' (quầy/bộ phận sử dụng)
  is_bar      boolean default false
);

-- Bổ sung cột location_id vào sổ cái bất biến (tồn được tính theo từng địa điểm)
alter table inventory_transactions
  add column location_id text references locations(id);

-- txn_type mở rộng thêm: 'TRANSFER_OUT','TRANSFER_IN','ISSUE'
--   IMPORT        : nhập từ NCC vào MAIN_STORE
--   TRANSFER_OUT  : xuất khỏi kho nguồn (âm)  ┐ ghép cặp bằng transfer_id
--   TRANSFER_IN   : nhập vào kho đích (dương) ┘ (kho tổng → bếp / bar)
--   ISSUE         : xuất dùng tại station (khi station tự tiêu hao trực tiếp)
alter table inventory_transactions add column transfer_id uuid; -- nối 2 chân chuyển kho

-- Tồn hiện tại = view tổng hợp theo (ingredient_id, location_id)
create view v_stock_on_hand as
  select ingredient_id, location_id, sum(qty) as qty_on_hand
  from inventory_transactions group by ingredient_id, location_id;
```

> **Lưu ý quan trọng:** từ v9, "tồn" luôn gắn với **một địa điểm**. Kho tổng nhập từ NCC; bếp và bar nhận hàng qua **TRANSFER** từ kho tổng. Đây là điều kiện để (a) tách Bar độc lập và (b) làm đúng động tác "đã xuất đồ trong ngày".

### 1.2. Cổng đăng nhập Bar & vai trò Bar

```sql
-- Mở rộng enum vai trò trong profiles:
--   thêm 'BAR_SUPERVISOR' (Trưởng quầy Bar) và 'BARTENDER' (Nhân viên pha chế)
-- Gắn mỗi user Bar với location_id = 'BAR' để RLS giới hạn phạm vi dữ liệu.

alter table profiles add column home_location text references locations(id);
alter table profiles add column pin_hash text;   -- PIN cá nhân cho tablet dùng chung (đã hash)
alter table profiles add column shift_role text;  -- 'OPENER','CLOSER' (ca mở/đóng quầy)
```

### 1.3. Hiệu chuẩn cân & Đếm Bar (bỏ giả định density)

```sql
-- HIỆU CHUẨN 2 ĐIỂM CÂN cho từng chai rượu (MỚI v9 – thay density cứng 1.0)
create table bar_bottle_calibration (
  ingredient_id     uuid primary key references ingredients(id),
  full_weight_grams numeric not null,   -- cân chai đầy nguyên seal
  empty_weight_grams numeric not null,  -- cân vỏ chai rỗng (tare thực đo)
  full_volume_ml    numeric not null    -- dung tích danh nghĩa (700/750/1000ml)
);

-- ĐẾM BAR THEO CA (MỚI v9 – quy trách nhiệm từng bartender)
create table bar_counts (
  id                uuid primary key default gen_random_uuid(),
  business_date     date not null,
  ingredient_id     uuid references ingredients(id),
  sealed_qty        numeric default 0,    -- số chai nguyên còn seal
  open_bottle_grams numeric,              -- cân khối lượng chai đang mở
  derived_volume_ml numeric,              -- nội suy ra dung tích còn lại
  shift             text,                 -- 'OPEN' (đầu ca) | 'CLOSE' (cuối ca)
  counted_by        uuid references profiles(id),
  counted_at        timestamptz default now()
);
```

### 1.4. Cổng xác nhận vận động kho & Chứng từ PDF đặt hàng

```sql
-- CỔNG "ĐÃ NHẬP / ĐÃ XUẤT TRONG NGÀY" theo bộ phận (MỚI v9)
create table daily_stock_movement (
  business_date         date,
  location_id           text references locations(id),
  imports_confirmed     boolean default false,
  imports_confirmed_by  uuid, imports_confirmed_at timestamptz,
  issues_confirmed      boolean default false,
  issues_confirmed_by   uuid, issues_confirmed_at timestamptz,
  closing_snapshot      jsonb,             -- chốt tồn cuối ngày khi cả 2 cờ = true
  status                text default 'OPEN', -- 'OPEN' → 'CLOSED'
  primary key (business_date, location_id)
);

-- CHỨNG TỪ ĐẶT HÀNG (PDF) – BẤT BIẾN, CÓ SỐ & NGƯỜI DUYỆT (MỚI v9)
create table order_documents (
  id            uuid primary key default gen_random_uuid(),
  doc_no        text unique,        -- VD: PO-2026-0612-BAR-001
  business_date date, location_id text references locations(id),
  supplier_id   uuid references suppliers(id),
  status        text default 'DRAFT', -- 'DRAFT' → 'APPROVED' → 'SENT'
  generated_by  uuid, approved_by uuid,
  pdf_path      text,               -- đường dẫn file PDF trong Supabase Storage
  content_hash  text,               -- SHA-256 nội dung để chống sửa
  payload       jsonb,              -- snapshot dòng hàng + mức cảnh báo tại thời điểm chốt
  created_at    timestamptz default now()
);
```

---

## 2. MODULE 1 — BAR ĐỘC LẬP + CỔNG ĐĂNG NHẬP BAR RIÊNG

### 2.1. Triết lý: "tách giao diện, KHÔNG tách dữ liệu"

Bar có cổng đăng nhập riêng (`/bar`), giao diện riêng tối giản cho thao tác quầy, **nhưng vẫn nằm trên cùng một Supabase/một sổ cái**. Tồn kho, giá vốn, pour variance của Bar **vẫn roll-up về Dashboard CFO** như bếp.

> **Phản biện thẳng:** nếu hiểu "đăng nhập Bar riêng" thành *một hệ thống/CSDL tách rời*, ta sẽ tái lập đúng cái bệnh silo Excel mà cả dự án đang xóa bỏ — và còn phát sinh chi phí hạ tầng thứ hai. v9 vì vậy chỉ tách **lớp truy cập + UI**, không tách kho dữ liệu.

### 2.2. Cơ chế đăng nhập Bar (tablet dùng chung + PIN cá nhân)

- Quầy bar thường dùng **một tablet chung**. Vì vậy: đăng nhập thiết bị một lần vào "phiên quầy Bar", mỗi thao tác (đếm cân, khai vỡ/đổ, comp) **bắt buộc nhập PIN cá nhân** của bartender đang trực → mọi bản ghi đều có `counted_by`/`created_by` đích danh.
- **Lý do bắt buộc quy trách nhiệm cá nhân:** Bar là khu vực thất thoát cao nhất trong F&B (rót quá tay, uống chùa, vỡ không khai). Một "tài khoản Bar dùng chung" sẽ **vô hiệu hóa toàn bộ khả năng truy vết** pour variance về người gây ra. PIN cá nhân là rào chắn rẻ tiền nhưng quyết định.
- RLS giới hạn user Bar chỉ thấy `location_id = 'BAR'`; không thấy doanh thu (theo phân quyền tài chính của v8); Trưởng quầy (`BAR_SUPERVISOR`) duyệt đếm cuối ca, Bartender chỉ nhập.
- **Mở ca / Đóng ca**: đầu ca đếm `shift='OPEN'`, cuối ca đếm `shift='CLOSE'` → hệ thống tính tiêu thụ thực của ca = (tồn đầu ca + nhập trong ca) − tồn cuối ca, đối chiếu với lý thuyết từ POS đồ uống.

### 2.3. Đo lượng rượu chai mở — công thức hiệu chuẩn 2 điểm (SỬA LỖI density v8)

> **Phản biện công thức v8:** v8 dùng *tỷ trọng mặc định 1.0*. Sai về vật lý: rượu mạnh ~0.91–0.95 g/ml, syrup/liqueur có thể >1.1 g/ml. Lấy density = 1.0 sẽ **báo sai dung tích còn lại một cách hệ thống** (rượu mạnh bị báo dư, syrup bị báo thiếu) → pour variance nhiễu, mất ý nghĩa.

v9 **bỏ density hoàn toàn**, dùng **2 lần cân hiệu chuẩn mỗi sản phẩm** (chai đầy & vỏ rỗng), rồi nội suy tuyến tính theo khối lượng:

```
remaining_ml = full_volume_ml *
               (measured_grams − empty_weight_grams)
             / (full_weight_grams − empty_weight_grams)
```

Cách này không cần biết density (đã ẩn trong chênh lệch khối lượng đầy–rỗng), đúng cho mọi loại rượu/syrup, và chỉ tốn một lần hiệu chuẩn ban đầu cho mỗi mã.

**Pour variance ca** = (dung tích lý thuyết phải còn theo BOM cocktail/BTG đã bán) − (dung tích thực đo bằng cân). Lệch vượt `tolerance_percent` nhóm A (1–2%) → cảnh báo đỏ kèm tên bartender trực ca.

### 2.4. Đặc thù đồ uống cần xử lý đúng (mở rộng BOM cho Bar)

- **Cocktail = công thức nhiều nguyên liệu** (rượu nền + liqueur + syrup + nước ép + garnish). Trừ kho phải phân rã theo `recipes` của từng cocktail, không chỉ trừ nguyên chai.
- **BTG (rượu vang ly)**: chai vang mở có hạn dùng ngắn (oxy hóa) → theo dõi chai mở + cho phép khai **đổ bỏ cuối ngày** (dump) như một dạng waste có lý do, để không quy oan thành thất thoát.
- **Bia tươi / draft**: hao hụt đường ống, bọt, vệ sinh line → cấu hình hệ số hao kỹ thuật riêng cho keg (đây là hao *kỹ thuật đo lường được*, khác với buffer ảo đã bị loại bỏ).
- **Vỡ/đổ/comp**: thêm loại `non_sale_consumption` cho bar: `BREAKAGE`,`SPILL`,`COMP_DRINK`,`TASTING` — khai ngay bằng PIN cá nhân.

---

## 3. MODULE 2 — NHẬP/XUẤT/TỒN CUỐI NGÀY & XUẤT PDF ĐẶT HÀNG THEO MỨC CẢNH BÁO

### 3.1. Luồng nghiệp vụ (đúng mô tả của bạn)

```
[Bộ phận kho/bar/bếp]
   1. Nhập hàng trong ngày   → ghi IMPORT/TRANSFER_IN  → bấm "✔ ĐÃ NHẬP XONG"
   2. Xuất đồ trong ngày      → ghi TRANSFER_OUT/ISSUE   → bấm "✔ ĐÃ XUẤT XONG"
        │
        ▼  (khi cả hai cờ imports_confirmed & issues_confirmed = true)
   3. Hệ thống CHỐT TỒN CUỐI NGÀY cho location đó (closing_snapshot)
        │
        ▼
   4. Engine cảnh báo chấm mức đỏ/vàng/xanh cho từng mã
        │
        ▼
   5. Sinh bản nháp đặt hàng → người có quyền DUYỆT → XUẤT FILE PDF (theo NCC)
```

Cổng xác nhận nằm ở `daily_stock_movement`. **Chỉ khi cả hai động tác "đã nhập" và "đã xuất" được xác nhận**, hệ thống mới chốt `closing_snapshot` và mở nút xuất PDF. Điều này khớp chính xác yêu cầu: phải có động tác của bộ phận thì mới ra số tồn và mới đặt hàng.

### 3.2. Công thức tồn cuối ngày (theo địa điểm)

```
closing_stock(ingredient, location) =
      tồn_đầu_ngày(location)
    + Σ nhập_trong_ngày (IMPORT + TRANSFER_IN)
    − Σ xuất_trong_ngày (TRANSFER_OUT + ISSUE)
```

> Đây là **tồn vật lý theo vận động kho (issue-based)** — khác với *tồn lý thuyết theo công thức POS* ở §4. Xem §5 để hiểu hai con số này phối hợp ra sao (điểm dễ sai nhất của cả hệ thống).

### 3.3. Engine chấm mức cảnh báo — THEO NHU CẦU, không so min tĩnh

> **Phản biện:** chấm đỏ/vàng chỉ bằng "tồn < min" là thiếu — một mã đang "xanh" hôm nay vẫn có thể **hết hàng trước kỳ giao kế tiếp** nếu mai có tiệc lớn hoặc lead time dài. v9 chấm mức theo **tồn dự phóng tại thời điểm giao hàng kế tiếp**:

```
projected = closing_stock
          + Σ PO_đang_mở_về_trước_kỳ_giao_kế_tiếp
          − dự_báo_tiêu_thụ_đến_kỳ_giao_kế_tiếp        (TB động 14 ngày, +hệ số cuối tuần)

status =
  🔴 OUT       nếu closing_stock ≤ 0
  🔴 CRITICAL  nếu projected ≤ safety_stock
  🟡 LOW       nếu projected ≤ min_stock
  🟢 OK        còn lại

suggested_order(purchase_uom) =
  roundup_to_pack( max(max_stock − projected, moq_nếu_kích_hoạt), pack_size )
```

### 3.4. Chứng từ PDF đặt hàng — cấu trúc & cách sinh

- **Gom theo nhà cung cấp ưu tiên** → mỗi NCC một PDF (PO_Thịt_NCC-A, PO_RượuVang_NCC-B...). Mặt hàng chợ (`MANUAL_REQUISITION`) ra một phiếu đề xuất mua tay riêng.
- **Bố cục PDF**: tiêu đề + số chứng từ + ngày + bộ phận; bảng dòng hàng **sắp xếp đỏ → vàng → xanh**, mỗi dòng: mã, tên, tồn hiện tại, mức cảnh báo (màu), **số lượng đề xuất đặt (theo đơn vị mua: thùng/kg)**, NCC; chân phiếu: người lập, ô ký duyệt, `doc_no`, mã hash/QR.
- **Sinh PDF ngay trên trình duyệt** (pdfmake/react-pdf) → 0 chi phí compute server. Sau khi duyệt, upload file + `content_hash` lên Supabase Storage, ghi `order_documents` (đây là **chứng từ mua hàng → giữ lâu dài, không nằm trong retention tự xóa**).

### 3.5. Hợp nhất với Auto-PO 22h40 (bỏ rủi ro "gửi mù")

> **Phản biện:** nếu để Auto-PO 22h40 *tự gửi* đồng thời tồn tại nút *xuất PDF thủ công*, sẽ có **hai cơ chế đặt hàng đá nhau → đặt trùng**. v9 hợp nhất:

1. 22h40, `pg_cron` tính toán và sinh **bản nháp** `order_documents (status='DRAFT')` — **không gửi đi**.
2. Sáng hôm sau (hoặc cuối ca), bộ phận xác nhận "đã nhập/đã xuất" → `closing_snapshot` **làm tươi lại bản nháp** bằng số tồn vật lý thật.
3. Người có quyền (Cấp 4 / Quản lý / Trưởng quầy với Bar) **review → APPROVED → xuất PDF (SENT)**. Chỉ khi đó đơn mới gửi NCC.

→ Một pipeline duy nhất, có người gác cổng, vừa nhanh (máy tính trước) vừa an toàn (người duyệt sau).

---

## 4. (GIỮ TỪ v8) LOGIC LÝ THUYẾT THEO POS

Các phần Moving WAC chống tồn âm + Landed cost (§4A v8), Trừ kho công thức bỏ ×1.10 (§4B v8), Mapping POS học được, FEFO/HACCP, Variance lọc nhiễu theo `tolerance_percent`, Khóa sổ ngày — **giữ nguyên**. v9 chỉ thêm: mọi giao dịch lý thuyết nay gắn `location_id` để tách dòng tiêu thụ Bếp vs Bar.

---

## 5. ĐIỂM MẤU CHỐT: HAI CON SỐ TỒN PHẢI ĐƯỢC ĐỊNH NGHĨA RÕ

Đây là rủi ro thiết kế lớn nhất khi thêm Module 2, cần chốt ngay:

| | **Tồn VẬT LÝ (issue-based)** | **Tồn LÝ THUYẾT (recipe-based)** |
| :-- | :-- | :-- |
| Nguồn | Nhập/Xuất/Chuyển kho do bộ phận thao tác (§3) | Doanh số POS × định mức công thức (§4) |
| Dùng để | **Đặt hàng (PDF) + kiểm kê** = nguồn sự thật về *on-hand* | **Food cost % + phát hiện variance** |
| Ai chủ trì | Thủ kho / Trưởng quầy | Kế toán / CFO |

**Quy tắc vàng:** đơn đặt hàng **luôn chạy trên tồn vật lý** (số thật bộ phận chốt), còn tồn lý thuyết dùng để **soi chênh lệch**. Cuối ngày/cuối tuần, hệ thống đặt hai con số cạnh nhau: `Variance = Tồn lý thuyết − Tồn vật lý`. Nếu để PDF đặt hàng chạy nhầm trên tồn lý thuyết (vốn có thể sai do quên khai waste), sẽ **đặt sai số lượng**. Phải tách bạch tuyệt đối.

---

## 6. PHÂN QUYỀN BỔ SUNG v9

| Vai trò mới | Phạm vi (location) | Quyền |
| :-- | :-- | :-- |
| **BAR_SUPERVISOR** (Trưởng quầy) | `BAR` | Duyệt đếm cuối ca, xác nhận "đã nhập/đã xuất" của Bar, **duyệt & xuất PDF đặt hàng Bar**. Không thấy doanh thu. |
| **BARTENDER** | `BAR` | Nhập đếm cân (PIN cá nhân), khai vỡ/đổ/comp. Không duyệt, không xuất PDF. |

Bổ sung quyền cho luồng Module 2:
- **Xác nhận "đã nhập / đã xuất trong ngày"**: Thủ kho (Cấp 7) cho Kho tổng/Bếp; Trưởng quầy cho Bar.
- **Duyệt & xuất PDF đặt hàng**: Cấp 4 (Kế toán kho) cho Bếp/Kho tổng; Trưởng quầy + đồng duyệt Cấp 4 cho Bar. Cấp 1 thấy toàn bộ kèm giá trị tiền.

---

## 7. PHẢN BIỆN & RỦI RO MỚI CẦN XỬ LÝ

1. **Cổng xác nhận có thể bị "quên bấm".** Nếu bộ phận không bấm "đã nhập/đã xuất", tồn cuối ngày không chốt → mất đơn đặt hàng. Cần **deadline + watchdog**: ví dụ 23h00 mà location chưa CLOSED → email nhắc Trưởng bộ phận + cho phép Cấp 2 chốt thay (có ghi `audit_log`).
2. **Định nghĩa "đã xong" phải chặt.** "Đã nhập xong" nghĩa là *mọi* hóa đơn trong ngày (kể cả phiếu `pending` của Cấp 7) đã được duyệt? Hóa đơn về **sau** khi đã chốt phải **đẩy sang ngày kế tiếp**, không được lén sửa số đã khóa (đụng nguyên tắc ledger bất biến). Cần quy tắc rõ cho hóa đơn trễ.
3. **Hai con số tồn (vật lý vs lý thuyết) — xem §5.** Đây là lỗi tiềm ẩn dễ làm cả hệ thống mất tin cậy nếu không tách bạch. Phải chốt: **PDF đặt hàng chạy trên tồn vật lý.**
4. **Tồn vật lý âm.** Nếu xuất nhiều hơn (đầu kỳ + nhập), tồn issue-based âm → chặn xuất PDF với số âm, bắn cảnh báo "thiếu chứng từ nhập" (song song với cơ chế chống tồn âm của WAC).
5. **Hiệu chuẩn cân Bar phải được bảo trì.** Vỏ chai cùng mã có thể lệch vài gram giữa các lô; nên cho phép cập nhật `empty_weight_grams` định kỳ và đặt **dung sai cân** (vd ±5g) để không báo nhiễu. Cân điện tử cần kiểm định định kỳ — sai số cân = sai pour variance.
6. **PDF là chứng từ tài chính, không phải bản in tạm.** Bắt buộc `doc_no` tuần tự + `content_hash` + lưu trữ bất biến + nhật ký ai sinh/ai duyệt. Tránh tình trạng in nhiều bản PDF khác nhau cho cùng một ngày mà không truy được bản nào đã gửi.
7. **Bar tablet dùng chung = rủi ro bảo mật vật lý.** Cần **auto-logout phiên quầy sau X phút**, PIN không hiển thị, và khóa không cho Bartender xem dữ liệu location khác. Cân nhắc nhật ký thiết bị (device id) cho phiên Bar.
8. **Mất mạng tại bếp/bar.** Khu bếp/quầy hay sóng yếu; nếu tablet rớt mạng lúc đếm cân/khai waste, thao tác có thể mất. Nên cho **lưu tạm cục bộ (offline queue) + đồng bộ lại kèm idempotency** để không mất và không nhân đôi bản ghi.
9. **Chuyển kho nội bộ phải khớp hai chân.** TRANSFER_OUT (kho tổng) và TRANSFER_IN (bếp/bar) phải bằng nhau và cùng `transfer_id`; lệch chân = thất thoát "trên đường nội bộ" cần báo. Đây là khe hở thất thoát mới mà mô hình đa địa điểm mở ra — phải kiểm soát.
10. **Mức cảnh báo cần dữ liệu đặt bàn để chính xác hơn.** TB động 14 ngày là khởi điểm; nhà hàng cao cấp nên gắn **số cover/đặt bàn** vào `dự_báo_tiêu_thụ` để mức cảnh báo phản ánh tiệc lớn — nếu không, vẫn có thể thiếu hàng cho sự kiện đã biết trước.

---

## 8. CẬP NHẬT KẾ HOẠCH 90 NGÀY (CHÈN 2 MODULE MỚI)

- **Giai đoạn 1 (Tuần 1–2):** thêm khai báo `locations` (Kho tổng/Bếp/Bar) ngay khi nạp tồn đầu kỳ — đếm tồn đầu kỳ **theo từng địa điểm**.
- **Giai đoạn 3 (Tuần 5–6):** dựng luồng **Nhập/Xuất/Tồn cuối ngày** + engine cảnh báo + **xuất PDF nháp** (chưa gửi NCC) để chạy thử.
- **Giai đoạn 4 (Tuần 7–8):** hợp nhất Auto-PO ↔ PDF (DRAFT→APPROVED→SENT); cấu hình deadline/watchdog cho cổng xác nhận.
- **Giai đoạn 5 (Tuần 9–12, chạy song song):** bật **cổng đăng nhập Bar `/bar`** + hiệu chuẩn cân 2 điểm + đếm mở/đóng ca; theo dõi pour variance theo từng bartender; tinh chỉnh dung sai cân.
- **Giai đoạn 6 (Tuần 13–14):** SOP video bổ sung 2 vai trò Bar; hướng dẫn quy trình xuất & duyệt PDF đặt hàng.

---

## PHỤ LỤC A — MẪU CHỨNG TỪ PDF ĐẶT HÀNG (ĐÃ DUYỆT GIAO DIỆN)

> Phụ lục này chốt **bố cục chuẩn** của file PDF do Module 2 (§3) sinh ra. Hai file mẫu thực tế đi kèm:
> - `PO_2026-0612_BEP_NCC-DaiDuong.pdf` — phiếu Bếp (NCC thịt & hải sản nhập khẩu).
> - `PO_2026-0612_BAR_NCC-HaiDang.pdf` — phiếu Bar (NCC rượu & đồ uống).
> Mỗi nhà cung cấp một file độc lập (đúng nguyên tắc gom theo NCC).

### A.1. Quy ước số chứng từ
`doc_no = PO-{YYYY}-{MMDD}-{LOCATION}-{seq3}` — ví dụ `PO-2026-0612-BEP-001`, `PO-2026-0612-BAR-001`. Số tuần tự sinh bằng trigger DB, không trùng, không nhảy cách.

### A.2. Bố cục phiếu (các khối bắt buộc)
1. **Header thương hiệu**: tên nhà hàng (MAISON VIE) + dòng định danh hệ thống + tiêu đề "PHIẾU ĐỀ XUẤT ĐẶT HÀNG / PURCHASE ORDER (AUTO-PO)".
2. **Khối thông tin**: Số CT · Ngày lập · Bộ phận · Giao dự kiến || Nhà cung cấp · Liên hệ · Lead time · Điều khoản.
3. **Chú giải 3 mức cảnh báo**: 🔴 KHẨN CẤP (tồn ≤ an toàn / hết) · 🟡 SẮP HẾT (tồn ≤ tối thiểu) · 🟢 ĐỦ TỒN (không đặt kỳ này).
4. **Bảng danh mục đặt** (sắp theo mức cảnh báo, đỏ → vàng): STT · Mã · Tên hàng · ĐVT tồn · Tồn hiện tại · **Dự phóng khi giao** · Mức cảnh báo (ô màu) · **SL đặt** · ĐVT mua (quy cách).
5. **Dòng tổng kết**: số mặt hàng cần đặt, số khẩn cấp/sắp hết.
6. **Bảng theo dõi (🟢)**: mặt hàng đã đánh giá nhưng đủ tồn, không đặt kỳ này (minh bạch toàn bộ kết quả chấm mức).
7. **Khối phê duyệt 3 cấp**: Người lập · Duyệt kho/Trưởng bộ phận · Phê duyệt (KT/CFO) — có ô ký.
8. **Chân phiếu**: `doc_no` · `SHA-256` (32 ký tự đầu) · số trang · dòng nhắc "bản nháp chỉ có hiệu lực sau khi được DUYỆT & ký".

### A.3. Quy tắc số liệu thể hiện trên phiếu (gắn với logic §3)
- **"Tồn hiện tại" = tồn VẬT LÝ** do bộ phận chốt (issue-based, §5) — không dùng tồn lý thuyết POS.
- **"Dự phóng khi giao"** = tồn hiện tại + PO đang mở về kịp − dự báo tiêu thụ tới kỳ giao (chấm mức theo nhu cầu, không so min tĩnh).
- **"SL đặt"** = `roundup_to_pack(max(max_stock − dự_phóng, MOQ), pack_size)` → luôn quy về **đơn vị mua** (thùng/kg) của từng NCC.

### A.4. Tính bất biến & bảo mật chứng từ
- Mỗi phiếu lưu một bản ghi `order_documents` với `content_hash` (SHA-256 trên payload dòng hàng). In lại nhiều lần vẫn truy được bản nào đã `SENT`.
- Vòng đời: `DRAFT` (máy sinh 22h40) → `APPROVED` (đủ chữ ký duyệt) → `SENT` (gửi NCC). **Chưa APPROVED thì chưa gửi.**
- File PDF lưu Supabase Storage; là **chứng từ mua hàng → giữ lâu dài**, không nằm trong retention tự xóa.

### A.5. Cách render (đúng triết lý tối ưu chi phí)
- Hệ thống thật: render **client-side trên trình duyệt** bằng `pdfmake`/`react-pdf` từ payload JSON → 0 chi phí compute server, rồi upload PDF + hash về Storage.
- Mẫu trong phụ lục này sinh tạm bằng Python/reportlab chỉ để **duyệt giao diện**; bố cục/field giữ nguyên khi chuyển sang client-side.

### A.6. Tùy chọn cấu hình cần chốt khi vào code
- **Cột Đơn giá / Thành tiền**: chỉ hiện trên **bản nội bộ của Cấp 4/CFO**; **ẩn** ở bản PDF gửi NCC (theo phân quyền tài chính: NCC và các cấp khác không thấy giá vốn nội bộ). *(Mặc định khuyến nghị: bật cho bản nội bộ, tắt cho bản gửi.)*
- **Logo Maison Vie**: chèn ở header khi có file thương hiệu chính thức.
- **Cột "Hạn giao mong muốn" / ghi chú dòng**: tùy chọn bật cho NCC cần lịch giao chi tiết.

---
*Hết bản v9.0. Các khối SQL là bản phác kiến trúc; khi vào code cần bổ sung index, ràng buộc khớp hai chân TRANSFER, trigger sinh `doc_no` tuần tự và policy RLS theo `location_id`. Mẫu chứng từ PDF ở Phụ lục A đã được duyệt giao diện, sẵn sàng để dựng bản render client-side.*

---

## 9. THỰC TẾ TRIỂN KHAI & CẬP NHẬT KHO BÊN TRONG (15/06/2026 - v9.3)

Hệ thống đã được cập nhật thực tế theo đúng yêu cầu gộp vai trò đăng nhập và chuẩn hóa kho Bar của chủ đầu tư:

### 9.1. Gộp Đăng nhập & Tinh giản Phân quyền
- **Cắt bỏ hoàn toàn** trang đăng nhập phụ `/bar` dùng mã PIN tablet. Thay vào đó, tích hợp trực tiếp 4 nút đăng nhập sandbox ngay tại trang chủ (`/`):
  1. `Owner / CFO / Admin` (Tương đương vai trò `admin`)
  2. `Chef / Manager / Thủ Kho` (Tương đương vai trò `restaurant_manager`)
  3. `SousChef / Kế toán` (Tương đương vai trò `senior_accountant`)
  4. `Bar` (Tương đương vai trò `BAR_SUPERVISOR`)
- Cấu hình lại logic chuyển Tab `hasTabAccess` ở [src/app/page.tsx](file:///D:/Invenroty/maison-vie-crm/src/app/page.tsx) để mở rộng đầy đủ các quyền nghiệp vụ cho các vai trò gộp mới này.

### 9.2. Phân tách Dữ liệu Bếp / Bar Cô lập
- Cơ chế lọc động `roleFilteredIngredients` và `filteredStockCountIngredients` tự động ẩn thực phẩm/đồ bếp khi người dùng thuộc bộ phận Bar đăng nhập, và ngược lại tự động ẩn rượu/bia/đồ uống khi người dùng thuộc bộ phận Bếp đăng nhập.
- Áp dụng phân tách này cho:
  - **Bảng Master Kho (Tab 1)**
  - **Phiếu Kiểm Kho & Cân dở điện tử (Tab 5)**
  - **Biểu mẫu Chuyển kho nội bộ**
  - **Biểu mẫu Tiêu hao ngoài bán hàng (Spill, Breakage, Comp, Tasting)**

### 9.3. Nhập 183 mã đồ uống & Chuẩn hóa Mappings POS từ Excel
- Đọc và import tự động toàn bộ **183 mặt hàng Bar** từ tệp [MAISON_VIE_v6_0_PRO.xlsx](file:///D:/Invenroty/MAISON_VIE_v6_0_PRO.xlsx) sheet `MASTER_BAR` vào danh mục nguyên liệu.
- Cập nhật ánh xạ POS trong [mockData.ts](file:///D:/Invenroty/maison-vie-crm/src/data/mockData.ts):
  - Bia Heineken, Tiger, 333, Sài Gòn, Sapporo, nước ngọt, vang chai, rượu mạnh... tự động trừ kho 1-1 theo mã POS bán ra.
  - Các đồ uống pha chế bằng nguyên liệu phụ (Nước cam, xoài, dưa hấu, mocktail Virgin Mojito, Shirley Temple...) hoặc ly rượu lẻ được tự động quy đổi để trừ hao hụt các nguyên liệu quả/sữa/syrup/rượu nền tương ứng.
- Đã bổ sung 183 mặt hàng, đơn vị tính mới (`CAN`, `GLASS`, `PACK`, `BOX`, `BAG`), và liên kết nhà cung cấp vào tệp hạt giống [supabase/seed.sql](file:///D:/Invenroty/maison-vie-crm/supabase/seed.sql) để sẵn sàng đồng bộ lên Supabase Cloud.

---
*Bản cập nhật v9.3 hoàn tất ngày 15/06/2026. Hệ thống chạy ổn định, build production thành công.*

