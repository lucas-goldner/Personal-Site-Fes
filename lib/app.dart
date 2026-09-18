import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'pages/home_page.dart';
import 'pages/legal_pages.dart';
import 'pages/not_found_page.dart';

/// The site's route table.
///
/// Multi-page routing means this component only runs on the server during
/// static generation; each route is written out as its own HTML file and the
/// `@client` parts below it are hydrated in the browser.
class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    // Carries the overflow rule the Gatsby root element (#___gatsby) had.
    return div(id: 'app', [
      Router(
        errorBuilder: (context, state) => const NotFoundPage(),
        routes: [
          Route(
            path: '/',
            title: 'Lucas Goldner - Persona(l) Portfolio Website',
            builder: (context, state) => const HomePage(),
            settings: const RouteSettings(priority: 1.0),
          ),
          Route(
            path: '/tos',
            title: 'Impressum - Lucas Goldner',
            builder: (context, state) => const TosPage(),
            settings: const RouteSettings(priority: 0.3),
          ),
          Route(
            path: '/privacy',
            title: 'Privacy Policy - Lucas Goldner',
            builder: (context, state) => const PrivacyPage(),
            settings: const RouteSettings(priority: 0.3),
          ),
          Route(
            path: '/404',
            title: 'Error : 404',
            builder: (context, state) => const NotFoundPage(),
          ),
        ],
      ),
    ]);
  }
}
