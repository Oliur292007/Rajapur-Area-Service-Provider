# Frontend Foundation — Pass 1

Date: 2026-11-26
Branch: `main` only
Production target: existing `https://rasp-rpst.vercel.app/` (no replacement Vercel project)

## Delivered

- Replaced the static homepage with a responsive, mobile-first directory landing page.
- Added a shared visual foundation in `assets/css/app.css`; legacy `main.css` remains untouched so old pages are not unintentionally restyled during this incremental migration.
- Added `assets/js/app.js` with the Supabase browser client using the project's public publishable key.
- Homepage category cards are queried from `public.categories`, filtered to active rows and sorted by `sort_order`.
- Added category search, Bangla/English switching, persisted language preference, light/dark/system theme selection and persisted theme preference.
- Added responsive mobile navigation and keyboard shortcut Ctrl/Cmd+K for category search.
- Preserved the RPST contact, social and information links from the old homepage.
- Added the agreed footer credit: `Developed by MD Oliur Rahman`.
- Kept all old pages and their root-level assets in place.

## Verification

- Fetched the homepage and both new assets from GitHub `main` after commits.
- Confirmed all referenced legacy icon/logo assets exist in the repository tree.
- Confirmed the `anon` role has SELECT privilege on `public.categories`; row visibility remains governed by RLS.
- Parsed the application JavaScript successfully after replacing only the remote ESM import with a local test stub.
- No database schema or data was modified in this pass.
- No donor contact data or legacy review records are exposed by this homepage.

## Commits

- CSS: `e1511e6e5ba1e4238224329da5dcdb77b115f7c9`
- JavaScript: `8d64f544d0467e22655d61a3546b2ef91d24bf6c`
- Homepage: `286b7e06ecae44e3be038737cc80bfd91bf94d5b`

## Known scope boundary

This is the first implementation increment, not the completed site migration. Legacy subpages still use their old duplicated markup and `main.css`. Search currently filters the live category directory; entity-level search, category detail views, authentication and admin review UI remain future implementation work. The local-services category detail destination will be wired when its live services page is implemented.

The existing Vercel project/team linkage is still not visible in the connected Vercel context. Do not create a new project or change production build settings until the existing `rasp-rpst` project linkage is identified.
