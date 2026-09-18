import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/animation_container.dart';
import '../components/baffle_text.dart';
import '../components/counter.dart';
import '../components/icon.dart';
import '../data/site_data.dart';
import '../layout/metrics.dart';

/// The six service cards plus the count-up strip beneath them.
class Services extends StatefulComponent {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

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
                  h4([.text('Services')]),
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

    return div(classes: 'row', [
      for (final service in services)
        div(
          classes: 'service col-md-4${service.borderSide ? ' border-side' : ''}',
          [
            AnimationContainer(
              delay: service.delay,
              animation: service.animation,
              children: [
                div(classes: 'icon', [
                  Icon(service.icon, classes: service.solid ? 'solid' : null),
                ]),
                h4([.text(service.title)]),
                p([.text(service.text)]),
              ],
            ),
          ],
        ),
    ]);
  }

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
