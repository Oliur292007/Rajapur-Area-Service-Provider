import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
const supabase=createClient('https://kapuhxccffmjgeszixxh.supabase.co','sb_publishable_pr-6-lthGkKlq8RNoxwmqg_X4pqblAV');
const params=new URLSearchParams(location.search),organizationId=params.get('organization')||'';
const $=id=>document.getElementById(id),esc=v=>String(v??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c])),safeImage=v=>{try{const u=new URL(String(v||''),location.origin);return ['http:','https:'].includes(u.protocol)?u.href:'';}catch{return '';}};
let language=localStorage.getItem('rasp-language')||'en',doctors=[],schedules=[],facility=null;
const copy={
 en:{skip:'Skip to content',navHome:'Home',navAbout:'About',navEmergency:'Emergency',themeLabel:'Theme',themeSystem:'System',themeLight:'Light',themeDark:'Dark',menu:'Menu',healthcare:'Healthcare',detailKicker:'DOCTORS & APPOINTMENTS',doctorsHeading:'Doctors & schedules',doctorsIntro:'Check each doctor’s available chamber days and appointment details.',doctorSearch:'Search doctors or specialties…',loading:'Loading…',backHealthcare:'Back to healthcare directory',footerAbout:'Connecting people with the information and services that matter locally.',quickLinks:'Quick links',contact:'Contact',upazilaSite:'Rajapur Upazila',items:'doctors',noDoctors:'No currently published doctor profiles are available for this facility.',noMatches:'No doctors match your search.',loadError:'Doctor information could not be loaded. Please try again later.',invalid:'This healthcare facility link is invalid or unavailable.',pending:'This facility’s current service information is being verified.',address:'Address',schedule:'Chamber schedule',noSchedule:'No published chamber schedule is available yet.',call:'Appointment',qualification:'Qualifications',verified:'Published doctor profile',days:['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'],time:'Time'},
 bn:{skip:'মূল কনটেন্টে যান',navHome:'হোম',navAbout:'পরিচিতি',navEmergency:'জরুরি সেবা',themeLabel:'রঙের ধরন',themeSystem:'ডিভাইস অনুযায়ী',themeLight:'উজ্জ্বল',themeDark:'অন্ধকার',menu:'মেনু',healthcare:'স্বাস্থ্যসেবা',detailKicker:'চিকিৎসক ও অ্যাপয়েন্টমেন্ট',doctorsHeading:'চিকিৎসক ও সময়সূচি',doctorsIntro:'প্রতিটি চিকিৎসকের চেম্বারের দিন, সময় ও অ্যাপয়েন্টমেন্টের তথ্য দেখুন।',doctorSearch:'চিকিৎসক বা বিশেষজ্ঞতা খুঁজুন…',loading:'লোড হচ্ছে…',backHealthcare:'স্বাস্থ্যসেবা ডিরেক্টরিতে ফিরুন',footerAbout:'রাজাপুরের মানুষকে প্রয়োজনীয় স্থানীয় তথ্য ও সেবার সঙ্গে যুক্ত করার উদ্যোগ।',quickLinks:'প্রয়োজনীয় লিংক',contact:'যোগাযোগ',upazilaSite:'রাজাপুর উপজেলা পরিষদ',items:'জন চিকিৎসক',noDoctors:'এই প্রতিষ্ঠানের কোনো প্রকাশিত চিকিৎসকের তথ্য এখনো নেই।',noMatches:'আপনার খোঁজের সঙ্গে মেলে এমন চিকিৎসক পাওয়া যায়নি।',loadError:'চিকিৎসকের তথ্য আনা যাচ্ছে না। কিছুক্ষণ পর আবার চেষ্টা করুন।',invalid:'প্রতিষ্ঠানের লিংকটি সঠিক নয় অথবা পাওয়া যায়নি।',pending:'এই প্রতিষ্ঠানের বর্তমান সেবার তথ্য যাচাই করা হচ্ছে।',address:'ঠিকানা',schedule:'চেম্বারের সময়সূচি',noSchedule:'এখনো কোনো প্রকাশিত চেম্বার সময়সূচি নেই।',call:'অ্যাপয়েন্টমেন্ট',qualification:'যোগ্যতা',verified:'প্রকাশিত চিকিৎসক প্রোফাইল',days:['রবিবার','সোমবার','মঙ্গলবার','বুধবার','বৃহস্পতিবার','শুক্রবার','শনিবার'],time:'সময়'}
};
const t=k=>copy[language][k]||k;
function theme(v){const x=v==='system'?(matchMedia('(prefers-color-scheme: dark)').matches?'dark':'light'):v;document.documentElement.dataset.theme=x;document.querySelector('meta[name="theme-color"]')?.setAttribute('content',x==='dark'?'#101522':'#f7f8fc');}
function render(){
 const q=$('doctorSearch').value.trim().toLocaleLowerCase(),filtered=doctors.filter(d=>[d.full_name,d.specialty,d.qualifications,d.bio].join(' ').toLocaleLowerCase().includes(q));
 $('doctorCount').textContent=filtered.length+' '+t('items');
 if(!filtered.length){$('doctorGrid').innerHTML='<div class="empty-state">'+(doctors.length?t('noMatches'):t('noDoctors'))+'</div>';return;}
 $('doctorGrid').innerHTML=filtered.map(d=>{
  const rows=schedules.filter(s=>s.doctor_id===d.id);
  const scheduleMarkup=rows.length?rows.map(s=>'<div class="doctor-schedule"><strong>'+esc(s.weekday===null?t('schedule'):t('days')[s.weekday])+'</strong><span>'+esc([s.start_time,s.end_time].filter(Boolean).join(' – ')||t('schedule'))+'</span>'+(s.schedule_note?'<p>'+esc(s.schedule_note)+'</p>':'')+(s.public_phone?'<a class="record-call" href="tel:'+esc(s.public_phone.replace(/[^+0-9]/g,''))+'">'+t('call')+': '+esc(s.public_phone)+'</a>':'')+'</div>').join(''):'<p class="doctor-no-schedule">'+t('noSchedule')+'</p>';
  return '<article class="record-card doctor-card">'+(safeImage(d.photo_url)?'<img class="record-image doctor-image" src="'+esc(safeImage(d.photo_url))+'" alt="" loading="lazy">':'')+'<div class="record-content"><div class="record-tags"><span>'+t('verified')+'</span></div><h2>'+esc(d.full_name)+'</h2>'+(d.specialty?'<p class="doctor-specialty">'+esc(d.specialty)+'</p>':'')+(d.qualifications?'<p>'+t('qualification')+': '+esc(d.qualifications)+'</p>':'')+(d.bio?'<p>'+esc(d.bio)+'</p>':'')+'<div class="doctor-schedules"><h3>'+t('schedule')+'</h3>'+scheduleMarkup+'</div>'+(d.public_phone?'<a class="record-call" href="tel:'+esc(d.public_phone.replace(/[^+0-9]/g,''))+'">'+t('call')+': '+esc(d.public_phone)+'</a>':'')+'</div></article>';
 }).join('');
}
function applyLanguage(){
 const d=copy[language];document.documentElement.lang=language;document.body.lang=language;
 document.querySelectorAll('[data-i18n]').forEach(el=>{const k=el.dataset.i18n;if(d[k])el.textContent=d[k];});
 document.querySelectorAll('[data-i18n-placeholder]').forEach(el=>{const k=el.dataset.i18nPlaceholder;if(d[k])el.placeholder=d[k];});
 $('languageToggle').textContent=language==='en'?'বাংলা':'English';document.title=t('doctorsHeading')+' | Rajapur Area Services';if(facility)$('facilityContact').innerHTML=(facility.phone?'<a class="record-call" href="tel:'+esc(facility.phone.replace(/[^+0-9]/g,''))+'">'+t('call')+': '+esc(facility.phone)+'</a>':'')+(safeImage(facility.website_url)?'<a class="record-external" href="'+esc(safeImage(facility.website_url))+'" target="_blank" rel="noopener noreferrer">'+(language==='bn'?'ওয়েবসাইট':'Website')+' ↗</a>':'');render();
}
async function init(){
 const themeSelect=$('themeSelect');themeSelect.value=localStorage.getItem('rasp-theme')||'system';theme(themeSelect.value);themeSelect.addEventListener('change',e=>{localStorage.setItem('rasp-theme',e.target.value);theme(e.target.value);});
 $('languageToggle').addEventListener('click',()=>{language=language==='en'?'bn':'en';localStorage.setItem('rasp-language',language);applyLanguage();});
 $('doctorSearch').addEventListener('input',render);
 const menu=$('menuToggle'),nav=$('mobileNav');menu.addEventListener('click',()=>{const open=menu.getAttribute('aria-expanded')==='true';menu.setAttribute('aria-expanded',String(!open));nav.hidden=open;});
 nav.querySelectorAll('a').forEach(a=>a.addEventListener('click',()=>{nav.hidden=true;menu.setAttribute('aria-expanded','false');}));
 $('currentYear').textContent=new Date().getFullYear();matchMedia('(prefers-color-scheme: dark)').addEventListener?.('change',()=>{if((localStorage.getItem('rasp-theme')||'system')==='system')theme('system');});
 applyLanguage();
 if(!/^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(organizationId)){$('doctorGrid').innerHTML='<div class="error-state">'+t('invalid')+'</div>';return;}
 try{
  const org=await supabase.from('organizations').select('id,name,address,phone,website_url,description,is_active,is_public').eq('id',organizationId).or('is_public.eq.true,is_active.eq.true').maybeSingle();
  if(org.error)throw org.error;if(!org.data)throw new Error('Facility unavailable');facility=org.data;
  $('facilityTitle').textContent=org.data.name;$('breadcrumbOrganization').textContent=org.data.name;$('facilityDescription').textContent=org.data.description||(org.data.is_active?'':t('pending'));$('facilityAddress').textContent=org.data.address||'';$('facilityContact').innerHTML=(org.data.phone?'<a class="record-call" href="tel:'+esc(org.data.phone.replace(/[^+0-9]/g,''))+'">'+t('call')+': '+esc(org.data.phone)+'</a>':'')+(safeImage(org.data.website_url)?'<a class="record-external" href="'+esc(safeImage(org.data.website_url))+'" target="_blank" rel="noopener noreferrer">'+(language==='bn'?'ওয়েবসাইট':'Website')+' ↗</a>':'');
  const [d,s]=await Promise.all([
   supabase.from('public_doctors').select('id,full_name,specialty,qualifications,bio,photo_url,public_phone').eq('organization_id',organizationId).order('full_name'),
   supabase.from('public_doctor_schedules').select('id,doctor_id,weekday,start_time,end_time,schedule_note,public_phone').eq('organization_id',organizationId).order('weekday').order('start_time')
  ]);
  if(d.error)throw d.error;if(s.error)throw s.error;doctors=d.data||[];const ids=new Set(doctors.map(x=>x.id));schedules=(s.data||[]).filter(x=>ids.has(x.doctor_id));applyLanguage();
 }catch(error){console.error('Healthcare details failed',error);$('doctorGrid').innerHTML='<div class="error-state">'+t('loadError')+'</div>';}
}
init();