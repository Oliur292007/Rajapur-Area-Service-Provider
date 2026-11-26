# Global Search Implementation

Date: 2026-11-26

## Delivered
- Replaced the homepage category-only search interaction with a live Supabase global search panel.
- Searches active categories, published directory listings, active doctors, published services, active transport operators, active bus routes, active emergency contacts, active places, and area statistics.
- Search terms are normalized before building PostgREST OR filters.
- Search results are rendered as escaped text and link into the relevant category directory.
- Category pages accept the `q` query parameter and apply it to their local record search.
- Added keyboard support: Ctrl/Cmd+K focuses search, Enter opens the first result, Escape closes the result panel.
- Added responsive search result styles and Bangla/English search labels.
- Blood donor personal records are intentionally excluded from global search.

## Security and data rules
- Queries are limited to public/active/published rows according to existing Supabase RLS policies.
- No service-role key is used in browser code.
- Result labels/details are HTML-escaped.
- Search input strips PostgREST filter control characters before constructing OR filters.
- Existing donor consent and verification rules remain unchanged.

## Current data availability
At implementation time, the Supabase project contained 9 active categories, but zero public rows in listings, doctors, services, transport operators, bus routes, emergency contacts, places, and area statistics. Therefore, the global search currently returns category matches; entity-level results will appear as approved public records are added.

Legacy migration records remain staged and unpublished. They must pass admin review and any required consent checks before becoming public.

## Validation
- `assets/js/app.js` syntax checked.
- `assets/js/category.js` syntax checked.
- Confirmed category query parameter prefill is wired.
- Confirmed production deployment is generated from `main`.
- Browser-level interaction and live PostgREST smoke tests remain to be performed.
