-- Run once in Supabase SQL Editor. All authorized fleet members and manager may edit.
create table if not exists public.vessel_directory (
 vessel_name text primary key, imo text, vessel_type text, fleet text check (fleet in ('A','B','C') or fleet is null),
 status text not null default 'active' check (status in ('active','sold')),
 updated_by uuid, updated_at timestamptz not null default now()
);
alter table public.vessel_directory enable row level security;
drop policy if exists vessel_directory_read on public.vessel_directory;
create policy vessel_directory_read on public.vessel_directory for select to authenticated using (
 exists(select 1 from public.fleet_members f where f.user_id=auth.uid()) or exists(select 1 from public.marine_manager_members m where m.user_id=auth.uid()));
drop policy if exists vessel_directory_write on public.vessel_directory;
create policy vessel_directory_write on public.vessel_directory for insert to authenticated with check (
 exists(select 1 from public.fleet_members f where f.user_id=auth.uid()) or exists(select 1 from public.marine_manager_members m where m.user_id=auth.uid()));
drop policy if exists vessel_directory_update on public.vessel_directory;
create policy vessel_directory_update on public.vessel_directory for update to authenticated using (
 exists(select 1 from public.fleet_members f where f.user_id=auth.uid()) or exists(select 1 from public.marine_manager_members m where m.user_id=auth.uid())) with check (
 exists(select 1 from public.fleet_members f where f.user_id=auth.uid()) or exists(select 1 from public.marine_manager_members m where m.user_id=auth.uid()));
create or replace function public.vessel_directory_stamp() returns trigger language plpgsql security invoker as $$begin new.updated_by=auth.uid();new.updated_at=now();return new;end$$;
drop trigger if exists vessel_directory_stamp_trigger on public.vessel_directory;
create trigger vessel_directory_stamp_trigger before insert or update on public.vessel_directory for each row execute function public.vessel_directory_stamp();
grant select,insert,update on public.vessel_directory to authenticated;
