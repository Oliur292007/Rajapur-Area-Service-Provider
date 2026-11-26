-- Expose teacher details through a safe public view only.
-- Direct anon access to base teacher rows is revoked so private phone values cannot be queried.
CREATE OR REPLACE VIEW public.public_teachers
WITH (security_barrier=true)
AS
SELECT
 t.id,t.institution_id,t.full_name,t.designation,t.subject,t.qualifications,t.bio,t.photo_url,
 CASE WHEN t.consent_public_phone THEN t.public_phone ELSE NULL END AS public_phone
FROM public.teachers t
JOIN public.educational_institutions i ON i.id=t.institution_id
WHERE t.is_active=true AND (i.is_public=true OR i.is_active=true);

REVOKE SELECT ON public.teachers FROM anon;
GRANT SELECT ON public.public_teachers TO anon,authenticated;
