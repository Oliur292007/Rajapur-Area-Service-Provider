-- Allow public visitors to resolve the operator name for any active public bus schedule.
-- This does not publish inactive operators without an active route and schedule.
create policy "Public can read operators linked to active schedules"
on public.transport_operators
for select
to anon, authenticated
using (
  exists (
    select 1
    from public.bus_routes r
    join public.bus_schedules s on s.route_id = r.id
    where r.operator_id = transport_operators.id
      and r.is_active = true
      and s.is_active = true
  )
);
