import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const SUPABASE_URL = 'https://kapuhxccffmjgeszixxh.supabase.co';
const SUPABASE_PUBLISHABLE_KEY = 'sb_publishable_pr-6-lthGkKlq8RNoxwmqg_X4pqblAV';
const supabase = createClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY);

const translations = {
  en: {
    skip:'Skip to content',navHome:'Home',navAbout:'About',navEmergency:'Emergency',themeLabel:'Theme',themeSystem:'System',themeLight:'Light',themeDark:'Dark',menu:'Menu',
    eyebrow:'YOUR LOCAL DIRECTORY',heroTitle:'Everything in Rajapur,<br><em>all in one place.</em>',heroText:'Discover trusted local information, essential services and useful places around your community.',searchPlaceholder:'Search services, doctors, places...',searchHint:'Type at least 2 characters to search the live directory.',searchLoading:'Searching the directory…',searchNoResults:'No matching public records found.',searchError:'Search is temporarily unavailable.',searchKinds:{category:'Category',listing:'Directory listing',doctor:'Doctor',service:'Service',transport:'Transport',education:'Educational institution',emergency:'Emergency contact',place:'Place',information:'Local information'},location:'Rajapur, Jhalakathi, Bangladesh',
    directoryKicker:'EXPLORE THE DIRECTORY',directoryTitle:'What are you looking for?',directoryText:'Browse services and information available in Rajapur.',liveData:'Live directory',loading:'Loading categories…',
    communityKicker:'BUILT FOR THE COMMUNITY',communityTitle:'A more connected Rajapur.',communityText:'A shared place to discover local knowledge and essential services.',learnMore:'Learn more',
    footerAbout:'Connecting people with the information and services that matter locally.',quickLinks:'Quick links',contact:'Contact',upazilaSite:'Rajapur Upazila',
    noResults:'No categories match your search.',loadError:'Could not load the directory right now. Please try again later.',
    categoryDescriptions:{healthcare:'Hospitals, clinics, doctors and health services.',education:'Schools, colleges and educational institutions.', 'blood-donation':'Blood donation and donor information.',transport:'Bus operators and published schedules.','places-heritage':'Tourism, historical places and local heritage.','emergency-contacts':'Important emergency service contacts.','important-locations':'Public offices and essential locations.','rajapur-information':'Local statistics and area information.','local-services':'Local businesses and service providers.'},
    categoryNames:{healthcare:'Healthcare',education:'Education','blood-donation':'Blood Donation',transport:'Transport','places-heritage':'Places & Heritage','emergency-contacts':'Emergency Contacts','important-locations':'Important Locations','rajapur-information':'Rajapur Information','local-services':'Local Services'}
  },
  bn: {
    skip:'মূল কনটেন্টে যান',navHome:'হোম',navAbout:'আমাদের সম্পর্কে',navEmergency:'জরুরি সেবা',themeLabel:'থিম',themeSystem:'সিস্টেম',themeLight:'লাইট',themeDark:'ডার্ক',menu:'মেনু',
    eyebrow:'আপনার এলাকার তথ্যভান্ডার',heroTitle:'রাজাপুরের প্রয়োজনীয় সব তথ্য,<br><em>এখন এক ঠিকানায়।</em>',heroText:'রাজাপুরের নির্ভরযোগ্য স্থানীয় তথ্য, প্রয়োজনীয় সেবা, প্রতিষ্ঠান ও গুরুত্বপূর্ণ স্থান সহজে খুঁজে নিন।',searchPlaceholder:'সেবা, চিকিৎসক, প্রতিষ্ঠান বা স্থান খুঁজুন...',searchHint:'খুঁজতে কমপক্ষে ২টি অক্ষর লিখুন।',searchLoading:'তথ্য খোঁজা হচ্ছে…',searchNoResults:'আপনার খোঁজের সঙ্গে মেলে এমন কোনো প্রকাশ্য তথ্য পাওয়া যায়নি।',searchError:'দুঃখিত, এই মুহূর্তে খোঁজ করা যাচ্ছে না। একটু পরে আবার চেষ্টা করুন।',searchKinds:{category:'বিভাগ',listing:'প্রতিষ্ঠানের তথ্য',doctor:'চিকিৎসক',service:'সেবা',transport:'পরিবহন',emergency:'জরুরি যোগাযোগ',place:'দর্শনীয় স্থান',information:'এলাকার তথ্য'},location:'রাজাপুর, ঝালকাঠি, বাংলাদেশ',
    directoryKicker:'বিভাগসমূহ',directoryTitle:'কী খুঁজছেন?',directoryText:'রাজাপুরের বিভিন্ন সেবা, প্রতিষ্ঠান ও প্রয়োজনীয় তথ্য দেখুন।',liveData:'হালনাগাদ তথ্য',loading:'বিভাগগুলোর তথ্য আনা হচ্ছে…',
    communityKicker:'সবার জন্য, রাজাপুরের উদ্যোগ',communityTitle:'তথ্য ও সেবায় আরও কাছাকাছি।',communityText:'এলাকার প্রয়োজনীয় তথ্য ও সেবা এক জায়গায় খুঁজে পাওয়ার সহজ মাধ্যম।',learnMore:'বিস্তারিত জানুন',
    footerAbout:'রাজাপুরের মানুষকে প্রয়োজনীয় স্থানীয় তথ্য ও সেবার সঙ্গে যুক্ত করার উদ্যোগ।',quickLinks:'প্রয়োজনীয় লিংক',contact:'যোগাযোগ',upazilaSite:'রাজাপুর উপজেলা পরিষদ',
    noResults:'আপনার অনুসন্ধানের সঙ্গে মেলে এমন ক্যাটাগরি নেই।',loadError:'এই মুহূর্তে ডিরেক্টরি লোড করা যাচ্ছে না। পরে আবার চেষ্টা করুন।',
    categoryDescriptions:{healthcare:'হাসপাতাল, ক্লিনিক, চিকিৎসক ও স্বাস্থ্যসেবা।',education:'স্কুল, কলেজ ও শিক্ষাপ্রতিষ্ঠান।','blood-donation':'রক্তদান ও রক্তদাতা সংক্রান্ত তথ্য।',transport:'বাস অপারেটর, রুট ও সময়সূচি।','places-heritage':'দর্শনীয় স্থান, ঐতিহ্য ও পর্যটন।','emergency-contacts':'জরুরি সেবার গুরুত্বপূর্ণ যোগাযোগ।','important-locations':'সরকারি অফিস ও প্রয়োজনীয় স্থান।','rajapur-information':'স্থানীয় পরিসংখ্যান ও এলাকার তথ্য।','local-services':'স্থানীয় ব্যবসা ও সেবাদাতা।'},
    categoryNames:{healthcare:'স্বাস্থ্যসেবা',education:'শিক্ষা','blood-donation':'রক্তদান',transport:'পরিবহন','places-heritage':'দর্শনীয় স্থান ও ঐতিহ্য','emergency-contacts':'জরুরি যোগাযোগ','important-locations':'গুরুত্বপূর্ণ স্থান','rajapur-information':'রাজাপুরের তথ্য','local-services':'স্থানীয় সেবা'}
  }
};
const categoryLinks = {
  healthcare:'category.html?slug=healthcare', education:'category.html?slug=education', 'blood-donation':'category.html?slug=blood-donation',
  transport:'category.html?slug=transport', 'places-heritage':'category.html?slug=places-heritage', 'emergency-contacts':'category.html?slug=emergency-contacts',
  'important-locations':'category.html?slug=important-locations', 'rajapur-information':'category.html?slug=rajapur-information', 'local-services':'category.html?slug=local-services'
};
const categoryIcons = {
  healthcare:'doctor-icon.png', education:'school.png', 'blood-donation':'blood.png',
  transport:'bus-icon.png', 'places-heritage':'tourism.png', 'emergency-contacts':'emergency-icon.png',
  'important-locations':'important.png', 'rajapur-information':'info.png', 'local-services':'logo.png'
};
let categories = [];
let language = localStorage.getItem('rasp-language') || 'en';

