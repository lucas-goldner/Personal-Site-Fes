import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/icon.dart';
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
    css('#about .social_link').styles(
      raw: {'color': 'inherit', 'text-decoration': 'none'},
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

class _AboutState extends State<About> {
  @override
  void initState() {
    super.initState();
    // Wait for particles.js to be evaluated and for the container to have been
    // laid out: the library sizes its canvas from the container's box, which is
    // still zero-height until the layout has measured the viewport.
    whenReady(
      () => js.particlesReady() && elementHeight(_particlesId) > 0,
      () => js.initParticles(_particlesId),
      maxAttempts: 200,
    );
  }

  @override
  Component build(BuildContext context) {
    final metrics = MetricsProvider.of(context);
    final lang = LangScope.langOf(context);

    return section(
      id: 'about',
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
