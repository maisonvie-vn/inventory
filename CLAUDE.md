<!-- @AGENTS.md -->

# CLAUDE.md — CẨM NANG AI CODING AGENT (MAISON VIE INVENTORY/ERP)

Tài liệu này định hướng mọi AI Coding Agent khi làm việc trên kho lưu trữ (repository) **Maison Vie CRM/Inventory/ERP**. Đây là hệ thống **ĐANG CHẠY PRODUCTION** để quản lý tồn kho và giá vốn WAC cho nhà hàng fine-dining Maison Vie. Mọi can thiệp code và database bắt buộc tuân thủ nghiêm ngặt các nguyên tắc dưới đây.

---

## 1. Think Before Coding (Suy nghĩ trước khi code)
**Tuyệt đối không đoán mò cấu trúc database và phải kiểm chứng schema thực tế trước khi viết code.**
Môi trường production không chấp nhận sai sót về mặt dữ liệu. Mọi thay đổi logic hay truy vấn đều phải dựa trên cơ sở thông tin chính xác.
*   **Hành động cụ thể:**
    *   Trước khi viết truy vấn SQL hoặc code Next.js, phải đọc file [supabase/schema.sql](file:///d:/Invenroty/maison-vie-crm/supabase/schema.sql) và các file migration liên quan để kiểm tra tên bảng, cột, kiểu dữ liệu và ràng buộc.
    *   Không tự ý suy đoán cấu trúc. Nếu có nghi ngờ, sử dụng công cụ đọc database trực tiếp.
    *   Khi có nhiều giải pháp thiết kế, bắt buộc phải liệt kê các phương án kèm phân tích ưu/nhược điểm và trình bày cho người dùng duyệt, không tự ý chọn giải pháp ngầm định.
    *   Đặt ra các câu hỏi phản biện về mặt nghiệp vụ trước khi tiến hành code. Chỉ được thực hiện các thay đổi không thể khôi phục (như xóa cột, đổi kiểu dữ liệu) khi có xác nhận rõ ràng của người dùng.

## 2. Surgical Changes (Can thiệp ngoại khoa)
**Chỉ tác động chính xác vào vùng mã nguồn được yêu cầu và giữ nguyên thiết kế chung của hệ thống.**
Hạn chế tối đa rủi ro gây lỗi dây chuyền (side-effects) trên một hệ thống đang vận hành trực tiếp.
*   **Hành động cụ thể:**
    *   Không thực hiện refactor các hàm, component hoặc bảng không liên quan đến yêu cầu công việc.
    *   Tuân thủ phong cách lập trình (coding style) hiện có trong các component tại [src/app/components](file:///d:/Invenroty/maison-vie-crm/src/app/components) và các hook tại [src/lib](file:///d:/Invenroty/maison-vie-crm/src/lib).
    *   Không can thiệp vào các phần tích hợp tự động hóa (GitHub ↔ Vercel ↔ Supabase) trừ khi được chỉ định rõ ràng.
    *   Mỗi dòng code thay đổi phải được giải thích rõ mục đích và ánh xạ trực tiếp với một yêu cầu nghiệp vụ cụ thể.

## 3. Simplicity First - With Conditions (Đơn giản tối đa - Có điều kiện)
**Giữ giải pháp đơn giản nhất có thể, nhưng không được lược bỏ các kiểm soát bảo mật, toàn vẹn dữ liệu và an toàn tài chính bắt buộc.**
Sự đơn giản không được đánh đổi bằng việc hạ thấp tiêu chuẩn an toàn của một hệ thống tài chính - kho.
*   **Hành động cụ thể:**
    *   Không thêm các thư viện bên thứ ba (npm packages), tầng trừu tượng (abstraction layers) hay các tính năng vẽ vời khi chưa cần thiết.
    *   Tuyệt đối **KHÔNG** được vô hiệu hóa RLS (Row Level Security), không bỏ qua việc ghi audit logs, và không làm giảm tính idempotent (chống trùng lặp bút toán) nhân danh "đơn giản hóa code".
    *   Đẩy các logic tính toán nặng hoặc cần đồng bộ cao xuống tầng database (PostgreSQL Triggers, Stored Functions) để giữ Client Next.js mỏng và nhẹ.

## 4. Goal-Driven Execution (Thực thi theo mục tiêu)
**Định nghĩa rõ tiêu chí hoàn thành và kiểm thử nghiêm ngặt trên nhánh phát triển trước khi tích hợp.**
Đảm bảo mọi tính năng được bàn giao đều hoạt động đúng đặc tả và không gây hồi quy lỗi (regression).
*   **Hành động cụ thể:**
    *   Trước khi code, phải ghi rõ tiêu chí nghiệm thu (Definition of Done - DoD) của tính năng.
    *   Phát triển và chạy thử nghiệm trên Supabase Branch (nhánh dev/staging) trước khi chạy trên database chính.
    *   Mỗi tệp SQL migration hay thay đổi schema phải được chia thành các checkpoint nhỏ để sẵn sàng rollback khi gặp sự cố.
    *   Lặp lại chu kỳ kiểm thử và tinh chỉnh cho đến khi vượt qua toàn bộ checklist nghiệp vụ được quy định tại [IMPLEMENTATION_PLAN_v9.6.md](file:///d:/Invenroty/maison-vie-crm/IMPLEMENTATION_PLAN_v9.6.md).

## 5. Production Discipline (Kỷ luật Production)
**Hệ thống đang chạy trực tiếp cho nhà hàng thật, mọi thay đổi phải tuân thủ quy trình an toàn tuyệt đối.**
Tránh tối đa việc gây gián đoạn hoạt động kinh doanh và làm sai lệch số liệu tồn kho/giá vốn đang chạy.
*   **Hành động cụ thể:**
    *   Bắt buộc thực hiện backup dữ liệu (daily backup / PITR) trước khi chạy bất kỳ script sửa đổi dữ liệu hoặc cấu trúc nào trên cơ sở dữ liệu thật.
    *   Mọi thay đổi cấu trúc bảng bắt buộc phải thực hiện thông qua file migration được đánh số thứ tự trong thư mục [supabase/migrations/](file:///d:/Invenroty/maison-vie-crm/supabase/migrations/), cấm tuyệt đối việc chỉnh sửa trực tiếp (hot-fix) trên database production.
    *   Không triển khai các đoạn code chắp vá hoặc sửa đi sửa lại nhiều lần trên môi trường chạy thật. Một khi đã deploy lên Vercel/Supabase Production là code phải chạy ổn định.
    *   Thực hiện chạy thử nghiệm khôi phục dữ liệu (restore runbook) ít nhất một lần để đảm bảo khả năng ứng cứu khi xảy ra thảm họa dữ liệu.

## 6. Toàn vẹn & Bảo mật là BẤT KHẢ XÂM PHẠM
**Chính sách an toàn dữ liệu, sổ cái kế toán và bảo mật tài chính phải được thực thi triệt để ở tầng cơ sở dữ liệu.**
Đây là lá chắn bảo vệ hệ thống khỏi gian lận, thất thoát và lỗi vận hành của con người.
*   **Hành động cụ thể:**
    *   **RLS 100%:** Kích hoạt Row Level Security trên tất cả các bảng. Các chính sách RLS phải phân quyền nghiêm ngặt dựa theo vai trò của user thông qua hàm `get_current_user_role()` hoặc logic phân quyền hệ thống.
    *   **Secret ở Vault:** Các khóa API (như `RESEND_API_KEY`) phải được lưu trữ trong Supabase Vault hoặc biến môi trường Vercel. Tuyệt đối không hardcode key trong code nguồn hoặc lưu ở các bảng cấu hình công khai.
    *   **Sổ cái bất biến (Immutable Ledger):** Bảng `inventory_transactions` là bất biến. Cấm sử dụng lệnh `UPDATE` hoặc `DELETE` đối với các bút toán lịch sử. Sửa sai bắt buộc phải dùng bút toán đảo (reversal transaction) kèm lý do rõ ràng. Bảng `audit_log` là append-only, cấm chỉnh sửa kể cả với tài khoản Admin.
    *   **Idempotency (Chống trùng lặp):** Đảm bảo mỗi giao dịch (import POS, GRN, Issue...) chỉ được thực thi một lần duy nhất. Thiết lập unique index/constraint (ví dụ: chống trùng `file_hash` của POS, unique ref index) để ngăn chặn việc chạy lại trigger làm trừ kho hai lần.
    *   **Effective-Dating:** Các cấu hình tài chính nhạy cảm phải được quản lý theo dạng lịch sử hiệu lực (`app_settings_history` có `valid_from` và `valid_to`) để số liệu báo cáo trong quá khứ không bị thay đổi khi cập nhật cài đặt mới.
    *   **Bảo mật tài chính:** Số liệu giá vốn (WAC), giá trị tồn kho, food cost và các card tài chính chỉ cho phép vai trò `Owner/CFO/Admin` đọc. Các vai trò khác (Thủ kho, Chef, Bar) bị chặn truy cập dữ liệu tiền tệ ngay tại tầng database (RLS/Views), không chỉ ẩn trên UI.
    *   **UoM chuẩn hóa:** Đơn vị tính (UoM) phải được chuẩn hóa trước khi ghi vào kho (ví dụ: kg, L, chai, lon...).

## 7. Tự động hóa tầng DB & Tiết kiệm chi phí
**Tận dụng tối đa tài nguyên PostgreSQL có sẵn để xử lý logic dữ liệu nhằm tối ưu hóa chi phí vận hành.**
Hạn chế sử dụng tài nguyên compute của Vercel (Edge Functions) để làm những việc database có thể làm tốt hơn và rẻ hơn.
*   **Hành động cụ thể:**
    *   Ưu tiên sử dụng trigger và pg_cron kết hợp pg_net để thực hiện các tác vụ tự động hóa (chốt kỳ, tính WAC, gửi email qua Resend). Xem chi tiết tại tệp [/CRON_TuDongHoa_MaisonVie.sql](file:///d:/Invenroty/maison-vie-crm/CRON_TuDongHoa_MaisonVie.sql).
    *   Tuyệt đối **KHÔNG** sử dụng cơ chế Polling liên tục từ phía Client Next.js để làm tươi số liệu. Tận dụng cơ chế realtime của Supabase hoặc sử dụng triggers khi có thay đổi trạng thái.
    *   Tồn kho phải được cập nhật thời gian thực (perpetual stock) ngay khi có bút toán mới được tạo. Ranh giới cutoff 04:00 chỉ dùng để gom kỳ báo cáo, không cản trở số tồn sống của bộ phận đặt hàng.

## 8. Tôn trọng "nguồn sự thật" & quyết định đã khóa
**Tuân thủ tuyệt đối các file kế hoạch tổng và các quyết định kỹ thuật/nghiệp vụ đã chốt.**
Tránh việc tự ý đảo lộn các quyết định gây lãng phí tài nguyên và làm sai lệch logic nghiệp vụ của nhà hàng.
*   **Hành động cụ thể:**
    *   Các quyết định kỹ thuật tại **§11 — Sổ quyết định đã khóa** trong [KE_HOACH_v3.0.md](file:///d:/Invenroty/maison-vie-crm/KE_HOACH_v3.0.md) là ràng buộc tối cao. Cụ thể:
        *   **UUID làm PK + Code sửa được:** Cột `id` của nguyên liệu phải là UUID (primary key), trường `code` (SKU) có thể chỉnh sửa được và được quản lý bằng ràng buộc duy nhất.
        *   **Cơ chế trừ kho (`deduction_type`):** Món ăn phải được phân loại rõ ràng thành `DIRECT` (trừ thẳng nguyên liệu khi bán), `RECIPE` (trừ theo định mức công thức BOM), và `NON_STOCK` (không quản lý kho như phí dịch vụ).
        *   **POS là chuẩn doanh số:** POS file là nguồn sự thật cho doanh số bán ra. Nhập tay chỉ dùng bổ sung món không có trong POS hoặc ghi đè có lý do.
        *   **Phân tầng duyệt PO:** Đơn hàng mua có giá trị ≥ 10.000.000đ bắt buộc phải qua luồng Admin/Owner phê duyệt.
        *   **3 Vùng Kho:** Hệ thống chỉ quản lý 3 vị trí kho/điểm tồn bao gồm: Kho chính (`MAIN_STORE`), Bếp (`KITCHEN`), Bar (`BAR`).
        *   **Closed Inventory:** Chốt kỳ vật chất hóa snapshot theo Ngày/Tuần/Tháng/Quý/Năm. Sau khi chốt kỳ thì **KHÓA** cấm ghi lùi ngày, nếu mở lại phải lưu version mới kèm lý do và người thực hiện.
        *   **Mô hình "Chai riêng":** Nguyên liệu dùng chung (như vang nấu bếp, cognac đốt) phải theo dõi tồn riêng theo từng location (`BAR` và `KITCHEN`). Mỗi bên tự đặt hàng theo min/max riêng. Việc gắn nhãn dùng chung phải được Bếp trưởng và Bar trưởng đồng duyệt. Chuyển kho nội bộ (`TRANSFER`) là ngoại lệ và được ghi vết rõ ràng.
        *   **Wastage Buffer +10%:** Giữ nguyên buffer 10% tiêu hao trong công thức lý thuyết, hiển thị song song **Variance Thô** và **Variance sau buffer (+10%)** trên UI để tránh bị "mù" thất thoát thật.
    *   Nếu phát hiện điểm bất hợp lý hoặc xung đột logic, AI Agent phải lập tức đề xuất phương án và xin ý kiến xác nhận từ người dùng, tuyệt đối không được tự ý chỉnh sửa ngầm.

---

## CẤU TRÚC THƯ MỤC DỰ ÁN (PROJECT STRUCTURE)

Mọi tệp tin mã nguồn và SQL phải được đặt đúng vị trí theo sơ đồ cấu trúc thực tế dưới đây:

*   **Tệp tin cấu hình và hướng dẫn tại gốc repo:**
    *   `/CLAUDE.md`: Hướng dẫn vận hành AI Agent (tệp này).
    *   `/AGENTS.md`: Quy tắc Next.js cho AI Agent.
    *   `/KE_HOACH_v3.0.md`: Kế hoạch tổng v3.0 (Chứa các quyết định đã khóa tại §11).
    *   `/IMPLEMENTATION_PLAN_v9.6.md`: Kế hoạch triển khai v9.6 chi tiết.
    *   `/SPEC_NhapTay_Unmapped_v9-4.md`: Đặc tả xử lý hàng bán chưa có công thức và nhập liệu thủ công.
    *   `/v9-6_01_schema.sql`: File SQL schema bổ sung v9.6.
    *   `/v9-6_02_uuid_code_migration.sql`: File SQL di chuyển id nguyên liệu sang UUID.
    *   `/CRON_TuDongHoa_MaisonVie.sql`: Cấu hình pg_cron tự động hóa tầng DB.
    *   `package.json`, `next.config.ts`, `postcss.config.mjs`, `eslint.config.mjs`, `vercel.json`, `tsconfig.json`: Các tệp cấu hình dự án.
*   **`/supabase/`**: Thư mục quản lý Cơ sở dữ liệu Supabase.
    *   `/supabase/migrations/`: Các file migration được quản lý bởi Supabase CLI (ví dụ: [20260619063107_remote_commit.sql](file:///d:/Invenroty/maison-vie-crm/supabase/migrations/20260619063107_remote_commit.sql)).
    *   `/supabase/schema.sql`: Schema cơ sở dữ liệu hiện tại.
    *   `/supabase/seed.sql`: Dữ liệu seed phục vụ môi trường local/test.
    *   `/supabase/functions.sql`: Các hàm stored procedures nghiệp vụ chính.
    *   `/supabase/migrations_v9.6_triggers.sql`: Triggers tự động tính toán tồn và giá vốn.
    *   Các tệp patch SQL sửa lỗi và nâng cấp (ví dụ: `patch_v3_0_1_stock_depletion.sql`, `patch_v3_0_4_po_chef_rls.sql`...).
*   **`/src/`**: Thư mục mã nguồn ứng dụng Next.js.
    *   `/src/app/`: Các tuyến đường (routes), bố cục (layouts) và styles.
        *   `/src/app/page.tsx`: Giao diện Dashboard hợp nhất của quản trị.
        *   `/src/app/bar/`: Workspace riêng cho bộ phận Bar.
        *   `/src/app/globals.css`: Tệp cấu hình CSS toàn cục (chứa các thiết kế màu sắc teal sâu, brass trầm...).
        *   `/src/app/components/`: Thư mục chứa các component giao diện React.
            *   [ClosedInventory.tsx](file:///d:/Invenroty/maison-vie-crm/src/app/components/ClosedInventory.tsx): Quản lý báo cáo đóng kỳ.
            *   [ManualForms.tsx](file:///d:/Invenroty/maison-vie-crm/src/app/components/ManualForms.tsx): Form nhập liệu thủ công (GRN, Issue, Sale).
            *   [PurchasingModule.tsx](file:///d:/Invenroty/maison-vie-crm/src/app/components/PurchasingModule.tsx): Quản lý quy trình đặt hàng và duyệt PO.
            *   [StockAlertPanel.tsx](file:///d:/Invenroty/maison-vie-crm/src/app/components/StockAlertPanel.tsx): Bảng cảnh báo tồn kho tối thiểu.
            *   [UniversalSearch.tsx](file:///d:/Invenroty/maison-vie-crm/src/app/components/UniversalSearch.tsx): Ô tìm kiếm nguyên liệu thông minh (sử dụng pg_trgm).
    *   `/src/lib/`: Các hàm tiện ích chung và hook kết nối Supabase client.
        *   [supabaseClient.ts](file:///d:/Invenroty/maison-vie-crm/src/lib/supabaseClient.ts): Khởi tạo Supabase client.
        *   [useRealtimeBadges.ts](file:///d:/Invenroty/maison-vie-crm/src/lib/useRealtimeBadges.ts): Custom hook đồng bộ realtime trạng thái cảnh báo.
        *   [useWebPush.ts](file:///d:/Invenroty/maison-vie-crm/src/lib/useWebPush.ts): Custom hook xử lý thông báo đẩy.
    *   `/src/data/`: Chứa các dữ liệu giả lập và snapshot.
        *   [db.json](file:///d:/Invenroty/maison-vie-crm/src/data/db.json): File dữ liệu thô phục vụ kiểm thử.
        *   [mockData.ts](file:///d:/Invenroty/maison-vie-crm/src/data/mockData.ts): Các hàm sinh mock data cho frontend.

---

## NHẬT KÝ QUYẾT ĐỊNH NGUYÊN TẮC

Dưới đây là lý do giữ/điều chỉnh/loại bỏ 4 nguyên tắc gốc trong tài liệu tham khảo CLAUDE.md của Andrej Karpathy:

1.  **Think Before Coding (Giữ nguyên và thắt chặt):**
    *   *Lý do:* Hệ thống CRM/Inventory này là một hệ tài chính - kho chạy trực tiếp trên Production. Mọi hành vi sửa đổi schema hay truy vấn sai cấu trúc cột sẽ dẫn đến lỗi hệ thống ngay lập tức, ảnh hưởng trực tiếp đến hoạt động mua hàng và quản lý giá vốn của nhà hàng. Việc thắt chặt nguyên tắc này bắt buộc AI Agent phải đọc schema thực tế trước khi code.
2.  **Surgical Changes (Giữ nguyên):**
    *   *Lý do:* Giúp giảm thiểu rủi ro phát sinh lỗi phụ (side-effects) và duy trì tính ổn định tối đa cho luồng tích hợp CI/CD tự động của dự án (GitHub ↔ Vercel ↔ Supabase). Refactor vô căn cứ sẽ làm thay đổi cấu trúc dữ liệu hoặc cơ chế RLS hiện hữu.
3.  **Simplicity First (Điều chỉnh thành "Simplicity First - With Conditions"):**
    *   *Lý do:* Đối với hệ thống tài chính - kho, sự "đơn giản" tuyệt đối của code nguồn không được phép đánh đổi bằng việc loại bỏ các chốt chặn an toàn dữ liệu như RLS, Audit log, Idempotency và Effective-dating. Do đó, nguyên tắc này được điều chỉnh để vừa giữ code tinh gọn, vừa bảo toàn tính toàn vẹn của dữ liệu.
4.  **Goal-Driven Execution (Giữ nguyên):**
    *   *Lý do:* Quy trình kiểm thử và nghiệm thu rõ ràng trên các chi nhánh phát triển (development branches) giúp đảm bảo chất lượng đầu ra, hạn chế tối đa việc đẩy lỗi lên môi trường Production.
