# KẾ HOẠCH TRIỂN KHAI HỆ THỐNG CRM/ERP INVENTORY – MAISON VIE **v9.5**
### (NỀN MÓNG + QUYẾT ĐỊNH v9.x ĐÃ TRIỂN KHAI 17/06 · BỔ SUNG §14: HÀNG BÁN CHƯA CÓ CÔNG THỨC + NHẬP LIỆU THỦ CÔNG · DARK THEME & MOBILE ĐÃ ÁP)

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

### A.1. Design tokens — **ĐÃ CHỐT: DARK THEME (Teal sâu · chữ trắng ấm · viền tan)** *(chốt 16/06, thay cho PA1 kem sáng)*

```css
:root{
  /* === DARK THEME CHÍNH THỨC — thay toàn bộ nền kem sáng PA1 === */
  /* Nền */
  --bg:            #102B2A;   /* nền trang (teal sâu) */
  --bg-2:          #042726;   /* nền phụ: panel / sidebar / header / card */

  /* Chữ — nền tối nên chữ SÁNG */
  --text:          #FBF8F4;   /* chữ chính (trắng ấm; KHÔNG dùng #FFF để tránh lóa) */
  --muted:         #FBF8F4;   /* chữ phụ cũng trắng (theo yêu cầu) — phân cấp bằng CỠ + ĐỘ ĐẬM */
  /* (nếu sau muốn lại chiều sâu: --muted #E6E2DA) */

  /* Viền — tan ấm, tách lớp panel rõ, hợp brass */
  --border:        #C9A581;

  /* Accent brass (giữ) */
  --accent:        #A8884E;
  --accent-deep:   #8C6F3C;
  --data-emph:     #C2A35A;   /* số liệu cần nhấn */

  /* Trạng thái — chỉnh sáng cho nền tối; tint = nền tối-có-sắc (KHÔNG tint sáng) */
  --warn-red:      #D06A5C; --warn-red-bg:   #3A1B17;
  --warn-amber:    #D8AA57; --warn-amber-bg: #3A2C13;
  --ok-green:      #62A57C; --ok-green-bg:   #0C201F;
}
```

> *Kiểm thử tương phản:* `--text #FBF8F4` trên `--bg #102B2A` ≈ 13:1 và trên `--bg-2 #042726` còn cao hơn — đạt WCAG AAA, không nhè/không lóa. Viền `#C9A581` trên nền tối tạo khung "fine-dining" rõ. **Màu olive `#262E22` của PA1 đã RETIRE** — toàn hệ dùng thuần teal `#102B2A`/`#042726` cho nhất quán.

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

> **[CHỐT 16/06] KHÔNG có mục nav "Cổng Quầy Bar (/bar)"** trong menu của bất kỳ vai trò quản trị nào (xem §C.6). Thay vào đó, dashboard hợp nhất có **bộ lọc bộ phận `Tất cả / Bếp / Bar`** đặt ở đầu trang. Bar staff không thấy bộ lọc này vì đã bị khóa cứng scope Bar.

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

### C.6. Mô hình truy cập: Bar là **SCOPE**, không phải **PORTAL** *(ĐÃ CHỐT 16/06)*
> **Quyết định:** **GỠ HẲN** mục nav "Cổng Quầy Bar (/bar)" khỏi mọi vai trò quản trị. Bar là **phạm vi (scope) do vai trò quyết định**, không phải một cổng/route riêng để "đi vào".

**Nguyên tắc:**
- **Vai trò quản trị** → **một dashboard hợp nhất duy nhất**, mặc định thấy phạm vi của mình; muốn soi riêng thì dùng **bộ lọc bộ phận trên dashboard: `Tất cả / Bếp / Bar`**. **Không** có portal Bar riêng.
- **Bartender / Quản lý Bar** → đăng nhập là **đã bị khóa cứng trong scope Bar**; toàn bộ màn hình (kiểm kho/nhập/xuất/tồn) chỉ là dữ liệu Bar. Không có khái niệm "portal" với họ.
- **"Hợp nhất 1 dashboard" ≠ "bỏ lọc".** Giao diện hợp nhất, nhưng scope vẫn theo vai trò (Bar login vẫn tự lọc về Bar — đúng bug đã xác nhận ở §0″/HOTFIX).

**Bảng VAI TRÒ → PHẠM VI BỘ PHẬN (đã tách Manager/Chef — Phương án A):**

| Vai trò | Phạm vi thấy | Doanh thu/Tiền | Ghi chú |
| :-- | :-- | :--: | :-- |
| Owner / CFO / Admin | **Tất cả** (Bếp + Bar) | ✔ | Có bộ lọc Tất cả/Bếp/Bar |
| **Quản lý NH (Manager)** | **Tất cả** (Bếp + Bar) | ✘ | Giám sát cả hai, không xem doanh thu |
| **Bếp trưởng (Chef)** | **CHỈ Bếp** (+ mã dùng chung) | ✘ | *Tách khỏi Manager* — không thấy cocktail/bia bán của Bar |
| Kế toán (senior_accountant) | **Tất cả** | Giá vốn (không DT) | Cần đối soát WAC/PO toàn bộ |
| Thủ kho | **Tất cả** | ✘ | Vận hành kho tổng (nhập/xuất cả 2 bộ phận) |
| **Bar (Bartender/QL Bar)** | **CHỈ Bar** (+ mã dùng chung) | ✘ | Khóa cứng scope Bar |

**Hệ quả code:** `roleToDept(role)` = `'KITCHEN'` cho **Chef**, `'BAR'` cho **Bar**, `null` (tất cả) cho phần còn lại (Admin/CFO/Manager/Kế toán/Thủ kho). Việc cần làm: (1) **gỡ nav item `/bar`** cho vai trò quản trị; (2) thêm **bộ lọc `Tất cả/Bếp/Bar`** trên dashboard hợp nhất; (3) **tách role Chef** ra khỏi role gộp `restaurant_manager` (Chef = KITCHEN-scope riêng).

### C.6.1. HAI MẶT CỦA BAR: vận hành (Bar staff) vs báo cáo (quản trị) *(làm rõ 16/06)*
> **Gỡ mục nav "Cổng Quầy Bar (/bar)"** (như ảnh). Bar không xuất hiện như một "nơi để đi vào" ở bất kỳ đâu. Thay vào đó Bar có **hai mặt** tùy người đăng nhập:

**① Ở khu BAR (Bartender / Quản lý Bar) → TÍCH HỢP HẾT vào màn của họ.**
Đăng nhập là vào thẳng workspace Bar đã lọc sẵn, gồm **đầy đủ thao tác vận hành**: Master kho Bar · Kiểm kho & Cân · Nhập/Xuất/Chuyển kho · Cảnh báo tồn Bar · Tạo/Duyệt phiếu đặt Bar · Waste/Non-sale (vỡ/đổ/comp) · Pour variance. Đây là **toàn bộ** giao diện của họ — không có khái niệm "portal", không thấy gì của Bếp.

