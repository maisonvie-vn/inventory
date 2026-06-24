# MEMORY.md — Cumulative Memory of Antigravity

_Bộ nhớ hệ thống lưu vết các cột mốc nâng cấp, sửa đổi dữ liệu và quy chuẩn của Maison Vie CRM & Inventory._

---

## 🗓️ Khởi tạo thông tin
- **Dự án:** Maison Vie CRM & Inventory (Next.js + Supabase)
- **Đường dẫn Workspace:** `d:\Invenroty\maison-vie-crm`
- **Agent ID:** `maison-vie-crm`
- **Cấu hình mô hình:** `litellm/my-combo` thông qua 9router (Port: 20128)

---

## 🚀 Các cột mốc & Thay đổi quan trọng (Bản vá v3.0.x)

### 1. Mobile Ready & iOS/Safari Fixes
- Khắc phục lỗi ép dẹt chữ và chồng cột trên Safari bằng cách đổi `table-fixed` thành `table-auto` trong Master Kho.
- Bọc toàn bộ bảng Master Kho, ManualForms, ClosedInventory và PurchasingModule trong container `div` riêng có class `overflow-x-auto` và đặt chiều rộng tối thiểu cho `table` (ví dụ `min-w-[750px]`).

### 2. Tự động hóa giá vốn Moving WAC & Tồn âm
- Khi duyệt nhận hàng (approved goods receipt), trigger tự động phân bổ chi phí Landed Cost (phí vận chuyển, hải quan).
- Đã thiết lập cơ chế xử lý tồn âm: Nếu tồn kho thực tế bị âm tại thời điểm duyệt nhập hàng mới, số lượng tồn kho trước đó sẽ được tính bằng 0 trong công thức Moving WAC để ngăn chặn giá vốn bị âm.

### 3. Row Level Security (RLS) của Nhà cung cấp
- Bảng `suppliers` được thiết lập tắt RLS (`DISABLE ROW LEVEL SECURITY`) để đảm bảo nghiệp vụ nhập file dữ liệu Excel hàng loạt từ client không bị chặn quyền.
- Các bảng giao dịch kho và danh mục khác vẫn duy trì bật RLS bảo mật tuyệt đối.

### 4. view và Khóa ngoại Purchasing
- view `v_order_worklist_ops` được bổ sung trường `supplier_id` để giải quyết lỗi mất liên kết nhà cung cấp ưu tiên.
- Sửa lỗi ràng buộc khóa ngoại của `po_lines(ingredient_id)` trỏ trực tiếp đến `ingredients(id)`.
- Thiết lập ràng buộc Unique trên cột mã PO (`po_no`) để loại bỏ hoàn toàn khả năng trùng lặp đơn hàng.
