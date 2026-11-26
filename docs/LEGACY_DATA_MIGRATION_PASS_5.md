# Legacy Data Migration — Pass 5: Admin Review Workflow Foundation

Date: 2026-11-26

## Outcome

Pass 5 prepares the database for a controlled human-review workflow. It adds decision metadata to each normalized legacy record and creates `public.legacy_review_events` for an audit history of record and issue-task decisions.

- Normalized legacy records: **204**
- Records with a decision before this pass: **0**
- Records still pending after this pass: **204**
- Approved/imported/published: **0**
- Review event rows created: **0** (no review action was taken)

## Review decision model

`legacy_content_records.review_decision` accepts:

| Decision | Meaning |
|---|---|
| `approved` | Human reviewer confirms the record is suitable for a future import proposal |
| `rejected` | Record must not be imported |
| `needs_clarification` | More information or source-owner confirmation is required |
| `duplicate` | Record is a duplicate; reviewer must document the canonical record/reference |

The existing `review_status` remains the processing state (currently all 204 are `pending`). The new `review_decision` is the human decision. Keeping these separate avoids confusing a workflow state with an approval decision.

The decision metadata also includes `reviewed_by`, `reviewed_at`, and `admin_review_notes`.

## Audit history

The new `legacy_review_events` table records:
- Target normalized record and/or review task
- Actor user ID
- Action type
- Previous and new state snapshots
- Reviewer note
- Timestamp

The table has RLS enabled. Anonymous access is denied. Authenticated users have SELECT privilege, but RLS restricts rows to users whose trusted Supabase Auth `app_metadata.role` is `admin`. Client roles have no INSERT, UPDATE, or DELETE privileges. The trusted server-side workflow must write events using a server-only service credential; that credential must never be included in browser code or a `NEXT_PUBLIC_*` variable.

## Admin review workflow requirements

The future admin interface/backend should provide:
1. Category/type filters and queue counts.
2. Side-by-side normalized fields and original source fragment/page context.
3. Duplicate-group inspection without automatic merging.
4. Approve, reject, needs-clarification, and duplicate decisions with mandatory notes where appropriate.
5. Issue-task resolution/waiver with a reason.
6. An audit timeline for every decision.
7. A strict import gate: only explicitly approved, sufficiently verified records may be considered for a separate import step.

## Security and privacy

- No client-side write privileges were added.
- No SECURITY DEFINER RPC was introduced.
- Service-role credentials must remain server-side only.
- Legacy donor information remains private; do not expose personal names or contact details without explicit, current consent.
- Repeated transport route titles must not be auto-merged because departure times may differ.

## Safety / import gate

This pass only adds workflow metadata and audit storage. It does not change any live directory/marketplace table, modify existing review decisions, resolve any issue, or import/publish any record. All 204 normalized records remain pending.
