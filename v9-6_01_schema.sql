-- =====================================================================
-- MAISON VIE v9.6 — FILE 1/2: SCHEMA BỔ SUNG (ĐÃ ĐỐI CHIẾU VỚI DỰ ÁN)
-- Hiện thực §16 (deduction_type), §17.2–17.5, §19.1–19.5.
-- =====================================================================
create extension if not exists pgcrypto;   -- gen_random_uuid()

-- ---------------------------------------------------------------------
-- A. §16 deduction_type + §14 mapping_status + chống trừ trùng
-- ---------------------------------------------------------------------
-- Cập nhật bảng menu_items hiện có
alter table menu_items add column if not exists
  deduction_type text not null default 'RECIPE'
  check (deduction_type in ('DIRECT','RECIPE','NON_STOCK'));

-- Cập nhật bảng sales_imports hiện có (thay thế cho placeholder sale_lines)
alter table sales_imports add column if not exists
  mapping_status text not null default 'MAPPED'
  check (mapping_status in ('MAPPED','UNMAPPED','RESOLVED','NO_STOCK_IMPACT'));

-- NOTE: ux_invtxn_ref index đã bị xóa (2026-06-19)
-- Lý do: gây false conflict khi cùng ingredient có cả SALE_DEPLETION + NON_SALE (comp)
-- cho cùng 1 sales_import row với lot_id=NULL.
-- process_single_sale_import đã tự chống duplicate bằng DELETE-then-INSERT nên index này thừa.

-- ---------------------------------------------------------------------
-- B. §17.2 non_sale_consumption (cơm NV / training / tasting)
-- ---------------------------------------------------------------------
-- Do bảng non_sale_consumption đã tồn tại, ta thực hiện ALTER TABLE để cấu trúc đồng bộ
alter table non_sale_consumption drop constraint if exists non_sale_consumption_consumption_type_check;
alter table non_sale_consumption add column if not exists reason text check (reason in
  ('STAFF_MEAL','TRAINING','COMP','TASTING','RND','OTHER'));

-- Cập nhật dữ liệu cũ nếu có (chuyển đổi consumption_type sang reason)
update non_sale_consumption set reason = consumption_type where reason is null and consumption_type is not null;

-- Đặt mặc định và ràng buộc NOT NULL sau khi đã cập nhật dữ liệu
alter table non_sale_consumption alter column reason set not null;

-- ---------------------------------------------------------------------
-- C. §17.3 PO thủ công + cổng duyệt
-- ---------------------------------------------------------------------
-- Cập nhật bảng purchase_orders đã tồn tại
alter table purchase_orders add column if not exists po_no text unique;
alter table purchase_orders add column if not exists is_manual boolean default true;
alter table purchase_orders add column if not exists total_value numeric default 0;
alter table purchase_orders add column if not exists reason text;
alter table purchase_orders add column if not exists created_by uuid references profiles(id);
alter table purchase_orders add column if not exists approved_by uuid references profiles(id);
alter table purchase_orders add column if not exists approved_at timestamptz;

-- Đồng bộ cột po_no từ po_number cũ
update purchase_orders set po_no = po_number where po_no is null;

-- Cập nhật bảng po_lines đã tồn tại
alter table po_lines add column if not exists qty numeric;
alter table po_lines add column if not exists uom text;
alter table po_lines add column if not exists unit_price numeric;
alter table po_lines add column if not exists stock_at_order numeric;            -- tồn hiện tại (hiển thị khi lập)
alter table po_lines add column if not exists avg_daily_usage numeric;           -- tiêu hao TB/ngày
alter table po_lines add column if not exists days_of_cover numeric;             -- = stock / avg_daily_usage

-- Đồng bộ dữ liệu qty từ qty_ordered cũ
update po_lines set qty = qty_ordered where qty is null;
update po_lines set uom = purchase_uom where uom is null and purchase_uom is not null;

-- Đặt ràng buộc NOT NULL cho cột qty
alter table po_lines alter column qty set not null;

