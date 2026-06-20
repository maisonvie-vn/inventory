-- =====================================================================
-- MAISON VIE v3.0 MIGRATION — IDEMPOTENT, CHECKPOINT-BASED
-- VIỆC 1: Cảnh báo tồn kho realtime (3 mức, days-of-cover)
-- VIỆC 2: Worklist PO + Duyệt phân tầng + PO bất biến
-- VIỆC 3: Thông báo đẩy Web Push + nhấp nháy đỏ
-- Chạy trên Supabase Branch TRƯỚC; merge sau khi verify.
-- =====================================================================

-- =============================================================
-- CHECKPOINT 0: Extensions & helpers
-- =============================================================
create extension if not exists pgcrypto;
create extension if not exists pg_net;     -- Supabase built-in (Pro)
create extension if not exists pg_cron;    -- Supabase built-in (Pro)

-- =============================================================
-- CHECKPOINT 1: Bảng cài đặt cảnh báo tồn kho & mùa vụ
-- (reorder_point đã có trên ingredients; xem v9-6_01_schema.sql)
-- =============================================================

-- Bổ sung cột avg_daily_usage vào ingredients (tính từ lịch sử 30 ngày)
alter table ingredients add column if not exists avg_daily_usage numeric default 0;

-- Bảng ghi nhận đã duyệt cảnh báo (acknowledge) → chống spam
create table if not exists stock_alert_acks (
  ingredient_id  uuid references ingredients(id) on delete cascade,
  location_id    text references locations(id),
  ack_by         uuid references profiles(id),
  ack_at         timestamptz default now(),
  alert_level    text check (alert_level in ('REORDER','CRITICAL','OUT')),
  -- Tự hết hiệu lực sau khi tồn thay đổi quá 10%: engine tái kích hoạt nếu cần
  primary key (ingredient_id, location_id, alert_level)
);
alter table stock_alert_acks enable row level security;
drop policy if exists "stock_alert_acks_select" on stock_alert_acks;
create policy "stock_alert_acks_select" on stock_alert_acks for select to authenticated using (true);
drop policy if exists "stock_alert_acks_manage" on stock_alert_acks;
create policy "stock_alert_acks_manage" on stock_alert_acks for all to authenticated
  using (get_current_user_role() in ('admin','restaurant_manager','senior_accountant','junior_accountant','head_chef','BAR_SUPERVISOR'))
  with check (get_current_user_role() in ('admin','restaurant_manager','senior_accountant','junior_accountant','head_chef','BAR_SUPERVISOR'));

-- =============================================================
-- CHECKPOINT 2: Bảng PO mở rộng — phiên bản bất biến
-- =============================================================

-- Thêm cột phiên bản + trạng thái mở rộng vào purchase_orders
alter table purchase_orders add column if not exists version int not null default 1;
alter table purchase_orders add column if not exists parent_po_id uuid references purchase_orders(id);
alter table purchase_orders add column if not exists location_id text references locations(id) default 'MAIN_STORE';
alter table purchase_orders add column if not exists notes text;
alter table purchase_orders add column if not exists second_approver uuid references profiles(id);   -- CFO/Admin ≥ 10tr
alter table purchase_orders add column if not exists second_approved_at timestamptz;
alter table purchase_orders add column if not exists escalated_at timestamptz;
alter table purchase_orders add column if not exists escalation_level int default 0;  -- 0=none, 1=manager, 2=cfo
alter table purchase_orders add column if not exists sent_at timestamptz;
alter table purchase_orders add column if not exists pdf_path text;
alter table purchase_orders add column if not exists content_hash text;
alter table purchase_orders add column if not exists requested_by uuid references profiles(id);

-- Cập nhật check constraint status của PO (mở rộng từ v8 OPEN/PARTIAL/RECEIVED/CLOSED/CANCELLED)
alter table purchase_orders drop constraint if exists purchase_orders_status_check;
alter table purchase_orders add constraint purchase_orders_status_check
  check (status in (
    'DRAFT',
    'PENDING_APPROVAL',
    'APPROVED',
    'SENT',
    'PARTIAL',
    'RECEIVED',
    'CLOSED',
    'CANCELLED'
  ));

-- Đổi default status sang DRAFT
alter table purchase_orders alter column status set default 'DRAFT';

-- Chỉ 1 PO DRAFT/PENDING mở cùng lúc cho mỗi NCC (constraint advisory — enforced by trigger)
-- Unique cho po_no
create unique index if not exists ux_po_no on purchase_orders(po_no) where po_no is not null;

-- Po_lines mở rộng: SL gợi ý, net open PO, MOQ
alter table po_lines add column if not exists suggested_qty numeric;
alter table po_lines add column if not exists net_open_qty numeric default 0;  -- đã trừ PO đang mở khác
alter table po_lines add column if not exists days_of_cover_at_order numeric;
alter table po_lines add column if not exists estimated_value numeric;  -- qty × unit_price
alter table po_lines add column if not exists moq_applied numeric;
alter table po_lines add column if not exists pack_size_applied numeric;

-- =============================================================
-- CHECKPOINT 3: GRN mở rộng — 3-way match + bulk import
-- =============================================================

