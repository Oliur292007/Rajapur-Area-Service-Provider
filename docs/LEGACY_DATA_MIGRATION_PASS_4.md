# Legacy Data Migration — Pass 4: Human Review Queue

Date: 2026-11-26

## Outcome

Created `public.legacy_review_queue`, a review-task table linked to normalized staging records. It flags records requiring human verification. A record may have more than one task, so task totals are not the same as record totals.

- Normalized source records: **204**
- Records with at least one review task: **204**
- Open review tasks: **250**
- Approved/imported/published: **0**

## Review queue summary

| Issue | Severity | Tasks |
|---|---|---:|
| Sensitive donor personal data | Critical | 7 |
| Verify current operational information | High | 154 |
| Possible duplicate title collision | High | 29 |
| Missing title | High | 8 |
| Verify source classification | Normal | 31 |
| Insufficient detail | Normal | 9 |
| Navigation metadata only | Low | 12 |
| **Total** | | **250** |

## Review workflow

1. Resolve critical donor privacy tasks first. Do not expose donor names or contact details publicly without explicit, current consent.
2. Verify operational records (doctors/clinics, institutions, emergency contacts, transport operators and schedules, facilities) with the responsible organization.
3. Review duplicate candidates against original fragments. A repeated route with different departure times is not necessarily a duplicate. No automatic merging occurs.
4. Inspect untitled and short-content records. Some may be CTA/navigation fragments rather than real entities.
5. Confirm destination type for places, area information, and important locations.
6. Mark a task resolved or waived only after adding a reason in the review notes.

## Access controls

RLS is enabled. Anonymous SELECT is denied. Authenticated SELECT is restricted by trusted `app_metadata.role = 'admin'`. No write privileges were granted to client roles. Review mutations should be implemented through a controlled admin backend workflow later.

## Safety / import gate

- Original source HTML remains preserved.
- Normalized staging rows remain pending.
- All review tasks remain open.
- No live directory or marketplace tables were changed.
- Pass 5 must not import any records until human review and explicit approval.
