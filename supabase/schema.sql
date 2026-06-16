-- MAISON VIE INVENTORY & CRM DATABASE SCHEMA **v8.0**
-- Target Database: PostgreSQL (Supabase)
-- Author: Full-Stack Data Architect / CFO / COO

-- Clean up existing tables and views if they exist (ordered by dependencies)
drop view if exists v_inventory_finance cascade;
drop view if exists v_inventory_cost cascade;
drop view if exists v_inventory_ops cascade;

drop table if exists audit_log cascade;
drop table if exists daily_close cascade;
drop table if exists stock_take_lines cascade;
drop table if exists stock_takes cascade;
drop table if exists pos_alias_map cascade;
drop table if exists non_sale_consumption cascade;
drop table if exists lots cascade;
drop table if exists grn_lines cascade;
drop table if exists goods_receipts cascade;
drop table if exists po_lines cascade;
drop table if exists purchase_orders cascade;
drop table if exists waste_logs cascade;
drop table if exists sales_imports cascade;
drop table if exists inventory_transactions cascade;
drop table if exists recipes cascade;
drop table if exists set_menu_items cascade;
drop table if exists menu_items cascade;
drop table if exists supplier_ingredients cascade;
drop table if exists suppliers cascade;
drop table if exists ingredients cascade;
drop table if exists purchase_categories cascade;
drop table if exists uom_conversions cascade;
drop table if exists uom cascade;
drop table if exists profiles cascade;

-- ==========================================
-- 1. PROFILES & ROLE-BASED ACCESS CONTROL (RBAC)
-- ==========================================

