-- Admin review performance hardening: index new audit/reviewer foreign keys
-- and evaluate the trusted admin JWT claim once per statement in RLS policies.

create index if not exists idx_legacy_content_records_reviewed_by
  on public.legacy_content_records(reviewed_by);
create index if not exists idx_legacy_review_events_actor_id
  on public.legacy_review_events(actor_id);

drop policy if exists "Admins can review legacy content records" on public.legacy_content_records;
create policy "Admins can review legacy content records"
  on public.legacy_content_records
  for select to authenticated
  using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin');

drop policy if exists "Admins can read legacy review queue" on public.legacy_review_queue;
create policy "Admins can read legacy review queue"
  on public.legacy_review_queue
  for select to authenticated
  using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin');

drop policy if exists "Admins can read legacy review events" on public.legacy_review_events;
create policy "Admins can read legacy review events"
  on public.legacy_review_events
  for select to authenticated
  using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin');
