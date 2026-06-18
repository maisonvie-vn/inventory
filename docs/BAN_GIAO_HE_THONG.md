# BÀN GIAO HỆ THỐNG CRM/ERP INVENTORY – MAISON VIE v9.6
### (Tài liệu kỹ thuật và kiến trúc hệ thống dành cho COO / CFO / System Admin)

Tài liệu này hướng dẫn chi tiết về mặt kỹ thuật, kiến trúc cơ sở dữ liệu, phân tầng bảo mật, quản lý tài khoản/PIN và cấu hình tự động của hệ thống CRM/ERP Inventory của Maison Vie v9.6.

---

## 1. KI KIẾN TRÚC TỔNG THỂ (System Architecture)

Hệ thống Maison Vie CRM/ERP Inventory được xây dựng dựa trên nguyên tắc **"Database-centric, serverless-thin"** nhằm tối đa hóa độ chính xác của số liệu tài chính đồng thời giữ chi phí vận hành ở mức tối thiểu.

```mermaid
graph TD
    User([Người dùng / Nhân viên]) -->|Next.js App / Vercel| FE[Giao diện Next.js Web App]
    FE -->|SheetJS| ExcelParser[Đọc & Phân rã Excel POS ngay tại Browser]
    ExcelParser -->|Gọi API / Server Actions| Supabase[Supabase DB / PostgreSQL]
    
    subgraph Supabase Cloud
        Supabase -->|RLS Policies| Tables[(Sổ cái append-only)]
        Supabase -->|Database Views| Views[v_inventory_ops / v_inventory_cost / v_inventory_finance]
        Supabase -->|pg_cron Scheduler| Jobs[WAC recalculated / Sale Depletion / Auto-PO / Watchdog]
    end
```

*   **Tầng Giao diện (Frontend - Vercel)**: Next.js (React) chạy mỏng. Các tính năng nặng như đọc và phân tích file Excel POS được thực hiện trực tiếp trên trình duyệt của người dùng thông qua thư viện **SheetJS**, giảm thiểu chi phí Compute và thời gian chạy Serverless Functions của Vercel (giới hạn 10s/request gói Free).
*   **Tầng Cơ sở dữ liệu (Backend - Supabase)**: Chứa toàn bộ logic nghiệp vụ (WAC, trừ kho, Auto-PO, variance) viết bằng **PL/pgSQL**. Các công việc định kỳ được xử lý bởi extension **`pg_cron`** chạy trực tiếp trong cơ sở dữ liệu.
*   **Nguyên tắc Bất biến (Append-Only Ledger)**: Mọi biến động kho đều được lưu tại một bảng duy nhất là `inventory_transactions`. Không cho phép bất kỳ vai trò nào thực hiện `UPDATE` hoặc `DELETE` trên bảng này. Nếu có sai sót, nhân viên bắt buộc phải tạo **bút toán đảo (reversal entry)** để sửa đổi, đảm bảo tính minh bạch kiểm toán.

---

## 2. BẢO MẬT, TÀI KHOẢN ĐĂNG NHẬP & CẬP NHẬT MẬT KHẨU / PIN

### 2.1. Phân quyền và Phân tách View Tài chính (RBAC & RLS)
Để giải quyết vấn đề rò rỉ thông tin giá vốn và doanh thu, hệ thống không cho phép các vai trò thông thường truy cập trực tiếp vào các bảng cơ sở dữ liệu gốc. Thay vào đó, dữ liệu được phân tách qua **3 tầng Database View**:
1.  **`v_inventory_ops` (View Vận hành)**: Loại bỏ hoàn toàn các cột giá vốn (WAC), giá trị tồn kho (VND), và doanh thu. Dành cho Cấp 2 (Quản lý), Cấp 3 (Bếp trưởng), Cấp 5 (Giám sát), Cấp 6 (Bếp phó), Cấp 7 (Thủ kho).
2.  **`v_inventory_cost` (View Kế toán kho)**: Hiển thị số lượng kèm theo giá vốn WAC để làm báo cáo nhập hàng, 3-way match, và duyệt Auto-PO, nhưng **không hiển thị** doanh thu POS hay Food Cost %. Dành cho Cấp 4 (Kế toán kho cấp cao).
3.  **`v_inventory_finance` (View Tài chính)**: Hiển thị đầy đủ số lượng, giá vốn WAC, doanh thu POS, giá trị kho VND và Food Cost %. **Chỉ dành riêng cho Cấp 1 (CFO/Owner/Admin)**.

