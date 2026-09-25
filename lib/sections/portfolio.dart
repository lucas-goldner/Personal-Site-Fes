import 'dart:async';
import 'dart:math' as math;

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../components/animation_container.dart';
import '../components/baffle_text.dart';
import '../components/icon.dart';
import '../components/tilt_box.dart';
import '../data/site_data.dart';
import '../interop/js_libs.dart' as js;
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
    ),
    // With every tile the same height the ported `cover` would crop a wide
    // screenshot down to a slice of itself, so the images are fitted inside
    // the box instead. The section is black, so the spare room does not read
    // as a letterbox.
    css('#portfolio .portfolio_item img').styles(raw: {'object-fit': 'contain'}),
    // A page of two rows leaves each tile half the section to itself, which
    // is far more than a screenshot or a title and a source line need. The
    // tiles take their height from their own width instead and only fall back
    // to the cap the grid gives them when that is the smaller of the two.
    css('#portfolio .portfolio_item img, #portfolio .portfolio_card').styles(
      width: 100.percent,
      height: .auto,
      raw: {'aspect-ratio': '1 / 1'},
    ),
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
      raw: {
        'overflow-wrap': 'break-word',
        // A long title is cut off rather than pushed out of a box that cannot
        // grow. Nothing is lost: hovering the tile shows the whole title.
        'display': '-webkit-box',
        '-webkit-box-orient': 'vertical',
        '-webkit-line-clamp': '4',
        'overflow': 'hidden',
      },
    ),
    css('#portfolio .portfolio_card .card_meta').styles(
      margin: .only(top: 10.px),
      color: const Color('#bbb'),
      fontSize: 11.px,
      fontWeight: .w300,
      raw: {
        'display': '-webkit-box',
        '-webkit-box-orient': 'vertical',
        '-webkit-line-clamp': '2',
        'overflow': 'hidden',
      },
    ),
    // One page of tiles at a time, stepped through with the arrows. On a
    // phone they sit under the grid; from the desktop breakpoint up they move
    // out into the column's own padding, one on each side of the grid.
    // The ported rule ruled each name itself, growing the line out from the
    // middle of whichever was active. There is one rule for the row now, so
    // it travels between names instead.
    css('#portfolio .portfolio_category span:after').styles(
      raw: {'content': 'none'},
    ),
    // The ported rule puts a 40px gap after `.portfolio_category span`, which
    // reaches the count nested inside the label as well as the label itself.
    // Both of those margins widened the label's box past its own text and took
    // the rule with them, so both are cleared and the gap moves to the button.
    css('#portfolio .portfolio_label').styles(
      display: .inlineBlock,
      padding: .only(bottom: 0.px),
      lineHeight: 20.px,
      raw: {
        'margin-right': '0',
        // A name and its count belong on one line; the row wraps between
        // filters instead, which it has to do on a narrow screen.
        'white-space': 'nowrap',
        'transition': 'color .3s ease',
      },
    ),
    css('#portfolio .portfolio_selector').styles(flexWrap: .wrap),
    css('#portfolio .portfolio_category .count').styles(
      margin: .only(right: 0.px),
    ),
    // The line marks the active filter, so hovering says so in colour.
    css('#portfolio .portfolio_category:hover .portfolio_label').styles(
      color: _accent,
    ),
    css('#portfolio .portfolio_underline').styles(
      position: .absolute(left: 0.px, top: 0.px),
      height: 2.px,
      backgroundColor: _accent,
      raw: {
        'transform-origin': 'left',
        'transition':
            'transform .35s cubic-bezier(.4, 0, .2, 1),'
            ' width .35s cubic-bezier(.4, 0, .2, 1), opacity .2s ease',
        'pointer-events': 'none',
      },
    ),
    // Dimmer and smaller than the name it follows, so the row still reads as
    // a set of filters rather than a table of figures.
    css('#portfolio .portfolio_category .count').styles(
      color: const Color('#8d8d8d'),
      fontWeight: .w300,
      raw: {'font-size': '.75em'},
    ),
    css('#portfolio .portfolio_nav').styles(
      display: .flex,
      margin: .only(top: 20.px),
      alignItems: .center,
      justifyContent: .center,
      gap: Gap(column: 20.px),
    ),
    css('#portfolio .portfolio_arrow', [
      css('&').styles(
        display: .flex,
        width: 38.px,
        height: 38.px,
        alignItems: .center,
        justifyContent: .center,
        color: Colors.white,
        raw: {
          'background-color': 'transparent',
          'border': '1px solid #2c343f',
          'border-radius': '50%',
          'cursor': 'pointer',
          'transition': 'color .3s ease, border-color .3s ease',
        },
      ),
      css('&:hover').styles(raw: {'color': '#ffb035', 'border-color': '#ffb035'}),
      css('&:focus-visible').styles(raw: {'outline': '2px solid #ffb035', 'outline-offset': '2px'}),
      css('& svg').styles(width: .auto, height: 14.px),
    ]),
    css('#portfolio .portfolio_pages').styles(
      color: const Color('#bbb'),
      fontSize: 12.px,
      fontWeight: .w300,
      raw: {'letter-spacing': '1px', 'font-variant-numeric': 'tabular-nums'},
    ),
    css.media(const MediaQuery.raw('(min-width: 992px)'), [
      css('#portfolio .portfolio_category').styles(
        margin: .only(right: 40.px),
      ),
      css('#portfolio .portfolio_category:last-of-type').styles(
        margin: .only(right: 0.px),
      ),
      css('#portfolio .content').styles(position: .relative()),
      // .content is positioned now, so without this it paints over the filter
      // row above it and swallows the clicks.
      css('#portfolio .portfolio_selector').styles(zIndex: const ZIndex(2)),
      // Dimmer and smaller than the name it follows, so the row still reads as
      // a set of filters rather than a table of figures.
      css('#portfolio .portfolio_category .count').styles(
        color: const Color('#8d8d8d'),
        fontWeight: .w300,
        raw: {'font-size': '.75em'},
      ),
      css('#portfolio .portfolio_nav').styles(margin: .only(top: 14.px)),
      // Out in the 5% padding the column already carries, so the arrows never
      // sit on top of a tile.
      css('#portfolio .portfolio_arrow').styles(
        position: .absolute(top: 50.percent),
        raw: {'transform': 'translateY(-50%)'},
      ),
      css('#portfolio .portfolio_arrow.prev').styles(position: .absolute(left: (-46).px)),
      css('#portfolio .portfolio_arrow.next').styles(position: .absolute(right: (-46).px)),
    ]),
    // The grid is five across on a full page, where the type has to come
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
        raw: {'-webkit-line-clamp': '3'},
      ),
      css('#portfolio .portfolio_container.dense .portfolio_card .card_meta').styles(
        margin: .only(top: 7.px),
        fontSize: 10.px,
      ),
    ]),
  ];
}

