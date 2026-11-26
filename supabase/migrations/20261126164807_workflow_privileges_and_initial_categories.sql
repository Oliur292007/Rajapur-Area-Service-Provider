
-- Tighten customer-controlled workflow state and profile fields.
revoke insert, update on public.profiles from authenticated;
grant insert (id, full_name, phone, avatar_url) on public.profiles to authenticated;
grant update (full_name, phone, avatar_url) on public.profiles to authenticated;

drop policy if exists "Users register own donor record" on public.blood_donors;
create policy "Users register inactive donor record" on public.blood_donors
for insert to authenticated
with check (user_id = (select auth.uid()) and is_active = false and verified_at is null);

drop policy if exists "Customers create own service requests" on public.service_requests;
create policy "Customers create new service requests" on public.service_requests
for insert to authenticated
with check ((select auth.uid()) = customer_id and status = 'new');

drop policy if exists "Customers create own bookings" on public.bookings;
create policy "Customers create pending bookings" on public.bookings
for insert to authenticated
with check ((select auth.uid()) = customer_id and status = 'pending');

drop policy if exists "Users create reports" on public.reports;
create policy "Users create open reports" on public.reports
for insert to authenticated
with check (reporter_id = (select auth.uid()) and status = 'open');

-- Initial categories corresponding to the current website's navigation.
insert into public.categories (name, slug, description, sort_order)
values
 ('Healthcare','healthcare','Hospitals, clinics, doctors and health services in Rajapur.',1),
 ('Education','education','Primary schools, secondary schools, high schools, colleges and madrasas.',2),
 ('Blood Donation','blood-donation','Blood donor directory with consent-based contact visibility.',3),
 ('Transport','transport','Bus operators, routes, departure schedules and ticket information.',4),
 ('Places & Heritage','places-heritage','Tourism, historical places, mosques and local heritage.',5),
 ('Emergency Contacts','emergency-contacts','Emergency service contact information.',6),
 ('Important Locations','important-locations','Important public offices and essential locations.',7),
 ('Rajapur Information','rajapur-information','General, agricultural, educational, health and other area statistics.',8),
 ('Local Services','local-services','Local service providers and customer service marketplace.',9)
on conflict (slug) do nothing;
