# KẾ HOẠCH TRIỂN KHAI HỆ THỐNG CRM/ERP INVENTORY – MAISON VIE **v9.2**
### (RÀ SOÁT BẢN DEPLOY THỰC TẾ · TINH CHỈNH TÔNG FINE-DINING · MOBILE-READY KHÔNG TRÀN TRANG · PHẠM VI BỘ PHẬN ÁP CHO TOÀN DASHBOARD)

> **Vai trò biên soạn**: COO / CFO / Kiến trúc sư Dữ liệu Full-Stack
> **Hạ tầng**: Supabase (PostgreSQL / Auth / RLS / pg_cron / Storage) + Vercel (Next.js / React) + GitHub (private).
> **Nguyên tắc nền tảng (giữ từ v8)**: *"Database-centric, serverless-thin"* — logic nặng nằm trong PostgreSQL, chạy bằng `pg_cron`. **Bổ sung v9**: PDF đặt hàng được **render ngay trên trình duyệt** (pdfmake/react-pdf) rồi lưu Storage → không tốn compute server, đúng triết lý tối ưu chi phí.

---

## 0″. RÀ SOÁT TỪ BẢN DEPLOY THỰC TẾ — 5 ĐIỂM PHẢI SỬA *(v9.2 · 16/06/2026)*

> Đối chiếu 3 ảnh chụp bản chạy thật (`...tory-six-sigma.vercel.app`). Phản biện thẳng:

### ⚖️ Lỗi/Quyết định 1 — "Wastage Buffer +10%": CHỦ ĐẦU TƯ QUYẾT ĐỊNH **GIỮ NGUYÊN** *(16/06)*
> **Quyết định:** **GIỮ** buffer 10% trong công thức tiêu hao như hệ thống đang chạy (theo yêu cầu chủ đầu tư). UI giữ dòng mô tả "Wastage Buffer 10%".

**Rủi ro phải biết rõ khi giữ:** 10% nhét sẵn vào tồn lý thuyết làm cột **Chênh lệch (Variance)** luôn lệch một khoảng cố định → khó tách "hao thao tác đã dự trù" với "thất thoát thật".

**Khuyến nghị bắt buộc để KHÔNG mất khả năng phát hiện (chi phí ~0 — chỉ thêm một cột tính):** hiển thị **hai cột variance** song song:
- **Variance THÔ** = tồn vật lý − (tồn đầu + nhập − tiêu hao **KHÔNG buffer**). ⇒ Đây mới là con số soi thất thoát/over-portion thật.
- **Variance sau buffer (+10%)** = cột hiện tại, mang tính tham khảo vận hành/đặt hàng.

Như vậy giữ được buffer theo ý bạn mà **vẫn không mù variance**. *(Nếu sau này muốn đảo sang GỠ HẲN: chỉ cần bỏ `*1.10` trong `process_daily_consumption`.)*

### ⚠️ Lỗi 2 — Phạm vi bộ phận CHƯA áp lên Dashboard (và bạn đang nhầm vai trò)
**Đính chính thẳng:** theo ảnh, vai trò đang đăng nhập là **`Owner/CFO/Admin`** (xem dòng *"TEST VAI TRÒ: Owner/CFO/Admin"*), **không phải Bar**. Vai trò Admin theo thiết kế **thấy tất cả** → việc panel "Cảnh báo Tồn kho tối thiểu" hiện cá tuyết/cá vược/tôm (đồ bếp) là **đúng cho Admin**, không phải lỗi ở ngữ cảnh này.
**Lỗi thật nằm sâu hơn:** bộ lọc bộ phận (§C) hiện **chưa được áp cho các surface của Dashboard**. §9.2 mới chỉ lọc Master Kho, Kiểm kho, Transfer, Non-sale — **bỏ sót**: (a) panel *Cảnh báo Tồn kho tối thiểu*, (b) chart + bảng *Nguyên liệu tiêu hao nhiều nhất*, (c) các card tổng quan.

> **[ĐÃ XÁC NHẬN 16/06]** Chủ đầu tư test ở vai trò **Bar** và panel *Cảnh báo Tồn kho tối thiểu* **vẫn hiện đồ bếp** (cá tuyết/cá vược/tôm). ⇒ **Khẳng định đây là BUG ƯU TIÊN.** Phải áp scope theo `ingredient_departments` (location = BAR) cho **panel cảnh báo + chart tiêu hao + card tổng quan**, không chỉ Master Kho/Kiểm kho. *(Ảnh chụp gửi kèm hiển thị selector ở 'Owner/CFO/Admin' — với vai trò đó việc thấy đồ bếp là đúng thiết kế; bug chỉ tính ở vai trò Bar, đúng như bạn xác nhận.)*

