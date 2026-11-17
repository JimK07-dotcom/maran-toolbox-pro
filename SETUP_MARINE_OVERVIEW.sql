-- Maran Toolbox Pro v1.13.1: STAGED Marine Manager migration
-- Run only after a Supabase database backup and review.
-- Keeps the six existing fleet memberships and policies intact.
BEGIN;

CREATE TABLE IF NOT EXISTS public.marine_manager_members (
  user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.marine_manager_members ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.marine_manager_members FROM anon, authenticated;
GRANT SELECT ON public.marine_manager_members TO authenticated;
DROP POLICY IF EXISTS marine_manager_self_read ON public.marine_manager_members;
CREATE POLICY marine_manager_self_read ON public.marine_manager_members
  FOR SELECT TO authenticated USING (user_id = (SELECT auth.uid()));

INSERT INTO public.marine_manager_members(user_id)
SELECT id FROM auth.users
WHERE lower(email) = 'ageorgiou@marantankers.gr'
ON CONFLICT DO NOTHING;

-- Preserve the original collection values and extend only the known
-- v1.6 constraint; this script assumes the constraint still has its original name.
ALTER TABLE public.fleet_events
  DROP CONSTRAINT IF EXISTS fleet_events_collection_name_check;
ALTER TABLE public.fleet_events
  ADD CONSTRAINT fleet_events_collection_name_check
  CHECK (collection_name IN
    ('records','projects','notes','budgets','supplies','attendance',
     'changeLog','manager_notice','manager_incident'));

-- Manager can view all fleet events and attendance, but cannot overwrite
-- or delete original fleet events.
DROP POLICY IF EXISTS marine_manager_read_events ON public.fleet_events;
CREATE POLICY marine_manager_read_events ON public.fleet_events
  FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1 FROM public.marine_manager_members m
    WHERE m.user_id = (SELECT auth.uid())
  ));

DROP POLICY IF EXISTS marine_manager_insert_events ON public.fleet_events;
CREATE POLICY marine_manager_insert_events ON public.fleet_events
  FOR INSERT TO authenticated
  WITH CHECK (
    actor_id = (SELECT auth.uid())
    AND collection_name IN ('budgets','manager_notice','manager_incident')
    AND EXISTS (
      SELECT 1 FROM public.marine_manager_members m
      WHERE m.user_id = (SELECT auth.uid())
    )
  );

DROP POLICY IF EXISTS marine_manager_read_plans ON public.attendance_plans;
CREATE POLICY marine_manager_read_plans ON public.attendance_plans
  FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1 FROM public.marine_manager_members m
    WHERE m.user_id = (SELECT auth.uid())
  ));
DROP POLICY IF EXISTS marine_manager_read_history ON public.attendance_history;
CREATE POLICY marine_manager_read_history ON public.attendance_history
  FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1 FROM public.marine_manager_members m
    WHERE m.user_id = (SELECT auth.uid())
  ));

-- Prevent ordinary superintendent accounts from impersonating a manager
-- by creating manager_notice or manager_incident events.
-- The existing fleet insert policy is permissive, so a restrictive policy
-- is required to enforce this for all insert policies.
DROP POLICY IF EXISTS restrict_manager_event_types ON public.fleet_events;
CREATE POLICY restrict_manager_event_types ON public.fleet_events
  AS RESTRICTIVE FOR INSERT TO authenticated
  WITH CHECK (
    collection_name NOT IN ('manager_notice','manager_incident')
    OR EXISTS (
      SELECT 1 FROM public.marine_manager_members m
      WHERE m.user_id = (SELECT auth.uid())
    )
  );

COMMIT;

-- Verification (should return exactly one manager):
SELECT u.email, m.created_at
FROM public.marine_manager_members m
JOIN auth.users u ON u.id=m.user_id;
