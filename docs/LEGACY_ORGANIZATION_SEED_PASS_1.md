# Legacy Organization Seed — Pass 1

Date: 2026-11-27

## Result

Seeded the new backend with inactive organization/operator master records so Super Admin can assign section managers without publishing legacy information.

- 14 transport operators from the archived `buses.html` index.
- 3 healthcare organizations from `hospitals.html`:
  - Doctors Clinic and Diagnostic Center
  - Popular Clinic and Diagnostic Center
  - Sohag General Hospital

All seeded rows have `is_active = false` and a description stating that the legacy directory entry is pending current operational verification. They are not visible to anonymous visitors under the current public RLS policies.

No doctor profiles, appointment phone numbers, bus routes, bus schedules, or historical contact details were migrated. The archived doctor/schedule data contains historical details and duplicate/incomplete route records; current accuracy and permission to publish have not been confirmed.

## Manager account registration

The manager portal now includes email/password registration. New accounts do not receive manager permissions automatically. A Super Admin must assign a registered account to an exact operator or organization and choose permissions.

## Verification

- 14 transport operator rows exist; 0 active.
- 3 organization rows exist; 0 active.
- 0 doctors, routes, schedules or active manager assignments were seeded.
- Manager portal registration UI is present in the production source.
- Production deployment is READY on `main`.

## Next

1. Confirm the current legal/display names of the operators and clinics.
2. Have each organization verify its current routes, schedules, doctors, and contact details.
3. Register manager accounts and assign scoped access.
4. Test each permission (view/add/edit/delete) using non-admin test accounts before activating public records.
