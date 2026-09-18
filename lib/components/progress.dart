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
}

class _ProgressState extends State<Progress> with ViewportAware {
  int _value = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    watchViewport(() {
      _timer = Timer(Duration(milliseconds: component.delay), () {
        if (!mounted) return;
        setState(() => _value = component.skill.value);
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
        styles: Styles(raw: {'width': '${_value * 20}%'}),
        const [],
      ),
    ]);
  }
}