**② Ở khu QUẢN TRỊ / GIÁM SÁT (Admin/CFO/Manager) → Bar mặc định là BÁO CÁO; có đường ADMIN-WRITE khi cần.**
Mặc định người quản trị **xem báo cáo** Bar (read-only/tổng hợp): tồn Bar theo nhóm (Vang/Mạnh/Bia-NN), tiêu hao Bar, beverage cost, variance & **pour variance**, cảnh báo tồn Bar, lịch sử phiếu đặt Bar — truy cập qua **bộ lọc `Bar`** hoặc tab **"Báo cáo Bar"**. **Nhưng khi cần** (bartender nghỉ, nạp tồn đầu kỳ, sửa sai, cập nhật giá hàng loạt), quản trị **được phép GHI** vào kho Bar qua **đường admin-write có kiểm soát — xem §C.6.2**.

| | Bar staff (vận hành) | Quản trị |
| :-- | :-- | :-- |
| Bản chất | Workspace thao tác, tích hợp hết | Báo cáo + admin-write khi cần |
| Làm được gì | Nhập/xuất/kiểm kho/đặt hàng/khai waste | Xem & phân tích; **ghi được vào Bar** (§C.6.2) |
| Vào bằng | Đăng nhập = mặc định scope Bar | Bộ lọc `Bar` / tab "Báo cáo Bar" |
| Thấy Bếp? | Không | Có (toàn bộ, vì là quản trị) |

### C.6.2. ADMIN-WRITE vào kho Bar từ khu quản trị *(ĐÃ CHỐT 16/06)*
> **Vì sao có:** §C.6.1 từng ghi "quản trị read-only với Bar" là **quá cứng**. Thực tế quản lý cần nhập thay khi bartender nghỉ, nạp tồn đầu kỳ, sửa sai, cập nhật giá hàng loạt.

**Ai được ghi:** **Tổng quản lý + Quản lý + Thủ kho** = được admin-write (đều có audit). **Giám sát FOH (thuần) = chỉ xem.** CFO/Owner đương nhiên được.

**Hai cơ chế ghi (đều bắt buộc chọn `location = BAR` trước khi nạp):**
- **Nhập từ file (hàng loạt):** upload Excel Bar (kiểm kho/nhập hàng) từ khu quản trị → qua đúng pipeline (mapping học được, **chống trùng `file_hash`**, 3-way match nếu nhập hàng). Giao dịch gắn `created_by = người ghi`, `source='ADMIN_IMPORT'`.
- **Nhập/sửa tay (từng mã):** là **bút toán điều chỉnh** (`STOCK_TAKE_ADJ`/reversal), **không** sửa lịch sử (sổ cái bất biến §1.2).

**Quy tắc xung đột — ĐÃ CHỐT: cho GHI ĐÈ ngay, KHÔNG hỏi lý do.**
Khi Bar staff đã "chốt đã nhập/đã xuất" trong ngày mà quản trị muốn ghi đè → **cho ghi đè tức thì, không bật popup hỏi lý do** (để không kẹt vận hành). Hệ thống tự reversal bản cũ + ghi bản mới.

> ⚠️ **Lằn ranh phải giữ (phản biện thẳng):** "không hỏi lý do" **≠ "không để lại vết".** Mọi lần admin-write/ghi đè vào Bar **vẫn TỰ ĐỘNG ghi** `audit_log`: **ai · lúc nào · giá trị cũ → mới**, và nổi lên **báo cáo "Can thiệp admin vào kho Bar"** gửi Cấp 1 (CFO/Owner). Đây là điều **không thương lượng** — vì Bar là khu thất thoát cao nhất; bỏ luôn cả dấu vết thì pour variance/variance mất hết tác dụng. Đánh đổi bạn đang chọn: CFO thấy *có* can thiệp nhưng **không thấy lý do** → khi số liệu bất thường, CFO phải tự hỏi người ghi. Đây là trade-off hợp lệ, miễn dấu vết còn nguyên.

**Trách nhiệm variance:** giao dịch do admin nhập được đánh dấu `source='ADMIN_*'` → báo cáo variance phân biệt rõ "số do admin nhập" vs "số do bar staff đếm", **không đổ oan bartender** khi sau đó lệch.



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

## 2. MODULE 1 — BAR THEO SCOPE *(cập nhật 16/06: Bar là phạm vi, KHÔNG phải portal)*

### 2.1. Triết lý: "tách giao diện, KHÔNG tách dữ liệu" — và Bar là **SCOPE**, không phải **PORTAL**

Bar **không** còn là một cổng/route `/bar` để admin "đi vào". Bar là **phạm vi do vai trò quyết định** (xem §C.6): Bar staff đăng nhập là đã bị khóa cứng trong scope Bar; vai trò quản trị dùng **bộ lọc `Tất cả/Bếp/Bar`** trên dashboard hợp nhất. Toàn bộ vẫn nằm trên **cùng một Supabase/một sổ cái** — tồn kho, giá vốn, pour variance của Bar **roll-up về Dashboard CFO** như bếp.

> **Phản biện thẳng (đã chốt):** ❌ **GỠ** mục nav "Cổng Quầy Bar (/bar)" khỏi mọi màn quản trị — nó là di sản từ thiết kế portal cũ + lần gộp login §9.1, gây hiểu nhầm Bar là "nơi để đi vào". Nếu hiểu "Bar riêng" thành *một hệ thống/route tách rời*, ta tái lập đúng bệnh silo Excel. Chỉ tách **scope theo vai trò + bộ lọc**, không tách kho dữ liệu, không tách route.

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
*Hết bản v9.2 (cập nhật quyết định 16/06). Quyết định chủ đầu tư: **GIỮ buffer 10%** (kèm khuyến nghị thêm cột "variance thô" không buffer để không mù phát hiện). Đã **xác nhận BUG ưu tiên**: vai trò Bar vẫn hiện đồ bếp trên Dashboard. **Quyết định kiến trúc mới (§C.6):** GỠ "Cổng Quầy Bar (/bar)" — Bar là **scope theo vai trò**, dashboard hợp nhất + bộ lọc Tất cả/Bếp/Bar; **tách Manager (thấy cả 2) khỏi Chef (chỉ Bếp)** — Phương án A. **Thứ tự sửa code:** (1) **lọc bộ phận cho toàn Dashboard** + tách role Chef; (2) **gỡ nav /bar** + thêm bộ lọc bộ phận; (3) mở khóa 3 card tài chính cho CFO; (4) recolor theo **Phương án 1 "Rêu sâu · Kem ấm"** (§A.1); (5) mobile-ready §B.4; (6) thêm cột variance thô.*

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

## 10. RÀ SOÁT NHẬT KÝ 16/06 — TRẠNG THÁI THỰC TẾ + ⛔ CẢNH BÁO BẢO MẬT NGHIÊM TRỌNG

### 10.1. Đã làm được (ghi nhận từ nhật ký 15–16/06)
- ✅ Bộ **SOP 4 vai trò** + `BAN_GIAO_HE_THONG.md` + script **backup tuần** `backup_weekly.bat` (Giai đoạn 6).
- ✅ **Ẩn thẻ Doanh thu POS** + chặn tab "Doanh số & POS Import" cho cấp dưới (chỉ CFO) — ở **frontend**.
- ✅ Tính năng **đổi mật khẩu** + xử lý session sandbox/production.
- ✅ **Gộp 4 nút đăng nhập**, bỏ `/bar`; import **183 mã Bar** + mapping POS + UoM mới (CAN/GLASS/PACK/BOX/BAG).
- ✅ **TỒN ĐẦU KỲ THẬT 01/06** (`opening_stock_01062026.sql`) — *tin tốt:* thay cho seed "Standard Opening 30" ⇒ **variance bắt đầu có ý nghĩa**.
- ✅ **Nhập mua 01–14/06** + phân bổ **landed cost** + **Moving WAC** + `grn_lines` + `lots`.

