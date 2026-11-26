# Frontend Architecture Audit and Redesign Plan

Date: 2026-11-26
Repository: `Oliur292007/Rajapur-Area-Service-Provider`
Target branch: `main` only

## 1. Audit outcome

The current frontend is a legacy multi-page static website built with plain HTML, one shared CSS file, and one small JavaScript file. No frontend package manifest or modern application build configuration was found at the checked repository-root paths (`package.json`, Vite configs, `vercel.json`, and `netlify.toml`).

Confirmed root frontend files:
- `index.html` — homepage and legacy footer/contact information.
- `main.css` — shared legacy styles.
- `main.js` — sidebar open/close behaviour only.
- `navbar.html` — empty file.
- 38 populated HTML pages archived in Supabase staging.

The existing JavaScript does not connect to Supabase, implement authentication, search, filters, forms, user workflows, or admin operations. No existing admin page was found at the checked paths (`admin.html`, `admin/index.html`).

## 2. Existing page inventory

### Main directory and navigation
- `index.html`
- `hospitals.html`
- `school-catagory.html`
- `collages.html`
- `blood.html`
- `buses.html`
- `places.html`
- `rajapur-haritage.html`
- `emergency.html`
- `important-locations.html`
- `about.html`

### Healthcare detail pages
- `sohag-hispital.html`
- `doctors-clinic.html`
- `popular-clinic.html`

### Education detail pages
- `primary-schools.html`
- `secondary-schools.html`
- `high-schools.html`
- `edu-info.html)

### Transport detail pages
- `eagle.html`
- `evan.html`
- `hanif.html`
- `labiba.html`
- `palki.html`
- `sakura.html`
- `Shyamoli.html`

### Places and heritage detail pages
- `bishkhali.html`
- `mosque.html`
- `galua-mosque.html`
- `satuira.html`

### Rajapur information pages
- `general-info.html`
- `agricultural-info.html`
- `communication.html`
- `family-planning.html`
- `fisheries.html`
- `health-releted.html`
- `land-and-revenue-related.html`
- `livestock.html`
- `cooperative.html`

The 38 populated pages and the empty `navbar.html` are all preserved in `public.legacy_content_staging`. All staging page rows remain pending.

## 3. Existing UI and functionality findings

- The current visual system uses Times New Roman, fixed/legacy card widths, a gradient header, and a slide-in sidebar.
- The sidebar is the only confirmed shared JavaScript interaction.
- Navigation and footer markup are duplicated across pages.
- Some document titles are incorrect or generic (for example, several pages use “Bus Schedules”).
- Existing content includes directory cards, organization and doctor pages, donor information, bus operators/routes/times, places/heritage, emergency contacts, important locations with Google Maps embeds, Rajapur statistics/information, RPST contact information, social links, and information partners.
- Existing emergency contact links and map references should be preserved only after verification.
- Existing donor data is sensitive and must not be copied into public UI without current explicit donor consent and active/verified status.

## 4. Backend readiness

The dedicated Supabase project is already provisioned with PostgreSQL 17 and 24+ public tables, RLS enabled, and nine initial categories.

Relevant tables include:
- Directory: `categories`, `listings`, `listing_images`, `organizations`, `doctors`, `doctor_schedules`, `blood_donors`, `transport_operators`, `bus_routes`, `bus_schedules`, `emergency_contacts`, `places`, `area_statistics`.
- Marketplace: `service_providers`, `services`, `service_requests`, `bookings`, `reviews`.
- Accounts and moderation: `profiles`, `user_roles`, `announcements`, `reports`, `audit_logs`.
- Legacy review: `legacy_content_staging`, `legacy_content_records`, `legacy_review_queue`, `legacy_review_events`.

Legacy migration status:
- 39 source HTML paths archived (38 populated, one empty).
- 204 normalized records.
- 250 review tasks.
- 204 normalized records remain pending.
- No legacy record has been approved, imported, or published automatically.
- Security Advisor was clean after Pass 5.

The frontend must use only the Supabase publishable/anon client key with RLS. Service-role/secret credentials must remain server-side and must never appear in browser bundles or `NEXT_PUBLIC_*` variables.

## 5. Mandatory product requirements

These requirements apply to the whole site, not just the homepage:

1. Complete, professional, mobile-first responsive redesign of public pages and the admin dashboard.
2. All directory and marketplace content must be read from Supabase; no permanent hardcoded/demo records.
3. Search, filters, navigation, forms, authentication, settings, admin actions, and user workflows must be functional and tested.
4. Bangla and English language support across the complete UI, including navigation, labels, validation, errors, empty states, and dashboard.
5. Light mode, dark mode, and system-theme option; persist the user's preference.
6. Persist the user's language preference.
7. Consistent footer preserving verified RPST contact/partner information and showing the developer credit: **Developed by MD Oliur Rahman**.
8. Keep the original useful content and features during migration; do not silently discard source pages, images, routes, maps, or contact references.
9. No automatic publication of legacy records. Sensitive donor information must remain private until current consent and verification are established.
10. All GitHub changes must be committed directly to `main`. Do not create or use feature/development branches.

## 6. Implementation direction

The current site is a static HTML collection without a package/build system. The implementation should move to a maintainable component-based frontend with:
- Shared application shell (header, navigation, responsive mobile menu, footer).
- Centralized bilingual translation dictionaries and locale-aware content handling.
- Theme provider with `light`, `dark`, and `system` modes.
- Typed Supabase client configuration using environment variables and a publishable key.
- Data-access modules for each directory domain.
- Reusable search, filter, pagination, loading, empty, and error states.
- Authentication and role-aware route protection.
- Server-side/Edge Function admin operations for protected legacy review actions.
- Accessible forms with validation and explicit success/error feedback.
- Tests for data access, authorization boundaries, language/theme persistence, and primary user flows.

Do not choose or install a framework until the remaining repository deployment/hosting configuration and existing asset conventions have been checked. Do not overwrite the old HTML content until its text, image references, and navigation have been mapped into the new application.

## 7. Work sequence

### Phase A — Complete repository and content inventory
- Inspect all source HTML content, image assets, external links, and existing hosting/deployment settings.
- Map each legacy page to its future application route and Supabase data domain.
- Record unresolved or outdated information for human verification.

### Phase B — Frontend foundation
- Confirm framework/build/deployment target.
- Add shared design tokens, application shell, responsive navigation, bilingual UI, and persistent theme/language settings.
- Add safe Supabase client configuration.

### Phase C — Public directory experience
- Implement homepage, categories, detail pages, global search, filters, pagination, emergency contacts, maps, and directory-specific interactions using live backend data.
- Implement provider/customer marketplace flows only where supported by verified schema and secure policies.

### Phase D — Authentication and admin
- Implement sign-in/session handling and role-aware access.
- Build the admin dashboard and secure server-side review endpoints.
- Provide record/task review, notes, duplicate inspection, audit history, and strict approval/import gates.

### Phase E — Migration and verification
- Import only reviewed and verified records in controlled batches.
- Verify counts, links, images, permissions, RLS, and donor consent.
- Run build, automated tests, mobile/responsive checks, and Supabase Security Advisor.
- Document environment variables and deployment steps without committing secrets.

## 8. Current stopping point

This audit is documentation only. No existing frontend page has been replaced, no legacy content has been published, and no database schema or access policy has been changed by this audit. The next implementation task is to finish the asset/hosting inventory and then establish the shared frontend foundation.
