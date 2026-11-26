-- Stage approved legacy school/college names for manager assignment and verification.
-- These rows are deliberately hidden and inactive; legacy approval is not publication approval.
INSERT INTO public.educational_institutions (name,institution_type,description,is_public,is_active)
SELECT
  r.title,
  CASE r.source_page
    WHEN 'primary-schools.html' THEN 'Primary School'
    WHEN 'high-schools.html' THEN 'High School'
    WHEN 'secondary-schools.html' THEN 'Secondary School'
    WHEN 'collages.html' THEN 'College'
    ELSE 'Educational Institution'
  END,
  'Legacy directory entry from '||r.source_page||'. Current name, address and contact details require verification. Not publicly listed.',
  false,
  false
FROM public.legacy_content_records r
WHERE r.record_type='education_institution'
  AND r.review_status='approved'
  AND NOT EXISTS (
    SELECT 1 FROM public.educational_institutions i
    WHERE lower(regexp_replace(i.name,'[^a-z0-9]','','g'))=lower(regexp_replace(r.title,'[^a-z0-9]','','g'))
  );
