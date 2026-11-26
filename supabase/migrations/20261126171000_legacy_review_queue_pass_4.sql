-- Pass 4: create a human-review queue for legacy records.
-- This queue is review metadata only; it does not publish or import live records.

create table if not exists public.legacy_review_queue (
 id bigint generated always as identity primary key,
 legacy_record_id bigint not null references public.legacy_content_records(id) on delete cascade,
 issue_type text not null check (issue_type in ('possible_duplicate','missing_title','insufficient_detail','sensitive_personal_data','verify_current_information','navigation_metadata_only','verify_source_classification')),
 severity text not null default 'normal' check (severity in ('low','normal','high','critical')),
 issue_details text not null,
 review_status text not null default 'open' check (review_status in ('open','in_review','resolved','waived')),
 resolution_notes text,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now(),
 unique(legacy_record_id,issue_type)
);
create index if not exists idx_legacy_review_queue_status_severity on public.legacy_review_queue(review_status,severity);
create index if not exists idx_legacy_review_queue_record on public.legacy_review_queue(legacy_record_id);
alter table public.legacy_review_queue enable row level security;
revoke all privileges on public.legacy_review_queue from anon, authenticated;
grant select on public.legacy_review_queue to authenticated;
drop policy if exists "Admins can read legacy review queue" on public.legacy_review_queue;
create policy "Admins can read legacy review queue" on public.legacy_review_queue
 for select to authenticated
 using ((auth.jwt()->'app_metadata'->>'role') = 'admin');

insert into public.legacy_review_queue(legacy_record_id,issue_type,severity,issue_details)
select id,'possible_duplicate','high','Title collision detected by normalized title. Compare route/time/contact and source fragment; do not merge automatically.'
from public.legacy_content_records where duplicate_candidate on conflict do nothing;

insert into public.legacy_review_queue(legacy_record_id,issue_type,severity,issue_details)
select id,'missing_title','high','Record has no extracted title. Inspect original HTML fragment and assign a verified title or mark as non-entity content.'
from public.legacy_content_records where title is null or btrim(title)='' on conflict do nothing;

insert into public.legacy_review_queue(legacy_record_id,issue_type,severity,issue_details)
select id,'insufficient_detail','normal','Short descriptive text; inspect source page and determine whether this is only a navigation card or incomplete entity data.'
from public.legacy_content_records where length(coalesce(source_text,''))<30 on conflict do nothing;

insert into public.legacy_review_queue(legacy_record_id,issue_type,severity,issue_details)
select id,'sensitive_personal_data','critical','Contains third-party donor information. Keep private; publication requires explicit current donor consent and verification.'
from public.legacy_content_records where record_type='blood_donor_source_record' on conflict do nothing;

insert into public.legacy_review_queue(legacy_record_id,issue_type,severity,issue_details)
select id,'verify_current_information','high','Legacy operational information may be outdated. Verify with the responsible organization before publication.'
from public.legacy_content_records where record_type in ('doctor_or_clinic','education_institution','emergency_contact','transport_route_schedule','transport_operator','healthcare_facility') on conflict do nothing;

insert into public.legacy_review_queue(legacy_record_id,issue_type,severity,issue_details)
select id,'navigation_metadata_only','low','This is a homepage/category navigation card, not automatically a directory entity. Preserve as UI metadata unless confirmed otherwise.'
from public.legacy_content_records where record_type in ('homepage_category','education_category') on conflict do nothing;

insert into public.legacy_review_queue(legacy_record_id,issue_type,severity,issue_details)
select id,'verify_source_classification','normal','Review the provisional record type and determine the correct destination table or whether this is descriptive content.'
from public.legacy_content_records where record_type in ('place_or_heritage','area_information','important_location') on conflict do nothing;
