# KẾ HOẠCH TRIỂN KHAI HỆ THỐNG CRM/ERP INVENTORY - MAISON VIE (BẢN CẬP NHẬT)

> **Vai trò**: Giám đốc Vận hành (COO) / Giám đốc Tài chính (CFO) / Kiến trúc sư Dữ liệu Full-Stack
> **Dự án**: Hệ thống CRM/ERP Quản lý Kho & Định mức tự động hóa cao cấp cho nhà hàng Pháp Maison Vie.
> **Hạ tầng**: Supabase (PostgreSQL / Auth / RLS) + Vercel (Next.js / React) + GitHub.

---

## 1. PHÂN TÍCH EXCEL & THIẾT KẾ CƠ SỞ DỮ LIỆU PHẲNG

Sau khi quét toàn bộ các sheet dữ liệu (`MASTER_BEP`, `MASTER_BAR`, `RECIPE_BEP`, `RECIPE_BAR`, và 12 sheet tháng `T01` - `T12`) trong file [MAISON_VIE_v6_0_PRO.xlsx](file:///d:/Invenroty/MAISON_VIE_v6_0_PRO.xlsx), chúng tôi đã loại bỏ hoàn toàn các lỗi thiết kế xếp chồng bảng (Anti-pattern) của Excel cũ để đưa lên cơ sở dữ liệu phẳng trên Supabase.

Cấu trúc database chuẩn được chia thành các bảng độc lập liên kết chặt chẽ bằng khóa ngoại:
*   [profiles](file:///d:/Invenroty/maison-vie-crm/supabase/schema.sql#L19-L33): Lưu trữ thông tin người dùng và phân quyền ma trận 7 cấp.
*   [purchase_categories](file:///d:/Invenroty/maison-vie-crm/supabase/schema.sql#L39-L46): Danh mục thu mua để xuất PO (Thịt, Rượu, Rau củ quả...).
*   [ingredients](file:///d:/Invenroty/maison-vie-crm/supabase/schema.sql#L48-L64): Master nguyên vật liệu với các trường `wac_price` (giá vốn trung bình gia quyền), `min_stock`, `max_stock`, `auto_po_group` ('AUTO_PO' hoặc 'MANUAL_REQUISITION').
*   [menu_items](file:///d:/Invenroty/maison-vie-crm/supabase/schema.sql#L66-L72): Danh mục món ăn POS, bao gồm cờ `is_set_menu` cho combo/tasting menu.
*   [set_menu_items](file:///d:/Invenroty/maison-vie-crm/supabase/schema.sql#L74-L81): Phân rã Set Menu để trừ kho con theo tỷ lệ portion.
*   [recipes](file:///d:/Invenroty/maison-vie-crm/supabase/schema.sql#L83-L92): Định mức công thức (BOM) liên kết món ăn với nguyên liệu thô (Net, Yield %, Eff).
*   [inventory_transactions](file:///d:/Invenroty/maison-vie-crm/supabase/schema.sql#L94-L110): Giao dịch kho real-time (import, consumption, stock_take, waste).
*   [waste_logs](file:///d:/Invenroty/maison-vie-crm/supabase/schema.sql#L112-L121): Nhật ký hủy hỏng trong ca do Bếp phó nhập.
*   [sales_imports](file:///d:/Invenroty/maison-vie-crm/supabase/schema.sql#L123-L131): Doanh số POS cuối ngày chờ phân rã và trừ kho.

---

## 2. MA TRẬN BẢO MẬT & PHÂN QUYỀN 7 CẤP (SUPABASE RLS)

Hệ thống được bảo mật bằng cơ chế Row Level Security (RLS) của Supabase, phân quyền chặt chẽ dòng dữ liệu dựa trên vai trò nhân sự:

| Cấp | Nhóm Quyền (Role) | SELECT | INSERT | UPDATE | DELETE | Mục Đích Vận Hành & Quyền Hạn |
| :--- | :--- | :---: | :---: | :---: | :---: | :--- |
| **Cấp 1** | **Admin (CFO / Owner)** | Tất cả | Tất cả | Tất cả | Tất cả | Xem Dashboard tài chính tối cao (giá trị kho VND, Food Cost % real-time, chênh lệch hao hụt tiền). |
| **Cấp 2** | **Quản lý Nhà hàng** | Tất cả | Giao dịch | Giao dịch | Không | Quản lý vận hành kho, duyệt phiếu hủy hỏng (`waste`) giá trị lớn. Không xem được số liệu tài chính CFO. |
| **Cấp 3** | **Bếp trưởng (Head Chef)** | Tất cả | Định mức | Định mức | Không | Sửa định mức món ăn (`recipes`) và tỷ lệ hao hụt (`yield_rate`). Chỉ xem số liệu tiêu thụ bếp. |
| **Cấp 4** | **Kế toán kho cấp cao** | Tất cả | PO, WAC | PO, WAC | Không | Duyệt màn hình mapping POS, đối soát giá vốn WAC lũy tiến, xuất file Auto-PO gửi nhà cung cấp. |
| **Cấp 5** | **Giám sát Sảnh (FOH)** | Menu, POS | Không | Không | Không | Đối chiếu lỗi mã POS cuối ngày. Không được can thiệp vào nguyên liệu hay giá cả. |
| **Cấp 6** | **Bếp phó (Sous Chef)** | Khai báo | Waste, PO | Không | Không | Tạo phiếu Manual PO Requisition (hàng chợ) và nhập Nhật ký hủy hỏng (`waste_logs`) ngay khi xảy ra sự cố trong ca. |
| **Cấp 7** | **Thủ kho / Kế toán phụ** | Xem | Hóa đơn | Không | Không | Nhập hóa đơn mua lẻ phát sinh dọc đường. Phiếu nằm ở trạng thái `pending`, không tác động lên kho cho đến khi Cấp 4 duyệt. |

---

## 3. LOGIC NGHIỆP VỤ ĐẶC THÙ VẬN HÀNH

Hệ thống áp dụng 4 mốc thời gian và thuật toán tự động hóa cốt lõi để đảm bảo độ chính xác của kho:

### A. Chốt giá vốn bình quan gia quyền lũy tiến (Moving WAC) lúc 18h30
*   **Mục đích**: Tính toán lại giá trị hàng tồn kho và thiết lập giá vốn mới cho các giao dịch trong tương lai mà không làm thay đổi lịch sử các giao dịch trước 18h30.
*   **Hàm cơ sở dữ liệu**: [calculate_moving_wac](file:///d:/Invenroty/maison-vie-crm/supabase/functions.sql#L7-L50)
*   **Thuật toán**:
    $$\text{New WAC} = \frac{\text{Giá trị tồn đầu ngày} + \text{Giá trị hàng nhập trước 18h30}}{\text{Số lượng tồn đầu ngày} + \text{Số lượng nhập trước 18h30}}$$
*   Sau khi chạy hàm chốt giá, giá trị `wac_price` trong bảng `ingredients` sẽ được cập nhật. Tất cả giao dịch xuất kho lý thuyết lúc 22h30 sẽ áp theo mức giá vốn mới này.

### B. Trừ kho tự động & Phân rã Set Menu lúc 22h30
*   **Mục đích**: Tự động khấu trừ tồn kho lý thuyết dựa trên doanh số POS kết hợp với nhật ký hủy hỏng trong ca.
*   **Hàm cơ sở dữ liệu**: [process_daily_consumption](file:///d:/Invenroty/maison-vie-crm/supabase/functions.sql#L56-L126)
*   **Thuật toán**:
    1.  **Phân rã Set/Tasting Menu**: Đối với các món combo (như Tasting 5 món), hệ thống đọc bảng `set_menu_items`, phân tách thành món đơn lẻ và tự động thu nhỏ định lượng thô theo `portion_ratio` (ví dụ: nhân với 70%).
    2.  **Khấu trừ thô (Gross Weight)**: Lượng trừ kho = Lượng tịnh (`qty_net`) / (`yield_rate` / 100) * Doanh số * 1.10 (bao gồm 10% bù hao phí bếp tiêu chuẩn).
    3.  **Cộng gộp Hủy hỏng**: Gom toàn bộ `waste_logs` của ngày (đã được duyệt) để trừ thêm vào kho lý thuyết.

### C. Lọc và tự động xuất file đơn đặt hàng (Auto-PO) lúc 22h40
*   **Mục đích**: Hợp lý hóa chuỗi cung ứng, tự động tạo PO riêng lẻ theo từng nhà cung cấp để Purchasing tải về lúc 7h00 sáng hôm sau.
*   **Hàm cơ sở dữ liệu**: [generate_auto_po](file:///d:/Invenroty/maison-vie-crm/supabase/functions.sql#L132-L210)
*   **Thuật toán**:
    *   Lọc tất cả các NVL thuộc nhóm `auto_po_group = 'AUTO_PO'` có lượng tồn lý thuyết hiện tại nhỏ hơn mức tối thiểu (`min_stock`).
    *   Công thức đặt hàng:
        $$\text{Số lượng đặt} = \text{max\_stock} - \text{Tồn lý thuyết hiện tại}$$
    *   Gom nhóm theo `purchase_categories` để xuất thành các đơn đặt hàng độc lập (PO_Thịt, PO_RượuVang, PO_RauCủĐồKhô). Các mặt hàng chợ tự mua lẻ sẽ được bỏ qua và chuyển sang danh mục đề xuất mua tay (`MANUAL_REQUISITION`).

### D. Màn hình Mapping Trung gian 30 Giây
*   Khi Kế toán tải file Excel doanh thu POS hoặc Phiếu nhập hàng lên hệ thống, một cửa sổ popup đè màn hình (Modal) xuất hiện đếm ngược 30 giây:
    *   Mã khớp 100%: Hiển thị trạng thái màu xanh lá 🟢.
    *   Mã lệch hoặc khớp mờ: Chạy thuật toán so khớp khoảng cách chuỗi (Levenshtein) để dự đoán mã tương thích, hiển thị màu vàng 🟡 kèm độ chính xác (ví dụ: "Angus Ribeye - Khớp 92%").
    *   Kế toán có quyền sửa tay hoặc bấm **Chốt ghi sổ** lập tức để hệ thống ghi nhận vào lịch sử giao dịch.

---

## 4. KẾ HOẠCH HÀNH ĐỘNG 90 NGÀY (90-DAY ACTION PLAN)

Kế hoạch chia làm 6 giai đoạn với mốc chốt chặn cụ thể để đảm bảo bàn giao thành công và giải phóng hoàn toàn chủ nhà hàng:

### Giai đoạn 1: Thiết lập cấu trúc & Pilot nhóm giá trị cao (Tuần 1 - Tuần 2)
*   **Hành động**:
    1. Triển khai schema database phẳng và RLS lên Supabase.
    2. Chạy thử nghiệm nhỏ (Pilot Run) đối với nhóm nguyên liệu có giá trị cao nhất: **Thịt bò nhập khẩu & Cá tuyết/Cá hồi** (5 mã hàng từ tab `MASTER_BEP` bao gồm: `ING-011` Trâu VN, `ING-093` Ribeye Angus US, `ING-003` Cá tuyết đen, `ING-007` Cá hồi Na Uy).
    3. Test chất lượng đọc file Excel POS thực tế của 13 ngày đầu tháng 6 tại máy chủ Vercel.

### Giai đoạn 2: Đấu nối phân hệ khóa sổ WAC & Waste Log ca (Tuần 3 - Tuần 4)
*   **Hành động**:
    1. Hoàn thiện giao diện tạo Waste Log cho Bếp phó trên máy tính bảng.
    2. Kiểm thử độ chính xác của hàm tính giá WAC lũy tiến lúc 18h30.
    3. Đào tạo kế toán phụ nhập dữ liệu hóa đơn mua lẻ dưới dạng phiếu `pending` chờ duyệt.

### Giai đoạn 3: Tích hợp phân rã Tasting Menu & Trừ kho tự động (Tuần 5 - Tuần 6)
*   **Hành động**:
    1. Đưa logic phân rã 70% portion Tasting Menu vào vận hành thực tế.
    2. Theo dõi chênh lệch vật lý (Variance) sau mỗi ca tối đối với nhóm Beef & Fish.
    3. Cấu hình tự động gửi cảnh báo thất thoát tiền mặt bằng email về tài khoản Admin nếu lệch âm vượt mức 5%.

### Giai đoạn 4: Hoàn thiện Auto-PO & Phân nhóm nhà cung cấp (Tuần 7 - Tuần 8)
*   **Hành động**:
    1. Thiết lập các thông số tồn kho tối thiểu (`min_stock`) và tối đa (`max_stock`) cho toàn bộ 347 mã hàng bếp và bar.
    2. Cấu hình xuất tự động các PO theo file Excel chuyên biệt lúc 22h40 gửi vào hòm thư nội bộ của Purchasing.
    3. Triển khai màn hình Mapping trung gian 30 giây giúp giảm 80% thời gian khớp dữ liệu thủ công.

### Giai đoạn 5: Vận hành song song & Chỉnh sửa lỗi phát sinh (Tuần 9 - Tuần 10)
*   **Hành động**:
    1. Chạy song song cả hai hệ thống Excel cũ và CRM mới.
    2. Đối soát chênh lệch tổng số liệu cuối tuần để hiệu chỉnh tỷ lệ Yield Rate thực tế của bếp.
    3. Kiểm tra tính ổn định của hệ thống RLS Supabase dưới áp lực truy cập ca cao điểm.

### Giai đoạn 6: Đóng gói tài liệu, Video SOP & Bàn giao (Tuần 11 - Tuần 12)
*   **Hành động**:
    1. Quay video hướng dẫn thao tác (SOP Video) chi tiết cho từng vai trò nhân sự:
        *   *Kế toán*: Cách tải file POS, đối soát mapping, chốt WAC 18h30.
        *   *Thủ kho/Bếp phó*: Cách kiểm kho trên mobile, nhập waste trong ca.
        *   *CFO/Owner*: Cách đọc Dashboard tài chính tối cao.
    2. Đóng gói mã nguồn lên kho lưu trữ GitHub riêng tư của Maison Vie.
    3. Bàn giao chìa khóa hạ tầng Supabase/Vercel cho chủ nhà hàng, chính thức dừng vận hành file Excel cũ.
