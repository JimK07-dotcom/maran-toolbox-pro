-- Maran Toolbox Pro v1.6. Run as project administrator in Supabase SQL Editor.
create extension if not exists pgcrypto;
create table if not exists public.fleet_members (
 user_id uuid not null references auth.users(id) on delete cascade,
 fleet text not null check (fleet in ('A','B','C')),
 created_at timestamptz not null default now(),
 primary key (user_id,fleet)
);
create table if not exists public.fleet_events (
 id uuid primary key,
 fleet text not null check (fleet in ('A','B','C')),
 actor_id uuid not null references auth.users(id),
 collection_name text not null check (collection_name in ('records','projects','notes','budgets','supplies','attendance','changeLog')),
 record_id text not null,
 payload jsonb not null,
 created_at timestamptz not null default now()
);
create index if not exists fleet_events_fleet_created on public.fleet_events(fleet,created_at);
alter table public.fleet_members enable row level security;
alter table public.fleet_events enable row level security;
revoke all on public.fleet_members from anon;
revoke all on public.fleet_events from anon;
grant select on public.fleet_members to authenticated;
grant select,insert on public.fleet_events to authenticated;
drop policy if exists member_read_self on public.fleet_members;
create policy member_read_self on public.fleet_members for select to authenticated using (user_id = (select auth.uid()));
drop policy if exists events_read_fleet on public.fleet_events;
create policy events_read_fleet on public.fleet_events for select to authenticated using (exists(select 1 from public.fleet_members m where m.user_id=(select auth.uid()) and m.fleet=fleet_events.fleet));
drop policy if exists events_insert_fleet on public.fleet_events;
create policy events_insert_fleet on public.fleet_events for insert to authenticated with check (actor_id=(select auth.uid()) and exists(select 1 from public.fleet_members m where m.user_id=(select auth.uid()) and m.fleet=fleet_events.fleet));
-- Membership creation/removal is intentionally reserved for project administrators.
-- Events are append-only: no update/delete grants or policies.
