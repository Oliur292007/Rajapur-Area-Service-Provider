-- Education directory: institutions, teacher profiles, scoped manager assignments.
ALTER TABLE public.section_manager_assignments
  DROP CONSTRAINT section_manager_assignments_target_type_check;
ALTER TABLE public.section_manager_assignments
  ADD CONSTRAINT section_manager_assignments_target_type_check
  CHECK (target_type = ANY (ARRAY['transport_operator','organization','educational_institution']::text[]));

CREATE TABLE public.educational_institutions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  institution_type text,
  address text,
  phone text,
  website_url text,
  logo_url text,
  description text,
  is_public boolean NOT NULL DEFAULT false,
  is_active boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE public.teachers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  institution_id uuid NOT NULL REFERENCES public.educational_institutions(id) ON DELETE CASCADE,
  full_name text NOT NULL,
  designation text,
  subject text,
  qualifications text,
  bio text,
  photo_url text,
  public_phone text,
  is_active boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_educational_institutions_public_active_name ON public.educational_institutions (is_public,is_active,name);
CREATE INDEX idx_teachers_institution_active_name ON public.teachers (institution_id,is_active,full_name);
ALTER TABLE public.educational_institutions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.teachers ENABLE ROW LEVEL SECURITY;
GRANT SELECT ON public.educational_institutions,public.teachers TO anon,authenticated;
GRANT INSERT,UPDATE,DELETE ON public.educational_institutions,public.teachers TO authenticated;
CREATE POLICY "Public can read listed educational institutions" ON public.educational_institutions FOR SELECT TO anon,authenticated USING (is_public=true OR is_active=true);
CREATE POLICY "Assigned managers read educational institutions" ON public.educational_institutions FOR SELECT TO authenticated USING (EXISTS (SELECT 1 FROM public.section_manager_assignments a WHERE a.user_id=(SELECT auth.uid()) AND a.target_type='educational_institution' AND a.target_id=educational_institutions.id AND a.is_active AND COALESCE((a.permissions->>'view')::boolean,false)));
CREATE POLICY "Admins manage educational institutions" ON public.educational_institutions FOR ALL TO authenticated USING ((SELECT auth.jwt())->'app_metadata'->>'role'='admin') WITH CHECK ((SELECT auth.jwt())->'app_metadata'->>'role'='admin');
CREATE POLICY "Assigned managers update educational institutions" ON public.educational_institutions FOR UPDATE TO authenticated USING (EXISTS (SELECT 1 FROM public.section_manager_assignments a WHERE a.user_id=(SELECT auth.uid()) AND a.target_type='educational_institution' AND a.target_id=educational_institutions.id AND a.is_active AND COALESCE((a.permissions->>'edit')::boolean,false))) WITH CHECK (EXISTS (SELECT 1 FROM public.section_manager_assignments a WHERE a.user_id=(SELECT auth.uid()) AND a.target_type='educational_institution' AND a.target_id=educational_institutions.id AND a.is_active AND COALESCE((a.permissions->>'edit')::boolean,false)));
CREATE POLICY "Public can read active teachers" ON public.teachers FOR SELECT TO anon,authenticated USING (is_active=true);
CREATE POLICY "Assigned managers read teachers" ON public.teachers FOR SELECT TO authenticated USING (EXISTS (SELECT 1 FROM public.section_manager_assignments a WHERE a.user_id=(SELECT auth.uid()) AND a.target_type='educational_institution' AND a.target_id=teachers.institution_id AND a.is_active AND COALESCE((a.permissions->>'view')::boolean,false)));
CREATE POLICY "Admins manage teachers" ON public.teachers FOR ALL TO authenticated USING ((SELECT auth.jwt())->'app_metadata'->>'role'='admin') WITH CHECK ((SELECT auth.jwt())->'app_metadata'->>'role'='admin');
CREATE POLICY "Assigned managers insert teachers" ON public.teachers FOR INSERT TO authenticated WITH CHECK (EXISTS (SELECT 1 FROM public.section_manager_assignments a WHERE a.user_id=(SELECT auth.uid()) AND a.target_type='educational_institution' AND a.target_id=teachers.institution_id AND a.is_active AND COALESCE((a.permissions->>'add')::boolean,false)));
CREATE POLICY "Assigned managers update teachers" ON public.teachers FOR UPDATE TO authenticated USING (EXISTS (SELECT 1 FROM public.section_manager_assignments a WHERE a.user_id=(SELECT auth.uid()) AND a.target_type='educational_institution' AND a.target_id=teachers.institution_id AND a.is_active AND COALESCE((a.permissions->>'edit')::boolean,false))) WITH CHECK (EXISTS (SELECT 1 FROM public.section_manager_assignments a WHERE a.user_id=(SELECT auth.uid()) AND a.target_type='educational_institution' AND a.target_id=teachers.institution_id AND a.is_active AND COALESCE((a.permissions->>'edit')::boolean,false)));
CREATE POLICY "Assigned managers delete teachers" ON public.teachers FOR DELETE TO authenticated USING (EXISTS (SELECT 1 FROM public.section_manager_assignments a WHERE a.user_id=(SELECT auth.uid()) AND a.target_type='educational_institution' AND a.target_id=teachers.institution_id AND a.is_active AND COALESCE((a.permissions->>'delete')::boolean,false)));
CREATE OR REPLACE FUNCTION public.log_section_manager_change()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path TO ''
AS $function$
DECLARE v_target_type text; v_target_id uuid; v_row_id uuid; v_old jsonb; v_new jsonb;
BEGIN
 v_row_id:=coalesce((to_jsonb(new)->>'id')::uuid,(to_jsonb(old)->>'id')::uuid);
 IF tg_table_name IN ('transport_operators','bus_routes','bus_schedules') THEN
  v_target_type:='transport_operator';
  IF tg_table_name='transport_operators' THEN v_target_id:=v_row_id;
  ELSIF tg_table_name='bus_routes' THEN v_target_id:=coalesce((to_jsonb(new)->>'operator_id')::uuid,(to_jsonb(old)->>'operator_id')::uuid);
  ELSE SELECT r.operator_id INTO v_target_id FROM public.bus_routes r WHERE r.id=coalesce((to_jsonb(new)->>'route_id')::uuid,(to_jsonb(old)->>'route_id')::uuid); END IF;
 ELSIF tg_table_name IN ('educational_institutions','teachers') THEN
  v_target_type:='educational_institution';
  IF tg_table_name='educational_institutions' THEN v_target_id:=v_row_id; ELSE v_target_id:=coalesce((to_jsonb(new)->>'institution_id')::uuid,(to_jsonb(old)->>'institution_id')::uuid); END IF;
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
CREATE TRIGGER audit_educational_institutions_changes AFTER INSERT OR UPDATE OR DELETE ON public.educational_institutions FOR EACH ROW EXECUTE FUNCTION public.log_section_manager_change();
CREATE TRIGGER audit_teachers_changes AFTER INSERT OR UPDATE OR DELETE ON public.teachers FOR EACH ROW EXECUTE FUNCTION public.log_section_manager_change();
