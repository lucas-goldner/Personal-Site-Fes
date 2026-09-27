import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/gde_badge.dart';
import '../components/glitch.dart';
import '../components/hover_button.dart';
import '../components/lang_slider.dart';
import '../components/typewriter.dart';
import '../data/site_data.dart';
import '../i18n/language_host.dart';
import '../i18n/strings.dart';
import '../layout/metrics.dart';

/// The landing panel: name, rotating job title, CV button and the photo.
class Hero extends StatelessComponent {
  const Hero({super.key});

  @css
  static List<StyleRule> get styles => [
    // In the flow by default, held to the right above the text. The panel is
    // only as tall as its contents once the columns stack, so there is no
    // corner to float in and a pinned slider would sit on the name.
    //
    // Relative rather than static: the knob inside is absolute, and static
    // would hand it the whole panel to size itself against.
    css('.hero .content > .lang_slider').styles(
      position: .relative(),
      margin: .only(bottom: 18.px),
      raw: {'align-self': 'flex-end'},
    ),
    // Side by side, the panel has room to spare, and the slider goes into the
    // corner opposite the menu button. The offsets live here rather than being
    // undone above: on a relative box `right` shifts it sideways instead of
    // placing it, which is a bug waiting to be reintroduced.
    css.media(const MediaQuery.raw('(min-width: 992px)'), [
      css('.hero .content > .lang_slider').styles(
        // The column is a Bootstrap `col-*`, so it is already positioned and
        // the corner is its own rather than the page's. Above the hobby icons,
        // which drift through the panel on their own layer.
        position: .absolute(right: 5.percent, top: 5.percent),
        zIndex: const ZIndex(60),
        margin: .zero,
      ),
    ]),
  ];

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
            const LangSlider(),
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
                href: cvLink(lang),
                // A file this site serves is handed over; the copy on Drive
                // has nothing to hand over and opens where it lives.
                download: !cvLink(lang).startsWith('http'),
              ),
            ]),
            ..._floatingIcons(),
          ]),
          div(classes: 'img col-md-6', [
            // High priority because this is what the load is measured on;
            // the browser otherwise treats it as just another image.
            //
            // No <link rel=preload> beside it. The element is in the markup
            // the first response carries, so the scanner finds it either way,
            // and a preload is a second opinion about which width to take:
            // under emulation it resolved before the device metrics did, and
            // the 1800px copy came down alongside the 900px one.
            img(
              src: heroImage,
              alt: heroImageAlt(lang),
              width: heroImageWidth,
              height: heroImageHeight,
              attributes: const {
                'srcset': heroImageSrcset,
                'sizes': heroImageSizes,
                'fetchpriority': 'high',
              },
            ),
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
          attributes: {
            'srcset': heroIcons[i].srcset,
            'sizes': heroIconSizes,
          },
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
