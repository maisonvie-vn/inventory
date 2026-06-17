# QUY TRÌNH VẬN HÀNH CHUẨN (SOP) – NHÂN VIÊN QUẦY BAR / BARTENDER
### (Phân hệ dành cho Cấp 5: Kiểm kho Bar bằng cân, Đóng/Mở ca và Khai báo hao hụt)

Quy trình này hướng dẫn Bartender và Tổ trưởng quầy Bar thực hiện các công việc kiểm kho đầu/cuối ca bằng cân điện tử, khai báo hao hụt vỡ hỏng và tiếp khách bằng PIN cá nhân trên Máy tính bảng chung tại quầy Bar.

---

## 1. CÁC QUYỀN HẠN & NGUYÊN TẮC ĐẶC THÙ (QUẦY BAR)
*   **Không xem thông tin giá trị tiền**: Toàn bộ thông tin giá vốn (WAC), doanh thu quầy Bar và chi phí tài chính đều bị ẩn khỏi tài khoản Bar. Nhân viên Bar chỉ tập trung vào số lượng vật lý.
*   **Mã PIN cá nhân trên thiết bị dùng chung**: Quầy bar sử dụng chung một máy tính bảng (tablet). Mọi thao tác nhập cân, báo hủy hỏng bắt buộc phải nhập **mã PIN cá nhân** để ghi vết chịu trách nhiệm (ai trực ca nào, cân sai lệch ca đó).
*   **Lọc dữ liệu cô lập**: Tài khoản Bar khi đăng nhập chỉ thấy các nguyên vật liệu thuộc phạm vi quầy Bar (rượu mạnh, rượu vang, bia, nước ngọt, syrup, hoa quả trang trí pha chế).

---

## 2. QUY TRÌNH HÀNG NGÀY (Daily Workflow)

### Bước 1: Mở ca trực (Start of Shift)
1.  Đầu ca, Bartender đăng nhập vào máy tính bảng quầy Bar bằng mã PIN cá nhân.
2.  Bấm vào nút **Mở ca trực** (`shift = 'OPEN'`).
3.  Tiến hành đếm và kiểm kê:
    *   **Chai nguyên seal**: Đếm số chai và nhập vào cột **Số chai nguyên**.
    *   **Chai đang mở**: Đặt chai rượu lên cân điện tử, lấy số Gram (ví dụ: *820g*) và nhập vào cột **Trọng lượng (Grams)**.
4.  Hệ thống tự động quy đổi trọng lượng rượu còn lại sang dung tích ML dựa trên cấu hình chai đầy/rỗng có sẵn:
    $$\text{Dung tích thực tế (ML)} = \text{Dung tích chai (ML)} \times \frac{\text{Trọng lượng cân (g)} - \text{Khối lượng vỏ rỗng (g)}}{\text{Khối lượng chai đầy (g)} - \text{Khối lượng vỏ rỗng (g)}}$$
5.  Xác nhận số liệu để hệ thống ghi nhận mốc tồn đầu ca.

### Bước 2: Khai báo Tiêu hao ngoài bán hàng (Trong ca trực)
Khi có sự cố xảy ra trong ca, Bartender bắt buộc phải nhập mã PIN cá nhân và tạo phiếu **Hủy hỏng / Tiêu hao ngoài bán hàng**:
1.  **Hủy hỏng do đổ vỡ (Breakage)**: Nhập số lượng rượu bị đổ vỡ (ví dụ: vỡ ly, vỡ chai) kèm lý do cụ thể.
2.  **Rót tràn / Hao hụt line (Spill)**: Ghi nhận lượng bia tươi hao hụt khi vệ sinh vòi hoặc rót bọt.
3.  **VIP Comp (Mời khách)**: Nhập các ly cocktail/rượu mời theo chỉ thị của quản lý.
4.  **Tasting (Thử rượu)**: Ghi nhận lượng rượu rót ra để thử vị/kiểm tra chất lượng trước khi phục vụ.

*Lưu ý*: Việc ghi chép đầy đủ các tiêu hao này sẽ giúp hệ thống trừ kho lý thuyết chính xác, tránh việc quy trách nhiệm oan cho Bartender khi tính toán chênh lệch cuối ca.

### Bước 3: Đóng ca trực & Chốt Variance (End of Shift)
1.  Cuối ca trực, Bartender chọn **Đóng ca trực** (`shift = 'CLOSE'`).
2.  Tiến hành cân và đếm lại toàn bộ chai rượu đang mở và chai nguyên seal tương tự như lúc mở ca.
3.  Bấm **Ghi nhận & Đóng ca**.
4.  Hệ thống tự động đối chiếu số liệu:
    $$\text{Tiêu hao thực tế} = (\text{Tồn đầu ca} + \text{Nhập trong ca}) - \text{Tồn cuối ca}$$
    $$\text{Pour Variance (Lệch rót)} = \text{Tiêu hao thực tế} - \text{Tiêu hao lý thuyết từ POS}$$
5.  *Hành động*: Nếu Pour Variance báo đỏ (vượt quá dung sai 1-2% đối với rượu mạnh giá trị cao), Bartender phải giải trình trực tiếp với Tổ trưởng hoặc Kế toán kho.

---

## 3. QUY TRÌNH HÀNG TUẦN / HÀNG THÁNG (Weekly/Monthly Workflow)

### 1. Hiệu chuẩn chai rượu mới (Calibration)
Khi nhà hàng nhập về loại rượu mới chưa có trong danh mục cân dở:
1.  Tổ trưởng quầy Bar cân chai rượu mới nguyên seal để lấy **Trọng lượng chai đầy (Full Weight Grams)**.
2.  Khi chai rượu đó hết, giữ lại vỏ chai và cân để lấy **Khối lượng vỏ rỗng (Empty Weight Grams)**.
3.  Nhập hai thông số này kèm theo dung tích chai (ví dụ: *750ml*) vào bảng **Cấu hình Hiệu chuẩn 2 điểm** để kích hoạt chức năng cân dở cho sản phẩm đó.

### 2. Xác nhận chốt ngày (Daily Stock Movement Confirmation)
1.  Trước khi kết thúc ngày vận hành, Tổ trưởng quầy Bar truy cập phân hệ **Xác nhận kho ngày**.
2.  Kiểm tra xem tất cả các giao dịch nhập hàng từ Kho tổng vào quầy Bar (`TRANSFER_IN`) và xuất hàng đã được cập nhật đủ chưa.
3.  Bấm nút **Đã nhập xong** và **Đã xuất xong** của bộ phận Bar để kích hoạt hệ thống chốt tồn vật lý cuối ngày của Bar.
