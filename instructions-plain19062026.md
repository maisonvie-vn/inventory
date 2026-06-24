# 📋 NHẬT KÝ CÔNG VIỆC — 19/06/2026
## Hệ thống: Maison Vie Inventory CRM
**URL production:** https://inventory-six-sigma.vercel.app/
**Repo:** https://github.com/maisonvie-vn/inventory

---

## 🐛 BUG FIXES

### 1. Vercel Build Error — `periodRange` used before declaration
**Lỗi:**
```
Type error: Block-scoped variable 'periodRange' used before its declaration.
  140 |   }, [periodRange.startStr, periodRange.endStr]);
```
**File:** `src/app/components/ClosedInventory.tsx`
**Root cause:** Hook `useEffect` dependency array tham chiếu `periodRange` trước khi biến được khai báo.
**Fix:** Reorder khai báo `periodRange` lên trước `useEffect`.

---

### 2. Supabase Schema Error — bảng `inventory_period_close` không tồn tại
**Lỗi:**
```
Could not find the table 'public.inventory_period_close' in the schema cache
```
**Fix:** Tạo script migration `supabase/create_period_close_tables.sql` để tạo 2 bảng còn thiếu:
- `inventory_period_close`
- `inventory_snapshots`

---

### 3. Toàn bộ hàng nhập bị "đóng băng" — 333 transactions kẹt ở `status='posted'`

**Triệu chứng:** User báo không thấy tồn kho, rất nhiều mặt hàng (đặc biệt rượu vang) không hiển thị số lượng đúng.

**Điều tra:**
- Kiểm tra DB: bảng `goods_receipt_items` → không tồn tại
- Bảng thực tế dùng là `grn_lines` → tồn tại nhưng TRỐNG (0 rows)
- Tìm thấy **333 IMPORT transactions** với `status='posted'` thay vì `'approved'`
- Hàm RPC `get_period_stock_summary` chỉ tính các transactions có `status='approved'`

**Root cause:** Script import lịch sử (`fix_production4.js`) đã insert transactions với `status='posted'` thay vì `'approved'`:
```javascript
// Dòng lỗi trong fix_production4.js
VALUES ($1, 'IMPORT', $2, $3, $4, $5, 'grn', $6, 'posted', $7)
//                                                   ^^^^^^^^ phải là 'approved'
```

**Fix:** Chạy lệnh update trực tiếp lên Supabase production:
```sql
UPDATE inventory_transactions
SET status = 'approved'
WHERE status = 'posted'
AND txn_type = 'IMPORT'
RETURNING id;
-- Kết quả: 333 rows updated ✅
```

**Kết quả sau fix — ví dụ V6027 Luis Felipe Chardonnay:**
| | Số lượng |
|---|---|
| Tồn đầu kỳ (31/05) | 122.2 chai |
| Nhập kho (01/06) | 123.0 chai |
| Xuất | 0.14 chai |
| **Tồn hiện tại** | **245.06 chai** ✅ |

---

### 4. Kiểm tra & Xác nhận dữ liệu nhập kho Excel

**File đã import:** `D:\Invenroty\hàng nhập 1-14.06.26.xlsx`
- 66 mặt hàng
- 5 phiếu GRN (INV-0602-AN đến INV-0606-AN)
- Tổng giá trị: **161,312,797 đ**
- Ngày business: 01/06/2026
- Trạng thái: ✅ Đã import đầy đủ vào DB

---

## ✨ TÍNH NĂNG MỚI — SEARCH COMBOBOX

Thay toàn bộ `<select>` dropdown bằng ô **tìm kiếm thông minh** tại **5 vị trí** trong giao diện nhập liệu thủ công.

### Cách hoạt động:
- Gõ **mã** (V6027, B5001, R1001...) hoặc **tên** nguyên liệu/món ăn
- Lọc realtime, hiển thị tối đa **8 kết quả** phù hợp
- Mỗi dòng gợi ý: `[MÃ CODE]  Tên  [ĐVT hoặc Giá]`
- Sau khi chọn: hiện `✓ Đã chọn: [mã]` xác nhận bên dưới ô
- Sau khi thêm dòng / submit: combobox tự **reset về trống**

