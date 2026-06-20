# HƯỚNG DẪN CHI TIẾT QUY TRÌNH MUA HÀNG & NHẬP KHO (v3.0)
> **Hệ thống:** Maison Vie Inventory & ERP  
> **Module:** Mua hàng & Nhập kho (`PurchasingModule`)  
> **Tài liệu kỹ thuật liên quan:** [PurchasingModule.tsx](file:///D:/Invenroty/maison-vie-crm/src/app/components/PurchasingModule.tsx) | [v3_0_migration.sql](file:///D:/Invenroty/maison-vie-crm/supabase/v3_0_migration.sql) | [migrations_v9.6_triggers.sql](file:///D:/Invenroty/maison-vie-crm/supabase/migrations_v9.6_triggers.sql)

---

## 📌 1. TỔNG QUAN QUY TRÌNH 5 BƯỚC KHÉP KÍN

Quy trình quản lý mua hàng và nhập kho của Maison Vie được thiết kế tự động hóa tối đa ở tầng cơ sở dữ liệu để đảm bảo tính chính xác, chống gian lận và quản lý giá vốn chính xác.

```mermaid
graph TD
    A["1. Cần đặt hàng (Hệ thống gợi ý)"] -->|Chọn & Gom nhà cung cấp| B["2. Tạo PO (DRAFT)"]
    B -->|Gửi duyệt (Segregation of Duties)| C["3. Duyệt PO (PENDING_APPROVAL)"]
    C -->|Dưới 10tr: Phê duyệt luôn| D["4. PO APPROVED"]
    C -->|Từ 10tr trở lên: Chờ CFO duyệt| E["Chờ duyệt cấp 2 (Tier 2)"]
    E -->|CFO duyệt| D
    D -->|Nhập Excel GRN| F["5. Nhập hàng & Đối soát (3-Way Match)"]
    F -->|Thành công| G["Tự động cộng kho + Tính lại giá WAC"]
```

---

## 📑 2. CHI TIẾT TỪNG BƯỚC THAO TÁC TRÊN GIAO DIỆN

Hệ thống chia làm **6 tab nhỏ (Sub-tabs)** trực quan tại trang Mua hàng.

---

### BƯỚC 1: XÁC ĐỊNH MẶT HÀNG CẦN ĐẶT (Tab "Cần đặt hàng")

Tab này hiển thị danh sách các nguyên vật liệu/rượu vang đang cạn dưới ngưỡng an toàn, được tính toán tự động mỗi đêm (hoặc cập nhật realtime sau mỗi giao dịch).

#### 1. Các thông số hệ thống tự tính:
* **Tồn hiện tại:** Số lượng thực tế trong kho (tô đỏ nếu sắp hết).
* **Ngưỡng (Reorder Point):** Điểm đặt hàng. Được tính bằng: `Tiêu thụ TB 30 ngày gần nhất` × `Lead time (3 ngày)` × `Hệ số an toàn (1.5)` × `Hệ số mùa vụ`.
* **Đủ dùng (Days of cover):** Số ngày tồn kho hiện tại còn trụ được.
* **SL gợi ý:** Số lượng hệ thống khuyên đặt để đưa tồn kho về mức tối đa (Par Level). Giá trị này đã tự động làm tròn theo **MOQ (Số lượng đặt tối thiểu)** và **Pack size (Quy cách đóng gói)** của Nhà cung cấp.
* **PO đang mở:** Số lượng hàng đã đặt ở các PO trước đó nhưng chưa nhập kho (giúp tránh đặt trùng).

#### 2. Thao tác thiết lập Nhà cung cấp (NCC) ưu tiên và Tạo PO:
1. **Chọn Nhà cung cấp ưu tiên:** Đối với mặt hàng chưa có NCC ưu tiên (hiển thị `-- Chọn NCC --`), bạn click vào dropdown ở cột **NCC ưu tiên** và chọn nhà cung cấp phù hợp. 
   *(Lưu ý: Hệ thống đã được vá lỗi bổ sung cột `supplier_id` dưới database giúp giao diện ghi nhớ lựa chọn NCC ngay lập tức mà không bị reset về `-- Chọn NCC --` khi tải lại).*
2. **Tích chọn mặt hàng:** Tích chọn (checkbox) vào các mặt hàng muốn đặt ở cột ngoài cùng bên trái.
3. **Tạo PO tự động:** Nhấn nút **"Tạo PO (X mặt hàng)"** ở góc trên bên phải.
   * **Cơ chế tự động gom NCC:** Hệ thống tự động gom các mặt hàng bạn đã chọn theo từng NCC ưu tiên để tạo ra các phiếu PO nháp tương ứng (mỗi NCC một phiếu).
   * **Lưu ý:** Nếu có mặt hàng nào chưa được gán NCC ưu tiên, hệ thống sẽ chặn lại và hiển thị cảnh báo yêu cầu bạn gán NCC trước hoặc chuyển sang tab "Tạo PO" để làm thủ công.

---

### BƯỚC 2 & 3: TẠO & DUYỆT ĐƠN HÀNG (Tab "Duyệt PO")

Tab này quản lý các đơn hàng đang ở trạng thái **DRAFT** (nháp) hoặc **PENDING_APPROVAL** (chờ duyệt).

> [!IMPORTANT]
> **Cơ chế kiểm soát nội bộ (Segregation of Duties):**
> Để chống gian lận, **người tạo PO không được phép tự duyệt PO của mình**. Hệ thống sẽ ẩn nút duyệt và hiển thị cảnh báo nếu bạn cố tình duyệt PO do chính tài khoản của bạn tạo ra.

#### Thao tác gửi duyệt (Dành cho Kế toán kho / Người tạo):
1. Tìm PO ở trạng thái **DRAFT** trong danh sách.
2. Bấm nút **"Gửi duyệt"** để chuyển trạng thái sang `PENDING_APPROVAL`.
3. Hệ thống sẽ tạo một **Badge nhấp nháy đỏ** trên màn hình của Quản lý/CFO/Admin để thông báo có đơn hàng mới cần duyệt.

#### Thao tác phê duyệt (Dành cho Quản lý / CFO / Admin):
1. Tìm PO ở trạng thái **PENDING_APPROVAL**. Bạn có thể bấm nút **In PDF (Biểu tượng máy in 🖨️)** để xem trước bản in hoặc tải file PDF về máy.
2. Bấm **"Duyệt"** (hoặc **"Từ chối"** - hệ thống sẽ yêu cầu nhập lý do từ chối).
3. **Quy tắc phân tầng duyệt giá trị đơn hàng:**
   * **Đơn hàng dưới 10.000.000 đ:** Chỉ cần 1 Quản lý hoặc Kế toán trưởng duyệt → PO chuyển ngay sang trạng thái **APPROVED** (Đã duyệt).
   * **Đơn hàng từ 10.000.000 đ trở lên (Duyệt cấp 2):** Sau khi Quản lý duyệt cấp 1, PO sẽ chuyển sang trạng thái chờ duyệt cấp 2. Hệ thống sẽ bắn thông báo đỏ đến tài khoản của **Admin/CFO** yêu cầu duyệt lần cuối để chính thức phê duyệt PO.
   * **Cảnh báo quá hạn (Escalation):** Nếu PO ở trạng thái chờ duyệt quá **2 giờ** mà chưa được xử lý, hệ thống tự động đẩy cảnh báo khẩn cấp (Escalated) lên CFO.

---

### BƯỚC 4: QUẢN LÝ ĐƠN HÀNG ĐÃ DUYỆT (Tab "Lịch sử PO")

Hiển thị toàn bộ các PO đã có kết quả (`APPROVED`, `SENT`, `CANCELLED`...).
* **Gửi yêu cầu giao hàng:** Bạn vào tab này, tìm PO đã được duyệt, bấm biểu tượng máy in 🖨️ để lưu file dưới dạng PDF. Sau đó gửi file PDF này cho Nhà cung cấp qua Zalo/Email.
* **Thời gian giao hàng:** Nếu bạn duyệt PO vào ban đêm (ví dụ: 22h00) và muốn yêu cầu giao hàng vào sáng hôm sau (ví dụ: 7h00 sáng):
  1. Ghi chú rõ mốc thời gian giao hàng vào phần **Ghi chú (Notes)** khi lập đơn PO hoặc gửi duyệt.
  2. Gửi file PDF PO đã duyệt kèm lời nhắn hẹn giờ giao cho Nhà cung cấp qua Zalo/Email.

---

### BƯỚC 5: NHẬP HÀNG THỰC TẾ & ĐỐI SOÁT (Tab "Nhập hàng GRN")

Khi hàng hóa được giao kèm hóa đơn, bạn tiến hành nhập kho bằng cách upload file Excel để hệ thống tự động đối soát.

#### 1. Thao tác tải mẫu và điền file:
1. Tại Tab **Nhập hàng (GRN)**, bấm nút **"Tải mẫu Excel"**. Hệ thống sẽ tải về file `MAU_NHAP_HANG_MAISON_VIE.xlsx`.
2. Mở file Excel và điền thông tin hàng nhận thực tế:
   * **Mã hàng:** Bắt buộc nhập đúng mã (ví dụ: `V6027`, `B5001`...).
   * **SL nhận:** Số lượng thực nhận.
   * **Đơn giá (VND):** Giá thực mua trên hóa đơn.
   * **Số HĐ:** Số hóa đơn giao hàng (cực kỳ quan trọng để đối soát công nợ).
   * **Ngày nhận:** Ngày nhập kho thực tế.

#### 2. Thao tác upload và cơ chế tự động hóa:
1. Bấm nút **"Chọn file nhập hàng"** và upload file Excel đã điền.
2. Hệ thống sẽ kích hoạt chuỗi **tự động hóa tầng Database (DB)**:
   * **Bước A (Validation):** Kiểm tra mã hàng có tồn tại không, định dạng số lượng, đơn giá có chuẩn không. Nếu lỗi, hệ thống sẽ báo ngay trên màn hình.
   * **Bước B (Chống trùng - Dedup):** Kiểm tra cột `Số HĐ` trên Excel. Nếu số hóa đơn này đã được nhập trước đó, hệ thống sẽ tự động bỏ qua để tránh ghi đè hoặc cộng trùng tồn kho.
   * **Bước C (Cộng tồn kho realtime):** Tồn kho các mặt hàng tăng lên ngay lập tức.
   * **Bước D (Moving WAC):** Tính toán lại **Giá vốn bình quan gia quyền di động** cho nguyên vật liệu đó dựa trên giá nhập mới.
   * **Bước E (Đối soát 3 bên - 3-Way Match):** Hệ thống tự động so sánh thông tin giữa **Đơn đặt hàng (PO) gốc** và **Hóa đơn thực nhận (GRN)**.

#### 🔎 3. Bảng trạng thái đối soát 3-Way Match tự động:

Sau khi upload, bạn sẽ thấy cột **3-Way Match** hiển thị một trong các biểu tượng sau:

| Biểu tượng | Trạng thái đối soát | Ý nghĩa | Hành động tiếp theo |
| :---: | :--- | :--- | :--- |
| ✅ | **MATCHED** | Số lượng nhận và Đơn giá khớp hoàn toàn với PO gốc. | Không cần xử lý thêm. |
| ⚠️ | **SHORT_DELIVERY** | Số lượng thực nhận ít hơn số lượng đặt trên PO (lệch > 5%). | Kế toán chỉ thanh toán theo số lượng thực tế nhận. Làm việc lại với NCC để giao bù hoặc hủy phần thiếu. |
| 📦 | **OVER_DELIVERY** | Số lượng thực nhận nhiều hơn đặt trên PO (lệch > 5%). | Thủ kho kiểm tra xem có đồng ý nhận thừa hàng không. Nếu đồng ý, hệ thống tự động cộng kho theo số thực nhận. Nếu không, trả lại phần thừa cho NCC và sửa lại file Excel trước khi upload. |
| 💰 | **PRICE_VARIANCE** | Đơn giá thực mua lệch so với đơn giá thỏa thuận trên PO (sai số > 5%). | Hệ thống vẫn ghi nhận giá mới để cập nhật giá vốn WAC chính xác, đồng thời ghi log chênh lệch vào `audit_log` để kế toán kiểm tra và làm việc lại với NCC về công nợ. |

---

## 📈 3. CƠ CHẾ TÍNH GIÁ VỐN BÌNH QUÂN GIA QUYỀN DI ĐỘNG (MOVING WAC)

Hệ thống quản lý giá vốn theo phương pháp **WAC di động (Moving Weighted Average Cost)** để đảm bảo số liệu biên lợi nhuận chính xác theo thời gian thực.

### 1. Công thức tính tại thời điểm nhập hàng:
Mỗi khi một phiếu nhập hàng (GRN) được phê duyệt, trigger [process_goods_receipt_approve](file:///d:/Invenroty/maison-vie-crm/supabase/migrations_v9.6_triggers.sql#L264-L422) dưới database sẽ tự động tính lại giá vốn của mặt hàng đó theo công thức:

$$\text{WAC mới} = \frac{(\text{Số lượng tồn kho hiện tại} \times \text{WAC cũ}) + (\text{Số lượng nhập mới} \times \text{Đơn giá nhập mới})}{\text{Số lượng tồn kho sau khi nhập}}$$

### 2. Tác động đối với các đơn hàng bán trước đó:
> [!IMPORTANT]
> **Không ảnh hưởng ngược về quá khứ (No Retroactive Impact):**  
> Việc tính lại giá vốn WAC tại ngày nhập hàng mới **chỉ có tác dụng với các giao dịch xuất kho/bán hàng phát sinh sau thời điểm đó**. Tất cả các đơn hàng đã bán trước ngày nhập kho sẽ giữ nguyên giá vốn tại thời điểm bán.

* **Giải thích kỹ thuật:** Khi xuất kho bán hàng, hệ thống gọi hàm [deplete_stock_fefo](file:///d:/Invenroty/maison-vie-crm/supabase/migrations_v9.6_triggers.sql#L10-L76). Hàm này lấy giá vốn WAC của mặt hàng tại đúng thời điểm đó và ghi cố định (static) vào cột `unit_cost` của bảng sổ cái [inventory_transactions](file:///d:/Invenroty/maison-vie-crm/supabase/schema.sql#L270). Khi có giá vốn mới, các dòng giao dịch cũ trong sổ cái không bị thay đổi.
* **Ví dụ thực tế với Coca-Cola:**
  * Từ ngày 1/6 đến 19/6, giá vốn Coke là **5.000đ/lon**. Bạn bán ra 10 lon, giá vốn của 10 lon này được chốt cố định là **50.000đ** (5.000đ/lon).
  * Ngày 20/6, do cước vận chuyển tăng, bạn nhập lô Coke mới với giá **7.000đ/lon** (số lượng tồn cũ trước nhập là 10 lon, nhập mới 20 lon).
  * Giá vốn WAC mới được tính lại là: 
    
    $$\text{WAC mới} = \frac{(10 \text{ lon} \times 5.000đ) + (20 \text{ lon} \times 7.000đ)}{10 + 20} = 6.333đ/\text{lon}$$

  * **Kết quả:** Kể từ ngày 20/6 trở đi, các lon Coke bán ra sẽ tính giá vốn mới là **6.333đ/lon**. Các lon Coke đã bán từ 1/6 đến 19/6 vẫn giữ nguyên giá vốn lịch sử là **5.000đ/lon**. Báo cáo lợi nhuận của giai đoạn trước đó hoàn toàn không bị ảnh hưởng.