const _accent = Color('#ffb035');

/// How many tiles a page of the grid holds.
///
/// The section is locked to the viewport height and does not scroll, so the
/// grid can only ever be as deep as fits; everything past this is a page of
/// its own, reached with the arrows.
const _pageSize = 10;

/// The share of the section height the grid and its arrows may take.
///
/// The filter row sits absolutely at 8% of the section and the block below it
/// is centred, so a block taller than this would slide up under the filters.
const _gridFraction = 0.76;

/// `margin-bottom` on a tile, from the ported rules, which sits under every
/// row and so has to come out of the budget along with the tiles themselves.
const _tileGap = 10.0;

/// The arrows and page counter under the grid, with their margin.
const _navHeight = 34.0;

class _PortfolioState extends State<Portfolio> {
  /// Null means the "All" filter.
  String? _category;

  /// Which page of the current filter is on screen.
  int _page = 0;

  /// Where the shared underline sits, measured from the filter row's left
  /// edge, and how wide it is. Both are zero until the first measurement,
  /// which is also what keeps it hidden until there is something to show.
  final _selectorKey = GlobalNodeKey<web.HTMLElement>();
  double _underlineLeft = 0;
  double _underlineTop = 0;
  double _underlineWidth = 0;
  int? _resizeToken;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;
    // The row is laid out by the time this runs a turn later, and the labels
    // move with the viewport, so the measurement is redone on a resize.
    Timer.run(_measureUnderline);
    _resizeToken = js.addResizeListener(_measureUnderline);
  }

  @override
  void dispose() {
    final token = _resizeToken;
    if (kIsWeb && token != null) js.removeResizeListener(token);
    super.dispose();
  }

  /// Puts the underline under the active filter's own text.
  ///
  /// Measured rather than styled: the labels are different widths, and a rule
  /// sized with a percentage would take in the gap the ported stylesheet puts
  /// after each one.
  void _measureUnderline() {
    if (!kIsWeb) return;
    final row = _selectorKey.currentNode;
    if (row == null) return;

    final index = _category == null ? 0 : _categories.indexOf(_category!) + 1;
    final labels = row.querySelectorAll('.portfolio_label');
    if (index < 0 || index >= labels.length) return;
    final label = labels.item(index);
    if (label == null) return;

    final rowBox = row.getBoundingClientRect();
    final box = (label as web.Element).getBoundingClientRect();
    final left = box.left - rowBox.left;
    // Measured against the label rather than pinned to the bottom of the row,
    // so the rule still sits under its own name when the row wraps onto a
    // second line on a narrow screen.
    final top = box.bottom - rowBox.top + 3;
    final width = box.width;
    if (left == _underlineLeft && top == _underlineTop && width == _underlineWidth) {
      return;
    }
    if (!mounted) return;
    setState(() {
      _underlineLeft = left;
      _underlineTop = top;
      _underlineWidth = width;
    });
  }

  /// Set once the rotated "Portfolio" heading has finished resolving.
  bool _show = false;

  /// The distinct categories, in the order the items declare them.
  List<String> get _categories => <String>{for (final item in portfolioItems) item.category}.toList();

  List<PortfolioItem> get _visibleItems => [
    for (final item in portfolioItems)
      if (_category == null || item.category == _category) item,
  ];

  int get _pageCount => (_visibleItems.length / _pageSize).ceil().clamp(1, 1 << 30);

  /// How many tiles a filter holds, for the number beside its name. All is
  /// left without one: it is the total, which the others already add up to.
  int _countFor(String category) => portfolioItems.where((item) => item.category == category).length;

  /// How many tiles the grid is laid out for.
  ///
  /// A full page, unless the whole filter is smaller than one. Sizing from the
  /// tiles actually on screen would blow the last page up whenever it held a
  /// couple of leftovers.
  int get _layoutCount => math.min(_pageSize, _visibleItems.length);

  /// The tiles on screen: one page of the current filter.
  List<PortfolioItem> get _pageItems => _visibleItems.skip(_page * _pageSize).take(_pageSize).toList();

  void _select(String? category) {
    setState(() {
      _category = category;
      _page = 0;
    });
    // After the rebuild, so the label being measured is the active one.
    if (kIsWeb) Timer.run(_measureUnderline);
  }

  /// Steps the page, wrapping at either end so the arrows never dead-end.
  void _step(int by) => setState(() {
    final count = _pageCount;
    _page = (_page + by + count) % count;
  });

  /// The column count the React component derived from the number of tiles.
  ///
  /// The ported ladder stopped at four columns, which was enough for the
  /// eleven tiles it had. A full page is five across in two rows, and four
  /// tiles move from two columns to one row: the ported pair of half-width
  /// tiles blew a square app icon up to the height of the section.
  int _columnsFor(int total) {
    if (total > 8) return 5;
    if (total > 6) return 4;
    if (total > 4) return 3;
    if (total == 4) return 4;
    if (total > 1) return 2;
    return 1;
  }

  String _itemWidth(SiteMetrics metrics, int columns) {
    if (metrics.isAuto) return '100%';
    return switch (columns) {
      5 => '20%',
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
            div(key: _selectorKey, classes: 'portfolio_selector', [
              button(
                classes: 'portfolio_category',
                onClick: () => _select(null),
                [
                  span(
                    classes: 'portfolio_label${_category == null ? ' active' : ''}',
                    [.text('All')],
                  ),
                ],
              ),
              for (final category in _categories)
                button(
                  classes: 'portfolio_category',
                  onClick: () => _select(category),
                  [
                    span(
                      classes: 'portfolio_label${_category == category ? ' active' : ''}',
                      [
                        .text(category),
                        span(classes: 'count', [
                          .text(' (${_countFor(category)})'),
                        ]),
                      ],
                    ),
                  ],
                ),
              // One rule for the whole row rather than one per filter, so it
              // travels to whichever name was pressed instead of each name
              // growing its own.
              div(
                classes: 'portfolio_underline',
                styles: Styles(
                  raw: {
                    'width': '${_underlineWidth.toStringAsFixed(1)}px',
                    'transform':
                        'translate(${_underlineLeft.toStringAsFixed(1)}px,'
                        ' ${_underlineTop.toStringAsFixed(1)}px)',
                    'opacity': _underlineWidth > 0 ? '1' : '0',
                  },
                ),
                const [],
              ),
            ]),
            div(classes: 'content', [
              div(
                classes: 'portfolio_container${_columnsFor(_layoutCount) >= 5 ? ' dense' : ''}',
                styles: Styles(
                  raw: {
                    'max-height': containerMaxHeight == null ? 'inherit' : '${containerMaxHeight.toStringAsFixed(0)}px',
                  },
                ),
                _tiles(metrics),
              ),
              _nav(metrics),
            ]),
          ]),
        ]),
      ],
    );
  }

  List<Component> _tiles(SiteMetrics metrics) {
    if (!_show && !metrics.isAuto) return const [];

    final items = _pageItems;
    final columns = _columnsFor(_layoutCount);
    final width = _itemWidth(metrics, columns);
    final rows = (_layoutCount / columns).ceil();

    // Mirrors the height factor of the React component, which shrank the tiles
    // for wide grids. Its four-item case is gone with the two-column step it
    // belonged to. Nothing here scrolls, so a deeper grid always shrinks to
    // the room it has; what will not fit legibly goes on the next page.
    final ported = columns >= 3 ? 0.35 : 1.0;
    final forRows = _gridFraction * metrics.height - (_pageCount > 1 ? _navHeight : 0);
    final perRow = forRows / rows - _tileGap;
    final factor = math.min(ported, perRow / (metrics.height == 0 ? 1 : metrics.height));
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

  /// The arrows and the page counter, or nothing when the filter fits a page.
  Component _nav(SiteMetrics metrics) {
    if ((!_show && !metrics.isAuto) || _pageCount < 2) return const Component.empty();

    return div(classes: 'portfolio_nav', [
      button(
        classes: 'portfolio_arrow prev',
        attributes: const {'aria-label': 'Previous page', 'type': 'button'},
        onClick: () => _step(-1),
        [const Icon(faChevronLeft)],
      ),
      span(classes: 'portfolio_pages', [.text('${_page + 1} / $_pageCount')]),
      button(
        classes: 'portfolio_arrow next',
        attributes: const {'aria-label': 'Next page', 'type': 'button'},
        onClick: () => _step(1),
        [const Icon(faChevronRight)],
      ),
    ]);
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
            'max-height': maxHeight == null ? 'none' : '${maxHeight.toStringAsFixed(0)}px',
          },
        ),
      );
    }

    return div(
      classes: 'portfolio_card',
      styles: Styles(
        raw: {
          // The cap the grid allows; the square aspect takes it from there, so
          // a panel lines up with the screenshots beside it rather than
          // collapsing onto its own text.
          'max-height': maxHeight == null ? 'none' : '${maxHeight.toStringAsFixed(0)}px',
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
