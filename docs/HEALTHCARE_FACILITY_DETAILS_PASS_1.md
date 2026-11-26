# Healthcare Directory — Facility Details Pass 1

Date: 2026-11-27
Branch: `main`
Production domain: https://amader-rajapur.vercel.app

## User experience

- The Healthcare directory now shows each public hospital/clinic as a facility card.
- Each facility card links to `healthcare.html?organization=<organization-uuid>`.
- The dedicated page loads only the selected facility and its currently active doctor profiles.
- Each doctor profile displays published active chamber schedules, weekday, time range, schedule note, and appointment phone when supplied.
- Search filters doctors by name, specialty, qualifications, and biography.
- Bangla/English and Light/Dark/System preferences reuse the site's persisted settings.
- Responsive layout supports phone, tablet, and desktop.
- Invalid or unavailable facility IDs show a safe error state.
- Profile images are restricted to HTTP/HTTPS URLs.

## Data and publication rules

- Uses existing `organizations`, `doctors`, and `doctor_schedules` tables; no schema migration was needed.
- Public facility cards include rows where `is_public=true OR is_active=true`.
- Only doctors with `is_active=true` and schedules with `is_active=true` are displayed.
- Doctor schedules are filtered by the selected organization and by doctor IDs belonging to that organization.
- No legacy doctor names, phone numbers, or old chamber schedules were copied or activated.

## Verification

- Database inventory at implementation time: 3 public healthcare organizations, 0 active doctor profiles, 0 active doctor schedules.
- Anonymous visibility check returned 3 organizations, 0 active doctors, and 0 active doctor schedules.
- The detail page therefore correctly shows an empty-state message until a facility manager adds and publishes current doctor information.
- Browser-level visual/E2E verification remains outstanding.

## Next implementation step

Continue the public provider rollout by strengthening the healthcare manager workflow: make draft-vs-public activation clear, validate doctor schedule ownership and required fields, and test scoped manager permissions with a dedicated non-admin test account before any provider information is published.