### Vị trí đã thêm:

| # | Form | Label | State | Data source |
|---|---|---|---|---|
| 1 | Nhập Doanh Số Thủ Công | Chọn món | `selManualSaleCode` | `recipes` (kèm giá) |
| 2 | Khai Báo Tiêu Thụ Ngoài (NON-SALE) | Chọn nguyên liệu | `nonSaleIngId` | `roleFilteredIngredients` |
| 3 | Lập Phiếu Nhập Kho Thủ Công (GRN) | Thêm dòng nguyên liệu | `selManualGrnIng` | `ingredients` (tự fill WAC price) |
| 4 | Xuất Kho Thủ Công | Chọn nguyên liệu | `selManualIssueIng` | `ingredients` |
| 5 | Chuyển Kho Nội Bộ (Internal Transfer) | Chọn nguyên liệu chuyển | `internalTransferIngId` | `roleFilteredIngredients` |

### State variables mới thêm vào `page.tsx`:
```typescript
const [saleSearchText, setSaleSearchText] = useState('');
const [nonSaleSearchText, setNonSaleSearchText] = useState('');
const [grnIngSearchText, setGrnIngSearchText] = useState('');
const [issueIngSearchText, setIssueIngSearchText] = useState('');
const [transferIngSearchText, setTransferIngSearchText] = useState('');
```

### Bonus fix khi làm combobox Chuyển kho:
- Bug cũ: sau khi submit chuyển kho, `internalTransferIngId` **không được reset**
- Đã fix: thêm `setInternalTransferIngId('')` vào handler

---

## 📦 COMMITS HÔM NAY

| Commit | Mô tả |
|---|---|
| `fce87b8` | feat: replace 3 select dropdowns with searchable comboboxes (sale/non-sale/GRN) |
| `fcdf53f` | feat: add search combobox for Xuat kho thu cong ingredient picker |
| `5be5acc` | feat: add search combobox for Chuyen kho noi bo ingredient picker |

---

## 📂 FILES ĐÃ SỬA

| File | Thay đổi |
|---|---|
| `src/app/page.tsx` | Thêm 5 search states; thay 5 `<select>` bằng combobox; fix reset issue |
| `src/app/components/ClosedInventory.tsx` | Fix periodRange declaration order |
| `supabase/create_period_close_tables.sql` | Tạo 2 bảng mới cho period close |
| `fix_production4.js` *(lỗi đã ghi nhận)* | Script cũ dùng `'posted'` thay vì `'approved'` |

---

## 🗄️ DB CHANGES (Production Supabase)

| Action | Chi tiết |
|---|---|
| UPDATE | 333 rows `inventory_transactions` → `status: 'posted'` → `'approved'` |
| CREATE TABLE | `inventory_period_close` |
| CREATE TABLE | `inventory_snapshots` |

---

## ⚠️ LƯU Ý CÒN LẠI

1. **Luis Felipe Chardonnay V6027:** Hệ thống đang ghi nhận **123 chai nhập** (01/06), không phải 100 chai. Cần xác nhận lại số thực tế nhập kho.

2. **`grn_lines` trống:** Bảng `grn_lines` tồn tại nhưng không có dữ liệu. 5 phiếu GRN hiện có đều có 0 dòng chi tiết. Hàng nhập được track qua `inventory_transactions` trực tiếp, không qua grn_lines.

3. **Không có trigger tự động:** Khi tạo phiếu GRN thủ công → `inventory_transactions` KHÔNG được tạo tự động. Cần code xử lý thêm trong `handleSaveManualGrn`.

4. **Tồn kho Caselletti Negroamaro Primitivo** và các loại rượu vang khác — sau fix 333 transactions, tất cả đã hiển thị. Nếu vẫn thiếu mặt hàng cụ thể nào, có thể ingredient đó chưa có trong `ingredients` master.
