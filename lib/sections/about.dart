import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/icon.dart';
import '../components/progress.dart';
import '../data/site_data.dart';
import '../interop/browser.dart';
import '../interop/js_libs.dart' as js;
import '../layout/metrics.dart';

/// The about text with the particle background, plus the skill bars.
class About extends StatefulComponent {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  static const _particlesId = 'particles-js';

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
              h3([.text("I'm an App and Web Developer")]),
              div(classes: 'separator', const []),
              p([
                .text(
                  'Creating something from the ground up, entirely by '
                  'myself, has always been my passion. I started to get into '
                  'programming by making my own small game in Unity. After '
                  'that, I started learning Java and got into Android App '
                  'Development. After that, I tried out web development, '
                  'HTML, CSS, JS, React. And other frameworks to code '
                  'landing pages and earn some money. By working as a Front '
                  'End Engineer, I made enough to buy myself a Mac and '
                  'iPhone, so I could also start developing for iOS. During '
                  'my fourth semester, I learned Python, and at my '
                  'internship at ',
                ),
                a(
                  href: 'https://bitfactory.io',
                  classes: 'freshColor',
                  [.text('Bitfactory ')],
                ),
                .text('I worked as a Flutter Developer.'),
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