*   **Bảo mật tuyệt đối "Tổng Doanh thu POS"**: Component hiển thị thẻ **"Tổng Doanh thu POS"** trong Dashboard được bọc hoàn toàn bằng điều kiện cứng `userRole === 'admin'`. Các vai trò khác sẽ không nhìn thấy thẻ này trên giao diện UI.

### 2.2. Tài khoản Đăng nhập mặc định (Sandbox Mode)
Ở chế độ thử nghiệm nội bộ hoặc khi không có kết nối cơ sở dữ liệu thật (Local Sandbox Mode), hệ thống hỗ trợ đăng nhập nhanh bằng mật khẩu mặc định là `sandbox`:

| Vai trò | Email mặc định | Mật khẩu | Phân quyền tương ứng (Role) |
| :--- | :--- | :--- | :--- |
| **Owner / CFO / Admin** | `ceo@maisonvie.vn` | `sandbox` | `admin` |
| **Chef / Quản lý / Thủ kho** | `maisonvie.vn@gmail.com` | `sandbox` | `restaurant_manager` |
| **SousChef / Kế toán phụ** | `maisonvie.vn@gmail.com` | `sandbox` | `senior_accountant` |
| **Bar / Giám sát quầy Bar** | `maisonvie.vn@gmail.com` | `sandbox` | `BAR_SUPERVISOR` |

### 2.3. Hướng dẫn thay đổi Mật khẩu và mã PIN cá nhân
*   **Đổi mật khẩu người dùng (CRM chính)**:
    *   *Mô tả*: Người dùng đăng nhập vào CRM chính, click chọn chữ **"Đổi mật khẩu"** ở cạnh tên tài khoản trên Header. Modal nhập mật khẩu hiện ra và gọi hàm:
        ```javascript
        const { error } = await supabase.auth.updateUser({ password: newPassword });
        ```
    *   *Bảo vệ*: Trong Sandbox Mode, hệ thống mô phỏng việc đổi thành công và lưu tạm thời; trong Production Mode, hành động này cập nhật trực tiếp tài khoản đăng nhập Supabase Auth của chính chủ.
*   **Đổi mã PIN đăng nhập quầy Bar (Tablet dùng chung)**:
    *   *Mô tả*: Cổng Bar (/bar) sử dụng máy tính bảng chung, Bartender đăng nhập bằng mã PIN 4 số cá nhân:
        *   Bartender Minh Cường: PIN `1234`
        *   Bartender Hoài Nam: PIN `5678`
        *   Trưởng Bar Quốc Tuấn: PIN `0000`
    *   *Sandbox Mode*: Các mã PIN này được lưu tại hằng số `BAR_USERS` trong tệp `src/app/bar/page.tsx`. Thay đổi bằng cách chỉnh sửa trực tiếp mã nguồn.
    *   *Production Mode*: PIN được lưu trữ dưới dạng mã hóa một chiều (bcrypt hash) tại bảng `profiles` (cột `pin_hash`). Admin có thể cập nhật trực tiếp thông qua câu lệnh SQL trong Supabase SQL Editor:
        ```sql
        UPDATE profiles SET pin_hash = crypt('NEW_PIN', gen_salt('bf')) WHERE username = 'user_name';
        ```

---

## 3. LOGIC NGHIỆP VỤ CỐT LÕI (v9.6 Upgrades)

### 3.1. Thiết kế Master-Data mới (`ingredients.id` → UUID)
Để đảm bảo người dùng có thể đổi mã nguyên liệu hiển thị (`code`) mà không làm vỡ các khóa ngoại tham chiếu, hệ thống v9.6 đã thay đổi cấu trúc bảng:
*   Khóa chính (`PK`): `ingredients.id` sử dụng kiểu dữ liệu **UUID** được tạo ngẫu nhiên.
*   Cột mã hiển thị (`code`): Chuyển thành cột thường có ràng buộc **UNIQUE** và kiểm tra chữ in hoa, không dấu cách. Khi sửa đổi `code`, hệ thống cập nhật bình thường và ghi vết vào bảng `audit_log`, không làm đứt gãy dữ liệu vì các bảng con liên kết thông qua cột `ingredient_id` kiểu UUID.

### 3.2. Quản lý Tiêu thụ ngoài bán hàng (`non_sale_consumption`)
Nguyên liệu dùng làm cơm nhân viên, R&D thử món, mời khách VIP hoặc đào tạo không được ghi nhận dưới dạng "bán hàng giá 0đ" để bảo vệ tính chính xác của doanh thu và Food Cost %.
*   Hệ thống lưu tại bảng `non_sale_consumption` với các lý do: `STAFF_MEAL`, `TRAINING`, `COMP`, `TASTING`, `RND`, `OTHER`.
*   Tự động sinh bút toán kho loại `OUT`, `source = 'NON_SALE'`. Số lượng này trừ kho lý thuyết để tính toán chênh lệch (Variance) chính xác nhưng được báo cáo tách biệt, không tính vào doanh thu.

