import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../i18n/lang.dart';
import '../i18n/language_host.dart';
import '../i18n/strings.dart';

/// The language switch, as a two-position slider.
///
/// Both halves are the same width whatever is written on them, so the knob has
/// one distance to travel and the control does not change size when the
/// language it is set to does.
class LangSlider extends StatelessComponent {
  const LangSlider({super.key});

  @override
  Component build(BuildContext context) {
    final scope = LangScope.of(context);

    return div(
      classes: 'lang_slider',
      attributes: {'role': 'group', 'aria-label': Strings.languageLabel(scope.lang)},
      [
        // Behind the labels rather than around them, so the one it is under
        // reads as chosen without the text having to move.
        span(
          classes: 'lang_knob${scope.lang == Lang.ja ? ' end' : ''}',
          attributes: const {'aria-hidden': 'true'},
          const [],
        ),
        for (final option in Lang.values)
          button(
            classes: 'lang_half${option == scope.lang ? ' active' : ''}',
            attributes: {
              'type': 'button',
              // Each half is written in its own language, so it is marked up as
              // being in it: a screen reader reading EN and Japanese in one
              // voice gets one of the two wrong.
              'lang': option.code,
              'aria-pressed': '${option == scope.lang}',
              'title': option.endonym,
            },
            onClick: () => scope.select(option),
            [.text(option.shortLabel)],
          ),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.lang_slider', [
      css('&').styles(
        display: .inlineFlex,
        position: .relative(),
        padding: .all(3.px),
        raw: {
          'background-color': 'rgba(0, 0, 0, .45)',
          'border': '1px solid #454e5c',
          'border-radius': '999px',
          'line-height': '1',
        },
      ),
      css('.lang_knob').styles(
        position: .absolute(left: 3.px, top: 3.px),
        width: 50.percent,
        height: .auto,
        raw: {
          'bottom': '3px',
          'width': 'calc(50% - 3px)',
          'background-color': '#ffb035',
          'border-radius': '999px',
          'transition': 'transform .25s ease',
        },
      ),
      // One width of travel, because the halves are equal.
      css('.lang_knob.end').styles(raw: {'transform': 'translateX(100%)'}),
      css('.lang_half', [
        css('&').styles(
          position: .relative(),
          zIndex: const ZIndex(1),
          width: 62.px,
          padding: .symmetric(vertical: 6.px, horizontal: 4.px),
          color: const Color('#cfd4db'),
          fontSize: 11.px,
          fontWeight: .w700,
          textAlign: .center,
          raw: {
            'background-color': 'transparent',
            'border': 'none',
            'border-radius': '999px',
            'cursor': 'pointer',
            'letter-spacing': '1px',
            'transition': 'color .25s ease',
          },
        ),
        css('&.active').styles(color: const Color('#1b2028')),
        css('&:focus-visible').styles(
          raw: {'outline': '2px solid #ffb035', 'outline-offset': '3px'},
        ),
      ]),
    ]),
  ];
}
