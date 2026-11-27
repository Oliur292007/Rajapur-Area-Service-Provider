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
- Public phone is shown only when the manager records the teacher's explicit consent. Consented numbers are synchronized to a separate `teacher_public_contacts` table; anonymous clients cannot read the base `teachers.public_phone` column.
- Public teacher profiles are served through `public.public_teachers`, a `security_invoker` view that applies underlying RLS policies and joins only consented phone rows.
- Changes are recorded by the existing section manager audit trigger.

## Database

Migrations:
- `20261127100000_education_institutions_teachers_manager_scope.sql`
- `20261127101000_seed_legacy_education_names_private.sql`
- `20261127102000_public_teacher_safe_view.sql`
- `20261127103000_teacher_public_contact_privacy_hardening.sql`

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
- Anonymous direct SELECT on `teachers` is denied; only the public-safe view is readable. Column-level privilege check confirms anonymous users cannot read `teachers.public_phone`.
- Browser-level visual tests and non-admin manager JWT CRUD tests remain outstanding.

## Admin workflow

1. Open `/admin/managers.html` and sign in as Super Admin.
2. Add a school/college/institute under Education Institutions.
3. Review the staged legacy institution name, correct it if needed, then enable public card visibility only after confirming the institution name; leave operational verification off until operational details are checked.
4. Register the manager account through `/manager/`.
5. Assign that account to the institution with the required permissions.
6. Manager adds teacher profiles as drafts and publishes only confirmed records.
## QA follow-up — 2026-11-27

- Fixed the Super Admin Edge Function target lookup so `educational_institution` assignments validate against `educational_institutions` (rather than `organizations`). Deployed `section-manager-admin` version 5 with JWT verification enabled.
- Fixed the public teacher contact renderer: `public_teachers` already exposes only consent-backed phone numbers, so the institution page now renders a phone link whenever the safe view returns a phone value.
- Manager signup now maps Supabase's built-in email rate-limit response to a localized Bangla/English message. No Supabase Auth rate-limit, SMTP, or confirmation settings were changed.
- Live data inventory at this check: 46 institutions; one public/active institution (Rajapur Model Pilot High School); zero teacher profiles; zero education manager assignments. The existing institution record was not changed during this QA pass.
- Browser-level visual testing and a real non-admin manager sign-in/add/edit/delete test still need to be completed. The earlier transaction-level RLS simulation remains the available backend test; it does not replace a real account E2E test.
