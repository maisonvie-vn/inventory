# QUY TRÌNH VẬN HÀNH CHUẨN (SOP) – CFO & OWNER / ADMIN
### (Phân hệ dành cho Cấp 1: Giám sát tài chính, duyệt định mức và kiểm toán)

Quy trình này hướng dẫn CFO, Owner hoặc người có quyền Admin tối cao sử dụng hệ thống CRM/ERP Inventory để quản trị tài chính kho, duyệt đề xuất thay đổi định mức sơ chế, và kiểm tra tính toàn vẹn của dữ liệu.

---

## 1. CÁC QUYỀN HẠN ĐẶC ĐẶC THÙ (CHỈ CẤP 1 CÓ QUYỀN)
*   **Xem Doanh thu & Chi phí Thực tế**: Xem thẻ **"Tổng Doanh thu POS"** và chỉ số **Food Cost %** lý thuyết/thực tế tại Dashboard. Toàn bộ các cấp dưới đều bị ẩn hoặc khóa thông tin tiền tệ này.
*   **Phê duyệt Yield Rate (Tỷ lệ thu hồi sơ chế)**: Quyết định cho phép thay đổi tỷ lệ thu hồi của nguyên vật liệu khi sơ chế (nhập từ bếp trưởng).
*   **Kiểm toán Hệ thống**: Truy cập nhật ký hoạt động bất biến (`audit_log`) để xem ai đã thay đổi số liệu, thời điểm thay đổi và dữ liệu trước/sau khi đổi.

---

## 2. QUY TRÌNH HÀNG NGÀY (Daily Workflow)

### Bước 1: Giám sát Sức khỏe Tài chính (Dashboard)
1.  Đăng nhập hệ thống bằng tài khoản Owner/CFO.
2.  Kiểm tra 4 chỉ số cốt lõi tại đầu trang Dashboard:
    *   **Tổng Doanh thu POS**: Doanh thu thuần của ngày hôm trước (hoặc khoảng thời gian được lọc) sau khi đã trừ chiết khấu.
    *   **Chi phí Tiêu hao (Cost)**: Tổng giá trị nguyên vật liệu tiêu hao lý thuyết cho các món đã bán trong ngày (tính theo công thức định mức món nhân với đơn giá vốn WAC hiện tại).
    *   **Giá trị Tồn kho Ước tính**: Giá trị của toàn bộ nguyên vật liệu hiện tại trong kho tính theo WAC.
    *   **Chênh lệch Kiểm kê (Variance)**: Tổng thiệt hại tài chính do sai lệch giữa số lượng đếm thực tế và tồn lý thuyết.
3.  *Hành động*: Nếu **Food Cost %** vượt quá ngưỡng mục tiêu (ví dụ >32% đối với nhà hàng Pháp), nhấp vào tab **Đối soát Song song & Yield** để xem nguyên liệu nào đang bị đội cost hoặc có hao hụt thực tế lớn.

### Bước 2: Duyệt đề xuất thay đổi Yield Rate sơ chế từ Bếp trưởng
Để tránh việc bếp trưởng tự ý tăng tỷ lệ hao hụt sơ chế (yield rate) nhằm che giấu việc làm mất mát hoặc thất thoát nguyên liệu, bếp trưởng chỉ có quyền **gửi đề xuất điều chỉnh**.
1.  Truy cập tab **Đối soát Song song & Yield**.
2.  Cuộn xuống phần **Đề xuất điều chỉnh Yield Rate**.
3.  Xem chi tiết đề xuất:
    *   Nguyên liệu (Ví dụ: Cá tuyết phi lê).
    *   Yield cũ (Ví dụ: 80% - tức hao hụt sơ chế 20%).
    *   Yield đề xuất mới (Ví dụ: 70% - tức hao hụt sơ chế tăng lên 30%, làm tăng chi phí vốn lý thuyết).
    *   Lý do bếp trưởng giải trình (Ví dụ: Lô hàng này cá nhỏ nhiều xương, tỷ lệ hao hụt tăng).
4.  *Hành động*: Bấm **"Phê duyệt"** (nếu lý do hợp lý) hoặc **"Từ chối"** (nếu cần bếp trưởng giải trình thêm). Hệ thống sẽ tự động cập nhật hệ số quy đổi công thức ngay khi được duyệt.

### Bước 3: Kiểm toán nhật ký hệ thống (Audit Log)
1.  Cuộn xuống cuối Dashboard hoặc truy cập phân hệ **Cài đặt & Audit Log**.
2.  Kiểm tra các hoạt động thủ công nhạy cảm:
    *   Ai đã thực hiện chốt WAC thủ công ngoài giờ quy định.
    *   Các bút toán điều chỉnh kiểm kê đột biến (điều chỉnh tăng/giảm tồn kho số lượng lớn).
    *   Ai đã phê duyệt các Waste Log (nhật ký hủy hỏng) có giá trị cao.
3.  *Lưu ý*: Mọi hành động ghi nhận trong sổ cái đều được gắn thẻ `actor_id` và lưu giữ vĩnh viễn, không thể xóa bỏ.

---

## 3. QUY TRÌNH HÀNG TUẦN / HÀNG THÁNG (Weekly/Monthly Workflow)

### 1. Đối soát Song song với Excel cũ (Chạy song song 4 tuần)
Trong giai đoạn chạy song song 4 tuần (Tuần 9-12):
1.  Cuối tuần, lấy báo cáo chênh lệch từ tab **Đối soát Song song**.
2.  So sánh cột **CRM Qty** và **Excel Qty**. Sai lệch phải tiến sát về **0.00** đối với các mã đã sửa đổi.
3.  *Hành động*: Chỉ khi tỷ lệ khớp đạt >98% trên toàn bộ các nhóm nguyên vật liệu chính, CFO mới ký quyết định ngắt hoàn toàn file Excel cũ và chuyển hẳn sang CRM.

### 2. Xem Báo cáo Hao hụt Thực tế (Wastage Analysis)
1.  Lọc báo cáo kiểm kê theo tháng.
2.  So sánh tổng số lượng nguyên liệu bị hủy trong `waste_logs` với chênh lệch kiểm kê `variance` thực tế.
3.  *Hành động*: Nếu lệch kiểm kê thực tế cao vượt trội so với Waste Log đã duyệt, điều đó có nghĩa là nhân viên đang không khai báo khi làm hỏng nguyên liệu hoặc có tình trạng thất thoát/uống trộm tại quầy Bar. CFO cần yêu cầu bếp và bar chấn chỉnh việc ghi chép Waste Log hàng ca.
