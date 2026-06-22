# HƯỚNG DẪN CHI TIẾT & NHẬT KÝ THỰC HIỆN NGÀY 22/06/2026

Tài liệu này ghi lại toàn bộ các công việc nâng cấp giao diện, căn chỉnh bảng biểu, tối ưu hóa định dạng cột Yield %, phân quyền biên tập định mức tồn kho và loại bỏ đơn vị tiền tệ "đ" đồng bộ trên toàn bộ frontend đã thực hiện cho dự án **Maison Vie CRM/ERP - Hệ thống quản lý kho & tính giá vốn WAC**.

---

## 1. Ẩn cột "Tên tiếng Pháp" tại Master Kho 101
*   **Yêu cầu:** Gỡ bỏ cột "Tên tiếng Pháp" khỏi bảng "Danh mục nguyên vật liệu" thuộc tab **Bảng Master Kho 101** để tăng không gian hiển thị cho các cột thông tin cốt lõi khác.
*   **Giải pháp đã thực hiện:** 
    *   Cập nhật bảng danh sách nguyên vật liệu trong tab Master Kho 101, ẩn hoàn toàn thẻ tiêu đề `<th>` và ô dữ liệu `<td>` tương ứng với cột tên tiếng Pháp.

---

## 2. Căn chỉnh Bảng Master Kho tự động vừa Khung (Responsive Layout)
*   **Vấn đề:** Chiều ngang của bảng danh mục nguyên vật liệu bị tràn viền và che khuất cột "Tồn tối thiểu" (người dùng phải kéo ngang hết cỡ mới xem được). Kích thước các cột ĐVT và Giá vốn chuẩn chiếm dụng quá nhiều không gian.
*   **Giải pháp đã thực hiện:**
    *   Thu nhỏ chiều rộng của các cột phụ như **ĐVT**, **Giá vốn chuẩn** về kích thước tối giản.
    *   Thiết lập thuộc tính CSS tự động điều chỉnh tỷ lệ chiều rộng và bọc bảng trong khung flex/overflow-x để bảng luôn nằm gọn trong khung nhìn chính của tab mà không bị tràn màn hình hoặc che khuất dữ liệu tồn tối thiểu.
    *   Tăng chiều rộng hiển thị của cột Tên Nguyên Liệu để đảm bảo thông tin tên đầy đủ, dễ đọc.

---

## 3. Định dạng lại Cột Yield % thành 3 Chữ Số Thống Nhất
*   **Vấn đề:** Cột Yield % (Tỷ lệ thu hồi) hiển thị các con số không đúng định dạng phần trăm trực quan (ví dụ: hiển thị dạng 10000% thay vì 100%).
*   **Giải pháp đã thực hiện:**
    *   Chuẩn hóa công thức định dạng Yield % hiển thị trên bảng, đảm bảo hiển thị đúng dạng 3 chữ số phần trăm sạch sẽ (ví dụ: `100%`, `80%` hoặc `95%`) đại diện chính xác cho tỷ lệ hao hụt nguyên vật liệu.

---

## 4. Phân quyền Biên tập Định mức Tồn kho Tối thiểu / Tối đa / An toàn
*   **Yêu cầu:** Thiết lập quyền chỉnh sửa các chỉ số định mức kho bao gồm Tồn tối thiểu (`min_stock`), Tồn tối đa (`max_stock`), và Tồn an toàn (`safety_stock`). Chỉ có các vai trò Quản lý cấp cao mới được sửa đổi các giá trị này, các vai trò khác chỉ được xem.
*   **Giải pháp đã thực hiện:**
    *   Áp dụng chính sách kiểm tra vai trò người dùng (`userRole`).
    *   Chỉ cho phép các vai trò **CFO** (`senior_accountant`), **Admin** (`admin`), và **Manager** (`restaurant_manager`) nhấp vào để chỉnh sửa các giá trị định mức tồn kho thông qua ô nhập số (input fields).
    *   Với các vai trò còn lại (như Thủ kho, Chef, Bar), các trường định mức này được hiển thị dưới dạng văn bản tĩnh chỉ đọc (read-only text), ngăn chặn hoàn toàn việc sửa đổi dữ liệu định mức kho trái phép từ phía client.

---