create table profiles (
    id uuid references auth.users(id) on delete cascade primary key,
    username varchar(100) not null,
    full_name varchar(255),
    role varchar(50) not null check (role in (
        'admin',              -- Cấp 1: Toàn quyền, CFO, Owner
        'restaurant_manager', -- Cấp 2: Quản lý nhà hàng, duyệt waste lớn
        'head_chef',          -- Cấp 3: Bếp trưởng, quản lý recipes & yield
        'senior_accountant',  -- Cấp 4: Kế toán cấp cao, WAC, mapping, duyệt Auto-PO
        'foh_supervisor',     -- Cấp 5: Giám sát sảnh, xem menu & đối soát POS
        'sous_chef',          -- Cấp 6: Bếp phó, tạo Waste Log, Manual PO Requisition
        'junior_accountant'   -- Cấp 7: Thủ kho/kế toán phụ, nhập hóa đơn chờ duyệt
    )),
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table profiles enable row level security;

-- ==========================================
-- 2. MASTER DATA TABLES (UoM, Suppliers, Categories, Ingredients)
-- ==========================================

-- Đơn vị tính (UoM)
create table uom (
    id text primary key,          -- 'KG', 'G', 'L', 'ML', 'BOTTLE', 'CASE', 'PIECE'
    name text not null,
    uom_type text not null check (uom_type in ('WEIGHT', 'VOLUME', 'COUNT'))
);

alter table uom enable row level security;

-- Quy đổi đơn vị tính chuẩn toàn cục (Chỉ lưu tỷ lệ chuẩn cố định như KG->G, L->ML)
create table uom_conversions (
    from_uom text references uom(id) on delete cascade,
    to_uom text references uom(id) on delete cascade,
    factor numeric not null,          -- 1 from_uom = factor * to_uom
    primary key (from_uom, to_uom)
);

alter table uom_conversions enable row level security;

-- Nhóm hàng đặt/Nhóm thu mua
create table purchase_categories (
    id uuid default gen_random_uuid() primary key,
    code varchar(50) unique not null,          -- e.g., 'THIT', 'WINE', 'RAU_CU_KHO'
    name varchar(100) not null,                 -- e.g., 'Thịt tươi', 'Rượu vang', 'Rau củ & đồ khô'
    is_active boolean default true not null,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table purchase_categories enable row level security;

-- Bảng Nguyên Vật Liệu (Ingredients Master v8.0)
create table ingredients (
    id varchar(50) primary key,                 -- Mã NVL từ Excel, e.g., 'ING-011', 'ING-093'
    code varchar(50) unique not null,
    nom_fr varchar(255) not null,               -- Tên tiếng Pháp
    ten_vi varchar(255) not null,               -- Tên tiếng Việt
    name_en varchar(255),                       -- Tên tiếng Anh
    purchase_category_id uuid references purchase_categories(id) on delete set null,
    stock_uom text references uom(id) on delete set null,    -- ĐVT tồn kho chuẩn
    recipe_uom text references uom(id) on delete set null,   -- ĐVT dùng trong công thức
    stock_to_recipe_factor numeric not null default 1,        -- MỚI v8.0: Quy đổi Tồn -> Công thức (VD: 1 BOTTLE rượu = 750 ML, 1 quả trứng = 50 G)
    tare_weight_grams numeric default 0 not null,             -- MỚI v8.0: Trọng lượng vỏ chai rỗng (dành riêng cho rượu Bar dùng cân điện tử)
    tolerance_percent numeric default 5.0 not null,           -- MỚI v8.0: Ngưỡng sai lệch cho phép (%) khi đối soát Variance (tránh nhiễu gia vị)
    wac_price numeric(12, 2) default 0.00 not null,           -- Giá vốn WAC lũy tiến hiện tại (VND)
    standard_price numeric(12, 2) default 0.00 not null,      -- Giá nhập chuẩn gần nhất (VND)
    yield_rate numeric(5, 2) default 100.00 not null,         -- Tỷ lệ thu hồi sau sơ chế (%)
    min_stock numeric(12, 4) default 0.0000 not null,         -- Tồn kho tối thiểu
    max_stock numeric(12, 4) default 0.0000 not null,         -- Tồn kho tối đa
    safety_stock numeric(12, 4) default 0.0000 not null,      -- Tồn kho an toàn cho Auto-PO
    is_import boolean default false not null,                 -- Cờ hàng nhập khẩu (tính landed cost)
    track_lot boolean default false not null,                 -- Bật theo dõi lô/hạn (FEFO)
    is_beverage boolean default false not null,               -- Cờ Bar/Đồ uống (bật tính năng Pour Variance)
    auto_po_group varchar(50) default 'AUTO_PO' not null check (auto_po_group in ('AUTO_PO', 'MANUAL_REQUISITION')),
    is_active boolean default true not null,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table ingredients enable row level security;

-- Nhà cung cấp (MỚI v8.0)
create table suppliers (
    id uuid default gen_random_uuid() primary key,
    name text not null,
    category_id uuid references purchase_categories(id) on delete set null,
    contact jsonb,
    lead_time_days int not null default 1,
    cutoff_time time,
    is_active boolean default true not null
);

alter table suppliers enable row level security;

-- Liên kết Giá & Quy cách theo từng NCC (MỚI v8.0)
create table supplier_ingredients (
    supplier_id uuid references suppliers(id) on delete cascade,
    ingredient_id varchar(50) references ingredients(id) on delete cascade,
    purchase_uom text references uom(id) on delete set null,  -- ĐVT mua hàng (VD: Thùng, Hộp)
    pack_size numeric not null default 1,                     -- Quy đổi Mua -> Tồn: 1 đơn vị mua = pack_size đơn vị tồn
    moq numeric not null default 1,                           -- Số lượng đặt hàng tối thiểu (theo purchase_uom)
    last_price_fx numeric(12, 2),                             -- Giá theo ngoại tệ (nếu là nhập khẩu)
    currency text default 'VND' not null,
    is_preferred boolean default false not null,              -- NCC ưu tiên khi chạy Auto-PO
    primary key (supplier_id, ingredient_id)
);

alter table supplier_ingredients enable row level security;

-- ==========================================
-- 3. MENU ITEMS & RECIPES (BOM)
-- ==========================================

-- Danh mục Món ăn
create table menu_items (
    id varchar(50) primary key,                 -- Mã món từ POS, e.g., 'R1121', 'R6212'
    name varchar(255) not null,
    sale_price numeric(12, 2) not null,
    is_set_menu boolean default false not null, -- Cờ combo/tasting menu
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table menu_items enable row level security;

-- Phân rã Set Menu
create table set_menu_items (
    id uuid default gen_random_uuid() primary key,
    parent_menu_item_id varchar(50) references menu_items(id) on delete cascade not null,
    child_menu_item_id varchar(50) references menu_items(id) on delete cascade not null,
    portion_ratio numeric(5, 2) default 1.00 not null, -- Tỷ lệ định lượng (e.g. 0.70 cho Tasting)
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    unique (parent_menu_item_id, child_menu_item_id)
);

alter table set_menu_items enable row level security;

-- Định mức Công thức (BOM)
create table recipes (
    id uuid default gen_random_uuid() primary key,
    menu_item_id varchar(50) references menu_items(id) on delete cascade not null,
    ingredient_id varchar(50) references ingredients(id) on delete cascade not null,
    qty_net numeric(10, 4) not null,                  -- Lượng tịnh trong đĩa ăn (theo recipe_uom)
    yield_pct numeric(5, 2) default 100.00 not null,  -- Yield riêng của NVL này (%)
    qty_eff numeric(10, 4) generated always as (qty_net / (yield_pct / 100.00)) stored, -- Lượng thô hiệu dụng (theo recipe_uom)
    recipe_uom text references uom(id) on delete set null,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    unique (menu_item_id, ingredient_id)
);

alter table recipes enable row level security;

-- ==========================================
-- 4. PURCHASE ORDERS & GOODS RECEIPTS (3-WAY MATCH)
-- ==========================================

-- Đơn đặt hàng (Purchase Orders v8.0)
create table purchase_orders (
    id uuid default gen_random_uuid() primary key,
    po_number varchar(100) unique not null,
    supplier_id uuid references suppliers(id) on delete cascade not null,
    status text default 'OPEN' not null check (status in ('OPEN', 'PARTIAL', 'RECEIVED', 'CLOSED', 'CANCELLED')),
    source text default 'AUTO_PO' not null check (source in ('AUTO_PO', 'MANUAL_REQUISITION')),
    expected_date date,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table purchase_orders enable row level security;

-- Chi tiết đơn đặt hàng (PO Lines v8.0)
create table po_lines (
    po_id uuid references purchase_orders(id) on delete cascade,
    ingredient_id varchar(50) references ingredients(id) on delete cascade,
    qty_ordered numeric(12, 4) not null,                      -- Số lượng đặt (theo purchase_uom)
    qty_received numeric(12, 4) default 0.0000 not null,      -- Số lượng thực tế đã nhận (theo purchase_uom)
    purchase_uom text references uom(id) on delete set null,
    primary key (po_id, ingredient_id)
);

alter table po_lines enable row level security;

-- Biên bản nhận hàng + Hóa đơn (Goods Receipts v8.0)
create table goods_receipts (
    id uuid default gen_random_uuid() primary key,
    po_id uuid references purchase_orders(id) on delete set null, -- Có thể null nếu mua khẩn cấp hàng chợ
    supplier_id uuid references suppliers(id) on delete set null,
    invoice_no text,                                              -- Số hóa đơn NCC
    invoice_amount numeric(12, 2),                                -- Tổng số tiền trên hóa đơn (VND)
    currency text default 'VND' not null,
    fx_rate numeric(12, 4) default 1.0000 not null,               -- Tỷ giá ngoại tệ
    duty numeric(12, 2) default 0.00 not null,                    -- Thuế nhập khẩu phân bổ (VND)
    freight numeric(12, 2) default 0.00 not null,                 -- Cước vận chuyển phân bổ (VND)
    match_status text default 'PENDING' not null check (match_status in ('PENDING', 'MATCHED', 'VARIANCE', 'APPROVED')), -- 3-way match status
    status text default 'pending' not null check (status in ('pending', 'approved', 'rejected')),                      -- Workflow duyệt tăng kho
    received_by uuid references profiles(id) on delete set null,
    approved_by uuid references profiles(id) on delete set null,
    business_date date,                                           -- Ngày ghi sổ kế toán
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table goods_receipts enable row level security;

-- Chi tiết nhận hàng (GRN Lines v8.0)
create table grn_lines (
    grn_id uuid references goods_receipts(id) on delete cascade,
    ingredient_id varchar(50) references ingredients(id) on delete cascade,
    qty_received numeric(12, 4) not null,                         -- Số lượng nhận (theo purchase_uom)
    purchase_uom text references uom(id) on delete set null,
    unit_price_fx numeric(12, 2) not null,                        -- Giá mua đơn vị theo ngoại tệ
    landed_unit_cost numeric(12, 2),                              -- Giá vốn landed cost sau quy đổi stock_uom và phân bổ thuế/cước
    primary key (grn_id, ingredient_id)
);

alter table grn_lines enable row level security;

-- ==========================================
-- 5. LOTS, TRANSACTIONS & SHIFT CONSUMPTION
-- ==========================================

-- Lô hàng / Hạn dùng (Lots v8.0 phục vụ FEFO)
create table lots (
    id uuid default gen_random_uuid() primary key,
    ingredient_id varchar(50) references ingredients(id) on delete cascade not null,
    grn_id uuid references goods_receipts(id) on delete cascade,
    qty_remaining numeric(12, 4) not null,                        -- Số lượng còn lại (theo stock_uom)
    expiry_date date,                                             -- Hạn sử dụng
    received_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table lots enable row level security;

-- Sổ cái biến động kho bất biến (Inventory Transactions v8.0)
create table inventory_transactions (
    id bigint generated always as identity primary key,
    ingredient_id varchar(50) references ingredients(id) on delete cascade not null,
    txn_type text not null check (txn_type in ('IMPORT', 'SALE_DEPLETION', 'WASTE', 'NON_SALE', 'STOCK_TAKE_ADJ', 'REVERSAL')),
    qty numeric(12, 4) not null,                                  -- Số lượng biến động theo stock_uom (âm = xuất, dương = nhập)
    unit_cost numeric(12, 2),                                     -- Giá vốn WAC tại thời điểm ghi (VND)
    lot_id uuid references lots(id) on delete set null,           -- Link lô hàng (FEFO)
    ref_table text,                                               -- Bảng gốc sinh giao dịch (grn, waste, sales_import, non_sale)
    ref_id varchar(100),                                          -- ID của bản ghi gốc
    reverses_id bigint references inventory_transactions(id) on delete set null, -- Link bút toán đảo (nếu có)
    business_date date not null,                                  -- Ngày kế toán ghi nhận
    status varchar(20) default 'approved' not null,               -- Trạng thái giao dịch
    created_by uuid references profiles(id) on delete set null,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table inventory_transactions enable row level security;

-- Nhật ký hủy hỏng nguyên liệu trong ca
create table waste_logs (
    id uuid default gen_random_uuid() primary key,
    ingredient_id varchar(50) references ingredients(id) on delete cascade not null,
    qty numeric(12, 4) not null,                                  -- Theo stock_uom
    reason text not null,
    status varchar(20) default 'approved' not null check (status in ('pending_approval', 'approved', 'rejected')),
    is_processed boolean default false not null,
    created_by uuid references profiles(id) on delete set null,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table waste_logs enable row level security;

-- Doanh thu POS cuối ngày chờ xử lý
create table sales_imports (
    id uuid default gen_random_uuid() primary key,
    import_date date not null,
    menu_item_id varchar(50) references menu_items(id) not null,
    qty_sold integer not null,
    net_revenue numeric(12, 2) not null,
    is_processed boolean default false not null,
    file_hash text,                                               -- Hash file POS chống tải lên trùng lặp
    void_qty integer default 0 not null,                          -- Số lượng món bị hủy
    comp_qty integer default 0 not null,                          -- Số lượng món tặng khách/khuyến mãi (comp)
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table sales_imports enable row level security;

-- Tiêu thụ ngoài bán hàng (Cơm nhân viên, R&D...)
create table non_sale_consumption (
    id bigint generated always as identity primary key,
    ingredient_id varchar(50) references ingredients(id) on delete cascade not null,
    qty numeric(12, 4) not null,                                  -- Theo stock_uom
    consumption_type text not null check (consumption_type in ('STAFF_MEAL', 'COMP', 'R&D', 'TRAINING', 'EVENT')),
    business_date date not null,
    created_by uuid references profiles(id) on delete set null,
    note text,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table non_sale_consumption enable row level security;

-- Bảng lưu trữ liên kết POS học được
create table pos_alias_map (
    pos_code text primary key,
    menu_item_id varchar(50) references menu_items(id) on delete cascade not null,
    confidence numeric(5, 2) default 100.00 not null,
    confirmed_by uuid references profiles(id) on delete set null,
    confirmed_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table pos_alias_map enable row level security;

-- ==========================================
-- 6. STOCKTAKING & RECONCILIATION
-- ==========================================

-- Đợt kiểm kho
create table stock_takes (
    id uuid default gen_random_uuid() primary key,
    take_type text not null check (take_type in ('OPENING', 'FULL', 'CYCLE')),
    business_date date not null,
    status text default 'OPEN' not null check (status in ('OPEN', 'COUNTING', 'POSTED')),
    frozen_snapshot jsonb,                                        -- Chốt tồn lý thuyết chống race condition khi kiểm kê
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table stock_takes enable row level security;

-- Chi tiết kiểm kho
create table stock_take_lines (
    take_id uuid references stock_takes(id) on delete cascade,
    ingredient_id varchar(50) references ingredients(id) on delete cascade,
    qty_physical numeric(12, 4) not null,
    qty_theoretical numeric(12, 4) not null,
    variance numeric(12, 4) not null,
    primary key (take_id, ingredient_id)
);

alter table stock_take_lines enable row level security;

-- Máy trạng thái khóa sổ ngày
create table daily_close (
    business_date date primary key,
    status text default 'OPEN' not null check (status in ('OPEN', 'WAC_DONE', 'CONSUMPTION_DONE', 'PO_DONE', 'LOCKED')),
    locked_at timestamp with time zone,
    locked_by uuid references profiles(id) on delete set null
);

alter table daily_close enable row level security;

-- Sổ kiểm toán
create table audit_log (
    id bigint generated always as identity primary key,
    actor uuid references profiles(id) on delete set null,
    action text not null,
    entity text not null,
    entity_id text not null,
    before_data jsonb,
    after_data jsonb,
    at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table audit_log enable row level security;

-- ==========================================
-- 7. SECURITY VIEWS (LỚP BẢO MẬT TÀI CHÍNH CỘT)
-- ==========================================

-- 7.1. View Vận Hành (Cấp 2, 3, 5, 6, 7) - Không có bất kỳ cột tiền hay giá vốn nào
create or replace view v_inventory_ops as
select 
    i.id as ingredient_id,
    i.code as ingredient_code,
    i.nom_fr,
    i.ten_vi,
    i.stock_uom,
    i.recipe_uom,
    i.stock_to_recipe_factor,
    i.tare_weight_grams,
    i.tolerance_percent,
    coalesce((select sum(qty) from inventory_transactions where ingredient_id = i.id and status = 'approved'), 0) as qty_on_hand,
    i.min_stock,
    i.max_stock,
    i.safety_stock,
    i.is_beverage,
    i.is_active
from ingredients i
where i.is_active = true;

-- 7.2. View Kế Toán (Cấp 4) - Xem được số lượng + giá vốn WAC/Landed Cost, nhưng không thấy doanh thu món ăn
create or replace view v_inventory_cost as
select 
    i.id as ingredient_id,
    i.code as ingredient_code,
    i.nom_fr,
    i.ten_vi,
    i.stock_uom,
    i.recipe_uom,
    i.stock_to_recipe_factor,
    i.tare_weight_grams,
    i.tolerance_percent,
    i.wac_price,
    i.standard_price,
    coalesce((select sum(qty) from inventory_transactions where ingredient_id = i.id and status = 'approved'), 0) as qty_on_hand,
    (coalesce((select sum(qty) from inventory_transactions where ingredient_id = i.id and status = 'approved'), 0) * i.wac_price) as stock_value_vnd,
    i.min_stock,
    i.max_stock,
    i.safety_stock,
    i.is_beverage,
    i.is_active
from ingredients i
where i.is_active = true;

-- 7.3. View Tài Chính (Cấp 1 - CFO / Owner) - Đầy đủ giá trị kho, giá vốn, doanh thu POS và food cost
create or replace view v_inventory_finance as
select 
    i.id as ingredient_id,
    i.code as ingredient_code,
    i.nom_fr,
    i.ten_vi,
    i.stock_uom,
    i.recipe_uom,
    i.stock_to_recipe_factor,
    i.tare_weight_grams,
    i.tolerance_percent,
    i.wac_price,
    i.standard_price,
    coalesce((select sum(qty) from inventory_transactions where ingredient_id = i.id and status = 'approved'), 0) as qty_on_hand,
    (coalesce((select sum(qty) from inventory_transactions where ingredient_id = i.id and status = 'approved'), 0) * i.wac_price) as stock_value_vnd,
    (
        select coalesce(sum(s.net_revenue), 0)
        from sales_imports s
        join recipes r on s.menu_item_id = r.menu_item_id
        where r.ingredient_id = i.id
    ) as attributed_revenue_vnd,
    i.min_stock,
    i.max_stock,
    i.safety_stock,
    i.is_beverage,
    i.is_active
from ingredients i
where i.is_active = true;

-- ==========================================
-- 8. ROW LEVEL SECURITY (RLS) POLICIES
-- ==========================================

-- Hàm hỗ trợ lấy role người dùng
create or replace function get_current_user_role()
returns varchar as $$
begin
  return coalesce(
    (select role from profiles where id = auth.uid()),
    'guest'
  );
end;
$$ language plpgsql security definer;

-- 8.1. Policy cho bảng Profiles (Thông tin người dùng)
create policy "Allow select profiles for all authenticated users"
on profiles for select to authenticated using (true);

create policy "Allow update profiles for self or admin"
on profiles for update to authenticated
using (auth.uid() = id or get_current_user_role() = 'admin')
with check (auth.uid() = id or get_current_user_role() = 'admin');

-- 8.2. Policy cho bảng Ingredients (Nguyên vật liệu)
create policy "Allow select ingredients for all staff"
on ingredients for select to authenticated using (true);

create policy "Allow write ingredients for admin and senior accountant"
on ingredients for all to authenticated
using (get_current_user_role() in ('admin', 'senior_accountant'))
with check (get_current_user_role() in ('admin', 'senior_accountant'));

-- 8.3. Policy cho bảng Inventory Transactions (Biến động kho)
create policy "Allow select transactions for all staff"
on inventory_transactions for select to authenticated using (true);

create policy "Allow insert transactions for authorized staff"
on inventory_transactions for insert to authenticated
with check (
    (get_current_user_role() = 'junior_accountant' and txn_type = 'IMPORT') or -- Thủ kho chỉ tạo phiếu pending
    (get_current_user_role() in ('admin', 'senior_accountant', 'head_chef') and (ref_table is not null or txn_type in ('IMPORT', 'STOCK_TAKE_ADJ', 'REVERSAL')))
);

create policy "Allow approve/update transactions for senior accountant and admin"
on inventory_transactions for update to authenticated
using (get_current_user_role() in ('admin', 'senior_accountant'))
with check (get_current_user_role() in ('admin', 'senior_accountant'));

-- 8.4. Policy cho bảng Waste Logs (Hủy hỏng)
create policy "Allow select waste_logs for all staff"
on waste_logs for select to authenticated using (true);

create policy "Allow insert waste_logs for sous chefs and chefs"
on waste_logs for insert to authenticated
with check (get_current_user_role() in ('sous_chef', 'head_chef', 'admin'));

create policy "Allow update/approve waste_logs for managers and chefs"
on waste_logs for update to authenticated
using (get_current_user_role() in ('admin', 'restaurant_manager', 'head_chef'));

-- 8.5. Policy cho bảng Purchase Orders (Đơn đặt hàng)
create policy "Allow select PO for accountants, managers, admin"
on purchase_orders for select to authenticated
using (get_current_user_role() in ('admin', 'senior_accountant', 'restaurant_manager'));

create policy "Allow manage PO for senior accountant and admin"
on purchase_orders for all to authenticated
using (get_current_user_role() in ('admin', 'senior_accountant'));

-- 8.6. Policy cho bảng Goods Receipts (Nhận hàng)
create policy "Allow select GRN for accountants, managers, admin"
on goods_receipts for select to authenticated
using (get_current_user_role() in ('admin', 'senior_accountant', 'junior_accountant', 'restaurant_manager'));

create policy "Allow insert GRN for accountants and admin"
on goods_receipts for insert to authenticated
with check (get_current_user_role() in ('admin', 'senior_accountant', 'junior_accountant'));

create policy "Allow update/approve GRN for senior accountant and admin"
on goods_receipts for update to authenticated
using (get_current_user_role() in ('admin', 'senior_accountant'))
with check (get_current_user_role() in ('admin', 'senior_accountant'));

-- Thu hồi quyền trực tiếp trên các bảng gốc khỏi người dùng thông thường để bắt buộc qua VIEW bảo mật
revoke select on table ingredients, inventory_transactions from public, authenticated;
grant select on table v_inventory_ops to authenticated;
grant select on table v_inventory_cost to authenticated;
grant select on table v_inventory_finance to authenticated;

-- =========================================================================
-- v9.0 SCHEMA ADDITIONS (BAR INDEPENDENCE, INTERNAL TRANSFER, ORDER DOCUMENTS)
-- =========================================================================

-- 1. Locations Table
create table if not exists locations (
  id          text primary key,     -- 'MAIN_STORE','KITCHEN','BAR'
  name        text not null,
  loc_type    text not null,        -- 'STORE' (kho) | 'STATION' (quầy/bộ phận sử dụng)
  is_bar      boolean default false
);

alter table locations enable row level security;

-- Insert default locations
insert into locations (id, name, loc_type, is_bar) values
('MAIN_STORE', 'Kho tổng', 'STORE', false),
('KITCHEN', 'Bếp', 'STATION', false),
('BAR', 'Quầy Bar', 'STATION', true)
on conflict (id) do nothing;

-- 2. Alter profiles to add bar attributes
alter table profiles add column if not exists home_location text references locations(id);
alter table profiles add column if not exists pin_hash text;
alter table profiles add column if not exists shift_role text;

-- Drop and recreate profiles check constraint to include new bar roles
alter table profiles drop constraint if exists profiles_role_check;
alter table profiles add constraint profiles_role_check check (role in (
    'admin',
    'restaurant_manager',
    'head_chef',
    'senior_accountant',
    'foh_supervisor',
    'sous_chef',
    'junior_accountant',
    'BAR_SUPERVISOR',
    'BARTENDER'
));

-- 3. Alter inventory_transactions for location tracking & transfer link
alter table inventory_transactions add column if not exists location_id text references locations(id) default 'MAIN_STORE';
alter table inventory_transactions add column if not exists transfer_id uuid;

-- Drop and recreate txn_type check constraint
alter table inventory_transactions drop constraint if exists inventory_transactions_txn_type_check;
alter table inventory_transactions add constraint inventory_transactions_txn_type_check check (txn_type in (
  'IMPORT', 'SALE_DEPLETION', 'WASTE', 'NON_SALE', 'STOCK_TAKE_ADJ', 'REVERSAL',
  'TRANSFER_OUT', 'TRANSFER_IN', 'ISSUE'
));

-- 4. Create View for Stock on Hand per Location
create or replace view v_stock_on_hand as
  select ingredient_id, location_id, sum(qty) as qty_on_hand
  from inventory_transactions 
  where status = 'approved'
  group by ingredient_id, location_id;

-- 5. Calibration for Bar Bottles
create table if not exists bar_bottle_calibration (
  ingredient_id      varchar(50) primary key references ingredients(id) on delete cascade,
  full_weight_grams  numeric not null,
  empty_weight_grams numeric not null,
  full_volume_ml     numeric not null
);

alter table bar_bottle_calibration enable row level security;

-- 6. Bar Counts by Shift
create table if not exists bar_counts (
  id                uuid primary key default gen_random_uuid(),
  business_date     date not null,
  ingredient_id     varchar(50) references ingredients(id) on delete cascade,
  sealed_qty        numeric default 0,
  open_bottle_grams numeric,
  derived_volume_ml numeric,
  shift             text check (shift in ('OPEN', 'CLOSE')),
  counted_by        uuid references profiles(id) on delete set null,
  counted_at        timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table bar_counts enable row level security;

-- 7. Daily Stock Movement Confirmation
create table if not exists daily_stock_movement (
  business_date         date,
  location_id           text references locations(id),
  imports_confirmed     boolean default false,
  imports_confirmed_by  uuid references profiles(id),
  imports_confirmed_at  timestamp with time zone,
  issues_confirmed      boolean default false,
  issues_confirmed_by   uuid references profiles(id),
  issues_confirmed_at   timestamp with time zone,
  closing_snapshot      jsonb,
  status                text default 'OPEN' check (status in ('OPEN', 'CLOSED')),
  primary key (business_date, location_id)
);

alter table daily_stock_movement enable row level security;

-- 8. Order Documents (Immutable PO PDFs)
create table if not exists order_documents (
  id            uuid primary key default gen_random_uuid(),
  doc_no        text unique not null,
  business_date date not null,
  location_id   text references locations(id),
  supplier_id   uuid references suppliers(id) on delete set null,
  status        text default 'DRAFT' check (status in ('DRAFT', 'APPROVED', 'SENT')),
  generated_by  uuid references profiles(id),
  approved_by   uuid references profiles(id),
  pdf_path      text,
  content_hash  text,
  payload       jsonb,
  created_at    timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table order_documents enable row level security;

-- Setup RLS Policies for new items
create policy "Allow select locations for all staff" on locations for select to authenticated using (true);
create policy "Allow select calibration for all staff" on bar_bottle_calibration for select to authenticated using (true);
create policy "Allow select bar_counts for all staff" on bar_counts for select to authenticated using (true);
create policy "Allow select daily_stock_movement for all staff" on daily_stock_movement for select to authenticated using (true);
create policy "Allow select order_documents for all staff" on order_documents for select to authenticated using (true);

-- Write policies for bar_bottle_calibration
create policy "Allow write calibration for authorized staff"
on bar_bottle_calibration for all to authenticated
using (get_current_user_role() in ('BAR_SUPERVISOR', 'admin', 'senior_accountant', 'restaurant_manager'))
with check (get_current_user_role() in ('BAR_SUPERVISOR', 'admin', 'senior_accountant', 'restaurant_manager'));

-- Write policies for bar_counts
create policy "Allow insert bar_counts for bartender, supervisor and admin"
on bar_counts for insert to authenticated
with check (get_current_user_role() in ('BARTENDER', 'BAR_SUPERVISOR', 'admin'));

create policy "Allow update/delete bar_counts for supervisor and admin"
on bar_counts for update to authenticated
using (get_current_user_role() in ('BAR_SUPERVISOR', 'admin'))
with check (get_current_user_role() in ('BAR_SUPERVISOR', 'admin'));

-- Write policies for daily_stock_movement
create policy "Allow manage daily_stock_movement for authorized roles"
on daily_stock_movement for all to authenticated
using (get_current_user_role() in ('BAR_SUPERVISOR', 'admin', 'senior_accountant', 'junior_accountant', 'head_chef', 'restaurant_manager'))
with check (get_current_user_role() in ('BAR_SUPERVISOR', 'admin', 'senior_accountant', 'junior_accountant', 'head_chef', 'restaurant_manager'));

-- Write policies for order_documents
create policy "Allow manage order_documents for authorized roles"
on order_documents for all to authenticated
using (get_current_user_role() in ('BAR_SUPERVISOR', 'admin', 'senior_accountant', 'restaurant_manager'))
with check (get_current_user_role() in ('BAR_SUPERVISOR', 'admin', 'senior_accountant', 'restaurant_manager'));

-- Grant select on new views
grant select on table v_stock_on_hand to authenticated;

-- NHÃN BỘ PHẬN cho từng nguyên liệu (MỚI v9.1)
create table ingredient_departments (
  ingredient_id uuid references ingredients(id) on delete cascade,
  department    text references locations(id) on delete cascade,   -- 'BAR' | 'KITCHEN'
  usage_context text,        -- 'BEVERAGE','COOKING','FLAMBE','GARNISH','SAUCE'
  is_primary    boolean default false,  -- bộ phận "chủ" mã
  primary key (ingredient_id, department)
);

alter table ingredient_departments enable row level security;

-- Setup RLS Policies for ingredient_departments
create policy "Allow select departments for all staff" on ingredient_departments for select to authenticated using (true);
create policy "Allow manage departments for admin and senior roles"
on ingredient_departments for all to authenticated
using (get_current_user_role() in ('admin', 'restaurant_manager', 'senior_accountant', 'head_chef'))
with check (get_current_user_role() in ('admin', 'restaurant_manager', 'senior_accountant', 'head_chef'));

-- Audit log schema for ingredient_departments (giao diện phê duyệt dùng chung)
create table department_approval_audit_logs (
  id uuid primary key default gen_random_uuid(),
  ingredient_id uuid references ingredients(id) on delete cascade,
  action_type text not null, -- 'ADD_TAG', 'REMOVE_TAG'
  department text not null,
  usage_context text,
  approved_by_chef uuid references profiles(id),
  approved_by_bar uuid references profiles(id),
  status text default 'PENDING', -- 'PENDING', 'APPROVED', 'REJECTED'
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table department_approval_audit_logs enable row level security;

create policy "Allow select audit logs for all staff" on department_approval_audit_logs for select to authenticated using (true);
create policy "Allow manage audit logs for chef, bar and admin"
on department_approval_audit_logs for all to authenticated
using (get_current_user_role() in ('admin', 'restaurant_manager', 'BAR_SUPERVISOR', 'head_chef'))
with check (get_current_user_role() in ('admin', 'restaurant_manager', 'BAR_SUPERVISOR', 'head_chef'));

grant select on table ingredient_departments to authenticated;
grant select on table department_approval_audit_logs to authenticated;


