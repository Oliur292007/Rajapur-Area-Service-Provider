# Full Website Dynamic UI Migration — Pass 1

## Objective
Remove the inconsistent legacy page presentation and route old deep links into the current responsive, Supabase-backed category directory pages.

## Completed
- Added `assets/js/legacy-redirect.js` with explicit route mappings for the former static HTML pages.
- Added `assets/css/legacy-redirect.css` using the shared application design tokens and responsive layout.
- Replaced the legacy presentation on 37 old root-level HTML pages with a lightweight compatibility screen that routes visitors into the current dynamic category experience.
- Preserved familiar legacy URLs as compatibility entry points; links to old pages no longer render the old `main.css` / `main.js` UI.
- Mapped historical pages into live directory categories:
  - Healthcare: clinics, doctors and hospital pages.
  - Education: school, college and education pages.
  - Transport: operator pages and bus listings.
  - Blood Donation, Emergency Contacts, Important Locations, Places & Heritage and Rajapur Information.
- For named legacy pages, the original name/topic is passed as the category search query where appropriate.
- Existing legacy source content remains archived in the private Supabase staging tables; no old record is automatically published by this UI migration.
- Current modern pages (home, category, healthcare, institution, admin and manager) remain in place.
- All code committed directly to `main`; no branches created.

## Compatibility behavior
Legacy URLs redirect to `category.html?slug=<category>&q=<optional-search-term>`. The current category page reads the query string and applies the initial search. If JavaScript is unavailable, a styled fallback link remains visible.

## Not in this pass
- No legacy source record has been imported or published.
- No clinic, school, operator, doctor, donor, or schedule operational status has been changed.
- User-requested real-account manager CRUD testing remains for the user; no test manager account was created.
- The old `main.css` and `main.js` assets are retained for rollback/reference and are no longer loaded by the converted legacy pages.

## Next pass
- Audit remaining static content and internal links across all live templates.
- Ensure category and detail pages use a consistent header/footer, language and theme controls.
- Convert any remaining standalone content into database-driven records where a matching schema exists, without publishing unverified legacy data.
