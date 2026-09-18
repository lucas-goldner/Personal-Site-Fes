import 'package:jaspr/jaspr.dart';

/// The viewport metrics the sections size themselves against.
///
/// This replaces the `ThemeContext` of the React site, which carried a single
/// `height` value that was either the window height in pixels or the string
/// `"auto"` once the layout collapsed to its mobile form.
@immutable
class SiteMetrics {
  const SiteMetrics({required this.isAuto, required this.height});

  /// Server-side and first-paint value.
  ///
  /// The React site started at `height: 0` too and only measured the window in
  /// `componentDidMount`, so the pre-rendered markup matches what Gatsby shipped.
  const SiteMetrics.initial() : isAuto = false, height = 0;

  /// Whether sections size themselves to their content instead of the viewport.
  ///
  /// True below 992px, mirroring the old `mobile` flag.
  final bool isAuto;

  /// The viewport height in pixels; meaningless while [isAuto] is true.
  final double height;

  /// Value for a section's inline `height`.
  String get cssHeight => isAuto ? 'auto' : '${height.toStringAsFixed(0)}px';

  /// A fraction of the viewport height, or null when sections are auto-sized.
  ///
  /// Callers render `inherit` for null, as the React code did.
  double? fraction(double factor) => isAuto ? null : height * factor;

  @override
  bool operator ==(Object other) => other is SiteMetrics && other.isAuto == isAuto && other.height == height;

  @override
  int get hashCode => Object.hash(isAuto, height);
}

/// Provides [SiteMetrics] to the sections below it.
class MetricsProvider extends InheritedComponent {
  const MetricsProvider({required this.metrics, required super.child, super.key});

  final SiteMetrics metrics;

  static SiteMetrics of(BuildContext context) {
    final provider = context.dependOnInheritedComponentOfExactType<MetricsProvider>();
    return provider?.metrics ?? const SiteMetrics.initial();
  }

  @override
  bool updateShouldNotify(MetricsProvider oldComponent) => oldComponent.metrics != metrics;
}
