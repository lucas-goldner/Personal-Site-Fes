/// The entrypoint for the **server** environment.
///
/// Runs only during static generation, where it renders the document shell for
/// every route. Client-side code lives in `main.client.dart`.
library;

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'app.dart';
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
        link(href: 'img/favicon.ico', rel: 'icon'),
        link(
          href: 'https://fonts.googleapis.com/css?family=Poppins:300,400,400,700,800,900&display=swap',
          rel: 'stylesheet',
        ),
        // Vendored, unchanged from the versions the Gatsby build used.
        link(href: 'styles/bootstrap.min.css', rel: 'stylesheet'),
        link(href: 'styles/animate.css', rel: 'stylesheet'),
        link(href: 'styles/fontawesome.css', rel: 'stylesheet'),
        // Compiled from the original SCSS sources.
        link(href: 'styles/site.css', rel: 'stylesheet'),
        // Deferred so they run before the Dart bundle but never block parsing.
        script(src: 'js/particles.js', defer: true),
        script(src: 'js/vanilla-tilt.min.js', defer: true),
        script(src: 'js/site-interop.js', defer: true),
      ],
      body: const App(),
    ),
  );
}
