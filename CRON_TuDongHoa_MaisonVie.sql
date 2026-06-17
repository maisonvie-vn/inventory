-- =====================================================================
-- MAISON VIE — LÊN LỊCH TỰ ĐỘNG HÓA (pg_cron + pg_net + Resend)
-- Chạy trong Supabase → SQL Editor. Cần quyền owner/postgres.
--
-- ⚠️ MÚI GIỜ: pg_cron trên Supabase chạy theo UTC.  VN = UTC + 7.
--    => Mọi cron dưới đây viết theo UTC, chú thích "(VN HH:MM)" là giờ thật.
--    Đổi giờ: chỉ sửa các biểu thức cron ở MỤC 3.
--
-- ⚠️ TÊN HÀM: các hàm nghiệp vụ (generate_auto_po, compute_variance, ...)
--    là PLACEHOLDER. Thay bằng tên hàm THẬT trong DB của bạn
--    (lấy từ health-check [2] — danh sách functions).
-- =====================================================================


-- ---------------------------------------------------------------------
-- 0. CHUẨN BỊ: bật extension + nạp khóa Resend vào Vault (CHẠY 1 LẦN)
-- ---------------------------------------------------------------------
create extension if not exists pg_cron;
create extension if not exists pg_net;

-- Nạp khóa Resend vào Vault (KHÔNG hardcode trong code/app).
-- Chạy 1 lần; sau đó có thể xóa dòng này khỏi lịch sử SQL.
-- select vault.create_secret('re_xxxxxxxxxxxxxxxx', 'RESEND_API_KEY');

-- Bảng chống gửi email trùng trong ngày (anti-loop / anti-duplicate).
create table if not exists public.cron_email_log (
  job_name  text not null,
  sent_date date not null default (now() at time zone 'Asia/Ho_Chi_Minh')::date,
  primary key (job_name, sent_date)
);


-- ---------------------------------------------------------------------
-- 1. HÀM GỬI EMAIL dùng chung (pg_net → Resend, khóa lấy từ Vault)
-- ---------------------------------------------------------------------
create or replace function public.send_email(
  p_to text, p_subject text, p_html text
) returns bigint
language plpgsql
security definer
set search_path = public, vault, net
as $func$
declare
  v_key  text;
  v_from text;
  v_req  bigint;
begin
  select decrypted_secret into v_key
  from vault.decrypted_secrets where name = 'RESEND_API_KEY' limit 1;

  select coalesce(email_from, 'no-reply@maisonvie.vn') into v_from
  from public.system_settings limit 1;

  if v_key is null then
    raise notice 'RESEND_API_KEY chưa có trong Vault — bỏ qua gửi email.';
    return null;
  end if;

  select net.http_post(
    url     := 'https://api.resend.com/emails',
    headers := jsonb_build_object(
      'Authorization', 'Bearer ' || v_key,
      'Content-Type',  'application/json'
    ),
    body := jsonb_build_object(
      'from',    v_from,
      'to',      p_to,
      'subject', p_subject,
      'html',    p_html
    )
  ) into v_req;

  return v_req;
end;
$func$;


-- ---------------------------------------------------------------------
-- 2. VÍ DỤ: email cảnh báo tồn thấp (có chống gửi trùng trong ngày)
--    => Đổi tên cột cho khớp schema thật (current_stock/min_stock/...).
-- ---------------------------------------------------------------------
create or replace function public.send_lowstock_email()
returns void
language plpgsql
security definer
set search_path = public
as $func$
declare
  v_today date := (now() at time zone 'Asia/Ho_Chi_Minh')::date;
  v_rows  text;
  v_to    text := 'mua-hang@maisonvie.vn';   -- đổi thành người nhận thật
begin
  -- đã gửi hôm nay rồi thì thôi
  if exists (select 1 from public.cron_email_log
             where job_name = 'lowstock_email' and sent_date = v_today) then
    return;
  end if;

  -- dựng các dòng HTML cho mã dưới mức tối thiểu
  select string_agg(
           format('<tr><td>%s</td><td>%s</td><td style="text-align:right">%s</td>'
               || '<td style="text-align:right">%s</td></tr>',
               i.code, i.name, round(i.current_stock,2), round(i.min_stock,2)),
           '' order by (i.current_stock / nullif(i.min_stock,0)) )
    into v_rows
  from public.ingredients i
  where i.is_active and i.current_stock <= i.min_stock;

  if v_rows is null then
    return;  -- không có mã nào cảnh báo
  end if;

  perform public.send_email(
    v_to,
    format('[Maison Vie] Cảnh báo tồn thấp — %s', to_char(v_today,'DD/MM/YYYY')),
    '<h3>Nguyên liệu chạm/under mức tối thiểu</h3>'
    || '<table border="1" cellpadding="6" style="border-collapse:collapse">'
    || '<tr><th>Mã</th><th>Tên</th><th>Tồn</th><th>Mức tối thiểu</th></tr>'
    || v_rows || '</table>'
  );

  insert into public.cron_email_log(job_name, sent_date)
  values ('lowstock_email', v_today)
  on conflict do nothing;
