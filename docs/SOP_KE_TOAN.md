# QUY TRÌNH VẬN HÀNH CHUẨN (SOP) – KẾ TOÁN KHO CẤP CAO
### (Phân hệ dành cho Cấp 4: Nhập kho, Đối soát 3-Way Match, Map POS, duyệt Auto-PO và PPV)

Quy trình này hướng dẫn Kế toán kho cấp cao quản lý quy trình nhập hàng, đối soát công nợ nhà cung cấp, ánh xạ món ăn POS và phê duyệt đơn đặt hàng tự động.

---

## 1. THÔNG TIN ĐĂNG NHẬP & CÁCH THAY ĐỔI MẬT KHẨU

### 1.1. Thông tin đăng nhập mặc định
*   **Chế độ Thử nghiệm (Local Sandbox Mode)**:
    *   **Tài khoản (Email)**: `maisonvie.vn@gmail.com`
    *   **Mật khẩu**: `sandbox`
    *   **Quy trình đăng nhập nhanh**: Tại màn hình đăng nhập chính, nhấp chọn nút **"📊 SousChef / Kế toán"** ở phần Sandbox Mode. Hệ thống sẽ tự điền tài khoản, mật khẩu và gán quyền `senior_accountant` tự động.
*   **Chế độ Vận hành Thực tế (Production Mode)**:
    *   **Tài khoản (Email)**: Email cá nhân được phân quyền kế toán (ví dụ: `ketoankho@maisonvie.vn`).
    *   **Mật khẩu**: Do người dùng tự tạo hoặc quản trị viên hệ thống cấp phát qua Supabase Auth.

### 1.2. Hướng dẫn thay đổi mật khẩu
Mật khẩu của tài khoản Kế toán kho cần được bảo mật và thay đổi định kỳ nhằm tránh việc can thiệp trái phép vào giá vốn WAC và số liệu PO.
1.  Đăng nhập vào hệ thống bằng tài khoản của anh/chị.
2.  Quan sát thanh Header phía trên cùng của giao diện. Bên cạnh tên tài khoản hiển thị (**"Kế toán kho cấp cao"**), nhấp vào nút **"Đổi mật khẩu"** (dòng chữ màu vàng nhạt, có gạch chân).
3.  Hộp thoại (Modal) đổi mật khẩu sẽ hiện ra:
    *   Nhập mật khẩu mới của anh/chị vào ô **Mật khẩu mới**.
    *   Nhập chính xác lại mật khẩu đó vào ô **Xác nhận mật khẩu**.
4.  Bấm nút **"CẬP NHẬT MẬT KHẨU"**:
    *   *Trong môi trường Production*: Hệ thống sẽ kết nối trực tiếp đến Supabase Authentication để thay đổi mật khẩu và cập nhật vào hệ thống bảo mật.
    *   *Trong môi trường Sandbox*: Hệ thống giả lập quá trình đổi mật khẩu thành công và tự động đóng hộp thoại sau 2 giây.

---

## 2. CÁC QUYỀN HẠN ĐẶC THÙ (CHỈ CẤP 4 CÓ QUYỀN)
*   **Duyệt Goods Receipt & Tính WAC**: Chốt đơn giá nhập kho, phân bổ chi phí Landed Cost (thuế, cước) để tự động cập nhật WAC.
*   **Duyệt Auto-PO**: Điều chỉnh số lượng và phê duyệt các đơn đặt hàng tự động do hệ thống đề xuất để gửi cho nhà cung cấp.
*   **Quản lý Danh mục Mapping POS & Bảng giá NCC**: Xác nhận và cập nhật bảng ánh xạ vĩnh viễn giữa mã POS của nhà hàng và mã Recipe định mức của hệ thống. Quản lý bảng giá nhà cung cấp (`supplier_prices`) có hiệu lực ngày.

---

## 3. QUY TRÌNH HÀNG NGÀY (Daily Workflow)

### Bước 1: Đối soát Nhập kho (3-Way Match) & Landed Cost
Khi có hàng giao tới nhà hàng kèm theo Hóa đơn/Phiếu giao hàng từ nhà cung cấp:
1.  Nhận thông tin nhập kho nháp (do Thủ kho Cấp 7 nhập ở trạng thái `pending` khi nhận hàng thô ở cửa kho).
2.  Thực hiện đối soát **3-Way Match (Đơn đặt hàng PO ↔ Phiếu nhập kho GRN ↔ Hóa đơn mua hàng)**:
    *   **Khớp Số lượng**: Số lượng thực nhận trên GRN phải khớp với số lượng trên đơn PO đã đặt.
    *   **Khớp Đơn giá**: Giá trên hóa đơn tài chính phải khớp với đơn giá đã thỏa thuận trên PO.
3.  *Xử lý lệch*:
    *   Nếu lệch số lượng hoặc giá: Hệ thống chuyển trạng thái đơn hàng thành `VARIANCE`. Kế toán kho phải liên hệ nhà cung cấp/bếp để xác minh. Số liệu kho sẽ **không được ghi tăng** và WAC sẽ **không cập nhật** cho đến khi kế toán xử lý xong và bấm **"APPROVED"**.
    *   Nếu khớp hoàn toàn: Nhập phân bổ **Landed Cost** (thuế nhập khẩu `duty`, phí vận chuyển `freight` phân bổ cho từng dòng hàng dựa trên giá trị đơn hàng), sau đó bấm duyệt **"APPROVED"**.
