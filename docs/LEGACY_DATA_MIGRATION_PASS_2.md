# Legacy Content Migration — Pass 2

Project: Rajapur Area Service Provider
Supabase project: `kapuhxccffmjgeszixxh`

## Scope

Pass 2 extracts non-article linked cards from the main content of index/category pages and classifies the operator-specific transport pages already extracted in Pass 1. All results remain in `public.legacy_content_staging.extracted_records`; no live/public tables are modified.

## New card extraction

| Source page | Type | Extracted |
| --- | --- | ---: |
| `buses.html` | Transport operator cards | 14 |
| `hospitals.html` | Healthcare facility cards | 3 |
| `places.html` | Place / heritage cards | 4 |
| `school-catagory.html` | Education category cards | 3 |
| `index.html` | Homepage category cards | 9 |
| **Total new card records** | | **33** |

Card records retain title, description, href, image path, original HTML fragment, and pending review status where available.

## Transport schedule classification

Seven operator-specific pages were classified as `transport_route_schedule`:

| Source page | Records |
| --- | ---: |
| `eagle.html` | 3 |
| `evan.html` | 4 |
| `hanif.html` | 6 |
| `labiba.html` | 6 |
| `palki.html` | 7 |
| `sakura.html` | 9 |
| `Shyamoli.html` | 3 |
| **Total** | **38** |

These are extracted HTML article blocks, not verified current schedules. Duplicate route headings and untitled call-to-action blocks remain pending and require cleanup.

## Cumulative extraction

- Original source pages archived: 39
- Pages with extracted records: 37 (pages containing structured card/article content)
- Pass 1 article records: 171
- Pass 2 new linked-card records: 33
- **Total staged extracted records: 204**

## Data integrity and publication status

- All source HTML remains preserved in `raw_html`.
- No extracted record has been imported into live tables.
- All source page migration statuses remain `pending`.
- Every extracted record remains `review_status: pending`.
- Bus operators and routes require current schedule verification.
- Healthcare facility names and details require verification.
- Donor records remain sensitive and must not be published without explicit public-contact consent.
- Homepage/category cards are navigation metadata, not necessarily entities to insert into the directory tables.

## Next steps

1. Parse the detailed fields inside transport schedules (route, departure, fare, boarding point) while preserving original fragments.
2. Normalize education, healthcare, place, emergency, and important-location records.
3. Identify duplicates and missing titles, then prepare a human-review report.
4. Only after review and approval, import eligible records into live tables using controlled, auditable operations.
