# HOTFIX — Lọc Dashboard theo bộ phận (Bar/Bếp)
### Sửa lỗi: panel "Cảnh báo Tồn kho tối thiểu" vẫn hiện đồ Bếp khi đang ở vai trò Bar

---

## 1. Nguyên nhân (chẩn đoán từ ảnh Lỗi_04)
- Panel **"Cảnh báo Tồn kho tối thiểu"** đang lấy danh sách từ **mảng `ingredients` tổng**, KHÔNG qua bộ lọc bộ phận.
- Bằng chứng: ở vai trò **Bar**, panel vẫn hiện cá tuyết/cá vược/tôm/cá hồi (đồ Bếp), tất cả `Tồn 0.00 kg → LOW STOCK`.
- Đối chiếu: **Bảng Master Kho đã lọc đúng** (ẩn đồ Bếp ở Bar) ⇒ chứng tỏ panel cảnh báo (và rất có thể cả chart tiêu hao) **không dùng** `roleFilteredIngredients`.
- Tóm lại: bug **không phải** ở dữ liệu, mà ở chỗ panel này **bỏ qua bộ lọc** đã có sẵn.

---

## 2. Sửa tối thiểu — cho MỌI panel Dashboard dùng chung 1 danh sách đã lọc

### Bước 1 — Mỗi nguyên liệu phải có nhãn bộ phận
```ts
type Ingredient = {
  id: string; code: string; name: string;
  currentStock: number; minStock: number;
  departments: ('BAR' | 'KITCHEN')[];   // mã dùng chung: ['BAR','KITCHEN']
  // ...
};
```

### Bước 2 — Map vai trò → bộ phận, và 1 danh sách lọc dùng chung
```ts
const roleToDept = (role: string): 'BAR' | 'KITCHEN' | null =>
  (role === 'BAR_SUPERVISOR' || role === 'Bar')        ? 'BAR'
  : (role === 'restaurant_manager')                    ? 'KITCHEN'  // Chef/Manager/Thủ kho
  : null;  // Owner/CFO/Admin & senior_accountant: thấy tất cả

const dept = roleToDept(currentRole);

const roleFilteredIngredients = useMemo(
  () => ingredients.filter(i => dept === null || i.departments.includes(dept)),
  [ingredients, dept]
);
```

### Bước 3 — ĐIỂM SỬA CỐT LÕI: panel cảnh báo & chart phải bắt nguồn từ `roleFilteredIngredients`
```ts
// ❌ TRƯỚC (gây bug): tính trên TOÀN BỘ ingredients
// const lowStock = ingredients.filter(i => i.currentStock <= i.minStock);

// ✅ SAU: tính trên danh sách ĐÃ LỌC theo bộ phận
const lowStockAlerts = useMemo(
  () => roleFilteredIngredients.filter(i => i.currentStock <= i.minStock),
  [roleFilteredIngredients]
);

// Chart "Nguyên liệu tiêu hao nhiều nhất" cũng phải lọc theo bộ phận:
const topConsumption = useMemo(
  () => consumption.filter(c =>
        roleFilteredIngredients.some(i => i.id === c.ingredientId)),
  [consumption, roleFilteredIngredients]
);
```

---

## 3. Checklist các surface PHẢI dùng `roleFilteredIngredients` (không bỏ sót)
- [x] Bảng Master Kho — *đã đúng*
- [x] Kiểm kho & Cân — *đã đúng*
- [x] **Panel "Cảnh báo Tồn kho tối thiểu"** ← **Hoàn thành (Đã lọc theo lowStockIngredients)**
- [x] **Chart + bảng "Nguyên liệu tiêu hao nhiều nhất"** ← **Hoàn thành (Đã lọc theo roleFilteredConsumptionData)**
- [x] Card tổng quan (Cost / Giá trị tồn / Variance) — khi vai trò là Bar thì số liệu cũng chỉ tính phần Bar ← **Hoàn thành (Đã lọc theo roleFilteredIngredients & roleFilteredConsumptionData cho 4 vai trò quản lý)**
- [x] Form Chuyển kho nội bộ & Tiêu hao ngoài bán hàng — *đã đúng theo §9.2, rà lại*

---

## 4. Lưu ý dữ liệu
- **Mã dùng chung** (Cognac, vang nấu, cam/chanh) gắn `departments: ['BAR','KITCHEN']` → vẫn hiện ở **cả hai** bộ phận, đúng quyết định **"chai riêng"** (tồn theo từng location, min/max riêng).
- Mấy mã đang **"0.00 kg"**: đây là đồ Bếp (ING-003..007) — sau khi lọc đúng, ở vai trò Bar chúng **phải biến mất** khỏi panel cảnh báo.
- Nhớ rà cả ngưỡng `minStock` theo **location**: Cognac ở Bar và ở Bếp có ngưỡng khác nhau (Bếp ít hơn).

---

## 5. Câu lệnh giao cho công cụ code (Claude Code / Cursor / dev)
> "Trong component Dashboard/Overview: panel **'Cảnh báo Tồn kho tối thiểu'** và chart/bảng **'Nguyên liệu tiêu hao nhiều nhất'** hiện đang lấy dữ liệu từ mảng `ingredients` tổng. Hãy đổi cho chúng lấy từ `roleFilteredIngredients` (đã lọc theo bộ phận của vai trò đăng nhập). Nếu `Ingredient` chưa có field `departments: ('BAR'|'KITCHEN')[]` thì thêm vào, và bổ sung hàm `roleToDept(role)` map vai trò sang bộ phận. Mã dùng chung gán cả hai bộ phận. Owner/CFO/Admin giữ nguyên thấy tất cả."

---

## 6. Cách tự kiểm tra sau khi sửa (acceptance)
1. Đăng nhập **Bar** → panel cảnh báo **chỉ** còn rượu/bia/đồ uống (+ mã dùng chung); **không** còn cá/tôm.
2. Đăng nhập **Bếp** → panel cảnh báo có đồ bếp **và** mã dùng chung (vang nấu, cognac); **không** có cocktail/bia bán.
3. Đăng nhập **Owner/CFO/Admin** → thấy **tất cả** (đúng thiết kế).
4. Chart "tiêu hao nhiều nhất" đổi danh sách tương ứng theo từng vai trò.