### 3.3. Quy trình Kiểm kê đóng băng (Freeze-Count Stocktakes)
Để tránh tình trạng nhân viên vừa kiểm kê đếm hàng thực tế vừa có giao dịch POS trừ kho làm sai lệch số liệu:
*   Khi nhân viên bấm **"Bắt đầu kiểm kê"**, hệ thống thực hiện lệnh **Freeze** chụp lại số lượng tồn lý thuyết tại thời điểm đó (`system_qty` snapshot).
*   Mọi phiếu đếm thực tế của nhân viên nhập vào sẽ được so sánh với `system_qty` đã chụp này. Các thay đổi tồn kho thực tế sau thời điểm freeze sẽ được cộng dồn sau khi phiếu kiểm kê được **Approved & Posted** để ghi nhận giao dịch điều chỉnh (`ADJUST`).

### 3.4. Cấu hình Tham số Đa vùng (Effective-Dated App Settings)
Các thiết lập hệ thống được chia làm 3 vùng quản trị:
1.  **Vùng Vô hại (COSMETIC)**: Tên nhà hàng, logo. Sửa đổi tự do.
2.  **Vùng Vận hành (OPERATIONAL)**: Giờ chạy cron, cảnh báo, reorder. Hiệu lực tức thì.
3.  **Vùng Tài chính (FINANCIAL)**: VAT, phí dịch vụ, ngưỡng PO, buffer hao hụt.
    *   *Cơ chế Bảo vệ*: Các cài đặt tài chính được lưu trữ lịch sử theo ngày hiệu lực (`app_settings_history` với cột `valid_from` và `valid_to`). Khi tính toán giá trị trong quá khứ, hệ thống tìm cấu hình tài chính tương ứng với ngày giao dịch đó, đảm bảo lịch sử báo cáo tài chính không bị ghi đè hay thay đổi bất hợp pháp.

### 3.5. Quy trình Bán thành phẩm (BTP) & BOM Nhiều tầng
Hỗ trợ quản lý mẻ sản xuất (demi-glace, nước dùng gà) nấu tại bếp:
*   Mỗi mẻ sản xuất sinh một `Production Order` ghi nhận giảm kho nguyên liệu thô (`OUT` đầu vào) và tăng kho BTP đầu ra (`IN` đầu ra).
*   Đơn giá vốn WAC của BTP = `Tổng giá trị nguyên liệu đầu vào` $\div$ `sản lượng mẻ thực tế thu được`.
*   BTP được cấu hình như một nguyên liệu bình thường và có thể đóng vai trò là đầu vào cho công thức món ăn khác, tạo ra cây định lượng (BOM) đa cấp.

---

## 4. TỰ ĐỘNG HÓA VÀ LẬP LỊCH (pg_cron Scheduler)

Hệ thống lập lịch tự động hàng ngày trong cơ sở dữ liệu bằng `pg_cron` (múi giờ Asia/Ho_Chi_Minh):
*   **18:30 (Chốt WAC)**: Tạo snapshot giá vốn trong ngày để phục vụ báo cáo.
*   **22:30 (Trừ kho POS)**: Phân rã món ăn bán trong ngày thành định mức nguyên liệu thô, trừ trực tiếp tồn kho lý thuyết.
*   **22:40 (Auto-PO)**: Tính toán nhu cầu hàng hóa dự kiến dựa trên trung bình động tiêu thụ 14 ngày gần nhất, tạo đơn đặt hàng nháp cho các nhà cung cấp nếu lượng tồn xuống dưới mức tồn an toàn.
*   **23:00 (Watchdog)**: Kiểm tra trạng thái đóng sổ ngày (`daily_close`). Nếu phát hiện lỗi hoặc thiếu bước, tự động bắn email cảnh báo khẩn cấp cho ban quản trị thông qua Resend API.

---

## 5. KHUYẾN NGHỊ TRIỂN KHAI VÀ HẠ TẦNG

> [!IMPORTANT]
> **Khuyến nghị nâng cấp Supabase Pro**:
> Maison Vie nên sử dụng gói **Supabase Pro (khoảng $25/tháng)** cho môi trường chạy thật. Gói Free của Supabase có giới hạn tự động pause dự án sau 7 ngày không hoạt động, không hỗ trợ PITR (Point-in-Time Recovery - sao lưu khôi phục theo từng giây) và hạn chế hiệu năng xử lý `pg_cron` cho các bút toán lớn cuối ngày.