## 5. Loại bỏ Ký hiệu Tiền tệ "đ" trên toàn bộ Giao diện Frontend
*   **Yêu cầu:** Loại bỏ ký hiệu tiền tệ Việt Nam Đồng (`đ`, `₫`, hoặc ` đ`) đi kèm sau tất cả các con số trên các bảng biểu, biểu đồ, metrics cards, form nhập liệu thủ công và các bản in đối soát.
*   **Giải pháp đã thực hiện:**
    *   Rà soát và xóa bỏ hậu tố `đ` / `₫` được ghép chuỗi thủ công sau các hàm hiển thị `.toLocaleString()` hoặc `.toLocaleString('vi-VN')`.
    *   **Các khu vực đã cập nhật:**
        *   **KPI Metrics Cards (`src/app/page.tsx`):** Doanh thu POS, Chi phí tiêu hao (Cost), Giá trị tồn kho ước tính, Lệch kho (Variance).
        *   **Biểu đồ Cột Tiêu hao & Bảng tiêu hao nhiều nhất (`src/app/page.tsx`):** Tooltip hover trên các cột biểu đồ tiêu hao.
        *   **Danh sách Đơn hàng PO & Phiếu Nhận GRN (`src/app/page.tsx`):** Tổng tiền PO, giá trị hóa đơn GRN, chi phí cước vận chuyển & thuế phân bổ, giá gốc và landed cost trong bảng 3-Way Match.
        *   **Danh mục & Chi tiết Recipe (`src/app/page.tsx`):** Giá bán thực đơn lẻ, đơn giá nguyên liệu cấu thành, chi phí dòng nguyên liệu thực tế, hao hụt bếp cộng thêm, tổng giá vốn đĩa (Food cost).
        *   **Kiểm kho & Báo cáo Lệch (`src/app/page.tsx`):** Giá vốn nguyên liệu, trị giá chênh lệch kiểm kê thực tế.
        *   **Danh sách Món chưa ánh xạ (`src/app/page.tsx`):** Doanh thu món ăn POS chưa liên kết công thức.
        *   **Form Nhập liệu Thủ công (`src/app/components/ManualForms.tsx`):** Giá mặc định món ăn, đơn giá và thành tiền bán hàng, tổng giá trị hóa đơn, WAC hiện tại khi nhận GRN, đơn giá gốc, landed cost, tiền hàng gốc, tổng phí phân bổ và tổng giá trị thanh toán chứng từ.
        *   **Chốt kỳ Tồn kho (`src/app/components/ClosedInventory.tsx`):** Các thẻ tổng kết Tồn đầu kỳ, Tổng nhập kỳ, Tổng xuất kỳ, Giá trị tài sản cuối kỳ và các cột Đơn giá WAC, Giá trị cuối kỳ của từng dòng nguyên liệu.
        *   **Mẫu in PO / Đơn đặt hàng (`src/app/components/PurchasingModule.tsx`):** Cột đơn giá, thành tiền và tổng cộng thanh toán trên bản in phiếu đặt hàng gửi NCC.

---

## 6. Danh sách tệp tin thay đổi
*   **Frontend Components:**
    *   [page.tsx](file:///d:/Invenroty/maison-vie-crm/src/app/page.tsx): Loại bỏ ký hiệu `đ` trên toàn bộ dashboard, bảng biểu, tooltip biểu đồ, và popup cảnh báo lệch giá.
    *   [ClosedInventory.tsx](file:///d:/Invenroty/maison-vie-crm/src/app/components/ClosedInventory.tsx): Loại bỏ hậu tố `đ` tại các thẻ giá trị tổng kết tài sản và bảng chốt kỳ.
    *   [ManualForms.tsx](file:///d:/Invenroty/maison-vie-crm/src/app/components/ManualForms.tsx): Loại bỏ `đ` khỏi các dòng hóa đơn bán hàng và nhập kho GRN thủ công.
    *   [PurchasingModule.tsx](file:///d:/Invenroty/maison-vie-crm/src/app/components/PurchasingModule.tsx): Loại bỏ ký hiệu `₫`/`đ` trên biểu in PO và các dòng cấu hình mua hàng.
*   **Tài liệu Dự án:**
    *   [instructions-22062026.md](file:///d:/Invenroty/maison-vie-crm/instructions-22062026.md): Hướng dẫn chi tiết & nhật ký thay đổi ngày 22/06/2026 (tệp này).
    *   [CLAUDE.md](file:///d:/Invenroty/maison-vie-crm/CLAUDE.md): Cập nhật danh sách tài liệu hướng dẫn tại gốc repo.
