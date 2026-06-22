-- ============================================================
-- PATCH v3.0.15 — Bổ sung quyền RLS và Grant cho vai trò anon (Sandbox)
-- Vấn đề:
--   Bảng notification_badges chỉ có RLS policy cho authenticated.
--   Khi chạy sandbox/mock login, Client kết nối bằng anon key (chưa qua Supabase Auth)
--   nên bị chặn không đọc được badge, dẫn đến việc không hiển thị cảnh báo.
-- Giải pháp:
--   1. Grant quyền SELECT, UPDATE cho vai trò anon trên bảng notification_badges.
--   2. Tạo các chính sách RLS cho phép anon SELECT và UPDATE.
-- ============================================================

-- 1. Grant quyền trên bảng cho cả anon và authenticated
GRANT SELECT, INSERT, UPDATE, DELETE ON public.notification_badges TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.notification_badges TO authenticated;

-- 2. Tạo RLS policies cho anon đọc badges
DROP POLICY IF EXISTS badges_anon_select ON public.notification_badges;
CREATE POLICY badges_anon_select ON public.notification_badges
  FOR SELECT TO anon USING (true);

-- 3. Tạo RLS policies cho anon update (resolve) badges
DROP POLICY IF EXISTS badges_anon_update ON public.notification_badges;
CREATE POLICY badges_anon_update ON public.notification_badges
  FOR UPDATE TO anon USING (true) WITH CHECK (true);
