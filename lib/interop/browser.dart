/// Small browser helpers shared by the interactive parts of the site.
///
/// Everything here is guarded by [kIsWeb] so the same code can be pre-rendered
/// on the server during static generation.
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

/// The easing `scroll-to-element` used for the section snapping, ported from
/// the `ease` package's `inOutExpo`.
double inOutExpo(double t) {
  if (t == 0 || t == 1) return t;
  t *= 2;
  if (t < 1) return 0.5 * math.pow(1024, t - 1);
  return 0.5 * (-math.pow(2, -10 * (t - 1)) + 2);
}

/// The element that actually scrolls the document.
web.Element? get _scroller => web.document.scrollingElement ?? web.document.documentElement;

double _scrollTop() => _scroller?.scrollTop.toDouble() ?? 0;

void _setScrollTop(double value) {
  final scroller = _scroller;
  if (scroller != null) scroller.scrollTop = value;
}

/// Smoothly scrolls the window to the element with [elementId].
///
/// Mirrors `scrollToElement(el, {offset: 0, ease: 'in-out-expo', duration: 2000})`
/// from the React site and invokes [onEnd] once the animation finishes, which is
/// what released the wheel handler's `scrolling` guard.
void scrollToElement(
  String elementId, {
  Duration duration = const Duration(milliseconds: 2000),
  VoidCallback? onEnd,
}) {
  if (!kIsWeb) {
    onEnd?.call();
    return;
  }
  final element = web.document.getElementById(elementId);
  if (element == null) {
    onEnd?.call();
    return;
  }

  final start = _scrollTop();
  final target = element.getBoundingClientRect().top + start;
  final distance = target - start;
  final totalMs = duration.inMilliseconds;

  if (totalMs <= 0 || distance == 0) {
    _setScrollTop(target);
    onEnd?.call();
    return;
  }

  final stopwatch = Stopwatch()..start();
  Timer.periodic(const Duration(milliseconds: 16), (timer) {
    final elapsed = stopwatch.elapsedMilliseconds;
    if (elapsed >= totalMs) {
      timer.cancel();
      stopwatch.stop();
      _setScrollTop(target);
      onEnd?.call();
      return;
    }
    final progress = inOutExpo(elapsed / totalMs);
    _setScrollTop(start + distance * progress);
  });
}

/// Locks or releases page scrolling, replacing `react-scrolllock`.
///
/// The scrollbar width is compensated with padding so locking does not shift
/// the layout sideways.
void setBodyScrollLock({required bool locked}) {
  if (!kIsWeb) return;
  final body = web.document.body;
  if (body == null) return;

  if (locked) {
    final scrollbar = web.window.innerWidth - web.document.documentElement!.clientWidth;
    body.style.overflow = 'hidden';
    if (scrollbar > 0) {
      body.style.paddingRight = '${scrollbar}px';
    }
  } else {
    body.style.removeProperty('overflow');
    body.style.removeProperty('padding-right');
  }
}

/// Adds or removes a class on `<body>`.
void setBodyClass(String name, {required bool present}) {
  if (!kIsWeb) return;
  final body = web.document.body;
  if (body == null) return;
  if (present) {
    body.classList.add(name);
  } else {
    body.classList.remove(name);
  }
}

/// Opens [url] in a new tab, as every outbound link on the site did.
void openUrl(String url) {
  if (!kIsWeb) return;
  web.window.open(url);
}

/// The current viewport width, or 0 while pre-rendering.
int get viewportWidth => kIsWeb ? web.window.innerWidth : 0;

/// The current viewport height, or 0 while pre-rendering.
int get viewportHeight => kIsWeb ? web.window.innerHeight : 0;

/// Reloads the page, which the React layout did on every width change.
void reloadPage() {
  if (!kIsWeb) return;
  web.window.location.reload();
}

/// Runs [action] as soon as [isReady] returns true.
///
/// The vendored libraries are loaded by their own `<script>` tags, so this
/// removes any dependency on the order in which those and the Dart bundle run.
void whenReady(
  bool Function() isReady,
  void Function() action, {
  int maxAttempts = 100,
  Duration interval = const Duration(milliseconds: 20),
}) {
  if (!kIsWeb) return;
  if (isReady()) {
    action();
    return;
  }
  var attempts = 0;
  Timer.periodic(interval, (timer) {
    attempts++;
    if (isReady()) {
      timer.cancel();
      action();
    } else if (attempts >= maxAttempts) {
      timer.cancel();
    }
  });
}

/// The rendered height of an element, or 0 when it is missing or pre-rendering.
///
/// particles.js sizes its canvas from the container's box, so the container has
/// to be laid out before the library is started.
int elementHeight(String elementId) {
  if (!kIsWeb) return 0;
  return web.document.getElementById(elementId)?.clientHeight ?? 0;
}

/// Whether [event] lands on something that can still scroll itself.
///
/// The layout snaps the whole page from section to section on every wheel
/// event, which would make a scrollable box inside a section unreachable. This
/// walks up from the target looking for an ancestor that scrolls and still has
/// room to move in the direction of [delta]; when it finds one the layout
/// leaves the event alone and the browser scrolls that box instead.
bool wheelScrollsInnerBox(web.Event event, double delta) {
  if (!kIsWeb || delta == 0) return false;

  // Node types rather than `is web.Element`: the interop types erase to the
  // same representation, so a type test against one matches every node and
  // then reads properties a text node does not have.
  const elementNode = 1;

  var node = event.target as web.Node?;
  while (node != null) {
    if (node.nodeType == elementNode) {
      final element = node as web.Element;
      final scrollable = element.scrollHeight - element.clientHeight;
      if (scrollable > 1) {
        final overflow = web.window.getComputedStyle(element).overflowY;
        if (overflow == 'auto' || overflow == 'scroll') {
          final top = element.scrollTop;
          if (delta > 0 ? top < scrollable - 1 : top > 1) return true;
        }
      }
    }
    node = node.parentNode;
  }
  return false;
}
