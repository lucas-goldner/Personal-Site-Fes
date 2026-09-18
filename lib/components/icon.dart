import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'icons_data.dart';

export 'icons_data.dart';

/// Renders a Font Awesome glyph as inline SVG.
///
/// The element and its classes reproduce what `<FontAwesomeIcon>` emitted on the
/// previous site, so the existing CSS selectors (`.social_icon`, `.closeNav`,
/// `.icon svg`, `.solid`) keep matching.
class Icon extends StatelessComponent {
  const Icon(this.icon, {this.classes, this.events, super.key});

  final FaIcon icon;

  /// Extra classes appended after the Font Awesome ones.
  final String? classes;

  final Map<String, EventCallback>? events;

  @override
  Component build(BuildContext context) {
    final faClasses =
        'svg-inline--fa fa-${icon.name} fa-w-${icon.faWidth}'
        '${classes != null ? ' $classes' : ''}';

    return svg(
      viewBox: '0 0 ${icon.width} ${icon.height}',
      classes: faClasses,
      attributes: {
        'aria-hidden': 'true',
        'focusable': 'false',
        'data-prefix': icon.prefix,
        'data-icon': icon.name,
        'role': 'img',
        'xmlns': 'http://www.w3.org/2000/svg',
      },
      events: events,
      [
        path(d: icon.path, fill: Color.currentColor, const []),
      ],
    );
  }
}