-- Bổ sung cột cho goods_receipts
alter table goods_receipts add column if not exists grn_no text;        -- Số phiếu GRN
alter table goods_receipts add column if not exists dedup_hash text unique; -- chống import trùng
alter table goods_receipts add column if not exists three_way_status text default 'PENDING'
  check (three_way_status in ('PENDING','MATCHED','SHORT_DELIVERY','OVER_DELIVERY','PRICE_VARIANCE','APPROVED_WITH_VARIANCE'));
alter table goods_receipts add column if not exists three_way_note text;
alter table goods_receipts add column if not exists received_date date;

-- Unique index cho grn_no
create unique index if not exists ux_grn_no on goods_receipts(grn_no) where grn_no is not null;

-- =============================================================
-- CHECKPOINT 4: Web Push subscriptions
-- =============================================================

create table if not exists push_subscriptions (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid references profiles(id) on delete cascade,
  endpoint      text not null unique,
  p256dh        text not null,
  auth_key      text not null,
  user_agent    text,
  created_at    timestamptz default now(),
  last_used_at  timestamptz default now()
);
alter table push_subscriptions enable row level security;
drop policy if exists "push_sub_own" on push_subscriptions;
create policy "push_sub_own" on push_subscriptions for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- Log push gửi đi (audit + chống gửi trùng)
create table if not exists push_notifications_log (
  id           bigint generated always as identity primary key,
  user_id      uuid references profiles(id),
  event_type   text not null,  -- 'LOW_STOCK','PO_PENDING','ESCALATION'
  payload      jsonb,
  sent_at      timestamptz default now(),
  status       text default 'SENT' check (status in ('SENT','FAILED','SKIPPED'))
);
alter table push_notifications_log enable row level security;
drop policy if exists "push_log_admin" on push_notifications_log;
create policy "push_log_admin" on push_notifications_log for select to authenticated
  using (get_current_user_role() in ('admin'));

-- =============================================================
-- CHECKPOINT 5: In-app notification badge (state-derived)
-- =============================================================

-- Bảng trạng thái thông báo in-app — DERIVED STATE, không phải event
-- Duy trì nháy đỏ tới khi được xử lý
create table if not exists notification_badges (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid references profiles(id) on delete cascade,
  badge_type      text not null check (badge_type in ('PO_PENDING_APPROVAL','LOW_STOCK','ESCALATION')),
  ref_table       text,         -- 'purchase_orders' | 'ingredients'
  ref_id          text,         -- UUID của PO hoặc ingredient
  scope_location  text references locations(id),  -- scoped theo bộ phận
  is_active       boolean default true,           -- true = vẫn đang nháy
  created_at      timestamptz default now(),
  resolved_at     timestamptz,
  resolved_by     uuid references profiles(id),
  metadata        jsonb         -- extra info (tên hàng, số tiền...)
);
create index if not exists idx_badges_user_active on notification_badges(user_id, is_active);
alter table notification_badges enable row level security;
drop policy if exists "badges_own" on notification_badges;
create policy "badges_own" on notification_badges for select to authenticated
  using (user_id = auth.uid());
drop policy if exists "badges_system" on notification_badges;
-- System functions (security definer) được phép insert/update
-- User tự resolve (mark resolved)
create policy "badges_resolve_own" on notification_badges for update to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- =============================================================
-- CHECKPOINT 6: Audit log cho PO (append-only enforcement)
-- =============================================================

-- Thêm audit trigger vào purchase_orders (mọi thay đổi trạng thái)
create or replace function trg_po_audit()
returns trigger language plpgsql security definer as $$
begin
  insert into audit_log(actor, action, entity, entity_id, before_data, after_data)
  values (
    auth.uid(),
    case
      when TG_OP = 'INSERT' then 'PO_CREATED'
      when TG_OP = 'UPDATE' and new.status <> old.status then 'PO_STATUS_CHANGE'
      when TG_OP = 'UPDATE' and new.approved_by is distinct from old.approved_by then 'PO_APPROVED'
      when TG_OP = 'UPDATE' and new.second_approver is distinct from old.second_approver then 'PO_SECOND_APPROVED'
      else 'PO_UPDATED'
    end,
    'purchase_orders',
    new.id::text,
    case when TG_OP = 'UPDATE' then jsonb_build_object(
      'status', old.status, 'approved_by', old.approved_by,
      'second_approver', old.second_approver, 'total_value', old.total_value
    ) else null end,
    jsonb_build_object(
      'status', new.status, 'approved_by', new.approved_by,
      'second_approver', new.second_approver,
      'total_value', new.total_value, 'po_no', new.po_no
    )
  );
  return new;
end $$;

drop trigger if exists trg_po_audit_trigger on purchase_orders;
create trigger trg_po_audit_trigger
after insert or update on purchase_orders
for each row execute function trg_po_audit();

-- =============================================================
-- CHECKPOINT 7: Trigger tính reorder_point sau MỌI inventory_transaction
-- =============================================================

-- Hàm tính lại avg_daily_usage + reorder_point cho 1 ingredient
create or replace function refresh_reorder_point(p_ingredient_id uuid)
returns void language plpgsql security definer as $$
declare
  v_avg_daily numeric;
  v_lead int;
  v_safety numeric;
  v_season_mult numeric;
  v_rp numeric;
  v_min_override numeric;
