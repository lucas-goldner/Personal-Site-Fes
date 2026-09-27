import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/gde_badge.dart';
import '../components/glitch.dart';
import '../components/hover_button.dart';
import '../components/typewriter.dart';
import '../data/site_data.dart';
import '../i18n/language_host.dart';
import '../i18n/strings.dart';
import '../interop/browser.dart';
import '../layout/metrics.dart';

/// The landing panel: name, rotating job title, CV button and the photo.
class Hero extends StatelessComponent {
  const Hero({super.key});

  @override
  Component build(BuildContext context) {
    final metrics = MetricsProvider.of(context);
    final lang = LangScope.langOf(context);

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
              // Keyed by language: the effect types one string at a time, and
              // swapping the list under it mid-word would leave it deleting
              // characters that are no longer there.
              Typewriter(
                key: ValueKey(lang),
                strings: [for (final title in typewriterStrings) title(lang)],
              ),
              const GdeBadge(),
              HoverButton(
                label: Strings.downloadCv(lang),
                onClick: () => openUrl(cvUrl),
              ),
            ]),
            ..._floatingIcons(),
          ]),
          div(classes: 'img col-md-6', [
            img(src: heroImage, alt: heroImageAlt(lang)),
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