### 10.2. ⛔ NGHIÊM TRỌNG (ƯU TIÊN #0) — RLS BỊ TẮT TOÀN BỘ + auto-admin khi đăng ký
Để vượt lỗi *"new row violates row-level security policy"* khi sandbox dùng anon client, nhật ký 16/06 đã **TẮT RLS** trên `goods_receipts, grn_lines, lots, inventory_transactions, ingredients`, **và** thêm trigger tự tạo profile **quyền `admin`** cho **mọi** đăng ký.

**Phản biện thẳng — đây là lỗ hổng phá vỡ toàn bộ mô hình bảo mật của dự án:**
- Tắt RLS = **bất kỳ ai có anon key** (key này **nằm công khai trong frontend**) có thể **đọc/ghi toàn bộ** sổ cái kho + giá vốn + nhập hàng qua REST API Supabase. Ma trận 7 cấp (§2) và "chỉ CFO thấy doanh thu" (§3) **bị vô hiệu ở tầng database**.
- Công sức **ẩn thẻ Doanh thu** (15/06) bằng `userRole==='admin'` ở frontend giờ **chỉ là che mắt**: dữ liệu vẫn lấy được trực tiếp qua API vì RLS đã tắt. **Ẩn ở UI ≠ bảo vệ dữ liệu.**
- **auto-admin khi signup** = ai đăng ký cũng thành admin → leo thang quyền tức thì.

**Cách sửa ĐÚNG (thay vì tắt RLS):**
1. Sandbox/local phải đăng nhập bằng **session Auth thật** (JWT mang role) — không gửi anon; **hoặc** đặt thao tác ghi sau một **API route server-side dùng `service_role` key** (tuyệt đối KHÔNG để service key ra frontend).
2. Trigger tạo profile gán **vai trò least-privilege mặc định** (vd `staff`), admin cấp tay — **bỏ auto-admin**.
3. **BẬT LẠI RLS** và sửa **policy** cho đúng vai trò được ghi, thay vì disable.

> Một hệ thống tài chính chạy production với RLS = OFF là rủi ro **lộ & sửa số liệu** nghiêm trọng. Việc này phải sửa **trước** mọi hạng mục giao diện/tính năng khác.

### 10.3. ⚠️ UoM trùng lặp phân biệt hoa/thường (nợ dữ liệu)
Hệ đang có nhiều id cho **cùng một đơn vị**: `CHAI` vs `Chai` vs `BOTTLE`; `KG` vs `kg`. Hệ quả: **phân mảnh** — một chai đếm dưới `CHAI` không cộng gộp với `Chai`/`BOTTLE`; **WAC & tồn tính sai** theo từng biến thể. Việc thêm `Chai`/`kg` chỉ để "qua lỗi FK" là **vá tạm**. Cần: **chuẩn hóa về một id duy nhất mỗi đơn vị**, dùng `uom_conversions`, rồi **map dữ liệu cũ** về chuẩn (đừng để tồn đọng hai chuẩn song song).

### 10.4. ⚠️ Các quyết định v9.1–v9.3 CHƯA vào code (nhắc để khỏi quên)
- **Bếp/Bar vẫn "ẩn cứng"** (§9.2): Bar ẩn hết đồ bếp & ngược lại ⇒ **mã dùng chung** (cognac đốt, vang nấu, cam/chanh) vẫn **biến mất khỏi Bếp**. Chưa có bảng `ingredient_departments` (§C).
- **Role vẫn gộp** `restaurant_manager` (Chef/Manager/Thủ kho) — **chưa tách** Manager khỏi Chef (Phương án A, §C.6).
- **Dashboard chưa lọc bộ phận** ở panel cảnh báo (bug đã xác nhận — HOTFIX).
- **Admin-write vào kho Bar** + báo cáo "Can thiệp admin" (§C.6.2) — chưa làm.
- **Dark theme** (§A.1) — chưa áp.

### 10.5. Thứ tự ưu tiên cập nhật (v9.3)
**(0) BẬT LẠI RLS + bỏ auto-admin** *(bảo mật, làm ngay)* → (1) chuẩn hóa UoM trùng → (2) lọc bộ phận toàn Dashboard + tách role Chef → (3) bảng `ingredient_departments` + mã dùng chung → (4) gỡ nav /bar + bộ lọc Tất cả/Bếp/Bar → (5) admin-write Bar + audit → (6) dark theme §A.1 → (7) mobile §B.4 → (8) cột variance thô.

*Buffer 10% giữ nguyên theo quyết định chủ đầu tư (§0″).*

---
*Hết bản v9.3 (16/06/2026). Trọng tâm: **xử lý lỗ hổng RLS trước tiên**, rồi mới tới giao diện & nghiệp vụ còn lại.*


---

# 11. v9.4 — TÍCH HỢP CHỌN LỌC STOCKY + CỦNG CỐ NỀN MÓNG

> **Nguyên tắc v9.4:** *Sửa nền trước — Gộp chọn lọc — Hoãn đồ bán lẻ.* Không bê nguyên bộ Stocky (POS bán lẻ) vào một nhà hàng fine-dining đơn lẻ. Chỉ lấy 6 module hợp nghiệp vụ; hoãn phần bán lẻ + kế toán kép cho tới khi có nhu cầu thật.

## 11.1. CHỐT `ingredients.id` = TEXT CODE (varchar(50)) — không migrate uuid
- DB đang deploy đã dùng **code text làm `id`** ('V9006', 'NLP6002'...). Giữ nguyên: `ingredients.id varchar(50) PRIMARY KEY` (= chính `code`). **Không** đổi sang uuid ⇒ chi phí migration ~ 0.
- **Mọi FK con thống nhất `ingredient_id varchar(50)`** (sale_items, stock_adjustment_lines, stock_transfer_lines, grn_lines, inventory_transactions...).
- **LUẬT BẤT BIẾN:** mã sản phẩm **không được sửa/tái dùng** (vì là khóa chính). Nếu buộc đổi code → làm qua migration cập nhật FK, không sửa tay.

## 11.2. ⛔ BẢO MẬT — BẬT LẠI RLS ĐÚNG CÁCH (ưu tiên #0, làm trước mọi thứ)

**Khẩn cấp:** RLS đang TẮT trên app chạy thật ⇒ anon key (công khai ở frontend) hiện **đọc/ghi được toàn bộ** kho + giá vốn. Xử lý ngay, không chờ build xong v9.4.

```sql
-- (a) BẬT LẠI RLS trên mọi bảng nghiệp vụ + audit
alter table public.goods_receipts         enable row level security;
alter table public.grn_lines              enable row level security;
alter table public.lots                   enable row level security;
alter table public.inventory_transactions enable row level security;
alter table public.ingredients            enable row level security;
alter table public.audit_log              enable row level security;
-- ... (áp cho tất cả bảng còn lại)

-- (b) BỎ auto-admin → mặc định least-privilege ('staff'), admin cấp tay
drop trigger if exists on_auth_user_created on auth.users;
create or replace function public.handle_new_user() returns trigger
  language plpgsql security definer as $func$
begin
  insert into public.profiles (id, role) values (new.id, 'staff')
  on conflict (id) do nothing;
  return new;
end; $func$;
create trigger on_auth_user_created after insert on auth.users
  for each row execute function public.handle_new_user();

-- (c) Mẫu policy GHI: chỉ vai trò được phép; KHÔNG dùng RLS làm máy quy trình
create policy gr_insert on public.goods_receipts for insert to authenticated
  with check (public.get_current_user_role() in
    ('admin','senior_accountant','restaurant_manager','head_chef','storekeeper'));

-- (d) audit_log CHỈ được INSERT, không ai UPDATE/DELETE (kể cả admin)
revoke update, delete on public.audit_log from anon, authenticated;
```

