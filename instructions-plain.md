# TÀI LIỆU TOÀN BỘ QUÁ TRÌNH TRIỂN KHAI & HƯỚNG DẪN HỆ THỐNG CRM/ERP INVENTORY - MAISON VIE

> **Dự án**: Hệ thống CRM/ERP Quản lý Kho & Định mức tự động hóa cao cấp cho nhà hàng Pháp Maison Vie.
> **Hạ tầng**: Supabase (PostgreSQL / Auth / RLS) + Vercel (Next.js / React) + GitHub.
> **Kiến trúc dữ liệu**: Phẳng hóa toàn bộ dữ liệu Excel cũ nhằm loại bỏ anti-pattern.

---

## 1. PHÂN PHỐI VAI TRÒ & PHÂN QUYỀN (7-LEVEL RBAC & RLS)

Hệ thống được bảo mật bằng cơ chế **Row Level Security (RLS)** trên Supabase, đảm bảo mỗi vai trò nhân sự chỉ được phép thực hiện các thao tác và xem thông tin thuộc thẩm quyền của mình.

### Bảng Phân Quyền & Tài Khoản Thử Nghiệm (Sandbox Accounts)

| Cấp | Nhóm Quyền (Role) | Email Đăng Nhập | Mật Khẩu | Quyền SELECT | Quyền INSERT/UPDATE | Quyền DELETE | Phân Hệ Được Truy Cập trên UI |
| :---: | :--- | :--- | :---: | :---: | :---: | :---: | :--- |
| **1** | **CFO / Owner (Admin)** | `admin@maisonvie.vn` | `sandbox` | Tất cả | Tất cả | Tất cả | Toàn bộ 7 Tab (Dashboard tài chính tối cao, Doanh số, Master Kho, Định mức, Kiểm kho, Bán thành phẩm, Đối soát & Yield). |
| **2** | **Quản lý Nhà hàng** | `manager@maisonvie.vn` | `sandbox` | Tất cả | Giao dịch kho, Hủy hỏng | Không | Dashboard, Doanh số, Kho, Kiểm kho, Bán thành phẩm, Đối soát. (Không có quyền xem/sửa công thức định mức). |
| **3** | **Bếp trưởng (Head Chef)** | `headchef@maisonvie.vn` | `sandbox` | Tất cả | Công thức định mức, Yield rate | Không | Dashboard, Kho, Định mức, Kiểm kho, Bán thành phẩm, Đối soát. (Chỉ xem số liệu tiêu hao, không xem doanh thu). |
| **4** | **Kế toán kho cấp cao** | `senior.accountant@maisonvie.vn` | `sandbox` | Tất cả | PO, WAC, POS Mapping | Không | Dashboard, Doanh số, Kho, Kiểm kho, Đối soát. (Duyệt giá vốn WAC lũy tiến, xuất file Auto-PO). |
| **5** | **Giám sát Sảnh (FOH)** | `foh@maisonvie.vn` hoặc `supervisor@maisonvie.vn` | `sandbox` | Doanh số, Định mức | Không | Không | Chỉ xem Doanh số và Định mức (để đối chiếu mã POS lỗi cuối ngày). |
| **6** | **Bếp phó (Sous Chef)** | `souschef@maisonvie.vn` | `sandbox` | Định mức, Kiểm kho | Khai báo hủy hỏng, BTP | Không | Định mức, Kiểm kho, Bán thành phẩm (Nhập Waste log trong ca và báo cáo nấu nước sốt/nước dùng). |
| **7** | **Thủ kho / Kế toán phụ** | `storekeeper@maisonvie.vn` hoặc `junior@maisonvie.vn` | `sandbox` | Kho | Hóa đơn mua lẻ (Pending) | Không | Chỉ được xem Master Kho và nhập hóa đơn mua lẻ (ở trạng thái chờ duyệt). |

*Lưu ý: Mật khẩu `sandbox` dùng để kích hoạt cơ chế đăng nhập lai (Hybrid), tự động bỏ qua Supabase Auth để phục vụ mục đích kiểm thử tiện lợi trên trang live.*

---

## 2. LOGIC NGHIỆP VỤ & THUẬT TOÁN ĐẶC THÙ

Hệ thống tích hợp 4 mốc thời gian và thuật toán cốt lõi để tự động hóa hoàn toàn quy trình kiểm soát hao hụt kho:

