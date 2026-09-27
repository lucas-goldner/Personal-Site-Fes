import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/icon.dart';
import '../data/site_data.dart';
import '../i18n/lang.dart';
import '../i18n/language_host.dart';
import '../i18n/strings.dart';
import '../interop/browser.dart';

/// The off-canvas menu and the hamburger that opens it.
class Navigation extends StatefulComponent {
  const Navigation({required this.onSectionChanged, super.key});

  /// Reports the index of the section the menu scrolled to, so the layout's
  /// wheel handler continues from the right place.
  final void Function(int index) onSectionChanged;

  @override
  State<Navigation> createState() => _NavigationState();

  @css
  static List<StyleRule> get styles => [
    css('.navigation .lang_switch', [
      css('&').styles(
        margin: .only(top: 40.px),
        textAlign: .center,
      ),
      css('.lang_title').styles(
        display: .block,
        margin: .only(bottom: 12.px),
        color: const Color('#888'),
        fontSize: 11.px,
        fontWeight: .w400,
        textTransform: .upperCase,
        raw: {'letter-spacing': '2px'},
      ),
      css('.lang_options').styles(
        display: .flex,
        gap: Gap(column: 10.px, row: 10.px),
        justifyContent: .center,
      ),
      css('.lang_option', [
        css('&').styles(
          padding: .symmetric(vertical: 6.px, horizontal: 16.px),
          color: const Color('#fff'),
          fontSize: 14.px,
          raw: {
            'background-color': 'transparent',
            'border': '1px solid #444',
            'border-radius': '999px',
            'cursor': 'pointer',
            'transition': 'color .2s ease, border-color .2s ease',
          },
        ),
        css('&:hover').styles(raw: {'border-color': '#ffb035'}),
        css('&:focus-visible').styles(
          raw: {'outline': '2px solid #ffb035', 'outline-offset': '2px'},
        ),
        // The chosen one is stated in the accent rather than only by contrast,
        // which a pair of buttons this close together needs.
        css('&.active').styles(
          color: const Color('#000'),
          raw: {'background-color': '#ffb035', 'border-color': '#ffb035'},
        ),
      ]),
    ]),
  ];
}

class _NavigationState extends State<Navigation> {
  bool _show = false;

  void _navigate(int index) {
    setState(() => _show = false);
    scrollToElement(
      sectionIds[index],
      onEnd: () => component.onSectionChanged(index),
    );
  }

  @override
  Component build(BuildContext context) {
    final scope = LangScope.of(context);

    return div([
      div(classes: 'opener', [
        Icon(
          faBars,
          classes: 'closeNav',
          events: events(onClick: () => setState(() => _show = true)),
        ),
      ]),
      div(classes: 'navigation${_show ? ' active' : ''}', [
        Icon(
          faTimes,
          classes: 'closeNav',
          events: events(onClick: () => setState(() => _show = false)),
        ),
        div(classes: 'logo', [
          img(src: 'img/LucasLogo.png', alt: 'logo'),
        ]),
        div(classes: 'links', [
          ul([
            for (var i = 0; i < Strings.navLabels.length; i++)
              li([
                button(
                  onClick: () => _navigate(i),
                  [.text(Strings.navLabels[i](scope.lang))],
                ),
              ]),
          ]),
        ]),
        _languages(scope),
      ]),
    ]);
  }

  /// The language switch, under the section links.
  ///
  /// Each option is written in its own language rather than translated, since
  /// somebody looking for Japanese is looking for the word Japanese is written
  /// with, and the `lang` attribute keeps a screen reader from reading one of
  /// them out in the voice of the other.
  Component _languages(LangScope scope) {
    return div(classes: 'lang_switch', [
      span(classes: 'lang_title', [.text(Strings.languageLabel(scope.lang))]),
      div(classes: 'lang_options', [
        for (final option in Lang.values)
          button(
            classes: 'lang_option${option == scope.lang ? ' active' : ''}',
            attributes: {
              'type': 'button',
              'lang': option.code,
              'aria-pressed': '${option == scope.lang}',
            },
            onClick: () => scope.select(option),
            [.text(option.endonym)],
          ),
      ]),
    ]);
  }

}
