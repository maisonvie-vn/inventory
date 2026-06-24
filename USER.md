# USER.md — About Maison Vie CRM & Users

---

## 👤 Người dùng & Vai trò

- **Anh Thành (Founder & CEO):** Người đưa ra yêu cầu chiến lược, phê duyệt các bản phát hành, giám sát dữ liệu tài chính và báo cáo tồn kho.
- **Kế toán trưởng & Nhân viên Kế toán Kho:** Người trực tiếp nhập liệu phiếu nhập kho (GRN), thực hiện đối soát 3-Way Match, chốt kỳ kế toán (tuần/tháng) và xuất hóa đơn.
- **Bộ phận Bếp & Bar:** Người thực hiện kiểm kê thực tế (`stocktakes`), báo cáo tiêu hao/hủy hỏng (`waste_logs`) và cân đo rượu dở/nguyên liệu cuối ngày.

---

## 🏢 Hệ sinh thái: Maison Vie Restaurant

Maison Vie là nhà hàng mang phong cách Tân cổ điển cao cấp. Hệ thống CRM & Quản lý Kho cần phản ánh sự chuẩn chỉ, chuyên nghiệp và chính xác cao:
- **Tông màu chủ đạo UI:** Xanh rêu (Moss Green) và Vàng gold ánh kim (Accent Gold) quý phái.
- **Database:** Supabase PostgreSQL bảo mật qua các chính sách RLS chặt chẽ.
- **Frontend:** Next.js ứng dụng Single Page Dashboard tương thích hoàn hảo trên các màn hình di động (iPhone/iPad/Android) để nhân viên bếp và bar có thể nhập tồn kho trực tiếp tại quầy.

---

## 🎯 Mục tiêu vận hành hệ thống

1. **Khấu trừ kho chính xác:** Đảm bảo trigger FEFO và công thức quy đổi BOM từ POS chạy mượt mà, hạn chế tối đa độ trễ.
2. **Quản lý giá vốn thực tế:** Tính giá vốn theo thời gian thực sử dụng phương pháp Bình quân gia quyền lũy tiến (Moving WAC) có phân bổ chi phí Landed Cost (phí vận chuyển, hải quan).
3. **Mobile Ready:** Đảm bảo tất cả các view, biểu bảng dữ liệu và form nhập liệu hiển thị gọn gàng, không bị chồng chéo hay dẹt chữ trên màn hình điện thoại (đặc biệt là iOS/Safari).
4. **Đối soát chặt chẽ:** Quản lý quy trình mua hàng qua 3 bước (3-Way Match) để kiểm soát chênh lệch giá (PPV) và công nợ nhà cung cấp.