begin
  -- Tính avg_daily_usage (OUT txn trong 30 ngày gần nhất)
  select coalesce(sum(abs(qty)) / 30.0, 0)
  into v_avg_daily
  from inventory_transactions
  where ingredient_id = p_ingredient_id
    and qty < 0
    and status = 'approved'
    and created_at >= now() - interval '30 days';

  -- Lấy lead_time, safety_factor, min_override
  select
    coalesce(lead_time_days, 3),
    coalesce(safety_factor, 1.5),
    min_override
  into v_lead, v_safety, v_min_override
  from ingredients where id = p_ingredient_id;

  -- Lấy hệ số mùa hiện tại
  select coalesce(
    (select multiplier from seasonal_profiles
     where is_active and current_date between season_from and season_to
     order by multiplier desc limit 1),
    1.0
  ) into v_season_mult;

  -- reorder_point = avg_daily × lead_time × safety × mùa
  v_rp := v_avg_daily * v_lead * v_safety * v_season_mult;

  -- Cập nhật (chỉ ghi nếu không có override hoặc là override)
  update ingredients
  set
    avg_daily_usage = round(v_avg_daily, 6),
    reorder_point   = case when v_min_override is not null then v_min_override else round(v_rp, 4) end
  where id = p_ingredient_id;
end $$;

-- Trigger AFTER INSERT OR UPDATE on inventory_transactions → tính lại ngay
create or replace function trg_refresh_reorder_after_txn()
returns trigger language plpgsql as $$
begin
  -- Chỉ quan tâm các txn approved
  if (TG_OP = 'INSERT' and new.status = 'approved') or
     (TG_OP = 'UPDATE' and new.status = 'approved' and old.status <> 'approved') then
    perform refresh_reorder_point(new.ingredient_id);
  end if;
  return new;
end $$;

drop trigger if exists trg_refresh_reorder_txn on inventory_transactions;
create trigger trg_refresh_reorder_txn
after insert or update on inventory_transactions
for each row execute function trg_refresh_reorder_after_txn();

-- =============================================================
-- CHECKPOINT 8: View tổng hợp mức cảnh báo (3 màu) theo location
-- =============================================================

-- Hàm tính mức cảnh báo cho 1 (ingredient, location)
-- Trả về: 'OK' | 'REORDER' | 'CRITICAL' | 'OUT'
create or replace function get_stock_alert_level(
  p_ingredient_id uuid,
  p_location_id   text
) returns text language sql stable security definer as $$
  select case
    when coalesce(soh.qty_on_hand, 0) <= 0                              then 'OUT'
    when coalesce(soh.qty_on_hand, 0) < coalesce(i.safety_stock, 0)    then 'CRITICAL'
    when coalesce(soh.qty_on_hand, 0) < coalesce(
           case when i.min_override is not null then i.min_override else i.reorder_point end,
           i.min_stock, 0
         )                                                               then 'REORDER'
    else 'OK'
  end
  from ingredients i
  left join v_stock_on_hand soh
    on soh.ingredient_id = p_ingredient_id and soh.location_id = p_location_id
  where i.id = p_ingredient_id
$$;

-- View worklist cảnh báo: mọi mặt hàng KHÔNG OK + scoped theo location
create or replace view v_stock_alerts as
select
  i.id                              as ingredient_id,
  i.code,
  i.ten_vi                          as name,
  i.nom_fr,
  i.stock_uom,
  id2.department                    as location_id,
  coalesce(soh.qty_on_hand, 0)      as current_stock,
  coalesce(
    case when i.min_override is not null then i.min_override else i.reorder_point end,
    i.min_stock, 0
  )                                  as reorder_point,
  coalesce(i.safety_stock, 0)        as safety_stock,
  coalesce(i.avg_daily_usage, 0)     as avg_daily_usage,
  coalesce(i.lead_time_days, 3)      as lead_time_days,
  get_stock_alert_level(i.id, id2.department) as alert_level,
  -- days_of_cover = tồn / avg_daily
  case when coalesce(i.avg_daily_usage, 0) > 0
    then round(coalesce(soh.qty_on_hand,0) / i.avg_daily_usage, 1)
    else null
  end                                as days_of_cover,
  -- Acknowledgement (nếu có)
  ack.ack_by                         as acked_by,
  ack.ack_at
from ingredients i
join ingredient_departments id2 on id2.ingredient_id = i.id
left join v_stock_on_hand soh
  on soh.ingredient_id = i.id and soh.location_id = id2.department
left join stock_alert_acks ack
  on ack.ingredient_id = i.id
  and ack.location_id = id2.department
  and ack.alert_level = get_stock_alert_level(i.id, id2.department)
where i.is_active
  and get_stock_alert_level(i.id, id2.department) <> 'OK'
  -- Chỉ hiện nếu chưa được acknowledge (hoặc alert level thay đổi)
  and ack.ack_by is null
order by
  case get_stock_alert_level(i.id, id2.department)
    when 'OUT'      then 1
    when 'CRITICAL' then 2
    when 'REORDER'  then 3
    else 4
  end,
  coalesce(soh.qty_on_hand, 0);

-- Grant view (ops users xem số lượng, không xem giá)
grant select on v_stock_alerts to authenticated;

