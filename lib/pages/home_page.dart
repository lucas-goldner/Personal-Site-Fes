import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/site_data.dart';
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
    return div([
      const Layout(
        children: [
          Hero(),
          About(),
          Services(),
          Portfolio(),
          Contact(),
        ],
      ),
      const Spinner(),
    ]);
  }
}

/// Route wrapper: renders the document metadata on the server and mounts the
/// interactive page below it.
class HomePage extends StatelessComponent {
  const HomePage({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment([
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
