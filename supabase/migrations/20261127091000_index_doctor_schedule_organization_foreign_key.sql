CREATE INDEX IF NOT EXISTS idx_doctor_schedules_doctor_organization ON public.doctor_schedules (doctor_id, organization_id);
