# Public Directory Rollout — Phase 1

Date: 2026-11-27
Repository branch: main
Production domain: https://amader-rajapur.vercel.app

## Verified database inventory

- Transport operators: 14 total, 14 public directory entries, 0 operationally active.
- Healthcare organizations: 3 total, 3 public directory entries, 0 operationally active.
- Doctor profiles: 0.
- Bus routes: 1 total, 1 active.
- Bus schedules: 1 total, 1 active.
- The current schedule is linked to Sakura Paribahan Pvt. Ltd. and the route Rajapur to Dhaka.

The 14 transport operator master records and 3 healthcare organization master records came from the archived legacy directory index. Their names are now visible as public directory entries, but their operational `is_active` status remains false until current operations are verified. Public cards show a verification notice. Their presence in the directory is not proof that current routes, services, phone numbers, or operating status remain accurate.

## Phase 1 fixes

1. Added separate `is_public` visibility flags for transport operators and healthcare organizations, distinct from their operational `is_active` state.
2. Marked all 14 legacy transport operator names and all 3 healthcare organization names as public directory entries, without activating them operationally.
3. Updated public RLS policies so visitors can read public directory entries. Transport operators linked to an active public schedule can also be resolved.
4. Verified with the PostgreSQL `anon` role that all 14 operator names and all 3 clinic/hospital names are visible, and that the active Sakura schedule can resolve its operator name even though the operator remains operationally inactive.
5. Updated the transport and healthcare frontend to show public directory entries with a localized verification notice, while keeping inactive operational records clearly distinguished from active providers.

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
