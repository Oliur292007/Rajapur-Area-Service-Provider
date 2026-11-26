
revoke all privileges on all tables in schema public from anon;
grant select on public.categories, public.listings, public.listing_images,
  public.organizations, public.doctors, public.doctor_schedules,
  public.blood_donors, public.transport_operators, public.bus_routes,
  public.bus_schedules, public.emergency_contacts, public.places,
  public.area_statistics, public.services, public.reviews, public.announcements
to anon;
