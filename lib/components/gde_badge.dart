import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/site_data.dart';

/// The Google Developer Expert credential line under the hero's job titles.
///
/// A real anchor rather than a scripted button, so it is crawlable and can be
/// opened in a new tab from the context menu. The hover treatment reuses the
/// navigation's motion: the label turns orange while an orange rule wipes in
/// from the left.
class GdeBadge extends StatelessComponent {
  const GdeBadge({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'gde-wrap', [
      a(
        href: gdeUrl,
        target: Target.blank,
        attributes: const {'rel': 'noopener noreferrer'},
        classes: 'gde-badge',
        [.text('Flutter & Dart Google Developer Expert')],
      ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.gde-wrap').styles(margin: .only(top: 22.px)),
    css('.gde-badge', [
      css('&').styles(
        display: .inlineBlock,
        position: .relative(),
        padding: .only(bottom: 4.px),
        color: Colors.white,
        fontSize: 16.px,
        fontWeight: .w600,
        textDecoration: const TextDecoration(line: .none),
        letterSpacing: 0.4.px,
        raw: {'transition': 'color .3s ease'},
      ),
      // The rule that wipes in on hover.
      css('&::after').styles(
        content: '',
        position: .absolute(left: 0.px, bottom: 0.px),
        width: 100.percent,
        height: 2.px,
        backgroundColor: const Color('#ffb035'),
        raw: {
          'transform': 'scaleX(0)',
          'transform-origin': 'left',
          'transition': 'transform .3s ease',
        },
      ),
      css('&:hover').styles(
        color: const Color('#ffb035'),
        textDecoration: const TextDecoration(line: .none),
      ),
      css('&:hover::after').styles(raw: {'transform': 'scaleX(1)'}),
    ]),
  ];
}