-- ---------------------------------------------------------------------
-- D. §17.4 Min-stock: derived + override + hồ sơ mùa
-- ---------------------------------------------------------------------
alter table ingredients add column if not exists lead_time_days int default 3;
alter table ingredients add column if not exists safety_factor numeric default 1.5;
alter table ingredients add column if not exists reorder_point numeric;     -- TÍNH RA
alter table ingredients add column if not exists min_override numeric;       -- tay (ngoại lệ)

create table if not exists seasonal_profiles (
  id uuid primary key default gen_random_uuid(),
  name text, multiplier numeric not null default 1 check (multiplier > 0),
  season_from date, season_to date, is_active boolean default true
);

-- reorder_point = tiêu hao_TB/ngày × lead_time × safety × hệ_số_mùa
create or replace function recompute_reorder_points(p_days int default 30)
returns void language plpgsql as $$
begin
  update ingredients i set reorder_point = sub.rp
  from (
    select t.ingredient_id,
           (sum(abs(t.qty)) / nullif(p_days,0)) -- Sửa từ qty_change sang qty theo schema dự án
           * coalesce(i2.lead_time_days,3)
           * coalesce(i2.safety_factor,1.5)
           * coalesce((select multiplier from seasonal_profiles
                        where is_active and current_date between season_from and season_to
                        order by multiplier desc limit 1), 1) as rp
    from inventory_transactions t
    join ingredients i2 on i2.id = t.ingredient_id
    where t.qty < 0 -- Direction = OUT (tiêu hao là số âm trong dự án)
      and t.created_at >= now() - (p_days || ' days')::interval
    group by t.ingredient_id, i2.lead_time_days, i2.safety_factor
  ) sub
  where i.id = sub.ingredient_id and i.min_override is null;
end $$;

-- ---------------------------------------------------------------------
-- E. §17.5 Settings 3 vùng + effective-dated (vùng FINANCIAL)
-- ---------------------------------------------------------------------
create table if not exists app_settings (
  key text primary key, value jsonb not null,
  zone text not null check (zone in ('COSMETIC','OPERATIONAL','FINANCIAL')),
  updated_by uuid references profiles(id), updated_at timestamptz default now()
);
create table if not exists app_settings_history (
  key text not null, value jsonb not null,
  valid_from date not null, valid_to date,         -- null = đang hiệu lực
  changed_by uuid references profiles(id), reason text, created_at timestamptz default now(),
  primary key (key, valid_from)
);

-- Đọc setting tài chính theo NGÀY giao dịch (quá khứ không bị rewrite)
create or replace function get_setting(p_key text, p_on date default current_date)
returns jsonb language sql stable as $$
  select value from app_settings_history
  where key = p_key and valid_from <= p_on
    and (valid_to is null or p_on < valid_to)
  order by valid_from desc limit 1
$$;

-- Đổi setting tài chính = ĐÓNG bản cũ + MỞ bản mới (KHÔNG ghi đè)
create or replace function set_financial_setting(
  p_key text, p_value jsonb, p_from date, p_by uuid, p_reason text)
returns void language plpgsql as $$
begin
  update app_settings_history set valid_to = p_from
   where key = p_key and valid_to is null;
  insert into app_settings_history(key,value,valid_from,changed_by,reason)
   values (p_key, p_value, p_from, p_by, p_reason);
end $$;

-- seed các setting bắt buộc
insert into app_settings(key,value,zone) values
  ('timezone','"Asia/Ho_Chi_Minh"','OPERATIONAL'),
  ('business_day_cutoff','"04:00"','OPERATIONAL'),
  ('currency','"VND"','FINANCIAL'),
  ('vat_pct','8','FINANCIAL'),
  ('consumption_buffer_pct','10','FINANCIAL'),
  ('po_approval_threshold','5000000','FINANCIAL'),
  ('ppv_alert_pct','15','FINANCIAL')
on conflict (key) do nothing;

