import 'dart:math' as math;

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

  /// What the tiles without a screenshot need.
  ///
  /// Articles and talks have nothing to show a picture of, so they stand in
  /// the grid as a panel carrying the title and where it was published or
  /// given. Everything else about the tile is unchanged: the same box, the
  /// same tilt, the same orange overlay on hover.
  @css
  static List<StyleRule> get styles => [
    // The ported grid lays the tiles out as inline blocks, so screenshots of
    // different proportions stagger their rows against each other. Flexing the
    // container and giving every tile the same height lines the rows up; the
    // ported `object-fit: cover` on the images does the rest.
    css('#portfolio .portfolio_container').styles(
      display: .flex,
      flexWrap: .wrap,
      alignItems: .start,
      raw: {
        // The All filter now holds every app, site, article and talk, more
        // than fits a section locked to the viewport. Rather than shrinking
        // the tiles until the writing is unreadable, the grid keeps a legible
        // floor and scrolls; the layout's wheel handler yields to it before
        // snapping on to the next section.
        'overflow-y': 'auto',
        'scrollbar-width': 'thin',
        'scrollbar-color': '#2c343f transparent',
      },
    ),
    // With every tile the same height the ported `cover` would crop a wide
    // screenshot down to a slice of itself, so the images are fitted inside
    // the box instead. The section is black, so the spare room does not read
    // as a letterbox.
    css('#portfolio .portfolio_item img').styles(raw: {'object-fit': 'contain'}),
    css('#portfolio .portfolio_card').styles(
      display: .flex,
      padding: .symmetric(vertical: 18.px, horizontal: 20.px),
      flexDirection: .column,
      justifyContent: .center,
      color: Colors.white,
      textAlign: .start,
      raw: {
        'border': '1px solid #2c343f',
        'background-color': '#08090c',
        'overflow': 'hidden',
      },
    ),
    css('#portfolio .portfolio_card .kind').styles(
      margin: .only(bottom: 10.px),
      color: _accent,
      fontSize: 10.px,
      fontWeight: .w600,
      textTransform: .upperCase,
      raw: {'letter-spacing': '1.5px'},
    ),
    css('#portfolio .portfolio_card .card_title').styles(
      color: Colors.white,
      fontSize: 16.px,
      fontWeight: .w600,
      lineHeight: 22.px,
      raw: {'overflow-wrap': 'break-word'},
    ),
    css('#portfolio .portfolio_card .card_meta').styles(
      margin: .only(top: 10.px),
      color: const Color('#bbb'),
      fontSize: 11.px,
      fontWeight: .w300,
    ),
    // The grid is six across at the All filter, where the type has to come
    // down with the box.
    css.media(const MediaQuery.raw('(min-width: 992px)'), [
      css('#portfolio .portfolio_container.dense .portfolio_card').styles(
        padding: .symmetric(vertical: 12.px, horizontal: 13.px),
      ),
      css('#portfolio .portfolio_container.dense .portfolio_card .kind').styles(
        margin: .only(bottom: 7.px),
        fontSize: 9.px,
      ),
      css('#portfolio .portfolio_container.dense .portfolio_card .card_title').styles(
        fontSize: 13.px,
        lineHeight: 18.px,
      ),
      css('#portfolio .portfolio_container.dense .portfolio_card .card_meta').styles(
        margin: .only(top: 7.px),
        fontSize: 10.px,
      ),
    ]),
  ];
}

const _accent = Color('#ffb035');

/// The shortest a tile may be, as a fraction of the section height. Below this
/// a card's title and source line start colliding with its own box.
const _minTileFactor = 0.22;

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
  ///
  /// The ported ladder stopped at four columns, which was enough for the
  /// eleven tiles it had. The All filter now holds every app, site, article
  /// and talk, and four columns would run it five rows deep in a section that
  /// does not scroll, so the ladder gains a wider step. Four tiles also move
  /// from two columns to one row: the ported pair of half-width tiles blew a
  /// square app icon up to the height of the section.
  int _columnsFor(int total) {
    if (total > 12) return 6;
    if (total > 6) return 4;
    if (total > 4) return 3;
    if (total == 4) return 4;
    if (total > 1) return 2;
    return 1;
  }

  String _itemWidth(SiteMetrics metrics, int columns) {
    if (metrics.isAuto) return '100%';
    return switch (columns) {
      6 => '16.6%',
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
                classes: 'portfolio_container${_columnsFor(_visibleItems.length) >= 6 ? ' dense' : ''}',
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
    final rows = (items.length / columns).ceil();

    // Mirrors the height factor of the React component, which shrank the tiles
    // for wide grids. Its four-item case is gone with the two-column step it
    // belonged to. A deep grid shrinks to fit the container, down to a floor:
    // past that the tiles stop being readable, so the container scrolls
    // instead.
    final ported = columns >= 3 ? 0.35 : 1.0;
    final factor = math.max(_minTileFactor, math.min(ported, 0.76 / rows));
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
                _face(item, maxHeight),
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

  /// The tile itself: a screenshot where there is one, a panel otherwise.
  Component _face(PortfolioItem item, double? maxHeight) {
    final image = item.image;
    if (image != null) {
      return img(
        src: image,
        alt: item.title,
        styles: Styles(
          raw: {
            // A height rather than a cap, so tiles of different proportions
            // still line up. The ported rule crops them to fit.
            'height': maxHeight == null ? 'auto' : '${maxHeight.toStringAsFixed(0)}px',
          },
        ),
      );
    }

    return div(
      classes: 'portfolio_card',
      styles: Styles(
        raw: {
          // A fixed height rather than a cap, so a panel lines up with the
          // screenshots beside it instead of collapsing onto its own text.
          'height': maxHeight == null ? 'auto' : '${maxHeight.toStringAsFixed(0)}px',
          if (maxHeight == null) 'min-height': '150px',
        },
      ),
      [
        span(classes: 'kind', [.text(item.category)]),
        span(classes: 'card_title', [.text(item.title)]),
        if (item.meta case final meta?) span(classes: 'card_meta', [.text(meta)]),
      ],
    );
  }
}