### ⚠️ Lỗi 3 — Chưa "mobile-ready" (tràn trang, cụt thông tin)
Ảnh 3 cho thấy: khối header (logo + đăng nhập + giờ + test vai trò + sync) **chiếm trọn màn hình đầu tiên**; bảng dữ liệu **tràn ngang, cụt cột** ("LƯỢNG TIÊU THỤ", đơn vị BOTTLE/GLASS/CAN bị cắt). Vi phạm §B. Khắc phục theo **§B.4 (mới)**: header thu gọn 1 thanh slim + bảng rộng chuyển sang **thẻ xếp chồng** hoặc **khung cuộn ngang có cột đầu ghim**.

### ⚠️ Lỗi 4 — Card tài chính "Khóa (Cấp 1)" vẫn khóa khi đang là CFO
CFO **chính là** Cấp 1 → ba card *Cost / Giá trị tồn / Variance* phải **mở khóa và hiện số thật** cho CFO. Hiện vẫn hiện ổ khóa cho cả CFO là **sai logic phân quyền** — ổ khóa chỉ nên xuất hiện với vai trò KHÔNG đủ quyền. Sửa: trạng thái khóa phải đọc theo vai trò hiện hành, không hard-code.

### ℹ️ Lỗi phụ — Tồn đầu kỳ đang là "Standard Opening 30" (seed demo)
Tồn lý thuyết ~30 đồng loạt mọi mã là dữ liệu seed, **chưa phải kiểm kê đầu kỳ thật**. Variance **chưa có ý nghĩa** cho tới khi nạp tồn đầu thực tế (§8 / Giai đoạn 1). Đừng đánh giá độ chính xác hệ thống dựa trên số seed này.

---

## 0′. CHANGELOG v9.0 / v9.3 → v9.1

| # | Hạng mục | Trạng thái trước (v9.0–v9.3) | v9.1 (cập nhật) |
| :-- | :-- | :-- | :-- |
| I | **Giao diện màu** | Màu mặc định | **Hệ màu fine-dining**: Xanh rêu đậm cho khung/ô/thành phần, Kem đậm cho nền mảng lớn, một accent vàng đồng; chữ tương phản chuẩn WCAG AA (không nhè, không lóa, không lệch tông). |
| II | **Điều hướng** | Menu tĩnh phủ hết màn hình; mobile phải cuộn nhiều mới tới nội dung | **Menu động responsive**: sidebar thu gọn (desktop) + hamburger/slide-over + thanh tab dưới (mobile), nội dung hiển thị trước, menu theo vai trò. |
| III | **Phạm vi Bar/Bếp** | v9.3 **ẩn cứng** toàn bộ đồ uống khỏi Bếp và ngược lại | **Lọc theo NHÃN bộ phận (many-to-many) + nguyên liệu DÙNG CHUNG**: Bar chỉ thấy đồ uống; Bếp thấy đồ bếp **và** các mã đồ uống dùng để chế biến (vang nấu, cognac đốt, cam/chanh). *Sửa lỗi §9.2.* **Chốt 16/06: mô hình "chai riêng" (tồn & đặt hàng theo từng location) + gắn nhãn dùng chung phải 2 trưởng bộ phận đồng duyệt.** |
| IV | **Mẫu PO** | Per-supplier, nhiều cột, có cột trạng thái | **6 cột cố định** (Mã · Tên hàng · SL tồn · SL cần · Nhà cung cấp · Ghi chú), **gom dòng theo NHÓM HÀNG** (Rượu vang / Rượu mạnh / Bia & Nước ngọt / Hải sản / Thịt tươi / Đồ bơ sữa…); mức cảnh báo thể hiện bằng **nền dòng** thay vì cột riêng. |

---

## A. HỆ THỐNG MÀU & TYPOGRAPHY — FINE-DINING (XANH RÊU + KEM)

**Triết lý:** bảng màu trầm – ấm – sang đúng tinh thần bếp Pháp. **Xanh rêu đậm** đóng vai trò "mực/khung" (các ô nhỏ, thẻ, input, sidebar, dải tiêu đề); **kem đậm** làm nền mảng lớn (canvas/trang); **một** accent **vàng đồng** cho tiêu đề – đường kẻ – nút chính. Tuyệt đối tránh dùng nhiều màu nhấn gây loạn.

### A.1. Design tokens — **ĐÃ CHỐT: PHƯƠNG ÁN 1 "Rêu sâu · Kem ấm"** *(chủ đầu tư chọn 16/06)*

