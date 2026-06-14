-- MAISON VIE INVENTORY & CRM DATABASE SCHEMA
-- Target Database: PostgreSQL (Supabase)
-- Author: Full-Stack Data Architect / CFO / COO

-- Clean up existing tables if they exist (ordered by dependencies)
drop table if exists purchase_order_details cascade;
drop table if exists purchase_orders cascade;
drop table if exists waste_logs cascade;
drop table if exists sales_imports cascade;
drop table if exists inventory_transactions cascade;
drop table if exists recipes cascade;
drop table if exists set_menu_items cascade;
drop table if exists menu_items cascade;
drop table if exists ingredients cascade;
drop table if exists purchase_categories cascade;
drop table if exists profiles cascade;

-- ==========================================
-- 1. PROFILES & ROLE-BASED ACCESS CONTROL (RBAC)
-- ==========================================

create table profiles (
    id uuid references auth.users(id) on delete cascade primary key,
    username varchar(100) not null,
    role varchar(50) not null check (role in (
        'admin',              -- Cấp 1: Toàn quyền, CFO, Owner
        'restaurant_manager', -- Cấp 2: Quản lý nhà hàng, duyệt waste lớn
        'head_chef',          -- Cấp 3: Bếp trưởng, quản lý recipes & yield
        'senior_accountant',  -- Cấp 4: Kế toán cấp cao, WAC, mapping, duyệt Auto-PO
        'foh_supervisor',    -- Cấp 5: Giám sát sảnh, xem menu & đối soát POS
        'sous_chef',          -- Cấp 6: Bếp phó, tạo Waste Log, Manual PO Requisition
        'junior_accountant'   -- Cấp 7: Thủ kho/kế toán phụ, nhập hóa đơn chờ duyệt
    )),
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable RLS for Profiles
alter table profiles enable row level security;

-- ==========================================
-- 2. MASTER DATA TABLES
-- ==========================================

-- Bảng Nhóm hàng đặt/Nhóm thu mua
create table purchase_categories (
    id uuid default gen_random_uuid() primary key,
    code varchar(50) unique not null,          -- e.g., 'THIT', 'WINE', 'RAU_CU_KHO'
    name varchar(100) not null,                 -- e.g., 'Thịt tươi', 'Rượu vang', 'Rau củ & đồ khô'
    is_active boolean default true not null,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Bảng Nguyên Vật Liệu (Ingredients Master)
create table ingredients (
    id varchar(50) primary key,                 -- Mã NVL từ Excel, e.g., 'ING-011', 'ING-093'
    nom_fr varchar(255) not null,               -- Tên tiếng Pháp
    ten_vi varchar(255) not null,               -- Tên tiếng Việt
    name_en varchar(255),                       -- Tên tiếng Anh
    unit varchar(50) not null,                  -- ĐVT chính, e.g., 'kg', 'L', 'Gram'
    wac_price numeric(12, 2) default 0.00 not null,     -- Giá vốn WAC lũy tiến hiện tại
    standard_price numeric(12, 2) default 0.00 not null,-- Giá nhập chuẩn gần nhất (dùng dự phòng)
    yield_rate numeric(5, 2) default 100.00 not null,   -- Tỷ lệ thu hồi sau sơ chế (%)
    min_stock numeric(12, 4) default 0.0000 not null,   -- Tồn kho tối thiểu
    max_stock numeric(12, 4) default 0.0000 not null,   -- Tồn kho tối đa
    auto_po_group varchar(50) default 'AUTO_PO' not null check (auto_po_group in ('AUTO_PO', 'MANUAL_REQUISITION')),
    purchase_category_id uuid references purchase_categories(id) on delete set null,
    is_active boolean default true not null,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Bảng Danh mục Món ăn (Menu Items from POS)
create table menu_items (
    id varchar(50) primary key,                 -- Mã món từ POS, e.g., 'R1121', 'R6212'
    name varchar(255) not null,
    sale_price numeric(12, 2) not null,         -- Giá bán lẻ trên POS
    is_set_menu boolean default false not null, -- Cờ xác nhận Set Menu/Tasting Menu
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Bảng Phân rã Set Menu (Set/Tasting Menu Components)
create table set_menu_items (
    id uuid default gen_random_uuid() primary key,
    parent_menu_item_id varchar(50) references menu_items(id) on delete cascade not null,
    child_menu_item_id varchar(50) references menu_items(id) on delete cascade not null,
    portion_ratio numeric(5, 2) default 1.00 not null, -- Tỷ lệ định lượng (e.g. 0.70 cho Tasting)
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    unique (parent_menu_item_id, child_menu_item_id)
);

-- Bảng Định mức Công thức (BOM / Recipe Details)
create table recipes (
    id uuid default gen_random_uuid() primary key,
    menu_item_id varchar(50) references menu_items(id) on delete cascade not null,
    ingredient_id varchar(50) references ingredients(id) on delete cascade not null,
    qty_net numeric(10, 4) not null,            -- Lượng tinh trong đĩa ăn
    yield_pct numeric(5, 2) default 100.00 not null, -- Yield thu hồi của riêng NVL này
    qty_eff numeric(10, 4) generated always as (qty_net / (yield_pct / 100.00)) stored, -- Lượng thô thực tế trừ kho
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    unique (menu_item_id, ingredient_id)
);

-- ==========================================
-- 3. TRANSACTIONS & SHIFT LOGS
-- ==========================================

-- Bảng Giao dịch Kho (Inventory Transactions)
create table inventory_transactions (
    id uuid default gen_random_uuid() primary key,
    ingredient_id varchar(50) references ingredients(id) on delete cascade not null,
    type varchar(20) not null check (type in ('import', 'consumption', 'stock_take', 'waste', 'transfer')),
    qty numeric(12, 4) not null,                -- Lượng giao dịch (+ nhập/kiểm dư, - xuất/tiêu hao/kiểm thiếu)
    unit_price numeric(12, 2) not null,         -- Giá trị trên 1 đơn vị
    status varchar(20) default 'pending' not null check (status in ('pending', 'approved', 'rejected')), -- Duyệt cấp 4
    approved_by uuid references profiles(id) on delete set null,
    approved_at timestamp with time zone,
    reference_id varchar(100),                  -- Mã hóa đơn hoặc mã POS import
    note text,
    created_by uuid references profiles(id) on delete set null,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Bảng Nhật ký Hủy hỏng trong ca (Waste Log - Cấp 6 nhập, Cấp 2 duyệt nếu lớn)
create table waste_logs (
    id uuid default gen_random_uuid() primary key,
    ingredient_id varchar(50) references ingredients(id) on delete cascade not null,
    qty numeric(12, 4) not null,
    reason text not null,
    status varchar(20) default 'approved' not null check (status in ('pending_approval', 'approved', 'rejected')),
    is_processed boolean default false not null, -- Đã gom chốt trừ kho cuối ngày chưa
    created_by uuid references profiles(id) on delete set null,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Bảng Nhập file doanh thu POS hàng ngày (Sales Imports Batch)
create table sales_imports (
    id uuid default gen_random_uuid() primary key,
    import_date date not null,
    menu_item_id varchar(50) references menu_items(id) not null,
    qty_sold integer not null,
    net_revenue numeric(12, 2) not null,
    is_processed boolean default false not null, -- Chốt lúc 22h30
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- ==========================================
-- 4. PURCHASE ORDERS (AUTO-PO SYSTEM)
-- ==========================================

-- Bảng Đơn đặt hàng (Purchase Orders)
create table purchase_orders (
    id uuid default gen_random_uuid() primary key,
    po_number varchar(50) unique not null,       -- Số PO định dạng PO-YYYYMMDD-CAT
    category_code varchar(50) not null,          -- Nhóm hàng, e.g. 'THIT', 'WINE', 'RAU_CU_KHO'
    order_date date default current_date not null,
    status varchar(20) default 'draft' not null check (status in ('draft', 'sent', 'completed')),
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Bảng Chi tiết Đơn đặt hàng (PO Details)
create table purchase_order_details (
    id uuid default gen_random_uuid() primary key,
    purchase_order_id uuid references purchase_orders(id) on delete cascade not null,
    ingredient_id varchar(50) references ingredients(id) on delete cascade not null,
    qty_ordered numeric(12, 4) not null,
    unit_price numeric(12, 2) not null,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- ==========================================
-- 5. ROW LEVEL SECURITY (RLS) POLICIES
-- ==========================================

-- Bật RLS cho tất cả các bảng chính
alter table ingredients enable row level security;
alter table menu_items enable row level security;
alter table recipes enable row level security;
alter table inventory_transactions enable row level security;
alter table waste_logs enable row level security;
alter table sales_imports enable row level security;
alter table purchase_orders enable row level security;

-- Hàm hỗ trợ lấy Role của User hiện tại để viết Policy cho gọn
create or replace function get_current_user_role()
returns varchar as $$
begin
  return coalesce(
    (select role from profiles where id = auth.uid()),
    'guest'
  );
end;
$$ language plpgsql security definer;

-- POLICY CHO INGREDIENTS (NVL)
-- Select: Cho phép tất cả nhân viên xem danh mục NVL
create policy "Allow select ingredients for all staff"
on ingredients for select to authenticated using (true);

-- Insert/Update: Chỉ Cấp 1 (Admin/CFO) và Cấp 4 (Senior Accountant) được sửa giá/tồn
create policy "Allow write ingredients for admin and senior accountant"
on ingredients for all to authenticated
using (get_current_user_role() in ('admin', 'senior_accountant'))
with check (get_current_user_role() in ('admin', 'senior_accountant'));

-- POLICY CHO INVENTORY TRANSACTIONS
-- Select: Tất cả nhân viên xem lịch sử giao dịch
create policy "Allow select transactions for all staff"
on inventory_transactions for select to authenticated using (true);

-- Insert: Cấp 7 (Junior Accountant/Thủ kho) được tạo phiếu 'pending'. 
-- Cấp 4, Chef, Admin được tạo phiếu approved.
create policy "Allow insert transactions for authorized staff"
on inventory_transactions for insert to authenticated
with check (
    (get_current_user_role() = 'junior_accountant' and status = 'pending') or
    (get_current_user_role() in ('admin', 'senior_accountant', 'head_chef') and status = 'approved')
);

-- Update/Duyệt: Chỉ Cấp 1 (Admin) và Cấp 4 (Senior Accountant) được duyệt phiếu 'pending' -> 'approved'
create policy "Allow update transactions for senior accountant and admin"
on inventory_transactions for update to authenticated
using (get_current_user_role() in ('admin', 'senior_accountant'))
with check (get_current_user_role() in ('admin', 'senior_accountant'));

-- POLICY CHO WASTE LOGS
-- Cấp 6 (Bếp phó) được tạo Waste Log. Cấp 2 (Manager) và Cấp 3 (Head Chef) được duyệt.
create policy "Allow select waste_logs for all staff"
on waste_logs for select to authenticated using (true);

create policy "Allow insert waste_logs for sous chefs and chefs"
on waste_logs for insert to authenticated
with check (get_current_user_role() in ('sous_chef', 'head_chef', 'admin'));

create policy "Allow update/approve waste_logs for manager and chefs"
on waste_logs for update to authenticated
using (get_current_user_role() in ('admin', 'restaurant_manager', 'head_chef'));

-- POLICY CHO PURCHASE ORDERS
create policy "Allow select PO for accountants and admin"
on purchase_orders for select to authenticated 
using (get_current_user_role() in ('admin', 'senior_accountant', 'restaurant_manager'));

create policy "Allow manage PO for senior accountant and admin"
on purchase_orders for all to authenticated
using (get_current_user_role() in ('admin', 'senior_accountant'));
