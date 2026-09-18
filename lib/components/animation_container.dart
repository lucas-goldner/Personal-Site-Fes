import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'in_viewport.dart';

/// Fades its children in with an animate.css class once it scrolls into view.
///
/// Port of `src/components/animation-container`: the element stays at
/// `opacity: 0` until it has been visible for [delay] milliseconds, then the
/// `animated <animation>` classes are applied and it becomes opaque.
class AnimationContainer extends StatefulComponent {
  const AnimationContainer({
    required this.delay,
    required this.animation,
    required this.children,
    this.id,
    this.height,
    super.key,
  });

  /// Milliseconds to wait after entering the viewport.
  final int delay;

  /// animate.css classes, e.g. `fadeInLeft fast`.
  final String animation;

  final List<Component> children;

  final String? id;

  /// Optional fixed height; defaults to `auto` like the React component.
  final String? height;

  @override
  State<AnimationContainer> createState() => _AnimationContainerState();
}

class _AnimationContainerState extends State<AnimationContainer> with ViewportAware {
  bool _classChanged = false;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    watchViewport(() {
      _delayTimer = Timer(Duration(milliseconds: component.delay), () {
        if (!mounted) return;
        setState(() => _classChanged = true);
      });
    });
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return div(
      key: viewportKey,
      id: component.id,
      classes: _classChanged ? 'animated ${component.animation}' : null,
      styles: Styles(
        raw: {
          'opacity': _classChanged ? '1' : '0',
          'height': component.height ?? 'auto',
        },
      ),
      component.children,
    );
  }
}
