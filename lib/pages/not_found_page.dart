import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../i18n/lang.dart';
import '../i18n/language_host.dart';
import '../i18n/strings.dart';

/// The 404 page.
///
/// An island like the home page, for the one reason that it has to be able to
/// read its own `lang` parameter: a link that carried the language this far
/// should not drop it at the last step.
@client
class NotFoundApp extends StatelessComponent {
  const NotFoundApp({super.key});

  @override
  Component build(BuildContext context) {
    return const LanguageHost(child: _NotFound());
  }
}

class _NotFound extends StatelessComponent {
  const _NotFound();

  @override
  Component build(BuildContext context) {
    final lang = LangScope.langOf(context);

    return div(classes: 'bg', [
      div(classes: 'error-404', [
        div([
          h1([.text('404')]),
          h2([.text(Strings.notFoundText(lang))]),
          Link(
            to: lang == Lang.en ? '/' : '/?lang=${lang.code}',
            child: .text(Strings.notFoundHome(lang)),
          ),
        ]),
      ]),
    ]);
  }
}

/// Route wrapper: the document metadata, then the page itself.
class NotFoundPage extends StatelessComponent {
  const NotFoundPage({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      const Document.head(title: 'Error : 404'),
      const NotFoundApp(),
    ]);
  }
}
