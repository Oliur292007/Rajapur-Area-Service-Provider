# Rajapur Area Service Provider — Database Architecture

Supabase project: `kapuhxccffmjgeszixxh`  
Database: PostgreSQL 17  
Status: Initial schema applied and verified.

## Applied schema

The dedicated Supabase project currently contains 23 tables. All 23 tables have Row Level Security (RLS) enabled.

### Accounts and access
- `profiles` — user profile details linked to Supabase Auth.
- `user_roles` — trusted role assignments (admin, provider, customer).

### Directory
- `categories` — directory and service categories.
- `listings` — shared public directory records.
- `listing_images` — listing image gallery.
- `organizations` — hospitals, clinics, schools, colleges and madrasas.
- `doctors` — doctor profiles and specialties.
- `doctor_schedules` — doctor visiting schedules.
- `blood_donors` — donor records with explicit public-contact consent.
- `transport_operators` — bus operators.
- `bus_routes` — transport routes and destinations.
- `bus_schedules` — departure times and operating days.
- `emergency_contacts` — emergency phone contacts.
- `places` — important locations, tourism and heritage records.
- `area_statistics` — structured Rajapur area statistics with source and reference period.

### Service marketplace
- `service_providers` — provider accounts and verification status.
- `services` — provider service listings.
- `service_requests` — customer requests.
- `bookings` — confirmed service booking workflow.
- `reviews` — moderated customer reviews.

### Site management
- `announcements` — public notices.
- `reports` — user-submitted content reports.
- `audit_logs` — administrative activity log.

## Initial categories

Nine active categories have been seeded:
1. Healthcare
2. Education
3. Blood Donation
4. Transport
5. Places & Heritage
6. Emergency Contacts
7. Important Locations
8. Rajapur Information
9. Local Services

## Security rules

- RLS is enabled on every public table.
- Anonymous API access is SELECT-only and granted only to public directory tables.
- Private account, request, booking, provider, report and audit data is not exposed to anonymous users.
- Users can read and update only their own profile fields.
- User roles are not self-assignable. Admin authorization uses trusted Supabase Auth `app_metadata.role`, never user-editable metadata.
- A donor's phone number is visible in the public donor directory only when the donor explicitly enables `consent_public_contact` and the record is active.
- Donors and providers cannot self-verify. Service listings and reviews require moderation before publication.
- Never place a Supabase service-role/secret key in browser code. Use the publishable key with RLS.

## Supabase migration history

The following migrations were applied to the hosted project:

- `20261126164713_initial_directory_marketplace_schema`
- `20261126164748_security_and_index_hardening`
- `20261126164807_workflow_privileges_and_initial_categories`
- `20261126164823_restrict_anon_api_table_grants`

## Next steps

1. Create a reviewed data inventory for all existing static HTML pages.
2. Map each record into the appropriate tables without dropping source text or images.
3. Import content in batches and verify record counts.
4. Connect the existing frontend to Supabase only after the import structure is validated.
5. Add Storage buckets and controlled upload policies before moving images to Supabase Storage.

## Legacy content staging

A private `legacy_content_staging` table was added for a safe, non-destructive migration. It contains a snapshot of each source HTML page, extracted plain text, headings, internal/external links, image paths, and the source Git blob SHA.

Initial archive:
- 39 HTML paths captured from the repository tree.
- 38 pages contain HTML; `navbar.html` is an empty placeholder.
- 264,775 characters of source HTML preserved.
- 443 headings, 322 image references and 496 internal-link references indexed.
- All staging rows remain `pending`; no legacy donor, doctor, school, or other public records have been automatically published.

The staging table is admin-only. Records must be reviewed and mapped into their destination tables before publication.
