import 'dart:async';

import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../interop/js_libs.dart' as js;

/// Fires a callback the first time an element scrolls into view.
///
/// This is the replacement for `react-in-viewport`, which every animated
/// component of the previous site was wrapped in. Mix it into a [State], attach
/// [viewportKey] to the element that should be observed and call
/// [watchViewport] from `initState`.
mixin ViewportAware<T extends StatefulComponent> on State<T> {
  /// Attach this to the component's outermost element.
  final GlobalNodeKey<web.HTMLElement> viewportKey = GlobalNodeKey();

  Timer? _pollTimer;
  bool _entered = false;

  /// Whether the element has scrolled into view at least once.
  bool get hasEnteredViewport => _entered;

  /// Starts observing, then calls [onEnter] exactly once.
  ///
  /// The element is not attached to the document yet while `initState` runs, so
  /// this polls briefly for the node before handing it to the observer.
  void watchViewport(void Function() onEnter) {
    if (!kIsWeb) return;

    var attempts = 0;
    void attach() {
      final node = viewportKey.currentNode;
      if (node == null) {
        attempts++;
        if (attempts > 50) return;
        _pollTimer = Timer(const Duration(milliseconds: 20), attach);
        return;
      }
      js.observeInViewport(node, () {
        if (_entered || !mounted) return;
        _entered = true;
        onEnter();
      });
    }

    _pollTimer = Timer(Duration.zero, attach);
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }
}
