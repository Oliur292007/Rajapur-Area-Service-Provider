# Public Directory Rollout — Phase 1

Date: 2026-11-27
Repository branch: main
Production domain: https://amader-rajapur.vercel.app

## Verified database inventory

- Transport operators: 14 total, 0 active.
- Healthcare organizations: 3 total, 0 active.
- Doctor profiles: 0.
- Bus routes: 1 total, 1 active.
- Bus schedules: 1 total, 1 active.
- The current schedule is linked to Sakura Paribahan Pvt. Ltd. and the route Rajapur to Dhaka.

The 14 transport operator master records and 3 healthcare organization master records came from the archived legacy directory index. They contain names only and are marked inactive pending current operational verification. Their presence in the database is not proof that their current routes, services, phone numbers, or operating status remain accurate.

## Phase 1 fixes

1. Consolidated the public transport-operator SELECT policy so visitors can read:
   - active operators; and
   - an otherwise inactive operator only when it is linked to an active route and active schedule.
2. Verified with the PostgreSQL `anon` role that the active Sakura schedule can now resolve and read the linked operator name even though the operator master row remains inactive.
3. Updated the healthcare directory frontend to query active organizations and render their public organization details alongside active doctors and published healthcare listings. This ensures clinics will appear when the Super Admin activates their verified records.

## Legacy healthcare source review

The archived `doctors-clinic.html` page contains seven historical doctor entries. The schedule and appointment information is old and must not be assumed current. No historic doctor appointment phone numbers were copied into active doctor profiles.

## Publication rules

- Do not activate all legacy operators or clinics blindly.
- Do not publish historic doctor schedules or appointment phone numbers without current confirmation and permission.
- Use the Super Admin / section-manager workflow to verify names, current operating status, routes, schedules, doctor profiles, public phone numbers, and publication permission.
- Only after verification should the corresponding records be activated for public display.

## Next rollout tasks

1. Verify the current status and display name of all 14 operators.
2. Collect and verify current Rajapur routes, departure/arrival times, operating days, and public ticket/contact channels for each operator.
3. Verify the 3 healthcare facilities and collect current public contact details.
4. Ask each facility to confirm its current doctors, specialties, clinic days, and appointment contacts.
5. Seed confirmed doctor profiles and schedules as inactive drafts first; activate only after the organization confirms them.
6. Test public anonymous reads and the scoped manager permissions before each group is published.

## Outstanding security note

Supabase Security Advisor still reports Leaked Password Protection as disabled. Enable it in Supabase Auth password security settings:
https://supabase.com/docs/guides/auth/password-security#password-strength-and-leaked-password-protection
