# Public Directory Content Manager — Pass 1

## Purpose
Provide a trusted Super Admin workflow for managing the live directory content that powers the public category pages. This avoids adding fake or unverified records directly to the database.

## Admin UI
- Route: `/admin/directory.html`
- Linked from the main Admin Review dashboard.
- Reuses Supabase Auth, Bangla/English preference and Light/Dark/System preference.
- Responsive layout for phone and desktop.
- Supports add, edit, list and delete for:
  - Emergency contacts
  - Places & heritage
  - Rajapur area statistics
  - General category listings

## Security
- New Edge Function: `public-directory-admin`.
- JWT verification is enabled.
- The function independently calls `auth.getUser(token)` and checks trusted `app_metadata.role === 'admin'`.
- Service-role key is used only inside the Edge Function.
- Table names and writable fields are selected from fixed allowlists; clients cannot supply arbitrary table or column names.
- Records are not modified from the browser directly.
- Area statistics require a source label or source URL.
- Directory listings require a valid category and URL slug; publishing requires a source label or source URL and sets `verified_at`.
- Blood donor records are deliberately excluded from this content manager.

## Public directory integration
- Emergency contact records feed the Emergency Contacts category.
- Place records feed Places & Heritage.
- Area statistics feed Rajapur Information.
- Published listings feed the matching category pages.
- Inactive places and emergency contacts remain hidden by existing public queries; listings remain hidden unless published.

## Current data state
The content tables were empty at the time this workflow was prepared. No placeholder or invented information was inserted. The admin can add genuine verified information through the portal.

## Verification and limitations
- Edge Function deployed and active as version 3 with `verify_jwt=true`.
- Supabase Security Advisor still reports only the existing warning: Leaked Password Protection Disabled.
- User-facing admin CRUD/E2E test intentionally not performed; the user will perform their own testing.
- Production frontend deployment is deferred until the Vercel daily deployment limit resets, as requested.
