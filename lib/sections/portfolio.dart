import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/animation_container.dart';
import '../components/baffle_text.dart';
import '../components/tilt_box.dart';
import '../data/site_data.dart';
import '../layout/metrics.dart';

/// The filterable project grid.
class Portfolio extends StatefulComponent {
  const Portfolio({super.key});

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  /// Null means the "All" filter.
  String? _category;

  /// Set once the rotated "Portfolio" heading has finished resolving.
  bool _show = false;

  /// The distinct categories, in the order the items declare them.
  List<String> get _categories => <String>{for (final item in portfolioItems) item.category}.toList();

  List<PortfolioItem> get _visibleItems => [
    for (final item in portfolioItems)
      if (_category == null || item.category == _category) item,
  ];

  /// The column count the React component derived from the number of tiles.
  int _columnsFor(int total) {
    if (total > 6) return 4;
    if (total > 4) return 3;
    if (total > 3) return 2;
    if (total > 1) return 2;
    return 1;
  }

  String _itemWidth(SiteMetrics metrics, int columns) {
    if (metrics.isAuto) return '100%';
    return switch (columns) {
      4 => '25%',
      3 => '33.3%',
      2 => '50%',
      _ => '100%',
    };
  }

  @override
  Component build(BuildContext context) {
    final metrics = MetricsProvider.of(context);
    final containerMaxHeight = metrics.fraction(0.8);

    return section(
      id: 'portfolio',
      classes: 'portfolio',
      styles: Styles(raw: {'height': metrics.cssHeight}),
      [
        div(classes: 'row', [
          div(classes: 'side col-md-2', [
            h2([
              BaffleText(
                text: 'Portfolio',
                revealDuration: 500,
                revealDelay: 500,
                revealCallbackDelay: 1100,
                onRevealed: () => setState(() => _show = true),
              ),
            ]),
          ]),
          div(classes: 'recent-works col-md-10', [
            div(classes: 'portfolio_selector', [
              button(
                classes: 'portfolio_category',
                onClick: () => setState(() => _category = null),
                [
                  span(
                    classes: _category == null ? 'active' : null,
                    [.text('All')],
                  ),
                ],
              ),
              for (final category in _categories)
                button(
                  classes: 'portfolio_category',
                  onClick: () => setState(() => _category = category),
                  [
                    span(
                      classes: _category == category ? 'active' : null,
                      [.text(category)],
                    ),
                  ],
                ),
            ]),
            div(classes: 'content', [
              div(
                classes: 'portfolio_container',
                styles: Styles(
                  raw: {
                    'max-height': containerMaxHeight == null ? 'inherit' : '${containerMaxHeight.toStringAsFixed(0)}px',
                  },
                ),
                _tiles(metrics),
              ),
            ]),
          ]),
        ]),
      ],
    );
  }

  List<Component> _tiles(SiteMetrics metrics) {
    if (!_show && !metrics.isAuto) return const [];

    final items = _visibleItems;
    final columns = _columnsFor(items.length);
    final width = _itemWidth(metrics, columns);

    // Mirrors the height factor of the React component, which shrank the tiles
    // for wide grids and for the four-item case.
    final factor = columns >= 3
        ? 0.35
        : items.length == 4
        ? 0.36
        : 1.0;
    final maxHeight = metrics.isAuto ? null : metrics.height * factor;

    return [
      for (final item in items)
        div(
          // Keyed by id so switching category rebuilds the tiles rather than
          // reusing a tilt handler bound to a different image. Links are not
          // unique: the FlowUs app and its landing page share one.
          key: ValueKey(item.id),
          classes: 'portfolio_item',
          styles: Styles(raw: {'width': width}),
          [
            AnimationContainer(
              delay: 200,
              animation: 'fadeIn',
              children: [
                img(
                  src: item.image,
                  alt: item.title,
                  styles: Styles(
                    raw: {
                      'max-height': maxHeight == null ? 'inherit' : '${maxHeight.toStringAsFixed(0)}px',
                    },
                  ),
                ),
                TiltBox(
                  children: [
                    div(classes: 'overlay', [
                      a(
                        href: item.link,
                        target: Target.blank,
                        attributes: const {'rel': 'noopener noreferrer'},
                        classes: 'title whiteColor',
                        [.text(item.title)],
                      ),
                    ]),
                  ],
                ),
              ],
            ),
          ],
        ),
    ];
  }
}
