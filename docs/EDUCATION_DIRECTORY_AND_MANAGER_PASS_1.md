# Education Directory and Teacher Manager — Pass 1

Date: 2026-11-27
Branch: `main`
Production domain: https://amader-rajapur.vercel.app

## Public directory

- Education category now loads records from `educational_institutions` and retains existing published `listings`.
- Each public/active institution renders as its own clickable card.
- Selecting a card opens `institution.html?institution=<uuid>`.
- Institution details page displays institution name, address, public phone, website and published teachers.
- Teacher profiles include name, designation, subject, qualifications, biography, photo and (only with consent) public phone.
- Search filters teacher name, designation, subject, qualifications and biography.
- Bangla/English, Light/Dark/System and responsive mobile/desktop layouts are supported.
- Global homepage search includes public/active educational institutions.

## Super Admin institution management

- Manager Access page now contains an Education Institutions section.
- Super Admin can create, edit and delete institutions.
- Super Admin controls whether the institution card is public and whether its operational information is verified/active.
- An institution must exist before a manager assignment can be created.
- Deleting an institution also deletes its teacher profiles through the database cascade; the UI asks for confirmation.

## Education section managers

- New assignment scope: `educational_institution`.
- Super Admin can assign a registered account to a specific institution with View/Add/Edit/Delete permissions.
- Manager Portal loads only the assigned institution's teachers.
- Managers can add, edit and delete teacher profiles, with RLS enforcing institution scope.
- New teacher profiles default to draft; explicit publish checkbox required.
- Public phone is shown only when the manager records the teacher's explicit consent.
- Changes are recorded by the existing section manager audit trigger.

## Database

Migration: `20261127100000_education_institutions_teachers_manager_scope.sql`

- Added `educational_institutions` and `teachers` with RLS enabled.
- Public read is restricted to public/active institutions and active teacher profiles.
- Assignment check constraint now supports `educational_institution`.
- RLS policies enforce assigned institution scope for teacher CRUD.
- Audit trigger supports the new target type.
- Added public listing indexes and updated_at triggers.

## Verification status

- Schema and policies created successfully in Supabase project `kapuhxccffmjgeszixxh`.
- Manager administration Edge Function `section-manager-admin` deployed with JWT verification enabled (version 4).
- Supabase Security Advisor reports only the existing Leaked Password Protection Disabled warning.
- 46 approved legacy school/college names were staged for verification and manager assignment with no contact numbers, no teacher profiles, `is_public=false` and `is_active=false`. They are not publicly visible; no legacy teachers or teacher contact details were imported.
- Browser-level visual tests and non-admin manager JWT CRUD tests remain outstanding.

## Admin workflow

1. Open `/admin/managers.html` and sign in as Super Admin.
2. Add a school/college/institute under Education Institutions.
3. Review the staged legacy institution name, correct it if needed, then enable public card visibility only after confirming the institution name; leave operational verification off until operational details are checked.
4. Register the manager account through `/manager/`.
5. Assign that account to the institution with the required permissions.
6. Manager adds teacher profiles as drafts and publishes only confirmed records.