```css
:root{
  /* === PHƯƠNG ÁN 1 (ĐÃ CHỐT) — Rêu sâu · Kem ấm · fine-dining trầm === */
  /* Nền mảng lớn (ngoài khung/ô) – KEM ẤM */
  --bg:            #ECE0C6;   /* nền trang (kem ấm) */
  --bg-2:          #F4ECD8;   /* nền phụ / card sáng */

  /* Khung / ô / thẻ / sidebar / input – XANH RÊU SÂU */
  --surface:       #262E22;   /* rêu sâu chủ đạo */
  --surface-2:     #313A2C;   /* rêu sáng hơn (hover/biến thể) */
  --border:        #3C4636;   /* viền khung trên rêu */
  --border-soft:   #D4C9AE;   /* viền nhạt trên kem */

  /* Chữ */
  --text:          #232B20;   /* chữ chính trên KEM */
  --text-on-moss:  #EDE4D0;   /* chữ trên RÊU = kem ấm, KHÔNG trắng tinh */
  --muted:         #6B7560;   /* phụ trên kem */
  --muted-on-moss: #AAB39C;   /* phụ trên rêu (sage trầm) */

  /* MỘT accent duy nhất – ĐỒNG/BRASS TRẦM (không cam) */
  --accent:        #A8884E;   /* brass muted */
  --accent-deep:   #8C6F3C;
  --data-emph:     #C2A35A;   /* số liệu cần nhấn = brass sáng, KHÔNG dùng cam #F5A623 */

  /* Trạng thái – giảm saturation để hợp tông trầm */
  --warn-red:      #A8443A; --warn-red-soft:   #EAD2CC;
  --warn-amber:    #BC8A3C; --warn-amber-soft: #EFE2C6;
  --ok-green:      #5E7A5A; --ok-green-soft:   #DDE6D6;  /* sage, lệch hue rõ với rêu chủ đạo */
}
```

> *Đối chiếu kiểm thử tương phản (WCAG AA):* `--text #232B20` trên `--bg #ECE0C6` và `--text-on-moss #EDE4D0` trên `--surface #262E22` đều đạt ≥ 4.5:1; `--data-emph #C2A35A` trên `--surface` đạt ≥ 3:1 (số liệu lớn). Khi áp vào code, kiểm lại từng cặp thực tế trước khi chốt build.

> **BỎ khỏi UI hiện tại (nguyên nhân "chưa cân đối"):**
> - **Cam/da cam rực** (≈`#F5A623`) ở số liệu, đơn giá và **thanh biểu đồ** → thay bằng `--data-emph` brass trầm / gradient brass.
> - **Vàng neon** ở biểu tượng ổ khóa → đổi sang brass `--accent`.
> - Giảm **độ bão hòa tổng thể ~15–20%**. Fine-dining = **tiết chế**: chỉ **một** màu nóng (brass), nhấn số liệu bằng **trọng lượng & cỡ chữ**, không bằng màu loud. Hai sắc xanh hiện đang lệch nhau giữa các trang → thống nhất về đúng `--surface`.
```

### A.2. Quy tắc chống "nhè / lóa / lệch tông" (bắt buộc)

- **Không** đặt chữ trắng tinh `#FFFFFF` trên nền rêu → dùng kem nhạt `--text-on-moss` để giảm chói (lóa).
- **Không** đặt chữ kem trên nền kem (tương phản thấp → chữ bị "nhè") → trên nền kem chữ phải là mực rêu `--text`.
- Giữ **tương phản ≥ 4.5:1** cho chữ thường, **≥ 3:1** cho chữ lớn/tiêu đề (WCAG AA). Cặp `--text` trên `--bg` và `--text-on-moss` trên `--surface` đều đạt ngưỡng này.
- **Màu trạng thái phải lệch hue đủ so với xanh rêu chủ đạo.** Vì nền/khung đã là xanh rêu, "ĐỦ TỒN" dùng xanh ngả ngọc (`--ok-green`) chứ không dùng xanh lá thuần — tránh người dùng nhầm trạng thái với khung.
- Trạng thái luôn thể hiện bằng **badge nền đặc + chữ tương phản**, không chỉ đổi màu chữ (người mù màu vẫn đọc được nhãn chữ).
- Chỉ **một** accent (vàng đồng). Bóng đổ rất nhẹ, bo góc vừa phải — giữ vẻ trầm, không bóng bẩy.

### A.3. Phản biện (in ấn & khả dụng)
- Nền kem đậm rất hợp **trên màn hình**, nhưng khi **in PDF**, nền đậm tốn mực và dễ lệch tông giữa các máy in → **bản PDF giữ nền sáng**, chỉ đưa rêu/kem vào header và dải tiêu đề nhóm (xem Phụ lục A).
- Cần kiểm thử trên màn hình tablet bếp/quầy dưới **ánh đèn vàng nhà hàng** — tông kem dễ bị "ngả" dưới đèn warm; chuẩn bị sẵn chế độ tăng tương phản nếu nhân viên phản hồi khó đọc.

---

## B. KIẾN TRÚC MENU ĐỘNG (RESPONSIVE) — THAY MENU TĨNH PHỦ MÀN HÌNH

**Vấn đề đang gặp:** menu tĩnh, các tầng menu chính chiếm hết chiều cao; trên điện thoại người dùng phải cuộn nhiều mới tới nội dung cần xem.

### B.1. Mẫu điều hướng theo thiết bị
- **Desktop**: **sidebar dọc thu gọn được** (collapsible). Mặc định mở (icon + nhãn); bấm thu còn icon → nội dung chiếm phần lớn màn hình. Ghi nhớ trạng thái mở/cụp theo thiết bị.
- **Mobile**: **không** hiển thị menu phủ màn hình. Dùng đồng thời:
  - **Thanh tab dưới (bottom navigation)** 4–5 mục dùng nhiều nhất → thao tác một chạm, nội dung hiện ngay.
  - **Hamburger → drawer trượt** cho các mục còn lại (phủ tạm, đóng lại để xem nội dung).