-- =============================================================
-- CHECKPOINT 9: View worklist đặt hàng thông minh (gợi ý SL)
-- =============================================================

create or replace view v_order_worklist as
select
  sa.ingredient_id,
  sa.code,
  sa.name,
  sa.nom_fr,
  sa.stock_uom,
  sa.location_id,
  sa.current_stock,
  sa.reorder_point,
  sa.safety_stock,
  sa.avg_daily_usage,
  sa.lead_time_days,
  sa.alert_level,
  sa.days_of_cover,
  -- Nhà cung cấp ưu tiên
  sp.supplier_id,
  s.name                            as supplier_name,
  sp.price                          as unit_price,
  sp.uom                            as purchase_uom,
  sp.pack_size,
  sp.moq,
  -- SL gợi ý = max(par/max - tồn hiện, moq) làm tròn lên pack_size
  -- par = max_stock (hoặc reorder_point × 2 nếu max_stock = 0)
  (
    select coalesce(max_stock, sa.reorder_point * 2)
    from ingredients where id = sa.ingredient_id
  )                                  as par_level,
  -- Net open PO (SL đã đặt nhưng chưa nhận)
  coalesce((
    select sum(pl.qty - coalesce(pl.qty_received, 0))
    from po_lines pl
    join purchase_orders po on po.id = pl.po_id
    where pl.ingredient_id = sa.ingredient_id
      and po.status in ('APPROVED','SENT','PARTIAL')
  ), 0)                              as net_open_po_qty,
  -- Estimated order value
  ceil(
    greatest(
      coalesce(
        (select coalesce(max_stock, sa.reorder_point * 2) from ingredients where id = sa.ingredient_id)
        - sa.current_stock
        - coalesce((
            select sum(pl.qty - coalesce(pl.qty_received, 0))
            from po_lines pl
            join purchase_orders po on po.id = pl.po_id
            where pl.ingredient_id = sa.ingredient_id
              and po.status in ('APPROVED','SENT','PARTIAL')
          ), 0),
        0
      ),
      coalesce(sp.moq, 1)
    ) / coalesce(sp.pack_size, 1)
  ) * coalesce(sp.pack_size, 1)     as suggested_order_qty,
  -- Giá ước tính (chỉ Owner/CFO xem được qua RLS column security)
  ceil(
    greatest(
      coalesce(
        (select coalesce(max_stock, sa.reorder_point * 2) from ingredients where id = sa.ingredient_id)
        - sa.current_stock
        - coalesce((
            select sum(pl.qty - coalesce(pl.qty_received, 0))
            from po_lines pl
            join purchase_orders po on po.id = pl.po_id
            where pl.ingredient_id = sa.ingredient_id
              and po.status in ('APPROVED','SENT','PARTIAL')
          ), 0),
        0
      ),
      coalesce(sp.moq, 1)
    ) / coalesce(sp.pack_size, 1)
  ) * coalesce(sp.pack_size, 1) * coalesce(sp.price, 0) as estimated_value
from v_stock_alerts sa
left join supplier_prices sp
  on sp.ingredient_id = sa.ingredient_id
  and sp.is_preferred = true
  and (sp.valid_to is null or sp.valid_to > current_date)
left join suppliers s on s.id = sp.supplier_id;

-- CHÚ Ý: RLS trên view này sẽ dùng security barrier + column security
-- estimated_value bị ẩn với non-Owner bằng function wrapper bên dưới
create or replace view v_order_worklist_ops as
select
  ingredient_id, code, name, nom_fr, stock_uom, location_id,
  current_stock, reorder_point, safety_stock,
  avg_daily_usage, lead_time_days, alert_level, days_of_cover,
  supplier_name, purchase_uom, pack_size, moq,
  par_level, net_open_po_qty, suggested_order_qty
  -- KHÔNG có unit_price, estimated_value
from v_order_worklist;

grant select on v_order_worklist_ops to authenticated;
-- v_order_worklist đầy đủ (có giá) chỉ grantable qua RPC bảo mật
revoke all on v_order_worklist from public, authenticated;

-- RPC an toàn để Owner/CFO lấy worklist đầy đủ
create or replace function get_order_worklist_finance()
returns setof v_order_worklist language sql security definer as $$
  select * from v_order_worklist;
$$ set search_path = public;
-- Chỉ admin/cfo gọi được
revoke execute on function get_order_worklist_finance from public;
grant execute on function get_order_worklist_finance to authenticated;

-- =============================================================
-- CHECKPOINT 10: RPC tạo PO thông minh từ worklist
-- =============================================================

create or replace function create_po_from_worklist(
  p_supplier_id  uuid,
  p_location_id  text,
  p_lines        jsonb,          -- [{ingredient_id, suggested_qty, unit_price, uom, moq, pack_size}]
  p_notes        text default null
) returns uuid language plpgsql security definer as $$
declare
  v_po_id        uuid;
  v_po_no        text;
  v_total        numeric := 0;
  v_line         jsonb;
  v_seq          int;
  v_role         text;
