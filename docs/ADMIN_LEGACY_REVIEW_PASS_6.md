# Legacy Content Review Admin — Pass 6

## Delivered
- Private static admin workspace at `/admin/`.
- Supabase Auth email/password sign-in.
- Access requires the trusted JWT `app_metadata.role = admin` claim. User-editable metadata is not used.
- Review list, search, decision filter, issue flags, source excerpts, review notes and recent audit activity.
- Bangla/English UI and persisted light/dark/system theme preference.
- Sensitive donor source records and their review tasks are excluded from the review API response.
- Admin actions are handled by the `legacy-admin-review` Supabase Edge Function; the service-role credential remains server-side.
- Edge Function JWT verification is enabled.

## Decision semantics
- `approved`: reviewed and eligible for a later migration assessment only.
- `rejected`, `needs_clarification`, `duplicate`: review metadata only.
- No action in this dashboard imports records into public tables, activates them, or publishes them.
- Approve/reject/duplicate resolves one associated open review task; clarification leaves its task open.
- Every decision and task resolution writes an audit event.

## Current staged data (verified during implementation)
- 204 legacy normalized records were pending before this pass.
- 250 review tasks were open before this pass.
- 7 tasks concern sensitive donor information; the dashboard API deliberately excludes the donor source records and those tasks.
- No legacy record was approved, rejected, imported or published by this implementation.

## Admin setup
1. In Supabase Dashboard > Authentication > Users, create or select the intended administrator account.
2. Set the trusted **App Metadata** claim to `{"role":"admin"}` using an owner-controlled admin process. Do not set this in User Metadata.
3. Sign in at `https://amader-rajapur.vercel.app/admin/` using that account.
4. If the account was already signed in when its app metadata changed, sign out and sign in again to refresh the JWT claim.

Do not grant the admin claim to public users. Never put the service-role key in the repository or browser.

## Verification status
- Supabase Edge Function deployed as `legacy-admin-review`, JWT verification enabled.
- Database constraints and RLS policies were inspected before implementation.
- Static UI and authenticated end-to-end browser testing still require an administrator account with the trusted app metadata claim.
