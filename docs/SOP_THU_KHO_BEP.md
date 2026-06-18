# QUY TRÌNH VẬN HÀNH CHUẨN (SOP) – THỦ KHO, BẾP TRƯỞNG & BẾP PHÓ
### (Phân hệ dành cho Cấp 3, 6, 7: Nhận hàng vật lý, Khai báo hủy hao, Non-Sale, Sản xuất Bán thành phẩm và Kiểm kho)

Quy trình này hướng dẫn Thủ kho, Bếp trưởng và Bếp phó thực hiện các nghiệp vụ ghi nhận nhập kho vật lý, báo hủy hao bếp, khai báo cơm nhân viên/thử món (Non-Sale), sản xuất Bán thành phẩm (BTP), và kiểm kho thực tế định kỳ.

---

## 1. THÔNG TIN ĐĂNG NHẬP & CÁCH THAY ĐỔI MẬT KHẨU

### 1.1. Thông tin đăng nhập mặc định
*   **Chế độ Thử nghiệm (Local Sandbox Mode)**:
    *   **Tài khoản (Email)**: `maisonvie.vn@gmail.com`
    *   **Mật khẩu**: `sandbox`
    *   **Quy trình đăng nhập nhanh**:
        *   Để vào vai trò **Quản lý / Thủ kho** (Cấp 7): Nhấp nút **"👨‍🍳 Chef / Manager / Thủ Kho"** (hệ thống tự gán quyền `restaurant_manager`).
        *   Để vào vai trò **Bếp phó / Kế toán phụ** (Cấp 6): Nhấp nút **"📊 SousChef / Kế toán"** (hệ thống tự gán quyền `senior_accountant`).
*   **Chế độ Vận hành Thực tế (Production Mode)**:
    *   **Tài khoản (Email)**: Email cá nhân được cấp phát (ví dụ: `chef@maisonvie.vn` hoặc `storekeeper@maisonvie.vn`).
    *   **Mật khẩu**: Do người dùng tự tạo hoặc quản trị viên hệ thống cấp phát qua Supabase Auth.

### 1.2. Hướng dẫn thay đổi mật khẩu
Mật khẩu của tài khoản Bếp và Thủ kho cần được bảo quản tốt để ngăn ngừa việc nhập sai lệch dữ liệu hủy hỏng hoặc sản xuất BTP ảo.
1.  Đăng nhập vào hệ thống bằng tài khoản của anh/chị.
2.  Quan sát thanh Header phía trên cùng của giao diện. Bên cạnh tên tài khoản hiển thị (ví dụ: **"Quản lý Nhà hàng"** hoặc **"Bếp phó"**), nhấp vào nút **"Đổi mật khẩu"** (dòng chữ màu vàng nhạt, có gạch chân).
3.  Hộp thoại (Modal) đổi mật khẩu sẽ hiện ra:
    *   Nhập mật khẩu mới của anh/chị vào ô **Mật khẩu mới**.
    *   Nhập chính xác lại mật khẩu đó vào ô **Xác nhận mật khẩu**.
4.  Bấm nút **"CẬP NHẬT MẬT KHẨU"**:
    *   *Trong môi trường Production*: Hệ thống sẽ kết nối trực tiếp đến Supabase Authentication để đổi mật khẩu chính thức.
    *   *Trong môi trường Sandbox*: Hệ thống giả lập quá trình đổi mật khẩu thành công và tự động đóng hộp thoại sau 2 giây.

---

## 2. QUY TRÌNH HÀNG NGÀY (Daily Workflow)

