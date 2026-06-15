# TIẾN TRÌNH LÀM VIỆC & TRIỂN KHAI HOÀN CHỈNH GIAI ĐOẠN 6 – NGÀY 15/06/2026
### HỆ THỐNG CRM/ERP INVENTORY & FINANCE – MAISON VIE

Tài liệu này ghi lại toàn bộ quá trình làm việc, cập nhật mã nguồn, thiết lập hệ thống phân quyền và đóng gói bàn giao hệ thống trong ngày 15/06/2026.

---

## 1. HOÀN THÀNH TOÀN BỘ GIAI ĐOẠN 6 (TUẦN 13 - 14)
Đã đóng gói hoàn chỉnh các tài liệu vận hành và tập lệnh sao lưu dự phòng theo đúng cam kết trong Bản kế hoạch v8.0:

### 1.1. Bộ Tài liệu SOP (Quy trình vận hành chuẩn) theo vai trò nhân sự
Đã tạo thư mục `docs/` và lưu trữ các file hướng dẫn chi tiết bằng tiếng Việt:
*   [BAN_GIAO_HE_THONG.md](file:///D:/Invenroty/maison-vie-crm/docs/BAN_GIAO_HE_THONG.md): Hướng dẫn kỹ thuật về cấu trúc phẳng, RLS, tính Moving WAC bảo vệ số âm, quy đổi UoM cục bộ, chốt sổ ngày và các job tự động hóa bằng `pg_cron`.
*   [SOP_CFO_OWNER.md](file:///D:/Invenroty/maison-vie-crm/docs/SOP_CFO_OWNER.md): Quy trình dành cho Cấp 1 (CFO/Owner) để theo dõi các chỉ số tài chính (Doanh thu, Food Cost %, Giá trị tồn kho), phê duyệt Yield Rate sơ chế từ Bếp trưởng và rà soát lịch sử kiểm toán `audit_log`.
*   [SOP_KE_TOAN.md](file:///D:/Invenroty/maison-vie-crm/docs/SOP_KE_TOAN.md): Hướng dẫn Kế toán kho (Cấp 4) thực hiện quy trình nhập hàng, đối soát 3-Way Match (PO ↔ GRN ↔ Hóa đơn), đồng bộ mapping POS và duyệt Auto-PO cuối ngày.
*   [SOP_THU_KHO_BEP.md](file:///D:/Invenroty/maison-vie-crm/docs/SOP_THU_KHO_BEP.md): Hướng dẫn Thủ kho nhận hàng thực tế, Bếp phó tạo Waste Log hủy hỏng trong ca, khai cơm nhân viên (Non-sale), thực hiện kiểm kho bằng cân điện tử đối với rượu bar và gửi yêu cầu điều chỉnh Yield sơ chế.

### 1.2. Tập lệnh Sao lưu cơ sở dữ liệu hàng tuần (Weekly Backup)
*   Đã tạo file [backup_weekly.bat](file:///D:/Invenroty/maison-vie-crm/supabase/backup_weekly.bat) tại thư mục `supabase/`.
*   Script tự động kết nối và dump cơ sở dữ liệu Supabase PostgreSQL về thư mục sao lưu cục bộ `D:\Invenroty\backups`, đặt tên tự động theo ngày chạy (Ví dụ: `maison_vie_backup_20260615.sql`), sẵn sàng tích hợp với Windows Task Scheduler.

---

## 2. NÂNG CẤP PHÂN QUYỀN BẢO MẬT & PHÂN HỆ DOANH THU
Thực hiện yêu cầu ẩn tuyệt đối thông tin nhạy cảm về doanh thu bán hàng khỏi tất cả các vai trò cấp dưới:

*   **Ẩn Thẻ Doanh thu POS**: Bọc thẻ thống kê **"Tổng Doanh thu POS"** trên Dashboard bằng điều kiện cứng `{userRole === 'admin' && ( ... )}`. Chỉ duy nhất CFO/Owner nhìn thấy thẻ này, tất cả vai trò khác đều bị ẩn hoàn toàn (không hiện thông tin khóa).
*   **Chặn phân hệ Doanh số**: Sửa đổi hàm [hasTabAccess](file:///D:/Invenroty/maison-vie-crm/src/app/page.tsx#L162-L180), thu hồi quyền truy cập tab **"Doanh số & POS Import"** của tất cả các cấp dưới (Quản lý nhà hàng, Kế toán kho, Giám sát sảnh...). Phân hệ này hiện tại chỉ hiển thị và cho phép duy nhất CFO/Owner thao tác.

---

## 3. TÍCH HỢP TÍNH NĂNG ĐỔI MẬT KHẨU (ĐÃ FIX LỖI SESSION)
*   **Giao diện**: Thêm nút **"Đổi mật khẩu"** nhỏ cạnh phần hiển thị tên người dùng ở Header, kích hoạt Modal điền mật khẩu mới.
*   **Khắc phục lỗi "Auth session missing!"**:
    *   *Nguyên nhân*: Khi kiểm thử bằng tài khoản Sandbox (bỏ qua Supabase Auth để login nhanh), hệ thống không có phiên đăng nhập (session) thực tế trên Supabase Cloud nên việc gọi API cập nhật mật khẩu của Supabase bị lỗi.
    *   *Khắc phục*: Thêm bước kiểm tra sự tồn tại của session qua `supabase.auth.getSession()`.
        *   Nếu có session thật (Production): Cập nhật mật khẩu bảo mật lên Supabase Cloud qua hàm `supabase.auth.updateUser()`.
        *   Nếu không có session thật (Sandbox): Tự động giả lập cập nhật thành công ngay trên giao diện để phục vụ kiểm thử suôn sẻ.

---

## 4. CHUẨN HÓA DANH SÁCH EMAIL ĐĂNG NHẬP THEO YÊU CẦU MỚI
Cập nhật hệ thống nút đăng nhập nhanh ở màn hình Login của Sandbox:

*   **CFO / Owner (Admin)**: Đổi email thành **`ceo@maisonvie.vn`**.
*   **Tất cả vai trò còn lại** (Quản lý Nhà hàng, Bếp trưởng, Kế toán cao cấp, Bếp phó, Thủ kho/Kế toán phụ): **Đồng loạt đổi thành email duy nhất `maisonvie.vn@gmail.com`**.
*   **Cơ chế định tuyến Sandbox (Sandbox Role Override)**: Bổ sung thêm biến trạng thái `sandboxRoleOverride` để lưu vết nút vai trò người dùng click chọn. Khi submit form với email `maisonvie.vn@gmail.com`, hệ thống tự nhận dạng vai trò cụ thể tương ứng để đăng nhập chính xác, giải quyết triệt để vấn đề trùng lặp email.

---

## 5. ĐỒNG BỘ HÓA & KHỞI CHẠY HỆ THỐNG
*   **Git / GitHub**: Đã commit và push toàn bộ các file sửa đổi lên nhánh `main` của GitHub chính thức tại **`https://github.com/maisonvie-vn/inventory.git`**.
*   **Vercel**: Tiến trình tự động build & deploy trên Vercel đã hoàn tất, cập nhật giao diện mới nhất lên môi trường chạy thật trực tuyến.
*   **Local Dev Server**: Máy chủ Next.js cục bộ đã được khởi chạy thành công tại địa chỉ **[http://localhost:3000](http://localhost:3000)** phục vụ kiểm thử ngoại tuyến.

---

## 6. GỘP VAI TRÒ ĐĂNG NHẬP & PHÂN TÁCH KHO BẾP/BAR (CẬP NHẬT MỚI CUỐI NGÀY)
Thực hiện yêu cầu tinh giản phân quyền và phân tách hiển thị kho Bếp/Bar độc lập:
*   **Gộp 4 Nhóm Vai trò**: Thay thế hoàn toàn cổng đăng nhập phụ `/bar` bằng 4 nhóm tài khoản sandbox trực tiếp tại trang chủ:
    1. `ceo@maisonvie.vn` -> Admin (Owner / CFO / Admin)
    2. `maisonvie.vn@gmail.com` -> Restaurant Manager (Chef / Manager / Thủ Kho)
    3. `maisonvie.vn@gmail.com` -> Senior Accountant (SousChef / Kế toán)
    4. `maisonvie.vn@gmail.com` -> Bar Supervisor (Bar)
*   **Tách hiển thị dữ liệu Bếp / Bar**:
    *   Khi bộ phận Bar đăng nhập: Chỉ hiển thị các mặt hàng rượu, bia, nước ngọt, mocktails. Ẩn toàn bộ nguyên liệu thực phẩm của bếp.
    *   Khi bộ phận Bếp đăng nhập: Chỉ hiển thị các mặt hàng thực phẩm sơ chế, gia vị, đồ bếp. Ẩn toàn bộ rượu bia nước ngọt của Bar.
    *   Áp dụng trên Bảng Master Kho (Tab 1), Phiếu Kiểm Kho & Cân dở (Tab 5), Dropdown Chuyển kho nội bộ, và Khai hao ngoài bán hàng (Spill/Vỡ).

---

## 7. IMPORT TOÀN BỘ 183 MẶT HÀNG KHO BAR TỪ EXCEL
Đã xử lý dứt điểm tình trạng quầy Bar chỉ hiển thị một vài loại rượu bằng cách nạp toàn bộ danh mục thực tế:
*   **Đồng bộ 183 mặt hàng**: Sử dụng script Python đọc trực tiếp từ tệp [MAISON_VIE_v6_0_PRO.xlsx](file:///D:/Invenroty/MAISON_VIE_v6_0_PRO.xlsx) sheet `MASTER_BAR` vào danh mục nguyên liệu.
*   **Mappings POS tự động**: Ánh xạ POS chuẩn trong [mockData.ts](file:///D:/Invenroty/maison-vie-crm/src/data/mockData.ts) đối với tất cả 183 mặt hàng bia chai/lon, nước ngọt lon, rượu vang chai, rượu mạnh... trừ kho 1-1 khi bán. Các đồ uống pha chế, ly rượu lẻ được tự động quy đổi để trừ hao các nguyên liệu quả/sữa/trà tương ứng.
*   **Hạt giống dữ liệu SQL**: Cập nhật tệp [seed.sql](file:///D:/Invenroty/maison-vie-crm/supabase/seed.sql) bổ sung danh mục `BEVERAGE`, các đơn vị tính `CAN`, `GLASS`, `PACK`, `BOX`, `BAG` và 183 insert statements nguyên liệu kèm nhà cung cấp để đồng bộ lên Supabase Cloud.

---
*Tiến trình ngày 15/06/2026 kết thúc tốt đẹp. Toàn bộ code đã được push lên GitHub và deploy thành công lên Vercel. Máy chủ Next.js và dữ liệu đã sẵn sàng cho ngày làm việc tiếp theo.*