### A. Khóa sổ & Tính giá vốn bình quan gia quyền lũy tiến (Moving WAC) lúc 18h30
*   **Mục đích**: Chốt đơn giá vốn trung bình cho các đợt xuất kho tiêu hao cuối ngày, không ảnh hưởng đến giá vốn lịch sử của các giao dịch trước 18h30.
*   **Công thức**:
    $$\text{WAC Mới} = \frac{\text{Giá trị tồn đầu ngày} + \text{Giá trị hàng nhập trước 18h30}}{\text{Số lượng tồn đầu ngày} + \text{Số lượng nhập trước 18h30}}$$
*   **Hàm cơ sở dữ liệu (PL/pgSQL)**: `calculate_moving_wac()` tự động cập nhật đơn giá vốn `wac_price` trong bảng `ingredients`.

### B. Trừ kho tự động & Phân rã Set Menu lúc 22h30
*   **Mục đích**: Tự động khấu trừ tồn kho nguyên liệu lý thuyết dựa trên doanh thu POS ngày.
*   **Công thức trừ kho**:
    $$\text{Lượng trừ kho thô} = \frac{\text{Lượng tịnh (Net)}}{\text{Yield Rate} / 100} \times \text{Số lượng bán} \times 1.10\ (\text{Wastage Buffer bếp } 10\%)$$
*   **Cơ chế Phân rã Tasting Menu**: Đối với các Set Menu / Tasting Menu (ví dụ: Set 5 món, Set 370k, Set 470k...), hệ thống tự động tìm bảng cấu tạo món đơn lẻ, áp dụng tỷ lệ portion **70%** so với món gọi lẻ (À La Carte) và trừ trực tiếp nguyên liệu thô cấu thành.
*   **Hộp hủy hỏng (Waste Logs)**: Gom toàn bộ phiếu hủy hỏng trong ca đã duyệt để trừ trực tiếp vào kho lý thuyết cuối ngày.

### C. Lọc & Tự động xuất đơn đặt hàng (Auto-PO) lúc 22h40
*   **Mục đích**: Tự động đề xuất đơn hàng gửi nhà cung cấp vào sáng hôm sau đối với các nguyên liệu thuộc nhóm tự động hóa (`auto_po_group = 'AUTO_PO'`) bị tụt dưới mức tối thiểu.
*   **Công thức**:
    $$\text{Số lượng đặt} = \text{max\_stock} - \text{Tồn lý thuyết hiện tại}$$
*   **Xuất PO**: Gom nhóm theo Danh mục thu mua và xuất thành 3 file Excel PO chuyên biệt gửi trực tiếp cho Purchasing.

### D. Màn hình Mapping Trung gian 30 Giây
*   Khi import file POS doanh thu cuối ngày, hệ thống đếm ngược 30 giây:
    *   🟢 Khớp 100%: Mã POS trùng khớp với Recipe.
    *   🟡 Gợi ý (Suggested): Áp dụng thuật toán so khớp khoảng cách ký tự (Levenshtein) để đề xuất định mức tương thích kèm % chính xác (ví dụ: "Angus US Ribeye - Khớp 92%"). Kế toán kho có quyền chỉnh sửa tay trước khi bấm **Chốt sổ ghi nhận**.

---

## 3. CƠ SỞ DỮ LIỆU PHẲNG (SUPABASE SCHEMA DDL)