### Nghiệp vụ 1: Nhận hàng vật lý tại cửa kho (Thủ kho Cấp 7 / Quản lý)
Khi nhà cung cấp giao nguyên vật liệu đến nhà hàng:
1.  Mở máy tính bảng hoặc máy tính, truy cập phân hệ **Nhận hàng (Goods Receipt)**.
2.  Bấm tạo mới Phiếu nhập kho nháp (GRN) từ đơn PO đã đặt trước.
3.  Thực hiện cân, đo, đếm số lượng nguyên liệu thực tế giao tới.
4.  Điền số lượng thực tế nhận vào cột **Số lượng nhận (Qty Received)**.
5.  *Hạn dùng & Quản lý Lô*: Nhập ngày hết hạn (`expiry_date`) và mã lô (`lot_code`) đối với hàng hóa cần theo dõi hạn (ví dụ: đồ tươi sống, sữa, bơ). Hệ thống sẽ trừ kho theo nguyên tắc **FEFO (Hạn gần hết trước, xuất trước)**.
6.  *Nếu phát hiện hàng hỏng/thiếu*: Ghi chú rõ lý do vào ô ghi chú dòng hàng (Ví dụ: *"Cà chua bị dập 2kg, trả lại NCC"*). Chỉ nhập số lượng thực tế giữ lại vào hệ thống.
7.  Bấm **"Gửi duyệt" (Submit to Pending)**. Phiếu sẽ được chuyển về cho Kế toán kho (Cấp 4) để đối chiếu hóa đơn công nợ và duyệt tăng kho chính thức.

### Nghiệp vụ 2: Khai báo Hủy hỏng / Waste Log (Bếp phó Cấp 6 / Bếp trưởng Cấp 3)
Mọi nguyên vật liệu bị cháy hỏng trong quá trình chế biến hoặc hư hỏng do thiết bị lưu trữ phải được khai báo ngay lập tức:
1.  Truy cập tab **Kiểm kho & Tính Variance** -> cuộn xuống phần **Nhật ký hủy hỏng (Waste Logs)**.
2.  Bấm **"Tạo Waste Log"** và điền:
    *   Nguyên vật liệu bị hỏng (Ví dụ: *Thịt bò Ribeye*).
    *   Số lượng bị hỏng (Ví dụ: *1.5 kg*).
    *   Lý do cụ thể (Ví dụ: *Cháy khi nướng Wellington*).
3.  Bấm **"Gửi yêu cầu"**.
    *   *Quy trình duyệt tự động*:
        *   Nếu giá trị hao hụt nhỏ (< 200.000đ): Hệ thống tự động duyệt để trừ kho.
        *   Nếu giá trị hao hụt lớn: Yêu cầu chuyển lên Quản lý nhà hàng (Cấp 2) hoặc CFO duyệt. Số liệu chỉ chính thức ghi nhận giảm kho sau khi được duyệt.

### Nghiệp vụ 3: Khai báo Tiêu thụ ngoài bán hàng (Non-Sale Consumption)
Sử dụng khi xuất nguyên liệu làm cơm nhân viên (Staff meal), thử nghiệm món mới (R&D), tiếp khách (VIP Comp) hoặc đào tạo (Training) nhằm tránh làm méo mó Food Cost %:
1.  Truy cập phần **Tiêu thụ ngoài bán hàng (Non-Sale)**.
2.  Chọn loại tiêu thụ (Ví dụ: `STAFF_MEAL` hoặc `R&D`).
3.  Nhập tên nguyên liệu và số lượng sử dụng thực tế.
4.  Bấm **"Lưu ghi nhận"**. Hệ thống sẽ tạo giao dịch kho loại `OUT`, `source = 'NON_SALE'`. Số lượng này sẽ trừ kho lý thuyết vào cuối ngày nhưng **không tính vào doanh thu món** giúp Food cost được đối soát chuẩn xác.

### Nghiệp vụ 4: Sản xuất Bán thành phẩm - BTP / Mise en place (Bếp trưởng / Bếp phó)
Nhà hàng fine-dining nấu nước sốt nền, demi-glace, bột bánh... theo mẻ rồi dùng dần làm nguyên liệu cho món ăn khác.
1.  Truy cập tab **Bán thành phẩm & Mẻ sản xuất**.
2.  Tạo **Lệnh sản xuất BTP (Production Order)**:
    *   Chọn mặt hàng đầu ra BTP (Ví dụ: *Nước dùng gà - Fond de volaille / ING-081*).
    *   Nhập sản lượng mẻ thực tế thu được (Ví dụ: *10 Lít*).