function applyTheme(value) {
  const resolved = value === 'system' ? (matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light') : value;
  document.documentElement.dataset.theme = resolved;
  document.documentElement.style.colorScheme = resolved;
  const meta = document.querySelector('meta[name="theme-color"]');
  if (meta) meta.content = resolved === 'dark' ? '#101522' : '#f7f8fc';
}
function applyLanguage() {
  const dict = translations[language];
  document.documentElement.lang = language;
  document.body.lang = language;
  document.querySelectorAll('[data-i18n]').forEach(el => {
    const value = dict[el.dataset.i18n];
    if (typeof value === 'string') el.innerHTML = value;
  });
  document.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
    const value = dict[el.dataset.i18nPlaceholder];
    if (value) el.placeholder = value;
  });
  const toggle = document.getElementById('languageToggle');
  toggle.textContent = language === 'en' ? 'বাংলা' : 'English';
  toggle.setAttribute('aria-label', language === 'en' ? 'Switch to Bangla' : 'Switch to English');
  renderCategories(document.getElementById('categorySearch').value);
}
function renderCategories(query = '') {
  const grid = document.getElementById('categoryGrid');
  const dict = translations[language];
  const term = query.trim().toLocaleLowerCase();
  const filtered = categories.filter(category => {
    const name = dict.categoryNames[category.slug] || category.name;
    const description = dict.categoryDescriptions[category.slug] || category.description || '';
    return [name, category.name, description, category.slug].some(value => String(value || '').toLocaleLowerCase().includes(term));
  });
  if (!filtered.length) {
    grid.innerHTML = '<div class="empty-state"></div>';
    grid.firstElementChild.textContent = dict.noResults;
    return;
  }
  grid.innerHTML = filtered.map(category => {
    const title = dict.categoryNames[category.slug] || category.name;
    const description = dict.categoryDescriptions[category.slug] || category.description || '';
    const href = categoryLinks[category.slug] || ('category.html?slug=' + encodeURIComponent(category.slug));
    const icon = category.icon_url || categoryIcons[category.slug];
    return '<a class="category-card" href="' + escapeAttribute(href) + '">' +
      '<span class="category-icon">' + (icon ? '<img src="' + escapeAttribute(icon) + '" alt="" loading="lazy">' : '<span aria-hidden="true">✦</span>') + '</span>' +
      '<span class="category-copy"><h3>' + escapeHtml(title) + '</h3><p>' + escapeHtml(description) + '</p></span><span class="category-arrow" aria-hidden="true">↗</span></a>';
  }).join('');
}
function escapeHtml(value) {
  return String(value ?? '').replace(/[&<>"']/g, char => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[char]));
}
function escapeAttribute(value) { return escapeHtml(value); }
async function loadCategories() {
  const grid = document.getElementById('categoryGrid');
  try {
    const { data, error } = await supabase.from('categories').select('id,name,slug,description,icon_url,sort_order').eq('is_active', true).order('sort_order', { ascending: true });
    if (error) throw error;
    categories = data || [];
    if (!categories.length) {
      grid.innerHTML = '<div class="empty-state"></div>';
      grid.firstElementChild.textContent = translations[language].noResults;
    } else {
      renderCategories(document.getElementById('categorySearch').value);
    }
  } catch (error) {
    console.error('Directory load failed:', error);
    grid.innerHTML = '<div class="error-state"></div>';
    grid.firstElementChild.textContent = translations[language].loadError;
  }
}

let searchRequestId = 0;
let searchDebounce = null;
function showSearchMessage(message, busy = false) {
  const panel = document.getElementById('globalSearchResults');
  panel.hidden = false;
  panel.innerHTML = '<div class="global-search-message">' + (busy ? '<span class="loader"></span>' : '') + escapeHtml(message) + '</div>';
  document.getElementById('categorySearch').setAttribute('aria-expanded', 'true');
}
function searchOr(columns, term) {
  const safe = term.replace(/[%,_()"\\]/g, ' ').replace(/\s+/g, ' ').trim();
  return columns.map(column => column + '.ilike.%' + safe + '%').join(',');
}
function searchTarget(slug, term) {
  return 'category.html?slug=' + encodeURIComponent(slug) + '&q=' + encodeURIComponent(term);
}
async function runGlobalSearch(rawTerm) {
  const term = rawTerm.trim();
  const panel = document.getElementById('globalSearchResults');
  const input = document.getElementById('categorySearch');
  const requestId = ++searchRequestId;
  if (term.length < 2) {
    panel.hidden = true;
    panel.innerHTML = '';
    input.setAttribute('aria-expanded', 'false');
    return;
  }
  showSearchMessage(translations[language].searchLoading, true);
  const pattern = searchOr(['name','description'], term);
  const jobs = [
    supabase.from('categories').select('name,slug,description').eq('is_active',true).or(pattern).limit(5).then(r => ({kind:'category',slug:null,rows:r.data||[],error:r.error})),
    supabase.from('listings').select('title,summary,address,category_id,categories(slug)').eq('status','published').or(searchOr(['title','summary','description','address','union_name'],term)).limit(8).then(r => ({kind:'listing',slug:'local-services',rows:r.data||[],error:r.error})),
    supabase.from('doctors').select('full_name,specialty,qualifications,bio').eq('is_active',true).or(searchOr(['full_name','specialty','qualifications','bio'],term)).limit(5).then(r => ({kind:'doctor',slug:'healthcare',rows:r.data||[],error:r.error})),
    supabase.from('services').select('title,description,service_area').eq('status','published').or(searchOr(['title','description','service_area'],term)).limit(5).then(r => ({kind:'service',slug:'local-services',rows:r.data||[],error:r.error})),
    supabase.from('educational_institutions').select('name,institution_type,address').or('is_public.eq.true,is_active.eq.true').or(searchOr(['name','institution_type','address'],term)).limit(5).then(r => ({kind:'education',slug:'education',rows:r.data||[],error:r.error})),
    supabase.from('transport_operators').select('name,description').eq('is_active',true).or(searchOr(['name','description'],term)).limit(4).then(r => ({kind:'transport',slug:'transport',rows:r.data||[],error:r.error})),
    supabase.from('emergency_contacts').select('title,organization_name,description,address').eq('is_active',true).or(searchOr(['title','organization_name','description','address'],term)).limit(4).then(r => ({kind:'emergency',slug:'emergency-contacts',rows:r.data||[],error:r.error})),
    supabase.from('places').select('name,description,address,place_type').eq('is_active',true).or(searchOr(['name','description','historical_details','address','place_type'],term)).limit(5).then(r => ({kind:'place',slug:'places-heritage',rows:r.data||[],error:r.error})),
    supabase.from('area_statistics').select('topic,metric_label,notes').or(searchOr(['topic','metric_label','notes'],term)).limit(4).then(r => ({kind:'information',slug:'rajapur-information',rows:r.data||[],error:r.error}))
  ];
  try {
    const results = await Promise.all(jobs);
    if (requestId !== searchRequestId) return;
    const errors = results.filter(result => result.error);
    const items = [];
    for (const group of results) {
      for (const row of group.rows) {
        let title = row.title || row.name || row.full_name || row.metric_label || row.route_name || '';
        let detail = row.summary || row.specialty || row.description || row.address || row.destination || row.topic || row.organization_name || '';
        const slug = group.kind === 'category' ? row.slug : (group.kind === 'listing' ? row.categories?.slug || group.slug : group.slug);
        if (group.kind === 'category') detail = row.description || '';
        items.push({title,detail,kind:group.kind,slug});
      }
    }
    const unique = [...new Map(items.map(item => [item.kind+'|'+item.title+'|'+item.slug,item])).values()].slice(0,12);
    if (!unique.length) {
      showSearchMessage(errors.length === jobs.length ? translations[language].searchError : translations[language].searchNoResults);
      return;
    }
    const dict = translations[language];
    panel.innerHTML = unique.map(item => '<a class="global-search-result" role="option" href="'+escapeHtml(searchTarget(item.slug,term))+'"><span class="global-search-result-copy"><strong>'+escapeHtml(item.title)+'</strong><small>'+escapeHtml(item.detail)+'</small></span><span class="global-search-kind">'+escapeHtml(dict.searchKinds[item.kind])+'</span></a>').join('');
    panel.hidden = false;
    document.getElementById('categorySearch').setAttribute('aria-expanded','true');
  } catch (error) {
    console.error('Global search failed:',error);
    if (requestId === searchRequestId) showSearchMessage(translations[language].searchError);
  }
}
function handleGlobalSearch(value) {
  clearTimeout(searchDebounce);
  const panel = document.getElementById('globalSearchResults');
  if (value.trim().length < 2) { panel.hidden = true; document.getElementById('categorySearch').setAttribute('aria-expanded','false'); return; }
  searchDebounce = setTimeout(() => runGlobalSearch(value), 280);
}

function setupControls() {
  const themeSelect = document.getElementById('themeSelect');
  const savedTheme = localStorage.getItem('rasp-theme') || 'system';
  themeSelect.value = savedTheme;
  applyTheme(savedTheme);
  themeSelect.addEventListener('change', () => {
    localStorage.setItem('rasp-theme', themeSelect.value);
    applyTheme(themeSelect.value);
  });
  document.getElementById('languageToggle').addEventListener('click', () => {
    language = language === 'en' ? 'bn' : 'en';
    localStorage.setItem('rasp-language', language);
    applyLanguage();
  });
  document.getElementById('categorySearch').addEventListener('input', event => handleGlobalSearch(event.target.value));
  document.addEventListener('click', event => { if (!event.target.closest('.global-search-wrap')) { document.getElementById('globalSearchResults').hidden = true; document.getElementById('categorySearch').setAttribute('aria-expanded','false'); } });
  document.getElementById('categorySearch').addEventListener('keydown', event => {
    const panel = document.getElementById('globalSearchResults');
    if (event.key === 'Escape') { panel.hidden = true; event.target.setAttribute('aria-expanded','false'); }
    if (event.key === 'Enter' && !panel.hidden) { const first = panel.querySelector('a.global-search-result'); if (first) { event.preventDefault(); first.click(); } }
  });
  const menuToggle = document.getElementById('menuToggle');
  const mobileNav = document.getElementById('mobileNav');
  menuToggle.addEventListener('click', () => {
    const expanded = menuToggle.getAttribute('aria-expanded') === 'true';
    menuToggle.setAttribute('aria-expanded', String(!expanded));
    mobileNav.hidden = expanded;
  });
  mobileNav.querySelectorAll('a').forEach(link => link.addEventListener('click', () => {
    mobileNav.hidden = true;
    menuToggle.setAttribute('aria-expanded', 'false');
  }));
  document.getElementById('currentYear').textContent = new Date().getFullYear();
  document.addEventListener('keydown', event => {
    if ((event.metaKey || event.ctrlKey) && event.key.toLowerCase() === 'k') {
      event.preventDefault();
      document.getElementById('categorySearch').focus();
    }
  });
  matchMedia('(prefers-color-scheme: dark)').addEventListener?.('change', () => {
    if ((localStorage.getItem('rasp-theme') || 'system') === 'system') applyTheme('system');
  });
}
setupControls();
applyLanguage();
loadCategories();
