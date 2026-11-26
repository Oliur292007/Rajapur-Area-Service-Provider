-- Keep teacher phone numbers out of the base teacher table for anonymous API clients.
-- The public view runs as invoker and can only join a separate consented-contact row.
CREATE TABLE public.teacher_public_contacts (
 teacher_id uuid PRIMARY KEY REFERENCES public.teachers(id) ON DELETE CASCADE,
 phone text NOT NULL,
 created_at timestamptz NOT NULL DEFAULT now(),
 updated_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.teacher_public_contacts ENABLE ROW LEVEL SECURITY;
GRANT SELECT ON public.teacher_public_contacts TO anon,authenticated;
GRANT INSERT,UPDATE,DELETE ON public.teacher_public_contacts TO authenticated;
CREATE POLICY "Public can read consented teacher contacts" ON public.teacher_public_contacts FOR SELECT TO anon,authenticated USING (EXISTS (SELECT 1 FROM public.teachers t JOIN public.educational_institutions i ON i.id=t.institution_id WHERE t.id=teacher_public_contacts.teacher_id AND t.is_active=true AND (i.is_public=true OR i.is_active=true)));
CREATE POLICY "Assigned managers read teacher contacts" ON public.teacher_public_contacts FOR SELECT TO authenticated USING (EXISTS (SELECT 1 FROM public.teachers t JOIN public.section_manager_assignments a ON a.target_id=t.institution_id WHERE t.id=teacher_public_contacts.teacher_id AND a.user_id=(SELECT auth.uid()) AND a.target_type='educational_institution' AND a.is_active AND COALESCE((a.permissions->>'view')::boolean,false)));
CREATE POLICY "Admins manage teacher contacts" ON public.teacher_public_contacts FOR ALL TO authenticated USING ((SELECT auth.jwt())->'app_metadata'->>'role'='admin') WITH CHECK ((SELECT auth.jwt())->'app_metadata'->>'role'='admin');
CREATE POLICY "Assigned managers insert teacher contacts" ON public.teacher_public_contacts FOR INSERT TO authenticated WITH CHECK (EXISTS (SELECT 1 FROM public.teachers t JOIN public.section_manager_assignments a ON a.target_id=t.institution_id WHERE t.id=teacher_public_contacts.teacher_id AND a.user_id=(SELECT auth.uid()) AND a.target_type='educational_institution' AND a.is_active AND (COALESCE((a.permissions->>'add')::boolean,false) OR COALESCE((a.permissions->>'edit')::boolean,false))));
CREATE POLICY "Assigned managers update teacher contacts" ON public.teacher_public_contacts FOR UPDATE TO authenticated USING (EXISTS (SELECT 1 FROM public.teachers t JOIN public.section_manager_assignments a ON a.target_id=t.institution_id WHERE t.id=teacher_public_contacts.teacher_id AND a.user_id=(SELECT auth.uid()) AND a.target_type='educational_institution' AND a.is_active AND (COALESCE((a.permissions->>'add')::boolean,false) OR COALESCE((a.permissions->>'edit')::boolean,false)))) WITH CHECK (EXISTS (SELECT 1 FROM public.teachers t JOIN public.section_manager_assignments a ON a.target_id=t.institution_id WHERE t.id=teacher_public_contacts.teacher_id AND a.user_id=(SELECT auth.uid()) AND a.target_type='educational_institution' AND a.is_active AND (COALESCE((a.permissions->>'add')::boolean,false) OR COALESCE((a.permissions->>'edit')::boolean,false))));
CREATE POLICY "Assigned managers delete teacher contacts" ON public.teacher_public_contacts FOR DELETE TO authenticated USING (EXISTS (SELECT 1 FROM public.teachers t JOIN public.section_manager_assignments a ON a.target_id=t.institution_id WHERE t.id=teacher_public_contacts.teacher_id AND a.user_id=(SELECT auth.uid()) AND a.target_type='educational_institution' AND a.is_active AND (COALESCE((a.permissions->>'edit')::boolean,false) OR COALESCE((a.permissions->>'delete')::boolean,false))));
REVOKE SELECT ON public.teachers FROM anon;
GRANT SELECT (id,institution_id,full_name,designation,subject,qualifications,bio,photo_url,is_active) ON public.teachers TO anon;
DROP VIEW IF EXISTS public.public_teachers;
CREATE VIEW public.public_teachers WITH (security_invoker=true,security_barrier=true) AS
SELECT t.id,t.institution_id,t.full_name,t.designation,t.subject,t.qualifications,t.bio,t.photo_url,c.phone AS public_phone
FROM public.teachers t
JOIN public.educational_institutions i ON i.id=t.institution_id
LEFT JOIN public.teacher_public_contacts c ON c.teacher_id=t.id
WHERE t.is_active=true AND (i.is_public=true OR i.is_active=true);
GRANT SELECT ON public.public_teachers TO anon,authenticated;
CREATE OR REPLACE FUNCTION public.sync_teacher_public_contact()
RETURNS trigger LANGUAGE plpgsql SET search_path TO ''
AS $function$
BEGIN
 IF TG_OP='DELETE' THEN RETURN OLD; END IF;
 IF NEW.consent_public_phone=true AND NULLIF(btrim(NEW.public_phone),'') IS NOT NULL THEN
  INSERT INTO public.teacher_public_contacts(teacher_id,phone) VALUES(NEW.id,NEW.public_phone)
  ON CONFLICT(teacher_id) DO UPDATE SET phone=EXCLUDED.phone,updated_at=now();
 ELSE
  DELETE FROM public.teacher_public_contacts WHERE teacher_id=NEW.id;
 END IF;
 RETURN NEW;
END;
$function$;
CREATE TRIGGER sync_teacher_public_contact AFTER INSERT OR UPDATE OF public_phone,consent_public_phone ON public.teachers FOR EACH ROW EXECUTE FUNCTION public.sync_teacher_public_contact();
CREATE OR REPLACE FUNCTION public.log_section_manager_change()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path TO ''
AS $function$
DECLARE v_target_type text; v_target_id uuid; v_row_id uuid; v_old jsonb; v_new jsonb; v_teacher_id uuid;
BEGIN
 v_row_id:=coalesce((to_jsonb(new)->>'id')::uuid,(to_jsonb(old)->>'id')::uuid);
 IF tg_table_name='teacher_public_contacts' THEN v_row_id:=coalesce((to_jsonb(new)->>'teacher_id')::uuid,(to_jsonb(old)->>'teacher_id')::uuid); END IF;
 IF tg_table_name IN ('transport_operators','bus_routes','bus_schedules') THEN
  v_target_type:='transport_operator';
  IF tg_table_name='transport_operators' THEN v_target_id:=v_row_id;
  ELSIF tg_table_name='bus_routes' THEN v_target_id:=coalesce((to_jsonb(new)->>'operator_id')::uuid,(to_jsonb(old)->>'operator_id')::uuid);
  ELSE SELECT r.operator_id INTO v_target_id FROM public.bus_routes r WHERE r.id=coalesce((to_jsonb(new)->>'route_id')::uuid,(to_jsonb(old)->>'route_id')::uuid); END IF;
 ELSIF tg_table_name IN ('educational_institutions','teachers','teacher_public_contacts') THEN
  v_target_type:='educational_institution';
  IF tg_table_name='educational_institutions' THEN v_target_id:=v_row_id;
  ELSIF tg_table_name='teachers' THEN v_target_id:=coalesce((to_jsonb(new)->>'institution_id')::uuid,(to_jsonb(old)->>'institution_id')::uuid);
  ELSE v_teacher_id:=coalesce((to_jsonb(new)->>'teacher_id')::uuid,(to_jsonb(old)->>'teacher_id')::uuid); SELECT t.institution_id INTO v_target_id FROM public.teachers t WHERE t.id=v_teacher_id; END IF;
 ELSE
  v_target_type:='organization';
  IF tg_table_name='organizations' THEN v_target_id:=v_row_id; ELSE v_target_id:=coalesce((to_jsonb(new)->>'organization_id')::uuid,(to_jsonb(old)->>'organization_id')::uuid); END IF;
 END IF;
 v_old:=CASE WHEN tg_op IN ('UPDATE','DELETE') THEN to_jsonb(old) ELSE null END;
 v_new:=CASE WHEN tg_op IN ('INSERT','UPDATE') THEN to_jsonb(new) ELSE null END;
 INSERT INTO public.section_manager_audit_logs(actor_user_id,target_type,target_id,table_name,row_id,action,old_data,new_data) VALUES(auth.uid(),v_target_type,v_target_id,tg_table_name,v_row_id,tg_op,v_old,v_new);
 IF tg_op='DELETE' THEN RETURN old; ELSE RETURN new; END IF;
END;
$function$;
CREATE TRIGGER audit_teacher_public_contacts_changes AFTER INSERT OR UPDATE OR DELETE ON public.teacher_public_contacts FOR EACH ROW EXECUTE FUNCTION public.log_section_manager_change();
