-- Require each doctor to belong to a healthcare organization.
-- Schedules must belong to the same organization as their doctor.
ALTER TABLE public.doctors
  ALTER COLUMN organization_id SET NOT NULL,
  ALTER COLUMN is_active SET DEFAULT false;

ALTER TABLE public.doctors
  ADD CONSTRAINT doctors_id_organization_id_unique
  UNIQUE (id, organization_id);

ALTER TABLE public.doctor_schedules
  ALTER COLUMN organization_id SET NOT NULL,
  ALTER COLUMN is_active SET DEFAULT false;

ALTER TABLE public.doctor_schedules
  ADD CONSTRAINT doctor_schedules_doctor_organization_fkey
  FOREIGN KEY (doctor_id, organization_id)
  REFERENCES public.doctors (id, organization_id)
  ON DELETE CASCADE;

CREATE INDEX IF NOT EXISTS idx_doctors_org_active_name
  ON public.doctors (organization_id, is_active, full_name);

CREATE INDEX IF NOT EXISTS idx_doctor_schedules_org_active_day
  ON public.doctor_schedules (organization_id, is_active, weekday, start_time);
