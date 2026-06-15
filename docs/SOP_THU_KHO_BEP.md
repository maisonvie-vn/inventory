# QUY TRÌNH VẬN HÀNH CHUẨN (SOP) – THỦ KHO, BẾP TRƯỞNG & BẾP PHÓ
### (Phân hệ dành cho Cấp 3, 6, 7: Nhận hàng vật lý, Khai báo hủy hao, Kiểm kho và Kiểm bar bằng cân)

Quy trình này hướng dẫn Thủ kho, Bếp trưởng và Bếp phó thực hiện các nghiệp vụ ghi nhận nhập kho vật lý, báo hủy hao bếp, khai báo cơm nhân viên, và kiểm kho thực tế định kỳ.

---

## 1. QUY TRÌNH HÀNG NGÀY (Daily Workflow)

### Nghiệp vụ 1: Nhận hàng tại cửa kho (Thành viên: Thủ kho Cấp 7)
Khi nhà cung cấp giao nguyên vật liệu đến nhà hàng:
1.  Mở máy tính bảng/máy tính, truy cập phân hệ **Nhận hàng (Goods Receipt)**.
2.  Bấm tạo mới Phiếu nhập kho nháp (GRN) từ đơn PO đã đặt trước.
3.  Thực hiện cân, đo, đếm số lượng nguyên liệu thực tế giao tới.
4.  Điền số lượng thực tế nhận vào cột **Số lượng nhận (Qty Received)**.
5.  *Nếu phát hiện hàng hỏng/thiếu*: Ghi chú rõ lý do vào ô ghi chú dòng hàng (Ví dụ: *"Cà chua bị dập 2kg, trả lại NCC"*). Chỉ nhập số lượng thực tế giữ lại vào hệ thống.
6.  Bấm **"Gửi duyệt" (Submit to Pending)**. Phiếu sẽ được chuyển về cho Kế toán kho (Cấp 4) để đối chiếu hóa đơn công nợ và duyệt tăng kho chính thức.

### Nghiệp vụ 2: Khai báo Hủy hỏng / Waste Log (Thành viên: Bếp phó Cấp 6 / Bếp trưởng Cấp 3)
Mọi nguyên vật liệu bị cháy hỏng trong quá trình chế biến hoặc hư hỏng do thiết bị lưu trữ phải được khai báo ngay lập tức:
1.  Truy cập tab **Kiểm kho & Tính Variance** -> cuộn xuống phần **Nhật ký hủy hỏng (Waste Logs)**.
2.  Bấm **"Tạo Waste Log"** và điền:
    *   Nguyên vật liệu bị hỏng (Ví dụ: *Thịt bò Ribeye*).
    *   Số lượng bị hỏng (Ví dụ: *1.5 kg*).
    *   Lý do cụ thể (Ví dụ: *Trâu Việt Nam bị cháy khi nướng Wellington*).
3.  Bấm **"Gửi yêu cầu"**.
    *   *Quy trình duyệt tự động*:
        *   Nếu giá trị hao hụt nhỏ (< 200.000đ): Hệ thống tự động duyệt để trừ kho.
        *   Nếu giá trị hao hụt lớn: Yêu cầu chuyển lên Quản lý nhà hàng (Cấp 2) duyệt. Số liệu chỉ chính thức ghi nhận giảm kho sau khi được duyệt.

### Nghiệp vụ 3: Khai báo Tiêu thụ ngoài bán hàng (Non-Sale Consumption)
Sử dụng khi xuất nguyên liệu làm cơm nhân viên (Staff meal), thử nghiệm món mới (R&D), tiếp khách (VIP Comp) hoặc đào tạo (Training):
1.  Truy cập phần **Tiêu thụ ngoài bán hàng (Non-Sale)**.
2.  Chọn loại tiêu thụ (Ví dụ: `STAFF_MEAL` hoặc `R&D`).
3.  Nhập tên nguyên liệu và số lượng sử dụng thực tế.
4.  Bấm **"Lưu ghi nhận"** để hệ thống trừ kho lý thuyết tương ứng vào cuối ngày lúc 22:30.

---

## 2. QUY TRÌNH KIỂM KHO ĐỊNH KỲ (Weekly/Monthly Stocktake)

### 1. Kiểm kho Bếp (Mỗi tối chủ nhật hoặc cuối tháng)
1.  Bếp trưởng/Thủ kho in phiếu kiểm kho hoặc cầm máy tính bảng đi cân thực tế tại bếp.
2.  Truy cập tab **Kiểm kho & Tính Variance**.
3.  Nhập số lượng đếm thực tế của từng nguyên liệu vào cột **Tồn thực tế (Physical Qty)**.
4.  Bấm **"Ghi nhận và Tính Variance"**.
5.  Hệ thống sẽ so sánh với tồn lý thuyết để tính chênh lệch:
    *   Nếu sai lệch nằm trong ngưỡng cho phép (`tolerance_percent`): Dòng hàng hiển thị màu xanh lá (Khớp hoặc lệch nhỏ).
    *   Nếu sai lệch vượt ngưỡng: Dòng hàng báo đỏ kèm cảnh báo. Bếp trưởng phải giải trình lý do sai lệch trước khi kế toán chốt khóa sổ.

### 2. Kiểm soát Bar bằng Cân điện tử (Dành cho Tổ trưởng Bar / Bếp trưởng)
Để kiểm soát chính xác lượng rượu còn lại trong các chai đã mở tại quầy Bar (tránh việc ước lượng bằng mắt không chính xác):
1.  Đặt chai rượu đang mở lên cân điện tử, lấy số Gram thực tế (Ví dụ: chai rượu còn một nửa nặng *780g*).
2.  Tại giao diện kiểm kho của CRM, nhập số **780** vào cột trọng lượng thực tế của mã rượu đó.
3.  Hệ thống sẽ tự động trừ đi trọng lượng vỏ chai rỗng (`tare_weight_grams` được khai báo trong danh mục nguyên liệu, ví dụ vỏ chai nặng *350g*) để tính ra lượng rượu còn lại bằng ML:
    $$\text{Dung tích rượu thực tế (ML)} = \text{780g} - \text{350g} = \text{430 ML}$$
4.  Hệ thống tự động quy đổi ML này về đơn vị tồn kho tiêu chuẩn (`BOTTLE`) để đối chiếu với tồn lý thuyết của Bar, tính toán chính xác sai lệch rót rượu (**Pour Variance**).

---

## 3. QUY TRÌNH ĐỀ XUẤT ĐIỀU CHỈNH ĐỊNH MỨC SƠ CHẾ (Yield Rate)
Khi phát hiện tỷ lệ hao hụt thực tế của nguyên liệu thô khi sơ chế khác biệt so với định mức hệ thống:
1.  Bếp trưởng truy cập tab **Đối soát Song song & Yield**.
2.  Tìm nguyên liệu cần điều chỉnh (Ví dụ: *Cá hồi Na Uy phi lê*).
3.  Nhập tỷ lệ thu hồi sơ chế thực tế mới (Ví dụ: nhập *75%* thay vì *80%*).
4.  Điền lý do cụ thể (Ví dụ: *"Cá hồi đợt này size nhỏ, hao hụt đầu xương nhiều hơn"*).
5.  Bấm **"Gửi đề xuất điều chỉnh"** và chờ CFO (Cấp 1) phê duyệt để định mức mới chính thức có hiệu lực.
