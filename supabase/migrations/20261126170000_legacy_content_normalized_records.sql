-- Pass 3: normalized, review-only legacy records.
-- Source archive remains untouched. No live directory/marketplace tables are written.

create table if not exists public.legacy_content_records (
 id bigint generated always as identity primary key,
 source_page text not null references public.legacy_content_staging(page_path) on update cascade on delete restrict,
 source_record_index integer not null,
 record_type text not null,
 title text,
 description text,
 href text,
 image_path text,
 structured_data jsonb not null default '{}'::jsonb,
 raw_fragment text,
 source_text text,
 normalized_title text,
 duplicate_candidate boolean not null default false,
 duplicate_group_key text,
 review_status text not null default 'pending' check (review_status in ('pending','approved','rejected','needs_clarification')),
 review_notes text,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now(),
 unique(source_page, source_record_index)
);

alter table public.legacy_content_records enable row level security;
revoke all privileges on public.legacy_content_records from anon, authenticated;
grant select on public.legacy_content_records to authenticated;
drop policy if exists "Admins can review legacy content records" on public.legacy_content_records;
create policy "Admins can review legacy content records" on public.legacy_content_records
 for select to authenticated
 using ((auth.jwt()->'app_metadata'->>'role') = 'admin');

insert into public.legacy_content_records
(source_page,source_record_index,record_type,title,description,href,image_path,structured_data,raw_fragment,source_text,normalized_title,duplicate_group_key)
with src as (
 select s.page_path, e
 from public.legacy_content_staging s
 cross join lateral jsonb_array_elements(s.extracted_records) e
),
base as (
 select page_path,
 (e->>'record_index')::integer as idx,
 coalesce(e->>'record_type','unknown') as typ,
 nullif(btrim(e->>'title'),'') as title,
 nullif(btrim(e->>'description'),'') as description,
 nullif(e->>'href','') as href,
 nullif(e->>'image_src','') as image_path,
 coalesce(e->>'content_text',e->>'description','') as src_text,
 e->>'html_fragment' as fragment
 from src
),
norm as (
 select *,
 lower(regexp_replace(coalesce(title,''),'[[:space:][:punct:]]+','','g')) as norm_title
 from base
)
select page_path,idx,typ,title,description,href,image_path,
 jsonb_strip_nulls(jsonb_build_object(
   'contact_numbers',(select jsonb_agg(m[1]) from regexp_matches(coalesce(src_text,''),'([+]?[0-9][0-9 -]{9,14}[0-9])','g') m),
   'time_text',case when src_text like '%সময়:%' then btrim(split_part(split_part(src_text,'সময়:',2),chr(10),1)) when src_text like '%সময়：%' then btrim(split_part(split_part(src_text,'সময়：',2),chr(10),1)) else null end,
   'opening_hours_text',(regexp_match(src_text,'Opens?:[[:space:]]*([^\r\n]+)'))[1],
   'route_text',case when typ='transport_route_schedule' then title else null end,
   'blood_group_text',(regexp_match(src_text,'Blood Group:[[:space:]]*([A-Za-z+-]+)'))[1]
 )),
 fragment,src_text,norm_title,
 case when norm_title<>'' then md5(typ||':'||norm_title) else null end
from norm
on conflict(source_page,source_record_index) do nothing;

with dup as (
 select duplicate_group_key from public.legacy_content_records
 where duplicate_group_key is not null
 group by duplicate_group_key having count(*)>1
)
update public.legacy_content_records r set duplicate_candidate=true
from dup where r.duplicate_group_key=dup.duplicate_group_key;
