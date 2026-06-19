# KẾ HOẠCH TỔNG **v3.0 — PRODUCTION · FINAL (ĐÓNG BĂNG 17/06)** · MAISON VIE INVENTORY/ERP
> Bản đóng băng để build. Mọi quyết định trong §11 là RÀNG BUỘC — không sửa lại.
### Hợp nhất & nâng cấp dòng v9.x lên chế độ vận hành thật. Chi tiết schema xem các file đồng hành (IMPLEMENTATION_PLAN_v9.6.md, v9-6_*.sql, SPEC_NhapTay_Unmapped_v9-4.md, CRON_*.sql).

---

## 0. HIẾN CHƯƠNG PRODUCTION
Hệ đã đồng bộ GitHub ↔ Vercel ↔ Supabase và **đang chạy thật để quản lý** — không còn thử nghiệm. Mọi việc từ đây phải: **đồng bộ, an toàn, không sửa đi sửa lại, tự động hóa ở tầng cơ sở dữ liệu, bảo mật ở mức cao nhất, và tận dụng gói trả phí (Supabase Pro/Vercel Pro) — không lãng phí tài nguyên đã trả tiền.**

## 1. SÁU NGUYÊN TẮC BẤT DI BẤT DỊCH
1. **Tự động hóa tầng DB:** triggers + pg_cron + pg_net. Không polling client, không tính tay.
2. **Bảo mật tối đa:** RLS 100% bảng + policy theo vai trò; secret chỉ ở Vault/env; audit mọi thay đổi.
3. **Sổ cái bất biến:** sửa = bút toán đảo; `audit_log` append-only.
4. **Idempotent:** không trùng bút toán (unique ref index).
5. **Effective-dated** cấu hình tài chính · **soft-delete** · **UoM chuẩn hóa**.
6. **Không rework:** plan + xác nhận trước; chạy trên Branch; migration có checkpoint.

## 2. TỰ ĐỘNG HÓA HOÀN TOÀN CÁC BÚT TOÁN *(mới — yêu cầu cốt lõi)*
**Người dùng chỉ NHẬP; hệ TÍNH.** Mọi đầu vào đã ghi DB → trigger/cron tự kéo theo hệ quả:

| Đầu vào (người nhập) | Hệ quả TỰ ĐỘNG (DB) |
| :-- | :-- |
| POS import / Bán thủ công | trừ kho theo deduction_type (DIRECT/RECIPE/BOM nhiều tầng) · FEFO lô · trừ bao bì takeaway · ghi doanh thu · dòng lạ → Unmapped |
| Nhận hàng (GRN) / Nhập tay | nhập kho · tạo lô · cập nhật Moving WAC · PPV cảnh báo |
| Xuất kho thủ công | định tuyến theo lý do (waste/non-sale/transfer/production) · txn OUT |
| Định mức / Công thức | dùng ngay cho lần trừ kho kế · reprocess dòng Unmapped đã treo |
| Sản xuất BTP | inputs OUT · BTP IN @ giá mẻ · nuôi WAC BTP |
| Kiểm kê (đã duyệt) | post điều chỉnh · variance |
| *(cron định kỳ)* | reorder/min-stock · low-stock · expiry · PO aging · báo cáo · partition tháng |

**Bất biến con người (không thể auto, theo thiết kế):** đếm kiểm kê thực tế, bảo trì công thức/ánh xạ, xác nhận nhận hàng, **duyệt PO**. "Tự động hóa hoàn toàn" = **phần TÍNH TOÁN 100% tự động**; các đầu vào trên là con người-cố-ý.

## 3. SEARCH TOÀN HỆ *(mới)*
Mọi module/tab/form có ô **tìm sản phẩm theo TÊN hoặc MÃ** (autocomplete, gồm alias POS), index **pg_trgm** chịu lỗi gõ. Bắt buộc ở: nhập tay (Sale/GRN/Issue), công thức, PO, kiểm kê, báo cáo, danh mục.

