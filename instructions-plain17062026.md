# HƯỚNG DẪN CHI TIẾT & NHẬT KÝ THỰC HIỆN NGÀY 17/06/2026

Tài liệu này ghi lại toàn bộ các công việc nâng cấp mã nguồn, thay đổi cấu trúc bảo mật dữ liệu, chuẩn hóa dữ liệu danh mục và cấu hình tự động hóa đã thực hiện trong ngày hôm nay cho dự án **Maison Vie CRM/ERP - Hệ thống quản lý kho & tính giá vốn WAC (Phiên bản nâng cấp v9.4)**.

---

## 1. Thiết lập Dark Theme Fine-Dining & Tối ưu UI/UX
*   **Yêu cầu:** Đổi bảng màu giao diện sang phong cách nhà hàng Pháp sang trọng và đồng bộ. Màu vàng kem sáng trước đây được thay hoàn toàn bằng màu xanh rêu deep.
*   **Giải pháp đã thực hiện:**
    *   Cập nhật tệp [globals.css](file:///d:/Invenroty/maison-vie-crm/src/app/globals.css) định nghĩa các design tokens cho theme tối:
        *   Nền chính trang: Deep Teal (`#102B2A`)
        *   Nền phụ (Sidebar/Header/Cards): Dark Teal (`#042726`)
        *   Viền phân cách: Brass ấm (`#C9A581`)
        *   Chữ chính: Trắng ấm (`#FBF8F4` - tương phản AAA, chống lóa)
        *   Điểm nhấn/Nút chính: Vàng đồng Brass (`#A8884E` / `#B58C67`)
    *   Tối ưu giao diện **Mobile-ready**: Thu gọn header slim (~56px), ghim các cột quan trọng của bảng để cuộn ngang và bổ sung thanh Bottom Tab Bar thao tác một chạm trên điện thoại.

---

## 2. Nâng cấp Bảo mật Row-Level Security (RLS) & Quy trình Đăng ký an toàn
*   **Yêu cầu:** Khắc phục giải pháp tắt RLS tạm thời ở các bản trước để đưa hệ thống vào vận hành thực tế bảo mật.
*   **Giải pháp đã thực hiện:**
    *   Kích hoạt lại bảo mật RLS (Row-Level Security) trên 100% các bảng nghiệp vụ nhạy cảm trong tệp [schema.sql](file:///d:/Invenroty/maison-vie-crm/supabase/schema.sql).
    *   Xây dựng lại các chính sách bảo mật (Policies) dựa trên vai trò thực tế của người dùng thông qua hàm tra cứu `get_current_user_role()`.
    *   Sửa đổi hàm trigger đăng ký tài khoản mới (`on_auth_user_created`): tài khoản mới mặc định nhận quyền hạn thấp nhất (`staff`) thay vì quyền `admin` như trước, ngăn chặn nguy cơ leo thang đặc quyền.

---

## 3. Chuẩn hóa Đơn vị tính (UoMs) Toàn diện
*   **Yêu cầu:** Loại bỏ triệt để các đơn vị trùng lặp hoặc viết sai định dạng chữ hoa/chữ thường gây lỗi khóa ngoại và phân mảnh tính giá vốn.
*   **Giải pháp đã thực hiện:**
    *   Quy định tập hợp đơn vị tính viết hoa chuẩn duy nhất: `KG`, `G`, `L`, `ML`, `BOTTLE`, `PIECE`, `CAN`, `GLASS`, `PACK`, `BOX`, `BAG`.
    *   Cập nhật và làm sạch toàn bộ dữ liệu mẫu trong tệp [seed.sql](file:///d:/Invenroty/maison-vie-crm/supabase/seed.sql), tệp tồn kho đầu kỳ [opening_stock_01062026.sql](file:///d:/Invenroty/maison-vie-crm/supabase/opening_stock_01062026.sql), và tệp dữ liệu giả lập [db.json](file:///d:/Invenroty/maison-vie-crm/src/data/db.json).

---

## 4. Nghiệp vụ Phân quyền & Lọc bộ phận Dashboard
*   **Yêu cầu:** Phân cấp rõ rệt quyền hạn xem dữ liệu và sửa lỗi bộ phận bếp vẫn nhìn thấy bia/rượu của quầy Bar khi ở vai trò Chef.
*   **Giải pháp đã thực hiện:**
    *   Tách biệt vai trò Bếp trưởng (`Chef` - chỉ thấy KITCHEN-scope) và Quản lý Nhà hàng (`Manager` - thấy Bếp + Bar nhưng không xem doanh thu).
    *   Cập nhật logic frontend trong [page.tsx](file:///d:/Invenroty/maison-vie-crm/src/app/page.tsx): Bộ lọc bộ phận `Tất cả / Bếp / Quầy Bar` ở đầu trang sẽ tự động lọc động toàn bộ các card tài chính, panel cảnh báo tồn tối thiểu, và biểu đồ tiêu hao nguyên liệu trên Dashboard.

---

## 5. Nghiệp vụ Kiểm kho, Pour Variance & Quyền ghi đè của Admin
*   **Yêu cầu:** Giải quyết vấn đề buffer 10% trong kiểm kho và quyền can thiệp nhanh của Admin vào kho quầy Bar.
*   **Giải pháp đã thực hiện:**
    *   **Song song 2 cột Variance:** Hiển thị đồng thời **Chênh lệch Thô** (Raw Variance = tồn thực tế − tồn lý thuyết gốc không chứa 10% buffer) bên cạnh cột chênh lệch sau khi cộng 10% buffer vận hành, giúp CFO phát hiện thất thoát thực tế.
    *   **Bảng điều khiển Admin-Write cho Bar:** Cho phép quản lý trực tiếp điều chỉnh số lượng tồn kho Bar hoặc import Excel điều chỉnh nhanh mà không cần Bartender mở ca. Hệ thống tự động ghi lại vết can thiệp vào bảng **Nhật ký can thiệp Admin** trên Dashboard (`source='ADMIN_ADJ'` / `source='ADMIN_IMPORT'`) mà không bật popup hỏi lý do gây gián đoạn vận hành.
    *   **Cân dở chai rượu:** Tích hợp máy tính quy đổi khối lượng cân nặng thực tế (Grams) sang dung tích còn lại (ML) dựa trên cấu hình hiệu chuẩn 2 điểm chai đầy/chai rỗng.

---

## 6. Thiết lập Tự động hóa và Cron Jobs trong DB
*   **Yêu cầu:** Thiết lập các công việc tự động chạy định kỳ trong cơ sở dữ liệu và gửi thông báo qua email.
*   **Giải pháp đã thực hiện:**
    *   Dựng tệp cấu hình [CRON_TuDongHoa_MaisonVie.sql](file:///d:/Invenroty/maison-vie-crm/CRON_TuDongHoa_MaisonVie.sql) thiết lập 10 job tự động bằng cách kết hợp extension `pg_cron` và `pg_net` gọi API của Resend:
        1.  `auto_close` (02h00 sáng VN): Lưới an toàn chốt sổ ngày.
        2.  `variance_nightly` (02h30 sáng VN): Tính chênh lệch kho đêm.
        3.  `auto_po` (06h30 sáng VN): Tự động tạo PO nháp.
        4.  `lowstock_email` (07h00 sáng VN): Email cảnh báo nguyên liệu chạm mức tối thiểu.
        5.  `expiry_alert` (07h05 sáng VN): Email cảnh báo hàng cận hạn dùng (HACCP).
        6.  `po_aging` (07h10 sáng VN): Cờ báo PO trễ giao hàng.
        7.  `daily_report` (08h00 sáng VN): Email báo cáo tài chính ngày cho CFO.
        8.  `weekly_report` (Thứ hai, 08h30 sáng VN): Báo cáo tuần sâu.
        9.  `monthly_partition` (Ngày 1 hàng tháng): Tạo phân vùng bảng giao dịch để tối ưu dung lượng DB.
        10. `storage_cleanup` (Chủ nhật, 10h00 VN): Dọn dẹp tệp tin rác trên Storage.

---

## 7. Khắc phục lỗi Build & Đồng bộ mã nguồn
*   **Giải pháp đã thực hiện:**
    *   Khắc phục lỗi build Turbopack (`npm run build`) do có liên kết tượng trưng (symlink) trỏ ra ngoài phân vùng làm việc. Sau khi loại bỏ symlink, dự án được build hoàn tất 100% không có lỗi biên dịch.
    *   Đồng bộ mã nguồn sạch lên nhánh `main` trên GitHub và kích hoạt quy trình tự động triển khai (auto-deploy) trên Vercel.

---

## 8. Xây dựng Cơ sở dữ liệu chuẩn cho bộ phận Bar & Thiết lập Giá kép
*   **Yêu cầu:** Lập lại cơ sở dữ liệu chuẩn cho bộ phận Bar dựa trên công thức từ file Excel [NUOC_EP_MAISON_VIE_270M.xlsx](file:///D:/Invenroty/NUOC_EP_MAISON_VIE_270M.xlsx), hỗ trợ hai loại giá (giá tại chỗ và giá mang về) tương thích với dữ liệu bán hàng POS.
*   **Giải pháp đã thực hiện:**
    *   **Thêm nguyên liệu mới:** Khai báo 8 nguyên liệu còn thiếu trong DB bao gồm các nguyên liệu tươi (Cà rốt `NLP60057`, Gừng `NLP60058`, Bạc hà `NLP60059`, Dưa chuột `NLP60061`) và bao bì mang về (Cốc giấy `PKG-001`, Nắp cốc `PKG-002`, Ống hút giấy `PKG-003`, Túi giấy `PKG-004`).
    *   **Cấu hình Giá kép (Dine-In vs Takeaway):** Thiết lập mức giá bán riêng biệt cho hai kênh Tại chỗ và Mang về đối với tất cả món uống của Bar trong bảng `menu_prices` (ví dụ: nước ép mang về phụ thu 10-20k, cocktail mang về phụ thu 70k, bia phụ thu 20k, trà/cà phê giữ nguyên giá).
    *   **Ánh xạ Bao bì mang về (`takeaway_packaging_map`):** Cấu hình tự động trừ kho nguyên liệu cốc, nắp, ống hút và túi giấy khi có đơn hàng mang về (các loại nước uống dùng cốc + nắp + ống hút + 0.5 túi; bia và rượu chai nguyên sử dụng túi giấy).
    *   **Đồng bộ DB & POS Mapping:** 
        *   Tích hợp toàn bộ 180 công thức (gồm cả bia, rượu ly, rượu chai, nước ép, cocktail, cà phê và trà) vào tệp dữ liệu [db.json](file:///d:/Invenroty/maison-vie-crm/src/data/db.json) và tệp seed [seed.sql](file:///d:/Invenroty/maison-vie-crm/supabase/seed.sql).
        *   Cập nhật `POS_MAPPING` trong [mockData.ts](file:///d:/Invenroty/maison-vie-crm/src/data/mockData.ts) chuyển toàn bộ đồ uống từ loại `beer` (bỏ qua ánh xạ định mức) sang loại `alc` (trừ kho tự động theo công thức chi tiết) để kiểm soát chính xác lượng tiêu hao.

---

## 9. Tối ưu trực quan hóa UI/UX mục Định mức & Công thức
*   **Yêu cầu:** Khắc phục sự nhầm lẫn trực quan của người dùng khi nhìn thấy các nút bộ lọc À La Carte và Dégustation giống tiêu đề cột, đồng thời xử lý trạng thái trống (empty state) khi chuyển sang bộ lọc Dégustation đối với nhóm đồ uống của Bar.
*   **Giải pháp đã thực hiện:**
    *   **Làm rõ mục tiêu bộ lọc:** Thêm tiêu đề phân định **`Bộ lọc thực đơn (Menu Filter):`** ngay phía trên hai nút À La Carte và Dégustation ở cột bên trái để phân biệt rõ đây là công cụ lọc danh sách, không phải tiêu đề cột.
    *   **Hộp chỉ báo Portion động:** Bổ sung Badge trạng thái nổi bật ở phần chi tiết công thức bên phải, tự động hiển thị **`À LA CARTE (ĐẦY ĐỦ)`** (màu xanh lá) hoặc **`DÉGUSTATION (TASTING)`** (màu cam) dựa trên mã công thức, giúp người dùng nhận biết ngay lập tức portion đang xem.
    *   **Xử lý Trạng thái Trống (Empty State) thông minh:** Khi người dùng lọc Dégustation cho các nhóm không hỗ trợ định lượng Tasting (như món nước của Bar vốn chỉ phục vụ À La Carte), hệ thống hiển thị thông báo hướng dẫn cụ thể thay vì để trống: *"Không có Định mức Tasting (Dégustation) cho nhóm này - Món uống Bar chỉ phục vụ phần À La Carte đầy đủ"*.
    *   **Đồng bộ sản phẩm:** Kiểm thử TypeScript thành công và đẩy các cập nhật UI/UX lên GitHub để triển khai tức thì.

---

## 10. Đối soát và Đồng bộ diện rộng 145 mặt hàng Đồ uống & Rượu bia
*   **Yêu cầu:** Thực hiện đối soát chéo danh mục đồ uống và rượu bia từ các bảng Excel (`MAISON_VIE_v6_0_PRO.xlsx`, `BÁO CÁO TỒN KHO BAR T05.2026.xlsx`, `FINAL(12062026)_Maison_Vie_Recipe_Master_2026_CORRIGE.xlsx`). Đồng bộ toàn bộ các sản phẩm đã có mã và nguyên liệu trong DB nhưng chưa được đăng ký Menu Item, chưa có Recipe 1:1, hoặc chưa có ánh xạ POS trên hệ thống (giải quyết triệt để vấn đề "hàng bán chưa có công thức - unmapped sales" cho các sản phẩm bán nguyên direct).
*   **Giải pháp đã thực hiện:**
    *   **Đối soát và trích xuất dữ liệu:** Phát hiện **145 mặt hàng** đồ uống (rượu vang, rượu mạnh, nước ngọt, bia, cigar...) có trong danh mục kho nhưng bị thiếu cấu hình Menu Item và mapping POS. Trích xuất đơn giá vốn (Cost Price) và giá bán lẻ (Sale Price) trực tiếp từ sheet `Unit Price` của tệp tồn kho [BÁO CÁO TỒN KHO BAR T05.2026.xlsx](file:///D:/Invenroty/BÁO CÁO TỒN KHO BAR T05.2026.xlsx). Đối với các mặt hàng thiếu giá bán lẻ, hệ thống tự động áp dụng hệ số markup `2.5` lần giá vốn và làm tròn đến 10,000 VND.
    *   **Đồng bộ cơ sở dữ liệu Supabase:** Tạo và chạy script `scratch_beverage_sync.sql` chứa **472 câu lệnh SQL** (INSERT các `menu_items`, `recipes` 1:1, `pos_alias_map`, và `ingredient_departments` liên kết bộ phận quản lý `BAR`). Kết quả chạy thực tế và chạy script kiểm tra trả về **0 thiếu sót (0 missing items/recipes/aliases)**.
    *   **Tích hợp seed & local code:**
        *   Tích hợp toàn bộ câu lệnh INSERT SQL vào tệp [seed.sql](file:///d:/Invenroty/maison-vie-crm/supabase/seed.sql) để đảm bảo đồng bộ môi trường local.
        *   Cập nhật tệp cấu hình [db.json](file:///d:/Invenroty/maison-vie-crm/src/data/db.json) bổ sung 145 công thức direct 1:1.
        *   Cập nhật [mockData.ts](file:///d:/Invenroty/maison-vie-crm/src/data/mockData.ts) (ánh xạ `POS_MAPPING` phân loại đúng `"alc"` cho rượu mã V và `"beer"` cho bia/nước ngọt/cigar/rượu mạnh).
    *   **Cập nhật File mẫu Excel:** Ghi nhận toàn bộ 145 sản phẩm này vào tệp biểu mẫu [MAU_IMPORT_DANHMUC_1-1.xlsx](file:///D:/Invenroty/MAU_IMPORT_DANHMUC_1-1.xlsx) (sheet `DANH_MUC_1-1`) làm One Source of Truth cho danh mục direct 1:1 với cờ `DIRECT` và đơn vị viết hoa chuẩn (BOTTLE, CAN, PACK...).
    *   **Đồng bộ GitHub:** Stage, commit và push thành công toàn bộ các thay đổi lên nhánh `main` của GitHub (commit hash `c17d9be`), kích hoạt Vercel tự động deploy bản mới.
