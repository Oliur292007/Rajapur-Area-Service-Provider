# Frontend Content and Hosting Inventory

Date: 2026-11-26
Repository: `Oliur292007/Rajapur-Area-Service-Provider`
Production URL supplied by project owner: https://rasp-rpst.vercel.app/
Target branch: `main` only

## 1. Hosting and build configuration

The repository root is currently a static HTML site. The inspected `main` tree contains no `package.json`, lockfile, Vite/Next configuration, `vercel.json`, `.vercel/project.json`, or Netlify configuration. The existing public URL is confirmed by the project owner; it must remain the production destination.

The connected Vercel team context was inspected for:
- Git repository `Oliur292007/Rajapur-Area-Service-Provider`
- project names containing `rasp`
- project names containing `rajapur`

No matching project was returned by that connected team context. This is an access/scope limitation, not evidence that the production site or Vercel project does not exist. Do not create a replacement Vercel project. Before changing build settings or deployment linkage, identify the existing `rasp-rpst` project in the correct Vercel team/account.

## 2. Existing root-level assets

The current repository stores page assets beside the HTML files rather than in a dedicated asset directory. Confirmed assets include:

- Brand/social: `logo.png`, `facebook-icon.png`, `youtube-icon.png`, `flaticon-logo.png`, `R.png`, `wikipedia.png`
- Healthcare: `doctor-icon.png`, `doctors.png`, `hospital.png`, `sohag.png`, `popular.png`, `health.png`
- Education: `school.png`, `education.png`, `primary.png`, `secondary.png`, `high-school.png`, `collage.png`
- Transport: `bus-icon.png`, `eagle-icon.png`, `hanif-icon.png`, `labiba-icon.png`, `palki-icon.png`, `sakura-icon.png`, `shyamoli.png`, and operator photos such as `evan.jpg`, `emad.jpg`, `comfort.jpg`, `mizan.jpg`, `islam.jpg`, `bex.jpg`, `bolesswar.jpg`, `jamuna.png`, `sheba.jpg`
- Places/heritage: `tourism.png`, `heritage.png`, `bishkhali.png`, `bishkhali(1).png`, `bishkhali(2).png`, `bishkhali(3).png`, `mosque.png`, `galua-mosque.jpg`, `satuira.jpg`, `peyara-bagan.png`
- Area information: `info.png`, `agriculture.png`, `Communication.png`, `Cooperative.png`, `Family-planning.png`, `Fisheries.png`, `land-and-revenue.png`, `livestock.png`, `Weaving.png`, `Pan.png`

Preserve original file names and case during migration. Several names contain uppercase letters, spaces or parentheses; paths must remain case-sensitive and URL-encoded where needed.

## 3. Frontend entry points

| File | Current role | Finding |
|---|---|---|
| `index.html` | Homepage | Static category cards, RPST footer/contact and partner links |
| `main.css` | Shared styling | Legacy styles, duplicated rules and mixed light/dark styling |
| `main.js` | Shared JavaScript | Sidebar open/close only; no backend, search, auth or form logic |
| `theme.css` | Theme stylesheet | Empty file |
| `navbar.html` | Potential shared navigation | Empty file |

Most pages duplicate the same header, sidebar and footer. The shared navigation currently contains links to the legacy pages.

## 4. Content and route integrity findings

- The repository has 38 populated HTML pages plus the empty `navbar.html`; all source pages have already been archived in Supabase staging.
- The source includes distinct directory areas: healthcare, education, blood donation, transport, places/heritage, emergency contacts, important locations, and Rajapur information.
- The bus directory page links to operator pages/assets including Emad, Comfort, Mizan, Islam, Barishal Express, Bolesswar, Jamuna and Sheba. Some linked operator HTML pages are not present in the current repository tree even though image assets exist. These are content gaps to resolve from the archived source/data review; do not create fabricated schedules.
- Some legacy pages have incorrect generic document titles (e.g. healthcare and blood pages titled “Bus Schedules”).
- Existing map embeds, phone links, contact details and third-party information require verification before re-publication.
- Legacy donor records are sensitive and must not be copied into public UI. Only active donors with current explicit public-contact consent may appear publicly.

## 5. Supabase integration constraints

The dedicated Supabase project is already provisioned and has RLS-enabled directory, marketplace, account, and moderation tables. The browser must use only the public publishable/anon key. Service-role/secret credentials must never be added to HTML, browser JavaScript, public repository configuration, or any `NEXT_PUBLIC_*` variable.

No frontend Supabase client or public runtime configuration was found in the existing source. Before live data is rendered, add a documented public-client configuration path and verify every queried table's SELECT grant and RLS policy. Private workflows must remain server-side or in authenticated Edge Functions.

## 6. Implementation decision

Because the production project's current Vercel build settings and Git linkage are not visible in the connected Vercel scope, do not introduce a build-tool dependency or change Vercel build settings yet. The safest first implementation increment is a static-host-compatible shared frontend foundation. If the existing Vercel project is later confirmed to support a build step, a pinned build tool can be introduced in a separately verified deployment change.

The redesign must preserve all existing source pages/assets while progressively replacing duplicated markup with shared navigation, footer, translations, theme preferences and Supabase-backed page data.

## 7. Next implementation steps

1. Confirm the existing `rasp-rpst` Vercel project's actual team, Git repository connection and build/output settings without creating a new project.
2. Implement the shared responsive design system and application shell in a way compatible with the current static deployment.
3. Add persistent Bangla/English and light/dark/system settings.
4. Add a public Supabase client configuration using only the publishable key; keep secrets server-side.
5. Map every legacy page to its Supabase domain and migrate only reviewed/verified content.
6. Implement functional search, filters, directory details, authentication and admin review operations.
7. Verify the current production deployment before and after each deployment-sensitive change.
