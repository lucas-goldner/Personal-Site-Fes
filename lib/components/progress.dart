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
  /// "AI-Assisted Development - Harness / Claude Code" runs straight into. The
  /// row becomes a wrapping flex line instead: the name takes the space that is
  /// left and wraps within it, the label stays on one line at the right, and the
  /// bar keeps a full-width line of its own. Type, colours and spacing are
  /// untouched.
  @css
  static List<StyleRule> get styles => [
    css('.progress-container', [
      css('&').styles(
        display: .flex,
        flexWrap: .wrap,
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
      css('.progress').styles(raw: {'flex': '0 0 100%'}),
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
      span(classes: 'name', [.text(component.skill.name)]),
      span(classes: 'value', [.text(component.skill.label)]),
      div(
        classes: 'progress',
        styles: Styles(raw: {'width': '$_percent%'}),
        const [],
      ),
    ]);
  }
}