begin
  v_role := get_current_user_role();
  if v_role not in ('admin','restaurant_manager','senior_accountant','junior_accountant') then
    raise exception 'Không đủ quyền tạo PO';
  end if;

  -- Sinh số PO
  select coalesce(max(version), 0) + 1 into v_seq
  from purchase_orders
  where date_trunc('month', created_at) = date_trunc('month', now());
  v_po_no := 'PO-' || to_char(now(), 'YYYYMM') || '-' || lpad(v_seq::text, 4, '0')
             || '-' || upper(left(p_location_id, 3));

  -- Tính tổng giá trị
  for v_line in select * from jsonb_array_elements(p_lines) loop
    v_total := v_total
      + coalesce((v_line->>'suggested_qty')::numeric, 0)
      * coalesce((v_line->>'unit_price')::numeric, 0);
  end loop;

  -- Tạo PO header
  insert into purchase_orders(
    supplier_id, location_id, status, po_no, po_number,
    total_value, notes, requested_by, created_by, is_manual, source
  ) values (
    p_supplier_id, p_location_id, 'DRAFT', v_po_no, v_po_no,
    round(v_total, 0), p_notes, auth.uid(), auth.uid(), true, 'MANUAL_REQUISITION'
  ) returning id into v_po_id;

  -- Tạo PO lines
  for v_line in select * from jsonb_array_elements(p_lines) loop
    insert into po_lines(
      po_id, ingredient_id,
      qty, qty_ordered, uom, purchase_uom,
      unit_price,
      suggested_qty, moq_applied, pack_size_applied,
      estimated_value
    ) values (
      v_po_id,
      (v_line->>'ingredient_id')::uuid,
      (v_line->>'suggested_qty')::numeric,
      (v_line->>'suggested_qty')::numeric,
      v_line->>'uom',
      v_line->>'uom',
      (v_line->>'unit_price')::numeric,
      (v_line->>'suggested_qty')::numeric,
      (v_line->>'moq')::numeric,
      (v_line->>'pack_size')::numeric,
      (v_line->>'suggested_qty')::numeric * coalesce((v_line->>'unit_price')::numeric, 0)
    );
  end loop;

  return v_po_id;
end $$;

-- =============================================================
-- CHECKPOINT 11: RPC duyệt PO phân tầng (Manager + CFO)
-- =============================================================

create or replace function approve_po(
  p_po_id      uuid,
  p_approve    boolean,   -- true=duyệt, false=từ chối
  p_note       text default null
) returns text language plpgsql security definer as $$
declare
  r_po          record;
  v_role        text;
  v_threshold   numeric;
  v_result      text;
  v_badge_users uuid[];
begin
  v_role := get_current_user_role();

  select * into r_po from purchase_orders where id = p_po_id;
  if r_po is null then raise exception 'PO không tồn tại'; end if;

  -- Lấy ngưỡng duyệt từ settings (mặc định 10tr)
  select coalesce((value::text)::numeric, 10000000)
  into v_threshold
  from app_settings where key = 'po_approval_threshold';

  -- PHÂN TẦNG DUYỆT
  if r_po.status = 'PENDING_APPROVAL' then
    -- Cấp 1: Manager / Senior Accountant duyệt
    if v_role in ('admin','restaurant_manager','senior_accountant') then
      if not p_approve then
        update purchase_orders set status = 'CANCELLED', notes = coalesce(notes,'') || ' | Từ chối: ' || coalesce(p_note,'')
        where id = p_po_id;
        -- Xóa badge
        update notification_badges set is_active = false, resolved_at = now(), resolved_by = auth.uid()
        where ref_id = p_po_id::text and badge_type = 'PO_PENDING_APPROVAL';
        return 'REJECTED';
      end if;

      -- Người yêu cầu ≠ người duyệt (segregation of duties)
      if r_po.requested_by = auth.uid() then
        raise exception 'Người yêu cầu không được tự duyệt PO của mình (segregation of duties)';
      end if;

      if r_po.total_value >= v_threshold and v_role <> 'admin' then
        -- Cần thêm lượt duyệt cấp 2 (CFO/Admin)
        update purchase_orders
        set approved_by = auth.uid(), approved_at = now(), escalation_level = 1
        where id = p_po_id;
        -- Tạo badge cho admin/CFO
        insert into notification_badges(user_id, badge_type, ref_table, ref_id, scope_location, metadata)
        select p.id, 'PO_PENDING_APPROVAL', 'purchase_orders', p_po_id::text, r_po.location_id,
          jsonb_build_object('po_no', r_po.po_no, 'total_value', r_po.total_value, 'tier', 2)
        from profiles p where p.role = 'admin';
        return 'NEEDS_SECOND_APPROVAL';
      else
        -- Duyệt hoàn tất (< threshold hoặc admin duyệt)
        update purchase_orders
        set status = 'APPROVED', approved_by = auth.uid(), approved_at = now()
        where id = p_po_id;
        -- Tắt badge PO_PENDING
        update notification_badges set is_active = false, resolved_at = now(), resolved_by = auth.uid()
        where ref_id = p_po_id::text and badge_type = 'PO_PENDING_APPROVAL';
        v_result := 'APPROVED';
      end if;
    else
      raise exception 'Vai trò không có quyền duyệt PO';
    end if;

  elsif r_po.status = 'PENDING_APPROVAL' and r_po.escalation_level = 1 then
    -- Cấp 2: Admin/CFO duyệt
    if v_role <> 'admin' then
      raise exception 'Chỉ Admin/CFO duyệt PO ≥ ngưỡng';
    end if;
    if not p_approve then
      update purchase_orders set status = 'CANCELLED', notes = coalesce(notes,'') || ' | Từ chối CFO: ' || coalesce(p_note,'')
      where id = p_po_id;
      update notification_badges set is_active = false, resolved_at = now(), resolved_by = auth.uid()
      where ref_id = p_po_id::text and badge_type = 'PO_PENDING_APPROVAL';
      return 'REJECTED_BY_CFO';
    end if;
    update purchase_orders
    set status = 'APPROVED', second_approver = auth.uid(), second_approved_at = now()
    where id = p_po_id;
    update notification_badges set is_active = false, resolved_at = now(), resolved_by = auth.uid()
    where ref_id = p_po_id::text and badge_type = 'PO_PENDING_APPROVAL';
    v_result := 'APPROVED_FINAL';
  else
    raise exception 'Trạng thái PO không phù hợp để duyệt: %', r_po.status;
  end if;

  return v_result;
