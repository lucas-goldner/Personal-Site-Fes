# Plan: Rebuild lucas-goldner.com in Jaspr

Goal: recreate the current Gatsby site 1:1 (same layout, colours, typography, animations and
behaviour) as a **statically generated Jaspr site**, and drop Gatsby, React, Node and Yarn
entirely. Work happens on the branch `claude/personal-website-jaspr-frd85l` so every push gets
a preview deployment.

Target stack (verified against pub.dev on 2026-09-18):

| Piece | Choice |
|---|---|
| Framework | `jaspr` 0.23.4, `jaspr_cli` 0.23.4, `jaspr_router` (multi-page) |
| Rendering mode | `static` with `@client` islands for interactivity |
| Language / SDK | Dart stable (3.x), no Flutter |
| Styling | Existing SCSS compiled once to plain CSS and served from `web/` (pixel parity), plus `@css` only for new bits |
| Hosting | Whatever currently serves the site (see §7), build output `build/jaspr` |

---

## 1. Inventory of the current site

### Pages
| Route | Gatsby file | Notes |
|---|---|---|
| `/` | `src/pages/index.js` | Layout > Hero, About, Services, Portfolio, Contact + Spinner overlay |
| `/tos` | `src/pages/tos.js` | Impressum + privacy text, plain white page (`#scrollAllow`) |
| `/privacy` | `src/pages/privacy.js` | App privacy policy, plain white page |
| `/404` | `src/pages/404.js` | Grey box, "404", link home |

### Sections (all full-viewport on desktop, `height: auto` under 992px)
| Section | Layout | Interactive bits |
|---|---|---|
| Hero | 2 cols: dark-grey text panel (`#2c343f`) / photo `person2x.png` bottom-right | Glitch heading, Typewriter (3 strings, loop), "Download CV" hover-button, 10 floating hobby icons with random up/down bobbing |
| About | 2 cols: text + social icons on black with particles / skills panel on `#2c343f` | Particle network (50 particles, linked lines), 6 skill progress bars animated on viewport entry |
| Services | Top 80%: 6 service cards (3 per row, middle card has side borders); bottom 20% `#2c343f` strip with 3 counters | Baffle text "What I Do", staggered `animate.css` fade-ins, count-up numbers (4 Years, 21 Projects, 749836 Lines) |
| Portfolio | 2/10 split: rotated "PORTFOLIO" side strip / category filter + image grid (4 cols) | Baffle text, All/App/Website filter, fade-in, tilt hover with orange overlay + title link |
| Contact | 2/5/5 split: rotated "CONTACT" strip / form / Google Maps iframe | Baffle text, EmailJS form with validation (red underline + red button corners), map fade-in |

### Global behaviour (`components/layout`)
- Desktop (≥1025px): body scroll locked, mouse wheel snaps one section at a time with a 2s
  `in-out-expo` scroll, nav buttons scroll to section ids.
- <1025px: scroll unlocked; <992px: sections become `height: auto`, stacked columns.
- Any width change reloads the page (`window.location.reload()` in resize handler).
- Orange (`#ffb035`) loading spinner overlay for 1s, then removed and `no-overflow` cleared.
- Off-canvas nav (25% width, 100% under 500px) with logo, 5 links, orange underline on hover.

### Design tokens
- Colours: black `#000`, panel grey `#2c343f`, orange `#ffb035`, text `#fff` / `#eee`, glitch shadows `#ff00c1` / `#00fff9`, error `red`.
- Font: Poppins 300/400/700/800/900 from Google Fonts, `display=swap`; hover-button uses Verdana.
- Grid: Bootstrap 3.3.7 (`row`, `col-md-*`, `container`, `form-group`).

### Assets to carry over (already tracked, no processing needed)
`public/person2x.png`, `public/heroIcons/*.png` (10), `public/projectImg/*` (11),
`public/img/LucasLogo.png`, `public/img/favicon.ico`, `public/img/*-brands.svg`, `static/robots.txt`.
`content/images/icons/*` appears unused and will not be copied.