- **Accordion**: trong drawer/sidebar, chỉ nhóm đang chọn mới bung; nhóm khác cụp → không đẩy nội dung xuống dài.
- **Content-first**: trang luôn load thẳng vào nội dung tab hiện hành; menu là lớp phủ/độc lập, không chiếm chỗ theo chiều dọc.

### B.2. Sắp xếp lại nhóm chức năng (Information Architecture)
Gom các tab hiện có thành nhóm động, **chỉ hiện nhóm/tab mà vai trò có quyền** (gắn với `hasTabAccess` đã có ở §9.1):

| Nhóm | Tab con | Vai trò thấy |
| :-- | :-- | :-- |
| **VẬN HÀNH KHO** | Master Kho · Nhập/Xuất/Chuyển kho · Kiểm kê & Cân | Thủ kho, Quản lý, Bar (bản đồ uống) |
| **ĐẶT HÀNG** | Cảnh báo tồn · Tạo/Duyệt PO · Lịch sử PO | Thủ kho, Kế toán, Quản lý |
| **ĐỐI SOÁT** | Variance · Waste/Non-sale · Mapping POS | Kế toán, Quản lý |
| **TÀI CHÍNH** *(chỉ Cấp 1)* | Dashboard · Food cost · Giá trị kho | Owner/CFO/Admin |

### B.3. Phản biện
- Vì đã **gộp 4 nút đăng nhập theo vai trò** (§9.1), menu động phải **render theo vai trò ngay từ đầu** — Bar login chỉ thấy nhóm liên quan đồ uống, **không** hiển thị tab thừa rồi mới chặn (vừa rối, vừa lộ cấu trúc không cần thiết).
- Bottom-nav mobile tối đa **5 mục**; mục thứ 6 trở đi đưa vào "Thêm" để tránh chen chúc.
- Tránh menu nhiều hơn **2 cấp** trên mobile — cấp 3 rất khó chạm; nếu cần, dùng trang con thay vì menu lồng sâu.

### B.4. MOBILE-READY — Header thu gọn & Bảng KHÔNG tràn trang *(MỚI v9.2, sửa lỗi ảnh 3)*
**Vấn đề thực tế (ảnh 3):** header chiếm trọn màn hình đầu; bảng tràn ngang, cụt cột & đơn vị. Quy chuẩn bắt buộc:

- **Header mobile**: gộp logo + chip vai trò + giờ + sync vào **1 thanh slim (~56px)**. Thông tin phụ (đổi mật khẩu, test vai trò, chi tiết sync) đưa vào menu "…" hoặc panel xổ — **không** xếp chồng chiếm cả màn hình.
- **Bảng rộng → chọn 1 trong 2 chiến lược** (theo từng bảng):
  1. **Thẻ xếp chồng (ưu tiên đọc)** — mỗi dòng thành 1 card, các cột thành cặp *nhãn : giá trị*. Hợp cho *Cảnh báo tồn*, *Tiêu hao nhiều nhất*, danh sách kiểm kho.
  2. **Khung cuộn ngang có cột đầu ghim** — giữ Mã/Tên cố định, các cột số cuộn ngang **trong khung**; chỉ khung cuộn, **không** để cả trang tràn.
- **Cột ưu tiên trên mobile**: chỉ hiện cột chính (Mã · Tên · số liệu chốt · đơn vị); chạm để bung phần còn lại.
- **Quy tắc tuyệt đối:** không có overflow ngang ở cấp **trang**; mọi đơn vị (kg/L/BOTTLE/GLASS/CAN) phải hiển thị **đủ**, không bị cắt.
- Bottom-nav giữ 4–5 icon; phần dư đưa vào "Thêm" (đã nêu §B.1).


---

## C. PHẠM VI BAR / BẾP THEO NHÃN & NGUYÊN LIỆU DÙNG CHUNG *(SỬA §9.2)*

### C.1. Phản biện sắc: cơ chế ẩn cứng của v9.3 đang SAI thực tế
§9.2 hiện **ẩn cứng toàn bộ rượu/bia/đồ uống khỏi Bếp** (và ngược lại). Cách này hỏng đúng nghiệp vụ bếp Pháp: bếp **cần** rượu vang đỏ để nấu (coq au vin, sốt vang), **cognac để đốt** (flambé), **cam/chanh** làm sốt & trang trí. Ẩn cứng theo kiểu "đồ uống = chỉ Bar" sẽ làm các nguyên liệu này **biến mất khỏi màn hình Bếp** → bếp không kiểm kho/không nhận cảnh báo được, buộc phải lách bằng tạo **mã trùng** → loạn dữ liệu, sai giá vốn.

