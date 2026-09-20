import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/icon.dart';
import '../components/progress.dart';
import '../data/site_data.dart';
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
                h4([.text('About Me')]),
              ]),
              h3([.text('Mobile Engineer. Builder. Speaker.')]),
              div(classes: 'separator', const []),
              p([
                .text(
                  'I\u2019m a mobile engineer based in Japan, specializing in '
                  'Flutter and Dart. At ',
                ),
                a(
                  href: youtrustUrl,
                  target: Target.blank,
                  attributes: const {'rel': 'noopener noreferrer'},
                  classes: 'freshColor',
                  [.text('YOUTRUST')],
                ),
                .text(
                  ' I build and improve a large-scale production app, and '
                  'contribute to technical direction, architecture, '
                  'performance, testing and developer experience.',
                ),
              ]),
              p([
                .text(
                  'I like digging deeper than the screens \u2014 Flutter '
                  'internals, shaders and rendering, native iOS integrations '
                  'and platform APIs. I\u2019m also a ',
                ),
                a(
                  href: gdeUrl,
                  target: Target.blank,
                  attributes: const {'rel': 'noopener noreferrer'},
                  classes: 'freshColor',
                  [.text('Flutter & Dart Google Developer Expert')],
                ),
                .text(' and an organizer of '),
                a(
                  href: flutterTokyoUrl,
                  target: Target.blank,
                  attributes: const {'rel': 'noopener noreferrer'},
                  classes: 'freshColor',
                  [.text('Flutter Tokyo')],
                ),
                .text(', where I share what I learn with the community.'),
              ]),
              p([
                .text(
                  'Before Flutter I worked across Android, iOS, web, Unity '
                  'and backend. That background still shapes how I work: '
                  'understand the whole product, experiment with new '
                  'technology, and turn ideas into things people can '
                  'actually use.',
                ),
              ]),
              p([
                .text(
                  'Outside of work I\u2019m usually building side projects, '
                  'experimenting with UI ideas, writing technical articles, '
                  'or preparing my next Flutter talk.',
                ),
              ]),
              div(classes: 'social social_icons', [
                for (final link in socialLinks)
                  Icon(
                    link.icon,
                    classes: 'social_icon',
                    events: events(onClick: () => openUrl(link.url)),
                  ),
              ]),
            ]),
          ]),
          div(classes: 'skills col-md-6', [
            div(classes: 'line-text', [
              h4([.text('My Skills')]),
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
