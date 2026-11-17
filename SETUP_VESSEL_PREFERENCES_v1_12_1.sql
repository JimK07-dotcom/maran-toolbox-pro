-- Run once in Supabase SQL Editor before publishing v1.12.1.
-- Only the signed-in account can read or change its own vessel choices.
-- Fleet assignment is taken separately from public.fleet_members.
create table if not exists public.user_vessel_preferences (
  user_id uuid primary key references auth.users(id) on delete cascade,
  vessels jsonb not null default '[]'::jsonb,
  active_vessel text,
  updated_at timestamptz not null default now(),
  constraint vessels_must_be_array check (jsonb_typeof(vessels)='array')
);
alter table public.user_vessel_preferences enable row level security;
revoke all on public.user_vessel_preferences from anon;
grant select, insert, update on public.user_vessel_preferences to authenticated;
drop policy if exists "Users read own vessel preferences" on public.user_vessel_preferences;
drop policy if exists "Users insert own vessel preferences" on public.user_vessel_preferences;
drop policy if exists "Users update own vessel preferences" on public.user_vessel_preferences;
create policy "Users read own vessel preferences" on public.user_vessel_preferences
 for select to authenticated using (user_id = (select auth.uid()));
create policy "Users insert own vessel preferences" on public.user_vessel_preferences
 for insert to authenticated with check (user_id = (select auth.uid())
 and exists(select 1 from public.fleet_members fm where fm.user_id = (select auth.uid())));
create policy "Users update own vessel preferences" on public.user_vessel_preferences
 for update to authenticated using (user_id = (select auth.uid()))
 with check (user_id = (select auth.uid()));
-- IMPORTANT: In Supabase Integrations > Data API, expose this new table
-- (auto-expose new tables was disabled in your project).
