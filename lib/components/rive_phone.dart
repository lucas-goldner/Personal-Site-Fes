import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../data/site_data.dart';
import '../interop/browser.dart';
import '../interop/js_libs.dart' as js;
import 'in_viewport.dart';

/// A Rive file playing inside a phone-shaped frame.
///
/// The frame is drawn in CSS rather than shipped as an image: a rounded shell
/// in the panel grey the rest of the site uses, a black screen inset in it and
/// the pill of a dynamic island over the top of that. The file itself is a
/// playable game, so the screen is where the pointer events land.
class RivePhone extends StatefulComponent {
  const RivePhone({super.key});

  @override
  State<RivePhone> createState() => _RivePhoneState();

  @css
  static List<StyleRule> get styles => [
    // The stage centres the phone in whatever room the column gives it and
    // keeps it off the edges on the way down to a narrow screen.
    css('#contact .phone_stage').styles(
      display: .flex,
      height: 100.percent,
      padding: .symmetric(vertical: 6.percent, horizontal: 5.percent),
      alignItems: .center,
      justifyContent: .center,
      raw: {'box-sizing': 'border-box'},
    ),
    css('.rive_phone', [
      // The height is what is scarce here, so the shell is sized from it and
      // the aspect ratio settles the width. 9/19.5 is the iPhone proportion.
      css('&').styles(
        position: .relative(),
        height: 100.percent,
        maxHeight: 620.px,
        padding: .all(9.px),
        raw: {
          'aspect-ratio': '9 / 19.5',
          'max-width': '100%',
          'background': 'linear-gradient(160deg, #3a4350 0%, #2c343f 45%, #1b2028 100%)',
          'border-radius': '44px',
          'box-shadow': '0 0 0 1px #11151b, 0 24px 60px rgba(0, 0, 0, .55)',
          'box-sizing': 'border-box',
        },
      ),
      // The side buttons, just enough of them to read as a phone.
      css('&::before').styles(
        content: '',
        position: .absolute(left: (-2).px, top: 22.percent),
        width: 2.px,
        height: 7.percent,
        raw: {'background': '#454e5c', 'border-radius': '2px 0 0 2px'},
      ),
      css('&::after').styles(
        content: '',
        position: .absolute(right: (-2).px, top: 26.percent),
        width: 2.px,
        height: 11.percent,
        raw: {'background': '#454e5c', 'border-radius': '0 2px 2px 0'},
      ),
    ]),
    css('.rive_phone .phone_screen', [
      css('&').styles(
        position: .relative(),
        overflow: .hidden,
        width: 100.percent,
        height: 100.percent,
        backgroundColor: const Color('#000'),
        raw: {'border-radius': '36px'},
      ),
      // The island floats over the canvas the way it does over an app.
      css('.phone_island').styles(
        position: .absolute(left: 50.percent, top: 10.px),
        zIndex: const ZIndex(2),
        width: 30.percent,
        height: 18.px,
        raw: {
          'transform': 'translateX(-50%)',
          'background': '#000',
          'border-radius': '12px',
        },
      ),
      css('canvas').styles(
        display: .block,
        width: 100.percent,
        height: 100.percent,
        raw: {'touch-action': 'none'},
      ),
    ]),
    // A line under the phone saying what it is, since a game in a frame is not
    // self-explanatory the way a map was.
    css('#contact .phone_caption').styles(
      margin: .only(top: 14.px),
      color: const Color('#bbb'),
      fontSize: 12.px,
      fontWeight: .w300,
      textAlign: .center,
      raw: {'letter-spacing': '.5px'},
    ),
    css('#contact .phone_column').styles(
      display: .flex,
      height: 100.percent,
      flexDirection: .column,
      alignItems: .center,
      justifyContent: .center,
    ),
    // The column is the full height of the section on a desktop; stacked under
    // the form on a phone it has to be told how tall to be.
    css.media(const MediaQuery.raw('(max-width: 991px)'), [
      css('#contact .phone_stage').styles(
        height: .auto,
        padding: .symmetric(vertical: 30.px, horizontal: 5.percent),
      ),
      css('.rive_phone').styles(height: 70.vh, maxHeight: 520.px),
    ]),
  ];
}

class _RivePhoneState extends State<RivePhone> with ViewportAware {
  final _canvas = GlobalNodeKey<web.HTMLCanvasElement>();
  int? _resizeToken;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;
    // The runtime and the file are megabytes; they are only worth fetching
    // once this has actually been scrolled to.
    watchViewport(() {
      whenReady(() => _canvas.currentNode != null, () {
        final canvas = _canvas.currentNode;
        if (canvas == null) return;
        js.startRive(canvas, riveScene, riveArtboard, riveStateMachine);
        _resizeToken = js.addResizeListener(() {
          final node = _canvas.currentNode;
          if (node != null) js.resizeRive(node);
        });
      });
    });
  }

  @override
  void dispose() {
    final token = _resizeToken;
    if (kIsWeb && token != null) js.removeResizeListener(token);
    final canvas = _canvas.currentNode;
    if (kIsWeb && canvas != null) js.stopRive(canvas);
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return div(key: viewportKey, classes: 'phone_column', [
      div(classes: 'phone_stage', [
        div(classes: 'rive_phone', [
          div(classes: 'phone_screen', [
            div(classes: 'phone_island', const []),
            // Jaspr has no canvas builder, so the element is spelled out.
            Component.element(
              tag: 'canvas',
              key: _canvas,
              attributes: const {
                'role': 'img',
                'aria-label': riveSceneLabel,
              },
              children: const [],
            ),
          ]),
        ]),
      ]),
      p(classes: 'phone_caption', [.text(riveSceneLabel)]),
    ]);
  }
}
