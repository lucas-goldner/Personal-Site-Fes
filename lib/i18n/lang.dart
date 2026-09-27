/// The two languages the site is published in, and how a page finds out which
/// one it is being read in.
///
/// English is the default and the only language the static build writes out:
/// every route is pre-rendered in English, and a page asked for in Japanese
/// switches once it is running in the browser. The loading overlay is still up
/// at that point, so the switch happens out of sight.
library;

import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

/// A language of the site.
enum Lang {
  en,
  ja;

  /// The value of the `lang` query parameter, and of the `lang` attribute on
  /// `<html>`.
  String get code => name;

  /// What the language calls itself, which is what the switcher shows: nobody
  /// looking for Japanese is helped by the word "Japanese".
  String get endonym => switch (this) {
    Lang.en => 'English',
    Lang.ja => '日本語',
  };

  /// The endonym cut down to what fits on half of a slider.
  ///
  /// Japanese does not shorten — 日本語 is already three characters — so this is
  /// the lopsided pairing every bilingual site in Japan uses.
  String get shortLabel => switch (this) {
    Lang.en => 'EN',
    Lang.ja => '日本語',
  };
}

/// A string in both languages.
///
/// Content carries its translation next to it rather than in a parallel file,
/// so a tile, a card or a skill bar is one entry that cannot half-exist in one
/// language and be forgotten in the other.
@immutable
class L {
  const L(this.en, this.ja);

  /// For text that is the same either way: product names, stacks, the list of
  /// technologies behind a card.
  const L.same(String both) : en = both, ja = both;

  final String en;
  final String ja;

  /// The wording for [lang], so call sites read as `service.title(lang)`.
  String call(Lang lang) => switch (lang) { Lang.en => en, Lang.ja => ja };
}

/// The language the `lang` query parameter asks for.
///
/// Anything that is not a language the site is published in falls back to
/// English, which is what the pre-rendered HTML holds anyway.
Lang langFromUrl() {
  if (!kIsWeb) return Lang.en;
  final search = web.window.location.search;
  final asked = Uri.splitQueryString(search.startsWith('?') ? search.substring(1) : search)['lang'];
  return Lang.values.firstWhere((lang) => lang.code == asked, orElse: () => Lang.en);
}

/// Writes [lang] back into the address bar.
///
/// Replaces rather than pushes: the back button does not switch the language
/// back, so leaving a history entry behind would only break it.
void putLangInUrl(Lang lang) {
  if (!kIsWeb) return;
  final here = Uri.parse(web.window.location.href);
  final params = Map<String, String>.of(here.queryParameters)..remove('lang');
  if (lang != Lang.en) params['lang'] = lang.code;
  final target = Uri(
    path: here.path,
    query: params.isEmpty ? null : Uri(queryParameters: params).query,
    fragment: here.fragment.isEmpty ? null : here.fragment,
  );
  web.window.history.replaceState(null, '', target.toString());
}

/// Tells the document itself what language it is in.
///
/// The `lang` attribute is what a screen reader picks its voice from and what
/// a browser offers to translate against, so it has to follow the text rather
/// than stay at the `en` the static build wrote.
void applyDocumentLang(Lang lang, {required String title, required String description}) {
  if (!kIsWeb) return;
  web.document.documentElement?.setAttribute('lang', lang.code);
  web.document.title = title;
  final meta = web.document.querySelector('meta[name="description"]');
  meta?.setAttribute('content', description);
}
