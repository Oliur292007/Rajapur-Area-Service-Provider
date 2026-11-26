
create table public.legacy_content_staging (
  page_path text primary key,
  source_sha text,
  page_title text,
  page_text text not null,
  headings jsonb not null default '[]'::jsonb,
  internal_links jsonb not null default '[]'::jsonb,
  external_links jsonb not null default '[]'::jsonb,
  image_paths jsonb not null default '[]'::jsonb,
  extracted_records jsonb not null default '[]'::jsonb,
  raw_html text not null,
  migration_status text not null default 'pending' check (migration_status in ('pending','reviewed','imported','ignored')),
  review_notes text,
  fetched_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index idx_legacy_content_status on public.legacy_content_staging(migration_status);
alter table public.legacy_content_staging enable row level security;
revoke all privileges on public.legacy_content_staging from anon;
revoke all privileges on public.legacy_content_staging from authenticated;
grant select, insert, update, delete on public.legacy_content_staging to authenticated;
grant all on public.legacy_content_staging to service_role;
create policy "Admins manage legacy content staging" on public.legacy_content_staging
for all to authenticated
using (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin')
with check (((select auth.jwt()) -> 'app_metadata' ->> 'role') = 'admin');
