import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/icon.dart';
import '../components/lang_slider.dart';
import '../data/site_data.dart';
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
          // 300px wide for a box CSS caps at 100px: enough for a three-times
          // display, and nothing beyond it was ever drawn.
          img(src: 'img/LucasLogo.webp', alt: 'logo', width: 300, height: 81),
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

  /// The same switch the hero carries, under the section links.
  ///
  /// The hero's scrolls away with the first section, and somebody who has read
  /// down to the contact form should not have to scroll back up to change
  /// their mind about the language.
  Component _languages(LangScope scope) {
    return div(classes: 'lang_switch', [
      span(classes: 'lang_title', [.text(Strings.languageLabel(scope.lang))]),
      const LangSlider(),
    ]);
  }

}
