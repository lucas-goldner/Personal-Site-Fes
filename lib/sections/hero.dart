import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/gde_badge.dart';
import '../components/glitch.dart';
import '../components/hover_button.dart';
import '../components/typewriter.dart';
import '../data/site_data.dart';
import '../interop/browser.dart';
import '../layout/metrics.dart';

/// The landing panel: name, rotating job title, CV button and the photo.
class Hero extends StatelessComponent {
  const Hero({super.key});

  @override
  Component build(BuildContext context) {
    final metrics = MetricsProvider.of(context);

    return section(
      id: 'home',
      classes: 'hero',
      styles: Styles(raw: {'height': metrics.cssHeight}),
      [
        div(classes: 'row', [
          div(classes: 'content col-md-6', [
            div(classes: 'content-text', [
              div(classes: 'line-text', [
                h4([.text('俺は')]),
              ]),
              const Glitch('Lucas Goldner'),
              const Typewriter(strings: typewriterStrings),
              const GdeBadge(),
              HoverButton(
                label: 'Download CV',
                onClick: () => openUrl(cvUrl),
              ),
            ]),
            ..._floatingIcons(),
          ]),
          div(classes: 'img col-md-6', [
            img(src: heroImage, alt: heroImageAlt),
          ]),
        ]),
      ],
    );
  }

  /// The hobby icons bobbing over the dark panel.
  List<Component> _floatingIcons() {
    return [
      for (var i = 0; i < heroIcons.length; i++)
        img(
          src: heroIcons[i].src,
          alt: 'shape',
          classes:
              'animated fadeIn '
              'move-${heroIcons[i].moveUp ? 'up' : 'down'} float-image',
          styles: Styles(
            raw: {
              'left': '${i * 10}%',
              'bottom': '${heroIcons[i].bottomPercent}%',
            },
          ),
        ),
    ];
  }
}
