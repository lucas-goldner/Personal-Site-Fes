import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

/// The 404 page.
class NotFoundPage extends StatelessComponent {
  const NotFoundPage({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      const Document.head(title: 'Error : 404'),
      div(classes: 'bg', [
        div(classes: 'error-404', [
          div([
            h1([.text('404')]),
            h2([.text('The page you are looking for could not be found')]),
            const Link(to: '/', child: .text('Home')),
          ]),
        ]),
      ]),
    ]);
  }
}