### Third-party JS to replace
| Current package | Used for | Jaspr replacement |
|---|---|---|
| `react-bootstrap` + `bootstrap` 3.3.7 CSS | grid | Keep `bootstrap.min.css` vendored (exact same CSS), plain `div(classes: 'row')` |
| `typewriter-effect` | hero subtitle | Small Dart `Timer` state machine, same class names (`Typewriter`, `Typewriter__cursor`) |
| `baffle-react` | scramble-reveal headings | Dart port (~40 lines): random chars from the same charset, 50ms tick, reveal after delay |
| `react-countup` | counters | Dart `Timer`/`requestAnimationFrame` easing to target over duration |
| `react-in-viewport` | trigger animations once | `IntersectionObserver` via `package:web`, wrapped in one `InViewport` island helper |
| `animate.css` | fadeIn/fadeInUp/Left/Right/Down + `fast` | Vendor only the used keyframes/classes into `animate.css` |
| `react-particles-js` | about background | Load `tsparticles-slim` (or the original `particles.js`) from `web/js/` and init via `dart:js_interop` with the identical config |
| `react-tilt` | portfolio hover | `vanilla-tilt.js` from `web/js/` initialised via JS interop, `max: 50, scale: 1` |
| `scroll-to-element` | smooth section scroll | Dart easing loop (`in-out-expo`, 2000ms) driving `window.scrollTo` |
| `react-scrolllock` | desktop scroll lock | Toggle `overflow: hidden` on `body` |
| `@fortawesome/*` | icons | Inline SVG paths as Dart constants (site already inlines Apple/Android) |
| `emailjs-com` | contact form | `POST https://api.emailjs.com/api/v1.0/email/send` with `package:http`, keys injected via `--dart-define` |
| `react-helmet` | meta tags | `Document(title:, meta:, head:)` in `main.server.dart` |
| `gatsby-plugin-offline`, `nprogress`, `preact`, `sharp`, remark plugins | Gatsby plumbing | Dropped, nothing to replace |

---

## 2. Target project structure

The Jaspr project lives at the repo root and replaces the Gatsby files (Gatsby is deleted in
Phase 6, not before, so the old site stays diffable during the port).

```
pubspec.yaml                     jaspr: { mode: static }
lib/
  main.server.dart               Document(head/meta/links) + App with Router
  main.client.dart               Jaspr.initializeApp + runApp(ClientApp())
  app.dart                       Router with routes /, /tos, /privacy, 404
  data/
    meta.dart                    title/description/keywords/author
    hero.dart                    hero icon list + image path
    portfolio.dart               11 portfolio items (title, category, link, image)
    services.dart                6 services + 3 counters
    skills.dart                  6 skills (name, value 1-5, label)
  pages/
    home_page.dart               composes the 5 sections + Spinner
    tos_page.dart, privacy_page.dart, not_found_page.dart
  layout/
    layout.dart                  @client: wheel snapping, scroll lock, resize reload, height context
    navigation.dart              @client: off-canvas menu
    spinner.dart                 @client: 1s overlay then remove
  sections/
    hero.dart, about.dart, services.dart, portfolio.dart, contact.dart
  components/
    glitch.dart, typewriter.dart, baffle_text.dart, counter.dart, progress.dart,
    animation_container.dart, in_viewport.dart, hover_button.dart, line_text.dart,
    icons.dart (SVG constants)
  interop/
    particles.dart, tilt.dart, scroll.dart, email.dart
web/
  index.html?                    not needed in static mode (Document is the shell)
  styles/
    bootstrap.min.css            vendored 3.3.7
    animate.css                  trimmed
    site.css                     compiled from the current SCSS
  js/ tsparticles.slim.min.js, vanilla-tilt.min.js
  img/, heroIcons/, projectImg/, person2x.png, robots.txt, favicon.ico   (moved from public/)
```

Key Jaspr facts driving this layout:
- `jaspr build` writes the static site to `build/jaspr/`; `jaspr_router` pre-renders every
  declared route to `index.html`, `tos/index.html`, `privacy/index.html`.
