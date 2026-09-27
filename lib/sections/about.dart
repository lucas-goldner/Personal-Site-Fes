import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/icon.dart';
import '../components/in_viewport.dart';
import '../components/progress.dart';
import '../data/site_data.dart';
import '../i18n/language_host.dart';
import '../i18n/strings.dart';
import '../interop/browser.dart';
import '../interop/js_libs.dart' as js;
import '../layout/metrics.dart';

/// The id of the element particles.js draws its canvas into.
const _particlesId = 'particles-js';

/// The about text with the particle background, plus the skill bars.
class About extends StatefulComponent {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();

  /// Tightens the column on short viewports.
  ///
  /// The section is locked to the viewport height on desktop while its row is
  /// absolutely positioned, so copy that outgrows the viewport spills over the
  /// services section below. The about text is long enough to do that on common
  /// laptop heights, so the type and spacing step down there. Selectors are
  /// id-based to outrank the ported rules in site.css regardless of load order.
  @css
  static List<StyleRule> get styles => [
    // The icons sit inside anchors now; Bootstrap would otherwise colour and
    // underline them.
    //
    // The glyph is 15px tall, which is a small thing to hit with a thumb, so
    // the anchor is floored at 24px in both directions. Its width comes out at
    // the glyph plus the 10px margin the icons already carried, so the row
    // sits exactly where it did.
    css('#about .social_link').styles(
      raw: {
        'color': 'inherit',
        'text-decoration': 'none',
        'display': 'inline-flex',
        'align-items': 'center',
        'justify-content': 'center',
        'min-width': '24px',
        'min-height': '24px',
      },
    ),
    css.media(const MediaQuery.raw('(min-width: 992px) and (max-height: 860px)'), [
      css('#about .row .content').styles(
        raw: {'padding-top': '2.5%', 'padding-bottom': '2.5%'},
      ),
      css('#about .row .content h3').styles(
        raw: {
          'font-size': '42px',
          'line-height': '46px',
          'margin': '6px 0 12px 0',
        },
      ),
      css('#about .row .content p').styles(
        raw: {'font-size': '13px', 'margin-top': '10px'},
      ),
      // The skills column is the taller of the two now that it carries seven
      // bars, so it has to give up the same kind of room.
      css('#about .row .skills').styles(
        raw: {'padding-top': '2.5%', 'padding-bottom': '2.5%'},
      ),
      css('#about .progress-container').styles(
        raw: {'margin-bottom': '12px'},
      ),
      css('#about .progress-container .name, #about .progress-container .value').styles(raw: {'font-size': '14px'}),
      css('#about .progress-container .progress').styles(
        raw: {'height': '8px', 'margin-top': '6px'},
      ),
    ]),
  ];
}

class _AboutState extends State<About> with ViewportAware<About> {
  @override
  void initState() {
    super.initState();
    // First wait for the section to have a height. Sections start at 0px and
    // are sized from the viewport once the metrics arrive, and until then the
    // whole page is collapsed into the fold — an observer attached that early
    // would report every section as visible. This is also what particles.js
    // needs, since it takes its canvas size from the container's box.
    whenReady(
      () => elementHeight(_particlesId) > 0,
      // Then nothing more until the section is actually on screen. The
      // particle network is a canvas that animates for as long as it exists,
      // and it sits below the fold, so starting it on load spends a
      // continuous slice of the main thread drawing something nobody is
      // looking at. Waiting also holds back the download: asking whether
      // particles.js is ready is what orders it.
      // A tenth of the section, not the first pixel: a browser reports a
      // section resting exactly on the fold as intersecting, which is every
      // desktop viewport here, and that would start the canvas on load again.
      () => watchViewport(threshold: 0.1, () {
        // The script is only fetched once the page has finished loading,
        // which on a slow connection lands well after this, so wait
        // generously — and at a tenth of a second rather than every frame,
        // since a background starting 100ms late is not something anyone can
        // see.
        // A closure, not a tear-off: particlesReady is an external interop
        // member and dart2js refuses to tear those off.
        whenReady(
          () => js.particlesReady(),
          () => js.initParticles(_particlesId),
          maxAttempts: 300,
          interval: const Duration(milliseconds: 100),
        );
      }),
    );
  }

  @override
  Component build(BuildContext context) {
    final metrics = MetricsProvider.of(context);
    final lang = LangScope.langOf(context);

    return section(
      id: 'about',
      key: viewportKey,
      classes: 'about',
      styles: Styles(raw: {'height': metrics.cssHeight}),
      [
        div(id: _particlesId, classes: 'particles', const []),
        div(classes: 'row', [
          div(classes: 'content col-md-6', [
            div(classes: 'content-text', [
              div(classes: 'line-text', [
                h4([.text(Strings.aboutEyebrow(lang))]),
              ]),
              h3([.text(Strings.aboutHeadline(lang))]),
              div(classes: 'separator', const []),
              // Each paragraph is one sentence split around the links inside
              // it, so both languages can put the link where their own grammar
              // wants it.
              p([
                .text(Strings.aboutWorkBefore(lang)),
                a(
                  href: youtrustUrl,
                  target: Target.blank,
                  attributes: const {'rel': 'noopener noreferrer'},
                  classes: 'freshColor',
                  [.text('YOUTRUST')],
                ),
                .text(Strings.aboutWorkAfter(lang)),
              ]),
              p([
                .text(Strings.aboutDeeperBefore(lang)),
                a(
                  href: gdeUrl,
                  target: Target.blank,
                  attributes: const {'rel': 'noopener noreferrer'},
                  classes: 'freshColor',
                  [.text(Strings.gdeTitle(lang))],
                ),
                .text(Strings.aboutDeeperBetween(lang)),
                a(
                  href: flutterTokyoUrl,
                  target: Target.blank,
                  attributes: const {'rel': 'noopener noreferrer'},
                  classes: 'freshColor',
                  [.text('Flutter Tokyo')],
                ),
                .text(Strings.aboutDeeperAfter(lang)),
              ]),
              p([.text(Strings.aboutBackground(lang))]),
              p([.text(Strings.aboutOutside(lang))]),
              div(classes: 'social social_icons', [
                // Real anchors rather than click handlers on the SVGs: the
                // icons carry no text, so each link needs an accessible name,
                // and they should be reachable by keyboard and openable in a
                // new tab from the context menu.
                for (final link in socialLinks)
                  a(
                    href: link.url,
                    target: Target.blank,
                    attributes: {
                      'rel': 'noopener noreferrer',
                      'aria-label': link.label,
                      'title': link.label,
                    },
                    classes: 'social_link',
                    [Icon(link.icon, classes: 'social_icon')],
                  ),
              ]),
            ]),
          ]),
          div(classes: 'skills col-md-6', [
            div(classes: 'line-text', [
              h4([.text(Strings.skillsHeading(lang))]),
            ]),
            div(classes: 'skills-container', [
              for (final skill in skills) Progress(skill),
            ]),
          ]),
        ]),
      ],
    );
  }
}