## 4. BÁO CÁO TỒN KHO ĐÓNG KỲ — "CLOSED INVENTORY" *(mới)*
**Kỳ:** Ngày / Tuần / Tháng / Quý / Năm. **Nội dung mỗi mặt hàng:** Tồn đầu + Nhập − Xuất = **Tồn cuối**, theo **SL và GIÁ TRỊ (WAC)**; lọc theo mặt hàng/nhóm/bộ phận/kho; kèm variance + **tổng giá trị tài sản tồn**. Bao gồm **NVL thô + BTP + bao bì**. **Xuất Excel/PDF.**
**Kỹ thuật:** materialize **snapshot cuối kỳ** (nhanh, không quét lại toàn lịch sử) + **khóa kỳ đã đóng** (cấm post lùi ngày). Tôn trọng timezone + giờ chốt ngày (settings §17.5).
```sql
create table if not exists inventory_snapshots (
  period_type text check (period_type in ('DAY','WEEK','MONTH','QUARTER','YEAR')),
  period_end date, ingredient_id uuid references ingredients(id),
  opening_qty numeric, in_qty numeric, out_qty numeric, closing_qty numeric,
  wac_at_close numeric, closing_value numeric,
  locked boolean default false, created_at timestamptz default now(),
  primary key (period_type, period_end, ingredient_id)
);
```

## 5. BẢN ĐỒ MODULE (đã chốt — chi tiết ở v9.6)
Ledger/WAC & locations (§1) · deduction_type DIRECT/RECIPE/NON_STOCK (§16) · Unmapped worklist + nhập tay Sale/GRN/Issue (§14, SPEC) · non_sale_consumption (§17.2) · PO + cổng duyệt + days-of-cover (§17.3) · min-stock derived + mùa vụ (§17.4) · Settings 3 vùng effective-dated, chỉ Admin/Owner (§17.5) · Lô/FEFO/truy vết (§19.1) · Yield/trim (§19.2) · Sản xuất BTP/BOM nhiều tầng (§19.3) · NCC + giá + PPV (§19.4) · Kiểm kê có duyệt (§19.5) · Giá kép + bao bì (§12) · Dashboard + lọc bộ phận (§4/§C.6) · uuid PK + code sửa được (§17.1).

## 6. BẢO MẬT & CHI PHÍ
- **RLS** 100% + policy vai trò; **audit_log append-only** (RLS cấm update/delete kể cả admin).
- **Secret ở Vault**; UI chỉ hiện "đã cấu hình ✓".
- **Tự động hóa = pg_cron + trigger** (đã trả phí Supabase Pro) — KHÔNG dựng server polling tốn Vercel function vô ích.
- **Tăng trưởng dữ liệu:** partition `inventory_transactions` theo tháng; retention dọn file Excel thô (Storage) định kỳ.
- **Sao lưu:** Supabase Pro daily backup + PITR — **phải DIỄN TẬP restore ít nhất 1 lần** (backup chưa test = chưa có backup).

## 7. QUẢN TRỊ DỮ LIỆU
Sổ cái bất biến (reversal) · audit (ai/khi/cũ→mới) · effective-dating tài chính · soft-delete · **khóa kỳ sau khi đóng** · idempotency.

## 8. CHANGE MANAGEMENT (chống rework)
Đổi schema prod → qua **Supabase Branch** → migration review có checkpoint → mới merge. Không sửa trực tiếp prod. Mọi quyết định đã chốt là ràng buộc.

## 9. NGHIỆM THU PRODUCTION
Người dùng chỉ nhập → mọi bút toán/báo cáo tự chạy ở DB · RLS+audit+Vault đủ · Closed Inventory đủ 5 kỳ + xuất file · search mọi nơi · không trùng bút toán · không secret trong code/DB · kỳ đóng được khóa · chạy gọn trong gói hiện tại.

## 10. CÂU HỎI MỞ CẦN CHỐT
(Xem 13 câu hỏi phản biện trong tin nhắn kèm — cần trả lời trước khi Antigravity build, để không phải làm lại.)

---

## 11. SỔ QUYẾT ĐỊNH ĐÃ KHÓA (v3.0 FINAL) — ràng buộc khi build

