import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/site_data.dart';
import 'in_viewport.dart';

/// A skill bar in the about section.
///
/// Port of `src/components/progress`: the bar grows to `value * 20%` once the
/// element has been in the viewport for [delay] milliseconds, with the 2s CSS
/// transition doing the actual animation.
class Progress extends StatefulComponent {
  const Progress(this.skill, {this.delay = 1100, super.key});

  final Skill skill;

  /// Milliseconds between entering the viewport and growing the bar.
  final int delay;

  @override
  State<Progress> createState() => _ProgressState();

  /// Lets a long skill name share its line with the right-aligned label.
  ///
  /// The ported rule floats the label right, which a name like
  /// "AI-Assisted Development - Harness / Claude Code" runs straight into. Only
  /// the name/label header becomes a flex line; the bar stays a plain block so
  /// its inline percentage width still sizes it and still animates. Making the
  /// whole row a flex container would give the bar a flex-basis, which wins
  /// over width and would peg every bar to full width.
  @css
  static List<StyleRule> get styles => [
    css('.progress-container .progress-head', [
      css('&').styles(
        display: .flex,
        justifyContent: .spaceBetween,
        raw: {'align-items': 'baseline', 'column-gap': '16px'},
      ),
      // Basis 0 rather than auto: the name takes whatever the label leaves and
      // wraps inside it, instead of claiming its full width and pushing the
      // label onto a line of its own where it would lose its right alignment.
      css('.name').styles(raw: {'flex': '1 1 0%', 'min-width': '0'}),
      css('.value').styles(
        raw: {
          'float': 'none',
          'flex': '0 0 auto',
          'margin-left': 'auto',
          'white-space': 'nowrap',
        },
      ),
    ]),
  ];
}

class _ProgressState extends State<Progress> with ViewportAware {
  int _percent = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    watchViewport(() {
      _timer = Timer(Duration(milliseconds: component.delay), () {
        if (!mounted) return;
        setState(() => _percent = component.skill.percent);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return div(key: viewportKey, classes: 'progress-container', [
      div(classes: 'progress-head', [
        span(classes: 'name', [.text(component.skill.name)]),
        span(classes: 'value', [.text(component.skill.label)]),
      ]),
      div(
        classes: 'progress',
        styles: Styles(raw: {'width': '$_percent%'}),
        const [],
      ),
    ]);
  }
}
