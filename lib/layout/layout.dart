import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../data/site_data.dart';
import '../interop/browser.dart';
import '../interop/js_libs.dart' as js;
import 'metrics.dart';
import 'navigation.dart';

/// Measures the viewport, locks scrolling on desktop and snaps the wheel from
/// one section to the next.
///
/// Port of `src/components/layout`, including the quirks that were part of how
/// the site felt: the wheel never wraps past the first or last section, and any
/// change of the window width reloads the page.
class Layout extends StatefulComponent {
  const Layout({required this.children, super.key});

  final List<Component> children;

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  /// Below this width sections size themselves to their content.
  static const _mobileBreakpoint = 992;

  /// Below this width the page scrolls normally instead of snapping.
  static const _scrollLockBreakpoint = 1025;

  var _metrics = const SiteMetrics.initial();
  var _width = 0;

  /// Index of the section the wheel handler will move away from.
  var _sectionIndex = 0;

  /// Guards against starting a second scroll while one is running.
  var _scrolling = false;

  int? _resizeToken;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;

    // The React layout also measured only after mounting, so the pre-rendered
    // markup keeps the zero height it shipped with.
    setBodyClass('no-overflow', present: true);
    _applyDefaults();

    _resizeToken = js.addResizeListener(_onResize);
  }

  void _applyDefaults() {
    final width = viewportWidth;
    final height = viewportHeight;
    final isAuto = width < _mobileBreakpoint;
    final locked = width >= _scrollLockBreakpoint;

    setState(() {
      _width = width;
      _metrics = SiteMetrics(isAuto: isAuto, height: isAuto ? 0 : height.toDouble());
    });
    setBodyScrollLock(locked: locked);
  }

  void _onResize() {
    // Matches the original behaviour: a width change reloads rather than
    // trying to re-lay-out the snapped sections.
    if (_width != viewportWidth) {
      reloadPage();
      return;
    }
    _applyDefaults();
  }

  void _onWheel(web.Event event) {
    if (_scrolling || _metrics.isAuto) return;
    final delta = (event as web.WheelEvent).deltaY;
    // A section may hold more than fits, and its own scrolling comes first.
    if (wheelScrollsInnerBox(event, delta)) return;

    final last = sectionIds.length - 1;
    if (delta < 0) {
      // Never wraps from the first section round to the last.
      if (_sectionIndex > 0) _sectionIndex--;
    } else {
      if (_sectionIndex != last) _sectionIndex++;
    }

    _scrolling = true;
    scrollToElement(
      sectionIds[_sectionIndex],
      onEnd: () => _scrolling = false,
    );
  }

  @override
  void dispose() {
    final token = _resizeToken;
    if (kIsWeb && token != null) {
      js.removeResizeListener(token);
    }
    setBodyScrollLock(locked: false);
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return MetricsProvider(
      metrics: _metrics,
      child: div([
        Navigation(
          onSectionChanged: (index) => _sectionIndex = index,
        ),
        div(
          events: {'wheel': _onWheel},
          component.children,
        ),
      ]),
    );
  }
}