### A. Tồn kho & tính toán
- **Tồn kho THỜI GIAN THỰC (perpetual):** mỗi bút toán (tay/import) cập nhật `current_stock` + WAC **ngay lập tức**. Ranh giới **04:00** chỉ để gom kỳ/chốt báo cáo, **không cản số tồn sống** (nhập 22:00 phải thấy tồn ngay cho Purchasing).
- **Tồn âm:** cho phép + **gắn cờ** + đẩy vào **WORKLIST TỒN ÂM**; có luồng **"mua ngoài / nhập bù" nhanh** để đóng âm sớm.
- **Guard-rail gõ nhầm:** số nhập lệch **>3× trung bình gần đây** → **bắt xác nhận** trước khi ghi (chống đầu độc WAC/tồn tức thời).

### B. Bán hàng & nguồn dữ liệu
- **POS file là CHUẨN cho doanh số.** Nhập tay chỉ **bổ sung món KHÔNG có trong POS**, hoặc override nhưng **bắt lý do**.
- Cùng **món × ngày** có 2 nguồn (POS + tay) → **hỏi xác nhận** trước khi ghi (chống trùng).
- Món lạ chưa công thức → **tab Unmapped** (không bỏ qua âm thầm).

### C. Closed Inventory & chốt kỳ
- **Snapshot tháng vật chất hóa** + on-the-fly trong kỳ đang mở; **WAC chốt cứng** tại kỳ.
- **Đóng kỳ = Owner/CFO bấm tay**, chạy **checklist tiền-đóng** (liệt kê Unmapped / kiểm kê chưa duyệt / PO mở).
- Sau đóng: **KHÓA**, cấm post/sửa ngày trước; **chỉ Admin/Owner mở lại**.
- **Mở lại = VERSIONED** (v1/v2 + lý do + ai + khi nào), giữ bản gốc.
- Kỳ: **Ngày/Tuần/Tháng/Quý/Năm**; gồm **NVL thô + BTP + bao bì**; xuất **Excel/PDF**. Đầu năm tài chính **01/01**.
```sql
create table if not exists inventory_period_close (
  period_type text, period_end date, version int,
  status text default 'CLOSED' check (status in ('OPEN','CLOSED')),
  closed_by uuid, closed_at timestamptz default now(),
  reopened_by uuid, reopen_reason text,
  primary key (period_type, period_end, version)
);
create or replace view v_negative_stock as
  select id, code, name, current_stock from ingredients where current_stock < 0;
```

### D. Bảo mật & phân quyền
- **Giá trị/giá vốn: chỉ Owner/CFO xem; chặn ở TẦNG DỮ LIỆU (RLS/view)**, không chỉ ẩn UI. Bộ phận khác **chỉ xem số lượng**.
- **`audit_log` APPEND-ONLY:** không ai (kể cả Owner) update/delete. Sửa sai = **bút toán đảo có lý do** (giữ gốc + đè bản sửa, cả hai đều thấy).
- Secret chỉ ở **Vault**; **RLS 100%** bảng.
- **Concurrency: quyền cao hơn THẮNG.**

### E. Cảnh báo
- **In-app theo KHU VỰC** (manager/bar/bếp thấy của mình; Owner thấy tất cả) + **email CHỈ admin** (Resend). Không escalate thêm.

### F. Tìm kiếm
- Mọi module: tìm theo **TÊN + MÃ + MÃ NCC** (autocomplete).

### G. Giá trị cấu hình (nằm trong settings, sửa được)
- **Ngưỡng duyệt PO: ≥ 10.000.000đ → admin duyệt.**
- **Kho/điểm tồn: Kho chính / Bếp / Bar** (chỉ 3).
- **VND: số nguyên đồng, không thập phân** (vd 1.000.000).
- **Lead time mặc định 3 ngày × hệ số an toàn 1.5** (tinh chỉnh từng món sau).
- **Email Resend:** domain Google Workspace của chủ — **tự verify SPF/DKIM**.

### H. Hạ tầng
- Tự động hóa = **pg_cron + trigger** (Supabase Pro), **không polling Vercel** tốn phí.
- **Partition tháng** `inventory_transactions`; retention dọn file thô Storage.
- **DR: diễn tập restore 1 lần + runbook** (chưa từng restore).

---
*v3.0 FINAL — đóng băng để build. 21 quyết định (13+8 phản biện + 5 cấu hình) đã khóa.*
