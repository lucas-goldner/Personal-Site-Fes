import 'dart:async';
import 'dart:math' as math;

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/site_data.dart';
import 'icon.dart';
import 'in_viewport.dart';

/// One of the three figures in the strip below the services.
///
/// Port of `src/components/counter`, which combined `react-countup` with
/// `react-in-viewport`. The count-up uses CountUp.js's default `easeOutExpo`
/// and no thousands separator, matching `react-countup`'s `separator: ''`.
class Counter extends StatefulComponent {
  const Counter(this.data, {super.key});

  final CounterData data;

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> with ViewportAware {
  static const _frame = Duration(milliseconds: 16);

  int _value = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    watchViewport(_countUp);
  }

  /// CountUp.js's default easing.
  double _easeOutExpo(double t, double change, double duration) =>
      change * (-math.pow(2, -10 * t / duration) + 1) * 1024 / 1023;

  void _countUp() {
    final durationMs = component.data.duration * 1000;
    final end = component.data.value.toDouble();
    final stopwatch = Stopwatch()..start();

    _timer = Timer.periodic(_frame, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final elapsed = stopwatch.elapsedMilliseconds.toDouble();
      if (elapsed >= durationMs) {
        timer.cancel();
        stopwatch.stop();
        setState(() => _value = component.data.value);
        return;
      }
      setState(() {
        _value = _easeOutExpo(elapsed, end, durationMs.toDouble()).round();
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
    return div(key: viewportKey, classes: 'counter_component', [
      div(classes: 'icon', [Icon(component.data.icon)]),
      div(classes: 'value', [
        span([.text('$_value')]),
        span(classes: 'symbol', [.text(component.data.symbol)]),
      ]),
      div(classes: 'text', [.text(component.data.text)]),
    ]);
  }
}
