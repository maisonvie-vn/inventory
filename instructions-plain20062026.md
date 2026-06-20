# HƯỚNG DẪN CHI TIẾT & NHẬT KÝ THỰC HIỆN NGÀY 20/06/2026

Tài liệu này ghi lại toàn bộ các công việc nâng cấp hệ thống, sửa lỗi tranh chấp mã PO, đồng bộ tồn kho thực tế, tối ưu hóa giao diện in ấn liền mạch và điền tự động chữ ký đã thực hiện cho dự án **Maison Vie CRM/ERP - Hệ thống quản lý kho & tính giá vốn WAC (Phiên bản nâng cấp v9.6)**.

---

## 1. Khắc phục lỗi Trùng khóa PO (Duplicate PO Number Key Constraint)
*   **Vấn đề:** Khi người dùng tạo nhiều PO đồng thời từ Worklist hoặc qua form thủ công, hệ thống báo lỗi `duplicate key value violates unique constraint "purchase_orders_po_number_key"`. Nguyên nhân là do các PO cũ trước đó trong tháng 6/2026 bị lưu cột `version` mặc định là `1` (do thiếu cột khi chèn ở các bản cũ), dẫn tới biểu thức tính toán chỉ số tiếp theo `coalesce(max(version), 0) + 1` luôn trả về `2`, gây trùng lặp với các đơn hàng hiện hữu. Đồng thời, việc gọi đồng thời từ frontend gây tranh chấp tài nguyên (race condition) khi sinh số PO.
*   **Giải pháp đã thực hiện:**
    *   **Khóa tuần tự hóa:** Thêm cơ chế khóa bảng độc quyền (`LOCK TABLE purchase_orders IN SHARE ROW EXCLUSIVE MODE;`) ở đầu hàm `create_po_from_worklist` để đảm bảo các yêu cầu tạo PO được xếp hàng xử lý tuần tự, tránh sinh trùng mã.
    *   **Lưu chỉ số version:** Cấu hình rõ ràng việc chèn cột `version` trong câu lệnh `INSERT` PO mới.
    *   **Cập nhật dữ liệu lịch sử:** Tạo tệp patch [patch_v3_0_13_recalculate_po_version.sql](file:///d:/Invenroty/maison-vie-crm/supabase/patch_v3_0_13_recalculate_po_version.sql) trích xuất chỉ số thực tế từ mã PO hiện tại (ví dụ: lấy chỉ số thứ tự ở ký tự 11-14 của `PO-202606-0002-MAI` là `2`) và lưu lại vào cột `version`. Từ đó, chỉ số lớn nhất được cập nhật đúng là `2`, giúp PO tiếp theo sinh ra là `3` không còn lỗi.

---

## 2. Khắc phục cột Số lượng Tồn hiển thị bằng 0 (stock_at_order)
*   **Vấn đề:** Người dùng phản hồi mặc dù trong kho vẫn có hàng tồn thực tế, nhưng khi xuất phiếu in PO ra PDF thì cột chênh lệch tồn kho hiển thị tất cả bằng 0.
*   **Giải pháp đã thực hiện:**
    *   **Truy vấn tồn kho realtime:** Cấu hình lại hàm `create_po_from_worklist` để tự động truy cập vào view `v_stock_on_hand` theo đúng `ingredient_id` và `location_id` ngay tại thời điểm tạo PO.
    *   **Ghi nhận tồn kho tại thời điểm đặt hàng:** Giá trị tồn kho này được ghi nhận trực tiếp vào cột `stock_at_order` của bảng `po_lines` (nằm trong tệp patch [patch_v3_0_11_po_lines_stock_at_order.sql](file:///d:/Invenroty/maison-vie-crm/supabase/patch_v3_0_11_po_lines_stock_at_order.sql)).
    *   **Backfill dữ liệu cũ:** Viết câu lệnh cập nhật số lượng tồn kho hiện tại vào các dòng PO cũ đang có giá trị bằng 0 để đảm bảo hiển thị đồng nhất.

---

## 3. Nâng cấp Giao diện in PO Liền mạch (Seamless PDF Print Layout)
*   **Vấn đề:** Khi chọn in nhiều PO cùng lúc từ danh sách duyệt hoặc lịch sử, hệ thống cũ phân tách mỗi nhà cung cấp (supplier) ra một trang PDF riêng biệt (có forced page break). Người dùng yêu cầu in liền mạch, nối tiếp nhau trên cùng một tài liệu PDF để tiết kiệm không gian và in một lần duy nhất.
*   **Giải pháp đã thực hiện:**
    *   Cập nhật hàm `handlePrintPO` trong tệp [PurchasingModule.tsx](file:///d:/Invenroty/maison-vie-crm/src/app/components/PurchasingModule.tsx).
    *   **Loại bỏ ép ngắt trang:** Gỡ bỏ thuộc tính `page-break-after: always;` của class `.po-page` trong `@media print`.
    *   **Tránh vỡ bố cục đơn hàng:** Bổ sung thuộc tính `page-break-inside: avoid;` để đảm bảo toàn bộ nội dung của một PO (bảng hàng hóa và chữ ký) không bị cắt đôi cắt ba dở dang giữa 2 trang giấy mà sẽ tự động di chuyển nguyên khối xuống trang tiếp theo nếu không đủ chỗ.
    *   **Đường kẻ phân tách:** Thêm đường viền nét đứt (`border-bottom: 1px dashed #333; padding-bottom: 30px; margin-bottom: 30px;`) làm dấu ngăn cách trực quan giữa các đơn hàng PO của các nhà cung cấp khác nhau trên cùng một mặt giấy in.

---

## 4. Sửa đổi hiển thị Mã hàng trong PDF thay vì UUID
*   **Vấn đề:** Cột `Mã hàng` trong bảng in PO hiển thị chuỗi UUID của nguyên liệu (như `s0000000-...` hoặc `ingredient_id`) thay vì mã nguyên vật liệu chuẩn dạng `ING-205` hay `NLP5024`.
*   **Giải pháp đã thực hiện:**
    *   Điều chỉnh logic gom nhóm trong `handlePrintPO` để lưu lại và truy xuất trường `ingredient_code`.
    *   Thay thế trường hiển thị từ `line.ingredient_id` thành `line.ingredient_code` trong hàng bảng HTML.

---

## 5. Tự động điền Tên & Bộ phận Chữ ký chân trang (Signature Box Pre-filling)
*   **Vấn đề:** Hộp chữ ký chân trang PO yêu cầu hiển thị rõ tên người lập (đính kèm bộ phận làm việc tương ứng lúc lập như Bar, Bếp, hoặc Kho chính) và người duyệt/người duyệt cuối.
*   **Giải pháp đã thực hiện:**
    *   **Hàm chuẩn hóa tên:** Tạo hàm `formatStaffName` để chuyển đổi các vai trò email (như `chef`, `bar_supervisor`, `cfo`) thành tên hiển thị tiếng Việt trang trọng (như `Bếp trưởng`, `Giám sát Bar`, `CFO`).
    *   **Điền thông tin Người lập:** Hiển thị dưới định dạng `[Bộ phận] - [Tên người lập]` (ví dụ: `Bếp - Bếp trưởng` hoặc `Bar - Giám sát Bar` dựa trên địa điểm nhận hàng `location_id`).
    *   **Điền thông tin Người duyệt / Duyệt cuối:** Tự động hiển thị tên người đã phê duyệt PO nếu có trong DB, hoặc pre-fill vai trò mặc định (`Bếp trưởng / Quản lý` và `CFO / Ban Giám đốc`) để đảm bảo mẫu in luôn đầy đủ thông tin chuyên nghiệp.

---

## 6. Danh sách tệp tin thay đổi
*   **Frontend Components:**
    *   [PurchasingModule.tsx](file:///d:/Invenroty/maison-vie-crm/src/app/components/PurchasingModule.tsx): Sửa đổi logic in, hiển thị mã hàng, và điền tên chữ ký.
*   **Database Patches (Supabase SQL):**
    *   [patch_v3_0_11_po_lines_stock_at_order.sql](file:///d:/Invenroty/maison-vie-crm/supabase/patch_v3_0_11_po_lines_stock_at_order.sql): Lưu trữ số lượng tồn kho realtime khi tạo PO.
    *   [patch_v3_0_12_fix_po_number_duplicate.sql](file:///d:/Invenroty/maison-vie-crm/supabase/patch_v3_0_12_fix_po_number_duplicate.sql): Khóa bảng và sửa đổi sinh số PO không trùng.
    *   [patch_v3_0_13_recalculate_po_version.sql](file:///d:/Invenroty/maison-vie-crm/supabase/patch_v3_0_13_recalculate_po_version.sql): Đồng bộ lại version của các PO lịch sử.
