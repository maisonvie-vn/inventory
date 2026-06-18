# QUY TRÌNH VẬN HÀNH CHUẨN (SOP) – CFO & OWNER / ADMIN
### (Phân hệ dành cho Cấp 1: Giám sát tài chính, duyệt định mức, quản trị cài đặt tài chính và kiểm toán)

Quy trình này hướng dẫn CFO, Owner hoặc người có quyền Admin tối cao sử dụng hệ thống CRM/ERP Inventory để quản trị tài chính kho, duyệt đề xuất thay đổi định mức sơ chế, cấu hình tham số hệ thống và kiểm tra tính toàn vẹn của dữ liệu qua nhật ký kiểm toán.

---

## 1. THÔNG TIN ĐĂNG NHẬP & CÁCH THAY ĐỔI MẬT KHẨU

### 1.1. Thông tin đăng nhập mặc định
*   **Chế độ Thử nghiệm (Local Sandbox Mode)**:
    *   **Tài khoản (Email)**: `ceo@maisonvie.vn`
    *   **Mật khẩu**: `sandbox`
    *   **Quy trình đăng nhập nhanh**: Tại màn hình đăng nhập chính, nhấp chọn nút **"💼 Owner / CFO / Admin"** ở phần Sandbox Mode. Hệ thống sẽ tự điền tài khoản, mật khẩu và gán quyền `admin` tự động.
*   **Chế độ Vận hành Thực tế (Production Mode)**:
    *   **Tài khoản (Email)**: Email cá nhân được phân quyền hành chính (ví dụ: `cfo@maisonvie.vn`).
    *   **Mật khẩu**: Do người dùng tự tạo hoặc quản trị viên hệ thống cấp phát qua Supabase Auth.

### 1.2. Hướng dẫn thay đổi mật khẩu
Mật khẩu của tài khoản Admin/CFO cần được bảo mật tối đa vì tài khoản này nắm giữ quyền xem doanh thu tài chính và điều chỉnh hệ thống.
1.  Đăng nhập vào hệ thống bằng tài khoản của anh/chị.
2.  Quan sát thanh Header phía trên cùng của giao diện. Bên cạnh tên tài khoản hiển thị (**"Quản trị viên (CFO)"**), nhấp vào nút **"Đổi mật khẩu"** (dòng chữ màu vàng nhạt, có gạch chân).
3.  Hộp thoại (Modal) đổi mật khẩu sẽ hiện ra:
    *   Nhập mật khẩu mới của anh/chị vào ô **Mật khẩu mới**.
    *   Nhập chính xác lại mật khẩu đó vào ô **Xác nhận mật khẩu**.
4.  Bấm nút **"CẬP NHẬT MẬT KHẨU"**:
    *   *Trong môi trường Production*: Hệ thống sẽ kết nối trực tiếp đến Supabase Authentication để thay đổi mật khẩu và cập nhật vào hệ thống bảo mật.
    *   *Trong môi trường Sandbox*: Hệ thống giả lập quá trình đổi mật khẩu thành công và tự động đóng hộp thoại sau 2 giây.

---

## 2. CÁC QUYỀN HẠN ĐẶC THÙ (CHỈ CẤP 1 CÓ QUYỀN)
*   **Xem Doanh thu & Chi phí Thực tế**: Xem thẻ **"Tổng Doanh thu POS"** và chỉ số **Food Cost %** lý thuyết/thực tế tại Dashboard. Toàn bộ các cấp dưới đều bị ẩn hoặc khóa thông tin tiền tệ này.
*   **Phê duyệt Yield Rate (Tỷ lệ thu hồi sơ chế)**: Quyết định cho phép thay đổi tỷ lệ thu hồi của nguyên vật liệu khi sơ chế (nhập từ bếp trưởng).
*   **Quản lý Phân vùng Cấu hình (Settings Module)**: Cấu hình các tham số hệ thống chia làm 3 vùng (Vô hại, Vận hành, Tài chính). Các cài đặt tài chính được lưu trữ lịch sử theo ngày hiệu lực (Effective-dated).
*   **Kiểm toán Hệ thống**: Truy cập nhật ký hoạt động bất biến (`audit_log`) để xem ai đã thay đổi số liệu, thời điểm thay đổi và dữ liệu trước/sau khi đổi.

---

## 3. QUY TRÌNH HÀNG NGÀY (Daily Workflow)

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
    *   *Nguyên lý tính*: Giá vốn thực tế của nguyên liệu dùng = $\text{WAC} \div \text{Yield \%}$. Ví dụ: WAC cá tuyết là 500,000đ/kg. Nếu yield là 80%, giá vốn thực tế là 625,000đ/kg. Nếu yield giảm xuống 70%, giá vốn thực tế tăng lên 714,285đ/kg.

