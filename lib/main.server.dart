/// The entrypoint for the **server** environment.
///
/// Runs only during static generation, where it renders the document shell for
/// every route. Client-side code lives in `main.client.dart`.
library;

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'app.dart';
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
        // The faces come from fonts.gstatic.com, a host the browser only
        // learns about after it has fetched and parsed the stylesheet below.
        // Warming the connection first takes a DNS lookup and a TLS handshake
        // off the critical path.
        link(href: 'https://fonts.gstatic.com', rel: 'preconnect', attributes: const {'crossorigin': ''}),
        // One request for both families rather than two. Poppins carries no
        // Japanese, so the Japanese page would otherwise fall through to
        // whatever the device happens to have; Google serves that face split
        // by unicode range, so an English reader downloads none of it.
        link(
          href: 'https://fonts.googleapis.com/css2'
              '?family=Noto+Sans+JP:wght@300;400;600;700'
              '&family=Poppins:wght@300;400;700;800;900'
              '&display=swap',
          rel: 'stylesheet',
        ),
        // One stylesheet: the grid, the icon sizing, the animations and the
        // site's own rules, which used to be four separate blocking requests.
        link(href: 'styles/site.css', rel: 'stylesheet'),
        // What every page's link preview has in common; each route adds its
        // own title, description and address.
        ...siteSocialTags,
        // Deferred so they run before the Dart bundle but never block parsing.
        script(src: 'js/particles.js', defer: true),
        script(src: 'js/vanilla-tilt.min.js', defer: true),
        script(src: 'js/site-interop.js', defer: true),
      ],
      body: const App(),
    ),
  );
}
