-- Protect doctor appointment contact numbers behind explicit public consent.
ALTER TABLE public.doctors
  ADD COLUMN IF NOT EXISTS consent_public_phone boolean NOT NULL DEFAULT false;

CREATE TABLE IF NOT EXISTS public.doctor_public_contacts (
  doctor_id uuid PRIMARY KEY REFERENCES public.doctors(id) ON DELETE CASCADE,
  phone text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.doctor_public_contacts ENABLE ROW LEVEL SECURITY;

GRANT SELECT ON public.doctor_public_contacts TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON public.doctor_public_contacts TO authenticated;

CREATE POLICY "Public can read consented doctor contacts"
ON public.doctor_public_contacts FOR SELECT TO anon, authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.doctors d
    JOIN public.organizations o ON o.id = d.organization_id
    WHERE d.id = doctor_public_contacts.doctor_id
      AND d.is_active = true
      AND (o.is_public = true OR o.is_active = true)
  )
);

CREATE POLICY "Assigned managers read doctor contacts"
ON public.doctor_public_contacts FOR SELECT TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.doctors d
    JOIN public.section_manager_assignments a ON a.target_id = d.organization_id
    WHERE d.id = doctor_public_contacts.doctor_id
      AND a.user_id = (SELECT auth.uid())
      AND a.target_type = 'organization'
      AND a.is_active
      AND COALESCE((a.permissions->>'view')::boolean, false)
  )
);

CREATE POLICY "Admins manage doctor contacts"
ON public.doctor_public_contacts FOR ALL TO authenticated
USING ((SELECT auth.jwt())->'app_metadata'->>'role' = 'admin')
WITH CHECK ((SELECT auth.jwt())->'app_metadata'->>'role' = 'admin');

CREATE POLICY "Assigned managers insert doctor contacts"
ON public.doctor_public_contacts FOR INSERT TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.doctors d
    JOIN public.section_manager_assignments a ON a.target_id = d.organization_id
    WHERE d.id = doctor_public_contacts.doctor_id
      AND a.user_id = (SELECT auth.uid())
      AND a.target_type = 'organization'
      AND a.is_active
      AND (COALESCE((a.permissions->>'add')::boolean, false)
        OR COALESCE((a.permissions->>'edit')::boolean, false))
  )
);

CREATE POLICY "Assigned managers update doctor contacts"
ON public.doctor_public_contacts FOR UPDATE TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.doctors d
    JOIN public.section_manager_assignments a ON a.target_id = d.organization_id
    WHERE d.id = doctor_public_contacts.doctor_id
      AND a.user_id = (SELECT auth.uid())
      AND a.target_type = 'organization'
      AND a.is_active
      AND (COALESCE((a.permissions->>'add')::boolean, false)
        OR COALESCE((a.permissions->>'edit')::boolean, false))
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.doctors d
    JOIN public.section_manager_assignments a ON a.target_id = d.organization_id
    WHERE d.id = doctor_public_contacts.doctor_id
      AND a.user_id = (SELECT auth.uid())
      AND a.target_type = 'organization'
      AND a.is_active
      AND (COALESCE((a.permissions->>'add')::boolean, false)
        OR COALESCE((a.permissions->>'edit')::boolean, false))
  )
);

CREATE POLICY "Assigned managers delete doctor contacts"
ON public.doctor_public_contacts FOR DELETE TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.doctors d
    JOIN public.section_manager_assignments a ON a.target_id = d.organization_id
    WHERE d.id = doctor_public_contacts.doctor_id
      AND a.user_id = (SELECT auth.uid())
      AND a.target_type = 'organization'
      AND a.is_active
      AND (COALESCE((a.permissions->>'edit')::boolean, false)
        OR COALESCE((a.permissions->>'delete')::boolean, false))
  )
);

REVOKE SELECT ON public.doctors, public.doctor_schedules FROM anon;
GRANT SELECT (id, organization_id, full_name, specialty, qualifications, bio, photo_url, is_active)
ON public.doctors TO anon;
GRANT SELECT (id, doctor_id, organization_id, weekday, start_time, end_time, schedule_note, is_active)
ON public.doctor_schedules TO anon;

CREATE OR REPLACE VIEW public.public_doctors
WITH (security_invoker = true, security_barrier = true) AS
SELECT d.id, d.organization_id, d.full_name, d.specialty, d.qualifications,
       d.bio, d.photo_url, c.phone AS public_phone
FROM public.doctors d
JOIN public.organizations o ON o.id = d.organization_id
LEFT JOIN public.doctor_public_contacts c ON c.doctor_id = d.id
WHERE d.is_active = true AND (o.is_public = true OR o.is_active = true);

CREATE OR REPLACE VIEW public.public_doctor_schedules
WITH (security_invoker = true, security_barrier = true) AS
SELECT s.id, s.doctor_id, s.organization_id, s.weekday, s.start_time,
       s.end_time, s.schedule_note, c.phone AS public_phone
FROM public.doctor_schedules s
JOIN public.doctors d ON d.id = s.doctor_id
JOIN public.organizations o ON o.id = s.organization_id
LEFT JOIN public.doctor_public_contacts c ON c.doctor_id = d.id
WHERE s.is_active = true AND d.is_active = true
  AND (o.is_public = true OR o.is_active = true);

GRANT SELECT ON public.public_doctors, public.public_doctor_schedules TO anon, authenticated;

CREATE OR REPLACE FUNCTION public.sync_doctor_public_contact()
RETURNS trigger
LANGUAGE plpgsql
SET search_path TO ''
AS $function$
BEGIN
  IF TG_OP = 'DELETE' THEN
    RETURN OLD;
  END IF;
  IF NEW.consent_public_phone = true AND NULLIF(btrim(NEW.appointment_phone), '') IS NOT NULL THEN
    INSERT INTO public.doctor_public_contacts(doctor_id, phone)
    VALUES (NEW.id, NEW.appointment_phone)
    ON CONFLICT (doctor_id) DO UPDATE
      SET phone = EXCLUDED.phone, updated_at = now();
  ELSE
    DELETE FROM public.doctor_public_contacts WHERE doctor_id = NEW.id;
  END IF;
  RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS sync_doctor_public_contact ON public.doctors;
CREATE TRIGGER sync_doctor_public_contact
AFTER INSERT OR UPDATE OF appointment_phone, consent_public_phone ON public.doctors
FOR EACH ROW EXECUTE FUNCTION public.sync_doctor_public_contact();