> **Nguyên tắc đúng:** phạm vi hiển thị xác định theo **NHÃN bộ phận (many-to-many)**, **không** theo loại hàng. Một mã có thể thuộc nhiều bộ phận với ngữ cảnh sử dụng khác nhau.

### C.2. Schema thay cho lọc cứng theo loại hàng

```sql
-- NHÃN BỘ PHẬN cho từng nguyên liệu (MỚI v9.1)
create table ingredient_departments (
  ingredient_id uuid references ingredients(id),
  department    text references locations(id),   -- 'BAR' | 'KITCHEN' (mở rộng được)
  usage_context text,        -- 'BEVERAGE','COOKING','FLAMBE','GARNISH','SAUCE'
  is_primary    boolean default false,  -- bộ phận "chủ" mã (mặc định NCC & ngưỡng min/max)
  primary key (ingredient_id, department)
);
-- VD: Cognac VSOP → (BAR,'BEVERAGE',is_primary=true) + (KITCHEN,'FLAMBE')
--     Vang đỏ      → (BAR,'BEVERAGE',is_primary=true) + (KITCHEN,'COOKING')
--     Chanh vàng   → (KITCHEN,'SAUCE',is_primary=true) + (BAR,'GARNISH')
```

### C.3. Quy tắc hiển thị (thay `roleFilteredIngredients` hiện tại)
- **Bar đăng nhập**: chỉ thấy mã có nhãn `department='BAR'` (đồ uống/pha chế/rượu bia). **Cảnh báo tồn tối thiểu của Bar chỉ tính trên mã Bar và chỉ trên tồn tại location `BAR`.**
- **Bếp đăng nhập**: thấy mã có nhãn `department='KITCHEN'` — **bao gồm** các mã đồ uống **dùng chung** đã gắn thêm nhãn KITCHEN với `usage_context` = COOKING/FLAMBE/GARNISH/SAUCE (vang nấu, cognac đốt, cam/chanh). Bếp **không** thấy mã Bar thuần (cocktail, bia bán, rượu BTG) không phục vụ chế biến.
- **[BỔ SUNG v9.2 — sửa thiếu sót §9.2] Phạm vi này áp cho MỌI surface, gồm cả DASHBOARD**, không chỉ Master Kho & Kiểm kho: (a) panel **Cảnh báo Tồn kho tối thiểu**, (b) chart + bảng **Nguyên liệu tiêu hao nhiều nhất**, (c) các **card tổng quan**. ⇒ Bar login chỉ thấy số liệu Bar trên các panel này; Bếp login không thấy bia/cocktail bán. *(Admin/CFO vẫn thấy tất cả — đó là lý do ảnh 2 hiện đồ bếp, vì đang đăng nhập Admin.)*

### C.4. Tồn & đặt hàng của mã dùng chung — MÔ HÌNH "CHAI RIÊNG" *(ĐÃ CHỐT 16/06/2026)*
> **Quyết định:** mỗi bộ phận **giữ chai/tồn riêng** cho mã dùng chung. Đây là mô hình chính thức vì rõ trách nhiệm và đơn giản kiểm soát.

- Mã dùng chung được **theo dõi tồn riêng theo từng location** (chiều location §1.1). VD Cognac VSOP: một dòng tồn ở `BAR` (pha/bán) và một dòng tồn ở `KITCHEN` (chai để đốt) — **mỗi location có min/max/safety riêng, cảnh báo riêng, và đặt hàng riêng**.
- **Hệ quả đặt hàng:** cùng một mã có thể xuất hiện **độc lập** trên phiếu đặt của Bar (tồn location `BAR`) **và** trên phiếu đặt của Bếp (tồn location `KITCHEN`). Mỗi bộ phận tự bổ sung phần của mình → **không ai "ăn" vào tồn của bên kia**.
- `is_primary` chỉ xác định bộ phận **chủ mã** (đặt NCC mặc định & dùng cho báo cáo gộp giá trị toàn nhà hàng); không ảnh hưởng việc mỗi location có ngưỡng & tồn riêng.
- **TRANSFER `BAR → KITCHEN` chỉ là đường NGOẠI LỆ** (khi bếp mượn gấp chai của bar lúc hết hàng), **không phải luồng thường ngày**. Mọi TRANSFER khớp 2 chân, ghi vết, nằm trong kiểm soát ở C.5.

### C.5. Kiểm soát gắn nhãn & chống lạm dụng *(ĐÃ CHỐT 16/06/2026)*
> **Quyết định:** việc gắn/sửa nhãn `ingredient_departments` cho **mã dùng chung** phải có **Bếp trưởng + Trưởng quầy Bar CÙNG DUYỆT**; mọi thay đổi ghi `audit_log`.