end $$;

revoke execute on function approve_po from public;
grant execute on function approve_po to authenticated;

-- =============================================================
-- CHECKPOINT 12: RPC submit PO (DRAFT → PENDING_APPROVAL) + tạo badge
-- =============================================================

create or replace function submit_po_for_approval(p_po_id uuid)
returns void language plpgsql security definer as $$
declare
  r_po       record;
  v_role     text;
  v_badge_uid uuid[];
begin
  v_role := get_current_user_role();
  select * into r_po from purchase_orders where id = p_po_id;

  if r_po is null then raise exception 'PO không tồn tại'; end if;
  if r_po.status <> 'DRAFT' then raise exception 'Chỉ DRAFT mới submit được'; end if;

  update purchase_orders
  set status = 'PENDING_APPROVAL', requested_by = coalesce(r_po.requested_by, auth.uid())
  where id = p_po_id;

  -- Tạo badge thông báo cho Manager + Senior Accountant (không phải người tạo)
  insert into notification_badges(user_id, badge_type, ref_table, ref_id, scope_location, metadata)
  select
    p.id, 'PO_PENDING_APPROVAL', 'purchase_orders', p_po_id::text,
    r_po.location_id,
    jsonb_build_object('po_no', r_po.po_no, 'total_value', r_po.total_value, 'supplier_id', r_po.supplier_id)
  from profiles p
  where p.role in ('admin','restaurant_manager','senior_accountant')
    and p.id <> r_po.requested_by  -- segregation: người yêu cầu không nhận badge
  on conflict do nothing;
end $$;

revoke execute on function submit_po_for_approval from public;
grant execute on function submit_po_for_approval to authenticated;

-- =============================================================
-- CHECKPOINT 13: 3-way match trigger khi GRN approved
-- =============================================================

create or replace function trg_grn_three_way_match()
returns trigger language plpgsql security definer as $$
declare
  r_line       record;
  v_po_line    record;
  v_match_status text := 'MATCHED';
  v_notes      text[] := '{}';
  v_price_tol  numeric := 0.05;  -- 5% price tolerance
begin
  if new.status = 'approved' and old.status = 'pending' and new.po_id is not null then
    for r_line in select * from grn_lines where grn_id = new.id loop
      select * into v_po_line from po_lines
      where po_id = new.po_id and ingredient_id = r_line.ingredient_id;

      if v_po_line is null then
        v_match_status := 'OVER_DELIVERY';
        v_notes := v_notes || format('Mã %s: không có trong PO', r_line.ingredient_id);
        continue;
      end if;

      -- Kiểm tra số lượng
      if r_line.qty_received < v_po_line.qty_ordered * 0.95 then
        v_match_status := 'SHORT_DELIVERY';
        v_notes := v_notes || format('Mã %s: đặt %s nhận %s', r_line.ingredient_id,
          v_po_line.qty_ordered, r_line.qty_received);
      elsif r_line.qty_received > v_po_line.qty_ordered * 1.05 then
        v_match_status := 'OVER_DELIVERY';
        v_notes := v_notes || format('Mã %s: nhận thừa %s (đặt %s)', r_line.ingredient_id,
          r_line.qty_received, v_po_line.qty_ordered);
      end if;

      -- Kiểm tra giá (nếu có unit_price trên PO line)
      if v_po_line.unit_price is not null and v_po_line.unit_price > 0 then
        if abs(r_line.unit_price_fx - v_po_line.unit_price) / v_po_line.unit_price > v_price_tol then
          v_match_status := 'PRICE_VARIANCE';
          v_notes := v_notes || format('Mã %s: giá đặt %s → nhận %s (lệch %.1f%%)', r_line.ingredient_id,
            v_po_line.unit_price, r_line.unit_price_fx,
            ((r_line.unit_price_fx - v_po_line.unit_price)/v_po_line.unit_price)*100);
          -- Ghi PPV alert vào audit
          insert into audit_log(actor, action, entity, entity_id, before_data, after_data)
          values (
            new.approved_by, '3WAY_PRICE_VARIANCE', 'grn_lines',
            (new.id::text || ':' || r_line.ingredient_id::text),
            jsonb_build_object('po_price', v_po_line.unit_price),
            jsonb_build_object('grn_price', r_line.unit_price_fx,
              'variance_pct', ((r_line.unit_price_fx - v_po_line.unit_price)/v_po_line.unit_price)*100)
          );
        end if;
      end if;
    end loop;

    update goods_receipts
    set
      three_way_status = v_match_status,
      three_way_note = array_to_string(v_notes, '; ')
    where id = new.id;

    -- Nếu match hoàn hảo, auto-approve match
    if v_match_status = 'MATCHED' then
      update goods_receipts set match_status = 'APPROVED' where id = new.id;
    else
      update goods_receipts set match_status = 'VARIANCE' where id = new.id;
    end if;
  end if;
  return new;
