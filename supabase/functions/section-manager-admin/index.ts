import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const originAllowed = "https://amader-rajapur.vercel.app";
const cors = {"Access-Control-Allow-Origin":originAllowed,"Access-Control-Allow-Headers":"authorization, apikey, content-type, x-client-info","Access-Control-Allow-Methods":"GET, POST, PATCH, OPTIONS","Vary":"Origin"};
const json=(body:unknown,status=200)=>new Response(JSON.stringify(body),{status,headers:{...cors,"Content-Type":"application/json","Cache-Control":"no-store"}});
const allowedTarget=new Set(["transport_operator","organization","educational_institution"]);
const permissionKeys=["view","add","edit","delete"];

Deno.serve(async(req:Request)=>{
 if(req.method==="OPTIONS")return new Response("ok",{headers:cors});
 if(!["GET","POST","PATCH"].includes(req.method))return json({error:"Method not allowed"},405);
 const origin=req.headers.get("origin");if(origin&&origin!==originAllowed)return json({error:"Origin not allowed"},403);
 const token=(req.headers.get("authorization")||"").replace(/^Bearer\s+/i,"");if(!token)return json({error:"Authentication required"},401);
 const url=Deno.env.get("SUPABASE_URL")!,anon=Deno.env.get("SUPABASE_ANON_KEY")||Deno.env.get("SUPABASE_PUBLISHABLE_KEY")!,secret=Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
 if(!url||!anon||!secret)return json({error:"Server configuration incomplete"},500);
 const auth=createClient(url,anon,{auth:{persistSession:false,autoRefreshToken:false},global:{headers:{Authorization:"Bearer "+token}}});
 const {data:authData,error:authError}=await auth.auth.getUser(token);const user=authData?.user;
 if(authError||!user||user.app_metadata?.role!=="admin")return json({error:"Admin access required"},403);
 const db=createClient(url,secret,{auth:{persistSession:false,autoRefreshToken:false}});
 if(req.method==="GET"){
  const [ops,orgs,schools,assignments]=await Promise.all([
   db.from("transport_operators").select("id,name").order("name"),
   db.from("organizations").select("id,name,organization_type").order("name"),
   db.from("educational_institutions").select("id,name,institution_type").order("name"),
   db.from("section_manager_assignments").select("*").order("created_at",{ascending:false})
  ]);
  const err=ops.error||orgs.error||schools.error||assignments.error;if(err)return json({error:"Could not load manager data"},500);
  const users=await Promise.all((assignments.data||[]).map(async(a:any)=>{const u=await db.auth.admin.getUserById(a.user_id);return {...a,email:u.data.user?.email||"Unknown account",target_name:a.target_type==="transport_operator"?(ops.data||[]).find((x:any)=>x.id===a.target_id)?.name:a.target_type==="educational_institution"?(schools.data||[]).find((x:any)=>x.id===a.target_id)?.name:(orgs.data||[]).find((x:any)=>x.id===a.target_id)?.name||"Unknown target"};}));
  return json({operators:ops.data||[],organizations:orgs.data||[],educationalInstitutions:schools.data||[],assignments:users});
 }
 let body:any;try{body=await req.json();}catch{return json({error:"Invalid JSON"},400);}
 if(req.method==="POST"&&body.action==="save_institution"){
  const id=String(body.id||"").trim(),name=String(body.name||"").trim();
  if(!name||name.length>180|| (id&&!/^[0-9a-f-]{36}$/i.test(id)))return json({error:"A valid institution name is required"},400);
  const payload={name,institution_type:String(body.institution_type||"").trim()||null,address:String(body.address||"").trim()||null,phone:String(body.phone||"").trim()||null,website_url:String(body.website_url||"").trim()||null,description:String(body.description||"").trim()||null,is_public:body.is_public===true,is_active:body.is_active===true,updated_at:new Date().toISOString()};
  if(payload.website_url){try{const u=new URL(payload.website_url);if(!["https:","http:"].includes(u.protocol))throw new Error();}catch{return json({error:"Website URL must use HTTP or HTTPS"},400);}}
  const q=id?await db.from("educational_institutions").update(payload).eq("id",id).select().single():await db.from("educational_institutions").insert(payload).select().single();
  if(q.error)return json({error:"Could not save institution"},500);return json({ok:true,institution:q.data});
 }
 if(req.method==="POST"){
  const email=String(body.email||"").trim().toLowerCase(),targetType=String(body.targetType||""),targetId=String(body.targetId||"");
  if(!email.includes("@")||!allowedTarget.has(targetType)||!/^[0-9a-f-]{36}$/i.test(targetId))return json({error:"Valid email and target are required"},400);
  const permissions:any={};for(const key of permissionKeys)permissions[key]=body.permissions?.[key]===true;
  permissions.view=true;
  const targetCheck=targetType==="transport_operator"
    ? await db.from("transport_operators").select("id").eq("id",targetId).maybeSingle()
    : targetType==="educational_institution"
      ? await db.from("educational_institutions").select("id").eq("id",targetId).maybeSingle()
      : await db.from("organizations").select("id").eq("id",targetId).maybeSingle();
  if(targetCheck.error||!targetCheck.data)return json({error:"Selected manager target was not found"},404);
  const users=await db.auth.admin.listUsers({page:1,perPage:1000});
  if(users.error)return json({error:"Could not look up user account"},500);
  const targetUser=users.data.users.find((u:any)=>u.email?.toLowerCase()===email);
  if(!targetUser)return json({error:"No registered account found for this email. Ask the manager to create an account first."},404);
  const {data,error}=await db.from("section_manager_assignments").upsert({user_id:targetUser.id,target_type:targetType,target_id:targetId,permissions,is_active:true,assigned_by:user.id,updated_at:new Date().toISOString()},{onConflict:"user_id,target_type,target_id"}).select().single();
  if(error)return json({error:"Could not save manager assignment"},500);
  return json({ok:true,assignment:data});
 }
 const id=String(body.id||"");if(!/^[0-9a-f-]{36}$/i.test(id))return json({error:"Invalid assignment id"},400);
 if(body.action==="delete_institution"){const {error}=await db.from("educational_institutions").delete().eq("id",id);if(error)return json({error:"Could not delete institution"},500);return json({ok:true});}
 if(body.action==="revoke"){
  const {error}=await db.from("section_manager_assignments").update({is_active:false,updated_at:new Date().toISOString()}).eq("id",id);
  if(error)return json({error:"Could not revoke assignment"},500);return json({ok:true});
 }
 const permissions:any={};for(const key of permissionKeys)permissions[key]=body.permissions?.[key]===true;permissions.view=true;
 const {error}=await db.from("section_manager_assignments").update({permissions,is_active:body.is_active!==false,updated_at:new Date().toISOString()}).eq("id",id);
 if(error)return json({error:"Could not update assignment"},500);return json({ok:true});
});