end;
$func$;


-- ---------------------------------------------------------------------
-- 3. LÊN LỊCH CÁC CRON  (UTC — chú thích là giờ VN, nhà hàng đóng ~23:00)
--    Sửa giờ: chỉ đổi biểu thức cron. Cú pháp: phút giờ ngày tháng thứ
-- ---------------------------------------------------------------------

-- (1) Auto-close ngày — lưới an toàn nếu bộ phận quên bấm chốt | VN 02:00
select cron.schedule('auto_close',     '0 19 * * *',  $$ select public.auto_close_day();        $$);

-- (2) Tính variance sau chốt                                   | VN 02:30
select cron.schedule('variance_nightly','30 19 * * *', $$ select public.compute_variance();       $$);

-- (3) Sinh PO nháp (Auto-PO / reorder)                         | VN 06:30
select cron.schedule('auto_po',        '30 23 * * *', $$ select public.generate_auto_po();        $$);

-- (4) Email cảnh báo tồn thấp                                  | VN 07:00
select cron.schedule('lowstock_email', '0 0 * * *',   $$ select public.send_lowstock_email();     $$);

-- (5) Cảnh báo hạn dùng (FEFO/HACCP)                           | VN 07:05
select cron.schedule('expiry_alert',   '5 0 * * *',   $$ select public.send_expiry_alert();       $$);

-- (6) PO quá hạn giao                                          | VN 07:10
select cron.schedule('po_aging',       '10 0 * * *',  $$ select public.flag_overdue_po();         $$);

-- (7) Email báo cáo ngày (food cost, variance, can thiệp admin)| VN 08:00
select cron.schedule('daily_report',   '0 1 * * *',   $$ select public.send_daily_report();       $$);

-- (8) Báo cáo tuần (variance/menu-engineering) — Thứ 2         | VN T2 08:30
select cron.schedule('weekly_report',  '30 1 * * 1',  $$ select public.send_weekly_report();      $$);

-- (9) Tạo partition tháng mới cho inventory_transactions       | ngày 1, VN 08:00
select cron.schedule('monthly_partition','0 1 1 * *', $$ select public.create_next_month_partition(); $$);

-- (10) Dọn file Excel thô cũ trong Storage (retention) — CN    | VN CN 10:00
select cron.schedule('storage_cleanup','0 3 * * 0',   $$ select public.cleanup_old_uploads();     $$);


-- ---------------------------------------------------------------------
-- 4. QUẢN LÝ JOB
-- ---------------------------------------------------------------------
-- Xem tất cả job:
--   select jobid, jobname, schedule, active from cron.job order by jobid;
-- Xem lịch sử chạy:
--   select jobid, status, return_message, start_time
--   from cron.job_run_details order by start_time desc limit 50;
-- Tắt 1 job:        select cron.unschedule('auto_po');
-- Đổi giờ 1 job:    unschedule rồi schedule lại với biểu thức mới.

-- =====================================================================
-- LƯU Ý TRIỂN KHAI:
--  • Thay placeholder hàm (auto_close_day, compute_variance, generate_auto_po,
--    send_expiry_alert, flag_overdue_po, send_daily_report, send_weekly_report,
--    create_next_month_partition, cleanup_old_uploads) bằng TÊN HÀM THẬT.
--    Hàm nào CHƯA có thì phải viết phần thân trước khi schedule.
--  • send_email + send_lowstock_email ở trên là BẢN DÙNG ĐƯỢC NGAY
--    (chỉ cần nạp RESEND_API_KEY vào Vault + xác thực domain SPF/DKIM).
--  • Việc theo SỰ KIỆN (WAC khi nhập, trừ kho khi import POS, audit) là
--    TRIGGER — KHÔNG nằm ở đây; kiểm bằng health-check [3].
-- =====================================================================
