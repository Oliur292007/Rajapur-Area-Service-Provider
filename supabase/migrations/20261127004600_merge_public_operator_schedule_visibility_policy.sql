-- Keep one public SELECT policy for transport operators.
-- Active operators are public; inactive operators are visible only when linked
-- to an active public route and schedule so schedule cards can show operator names.
drop policy if exists "Public can read operators linked to active schedules" on public.transport_operators;
drop policy if exists "Public can read active transport operators" on public.transport_operators;
create policy "Public can read active transport operators"
on public.transport_operators
for select
to anon, authenticated
using (
  is_active = true
  or exists (
    select 1
    from public.bus_routes r
    join public.bus_schedules s on s.route_id = r.id
    where r.operator_id = transport_operators.id
      and r.is_active = true
      and s.is_active = true
  )
);