**Giải quyết gốc lỗi anon (lý do trước đây phải tắt RLS):** sandbox/local **không gửi anon** nữa — hoặc (1) đăng nhập bằng **session Auth thật** (mỗi vai trò sandbox = một auth user có `profiles.role` tương ứng), hoặc (2) đẩy thao tác ghi qua **API route server-side dùng `service_role` key** (giữ ở server Vercel, **không bao giờ** ra `NEXT_PUBLIC_*`). Anon key chỉ an toàn KHI có RLS.

**Nguyên tắc bảo mật kèm theo:**
- **Ẩn doanh thu ở frontend chỉ là che mắt nếu RLS off.** Bảo vệ thật = view `v_inventory_finance/cost/ops` + **column privilege** + RLS.
- **PIN bartender phải `pin_hash`** + giới hạn số lần thử. PIN 4 số chỉ để *quy trách nhiệm*, không cấp quyền việc nhạy cảm.
- **Excel parse ở client (rẻ) nhưng quyền GHI kiểm ở DB/server** — không tin dữ liệu client cho phân quyền.

## 11.3. SECRET KHÔNG nằm trong DB — `system_settings` đã làm sạch
Bỏ mọi cột secret mà bản chuyên gia định thêm (`stripe_secret_key`, `email_api_key`, `sms_api_key`, `sms_gateway_url`). Secret → **Supabase Vault** (DB) hoặc **env server Vercel** (app).

```sql
create table if not exists system_settings (
  id serial primary key,
  restaurant_name text not null,
  default_vat   numeric(5,2) default 10.00 not null,
  base_currency text default 'VND' not null,
  email_from    text,            -- địa chỉ gửi (KHÔNG phải khóa)
  updated_at    timestamptz default now()
);  -- KHÔNG có cột khóa API nào ở đây
```

## 11.4. EMAIL — Resend, nối vừa an toàn vừa rẻ ($0 thêm)
- Resend free **3.000 email/tháng (100/ngày)** — đủ cho PO/cảnh báo/báo cáo "can thiệp admin".
- Khóa Resend để trong **Supabase Vault**; gửi mail bằng **`pg_net` gọi thẳng API Resend từ `pg_cron`** ⇒ **không cần Edge Function**, ít invocation, $0.
- Bắt buộc **xác thực domain maisonvie.vn (SPF/DKIM)** (chống spam + giả mạo). Đặt cờ **"đã gửi trong ngày"** để job lỗi không gửi vòng lặp.

## 11.5. MODULES GỘP (KEEP — đã sửa khớp v9.x)

### 11.5.1. Adjustment + Kiểm soát bất biến *(phần mạnh nhất của bản chuyên gia — giữ)*
> **Luật vàng:** không ai sửa trực tiếp `inventory_transactions`. Mọi thay đổi qua phiếu `stock_adjustments` (sinh giao dịch `STOCK_TAKE_ADJ`), ghi `audit_log` kèm `before_data`/`after_data`.

```sql
create table if not exists stock_adjustments (
  id uuid primary key default gen_random_uuid(),
  adjustment_no text unique not null,
  location_id text references locations(id) not null,
  reason text,                       -- NULLABLE: admin-write ghi đè KHÔNG bắt buộc lý do (§C.6.2)
  source text default 'ADMIN_ADJ',   -- gắn cờ để phân biệt số do admin nhập
  created_by uuid references profiles(id),
  created_at timestamptz default now() not null
);
create table if not exists stock_adjustment_lines (
  adjustment_id uuid references stock_adjustments(id) on delete cascade,
  ingredient_id varchar(50) references ingredients(id) on delete cascade,
  qty_adjusted numeric(12,4) not null,   -- Dương=tăng, Âm=giảm
  primary key (adjustment_id, ingredient_id)
);
```
*Lưu ý:* `reason` để **nullable** (khớp quyết định admin-write ghi đè không hỏi lý do) — nhưng `audit_log` vẫn TỰ ĐỘNG ghi ai/lúc nào/cũ→mới (§C.6.2).

### 11.5.2. Transfer có duyệt *(giữ — ép cân hai chân)*
```sql
create table if not exists stock_transfers (
  id uuid primary key default gen_random_uuid(),
  transfer_no text unique not null,
  from_location_id text references locations(id) not null,
  to_location_id   text references locations(id) not null,
  status text default 'PENDING' check (status in ('PENDING','APPROVED','REJECTED')),
  approved_by uuid references profiles(id),
  created_by  uuid references profiles(id),
  created_at  timestamptz default now() not null,
  check (from_location_id <> to_location_id)
);
create table if not exists stock_transfer_lines (
  transfer_id uuid references stock_transfers(id) on delete cascade,
  ingredient_id varchar(50) references ingredients(id) on delete cascade,
  qty_transfer numeric(12,4) not null check (qty_transfer > 0),
  primary key (transfer_id, ingredient_id)
);
```
- Khi `status = APPROVED` → sinh **2 chân** `inventory_transactions` (xuất kho nguồn + nhập kho đích) để sổ cái cân. Người duyệt: Quản lý/Thủ kho.
- Gắn mô hình **"chai riêng"** (§C.4): TRANSFER `BAR→KITCHEN` là ngoại lệ, vào báo cáo cho CFO.

### 11.5.3. Count Stock có bộ lọc danh mục *(giữ)*
Tận dụng `stock_takes`/`stock_take_lines`, thêm **bộ lọc danh mục** (đếm riêng Rượu / Rau củ / Thịt...) phục vụ cycle-count. Khớp scope bộ phận (§C) + chốt sổ ngày (§3.1).

### 11.5.4. User / Device / PIN + `user_locations` *(giữ — scope theo DỮ LIỆU, hay hơn hard-code)*
```sql
create table if not exists user_locations (
  profile_id  uuid references profiles(id) on delete cascade,
  location_id text references locations(id) on delete cascade,
  primary key (profile_id, location_id)
);
create table if not exists login_activity (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid references profiles(id) on delete cascade,
  ip_address text, user_agent text, device_info text,
  login_at timestamptz default now() not null
);
```
- `user_locations` thay cho `roleToDept` hard-code: **giới hạn kho theo dữ liệu** → Bar staff gắn `BAR`, Chef gắn `KITCHEN`, quản trị gắn tất cả. Khớp §C.6 (Bar là scope).
- PIN lưu `pin_hash`, giới hạn thử. `login_activity` để giám sát phiên.

### 11.5.5. Product import (thêm mới / chỉ cập nhật giá) *(giữ — kèm chốt UoM)*
- *Import Products:* `ON CONFLICT (code) DO NOTHING`. *Import (Update Only):* `UPDATE ... WHERE code = ...`.
- **Bắt buộc đi kèm chuẩn hóa UoM** (§10.3): trước khi cho import thêm, phải gộp `CHAI/Chai/BOTTLE`, `KG/kg` về **một id chuẩn mỗi đơn vị** + `uom_conversions`, nếu không import sẽ đẻ thêm trùng.