### Bước 3: Duyệt các PO thủ công có giá trị lớn vượt hạn mức
Hệ thống kiểm soát chặt chẽ việc đặt PO thủ công để ngăn ngừa thất thoát ngân sách.
1.  Nhận thông báo hoặc truy cập phân hệ **Đơn đặt hàng (Purchase Orders)**.
2.  Lọc các PO có trạng thái `PENDING_APPROVAL`.
3.  Kiểm tra tổng giá trị đơn hàng. Nếu PO vượt quá **Ngưỡng duyệt PO** được cấu hình trong bảng cấu hình tài chính (ví dụ: > 20,000,000 VND), hệ thống sẽ bắt buộc phải có chữ ký số hoặc phê duyệt của CFO mới có thể chuyển sang trạng thái `APPROVED` và cho phép xuất/gửi NCC.
4.  Đối với các mặt hàng có số lượng đặt cao bất thường (ngày lưu kho - days-of-cover vượt quá 14 ngày), yêu cầu xem giải trình của kế toán/bếp (ví dụ: mua dự phòng cho tiệc cưới, hoặc nhà cung cấp giảm giá sâu). Bấm **"Phê duyệt"** để cho đi tiếp hoặc **"Từ chối"** để hủy PO.

### Bước 4: Kiểm toán nhật ký hệ thống (Audit Log) & Quản trị Cấu hình
1.  Truy cập phân hệ **Cài đặt & Audit Log**.
2.  Kiểm tra các hoạt động nhạy cảm:
    *   Thay đổi mã nguyên liệu (nguyên lý v9.6: `ingredients.id` dùng UUID cố định, cột `code` có thể sửa đổi được nhưng mỗi lần sửa đổi sẽ ghi audit).
    *   Sửa đổi cài đặt tài chính tại bảng `app_settings` (VAT, phí dịch vụ, ngưỡng PO, buffer hao hụt). Cài đặt tài chính được lưu lịch sử tại bảng `app_settings_history` để bảo vệ các bút toán trong quá khứ không bị tính sai lệch.
    *   Các bút toán điều chỉnh kiểm kê đột biến (điều chỉnh tăng/giảm tồn kho số lượng lớn).
    *   Phê duyệt các Waste Log (nhật ký hủy hỏng) có giá trị cao.
3.  *Lưu ý*: Mọi hành động ghi nhận trong sổ cái đều được gắn thẻ `actor_id` và lưu giữ vĩnh viễn, không thể xóa bỏ.

---

## 4. QUY TRÌNH HÀNG TUẦN / HÀNG THÁNG (Weekly/Monthly Workflow)

### 1. Đối soát Song song với Excel cũ (Chạy song song 4 tuần)
Trong giai đoạn chạy song song 4 tuần (Tuần 9-12):
1.  Cuối tuần, lấy báo cáo chênh lệch từ tab **Đối soát Song song**.
2.  So sánh cột **CRM Qty** và **Excel Qty**. Sai lệch phải tiến sát về **0.00** đối với các mã đã sửa đổi.
3.  *Hành động*: Chỉ khi tỷ lệ khớp đạt >98% trên toàn bộ các nhóm nguyên vật liệu chính, CFO mới ký quyết định ngắt hoàn toàn file Excel cũ và chuyển hẳn sang CRM.

### 2. Xem Báo cáo Hao hụt Thực tế (Wastage Analysis)
1.  Lọc báo cáo kiểm kê theo tháng.
2.  So sánh tổng số lượng nguyên liệu bị hủy trong `waste_logs` với chênh lệch kiểm kê `variance` thực tế.
3.  *Hành động*: Nếu lệch kiểm kê thực tế cao vượt trội so với Waste Log đã duyệt, điều đó có nghĩa là nhân viên đang không khai báo khi làm hỏng nguyên liệu hoặc có tình trạng thất thoát/uống trộm tại quầy Bar. CFO cần yêu cầu bếp và bar chấn chỉnh việc ghi chép Waste Log hàng ca.

### 3. Phê duyệt Báo cáo Kiểm kê Toàn phần (Full Month-End Stocktake)
1.  Vào ngày cuối tháng, sau khi bếp và bar hoàn thành đếm tồn kho vật lý và gửi phiếu kiểm kê (`stocktakes` trạng thái `REVIEW`).
2.  Xem xét bảng chênh lệch (Variance Report) tổng hợp của toàn bộ nhà hàng.
3.  Duyệt các khoản chênh lệch mất mát lớn có lý do giải trình đi kèm.
4.  Bấm **"Phê duyệt & Post ghi sổ"** để chính thức điều chỉnh sổ cái kho về số thực tế cuối tháng, đóng kỳ kế toán hiện tại. Sau khi Post, hệ thống sẽ freeze và không cho phép chỉnh sửa bất kỳ bút toán nào trong kỳ đó nữa.

