-- Separate public directory visibility from verified operational activation.
-- This lets the site show provider names with a "details being verified" label
-- without claiming that an inactive provider currently operates.
alter table public.transport_operators
  add column if not exists is_public boolean not null default false;
alter table public.organizations
  add column if not exists is_public boolean not null default false;

create index if not exists idx_transport_operators_public
  on public.transport_operators (is_public) where is_public = true;
create index if not exists idx_organizations_public
  on public.organizations (is_public) where is_public = true;

drop policy if exists "Public can read active transport operators" on public.transport_operators;
create policy "Public can read active transport operators"
on public.transport_operators
for select
to anon, authenticated
using (
  is_public = true
  or is_active = true
  or exists (
    select 1
    from public.bus_routes r
    join public.bus_schedules s on s.route_id = r.id
    where r.operator_id = transport_operators.id
      and r.is_active = true
      and s.is_active = true
  )
);

drop policy if exists "Public can read active organizations" on public.organizations;
create policy "Public can read active organizations"
on public.organizations
for select
to anon, authenticated
using (is_public = true or is_active = true);

update public.transport_operators
set is_public = true,
    description = 'Public directory entry. Current routes, schedules and contact details are being verified.'
where description = 'Legacy directory entry. Pending current operational verification; not published.';

update public.organizations
set is_public = true,
    description = 'Public directory entry. Current services, doctors and contact details are being verified.'
where description = 'Legacy directory entry. Pending current operational verification; not published.';
