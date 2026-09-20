import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/site_data.dart';
import 'icon.dart';

/// The Google Developer Expert credential line under the hero's job titles.
///
/// A real anchor rather than a scripted button, so it is crawlable and can be
/// opened in a new tab from the context menu. A highlight sweeps across the
/// label every few seconds and the star twinkles alongside it, which lifts the
/// credential off the panel without competing with the glitching name above.
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
        [
          const Icon(faStar, classes: 'gde-star'),
          span(classes: 'gde-label', [
            .text('Flutter & Dart Google Developer Expert'),
          ]),
        ],
      ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.gde-wrap').styles(margin: .only(top: 22.px)),
    css('.gde-badge', [
      css('&').styles(
        display: .inlineFlex,
        position: .relative(),
        padding: .only(bottom: 4.px),
        alignItems: .center,
        gap: Gap(column: 9.px),
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
        backgroundColor: _accent,
        raw: {
          'transform': 'scaleX(0)',
          'transform-origin': 'left',
          'transition': 'transform .3s ease',
        },
      ),
      css('&:hover').styles(
        color: _accent,
        textDecoration: const TextDecoration(line: .none),
      ),
      css('&:hover::after').styles(raw: {'transform': 'scaleX(1)'}),
    ]),
    css('.gde-star').styles(
      width: .auto,
      height: 15.px,
      flex: const Flex(grow: 0, shrink: 0),
      color: _accent,
      raw: {
        'animation': 'gdeTwinkle 2.4s ease-in-out infinite',
        'transform-origin': 'center',
      },
    ),
    // The label is painted by a moving gradient, so it needs background-clip.
    // Browsers without it keep the plain white text set above.
    css.supports('(background-clip: text) or (-webkit-background-clip: text)', [
      css('.gde-label').styles(
        raw: {
          'background': 'linear-gradient(100deg, #fff 30%, #ffb035 50%, #fff 70%)',
          'background-size': '250% 100%',
          '-webkit-background-clip': 'text',
          'background-clip': 'text',
          '-webkit-text-fill-color': 'transparent',
          'animation': 'gdeShine 4.5s linear infinite',
        },
      ),
    ]),
    // Hovering turns the whole line orange, so the sweep has to get out of the
    // way or it would keep repainting the label white.
    css('.gde-badge:hover .gde-label').styles(
      color: _accent,
      raw: {
        'background': 'none',
        '-webkit-text-fill-color': 'currentColor',
        'animation': 'none',
      },
    ),
    css.keyframes('gdeShine', {
      'from': Styles(raw: {'background-position': '200% 0'}),
      'to': Styles(raw: {'background-position': '-50% 0'}),
    }),
    css.keyframes('gdeTwinkle', {
      '0%, 100%': Styles(raw: {'transform': 'scale(1) rotate(0deg)', 'opacity': '1'}),
      '50%': Styles(raw: {'transform': 'scale(1.35) rotate(18deg)', 'opacity': '.75'}),
    }),
    // Both loops are decorative; stop them for anyone who asked for less motion.
    css.media(const MediaQuery.raw('(prefers-reduced-motion: reduce)'), [
      css('.gde-star, .gde-label').styles(raw: {'animation': 'none'}),
    ]),
  ];
}

const _accent = Color('#ffb035');