4.  *Ghi sổ & Tính WAC*: Sau khi bấm duyệt, hệ thống tự động ghi nhận giao dịch `IMPORT` vào sổ cái và chạy hàm tính WAC mới.
    *   *Bảo vệ tồn âm*: Nếu trước khi nhập kho, tồn kho lý thuyết của nguyên liệu bị âm (do bán trước nhập sau), hệ thống tự động coi tồn kho hiện tại bằng `0` để tránh làm méo mó đơn giá vốn WAC mới.

### Bước 2: Import Doanh số POS cuối ngày & Đồng bộ Mapping
1.  Truy cập tab **Doanh số & POS Import**.
2.  Chọn file Excel báo cáo doanh số POS trong ngày (tải từ phần mềm POS của nhà hàng).
3.  Hệ thống sẽ tự động đọc file Excel và đối chiếu các trạng thái của dòng giao dịch:
    *   **`MAPPED` (Đã ánh xạ)**: Các món ăn đã được cấu hình định mức trong hệ thống trước đó. Tự động thông qua 100%.
    *   **`UNMAPPED` (Chưa ánh xạ)**: Các món ăn mới tinh vừa được đưa vào menu nhà hàng và chưa có định mức tương ứng trên CRM. Hệ thống sẽ hiển thị cảnh báo màu vàng và sử dụng thuật toán Levenshtein so khớp từ gần đúng để đưa ra gợi ý (Ví dụ: *"Angus Ribeye Wellington - Gợi ý 92% khớp với R-011"*).
4.  *Xử lý UNMAPPED*:
    *   Kế toán kho chọn Recipe chính xác cho mã mới đó và bấm **"Xác nhận ánh xạ"** (trạng thái chuyển sang **`RESOLVED`**). Bảng `pos_alias_map` sẽ tự động ghi đè vĩnh viễn để lần sau hệ thống tự nhận diện.
    *   Nếu món ăn đó không có định mức cấu thành kho (ví dụ: phí dịch vụ, set menu tổng, khăn ướt mua ngoài), chọn **`NO_STOCK_IMPACT`** để hệ thống bỏ qua và không trừ kho món này.
5.  *Chốt ghi sổ*: Sau khi kiểm tra toàn bộ danh sách món khớp hoàn toàn (không còn dòng nào ở trạng thái `UNMAPPED`), kế toán chủ động bấm **"Chốt ghi sổ POS"** để kích hoạt job trừ kho định mức (không sử dụng cơ chế tự động đếm ngược 30 giây để tránh lỗi ghi sổ khi số liệu chưa khớp).

### Bước 3: Xem và duyệt Đề xuất Auto-PO cuối ngày
Hệ thống chạy job tự động tính toán nhu cầu đặt hàng vào lúc **22:40** dựa trên tồn lý thuyết và lịch sử tiêu thụ 14 ngày.
1.  Truy cập phân hệ **Đơn đặt hàng (Purchase Orders)**.
2.  Xem các PO ở trạng thái nháp (Draft PO) được gom theo từng Nhà cung cấp ưu tiên.
3.  Kiểm tra số lượng đặt hàng đề xuất:
    *   **Days of Cover (Ngày dự trữ)**: Kiểm tra hệ số dự trữ tồn kho đề xuất cho từng mặt hàng (ví dụ: còn đủ dùng trong bao nhiêu ngày).
    *   **Net Open PO**: Số lượng hàng đang trên đường về từ các PO trước chưa giao nhận hết. Hệ thống sẽ tự động trừ đi số này để tránh đặt trùng lặp hàng hóa.
    *   Hệ thống tự động làm tròn lên theo kích thước đóng gói của nhà cung cấp (`pack_size` - ví dụ: làm tròn lên thùng 24 chai thay vì đặt lẻ chai) và tôn trọng số lượng đặt tối thiểu (`moq`).
4.  *Hành động*: Kế toán có thể chỉnh sửa trực tiếp số lượng nếu có sự kiện đặc biệt (ví dụ: nhà hàng có tiệc cưới lớn vào cuối tuần cần đặt thêm).
    *   Nếu tổng giá trị đơn hàng vượt quá ngưỡng tài chính quy định, bấm **"Gửi duyệt"** để chuyển cho CFO duyệt.
    *   Nếu trong hạn mức, bấm **"Phê duyệt & Xuất PO"**. Hệ thống sẽ xuất ra file PDF/Excel PO sạch để kế toán gửi cho nhà cung cấp trước giờ cutoff time.

---

## 4. QUẢN LÝ BẢNG GIÁ & CẢNH BÁO BIẾN ĐỘNG GIÁ MUA (PPV)
Kế toán kho cần theo dõi sát sao biến động giá mua từ các nhà cung cấp nhằm bảo vệ biên lợi nhuận của nhà hàng:
1.  **Quản lý giá NCC**: Cập nhật giá mới vào bảng `supplier_prices` khi có thông báo thay đổi giá từ NCC. Các giá trị này có thuộc tính `valid_from` và `valid_to` để quản lý theo thời gian.
2.  **Purchase Price Variance (PPV - Biến động giá mua)**: Khi kế toán nhập phiếu GRN, hệ thống sẽ so sánh đơn giá nhập thực tế trên GRN dòng hàng với giá thỏa thuận trong bảng `supplier_prices`.
3.  *Hành động*: Nếu phát hiện chênh lệch đơn giá (PPV báo đỏ, vượt ngưỡng cấu hình ví dụ >5%), kế toán kho phải:
    *   Liên hệ nhà cung cấp yêu cầu giải trình về giá (do biến động thị trường hay tính nhầm hóa đơn).
    *   Báo cáo ngay cho CFO/Owner nếu đây là xu hướng tăng giá dài hạn để ban quản lý xem xét rà soát điều chỉnh giá bán món ăn trên menu.