-- ---------------------------------------------------------------------
-- F. §19.1 Lô / Hạn dùng / FEFO + truy vết
-- ---------------------------------------------------------------------
-- Cập nhật bảng lots đã có sẵn
alter table lots add column if not exists lot_code text;
alter table lots add column if not exists supplier_id uuid references suppliers(id);
alter table lots add column if not exists received_date date;
alter table lots add column if not exists qty_received numeric;
alter table lots add column if not exists unit_cost numeric;
alter table lots add column if not exists status text default 'ACTIVE' check (status in ('ACTIVE','EXPIRED','DEPLETED'));

-- Cập nhật qty_received mặc định bằng qty_remaining cho dữ liệu cũ
update lots set qty_received = qty_remaining where qty_received is null;
alter table lots alter column qty_received set not null;

-- Thứ tự FEFO để engine chọn lô khi xuất (hạn gần nhất trước)
create or replace view v_fefo_lots as
  select * from lots
  where status = 'ACTIVE' and qty_remaining > 0
  order by ingredient_id, expiry_date nulls last, received_at;

-- ---------------------------------------------------------------------
-- G. §19.2 Hệ số hao hụt sơ chế (yield / trim)
-- ---------------------------------------------------------------------
alter table ingredients add column if not exists yield_pct numeric not null default 100 check (yield_pct > 0 and yield_pct <= 100);
alter table recipes add column if not exists yield_pct_override numeric; -- Thay thế recipe_lines bằng recipes

-- ---------------------------------------------------------------------
-- H. §19.3 Công thức con / mẻ sản xuất (BTP)
-- ---------------------------------------------------------------------
create table if not exists production_orders (
  id uuid primary key default gen_random_uuid(),
  output_ingredient_id uuid not null references ingredients(id),  -- BTP là 1 SKU
  output_qty numeric not null check (output_qty > 0),             -- sản lượng thực
  business_date date, status text default 'DONE', created_by uuid,
  created_at timestamptz default now()
);
create table if not exists production_inputs (
  production_id uuid references production_orders(id),
  ingredient_id uuid references ingredients(id),
  qty numeric not null check (qty > 0)
);

-- ---------------------------------------------------------------------
-- I. §19.4 NCC + bảng giá + PPV
-- ---------------------------------------------------------------------
alter table suppliers add column if not exists payment_terms text;
alter table suppliers add column if not exists is_active boolean default true;

create table if not exists supplier_prices (
  id uuid primary key default gen_random_uuid(),
  supplier_id uuid references suppliers(id),
  ingredient_id uuid references ingredients(id),
  price numeric not null, uom text, pack_size numeric, moq numeric,
  is_preferred boolean default false,
  valid_from date not null, valid_to date                        -- effective-dated
);

-- % biến động giá mua so với giá gần nhất (app cảnh báo nếu > ppv_alert_pct)
create or replace function ppv_pct(p_ingredient uuid, p_new_price numeric)
returns numeric language sql stable as $$
  select case when lp is null or lp = 0 then 0 else (p_new_price - lp)/lp end
  from (select price as lp from supplier_prices
        where ingredient_id = p_ingredient order by valid_from desc limit 1) x
$$;

-- ---------------------------------------------------------------------
-- J. §19.5 Kiểm kê định kỳ / cycle-count có duyệt
-- ---------------------------------------------------------------------
create table if not exists stocktakes (
  id uuid primary key default gen_random_uuid(),
  type text check (type in ('FULL','CYCLE')), scope text,
  business_date date,
  status text not null default 'DRAFT' check (status in
    ('DRAFT','COUNTING','REVIEW','APPROVED','POSTED')),
  started_by uuid references profiles(id), approved_by uuid references profiles(id), created_at timestamptz default now()
);
create table if not exists stocktake_lines (
  stocktake_id uuid references stocktakes(id),
  ingredient_id uuid references ingredients(id),
  system_qty numeric,        -- SNAPSHOT lúc freeze
  counted_qty numeric,
  variance numeric, variance_value numeric, reason text
);

-- Bổ sung cột source và note cho inventory_transactions để lưu vết nghiệp vụ và ghi chú
alter table inventory_transactions add column if not exists source text;
alter table inventory_transactions add column if not exists note text;
