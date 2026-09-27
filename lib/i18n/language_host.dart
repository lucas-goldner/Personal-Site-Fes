/// Holds the language for a page and hands it to everything below.
library;

import 'package:jaspr/jaspr.dart';

import 'lang.dart';
import 'strings.dart';

/// The language the components below are being read in, and the way to change
/// it.
class LangScope extends InheritedComponent {
  const LangScope({required this.lang, required this.select, required super.child, super.key});

  final Lang lang;

  /// Switches the page to another language and puts the choice in the URL.
  final void Function(Lang lang) select;

  /// The scope above [context], or an English one for a page that has no host.
  static LangScope of(BuildContext context) =>
      context.dependOnInheritedComponentOfExactType<LangScope>() ?? _none;

  /// Shorthand for the common case of only needing the language itself.
  static Lang langOf(BuildContext context) => of(context).lang;

  static const _none = LangScope(lang: Lang.en, select: _ignore, child: Component.empty());

  static void _ignore(Lang lang) {}

  @override
  bool updateShouldNotify(LangScope oldComponent) => oldComponent.lang != lang;
}

/// Reads the language out of the URL once the page is running, and re-renders
/// everything under it in that language.
///
/// The first build deliberately stays in English, whatever the URL says: the
/// markup the static build shipped is English, and hydration has to find the
/// tree it left behind. The switch follows immediately afterwards, while the
/// loading overlay still covers the page.
class LanguageHost extends StatefulComponent {
  const LanguageHost({required this.child, super.key});

  final Component child;

  @override
  State<LanguageHost> createState() => _LanguageHostState();
}

class _LanguageHostState extends State<LanguageHost> {
  var _lang = Lang.en;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;
    final asked = langFromUrl();
    if (asked == Lang.en) return;
    Future(() {
      if (mounted) _apply(asked);
    });
  }

  void _apply(Lang lang) {
    setState(() => _lang = lang);
    applyDocumentLang(
      lang,
      title: Strings.documentTitle(lang),
      description: Strings.documentDescription(lang),
    );
  }

  void _select(Lang lang) {
    if (lang == _lang) return;
    putLangInUrl(lang);
    _apply(lang);
  }

  @override
  Component build(BuildContext context) {
    return LangScope(lang: _lang, select: _select, child: component.child);
  }
}
