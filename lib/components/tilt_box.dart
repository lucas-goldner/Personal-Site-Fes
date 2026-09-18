import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../interop/browser.dart';
import '../interop/js_libs.dart' as js;

/// The 3D hover container around a portfolio tile.
///
/// Replaces `react-tilt`, which wrapped vanilla-tilt with
/// `{scale: 1, max: 50}`; those options now live in `web/js/site-interop.js`.
class TiltBox extends StatefulComponent {
  const TiltBox({required this.children, super.key});

  final List<Component> children;

  @override
  State<TiltBox> createState() => _TiltBoxState();
}

class _TiltBoxState extends State<TiltBox> {
  final _key = GlobalNodeKey<web.HTMLElement>();
  Timer? _attachTimer;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;
    // The node only exists after the first render, so wait for it and for
    // vanilla-tilt to have been evaluated.
    _attachTimer = Timer(Duration.zero, () {
      whenReady(
        () => js.tiltReady() && _key.currentNode != null,
        () {
          final node = _key.currentNode;
          if (node != null) js.initTilt(node);
        },
      );
    });
  }

  @override
  void dispose() {
    _attachTimer?.cancel();
    final node = _key.currentNode;
    if (node != null) js.destroyTilt(node);
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return div(key: _key, classes: 'Tilt', component.children);
  }
}
