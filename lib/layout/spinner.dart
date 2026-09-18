import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../interop/browser.dart';

/// The orange loading overlay shown while the page settles.
///
/// Port of `src/components/spinner`: it covers the viewport for [duration],
/// fades out over the CSS transition and is then dropped from the tree, which
/// is what the original achieved by removing the node from the DOM.
class Spinner extends StatefulComponent {
  const Spinner({this.duration = const Duration(milliseconds: 1000), super.key});

  final Duration duration;

  @override
  State<Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<Spinner> {
  bool _spin = true;
  bool _removed = false;
  Timer? _hideTimer;
  Timer? _removeTimer;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;
    _hideTimer = Timer(component.duration, () {
      if (!mounted) return;
      setState(() => _spin = false);
      setBodyClass('no-overflow', present: false);
      _removeTimer = Timer(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() => _removed = true);
      });
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _removeTimer?.cancel();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    if (_removed) return const Component.empty();

    return div(
      id: 'spinner',
      classes: 'spinner-container${_spin ? ' show' : ''}',
      [
        div(classes: 'spinner', [
          div(classes: 'ring', const []),
          div(classes: 'dot', const []),
        ]),
      ],
    );
  }
}