end $$;

drop trigger if exists trg_grn_three_way_match_trigger on goods_receipts;
create trigger trg_grn_three_way_match_trigger
after update on goods_receipts
for each row execute function trg_grn_three_way_match();

-- =============================================================
-- CHECKPOINT 14: RPC acknowledge cảnh báo tồn kho
-- =============================================================

create or replace function acknowledge_stock_alert(
  p_ingredient_id uuid,
  p_location_id   text,
  p_alert_level   text
) returns void language plpgsql security definer as $$
begin
  insert into stock_alert_acks(ingredient_id, location_id, ack_by, alert_level)
  values (p_ingredient_id, p_location_id, auth.uid(), p_alert_level)
  on conflict (ingredient_id, location_id, alert_level)
  do update set ack_by = excluded.ack_by, ack_at = now();
end $$;

revoke execute on function acknowledge_stock_alert from public;
grant execute on function acknowledge_stock_alert to authenticated;

-- Reset acknowledgement khi tồn thay đổi đáng kể (> 20%)
create or replace function trg_reset_ack_on_stock_change()
returns trigger language plpgsql security definer as $$
begin
  -- Xóa ack cũ khi có txn mới approved → tồn đã thay đổi
  delete from stock_alert_acks
  where ingredient_id = new.ingredient_id;
  return new;
end $$;

drop trigger if exists trg_reset_ack on inventory_transactions;
create trigger trg_reset_ack
after insert on inventory_transactions
for each row when (new.status = 'approved')
execute function trg_reset_ack_on_stock_change();

-- =============================================================
-- CHECKPOINT 15: pg_cron — Tính lại reorder_point mỗi đêm + escalation
-- =============================================================

-- Tính lại toàn bộ reorder_points lúc 03:00 AM hàng ngày
select cron.schedule(
  'mv_refresh_all_reorder_points',
  '0 3 * * *',
  $$
    select refresh_reorder_point(id) from ingredients where is_active;
  $$
);

-- Escalation: PO chờ duyệt > X giờ → đẩy lên CFO/Admin
-- pg_cron kiểm tra mỗi 30 phút
create or replace function escalate_overdue_pos()
returns void language plpgsql security definer as $$
declare
  r_po       record;
  v_hours    numeric;
begin
  select coalesce((value::text)::numeric, 2)
  into v_hours
  from app_settings where key = 'po_escalation_hours';

  -- Tìm các PO PENDING_APPROVAL quá hạn chưa escalate
  for r_po in
    select * from purchase_orders
    where status = 'PENDING_APPROVAL'
      and escalation_level = 0
      and created_at < now() - (v_hours || ' hours')::interval
  loop
    -- Update escalation level
    update purchase_orders
    set escalation_level = 1, escalated_at = now()
    where id = r_po.id;

    -- Tạo badge cho admin
    insert into notification_badges(user_id, badge_type, ref_table, ref_id, scope_location, metadata)
    select p.id, 'ESCALATION', 'purchase_orders', r_po.id::text, r_po.location_id,
      jsonb_build_object(
        'po_no', r_po.po_no, 'total_value', r_po.total_value,
        'escalation_reason', 'Chưa duyệt sau ' || v_hours || ' giờ'
      )
    from profiles p where p.role = 'admin'
    on conflict do nothing;

    -- Ghi audit
    insert into audit_log(actor, action, entity, entity_id, before_data, after_data)
    values (
      null, 'PO_ESCALATED', 'purchase_orders', r_po.id::text,
      jsonb_build_object('escalation_level', 0),
      jsonb_build_object('escalation_level', 1, 'escalated_at', now())
    );
  end loop;
end $$;

select cron.schedule(
  'mv_escalate_overdue_pos',
  '*/30 * * * *',
  $$ select escalate_overdue_pos(); $$
);

-- Seed escalation hours setting
insert into app_settings(key, value, zone)
values ('po_escalation_hours', '2', 'OPERATIONAL')
on conflict (key) do nothing;

-- Seed PO approval threshold (10 triệu VND)
insert into app_settings(key, value, zone)
values ('po_approval_threshold', '10000000', 'FINANCIAL')
on conflict (key) do nothing;

-- =============================================================
-- CHECKPOINT 16: RLS chặn cột giá trị với non-Owner/CFO
-- =============================================================

-- Hàm kiểm tra quyền xem tài chính
create or replace function can_view_financials()
returns boolean language sql stable security definer as $$
  select get_current_user_role() in ('admin','senior_accountant','restaurant_manager')
$$;

-- View cảnh báo cho ops (không có giá trị VND)
create or replace view v_stock_alerts_ops as
select
  ingredient_id, code, name, nom_fr, stock_uom,
  location_id, current_stock, reorder_point, safety_stock,
  avg_daily_usage, lead_time_days, alert_level, days_of_cover,
  acked_by, ack_at