- Any component that needs browser state or events is marked `@client`. Its constructor
  parameters must be serialisable (primitives, lists, maps), so islands receive plain data
  from `lib/data/*`, not callbacks.
- DOM access goes through `GlobalNodeKey<web.HTMLElement>` and `package:universal_web`
  (guarded by `kIsWeb`) so the same file compiles on the server during static generation.
- Build-time secrets: `jaspr build --dart-define=EMAILJS_SERVICE_ID=... --dart-define=EMAILJS_TEMPLATE_ID=... --dart-define=EMAILJS_USER_ID=...`, read with `String.fromEnvironment`.

---

## 3. Styling strategy (why not rewrite every rule in Dart)

"Exact same style" is cheapest to guarantee by keeping the CSS the browser already receives:

1. Run `sass` once over the existing `.scss` files (globals + navigation, spinner, glitch,
   progress, hero, about, services, portfolio, contact) into `web/styles/site.css`. The glitch
   keyframes use Sass `random()` at compile time, so a one-off compile reproduces the exact
   current behaviour.
2. Replace `#___gatsby { overflow-x: hidden }` with the same rule on the Jaspr root element.
3. Keep Bootstrap 3.3.7 minified CSS and a trimmed `animate.css` as vendored files.
4. Link the three stylesheets and the Poppins Google Fonts URL in `Document(head: [...])`.
5. Use Jaspr `@css` / `Styles` only for the few inline styles React computed at runtime
   (section `height`, portfolio item `width`/`maxHeight`, float-icon `left`/`bottom`).

Later, once parity is confirmed by screenshots, individual files can be migrated to `@css`
incrementally if desired. That is optional and not part of this plan's definition of done.

---

## 4. Component-by-component port

| Gatsby component | Dart file | Island? | Implementation notes |
|---|---|---|---|
| `html.js` | `main.server.dart` | no | `Document(lang: 'en', title, meta viewport/author/description/keywords, favicon link, stylesheets, fonts)`; `body` class `no-overflow` |
| `layout/index.js` | `layout/layout.dart` | yes | Holds `height`, `mobile`, `scrolllock`; wheel handler with `scrolling` guard; sections list; provides height to sections via an `InheritedComponent` (same role as `ThemeContext`). Resize → reload only when width changed |
| `navigation/index.js` | `layout/navigation.dart` | yes | `show` state, bars/times SVG icons, logo `img/LucasLogo.png`, 5 buttons calling shared `scrollToSection(id)` and reporting index back via a callback registered on a small `ScrollController` singleton (islands cannot take function props) |
| `spinner/index.js` | `layout/spinner.dart` | yes | `Timer(1s)` → remove `show`, remove `no-overflow` from body, `Timer(500ms)` → remove node |
| `glitch/index.js` | `components/glitch.dart` | no | Pure markup `div.glitch[data-text]` |
| `typewriter-effect` | `components/typewriter.dart` | yes | Type/delete with 75ms/50ms cadence, 1.5s pause, loop; renders `span.Typewriter__wrapper` + `span.Typewriter__cursor` "\|" |
| `baffle-text/index.js` | `components/baffle_text.dart` | yes | Scramble until in viewport, then reveal over `revealDuration` after `revealDelay`; optional `onRevealed` used by Services/Portfolio/Contact to show their content after 1100ms |
| `counter/index.js` | `components/counter.dart` | yes | Start when visible; 60fps interpolation over `duration` seconds; icon SVG, `.value span`, `.symbol` |
| `progress/index.js` | `components/progress.dart` | yes | Width `value*20%` after `delay` ms, once visible, 2s CSS transition |
| `animation-container` | `components/animation_container.dart` | yes | Opacity 0 until visible, then after `delay` add `animated <animation>` classes; optional fixed `height` |
| `react-in-viewport` | `components/in_viewport.dart` | yes | One `IntersectionObserver` helper used by the four above |
| `sections/hero` | `sections/hero.dart` | partly | Static markup; Typewriter island; floating icons get their random `bottom` and up/down class chosen once at build time (React chose them per render, visually indistinguishable) |
| `sections/about` | `sections/about.dart` | partly | Particles island (`interop/particles.dart`), Progress islands, social icon buttons open the 5 short links |
| `sections/services` | `sections/services.dart` | partly | Content hidden until Baffle reveal on desktop, always shown when `height == auto`; six cards with side-border rule on the 2nd and 5th |
| `sections/portfolio` | `sections/portfolio.dart` | yes | Category state, column count rule (>6→4, >4→3, >3→2, >1→2, else 1), item `maxHeight = height * (col>=3 ? 0.35 : count==4 ? 0.36 : 1)`, tilt via `interop/tilt.dart` |
| `sections/contact` | `sections/contact.dart` | yes | Form state, `check()` error logic, `hover-button.error`, "Email sent!" message, EmailJS POST; Maps iframe with the same embed URL |
| `pages/tos.js`, `privacy.js` | `pages/*.dart` | no | Copy text verbatim; keep `id="scrollAllow"` white page |
| `pages/404.js` | `pages/not_found_page.dart` | no | `div.bg > div.error-404`; wired as Router's fallback |

