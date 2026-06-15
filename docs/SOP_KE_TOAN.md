# QUY TRÌNH VẬN HÀNH CHUẨN (SOP) – KẾ TOÁN KHO CẤP CAO
### (Phân hệ dành cho Cấp 4: Nhập kho, Đối soát 3-Way Match, Map POS và duyệt Auto-PO)

Quy trình này hướng dẫn Kế toán kho cấp cao quản lý quy trình nhập hàng, đối soát công nợ nhà cung cấp, ánh xạ món ăn POS và phê duyệt đơn đặt hàng tự động.

---

## 1. CÁC QUYỀN HẠN ĐẶC ĐẶC THÙ (CHỈ CẤP 4 CÓ QUYỀN)
*   **Duyệt Goods Receipt & Tính WAC**: Chốt đơn giá nhập kho, phân bổ chi phí Landed Cost (thuế, cước) để tự động cập nhật WAC.
*   **Duyệt Auto-PO**: Điều chỉnh số lượng và phê duyệt các đơn đặt hàng tự động do hệ thống đề xuất để gửi cho nhà cung cấp.
*   **Quản lý Danh mục Mapping POS**: Xác nhận và cập nhật bảng ánh xạ vĩnh viễn giữa mã POS của nhà hàng và mã Recipe định mức của hệ thống.

---

## 2. QUY TRÌNH HÀNG NGÀY (Daily Workflow)

### Bước 1: Đối soát Nhập kho (3-Way Match)
Khi có hàng giao tới nhà hàng kèm theo Hóa đơn/Phiếu giao hàng từ nhà cung cấp:
1.  Nhận thông tin nhập kho nháp (do Thủ kho Cấp 7 nhập ở trạng thái `pending`).
2.  Thực hiện đối soát **3-Way Match (Đơn đặt hàng PO ↔ Phiếu nhập kho GRN ↔ Hóa đơn mua hàng)**:
    *   **Khớp Số lượng**: Số lượng thực nhận trên GRN phải khớp với số lượng trên đơn PO đã đặt.
    *   **Khớp Đơn giá**: Giá trên hóa đơn tài chính phải khớp với đơn giá đã thỏa thuận trên PO.
3.  *Xử lý lệch*:
    *   Nếu lệch số lượng hoặc giá: Hệ thống chuyển trạng thái đơn hàng thành `VARIANCE`. Kế toán kho phải liên hệ nhà cung cấp/bếp để xác minh. Số liệu kho sẽ **không được ghi tăng** và WAC sẽ **không cập nhật** cho đến khi kế toán xử lý xong và bấm **"APPROVED"**.
    *   Nếu khớp hoàn toàn: Bấm duyệt **"APPROVED"**. Hệ thống sẽ tự động ghi bút toán `IMPORT` vào sổ cái và tính lại giá vốn bình quan gia quyền (Moving WAC) theo lô hàng mới nhất.

### Bước 2: Import Doanh số POS cuối ngày & Đồng bộ Mapping
1.  Truy cập tab **Doanh số & POS Import**.
2.  Chọn file Excel báo cáo doanh số POS trong ngày (tải từ phần mềm POS của nhà hàng).
3.  Hệ thống sẽ tự động đọc file Excel và đối chiếu:
    *   **Mã POS cũ (Đã map)**: Hệ thống tự động nhận diện và gán Recipe ID tương ứng 100%, không yêu cầu kế toán thao tác lại.
    *   **Mã POS mới xuất hiện**: Hệ thống sẽ dùng thuật toán Levenshtein so khớp từ gần đúng và đưa ra gợi ý màu vàng (Ví dụ: *"Angus Ribeye Wellington - Gợi ý 92% khớp với R-011"*).
4.  *Hành động*: Kế toán kho chọn Recipe chính xác cho mã mới đó và bấm **"Xác nhận ánh xạ"**. Ánh xạ này sẽ được ghi đè vĩnh viễn vào bảng `pos_alias_map`, từ lần sau hệ thống sẽ tự động khớp mà không hỏi lại.
5.  *Chốt ghi sổ*: Sau khi kiểm tra toàn bộ danh sách món khớp hoàn toàn, kế toán chủ động bấm **"Chốt ghi sổ POS"** để kích hoạt job trừ kho định mức (không sử dụng cơ chế tự động đếm ngược 30 giây để tránh lỗi ghi sổ khi số liệu chưa khớp).

### Bước 3: Xem và duyệt Đề xuất Auto-PO cuối ngày
Hệ thống chạy job tự động tính toán nhu cầu đặt hàng vào lúc **22:40** dựa trên tồn lý thuyết và lịch sử tiêu thụ 14 ngày.
1.  Truy cập phân hệ **Đơn đặt hàng (Purchase Orders)**.
2.  Xem các PO ở trạng thái nháp (Draft PO) được gom theo từng Nhà cung cấp ưu tiên.
3.  Kiểm tra số lượng đặt hàng đề xuất:
    *   Hệ thống đã tự động làm tròn lên theo kích thước đóng gói của nhà cung cấp (`pack_size` - ví dụ: làm tròn lên thùng 24 chai thay vì đặt lẻ chai).
    *   Đã tôn trọng số lượng đặt tối thiểu (`moq`) của nhà cung cấp.
4.  *Hành động*: Kế toán có thể chỉnh sửa trực tiếp số lượng nếu có sự kiện đặc biệt (ví dụ: nhà hàng có tiệc cưới lớn vào cuối tuần cần đặt thêm). Sau đó bấm **"Phê duyệt & Xuất PO"**. Hệ thống sẽ xuất ra file PDF/Excel PO sạch để kế toán gửi cho nhà cung cấp trước giờ cutoff time.

---

## 3. PHƯƠNG PHÁP TÍNH TOÁN GIÁ VỐN & LANDED COST (Dành cho kế toán)
Kế toán cần hiểu rõ công thức tính Moving WAC có bảo vệ tồn âm của hệ thống để giải trình số liệu cho CFO:
1.  Nếu tồn kho lý thuyết trước khi nhập bị âm (do bán trước, nhập hóa đơn sau): Hệ thống coi như tồn kho hiện tại bằng `0` để tính WAC, bảo vệ đơn giá vốn không bị tăng ảo.
2.  **Landed Cost (Giá vốn cập bến)**: Đối với nguyên liệu nhập khẩu (như Thịt bò Mỹ, Bơ Pháp), đơn giá nhập kho để tính WAC không phải là giá gốc của sản phẩm, mà được tự động cộng thêm phí vận chuyển phân bổ và thuế nhập khẩu:
    $$\text{Landed Cost} = \frac{\text{Giá trị hàng nhập} \times \text{Tỷ giá ngoại tệ} + \text{Thuế nhập khẩu phân bổ} + \text{Cước vận chuyển phân bổ}}{\text{Số lượng tồn quy đổi}}$$
    Kế toán cần điền chính xác các trường thuế (`duty`) và cước (`freight`) trên form nhận hàng để hệ thống tính toán chính xác WAC.
