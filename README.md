# Lucas Goldner - Persona(l) Site

Personal portfolio site, built with [Jaspr](https://jaspr.site) and pre-rendered
to static HTML. It replaces the previous Gatsby/React build while keeping the
same layout, styling and behaviour.

## Requirements

- [Dart SDK](https://dart.dev/get-dart) 3.10 or newer
- The Jaspr CLI: `dart pub global activate jaspr_cli`

## Running locally

```bash
dart pub get
jaspr serve
```

The dev server listens on <http://localhost:8080> and reloads on change.

## Building

```bash
jaspr build
```

The static site lands in `build/jaspr/`. For a build that matches production,
including the sitemap and the EmailJS credentials, run the deploy script:

```bash
EMAILJS_SERVICE_ID=... EMAILJS_TEMPLATE_ID=... EMAILJS_USER_ID=... \
  bash scripts/vercel-build.sh
```

## Project layout

```
lib/
  main.server.dart    document shell: meta tags, stylesheets, vendored scripts
  main.client.dart    client entrypoint, hydrates the @client islands
  app.dart            route table (/, /tos, /privacy, /404)
  data/               all page content, ported from the old data/*.json
  layout/             viewport metrics, wheel snapping, navigation, spinner
  sections/           hero, about, services, portfolio, contact
  components/         glitch, typewriter, baffle text, counters, progress bars
  interop/            browser helpers, EmailJS, bridge to the vendored JS libs
web/
  styles/             site.css (compiled from the original SCSS) + vendored CSS
  js/                 particles.js, vanilla-tilt, and the interop shim
  img/ heroIcons/ projectImg/   images, moved over unchanged
tool/                 generators for the icon and legal-page Dart sources
scripts/              Vercel install and build steps
```

### How the page is rendered

The site builds in Jaspr's `static` mode, so every route is pre-rendered to HTML
at build time. The home page is one `@client` island that is hydrated in the
browser, which is what lets it measure the viewport, snap between sections and
run the animations, exactly as the React app did.

### Styling

`web/styles/site.css` is compiled once from the original SCSS sources of the
Gatsby site, so the rules the browser receives are unchanged. Bootstrap 3.3.7,
the used parts of animate.css 3.7.2 and the Font Awesome inline-SVG sizing rules
are vendored next to it. Poppins is loaded from Google Fonts, as before.

To regenerate `site.css` after editing the SCSS, compile the partials in this
order: globals, navigation, spinner, glitch, progress, hero, about, services,
portfolio, contact.

### Generated sources

Two files are produced by the scripts in `tool/` and should not be edited by
hand:

- `lib/components/icons_data.dart` - Font Awesome outlines (`node tool/gen_icons.js <out>`)
- `lib/pages/tos_content.dart`, `lib/pages/privacy_content.dart` - legal copy

`lib/main.client.options.dart` and `lib/main.server.options.dart` are written by
`jaspr_builder` on every build.

## Deployment

Vercel builds the site with `scripts/vercel-install.sh` (which fetches the Dart
SDK, since the build image has none) and `scripts/vercel-build.sh`, then serves
`build/jaspr`. Unmatched paths fall through to the 404 page with a 404 status.

Set these environment variables in the Vercel project so the contact form can
send. They replace the old `GATSBY_*` variables and are public EmailJS keys:

| Variable | Purpose |
| --- | --- |
| `EMAILJS_SERVICE_ID` | EmailJS service |
| `EMAILJS_TEMPLATE_ID` | EmailJS template |
| `EMAILJS_USER_ID` | EmailJS public key |
| `SITE_DOMAIN` | Base URL for `sitemap.xml`, defaults to the production domain |

Without them the form still renders, but submitting reports that sending failed.

## Continuous integration

There is no workflow file in the repository. To check every push, add
`.github/workflows/build.yml` with:

```yaml
name: Build

on:
  push:
    branches: ["**"]
  pull_request:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dart-lang/setup-dart@v1
        with:
          sdk: stable
      - run: dart pub global activate jaspr_cli
      - run: dart pub get
      - run: dart format --output=none --set-exit-if-changed lib tool
      - run: dart analyze --fatal-infos
      - run: jaspr build --verbose
      - uses: actions/upload-artifact@v4
        with:
          name: site
          path: build/jaspr
```

## Third-party assets

Bootstrap (MIT), animate.css (MIT), particles.js (MIT), vanilla-tilt (MIT) and
Font Awesome Free (CC BY 4.0 for the icons, MIT for the styles) are vendored
under `web/` and `lib/components/icons_data.dart` with their original notices.