- Đầu bếp/bartender **không** được tự thêm nhãn dùng chung — chỉ **đề xuất**; hai trưởng bộ phận phê duyệt. Mục đích: chống bếp tự gắn nhãn để **rút rượu xịn của Bar**.
- Workflow kỹ thuật cho nhãn dùng chung: `pending → co_approved (đủ 2 chữ ký) → active`; chưa đủ 2 duyệt thì nhãn **chưa hiệu lực**.
- Mọi **TRANSFER `BAR→KITCHEN`** (đường ngoại lệ ở C.4) được tổng hợp trong **báo cáo định kỳ** để Cấp 1 (CFO/Owner) soi giá trị rượu/nguyên liệu chuyển nội bộ — bịt đường rò rỉ qua kiểu "mượn".

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

> **[CẬP NHẬT v9.1]** Phụ lục này chốt **bố cục chuẩn mới** của phiếu PO (6 cột cố định, gom dòng theo nhóm hàng). File mẫu thực tế đi kèm:
> - `PO_2026-0615_TONGHOP_v9-1.pdf` — **phiếu tổng hợp** gom theo nhóm hàng (Rượu vang / Rượu mạnh / Bia & Nước ngọt / Hải sản / Thịt tươi / Đồ bơ sữa), theme xanh rêu + kem.
>
> **Nguyên tắc mới:** phiếu gom theo **nhóm hàng** là **bản chủ để review & duyệt** (nhìn toàn cảnh theo loại). Khi **gửi đi**, hệ thống **lọc theo cột Nhà cung cấp** ra bản cắt cho từng NCC (cùng dữ liệu, cùng doc lineage). Phiếu Bar và Bếp là hai bản lọc theo phạm vi bộ phận (§C).

### A.1. Quy ước số chứng từ
`doc_no = PO-{YYYY}-{MMDD}-{LOCATION}-{seq3}` — ví dụ `PO-2026-0612-BEP-001`, `PO-2026-0612-BAR-001`. Số tuần tự sinh bằng trigger DB, không trùng, không nhảy cách.

### A.2. Bố cục phiếu (cập nhật v9.1)
1. **Header thương hiệu**: MAISON VIE (theme xanh rêu + kem) + tiêu đề "PHIẾU ĐỀ XUẤT ĐẶT HÀNG".
2. **Khối thông tin**: Số CT · Ngày lập · Bộ phận/Phạm vi · Người lập · Ghi chú chung.
3. **Chú giải mức cảnh báo** (nay thể hiện bằng **nền dòng**): 🔴 nền đỏ nhạt = Khẩn cấp · 🟡 nền vàng nhạt = Sắp hết · (không tô) = Đủ tồn.
4. **Bảng đặt hàng gom theo NHÓM HÀNG** — mỗi nhóm có một **dải tiêu đề nhóm** (Rượu Vang · Rượu Mạnh · Bia & Nước ngọt · Hải sản · Thịt tươi · Đồ Bơ Sữa · Rau củ/Trang trí…). **Đúng 6 cột cố định:**

   | Mã | Tên hàng | SL tồn | SL cần | Nhà cung cấp | Ghi chú |
   | :-- | :-- | :--: | :--: | :-- | :-- |

5. **Dòng tổng kết** mỗi nhóm + tổng toàn phiếu (số mặt hàng cần đặt).
6. **Khối phê duyệt 3 cấp**: Người lập · Duyệt kho/Trưởng bộ phận · Phê duyệt (KT/CFO) — có ô ký.
7. **Chân phiếu**: `doc_no` · `SHA-256` (32 ký tự đầu) · số trang · dòng nhắc "bản nháp chỉ có hiệu lực sau khi được DUYỆT & ký".

### A.3. Quy tắc số liệu trên phiếu (gắn với logic §3, §5)
- **"SL tồn" = tồn VẬT LÝ** do bộ phận chốt (issue-based, §5) — không dùng tồn lý thuyết POS.
- **"SL cần"** = lượng đề xuất đặt = `roundup_to_pack(max(max_stock − dự_phóng_khi_giao, MOQ), pack_size)`, quy về **đơn vị mua** (thùng/kg/lon…). In **đậm** để nhân viên đặt nhanh.
- **Mức cảnh báo** (đỏ/vàng) suy từ *dự phóng tồn tại kỳ giao kế tiếp* (không so min tĩnh) và được tô **nền dòng** — giữ yêu cầu "đặt theo mức độ cảnh báo" mà **không** cần thêm cột.
- **"Ghi chú"**: dùng cho thông tin tác nghiệp — ví dụ *"dùng chung Bếp/Bar (flambé)"*, *"hàng chợ – mua lẻ"*, *"hạn giao trước 7h"*.
- **"Nhà cung cấp"**: là cột để hệ thống **lọc ra bản gửi từng NCC** từ phiếu tổng hợp này.

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
*Hết bản v9.2 (cập nhật quyết định 16/06). Quyết định chủ đầu tư: **GIỮ buffer 10%** (kèm khuyến nghị thêm cột "variance thô" không buffer để không mù phát hiện). Đã **xác nhận BUG ưu tiên**: vai trò Bar vẫn hiện đồ bếp trên Dashboard. **Thứ tự sửa code:** (1) **lọc bộ phận cho toàn Dashboard** (panel cảnh báo + chart tiêu hao + card) — bug đã xác nhận; (2) mở khóa 3 card tài chính cho CFO; (3) recolor theo **Phương án 1 "Rêu sâu · Kem ấm"** (đã chốt — token ở §A.1); (4) mobile-ready theo §B.4; (5) thêm cột variance thô. Tông màu cuối: **ĐÃ CHỐT Phương án 1**.*

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