Cơ sở dữ liệu của hệ thống gồm 8 bảng phẳng độc lập liên kết chặt chẽ bằng khóa ngoại (đã được cấu hình toàn bộ tại [schema.sql](file:///d:/Invenroty/maison-vie-crm/supabase/schema.sql) và các hàm tại [functions.sql](file:///d:/Invenroty/maison-vie-crm/supabase/functions.sql)):

1.  **profiles**: Thông tin người dùng và vai trò phân quyền (admin, head_chef, sous_chef...).
2.  **purchase_categories**: Danh mục thu mua để xuất PO chuyên biệt (Thịt, Hải sản, Rau củ, Rượu vang...).
3.  **ingredients**: Master nguyên vật liệu (chứa `wac_price`, `min_stock`, `max_stock`, `yield_rate`, `auto_po_group`).
4.  **menu_items**: Danh mục món ăn POS bán ra, chứa cờ `is_set_menu`.
5.  **set_menu_items**: Bảng liên kết phân rã Tasting Menu và Set Menu theo tỷ lệ portion định mức.
6.  **recipes**: Định mức cấu thành món ăn (BOM - Link món ăn và nguyên liệu thô).
7.  **inventory_transactions**: Lịch sử nhập, xuất, kiểm kho, hủy hỏng thực tế.
8.  **waste_logs**: Nhật ký hủy hỏng thực phẩm trong ca do Bếp phó nhập.

---

## 4. CHI TIẾT CÁC GIAI ĐOẠN ĐÃ HOÀN THÀNH (MỐC 90 NGÀY)

### Giai đoạn 1: Thiết lập cấu trúc & Pilot Nhóm Giá Trị Cao (Tuần 1 - 2)
*   **Kết quả**: Hoàn thành Schema DDL phẳng, 7 cấp RLS bảo mật, database functions tính toán Moving WAC & Auto-PO. Đã test thành công việc trừ kho 13 ngày đầu tháng 6 với nhóm thịt bò Angus, cá hồi, cá tuyết.

### Giai đoạn 2: Đấu nối phân hệ WAC & Nhật ký hủy hỏng ca (Tuần 3 - 4)
*   **Kết quả**: Thiết kế giao diện nhập Waste Log trực quan cho Bếp phó trên tablet. Tích hợp tính năng chốt Moving WAC và thay đổi hệ thống giờ để khóa sổ lúc 18h30.

### Giai đoạn 3: Tích hợp phân rã Tasting Menu & Trừ kho tự động (Tuần 5 - 6)
*   **Kết quả**: Đưa logic phân rã portion **70%** của Tasting/Set Menu từ Excel vào vận hành thực tế trên ứng dụng. Cấu hình log cảnh báo lệch kho vượt biên 5% về cho CFO.

### Giai đoạn 4: Hoàn thiện Auto-PO & Cấu hình NCC (Tuần 7 - 8)
*   **Kết quả**: Thiết lập min/max stock cho 347 mã hàng. Triển khai nút xuất PO tự động lúc 22h40 và màn hình Mapping trung gian đếm ngược 30 giây giúp giảm tải 80% công sức của kế toán.

### Giai đoạn 5: Vận hành song song & Chỉnh sửa lỗi phát sinh (Tuần 9 - 10)
*   **Kết quả**: 
    1.  **Bảng Đối soát Song song (Parallel Dashboard)**: Cho phép import file báo cáo xuất kho Excel cũ để chạy đối chiếu chênh lệch tự động với CRM mới kèm phân tích nguyên nhân hao hụt.
    2.  **Công cụ hiệu chỉnh Yield Rate bếp**: Tính toán Yield thực tế từ chênh lệch vật lý và cho phép Bếp trưởng cập nhật trực tiếp định lượng vào database chỉ với 1 click.
    3.  **Supabase RLS & Stress Simulator**: Chạy giả lập tải peak ca (1000 req/sec) và chạy audit tự động 9/9 quy tắc an toàn bảo mật Supabase RLS hiển thị trực tiếp trên Console Log.

---

## 5. HƯỚNG DẪN KIỂM THỬ TRÊN TRÌNH DUYỆT (VERCEL LIVE)

1.  **Địa chỉ ứng dụng**: [inventory-six-sigma.vercel.app](https://inventory-six-sigma.vercel.app/)
2.  **Đăng nhập**: 
    *   Sử dụng các nút bấm **Đăng nhập nhanh màu xám** tương ứng với vai trò ở phía dưới biểu mẫu đăng nhập.
    *   Hoặc gõ thủ công Email (Ví dụ: `admin@maisonvie.vn`) với Mật khẩu là `sandbox`.
3.  **Trải nghiệm Phân hệ Giai đoạn 5**:
    *   Đăng nhập bằng quyền **💼 CFO / Owner (Admin)** hoặc **👨‍🍳 Bếp trưởng (Head Chef)**.
    *   Click chọn tab **"Đối soát Song song & Yield"** ở sidebar bên trái để kiểm thử:
        *   Tải Excel đối soát và xem nhận xét CFO.
        *   Hiệu chỉnh Yield Rate cho các nhóm thịt bò/cá.
        *   Bấm chạy Stress Test & Audit RLS để xem kết quả kiểm thử an ninh.
