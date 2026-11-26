# Healthcare Manager Publication Controls — Pass 2

Date: 2026-11-27
Branch: `main`

## Manager portal changes

- New doctor profiles are draft by default; the manager must explicitly enable **Publish doctor profile** to make a doctor visible publicly.
- New doctor schedules are draft by default; the manager must explicitly enable **Publish chamber schedule** to show a schedule publicly.
- Existing records display Published / Draft status in the manager record list.
- Editing a record preserves its current publication state.
- Doctor schedule submission requires a doctor, weekday, start time and end time; the end time must be later than the start time.
- Doctor photo URLs accept only HTTP or HTTPS.
- Both publication controls are localized in Bangla and English.

## Database integrity

Migration: `20261127090000_healthcare_publication_defaults_and_schedule_integrity.sql`

- Database defaults for `doctors.is_active` and `doctor_schedules.is_active` are now false.
- Every doctor must belong to an organization.
- Every doctor schedule must belong to an organization.
- Composite foreign key enforces that the schedule's doctor belongs to the same organization as the schedule.
- Organization/publication lookup indexes added.

## Verification

- Migration applied successfully to Supabase project `kapuhxccffmjgeszixxh`.
- Confirmed doctor and schedule publication defaults are false.
- Confirmed both organization_id columns are NOT NULL.
- At verification time there were no doctor profiles or doctor schedules, so existing data was not modified.
- Supabase Security Advisor continues to report only the existing warning: Leaked Password Protection Disabled. Enable it in Supabase Auth password security settings.
- Dedicated non-admin manager permission tests and browser-level visual/E2E tests remain outstanding.

## Publication process

A section manager may create a doctor or schedule as a draft. The manager must explicitly mark each profile/schedule public only after confirming the current information with the healthcare facility. Public visibility remains limited to active doctor profiles and active schedules.