### 11.5.6. Settings *(giữ — bản đã làm sạch ở §11.3)*

## 11.6. 💰 KIẾN TRÚC TIẾT KIỆM CHI PHÍ (giữ ~20–25$/tháng)
- `pg_cron` chạy mọi job trong DB (không scheduler ngoài). Logic nặng = PL/pgSQL, hạn chế Edge Function.
- Excel/PDF render **client-side** (SheetJS/pdfmake) — giảm compute.
- **Partition `inventory_transactions` theo tháng** — DB gọn, backup nhanh, khỏi nâng tier.
- Storage retention: tự xóa Excel thô cũ, chỉ giữ dữ liệu đã parse + PDF chứng từ. Tránh Realtime nếu không cần.
- **Khoản nên chi duy nhất:** Supabase **Pro (~25$)** nếu đang Free — production tài chính cần PITR + không pause.

## 11.7. 🚫 HOÃN (deferred — chỉ làm khi có nhu cầu thật)
| Module | Lý do hoãn |
| :-- | :-- |
| Online Store + overselling + Stripe | Nhà hàng, không phải shop online; overselling đi ngược kiểm soát kho |
| Loyalty points + credit khách | Kiểu bán lẻ; nếu cần thì chỉ làm `customers` gọn cho **công nợ catering** |
| Technicians (thợ bảo trì) | Lạc đề với hệ kho |
| HRM / Payroll (tính lương) | Lĩnh vực riêng (thuế/OT/BHXH) — tách; chỉ giữ chấm công PIN nếu cần |
| Barcode / Label printing | F&B hiếm dán mã vạch từng lô |
| SMS / Termii gateway | Email Resend là đủ; SMS thêm chi phí, ít lợi |
| **Accounting kép (CoA/Journal)** | Module nặng nhất; làm bài bản **sau cùng**, sau khi RLS đúng |
| Sales Return | Đồ ăn không "trả lại"; Sales thủ công chỉ giữ cho catering |

