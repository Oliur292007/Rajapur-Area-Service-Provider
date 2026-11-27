-- Direct anonymous reads must follow the same facility publication boundary as the safe views.
DROP POLICY IF EXISTS "Public can read active doctors" ON public.doctors;
CREATE POLICY "Public can read doctors at listed facilities"
ON public.doctors FOR SELECT TO anon, authenticated
USING (
  is_active = true
  AND EXISTS (
    SELECT 1 FROM public.organizations o
    WHERE o.id = doctors.organization_id
      AND (o.is_public = true OR o.is_active = true)
  )
);

DROP POLICY IF EXISTS "Public can read active doctor schedules" ON public.doctor_schedules;
CREATE POLICY "Public can read schedules at listed facilities"
ON public.doctor_schedules FOR SELECT TO anon, authenticated
USING (
  is_active = true
  AND EXISTS (
    SELECT 1 FROM public.organizations o
    JOIN public.doctors d ON d.organization_id = o.id
    WHERE d.id = doctor_schedules.doctor_id
      AND d.is_active = true
      AND o.id = doctor_schedules.organization_id
      AND (o.is_public = true OR o.is_active = true)
  )
);