---

## 5. Phases and checkpoints

Each phase ends with a push, so the preview URL always reflects the latest state.

### Phase 0: Scaffold + preview pipeline (½ day)
1. `dart pub global activate jaspr_cli` and `jaspr create . --mode static --routing multi-page --flutter none` (or scaffold in a temp dir and move files in).
2. Move `public/{img,heroIcons,projectImg,person2x.png,robots.txt}` to `web/`.
3. Add hosting config for branch previews (§7) and a `.github/workflows/build.yml` that runs `jaspr build` on every push as a smoke test.
4. Push. Checkpoint: preview URL shows the Jaspr hello page.

### Phase 1: Static shell with exact styling (1 day)
1. Compile SCSS → `web/styles/site.css`, vendor Bootstrap + trimmed animate.css, wire fonts and meta in `Document`.
2. Port `lib/data/*` from `data/*.json` and the hard-coded texts in the sections.
3. Build all five sections and the nav as **non-interactive** markup with identical class names and DOM nesting.
4. Add `/tos`, `/privacy`, 404.
5. Checkpoint: screenshots at 1440px, 1024px and 375px match the Gatsby site with animations disabled (`prefers-reduced-motion` or JS off).

### Phase 2: Islands (2 days)
1. Spinner, Navigation, Typewriter, BaffleText, Counter, Progress, AnimationContainer, InViewport.
2. Portfolio filter + tilt, Contact form + EmailJS, Particles.
3. Checkpoint: every animation/timing listed in §1 reproduced; EmailJS send verified with a test template.

### Phase 3: Scroll behaviour (½ day)
1. Wheel snapping, `in-out-expo` 2s scroll, scroll lock ≥1025px, nav-driven section index, reload-on-width-change.
2. Checkpoint: manual test on desktop, iPad width and phone width.

### Phase 4: SEO and extras (½ day)
1. Titles/meta per page, `robots.txt`, favicon, `jaspr build --sitemap-domain https://lucas-goldner.com`.
2. Lighthouse run; target ≥ Gatsby's scores on Performance/Accessibility/SEO.

### Phase 5: Visual QA (½ day)
1. Playwright script (Chromium is available in CI) that captures both sites at the three
   widths and diffs them; fix any drift.

### Phase 6: Remove Gatsby (½ day)
1. Delete `gatsby-*.js`, `package.json`, `yarn.lock`, `src/`, `data/`, `content/`, `static/`, `public/`, `.cache/`.
2. Update `.gitignore` for Dart (`.dart_tool/`, `build/`, `*.options.dart` if generated) and rewrite the README with Dart setup and build steps.
3. Open the PR to `main`.

Total: roughly 5 to 6 working days of focused work.

---

## 6. Behaviour details worth preserving exactly

