import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/animation_container.dart';
import '../components/baffle_text.dart';
import '../components/counter.dart';
import '../components/icon.dart';
import '../data/site_data.dart';
import '../layout/metrics.dart';

/// The expertise cards plus the count-up strip beneath them.
class Services extends StatefulComponent {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();

  /// What the seven cards need on top of the ported `.service` rules.
  ///
  /// Selectors are anchored on `#services` so they outrank the ported rules in
  /// site.css, which reach the cards through a seven-class descendant chain.
  @css
  static List<StyleRule> get styles => [
    // A flex row rather than Bootstrap's floats. Seven cards of uneven height
    // snag on each other when floated, and flexing them also runs the middle
    // column's dividers the full height of the row instead of stopping at the
    // shortest card.
    css('#services .expertise-row').styles(
      display: .flex,
      flexWrap: .wrap,
      alignItems: .stretch,
      justifyContent: .center,
    ),
    // Every icon is a solid glyph now, so they share one size instead of the
    // 50px/40px split that kept the brand marks from dwarfing them.
    css('#services .service .icon svg').styles(fontSize: 38.px),
    css('#services .service h4').styles(
      margin: .only(top: 14.px, bottom: 4.px),
      fontSize: 19.px,
    ),
    // The stack behind each area: smaller than the title, accented, and free
    // to wrap onto a second line in a narrow column.
    css('#services .service .technologies').styles(
      margin: .only(bottom: 9.px),
      color: _accent,
      fontSize: 11.px,
      fontWeight: .w500,
      lineHeight: 16.px,
      raw: {'letter-spacing': '.2px', 'overflow-wrap': 'break-word'},
    ),
    // The ported 10px is unreadable under descriptions this long. The bottom
    // margin has to go: it is dead space under the last line of every card,
    // and three rows of it is more than the locked section can spare.
    css('#services .service p').styles(
      margin: Margin.zero,
      fontSize: 11.px,
      lineHeight: 17.px,
    ),
    // The closing card spans the row and is set off by the same divider grey
    // the middle column uses, so it reads as a way of working rather than an
    // eighth platform.
    css('#services .service.featured').styles(
      margin: .only(top: 6.px),
      padding: .only(top: 18.px),
      raw: {'border-top': '1px solid #2c343f'},
    ),
    css('#services .service.featured .service-body').styles(
      raw: {'max-width': '880px', 'margin': '0 auto'},
    ),
    // From the two-column breakpoint up there is room to set the band on one
    // line, which keeps the last row short enough for the locked section.
    css.media(const MediaQuery.raw('(min-width: 768px)'), [
      css('#services .service.featured .service-body').styles(
        display: .flex,
        alignItems: .center,
        gap: Gap(column: 26.px),
        textAlign: .start,
      ),
      css('#services .service.featured .icon').styles(
        flex: const Flex(grow: 0, shrink: 0),
      ),
      css('#services .service.featured h4').styles(margin: .only(bottom: 4.px)),
    ]),
    // The section is locked to the viewport height on desktop and clips what
    // does not fit, and three rows of cards still outgrow a laptop screen even
    // with the copy cut back. Above that the block is left at full size.
    css.media(const MediaQuery.raw('(min-width: 992px) and (max-height: 880px)'), [
      // The ported padding is a percentage of the width, so it is at its
      // most generous exactly where the height is scarcest.
      css('#services .row.top .content').styles(
        raw: {'padding-top': '14px', 'padding-bottom': '14px'},
      ),
      css('#services .row.top .content .baffle_text span').styles(
        fontSize: 42.px,
        lineHeight: 44.px,
      ),
      css('#services .service').styles(margin: .symmetric(vertical: 8.px)),
      css('#services .service .icon svg').styles(fontSize: 32.px),
      css('#services .service h4').styles(
        margin: .only(top: 8.px, bottom: 3.px),
        fontSize: 17.px,
      ),
      css('#services .service .technologies').styles(
        margin: .only(bottom: 6.px),
        fontSize: 10.px,
        lineHeight: 14.px,
      ),
      css('#services .service p').styles(fontSize: 10.px, lineHeight: 14.px),
      css('#services .service.featured').styles(
        margin: Margin.zero,
        padding: .only(top: 10.px),
      ),
    ]),
  ];
}

const _accent = Color('#ffb035');

class _ServicesState extends State<Services> {
  /// Set once the "What I Do" heading has finished resolving.
  bool _show = false;

  @override
  Component build(BuildContext context) {
    final metrics = MetricsProvider.of(context);
    final topMaxHeight = metrics.fraction(0.8);
    final containerMinHeight = metrics.fraction(0.6);

    return section(
      id: 'services',
      classes: 'services',
      styles: Styles(raw: {'height': metrics.cssHeight}),
      [
        div(
          classes: 'top row',
          styles: Styles(
            raw: {
              'max-height': topMaxHeight == null ? 'inherit' : '${topMaxHeight.toStringAsFixed(0)}px',
            },
          ),
          [
            div(classes: 'content', [
              div(classes: 'col-md-12', [
                div(classes: 'line-text', [
                  h4([.text('Expertise')]),
                ]),
                div(classes: 'heading', [
                  BaffleText(
                    text: 'What I Do',
                    revealDuration: 500,
                    revealDelay: 500,
                    revealCallbackDelay: 1100,
                    onRevealed: () => setState(() => _show = true),
                  ),
                ]),
                div(
                  classes: 'services_container',
                  styles: Styles(
                    raw: {
                      'min-height': containerMinHeight == null
                          ? 'inherit'
                          : '${containerMinHeight.toStringAsFixed(0)}px',
                    },
                  ),
                  [
                    div(classes: 'container', [_cards(metrics)]),
                  ],
                ),
              ]),
            ]),
          ],
        ),
        div(classes: 'bottom row', [_counters(metrics)]),
      ],
    );
  }

  /// Content appears once the heading resolved, or immediately on mobile where
  /// the sections are auto-sized.
  bool _visible(SiteMetrics metrics) => _show || metrics.isAuto;

  Component _cards(SiteMetrics metrics) {
    if (!_visible(metrics)) return const Component.empty();

    return div(classes: 'row expertise-row', [
      for (final service in services)
        div(classes: _cardClasses(service), [
          AnimationContainer(
            delay: service.delay,
            animation: service.animation,
            children: [
              div(classes: 'service-body', [
                div(classes: 'icon', [Icon(service.icon)]),
                div(classes: 'service-text', [
                  h4([.text(service.title)]),
                  p(classes: 'technologies', [.text(service.technologies)]),
                  p([.text(service.text)]),
                ]),
              ]),
            ],
          ),
        ]),
    ]);
  }

  /// Three columns on a desktop, two on a tablet, one on a phone; the featured
  /// card takes the full width at every size.
  ///
  /// The ported `border-side` class, which ruled a line down either side of
  /// the middle column, is not used: the columns are far enough apart to read
  /// as columns without it, and the rule above the closing card says more
  /// when it is the only line in the section.
  String _cardClasses(Service service) => [
    'service',
    if (service.featured) 'featured col-xs-12' else 'col-sm-6 col-md-4',
  ].join(' ');

  Component _counters(SiteMetrics metrics) {
    if (!_visible(metrics)) return const Component.empty();

    return div(classes: 'container', [
      for (final counter in counters)
        div(classes: 'col-md-4', [
          AnimationContainer(
            delay: 100,
            animation: 'fadeIn fast',
            children: [Counter(counter)],
          ),
        ]),
    ]);
  }
}
