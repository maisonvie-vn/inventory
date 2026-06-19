-- ============================================================
-- MIGRATION: Create inventory_period_close + inventory_snapshots
-- Used by: ClosedInventory.tsx (Báo Cáo Tồn Kho Đóng Kỳ)
-- ============================================================

-- 1. inventory_period_close
-- Records when a period was closed/reopened (versioned audit log)
CREATE TABLE IF NOT EXISTS public.inventory_period_close (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  period_type   TEXT NOT NULL,           -- e.g. 'Kỳ Tháng', 'Kỳ Tuần', 'Kỳ Ngày'
  period_end    DATE NOT NULL,           -- last day of the period
  version       INTEGER NOT NULL DEFAULT 1,
  status        TEXT NOT NULL DEFAULT 'CLOSED' CHECK (status IN ('CLOSED', 'OPEN')),
  closed_by     TEXT,                    -- email of user who closed
  closed_at     TIMESTAMPTZ,
  reopened_by   TEXT,                    -- email of user who reopened
  reopen_reason TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Index for fast lookups by period
CREATE INDEX IF NOT EXISTS idx_ipc_period ON public.inventory_period_close (period_type, period_end, version DESC);

-- 2. inventory_snapshots
-- Frozen stock values at moment of period close
CREATE TABLE IF NOT EXISTS public.inventory_snapshots (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  period_type     TEXT NOT NULL,
  period_end      DATE NOT NULL,
  ingredient_id   UUID NOT NULL REFERENCES public.ingredients(id) ON DELETE CASCADE,
  opening_qty     NUMERIC(15,4) DEFAULT 0,
  in_qty          NUMERIC(15,4) DEFAULT 0,
  out_qty         NUMERIC(15,4) DEFAULT 0,
  closing_qty     NUMERIC(15,4) DEFAULT 0,
  wac_at_close    NUMERIC(15,4) DEFAULT 0,
  closing_value   NUMERIC(18,4) DEFAULT 0,
  locked          BOOLEAN DEFAULT true,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Index for fast period filtering
CREATE INDEX IF NOT EXISTS idx_isnap_period ON public.inventory_snapshots (period_type, period_end);
CREATE INDEX IF NOT EXISTS idx_isnap_ingredient ON public.inventory_snapshots (ingredient_id);

-- 3. Enable RLS (permissive for authenticated users)
ALTER TABLE public.inventory_period_close ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.inventory_snapshots ENABLE ROW LEVEL SECURITY;

-- Allow all operations for authenticated users
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'inventory_period_close' AND policyname = 'allow_all_authenticated'
  ) THEN
    CREATE POLICY allow_all_authenticated ON public.inventory_period_close
      FOR ALL TO authenticated, anon USING (true) WITH CHECK (true);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'inventory_snapshots' AND policyname = 'allow_all_authenticated'
  ) THEN
    CREATE POLICY allow_all_authenticated ON public.inventory_snapshots
      FOR ALL TO authenticated, anon USING (true) WITH CHECK (true);
  END IF;
END $$;

SELECT 'inventory_period_close created' as status;
SELECT 'inventory_snapshots created' as status;
