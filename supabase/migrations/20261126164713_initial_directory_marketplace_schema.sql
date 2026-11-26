
-- Rajapur Area Service Provider: initial production schema
-- PostgreSQL 17 / Supabase. No existing application data is dropped.

create extension if not exists pgcrypto;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  phone text,
  avatar_url text,
  account_status text not null default 'active' check (account_status in ('active','suspended','pending')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.user_roles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null check (role in ('admin','provider','customer')),
  assigned_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  unique (user_id, role)
);

create table public.categories (
  id uuid primary key default gen_random_uuid(),
  parent_id uuid references public.categories(id) on delete set null,
  name text not null,
  slug text not null unique,
  description text,
  icon_url text,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.listings (
  id uuid primary key default gen_random_uuid(),
  category_id uuid references public.categories(id) on delete set null,
  title text not null,
  slug text not null unique,
  summary text,
  description text,
  address text,
  union_name text,
  phone text,
  email text,
  website_url text,
  latitude double precision,
  longitude double precision,
  cover_image_url text,
  status text not null default 'draft' check (status in ('draft','pending','published','rejected','archived')),
  source_label text,
  source_url text,
  verified_at timestamptz,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (latitude is null or latitude between -90 and 90),
  check (longitude is null or longitude between -180 and 180)
);

create table public.listing_images (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid not null references public.listings(id) on delete cascade,
  image_url text not null,
  alt_text text,
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

create table public.organizations (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid unique references public.listings(id) on delete set null,
  organization_type text not null check (organization_type in ('hospital','clinic','school','college','madrasa','other')),
  name text not null,
  address text,
  phone text,
  email text,
  website_url text,
  opening_hours jsonb not null default '{}'::jsonb,
  description text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.doctors (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid references public.organizations(id) on delete set null,
  full_name text not null,
  specialty text,
  qualifications text,
  bio text,
  photo_url text,
  appointment_phone text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.doctor_schedules (
  id uuid primary key default gen_random_uuid(),
  doctor_id uuid not null references public.doctors(id) on delete cascade,
  organization_id uuid references public.organizations(id) on delete set null,
  weekday smallint check (weekday between 0 and 6),
  start_time time,
  end_time time,
  schedule_note text,
  appointment_phone text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (start_time is null or end_time is null or end_time > start_time)
);

create table public.blood_donors (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  display_name text not null,
  blood_group text not null check (blood_group in ('A+','A-','B+','B-','AB+','AB-','O+','O-')),
  phone text not null,
  union_name text,
  last_donation_date date,
  available_from date,
  consent_public_contact boolean not null default false,
  is_active boolean not null default false,
  verified_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.transport_operators (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid unique references public.listings(id) on delete set null,
  name text not null,
  contact_phone text,
  ticket_url text,
  logo_url text,
  description text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.bus_routes (
  id uuid primary key default gen_random_uuid(),
  operator_id uuid not null references public.transport_operators(id) on delete cascade,
  route_name text not null,
  origin text not null,
  destination text not null,
  via_points text[] not null default '{}',
  route_note text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.bus_schedules (
  id uuid primary key default gen_random_uuid(),
  route_id uuid not null references public.bus_routes(id) on delete cascade,
  departure_time time,
  arrival_time time,
  operating_days smallint[] not null default '{0,1,2,3,4,5,6}',
  frequency_minutes integer check (frequency_minutes is null or frequency_minutes > 0),
  schedule_note text,
  contact_phone text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.emergency_contacts (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  organization_name text,
  phone text not null,
  alternate_phone text,
  address text,
  description text,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.places (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid unique references public.listings(id) on delete set null,
  place_type text not null check (place_type in ('important_location','heritage','tourism','religious_site','natural_site','other')),
  name text not null,
  description text,
  historical_details text,
  address text,
  latitude double precision,
  longitude double precision,
  opening_hours jsonb not null default '{}'::jsonb,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (latitude is null or latitude between -90 and 90),
  check (longitude is null or longitude between -180 and 180)
);

create table public.area_statistics (
  id uuid primary key default gen_random_uuid(),
  topic text not null,
  metric_key text not null,
  metric_label text not null,
  metric_value jsonb not null,
  unit text,
  source_label text,
  source_url text,
  reference_period text,
  last_verified_at timestamptz,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (topic, metric_key)
);

create table public.service_providers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  listing_id uuid references public.listings(id) on delete set null,
  business_name text not null,
  description text,
  phone text,
  address text,
  union_name text,
  verification_status text not null default 'pending' check (verification_status in ('pending','verified','rejected','suspended')),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id)
);

create table public.services (
  id uuid primary key default gen_random_uuid(),
  provider_id uuid not null references public.service_providers(id) on delete cascade,
  category_id uuid references public.categories(id) on delete set null,
  title text not null,
  description text,
  price_amount numeric(12,2) check (price_amount is null or price_amount >= 0),
  price_type text not null default 'quote' check (price_type in ('fixed','hourly','daily','quote')),
  service_area text,
  cover_image_url text,
  status text not null default 'pending' check (status in ('draft','pending','published','rejected','archived')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.service_requests (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references auth.users(id) on delete cascade,
  service_id uuid references public.services(id) on delete set null,
  provider_id uuid references public.service_providers(id) on delete set null,
  request_title text not null,
  details text,
  customer_phone text,
  service_address text,
  preferred_date date,
  status text not null default 'new' check (status in ('new','accepted','rejected','in_progress','completed','cancelled')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.bookings (
  id uuid primary key default gen_random_uuid(),
  request_id uuid references public.service_requests(id) on delete set null,
  customer_id uuid not null references auth.users(id) on delete cascade,
  provider_id uuid not null references public.service_providers(id) on delete cascade,
  service_id uuid references public.services(id) on delete set null,
  scheduled_at timestamptz,
  agreed_amount numeric(12,2) check (agreed_amount is null or agreed_amount >= 0),
  status text not null default 'pending' check (status in ('pending','confirmed','completed','cancelled','rejected')),
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.reviews (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references auth.users(id) on delete cascade,
  provider_id uuid references public.service_providers(id) on delete cascade,
  listing_id uuid references public.listings(id) on delete cascade,
  rating smallint not null check (rating between 1 and 5),
  review_text text,
  status text not null default 'pending' check (status in ('pending','approved','rejected')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (provider_id is not null or listing_id is not null)
);

create table public.announcements (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  body text not null,
  image_url text,
  priority text not null default 'normal' check (priority in ('low','normal','high','urgent')),
  status text not null default 'draft' check (status in ('draft','published','archived')),
  published_at timestamptz,
  expires_at timestamptz,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid references auth.users(id) on delete set null,
  listing_id uuid references public.listings(id) on delete cascade,
  service_id uuid references public.services(id) on delete cascade,
  reason text not null,
  details text,
  status text not null default 'open' check (status in ('open','reviewing','resolved','dismissed')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (listing_id is not null or service_id is not null)
);

create table public.audit_logs (
  id bigint generated always as identity primary key,
  actor_id uuid references auth.users(id) on delete set null,
  action text not null,
  entity_table text not null,
  entity_id text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

-- Useful indexes for search, filters, joins, ownership and RLS.
create index idx_user_roles_user_id on public.user_roles(user_id);
create index idx_categories_parent_id on public.categories(parent_id);
create index idx_listings_category_status on public.listings(category_id,status);
create index idx_listings_created_by on public.listings(created_by);
create index idx_listings_title on public.listings using gin (to_tsvector('simple', coalesce(title,'') || ' ' || coalesce(summary,'')));
create index idx_listing_images_listing_id on public.listing_images(listing_id);
create index idx_organizations_type_active on public.organizations(organization_type,is_active);
create index idx_doctors_organization_id on public.doctors(organization_id);
create index idx_doctor_schedules_doctor_id on public.doctor_schedules(doctor_id);
create index idx_blood_donors_group_active on public.blood_donors(blood_group,is_active,consent_public_contact);
create index idx_transport_operators_listing_id on public.transport_operators(listing_id);
create index idx_bus_routes_operator_id on public.bus_routes(operator_id);
create index idx_bus_schedules_route_id on public.bus_schedules(route_id);
create index idx_places_type_active on public.places(place_type,is_active);
create index idx_service_providers_user_id on public.service_providers(user_id);
create index idx_services_provider_status on public.services(provider_id,status);
create index idx_services_category_id on public.services(category_id);
create index idx_service_requests_customer_id on public.service_requests(customer_id);
create index idx_service_requests_provider_id on public.service_requests(provider_id);
create index idx_bookings_customer_id on public.bookings(customer_id);
create index idx_bookings_provider_id on public.bookings(provider_id);
create index idx_reviews_provider_id on public.reviews(provider_id);
create index idx_announcements_status_published on public.announcements(status,published_at desc);
create index idx_reports_reporter_id on public.reports(reporter_id);
create index idx_audit_logs_actor_id on public.audit_logs(actor_id);

-- Keep updated_at current.
do $$
declare t text;
begin
  foreach t in array array[
    'profiles','categories','listings','organizations','doctors','doctor_schedules',
    'blood_donors','transport_operators','bus_routes','bus_schedules',
    'emergency_contacts','places','area_statistics','service_providers','services',
    'service_requests','bookings','reviews','announcements','reports'
  ] loop
    execute format('create trigger set_updated_at before update on public.%I for each row execute function public.set_updated_at()', t);
  end loop;
end $$;

-- Enable RLS on every public table.
do $$
declare t text;
begin
  foreach t in array array[
    'profiles','user_roles','categories','listings','listing_images','organizations',
    'doctors','doctor_schedules','blood_donors','transport_operators','bus_routes',
    'bus_schedules','emergency_contacts','places','area_statistics','service_providers',
    'services','service_requests','bookings','reviews','announcements','reports','audit_logs'
  ] loop
    execute format('alter table public.%I enable row level security', t);
  end loop;
end $$;

-- Explicit API grants: this project was created after Supabase's Data API exposure change.
grant usage on schema public to anon, authenticated;
grant select on public.categories, public.listings, public.listing_images,
  public.organizations, public.doctors, public.doctor_schedules,
  public.transport_operators, public.bus_routes, public.bus_schedules,
  public.emergency_contacts, public.places, public.area_statistics,
  public.reviews, public.announcements to anon;
grant select, insert, update, delete on all tables in schema public to authenticated;
grant usage, select on all sequences in schema public to authenticated;
grant select, insert, update, delete on all tables in schema public to service_role;
grant usage, select on all sequences in schema public to service_role;

-- Public read-only directory content.
create policy "Public can read active categories" on public.categories
for select to anon, authenticated using (is_active = true);
create policy "Public can read published listings" on public.listings
for select to anon, authenticated using (status = 'published');
create policy "Public can read images for published listings" on public.listing_images
for select to anon, authenticated using (
  exists (select 1 from public.listings l where l.id = listing_id and l.status = 'published')
);
create policy "Public can read active organizations" on public.organizations
for select to anon, authenticated using (is_active = true);
create policy "Public can read active doctors" on public.doctors
for select to anon, authenticated using (is_active = true);
create policy "Public can read active doctor schedules" on public.doctor_schedules
for select to anon, authenticated using (is_active = true);
create policy "Public can read active transport operators" on public.transport_operators
for select to anon, authenticated using (is_active = true);
create policy "Public can read active routes" on public.bus_routes
for select to anon, authenticated using (is_active = true);
create policy "Public can read active bus schedules" on public.bus_schedules
for select to anon, authenticated using (is_active = true);
create policy "Public can read active emergency contacts" on public.emergency_contacts
for select to anon, authenticated using (is_active = true);
create policy "Public can read active places" on public.places
for select to anon, authenticated using (is_active = true);
create policy "Public can read area statistics" on public.area_statistics
for select to anon, authenticated using (true);
create policy "Public can read approved reviews" on public.reviews
for select to anon, authenticated using (status = 'approved');
create policy "Public can read published announcements" on public.announcements
for select to anon, authenticated using (
  status = 'published' and (expires_at is null or expires_at > now())
);

-- Profile owners can manage only their own basic profile.
create policy "Users can view own profile" on public.profiles
for select to authenticated using ((select auth.uid()) = id);
create policy "Users can create own profile" on public.profiles
for insert to authenticated with check ((select auth.uid()) = id);
create policy "Users can update own profile" on public.profiles
for update to authenticated using ((select auth.uid()) = id)
with check ((select auth.uid()) = id);

-- Role assignments are read-only to the user; only trusted admin app_metadata can manage them.
create policy "Users can view own roles" on public.user_roles
for select to authenticated using ((select auth.uid()) = user_id);
create policy "Admins manage user roles" on public.user_roles
for all to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

-- Providers manage their own provider profile and their own services.
create policy "Providers view own provider profile" on public.service_providers
for select to authenticated using ((select auth.uid()) = user_id);
create policy "Users create own provider profile" on public.service_providers
for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "Providers update own provider profile" on public.service_providers
for update to authenticated using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);
create policy "Providers manage own services" on public.services
for all to authenticated
using (exists (select 1 from public.service_providers p where p.id = provider_id and p.user_id = (select auth.uid())))
with check (exists (select 1 from public.service_providers p where p.id = provider_id and p.user_id = (select auth.uid())));
create policy "Public can read published services" on public.services
for select to anon, authenticated using (status = 'published');

-- Service request and booking participants only.
create policy "Customers create own service requests" on public.service_requests
for insert to authenticated with check ((select auth.uid()) = customer_id);
create policy "Participants view service requests" on public.service_requests
for select to authenticated using (
  (select auth.uid()) = customer_id or
  exists (select 1 from public.service_providers p where p.id = provider_id and p.user_id = (select auth.uid()))
);
create policy "Customers update own requests" on public.service_requests
for update to authenticated using ((select auth.uid()) = customer_id)
with check ((select auth.uid()) = customer_id);
create policy "Booking participants view bookings" on public.bookings
for select to authenticated using (
  (select auth.uid()) = customer_id or
  exists (select 1 from public.service_providers p where p.id = provider_id and p.user_id = (select auth.uid()))
);
create policy "Customers create own bookings" on public.bookings
for insert to authenticated with check ((select auth.uid()) = customer_id);
create policy "Customers update own bookings" on public.bookings
for update to authenticated using ((select auth.uid()) = customer_id)
with check ((select auth.uid()) = customer_id);

-- Donor contact is public only after explicit opt-in. Donors manage their own record.
create policy "Public can view opted-in active donors" on public.blood_donors
for select to anon, authenticated using (is_active = true and consent_public_contact = true);
create policy "Donors view own record" on public.blood_donors
for select to authenticated using (user_id = (select auth.uid()));
create policy "Users register own donor record" on public.blood_donors
for insert to authenticated with check (user_id = (select auth.uid()));
create policy "Donors update own record" on public.blood_donors
for update to authenticated using (user_id = (select auth.uid()))
with check (user_id = (select auth.uid()));

-- Users can submit a review/report; publication and moderation are admin-controlled.
create policy "Users create own reviews" on public.reviews
for insert to authenticated with check (customer_id = (select auth.uid()));
create policy "Review authors view own reviews" on public.reviews
for select to authenticated using (customer_id = (select auth.uid()));
create policy "Users create reports" on public.reports
for insert to authenticated with check (reporter_id = (select auth.uid()));
create policy "Report authors view own reports" on public.reports
for select to authenticated using (reporter_id = (select auth.uid()));

-- Admin access across content tables. Admin claim must be set by trusted server-side tooling.
create policy "Admins manage categories" on public.categories for all to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
create policy "Admins manage listings" on public.listings for all to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
create policy "Admins manage listing images" on public.listing_images for all to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
create policy "Admins manage organizations" on public.organizations for all to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
create policy "Admins manage doctors" on public.doctors for all to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
create policy "Admins manage doctor schedules" on public.doctor_schedules for all to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
create policy "Admins manage blood donors" on public.blood_donors for all to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
create policy "Admins manage transport operators" on public.transport_operators for all to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
create policy "Admins manage bus routes" on public.bus_routes for all to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
create policy "Admins manage bus schedules" on public.bus_schedules for all to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
create policy "Admins manage emergency contacts" on public.emergency_contacts for all to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
create policy "Admins manage places" on public.places for all to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
create policy "Admins manage area statistics" on public.area_statistics for all to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
create policy "Admins manage service providers" on public.service_providers for all to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
create policy "Admins manage services" on public.services for all to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
create policy "Admins manage service requests" on public.service_requests for all to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
create policy "Admins manage bookings" on public.bookings for all to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
create policy "Admins moderate reviews" on public.reviews for update to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
create policy "Admins manage announcements" on public.announcements for all to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
create policy "Admins manage reports" on public.reports for all to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
create policy "Admins view audit logs" on public.audit_logs for select to authenticated
using ((select auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

-- Grant API role privileges only for intended tables. RLS still filters every row.
grant select on public.blood_donors to anon, authenticated;
grant select, insert, update on public.profiles to authenticated;
grant select on public.user_roles to authenticated;
grant insert, update, delete on public.user_roles to authenticated;
grant select, insert, update on public.service_providers, public.services,
  public.service_requests, public.bookings, public.blood_donors,
  public.reviews, public.reports to authenticated;
grant insert on public.audit_logs to service_role;
