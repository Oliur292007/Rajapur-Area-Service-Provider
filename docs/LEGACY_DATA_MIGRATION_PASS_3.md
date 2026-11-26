# Legacy Data Migration — Pass 3: Normalization & Review Staging

Date: 2026-11-26

## Outcome

Pass 3 created `public.legacy_content_records` as a normalized, admin-review-only staging layer. All 204 extracted records from Pass 2 were copied with their source page, record index, type, title, original text/HTML fragment, and a structured JSON field for clearly detectable attributes.

- Total normalized records: **204**
- Pending review: **204**
- Duplicate candidates: **29** (27 transport-route title collisions and 2 doctor/clinic title collisions)
- Records with detected contact strings: **137**
- Records with detected time text: **26**
- Records with detected opening-hours text: **46**
- Approved/imported/published: **0**

## Type counts

| Record type | Records | Duplicate candidates |
|---|---:|---:|
| Area information | 10 | 0 |
| Blood donor source records | 7 | 0 |
| Doctor or clinic | 49 | 2 |
| Education category cards | 3 | 0 |
| Education institutions | 46 | 0 |
| Emergency contacts | 4 | 0 |
| Healthcare facility cards | 3 | 0 |
| Homepage category cards | 9 | 0 |
| Important locations | 7 | 0 |
| Places or heritage | 14 | 0 |
| Transport operators | 14 | 0 |
| Transport route schedules | 38 | 27 |
| **Total** | **204** | **29** |

## Normalization fields

The staging table includes:
- Source identity: `source_page`, `source_record_index`
- Classification: `record_type`
- Display/source fields: `title`, `description`, `href`, `image_path`
- Structured extraction: `structured_data` (detected contact strings, route/time text, opening-hours text, blood-group text where available)
- Traceability: `raw_fragment`, `source_text`
- Duplicate review: `normalized_title`, `duplicate_candidate`, `duplicate_group_key`
- Review workflow: `review_status`, `review_notes`

## Review and safety rules

1. Duplicate candidates are **not confirmed duplicates**. Several transport services legitimately have the same route at different departure times. Review by source fragment and schedule details before merging.
2. Route times, contact details, opening hours, and institutional data may be outdated. They must be verified with the responsible organization before publication.
3. Blood donor source records contain third-party personal information. They remain restricted and must not be published or contacted without explicit, current donor consent.
4. Homepage/category cards are navigation metadata, not automatically directory entities.
5. Original raw HTML remains preserved in `legacy_content_staging`.
6. No rows were inserted into live directory or marketplace tables. Every normalized row remains `pending`.

## Access controls

RLS is enabled. Anonymous users cannot SELECT this table. Authenticated SELECT is additionally restricted by an admin claim in trusted `app_metadata.role`. No public API grants were added.

## Next step

Pass 4 should produce a human-review queue grouped by source and category, resolve the 29 duplicate candidates, validate ambiguous/missing fields, and obtain approval before any live-table import.
