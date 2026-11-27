(() => {
  const routes = {
    'blood.html': ['blood-donation', ''],
    'buses.html': ['transport', ''],
    'sakura.html': ['transport', 'Sakura'],
    'Shyamoli.html': ['transport', 'Shyamoli'],
    'eagle.html': ['transport', 'Eagle'],
    'evan.html': ['transport', 'Evan'],
    'hanif.html': ['transport', 'Hanif'],
    'labiba.html': ['transport', 'Labiba'],
    'palki.html': ['transport', 'Palki'],
    'emergency.html': ['emergency-contacts', ''],
    'important-locations.html': ['important-locations', ''],
    'places.html': ['places-heritage', ''],
    'rajapur-haritage.html': ['places-heritage', 'heritage'],
    'bishkhali.html': ['places-heritage', 'Bishkhali'],
    'satuira.html': ['places-heritage', 'Satuira'],
    'mosque.html': ['places-heritage', 'mosque'],
    'galua-mosque.html': ['places-heritage', 'Galua Mosque'],
    'high-schools.html': ['education', 'high school'],
    'primary-schools.html': ['education', 'primary school'],
    'secondary-schools.html': ['education', 'secondary school'],
    'collages.html': ['education', 'college'],
    'school-catagory.html': ['education', 'school'],
    'edu-info.html': ['education', ''],
    'doctors-clinic.html': ['healthcare', ''],
    'hospitals.html': ['healthcare', 'hospital'],
    'popular-clinic.html': ['healthcare', 'Popular Clinic'],
    'sohag-hispital.html': ['healthcare', 'Sohag'],
    'agricultural-info.html': ['rajapur-information', 'agriculture'],
    'fisheries.html': ['rajapur-information', 'fisheries'],
    'livestock.html': ['rajapur-information', 'livestock'],
    'family-planning.html': ['rajapur-information', 'family planning'],
    'health-releted.html': ['rajapur-information', 'health'],
    'land-and-revenue-related.html': ['rajapur-information', 'land revenue'],
    'cooperative.html': ['rajapur-information', 'cooperative'],
    'general-info.html': ['rajapur-information', ''],
    'about.html': ['rajapur-information', ''],
    'communication.html': ['important-locations', '']
  };
  const file = location.pathname.split('/').pop();
  const target = routes[file];
  const status = document.querySelector('[data-legacy-status]');
  const link = document.querySelector('[data-legacy-link]');
  if (!target) {
    if (status) status.textContent = 'The requested page could not be mapped to a current directory.';
    return;
  }
  const url = new URL('category.html', location.href);
  url.searchParams.set('slug', target[0]);
  if (target[1]) url.searchParams.set('q', target[1]);
  if (link) link.href = url.href;
  if (status) status.textContent = 'Opening the updated directory…';
  location.replace(url.href);
})();