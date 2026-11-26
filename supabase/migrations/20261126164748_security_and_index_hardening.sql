
alter function public.set_updated_at() set search_path = '';

do $$
declare r record;
declare expr text := '(((select auth.jwt()) -> ''app_metadata'' ->> ''role'') = ''admin'')';
begin
  for r in
    select schemaname, tablename, policyname, cmd
    from pg_policies
    where schemaname='public' and policyname like 'Admins %'
  loop
    if r.cmd = 'SELECT' or r.cmd = 'DELETE' then
      execute format('alter policy %I on %I.%I using (%s)',r.policyname,r.schemaname,r.tablename,expr);
    elsif r.cmd = 'INSERT' then
      execute format('alter policy %I on %I.%I with check (%s)',r.policyname,r.schemaname,r.tablename,expr);
    else
      execute format('alter policy %I on %I.%I using (%s) with check (%s)',r.policyname,r.schemaname,r.tablename,expr,expr);
    end if;
  end loop;
end $$;

create index if not exists idx_announcements_created_by on public.announcements(created_by);
create index if not exists idx_blood_donors_user_id on public.blood_donors(user_id);
create index if not exists idx_bookings_request_id on public.bookings(request_id);
create index if not exists idx_bookings_service_id on public.bookings(service_id);
create index if not exists idx_doctor_schedules_organization_id on public.doctor_schedules(organization_id);
create index if not exists idx_reports_listing_id on public.reports(listing_id);
create index if not exists idx_reports_service_id on public.reports(service_id);
create index if not exists idx_reviews_customer_id on public.reviews(customer_id);
create index if not exists idx_reviews_listing_id on public.reviews(listing_id);
create index if not exists idx_service_providers_listing_id on public.service_providers(listing_id);
create index if not exists idx_service_requests_service_id on public.service_requests(service_id);
create index if not exists idx_user_roles_assigned_by on public.user_roles(assigned_by);

drop policy if exists "Donors update own record" on public.blood_donors;
create policy "Donors update own unverified record" on public.blood_donors
for update to authenticated
using (user_id = (select auth.uid()) and verified_at is null)
with check (user_id = (select auth.uid()) and verified_at is null and is_active = false);

drop policy if exists "Users create own provider profile" on public.service_providers;
create policy "Users create pending provider profile" on public.service_providers
for insert to authenticated
with check ((select auth.uid()) = user_id and verification_status = 'pending');

drop policy if exists "Providers update own provider profile" on public.service_providers;
create policy "Providers update pending provider profile" on public.service_providers
for update to authenticated
using ((select auth.uid()) = user_id and verification_status = 'pending')
with check ((select auth.uid()) = user_id and verification_status = 'pending');

drop policy if exists "Providers manage own services" on public.services;
create policy "Providers read own services" on public.services
for select to authenticated
using (exists (select 1 from public.service_providers p where p.id = provider_id and p.user_id = (select auth.uid())));
create policy "Providers create draft services" on public.services
for insert to authenticated
with check (
  status in ('draft','pending') and
  exists (select 1 from public.service_providers p where p.id = provider_id and p.user_id = (select auth.uid()) and p.verification_status = 'verified')
);
create policy "Providers update draft services" on public.services
for update to authenticated
using (
  status in ('draft','pending') and
  exists (select 1 from public.service_providers p where p.id = provider_id and p.user_id = (select auth.uid()) and p.verification_status = 'verified')
)
with check (
  status in ('draft','pending') and
  exists (select 1 from public.service_providers p where p.id = provider_id and p.user_id = (select auth.uid()) and p.verification_status = 'verified')
);
create policy "Providers delete draft services" on public.services
for delete to authenticated
using (
  status in ('draft','pending') and
  exists (select 1 from public.service_providers p where p.id = provider_id and p.user_id = (select auth.uid()))
);

drop policy if exists "Users create own reviews" on public.reviews;
create policy "Users create pending reviews" on public.reviews
for insert to authenticated
with check (customer_id = (select auth.uid()) and status = 'pending');

drop policy if exists "Customers update own requests" on public.service_requests;
drop policy if exists "Customers update own bookings" on public.bookings;
