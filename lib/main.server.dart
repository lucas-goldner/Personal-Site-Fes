/// The entrypoint for the **server** environment.
///
/// Runs only during static generation, where it renders the document shell for
/// every route. Client-side code lives in `main.client.dart`.
library;

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'app.dart';
import 'components/inline_styles.dart';
import 'components/social_tags.dart';
import 'data/site_data.dart';
import 'main.server.options.dart';

void main() {
  Jaspr.initializeApp(options: defaultServerOptions);

  runApp(
    Document(
      lang: 'en',
      title: SiteMeta.title,
      viewport: 'width=device-width, initial-scale=1.0',
      meta: const {
        'author': SiteMeta.author,
        'description': SiteMeta.description,
        'keywords': SiteMeta.keywords,
      },
      head: [
        // The query is a cache-buster, not a path. A browser holds on to a
        // favicon well past the page that named it, so replacing the file
        // without renaming what points at it leaves the old face in the tab.
        link(href: 'img/favicon.ico?v=3', rel: 'icon'),
        // No font request here at all: Poppins is declared in the stylesheet
        // below and served from this site. The Japanese face still comes from
        // Google, fetched by the language host only when a page is actually
        // being read in Japanese — see loadJapaneseFont.
        // One stylesheet, and inline rather than linked: the grid, the icon
        // sizing, the animations and the site's own rules, which used to be
        // four separate blocking requests. See inlineSiteStyles.
        inlineSiteStyles(),
        // What every page's link preview has in common; each route adds its
        // own title, description and address.
        ...siteSocialTags,
        // The only script in the head, and deferred so it never blocks
        // parsing. particles.js and vanilla-tilt used to sit beside it; they
        // are decoration, so site-interop now fetches them once the page has
        // loaded rather than alongside the hero image.
        script(src: 'js/site-interop.js', defer: true),
      ],
      body: const App(),
    ),
  );
}
