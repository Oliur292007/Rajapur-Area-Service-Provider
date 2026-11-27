# Healthcare Directory and Doctor Manager — Privacy Hardening Pass

## Public facility and doctor directory
- Healthcare facility cards link to `healthcare.html?organization=<uuid>`.
- The facility page displays active doctors and active chamber schedules for the selected public/active organization.
- Search supports doctor name, specialty, qualifications and biography.
- Bangla/English, theme persistence, responsive layout and mobile navigation are supported.

## Doctor contact privacy
- Added `doctors.consent_public_phone`, default false.
- Added `doctor_public_contacts` as a separate store for consented appointment contact numbers.
- Added `public_doctors` and `public_doctor_schedules` security-invoker views.
- Anonymous users no longer have table-level SELECT on `doctors` or `doctor_schedules`; only the safe columns required by the views are granted.
- Public views only return active doctors/schedules belonging to public or active organizations.
- A doctor appointment phone is exposed only after the manager explicitly checks the consent control.
- Schedule-level appointment phone remains manager-only and is not exposed through the public schedule view.
- Manager form continues to save doctors and chamber schedules to the existing scoped tables; RLS remains the authorization boundary.

## Verification
- Migration applied to Supabase project `kapuhxccffmjgeszixxh`.
- Healthcare page now reads from the safe views instead of base doctor/schedule tables.
- Browser end-to-end test with a real non-admin manager account remains pending.
- Existing doctor, schedule and clinic data were not bulk-published or activated.


## RLS boundary follow-up
- Direct anonymous reads of doctor and schedule safe columns are also constrained to active doctors/schedules whose parent organization is public or active.
- Applied in `20261127111000_restrict_public_doctor_rls_to_listed_facilities.sql`.