- Section ids `home`, `about`, `services`, `portfolio`, `contact`; nav labels Home/About/Services/Portfolio/Contact.
- Wheel handler never wraps: cannot go up from Home or down from Contact.
- Services/Portfolio/Contact content is hidden on desktop until the Baffle text finishes (1100ms after entering the viewport) and always visible on mobile.
- Hero float icons: `left = index*10%`, even index bottom in 70–80%, odd in 10–20%, 50px wide (10px on mobile).
- Portfolio categories are derived from the items in insertion order: All, App, Website.
- Contact validation: Name, Email and Message required; Phone optional; on error inputs get `.error` and the button gets `.error` (red corners).
- Download CV opens the existing Google Drive link in a new tab.
- Social links: github/linkedin/youtube/twitter/stackoverflow `.lucas-goldner.com` subdomains.
- Spinner: 1000ms show, 500ms fade, then node removed.

---

## 7. Preview deployments on the branch

The repo ships `gatsby-plugin-netlify` but the `.gitignore` also lists `.vercel`, so the host
is not certain from the code. Both hosts build previews for every non-production branch once
the project is connected; the only Jaspr-specific need is installing Dart in the build image.

**Vercel** (`vercel.json`):
```json
{
  "installCommand": "curl -fsSL https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-x64-release.zip -o /tmp/dart.zip && unzip -q /tmp/dart.zip -d /tmp && /tmp/dart-sdk/bin/dart pub global activate jaspr_cli",
  "buildCommand": "export PATH=/tmp/dart-sdk/bin:$HOME/.pub-cache/bin:$PATH && jaspr build --sitemap-domain https://lucas-goldner.com",
  "outputDirectory": "build/jaspr",
  "framework": null
}
```
Set `EMAILJS_*` as environment variables and pass them with `--dart-define` in the build command.

**Netlify** (`netlify.toml`):
```toml
[build]
  command = "curl -fsSL https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-x64-release.zip -o /tmp/dart.zip && unzip -q /tmp/dart.zip -d /tmp && export PATH=/tmp/dart-sdk/bin:$HOME/.pub-cache/bin:$PATH && dart pub global activate jaspr_cli && jaspr build"
  publish = "build/jaspr"
```
Netlify Deploy Previews / branch deploys need to be enabled for the branch in site settings.

**GitHub Actions fallback** (works regardless of host, also used as the CI smoke test):
```yaml
- uses: dart-lang/setup-dart@v1
- run: dart pub global activate jaspr_cli
- run: jaspr build --verbose
- uses: actions/upload-artifact@v4
  with: { name: site, path: build/jaspr }
```
If the site should be previewed from Actions directly, add a `peaceiris/actions-gh-pages`
step publishing `build/jaspr` to a `gh-pages` branch for this feature branch only.

---

## 8. Risks and open questions

| Risk | Mitigation |
|---|---|
| Particle background not pixel-identical | Use the same `particles.js` config (50 particles, linked lines opacity 0.5, size 1, retina); accept minor randomness as the original is random too |
| EmailJS keys currently live in Gatsby env vars on the host | Copy them to the new host as `EMAILJS_SERVICE_ID/TEMPLATE_ID/USER_ID`; they are public-key style values so `--dart-define` into the JS bundle is fine |
| `@client` islands cannot receive callbacks | Nav ↔ Layout communicate through a tiny shared `ScrollController` singleton in `interop/scroll.dart` |
| Wheel snapping feel depends on easing implementation | Port `in-out-expo` formula from `scroll-to-element` (`ease` package) verbatim |
| Dart not present on the hosting build image | Install step above; build takes ~2–3 min cold |
| Google Maps embed | Unchanged iframe URL, no key needed |
| Jaspr API drift (0.22 → 0.23 renamed `browser.dart` → `client.dart`, html components are now classes) | Pin `jaspr: ^0.23.4` and follow the generated template |

---

## 9. Definition of done

- [ ] `jaspr build` succeeds in CI and on the host; preview URL serves the site from `build/jaspr`.
- [ ] Screenshot diff at 1440/1024/375px shows no visible difference from the Gatsby site.
- [ ] All interactions in §1 and §6 work on Chrome, Safari and Firefox.
- [ ] Contact form sends via EmailJS from the preview deployment.
- [ ] `/tos`, `/privacy` and 404 render; sitemap and robots present.
- [ ] Gatsby, Node and Yarn files removed; README documents the Dart workflow.
