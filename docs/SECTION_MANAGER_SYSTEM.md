# Organization & Section Manager System

Status: backend schema and portal foundation deployed.

## Portals

- Super Admin assignment console: `/admin/managers.html`
- Manager portal: `/manager/`
- Public website: `https://amader-rajapur.vercel.app`

## Supported assignment scopes

- `transport_operator`: one specific row in `transport_operators`. The manager can manage its routes and schedules through `bus_routes` and `bus_schedules`.
- `organization`: one specific row in `organizations`. The manager can manage that organization's doctor profiles and doctor schedules.

One user may have multiple assignments. A target may have multiple managers. An assignment can be disabled without deleting its history.

## Permissions

The assignment stores a JSON permission object:

- `view`
- `add`
- `edit`
- `delete`

The manager portal only renders controls allowed by the assignment. PostgreSQL RLS independently enforces every operation, so hiding a button is not the security boundary.

## Security

- Assignment creation, updates and revocation are restricted to trusted `app_metadata.role = admin`.
- The manager administration Edge Function verifies the caller's Supabase JWT and trusted app metadata server-side.
- The service-role key is used only inside the Edge Function; it is not shipped to the browser.
- Manager data access is scoped by `section_manager_assignments` RLS checks.
- Transport schedules inherit scope through their parent bus route and assigned operator.
- Doctor and doctor-schedule rows are scoped to the assigned organization.
- Audit triggers record INSERT, UPDATE and DELETE events in `section_manager_audit_logs`. The audit table is readable only by Super Admins.
- The manager must already have a Supabase Auth account. Super Admin assigns the account by its registered email.
- Blood donor records, emergency contacts, area statistics, site-wide settings, legacy review data, and other organizations are not in the manager portal's scope.

## Database objects

- `section_manager_assignments`: manager-to-organization/operator assignments and permissions.
- `section_manager_audit_logs`: row-level change history.
- `log_section_manager_change()`: server-side audit trigger function.
- `section-manager-admin`: Super Admin-only Edge Function for listing targets, assigning managers and revoking access.

Hosted migration history:
- `20261126180414_section_manager_assignments_and_scoped_access`
- `20261126180614_section_manager_policy_performance_hardening`

## Operational notes

1. Create the manager's Auth account first (the manager can register/sign in using the portal's email/password flow).
2. Sign in to the Super Admin review console, then open Manager Access.
3. Select the exact operator or organization, enter the manager's registered email, and grant only the required permissions.
4. The manager signs in at `/manager/` and sees only assigned sections.
5. Revoke access from Manager Access when the assignment ends.

New manager-created rows in the supported tables are visible according to the existing public active-record policies. Managers should only enter information they are authorized to maintain. All changes are auditable.


## Healthcare publication safeguards

- New doctor profiles and doctor schedules default to inactive drafts in both the portal and database.
- Managers must explicitly publish a doctor profile and each chamber schedule after confirming current details with the facility.
- Doctor schedules are constrained by a composite foreign key so a manager cannot associate a doctor from another organization with their assigned clinic.
- Doctor schedule forms require a selected doctor, weekday, valid start time, and later end time.
- See `docs/HEALTHCARE_MANAGER_PUBLICATION_PASS_2.md` for implementation and verification details.