3.  Hệ thống tự động hiển thị định mức các nguyên liệu đầu vào cần có (ví dụ: thịt gà thô, rau Đà Lạt, húng tây) để làm ra 10L nước dùng.
4.  Bấm **"Xác nhận hoàn thành"**:
    *   Hệ thống tự động thực hiện bút toán xuất (`OUT`) các nguyên liệu đầu vào khỏi kho Bếp.
    *   Đồng thời, ghi nhận nhập kho (`IN`) lượng BTP đầu ra vào kho Bếp với giá trị vốn bằng tổng giá trị các nguyên liệu đầu vào chia cho sản lượng thực tế (cập nhật WAC của BTP). BTP này sẽ có hạn dùng và được quản lý theo lô FEFO.

---

## 3. QUY TRÌNH KIỂM KHO ĐỊNH KỲ (Weekly/Monthly Stocktake)
1.  Bếp trưởng/Thủ kho truy cập tab **Kiểm kho & Tính Variance**.
2.  Bấm **"Bắt đầu kiểm kê" (Start Stocktake)**. Hệ thống sẽ thực hiện lệnh **Freeze Count (Đóng băng tồn kho)**:
    *   *Lưu ý*: Lệnh này chụp lại một bản snapshot số lượng tồn lý thuyết tại thời điểm đó (`system_qty`). Mọi giao dịch POS bán hàng hay nhập xuất kho đang chạy song song sau đó sẽ không làm ảnh hưởng đến số liệu trên phiếu đếm.
3.  In phiếu kiểm kho hoặc cầm máy tính bảng đi cân, đếm thực tế tại bếp.
4.  Nhập số lượng đếm thực tế của từng nguyên liệu vào cột **Tồn thực tế (Physical Qty)**.
5.  Bấm **"Ghi nhận và Tính Variance"**.
6.  Hệ thống so sánh tồn thực tế và tồn lý thuyết đóng băng để tính chênh lệch:
    *   Nếu sai lệch nằm trong ngưỡng cho phép (`tolerance_percent` - ví dụ: gia vị <10%): Hiển thị màu xanh lá.
    *   Nếu sai lệch vượt ngưỡng: Dòng hàng báo đỏ kèm cảnh báo. Bếp trưởng phải nhập lý do giải trình cụ thể cho chênh lệch đó.
7.  Bấm **"Gửi duyệt Phiếu Kiểm kê"** chuyển lên CFO/Kế toán duyệt để chính thức điều chỉnh số liệu sổ cái kho về số đếm thực tế.

---

## 4. QUY TRÌNH ĐỀ XUẤT ĐIỀU CHỈNH ĐỊNH MỨC SƠ CHẾ (Yield Rate)
Khi phát hiện tỷ lệ hao hụt thực tế của nguyên liệu thô khi sơ chế khác biệt so với định mức hệ thống (Ví dụ: Cá hồi nhập về nhỏ hơn nên hao hụt lọc xương nhiều hơn):
1.  Bếp trưởng truy cập tab **Đối soát Song song & Yield**.
2.  Tìm nguyên liệu cần điều chỉnh (Ví dụ: *Cá hồi Na Uy phi lê*).
3.  Nhập tỷ lệ thu hồi sơ chế thực tế mới (Ví dụ: nhập *75%* thay vì *80%*).
4.  Điền lý do cụ thể (Ví dụ: *"Cá hồi đợt này size nhỏ, hao hụt đầu xương nhiều hơn"*).
5.  Bấm **"Gửi đề xuất điều chỉnh"** và chờ CFO phê duyệt để định mức mới chính thức có hiệu lực quy đổi công thức.
