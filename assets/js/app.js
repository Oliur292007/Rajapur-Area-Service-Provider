import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const SUPABASE_URL = 'https://kapuhxccffmjgeszixxh.supabase.co';
const SUPABASE_PUBLISHABLE_KEY = 'sb_publishable_pr-6-lthGkKlq8RNoxwmqg_X4pqblAV';
const supabase = createClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY);

const translations = {
  en: {
    skip:'Skip to content',navHome:'Home',navAbout:'About',navEmergency:'Emergency',themeLabel:'Theme',themeSystem:'System',themeLight:'Light',themeDark:'Dark',menu:'Menu',
    eyebrow:'YOUR LOCAL DIRECTORY',heroTitle:'Everything in Rajapur,<br><em>all in one place.</em>',heroText:'Discover trusted local information, essential services and useful places around your community.',searchPlaceholder:'Search services and categories...',location:'Rajapur, Jhalakathi, Bangladesh',
    directoryKicker:'EXPLORE THE DIRECTORY',directoryTitle:'What are you looking for?',directoryText:'Browse services and information available in Rajapur.',liveData:'Live directory',loading:'Loading categories…',
    communityKicker:'BUILT FOR THE COMMUNITY',communityTitle:'A more connected Rajapur.',communityText:'A shared place to discover local knowledge and essential services.',learnMore:'Learn more',
    footerAbout:'Connecting people with the information and services that matter locally.',quickLinks:'Quick links',contact:'Contact',upazilaSite:'Rajapur Upazila',
    noResults:'No categories match your search.',loadError:'Could not load the directory right now. Please try again later.',
    categoryDescriptions:{healthcare:'Hospitals, clinics, doctors and health services.',education:'Schools, colleges and educational institutions.', 'blood-donation':'Blood donation and donor information.',transport:'Bus operators, routes and schedules.','places-heritage':'Tourism, historical places and local heritage.','emergency-contacts':'Important emergency service contacts.','important-locations':'Public offices and essential locations.','rajapur-information':'Local statistics and area information.','local-services':'Local businesses and service providers.'},
    categoryNames:{healthcare:'Healthcare',education:'Education','blood-donation':'Blood Donation',transport:'Transport','places-heritage':'Places & Heritage','emergency-contacts':'Emergency Contacts','important-locations':'Important Locations','rajapur-information':'Rajapur Information','local-services':'Local Services'}
  },
  bn: {
    skip:'মূল কনটেন্টে যান',navHome:'হোম',navAbout:'আমাদের সম্পর্কে',navEmergency:'জরুরি সেবা',themeLabel:'থিম',themeSystem:'সিস্টেম',themeLight:'লাইট',themeDark:'ডার্ক',menu:'মেনু',
    eyebrow:'আপনার স্থানীয় ডিরেক্টরি',heroTitle:'রাজাপুরের প্রয়োজনীয় সবকিছু,<br><em>এক জায়গাতেই।</em>',heroText:'আপনার এলাকার নির্ভরযোগ্য তথ্য, প্রয়োজনীয় সেবা ও গুরুত্বপূর্ণ স্থান খুঁজে নিন সহজেই।',searchPlaceholder:'সেবা ও ক্যাটাগরি খুঁজুন...',location:'রাজাপুর, ঝালকাঠি, বাংলাদেশ',
    directoryKicker:'ডিরেক্টরি ঘুরে দেখুন',directoryTitle:'আপনি কী খুঁজছেন?',directoryText:'রাজাপুরের বিভিন্ন সেবা ও তথ্য দেখুন।',liveData:'লাইভ ডিরেক্টরি',loading:'ক্যাটাগরি লোড হচ্ছে…',
    communityKicker:'কমিউনিটির জন্য তৈরি',communityTitle:'আরও সংযুক্ত হোক রাজাপুর।',communityText:'স্থানীয় জ্ঞান ও প্রয়োজনীয় সেবা খুঁজে পাওয়ার একটি সম্মিলিত জায়গা।',learnMore:'আরও জানুন',
    footerAbout:'স্থানীয় প্রয়োজনীয় তথ্য ও সেবার সঙ্গে মানুষকে যুক্ত করার একটি উদ্যোগ।',quickLinks:'দ্রুত লিংক',contact:'যোগাযোগ',upazilaSite:'রাজাপুর উপজেলা',
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
  document.getElementById('categorySearch').addEventListener('input', event => renderCategories(event.target.value));
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
