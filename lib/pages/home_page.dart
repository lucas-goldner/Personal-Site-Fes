import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/site_data.dart';
import '../i18n/language_host.dart';
import '../layout/layout.dart';
import '../layout/spinner.dart';
import '../sections/about.dart';
import '../sections/contact.dart';
import '../sections/hero.dart';
import '../sections/portfolio.dart';
import '../sections/services.dart';

/// The one-page site: the five scroll-snapped sections plus the loading overlay.
///
/// The whole page is a single `@client` island, mirroring the React app it
/// replaces. Static generation still pre-renders the markup, it is just resumed
/// in the browser so the sections can measure the viewport and animate.
@client
class HomeApp extends StatelessComponent {
  const HomeApp({super.key});

  @override
  Component build(BuildContext context) {
    // Everything below reads its language from here. The host starts in the
    // English the static build shipped and switches on the next turn of the
    // event loop if the URL asked for Japanese, which is still behind the
    // loading overlay.
    return const LanguageHost(
      child: div([
        Layout(
          children: [
            Hero(),
            About(),
            Services(),
            Portfolio(),
            Contact(),
          ],
        ),
        Spinner(),
      ]),
    );
  }
}

/// Route wrapper: renders the document metadata on the server and mounts the
/// interactive page below it.
class HomePage extends StatelessComponent {
  const HomePage({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      // Static generation writes English; the language host rewrites the
      // title and the description in the browser when the URL asks for
      // Japanese.
      const Document.head(
        title: SiteMeta.title,
        meta: {
          'author': SiteMeta.author,
          'description': SiteMeta.description,
          'keywords': SiteMeta.keywords,
        },
      ),
      const HomeApp(),
    ]);
  }
}