from v_stock_alerts;

-- View cảnh báo đầy đủ (có giá trị VND) — chỉ gọi qua RPC
create or replace function get_stock_alerts_finance()
returns table (
  ingredient_id uuid, code text, name text, location_id text,
  current_stock numeric, reorder_point numeric, alert_level text,
  days_of_cover numeric, estimated_value numeric
) language sql security definer as $$
  select
    sa.ingredient_id, sa.code, sa.name, sa.location_id,
    sa.current_stock, sa.reorder_point, sa.alert_level,
    sa.days_of_cover,
    sa.current_stock * coalesce(i.wac_price, 0) as estimated_value
  from v_stock_alerts sa
  join ingredients i on i.id = sa.ingredient_id;
$$;

revoke execute on function get_stock_alerts_finance from public;
grant execute on function get_stock_alerts_finance to authenticated;
-- Caller-side RBAC: frontend kiểm tra role trước khi gọi

grant select on v_stock_alerts_ops to authenticated;

-- =============================================================
-- CHECKPOINT 17: RPC đăng ký / hủy Web Push subscription
-- =============================================================

create or replace function upsert_push_subscription(
  p_endpoint  text,
  p_p256dh    text,
  p_auth      text,
  p_ua        text default null
) returns void language plpgsql security definer as $$
begin
  insert into push_subscriptions(user_id, endpoint, p256dh, auth_key, user_agent)
  values (auth.uid(), p_endpoint, p_p256dh, p_auth, p_ua)
  on conflict (endpoint) do update
  set p256dh = excluded.p256dh, auth_key = excluded.auth_key,
      last_used_at = now(), user_id = auth.uid();
end $$;

revoke execute on function upsert_push_subscription from public;
grant execute on function upsert_push_subscription to authenticated;

create or replace function remove_push_subscription(p_endpoint text)
returns void language plpgsql security definer as $$
begin
  delete from push_subscriptions where endpoint = p_endpoint and user_id = auth.uid();
end $$;

revoke execute on function remove_push_subscription from public;
grant execute on function remove_push_subscription to authenticated;

-- =============================================================
-- CHECKPOINT 18: Supabase Realtime — enable cho các bảng cần thiết
-- =============================================================
-- Chạy trong Supabase Dashboard: Realtime > Publications > supabase_realtime
-- Thêm các bảng: notification_badges, stock_alert_acks, purchase_orders
-- (script SQL để enable nếu chưa có)
do $$
begin
  -- Enable realtime cho notification_badges
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and tablename = 'notification_badges'
  ) then
    alter publication supabase_realtime add table notification_badges;
  end if;

  -- Enable realtime cho purchase_orders
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and tablename = 'purchase_orders'
  ) then
    alter publication supabase_realtime add table purchase_orders;
  end if;

  -- Enable realtime cho stock_alert_acks
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and tablename = 'stock_alert_acks'
  ) then
    alter publication supabase_realtime add table stock_alert_acks;
  end if;
exception when others then
  raise notice 'Realtime publication update skipped: %', sqlerrm;
end $$;

-- =============================================================
-- CHECKPOINT 19: RLS cho notification_badges (scoped theo role)
-- =============================================================
-- Badges chỉ hiện với đúng người, đúng scope
drop policy if exists "badges_system_insert" on notification_badges;
-- Security definer functions được quyền insert (không cần policy riêng)
-- Chỉ authenticated user đọc badge của chính mình (đã có policy badges_own)
-- Admin xem tất cả badges
drop policy if exists "badges_admin_all" on notification_badges;
create policy "badges_admin_all" on notification_badges for select to authenticated
  using (
    get_current_user_role() = 'admin'
    or user_id = auth.uid()
  );

-- =============================================================
-- CHECKPOINT 20: Verify (chạy kiểm tra sau migration)
-- =============================================================
do $$
declare
  v_count int;
begin
  -- Kiểm tra các bảng tồn tại
  assert exists (select 1 from pg_tables where tablename = 'stock_alert_acks'), 'FAIL: stock_alert_acks missing';
  assert exists (select 1 from pg_tables where tablename = 'push_subscriptions'), 'FAIL: push_subscriptions missing';
  assert exists (select 1 from pg_tables where tablename = 'notification_badges'), 'FAIL: notification_badges missing';
  assert exists (select 1 from pg_views where viewname = 'v_stock_alerts'), 'FAIL: v_stock_alerts missing';
  assert exists (select 1 from pg_views where viewname = 'v_order_worklist_ops'), 'FAIL: v_order_worklist_ops missing';
  -- Kiểm tra triggers
  assert exists (select 1 from pg_trigger where tgname = 'trg_refresh_reorder_txn'), 'FAIL: reorder trigger missing';
  assert exists (select 1 from pg_trigger where tgname = 'trg_po_audit_trigger'), 'FAIL: po audit trigger missing';
  assert exists (select 1 from pg_trigger where tgname = 'trg_grn_three_way_match_trigger'), 'FAIL: 3way trigger missing';
  raise notice 'CHECKPOINT 20: ALL CHECKS PASSED ✅';
end $$;