## 11.8. CARRY-FORWARD — việc nền móng còn treo (gộp 1 chỗ)
1. **[#0] Bật lại RLS + bỏ auto-admin** (§11.2 / §10.2).
2. Chuẩn hóa **UoM trùng** (§10.3) + chốt `id` text (§11.1).
3. **`ingredient_departments` + mã dùng chung** (cognac đốt/vang nấu) — §C.
4. **Tách Manager/Chef** (Phương án A) — §C.6.
5. **Lọc bộ phận toàn Dashboard** (bug đã xác nhận) — HOTFIX.
6. **Admin-write Bar + báo cáo "Can thiệp admin"** — §C.6.2.
7. **Dark theme** §A.1 + **cột variance thô** (§0″, buffer 10% giữ).

## 11.9. LỘ TRÌNH v9.4 (sửa lại thứ tự của bản chuyên gia)
**GĐ0 — Nền móng bảo mật:** bật lại RLS + auth thật/route service_role + bỏ auto-admin + secret ra Vault/env.
**GĐ1 — Dữ liệu chuẩn:** chốt `id` text + chuẩn hóa UoM + `ingredient_departments`.
**GĐ2 — Quyết định v9.1–9.3:** tách Chef, lọc Dashboard, gỡ nav /bar + bộ lọc, dark theme.
**GĐ3 — Module GIỮ:** Adjustment+Audit, Transfer-duyệt, Count-lọc, User/PIN/`user_locations`, Product import, Settings.
**GĐ4 — [HOÃN]:** Accounting kép + nhóm bán lẻ (khi có nhu cầu).

---
*Hết bản v9.4. Tinh thần: chỉ gộp phần hợp nghiệp vụ fine-dining, **sửa nền móng (RLS/secret/UoM/id) trước**, hoãn đồ bán lẻ & kế toán kép. Mọi schema mới đã đổi `ingredient_id` sang `varchar(50)` và loại bỏ cột secret.*

---

# 12. BÁN HÀNG 2 GIÁ — TẠI CHỖ (DINE-IN) vs MANG VỀ (TAKEAWAY)

> **Nguyên tắc cốt lõi (chốt theo yêu cầu chủ đầu tư):** **MỘT sản phẩm cho mọi việc tồn kho — kiểm kê, định lượng, trừ kho đều cùng một loại; chỉ có HAI loại GIÁ.** 2 giá nằm **duy nhất ở tầng doanh thu**, KHÔNG tạo ra bản ghi tồn kho thứ hai ở bất kỳ đâu.

## 12.1. Tách tầng — điều kiện BẮT BUỘC

**Tầng TỒN KHO (kiểm kê · định lượng · trừ kho) = MỘT sản phẩm, không biết tới giá:**
1. **Định lượng:** mỗi món có **một công thức (BOM) duy nhất**. Không tạo công thức "tại chỗ" và "mang về" riêng.
2. **Trừ kho:** mỗi dòng POS → tra **đúng một công thức** → trừ đúng một lượng nguyên liệu. Dòng giá tại chỗ hay mang về đều trừ **y hệt nhau**.
3. **Kiểm kê:** đếm tồn của **một sản phẩm** — giá không liên quan.
   → Hệ quả: `ingredients`, công thức, `stock_takes`, `inventory_transactions` **hoàn toàn không có khái niệm 2 giá**. Tuyệt đối **không nhân đôi mã/sản phẩm theo kênh** (sẽ phân mảnh WAC/variance đúng bệnh trùng UoM §10.3).

**Tầng DOANH THU = nơi DUY NHẤT có 2 giá:**
4. **POS/Sales mang `order_type` (DINE_IN/TAKEAWAY)** + **giá thực của dòng bán** (POS đã gửi sẵn). Đây là chỗ duy nhất phân biệt 2 giá. Engine tồn kho không cần biết dòng đó bán giá nào để trừ kho — chỉ cần biết **mã sản phẩm**.

## 12.2. Điều kiện CẦN (để báo cáo đúng)
5. Báo cáo **doanh thu + food cost % tách theo kênh** (cùng COGS một-sản-phẩm, khác giá ⇒ khác biên).
6. Tách **phí phục vụ/VAT** (dine-in thường có phí phục vụ) khỏi giá net — ảnh hưởng P&L, **không** ảnh hưởng tồn.
7. **Variance KHÔNG đổi theo kênh** — vì cùng một sản phẩm/một công thức.

> **(Tùy chọn, KHÔNG bắt buộc cho mô hình 2 giá)** — Bao bì mang về (hộp/túi/nắp) là SKU kho riêng; *nếu* sau này muốn kiểm soát tồn bao bì thì trừ thêm qua `takeaway_packaging_map` khi `order_type=TAKEAWAY`. Đây là một sản phẩm **độc lập**, không phải biến thể của món ăn — nên vẫn đúng nguyên tắc "một sản phẩm / một loại". Chưa cần thì bỏ qua.

## 12.3. Schema tối thiểu
```sql
-- (a) Gắn kênh vào dữ liệu bán (POS import & Sales thủ công)
alter table sales_imports add column if not exists
  order_type text not null default 'DINE_IN'
  check (order_type in ('DINE_IN','TAKEAWAY'));
alter table sales add column if not exists
  order_type text not null default 'DINE_IN'
  check (order_type in ('DINE_IN','TAKEAWAY'));

-- (b) Map bao bì cho đơn MANG VỀ: mỗi mã món POS → các SKU bao bì + số lượng
create table if not exists takeaway_packaging_map (
  pos_item_code text not null,
  packaging_id  varchar(50) references ingredients(id) not null,  -- hộp/túi/nắp...
  qty_per_unit  numeric(12,4) not null default 1,
  primary key (pos_item_code, packaging_id)
);

-- (c) (TÙY CHỌN) bảng giá theo kênh — CHỈ cần cho module Sales thủ công (catering).
--     Với POS: giá bán đã nằm sẵn trong dữ liệu import nên KHÔNG cần lưu lại.
create table if not exists menu_prices (
  item_code  text not null,
  order_type text not null check (order_type in ('DINE_IN','TAKEAWAY')),
  price numeric(15,2) not null,
  primary key (item_code, order_type)
);
```

## 12.4. Luồng trừ kho khi nhập POS (giá 2 mức đã có sẵn trong data)
1. Mỗi dòng POS → tra mapping → trừ **tiêu hao theo công thức** (giống hệt cho cả 2 kênh — engine không quan tâm giá).
2. Doanh thu ghi theo **giá thực trong dữ liệu POS**, gắn nhãn `order_type` để báo cáo tách dine-in/takeaway.
3. Food cost % = COGS ÷ doanh thu, **tính riêng từng kênh** (cùng COGS, khác giá).
4. *(Tùy chọn)* nếu bật kiểm soát bao bì: `order_type=TAKEAWAY` → trừ thêm SKU bao bì theo `takeaway_packaging_map`.

## 12.5. Bẫy phải tránh
- ❌ Tạo 2 mã nguyên liệu / 2 công thức "tại chỗ" và "mang về" → phân mảnh tồn/WAC/variance. **Chỉ một sản phẩm.**
- ❌ Để 2 giá "rò" xuống tầng tồn kho (tạo bản ghi kho theo giá) → sai bản chất; 2 giá chỉ ở tầng doanh thu.

*(Liên quan: §11.7 Sales thủ công dùng `menu_prices` khi làm catering. Bao bì — nếu bật — gắn nhóm danh mục `PACKAGING` ở §11.5.5, là sản phẩm độc lập, không phải biến thể của món.)*

---

# 13. DANH MỤC CRON & TỰ ĐỘNG HÓA *(v9.4)*

> **Phát hiện health-check 17/06:** DB **chưa bật `pg_cron`** (schema `cron` không tồn tại) ⇒ chưa có job định kỳ nào trong DB. RLS thì **đã bật lại toàn bộ** (tốt). Phần "chạy theo lịch" cần dựng theo mục này.

## 13.1. Hai loại tự động — đừng nhầm
- **Theo SỰ KIỆN = TRIGGER (không cần cron):** cập nhật WAC khi nhập, trừ kho khi import POS, ghi audit, sinh 2 chân khi duyệt transfer. Kiểm bằng health-check [3].
- **Theo LỊCH = CRON:** mục này. Hai cách (đều đã trả phí sẵn):
  - **pg_cron + pg_net** *(khuyến nghị)* — chạy trong DB, không phụ thuộc app mở, gửi email thẳng. Bật ở Supabase → Database → Extensions.
  - **Vercel Cron** — khai trong `vercel.json`, gọi API route Next.js theo lịch (bảo vệ bằng `CRON_SECRET`). Hợp khi logic ở TypeScript.

> ⚠️ **pg_cron chạy theo UTC** (không phải giờ VN). VN = UTC+7 → mọi biểu thức cron phải trừ 7 tiếng. File `CRON_TuDongHoa_MaisonVie.sql` đã viết sẵn theo UTC kèm chú thích giờ VN.

## 13.2. Danh mục cron cần có (giả định đóng cửa ~23:00)
| Job | Giờ VN | Việc |
| :-- | :-- | :-- |
| `auto_close` | 02:00 | Lưới an toàn chốt sổ nếu bộ phận quên bấm |
| `variance_nightly` | 02:30 | Tính variance (kèm cột thô không buffer) sau chốt |
| `auto_po` | 06:30 | Sinh PO nháp (reorder: lead time, PO mở, MOQ) |
| `lowstock_email` | 07:00 | Email danh sách đỏ/vàng/xanh cho người mua |
| `expiry_alert` | 07:05 | Cảnh báo lô sắp hết hạn (FEFO/HACCP) |
| `po_aging` | 07:10 | Cờ PO quá hạn giao |
| `daily_report` | 08:00 | Food cost %, variance, **"can thiệp admin vào kho Bar"** (§C.6.2), pour variance |
| `weekly_report` | T2 08:30 | Variance/menu-engineering sâu |
| `monthly_partition` | ngày 1, 08:00 | Tạo partition tháng mới cho `inventory_transactions` (§11.6) |
| `storage_cleanup` | CN 10:00 | Xóa file Excel thô cũ (retention) |

**Không phải cron thuần:** *Chốt sổ ngày* là **bộ phận xác nhận → bấm** (người), `auto_close` chỉ là lưới an toàn. *Backup* đã có pg_dump tuần + Supabase Pro daily backup — không cần cron riêng.

## 13.3. Triển khai
- File SQL: **`CRON_TuDongHoa_MaisonVie.sql`** — gồm: bật extension, nạp khóa Resend vào **Vault**, **hàm `send_email` (pg_net→Resend) + `send_lowstock_email` dùng được ngay**, và 10 lệnh `cron.schedule` ở trên.
- Các hàm nghiệp vụ khác (`compute_variance`, `generate_auto_po`, `send_expiry_alert`, `flag_overdue_po`, `send_daily_report`, `create_next_month_partition`, `cleanup_old_uploads`) là **placeholder** — thay bằng tên hàm thật (health-check [2]); hàm nào chưa có thì viết thân trước khi `schedule`.
- Email: nạp `RESEND_API_KEY` vào Vault + xác thực domain SPF/DKIM; `cron_email_log` chống gửi trùng trong ngày.

---

# 14. HÀNG BÁN CHƯA CÓ CÔNG THỨC (UNMAPPED) + NHẬP LIỆU THỦ CÔNG *(v9.4)*

## 14.1. Vấn đề: dòng POS không có công thức/ánh xạ (món gọi thêm, off-menu)
Ốc Bulot, Súp Vẹm, Mixed Salad... khách gọi thêm, **chưa có công thức** ⇒ không trừ kho được. Hiện popup chọn nguyên liệu **hiện ra rồi đóng quá nhanh** → dòng chưa ánh xạ bị **bỏ qua âm thầm** → tồn ảo cao → **variance sai**.

> ✅ **Nguyên tắc:** KHÔNG bỏ qua âm thầm, KHÔNG dùng popup chớp-tắt. Dòng chưa khớp phải nằm trong **hàng đợi bền** để xử lý theo nhịp của người dùng.

## 14.2. Cách xử lý đúng — "Hàng đợi ánh xạ" bền (persistent worklist)
1. Khi import POS, mỗi dòng:
   - **Có** ánh xạ (`pos_alias_map` → recipe) → trừ kho tự động.
   - **Không** → **vẫn ghi nhận doanh thu**, đánh dấu `mapping_status='UNMAPPED'`, đẩy vào **tab "Hàng bán chưa có công thức"** (màn hình bền, KHÔNG phải popup).
2. Người dùng giải quyết từng dòng **không bị đóng file**, bằng 1 trong 2 cách:
   - **Tạo công thức + ánh xạ** (món thật, lặp lại) → hệ **reprocess** dòng treo để trừ kho (**idempotent**, không trừ trùng); lần sau import tự khớp.
   - **Khai tiêu hao một lần** (món ad-hoc): tự nhập nguyên liệu món đó đã dùng; hoặc đánh dấu `NO_STOCK_IMPACT` (vd phí dịch vụ).
3. **Cảnh báo nổi:** Dashboard + `daily_report` hiện "N dòng bán chưa ánh xạ" — unmapped = rò rỉ variance thầm lặng, không được để quên.

```sql
alter table <sale_lines> add column if not exists
  mapping_status text not null default 'MAPPED'
  check (mapping_status in ('MAPPED','UNMAPPED','RESOLVED','NO_STOCK_IMPACT'));

create or replace view v_unmapped_sales as
  select * from <sale_lines> where mapping_status = 'UNMAPPED';
```

## 14.3. Nhập liệu THỦ CÔNG (Bán / Nhập kho / Xuất kho) — cùng MỘT engine
> Mỗi loại giao dịch có **2 đường vào** (import file **và** form thủ công) nhưng **dùng chung một engine** trừ kho/WAC/sổ cái. Form thủ công chỉ là một "đầu vào" khác.

**(a) Bán thủ công** — vd 3 Mix salad · 10 ốc Bulot · 3 Coke · 7 bia tươi:
- Form: chọn món + SL + `order_type` (tại chỗ/mang về) → lưu → **trừ kho theo công thức** (giống hệt import POS). Món chưa có công thức → vào đúng luồng §14.2. Gắn `source='MANUAL_SALE'`.

**(b) Nhập kho thủ công** (song song import Excel mua hàng):
- Form: nhà cung cấp + số HĐ + dòng (mã, SL, đơn vị, đơn giá, cước/thuế) → tạo `goods_receipts` + `grn_lines` + `lots` + giao dịch **IN** + cập nhật **Moving WAC**. Gắn `source='MANUAL_GRN'`.

**(c) Xuất kho thủ công** — **phải hỏi LÝ DO** rồi định tuyến đúng sổ:
- Hủy/hỏng → `waste_logs`; Cơm NV/biếu/test → `non_sale_consumption`; Chuyển kho → `stock_transfers`; Sản xuất BTP → production. Sinh giao dịch **OUT** tương ứng. Gắn `source='MANUAL_ISSUE'`.

## 14.4. Bẫy phải tránh (quan trọng)
- ⛔ **Trừ kho hai lần:** bán thủ công món mà CŨNG có trong file POS ⇒ trừ trùng. Quy tắc: một `(ngày × món)` chỉ **một nguồn** — manual **HOẶC** import, không cả hai; dedup theo `(business_date, item, source)`.
- Mọi giao dịch thủ công vẫn qua **RLS + audit** + gắn `source='MANUAL_*'` (phân biệt POS/ADMIN) để variance không đổ oan & truy được nguồn.
- Sửa sai dòng thủ công = **bút toán đảo (reversal)**, không sửa lịch sử (§1.2).

---

# 15. TRẠNG THÁI TRIỂN KHAI (chốt v9.5 — theo nhật ký 17/06)

> Phần lớn quyết định v9.1–v9.4 **đã được code** trong ngày 17/06. Mục này chốt cái gì XONG, cái gì CÒN.

## 15.1. ĐÃ TRIỂN KHAI ✅
| Hạng mục | Ghi chú |
| :-- | :-- |
| **Dark theme + Mobile-ready** | Đúng token đã chốt (#102B2A/#042726/#C9A581/#FBF8F4/brass); header slim, ghim cột, bottom tab |
| **RLS bật lại 100% + policy theo `get_current_user_role()`** | Khớp health-check RLS=true; **auto-admin → mặc định `staff`** |
| **Chuẩn hóa UoM** | Một bộ viết hoa: KG/G/L/ML/BOTTLE/PIECE/CAN/GLASS/PACK/BOX/BAG; làm sạch seed/opening/db.json |
| **Tách Chef/Manager + lọc bộ phận Dashboard** | Chef=KITCHEN; Manager=cả 2 (không doanh thu); bộ lọc Tất cả/Bếp/Bar áp cho card + cảnh báo + chart |
| **2 cột variance (thô + buffer)** | CFO thấy thất thoát thật |
| **Admin-write Bar + nhật ký can thiệp** | `ADMIN_ADJ`/`ADMIN_IMPORT`, không hỏi lý do, tự ghi vết |
| **Cân dở chai rượu** | Gram → ml, hiệu chuẩn 2 điểm |
| **Cron (10 job) + giá kép + bao bì** | Chạy file CRON; `menu_prices` dine-in/takeaway; `takeaway_packaging_map` + PKG-001..004; 180 công thức; POS mapping beer→alc |
| **Build sạch + deploy** | Turbopack OK; push main; Vercel auto-deploy |

## 15.2. CÒN LẠI / CẦN XÁC MINH (v9.5)
1. **§14 — Hàng bán chưa có công thức + 3 form nhập tay** *(MỚI, chưa build)* — đặc tả ở **`SPEC_NhapTay_Unmapped_v9-4.md`**. Ưu tiên: tab Unmapped (Ốc Bulot/Súp Vẹm/Mixed Salad...) + bán/nhập/xuất thủ công.
2. **Xác minh THÂN HÀM cron** — job đã `schedule` nhưng cần chắc các hàm `compute_variance/generate_auto_po/send_expiry_alert/...` **đã có thân** (health-check [2]/[3]); nếu rỗng, job nổ lỗi mỗi đêm.
3. **Email Resend** — xác minh `RESEND_API_KEY` đã nạp Vault + domain maisonvie.vn đã verify SPF/DKIM.
4. **RLS policy** — xác nhận là policy theo vai trò thật, không phải `using(true)` (log nói dùng `get_current_user_role()` — tốt; nên rà nhanh `pg_policies`).
5. **Co-duyệt nhãn dùng chung** (§C.5) + **ingredient_departments** cho mã dùng chung (cognac đốt/vang nấu) — xác minh đã có quy trình 2-chữ-ký.
6. **HOÃN (chưa làm, đúng kế hoạch):** kế toán kép + nhóm bán lẻ (§11.7).

## 15.3. Ưu tiên kế tiếp (đề xuất)
**(1)** Build §14 (unmapped + nhập tay) — vì đây là việc vận hành hằng ngày đang vướng. **(2)** Xác minh thân hàm cron + email. **(3)** Rà co-duyệt nhãn dùng chung. Còn lại giữ nguyên lộ trình.

---
*Hết bản v9.5 (17/06/2026). Nền móng (RLS/UoM/secret/dark theme/mobile) + phần lớn nghiệp vụ đã triển khai; trọng tâm còn lại: §14 (unmapped + nhập tay) và xác minh cron/email.*

---

# 16. MÔ HÌNH LOẠI-SẢN-PHẨM `deduction_type` (gốc rễ — chuyên nghiệp) *(v9.5)*

> **Vì sao có:** tab Unmapped đang đầy **món chuẩn** (Coke, nước ngọt) — không phải vì chúng "gọi thêm", mà vì **danh mục thiếu** + thay đổi 17/06 (gộp `beer→alc`) **ép món 1:1 phải có công thức**. Gốc rễ: thiếu một trường phân loại **cách trừ kho**. Đây là fix cấu trúc, không phải vá từng lần.

## 16.1. Ba loại `deduction_type`
- **`DIRECT` (1:1):** món bán **chính là** SKU kho → bán 1 trừ 1. *(Coke, nước ngọt lon, bia chai nguyên, nước suối, chai rượu bán nguyên.)*
- **`RECIPE` (BOM):** trừ theo công thức nhiều nguyên liệu. *(Cocktail, nước ép, món ăn.)*
- **`NON_STOCK`:** không ảnh hưởng kho. *(Phí phục vụ, phụ thu.)*

⇒ Logic trừ kho trở nên **xác định**; món DIRECT **không bao giờ** cần công thức giả.

## 16.2. Schema + cách engine dùng
```sql
alter table menu_items add column if not exists
  deduction_type text not null default 'RECIPE'
  check (deduction_type in ('DIRECT','RECIPE','NON_STOCK'));
-- DIRECT: pos_alias_map trỏ thẳng pos_item_code -> ingredient SKU, deduct_qty = 1
--         (KHÔNG cần bảng recipes cho nhóm này)
```
Khi trừ kho (POS import / bán tay / reprocess §14): **DIRECT** → trừ chính SKU × SL; **RECIPE** → bung BOM; **NON_STOCK** → bỏ qua (chỉ ghi doanh thu).

## 16.3. Migration — sửa hệ quả 17/06 (`beer→alc`)
- **Phân loại lại:** lon/chai bán nguyên (Coke, nước ngọt, bia chai, nước suối) → **DIRECT**; cocktail/nước ép → **RECIPE**; phí/phụ thu → **NON_STOCK**.
- Mỗi món **DIRECT** phải có **một ingredient SKU + một ánh xạ POS 1:1** (deduct_qty=1). Nạp hàng loạt bằng file mẫu (§16.4).

## 16.4. Quy trình chuẩn (one source of truth)
1. **Import danh mục 1:1** bằng **`MAU_IMPORT_DANHMUC_1-1.xlsx`** (loại DIRECT; có **dropdown** Nhóm/Bộ phận/Đơn vị/Loại trừ kho → chặn trùng UoM tận gốc) — **một pass**, dứt điểm lỗ hổng Coke + nước ngọt + bia chai.
2. **Tab Unmapped** (§14): nút resolve **theo `deduction_type`** — DIRECT → *"Tạo nhanh SKU 1:1"*, RECIPE → *"Tạo công thức"*, NON_STOCK → *"Không ảnh hưởng kho"*.
3. **Kỷ luật:** món mới **vào danh mục trước khi bán**; tab Unmapped **trôi về gần rỗng** (nếu đầy món chuẩn = dấu hiệu danh mục bị buông).

## 16.5. Lợi ích
Hết cảnh món chuẩn rơi vào Unmapped · không còn công thức giả cho lon nước · danh mục thành **master list được kiểm soát** · dropdown chặn trùng đơn vị (CHAI/Chai) ngay từ khâu nhập — đúng chuẩn một hệ F&B chuyên nghiệp.

## 16.6. Kết quả triển khai đồng bộ danh mục 1:1 (17/06/2026)

Đã hoàn thành đồng bộ 15 mặt hàng đồ uống và bia bán nguyên (direct) từ `Soft-Beer.xlsx` vào hệ thống:
1. **Danh sách sản phẩm**:
   - **Bia (BEER)**: B5001 (Heineken - 33cl), B5002 (Tiger - 33cl), B5004 (Beer 333 - 33cl), B5005 (Saigon beer), B5007 (Sapporo draught), B5010 (Hanoi bottle), B5012 (Hanoi can).
   - **Nước ngọt/Nước suối (SOFT_DRINK / WATER)**: M6001 (Coke), M6002 (Soda), M6004 (Sprite), M6006 (Diet Coke), M6008 (La Vie 1,5 L), M6010 (S.Pellegrino 0.5L), M6020 (Maison Vie 0.52L).
   - **Cigar (OTHER)**: M9203 (Cigar Havana).
2. **Cập nhật File mẫu**:
   - `D:\Invenroty\MAU_IMPORT_DANHMUC_1-1.xlsx` (sheet `DANH_MUC_1-1`) được làm sạch và nạp đầy đủ 15 sản phẩm trên với cờ loại trừ kho là `DIRECT` và tỷ lệ trừ kho 1:1.
3. **Đồng bộ cơ sở dữ liệu Supabase**:
   - Nạp các nguyên liệu còn thiếu vào bảng `ingredients` với thuộc tính `is_beverage = true` và `purchase_category_id` tương ứng (`ALCOHOL` / `BEVERAGE`).
   - Thiết lập công thức 1:1 trong bảng `recipes` cho các mặt hàng nước ngọt và Cigar (các mặt hàng bia đã có sẵn công thức chỉ cần liên kết).
   - Đăng ký ánh xạ POS trong bảng `pos_alias_map` cho toàn bộ 15 mã giúp hệ thống tự động nhận diện khi import file bán hàng POS, tránh rơi vào tab Unmapped.
   - Gắn nhãn bộ phận `BAR` trong bảng `ingredient_departments` để phân quyền quản lý kho.
   - Các câu lệnh SQL INSERT tương ứng được lưu lại tại `supabase/seed.sql` và `supabase/seed_soft_beer_sync.sql`.
4. **Cập nhật Logic mô phỏng**:
   - `src/data/mockData.ts` được cập nhật trong `POS_MAPPING` với loại `"beer"` cho tất cả 15 mã trên, đảm bảo lượng tiêu hao mô phỏng chạy 1:1 trực tiếp trên ID nguyên liệu tương ứng.

5. **Đồng bộ công thức Cocktail Sangria (M7020)**:
   - **Nguồn gốc**: Tìm thấy công thức định lượng chi tiết trong file `NUOC_EP_MAISON_VIE_270M.xlsx` tại sheet `3.BOM_COCKTAIL_IBA`.
   - **Định lượng công thức**:
     - House red wine (`ING-115`): 120 ml (quy đổi thành 0.16 BOTTLE)
     - Nước cam tươi (`ING-110`): 30 ml (quy đổi thành 0.03 L)
     - Triple Sec (`M9801`): 15 ml (quy đổi thành 0.02 BOTTLE)
     - Cognac VSOP (`ING-072`): 15 ml (quy đổi thành 0.015 L)
     - Trái cây nhiệt đới (`ING-049`): 50 g (quy đổi thành 0.05 KG)
   - **Đồng bộ database & code**:
     - Cấu hình công thức liên kết trong bảng `recipes` và tạo liên kết POS (`pos_alias_map`) cho mã `M7020` trên Supabase.
     - Cập nhật công thức và chi phí cost (34,450 VND) trong `src/data/db.json`.
     - Cập nhật POS mapping loại `"alc"` (Cocktail) cho mã `M7020` trong `src/data/mockData.ts`.
     - Lưu lại các câu lệnh insert tương ứng tại `supabase/seed_sangria_sync.sql` và lưu trữ trong `supabase/seed.sql`.


