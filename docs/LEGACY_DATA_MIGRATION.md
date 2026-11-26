# Legacy Content Migration — Extraction Pass 1

Project: Rajapur Area Service Provider
Supabase project: `kapuhxccffmjgeszixxh`

## Scope

This pass extracts individual HTML `<article>` blocks from the archived source pages into `public.legacy_content_staging.extracted_records`. It does not write to live directory, provider, donor, schedule, or public-facing tables.

Each extracted JSON record retains:
- source page (the parent staging row's `page_path`)
- record index
- provisional record type
- extracted heading/title when present
- stripped text preview/content
- original HTML fragment
- `review_status: pending`

Original `raw_html`, source hash, page text, headings, links, and image references remain intact.

## Extraction results

- 39 source pages remain archived.
- 32 pages contained article blocks and received structured article extraction.
- 171 article blocks extracted into staging.
- 8 records currently have no `h1-h6` title (2 place/heritage descriptions and 6 transport-page call-to-action blocks); these need manual review.
- 0 records have been imported into live tables.
- All extracted records remain pending review.

### Provisional record-type counts

| Record type | Count |
| --- | ---: |
| Education institutions | 46 |
| Doctors / clinics | 49 |
| Blood donor source records | 7 |
| Emergency contacts | 4 |
| Important locations | 7 |
| Places / heritage | 10 |
| Area information | 10 |
| Other directory records | 38 |
| **Total** | **171** |

## Important safeguards

- Blood donor entries are source records only. Do not publish donor identity or contact details unless explicit public-contact consent is confirmed.
- Phone numbers and contact information in legacy pages may be outdated. Treat them as unverified.
- Do not promote any record to a live table or set it public/active until a human review confirms the source, category, and current accuracy.
- Transport operator pages and non-article card pages (including the bus, hospital, places, and school-category index pages) still need a separate extraction pass.
- Some article blocks are descriptive text rather than standalone entities. The provisional record type is only a hint, not a final classification.

## Next steps

1. Extract non-article cards and structured content from the remaining pages.
2. Normalize each candidate into the appropriate live-table shape without publishing.
3. Produce a review report grouped by category and source page.
4. Obtain approval and verify stale/contact-sensitive details before controlled import.