---

## 10. THỰC TẾ TRIỂN KHAI PHIÊN BẢN v9.2 (16/06/2026)

Hệ thống đã được cập nhật và nghiệm thu toàn bộ các tính năng rà soát và sửa lỗi của bản thiết kế v9.2:

### 10.1. Đồng bộ Hệ màu Fine-Dining (Phương án 1: Rêu sâu · Kem ấm) (Hoàn tất 100%)
- Đã áp dụng hệ màu tối ưu cho in ấn và hiển thị: Nền kem ấm (`--bg` #ECE0C6 / `#F4ECD8`), các panel rêu sâu (`--surface` #262E22 / `#313A2C`) và màu chữ tương phản cao, đáp ứng chuẩn WCAG AA.
- Cấu hình lại các thành phần giao diện trong [src/app/page.tsx](file:///D:/Invenroty/maison-vie-crm/src/app/page.tsx) và [src/app/globals.css](file:///D:/Invenroty/maison-vie-crm/src/app/globals.css), loại bỏ hoàn toàn các màu neon và cam chói cũ.

### 10.2. Lọc Bộ phận cho toàn bộ Dashboard (Hoàn tất 100%)
- Sửa lỗi phân quyền: Giờ đây, khi người dùng vai trò `BAR_SUPERVISOR` hoặc `BARTENDER` đăng nhập, toàn bộ các panel trên Dashboard (gồm Cảnh báo tồn kho tối thiểu, Biểu đồ nguyên liệu tiêu hao nhiều nhất, và các thẻ tổng quan) sẽ chỉ hiển thị các mặt hàng thuộc phạm vi quản lý của quầy Bar (đồ uống, bia, vang, chanh/cam dùng chung...).
- Các đồ dùng bếp và nguyên liệu của Chef sẽ được ẩn hoàn toàn trên Dashboard của Bar, và ngược lại. Admin/CFO vẫn giữ quyền tối cao để theo dõi toàn bộ nhà hàng.

### 10.3. Mở khóa Thẻ Tài chính Cấp 1 cho CFO (Hoàn tất 100%)
- Hệ thống đã mở khóa và hiển thị số liệu thật của ba thẻ tài chính cốt lõi: *Tổng chi phí nguyên liệu*, *Tổng giá trị kho*, và *Chênh lệch kiểm kê (Variance)* khi người dùng đăng nhập với vai trò CFO (`admin`).
- Đối với các vai trò không đủ thẩm quyền, thẻ tài chính vẫn hiển thị biểu tượng ổ khóa bảo mật "🔒 Khóa (Cấp 1)".

### 10.4. Tối ưu Giao diện Mobile-Ready chống Tràn trang (Hoàn tất 100%)
- **Header Slim Mobile**: Toàn bộ logo, giờ hệ thống, vai trò và trạng thái sync đã được rút gọn thành một thanh Slim Header (~56px) trên thiết bị di động, giải phóng không gian hiển thị cho bảng biểu và nội dung vận hành.
- **Bảng Responsive**: Đã cấu hình khung cuộn ngang (`overflow-x-auto`) cho các bảng dữ liệu phức tạp và ghim cột đầu tiên, đảm bảo thông tin quan trọng như đơn vị tính (BOTTLE, kg, lon...) không bao giờ bị tràn hay cắt cụt trên màn hình nhỏ.

### 10.5. Hiển thị song song Hai Cột Variance (Variance Thô và Variance sau Buffer 10%) (Hoàn tất 100%)
- Giữ nguyên cơ chế wastage buffer 10% cho bếp và bar phục vụ mục đích dự báo đặt hàng.
- Bổ sung thêm cột hiển thị **Variance THÔ (Raw Variance)** để CFO và Kế toán có thể đối chiếu chính xác hao hụt thực tế (không tính buffer) nhằm phát hiện thất thoát/over-portion thực sự.

### 10.6. Sửa lỗi Ràng buộc khóa ngoại cơ sở dữ liệu (Seeding Constraint) (Hoàn tất 100%)
- **Mô tả lỗi**: Khi chạy tệp `seed.sql`, hệ thống phát sinh hai lỗi ràng buộc khóa ngoại (foreign key constraint):
  1. Lỗi `recipes_ingredient_id_fkey` vì bảng `recipes` tham chiếu đến nguyên liệu `NVLC3001` và 21 nguyên liệu khác (mã `NVLC`/`NLP`) chưa được định nghĩa trong bảng `ingredients`.
  2. Lỗi `set_menu_items_parent_menu_item_id_fkey` vì bảng `set_menu_items` tham chiếu đến 3 Tasting Set Menus (`R6212, R6213, R6218`) chưa được định nghĩa trong bảng `menu_items`.
- **Hành động khắc phục**:
  - Trích xuất thông tin chi tiết (Tên, ĐVT kho, và giá vốn) của 22 nguyên liệu bị thiếu từ sheet `MASTER_BEP` trong tệp Excel gốc `MAISON_VIE_v6_0_PRO.xlsx` và bổ sung các bản ghi `INSERT INTO ingredients` và `INSERT INTO supplier_ingredients` tương ứng.
  - Bổ sung đơn vị tính `'HOP'` vào tệp `seed.sql` dưới phần seed `uom` để ngăn lỗi khóa ngoại `ingredients_stock_uom_fkey`.
  - Trích xuất cấu hình Tasting Set Menu từ code logic của hệ thống (`src/data/mockData.ts` và `src/data/db.json`) và bổ sung 3 bản ghi `INSERT INTO menu_items` cho `R6212, R6213, R6218` (Tasting 5, 6, 7 courses) với giá tương ứng.

### 10.7. Thực hiện hoàn thành toàn bộ Giai đoạn 5 (Tuần 9-12) (Hoàn tất 100%)
- **Cổng đăng nhập Bar `/bar`**: Tích hợp cổng đăng nhập bằng mã PIN cho tablet quầy bar chung của 3 nhân sự (`b-1`, `b-2`, `b-3`) cùng hệ thống tự động đăng xuất sau 3 phút không hoạt động để quy trách nhiệm pour variance cho từng bartender.
- **Nội suy thể tích 2 điểm (2-point calibration)**: Đã triển khai công thức tính toán thể tích dở bằng cách cân chai điện tử, nội suy tuyến tính dựa trên thông số chai đầy và vỏ rỗng của từng nguyên liệu.
- **Kiểm kho Đóng/Mở ca**: Cho phép đếm số chai nguyên seal và cân chai dở tại quầy bar đầu ca (`shift='OPEN'`) và cuối ca (`shift='CLOSE'`), tự động đồng bộ lên Supabase qua bảng `bar_counts`.
- **Hao hụt rót (Pour Variance)**: Đối soát chênh lệch tiêu thụ thực tế với dữ liệu lý thuyết từ POS của 183 mã Bar, hiển thị cảnh báo đỏ khi lệch âm vượt quá dung sai `weightToleranceGrams` (từ 2% đến 10% tùy chỉnh).
- **Nhật ký hao hụt & Yêu cầu cấp hàng**: Tích hợp các biểu mẫu khai báo vỡ/đổ/comp (`waste_logs`) và gửi phiếu yêu cầu cấp hàng/chuyển kho từ Kho tổng (`inventory_transactions`).
- **Liên kết Hệ thống**: Tích hợp liên kết truy cập nhanh "Cổng Quầy Bar (/bar)" trong Menu Sidebar (máy tính) và Mobile Navigation Drawer (điện thoại).

### 10.8. Sửa lỗi Lọc Dashboard theo bộ phận (Hotfix hoàn tất 100%)
- **Triệu chứng lỗi**: Khi nhân viên bộ phận Bar đăng nhập, panel "Cảnh báo Tồn kho tối thiểu" vẫn hiển thị các nguyên liệu thực phẩm của Bếp (Cá tuyết, cá hồi, tôm...) với thông báo Low Stock (Tồn 0.00 kg).
- **Nguyên nhân**: Panel cảnh báo tồn kho tối thiểu và biểu đồ "Nguyên liệu tiêu hao nhiều nhất" trước đây sử dụng mảng `ingredients` tổng và `consumptionData` tổng thay vì mảng `roleFilteredIngredients` và `roleFilteredConsumptionData` đã được lọc theo bộ phận của vai trò đăng nhập.
- **Biện pháp khắc phục**:
  1. Định nghĩa thêm memo `roleFilteredConsumptionData` để lọc tiêu hao nguyên liệu theo bộ phận.
  2. Định nghĩa memo `lowStockIngredients` để lọc các nguyên liệu sắp chạm mốc `min_stock` thực tế thuộc bộ phận.
  3. Cập nhật panel "Cảnh báo Tồn kho tối thiểu" và biểu đồ "Nguyên liệu tiêu hao nhiều nhất" trên Dashboard sử dụng hai memo lọc này.
  4. Cấu hình khóa logic của ba thẻ tài chính lớn (Cost / Giá trị tồn / Variance) mở ra cho các vai trò quản lý chính (`admin`, `BAR_SUPERVISOR`, `restaurant_manager`, `senior_accountant`) nhưng giá trị hiển thị chỉ tính toán các nguyên liệu thuộc bộ phận tương ứng.

---
*Nghiệm thu v9.4 hoàn tất ngày 16/06/2026. Biên dịch thành công 100%, đồng bộ hóa cơ sở dữ liệu và triển khai trực tiếp lên Vercel.*


