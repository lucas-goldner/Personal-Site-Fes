import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../data/site_data.dart';
import '../i18n/language_host.dart';
import '../i18n/strings.dart';
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
      width: 100.percent,
      height: 100.percent,
      padding: .symmetric(vertical: 6.percent, horizontal: 5.percent),
      alignItems: .center,
      justifyContent: .center,
      raw: {'box-sizing': 'border-box'},
    ),
    css('.rive_phone', [
      // Height is what is scarce here, so one number decides it and the width
      // is calculated from that number at the iPhone proportion of 9/19.5.
      //
      // Both are spelled out because the shell used to have only a height and
      // an `aspect-ratio`, leaving the width to be carried across from the
      // height into an automatic width on a flex item. Chrome does carry it;
      // on iOS the shell arrived as a grey sliver the width of its own 18px of
      // padding, which is exactly what is left when that transfer does not
      // happen and the width falls back to content that is sized entirely in
      // percentages. Two explicit lengths cannot be read two ways.
      css('&').styles(
        display: .flex,
        position: .relative(),
        padding: .all(9.px),
        raw: {
          '--phone-height': 'min(620px, 84vh)',
          'width': 'calc(var(--phone-height) * 9 / 19.5)',
          'height': 'var(--phone-height)',
          'max-width': '100%',
          'flex': '0 0 auto',
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
        backgroundColor: const Color('#000'),
        raw: {'flex': '1 1 auto', 'min-width': '0', 'border-radius': '36px'},
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
      // The end of a run, laid over the screen rather than under it, so the
      // game stays visible behind the offer to go again.
      css('.phone_over').styles(
        display: .flex,
        position: .absolute(left: 0.px, top: 0.px),
        zIndex: const ZIndex(3),
        width: 100.percent,
        height: 100.percent,
        flexDirection: .column,
        alignItems: .center,
        justifyContent: .center,
        gap: Gap(column: 0.px, row: 14.px),
        raw: {'background': 'rgba(0, 0, 0, .55)'},
      ),
      css('.phone_over .over_title').styles(
        color: Colors.white,
        fontSize: 18.px,
        fontWeight: .w600,
        raw: {'letter-spacing': '1px', 'text-shadow': '0 2px 6px rgba(0,0,0,.6)'},
      ),
      css('.phone_over .over_button', [
        css('&').styles(
          padding: .symmetric(vertical: 10.px, horizontal: 22.px),
          color: const Color('#000'),
          fontSize: 12.px,
          fontWeight: .w600,
          textTransform: .upperCase,
          raw: {
            'background-color': '#ffb035',
            'border': 'none',
            'border-radius': '999px',
            'letter-spacing': '1.5px',
            'cursor': 'pointer',
            'font-family': 'Poppins, "Noto Sans JP", sans-serif',
            'transition': 'transform .2s ease, background-color .2s ease',
          },
        ),
        css('&:hover').styles(
          raw: {'background-color': '#ffc166', 'transform': 'translateY(-1px)'},
        ),
        css('&:focus-visible').styles(
          raw: {'outline': '2px solid #fff', 'outline-offset': '3px'},
        ),
      ]),
      css('canvas').styles(
        display: .block,
        position: .absolute(left: 0.px, top: 0.px),
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
      // One number again, and the width follows it. The third term keeps the
      // shell inside a narrow screen rather than leaning on a max-width.
      css('.rive_phone').styles(
        raw: {'--phone-height': 'min(520px, 70vh, calc(84vw * 19.5 / 9))'},
      ),
    ]),
  ];
}

class _RivePhoneState extends State<RivePhone> with ViewportAware {
  final _canvas = GlobalNodeKey<web.HTMLCanvasElement>();
  int? _resizeToken;

  /// True between the bird dying and the restart button being pressed.
  bool _over = false;

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
        js.startRive(
          canvas,
          riveScene,
          riveArtboard,
          riveStateMachine,
          riveDeathSignals,
          () {
            if (mounted) setState(() => _over = true);
          },
        );
        _resizeToken = js.addResizeListener(() {
          final node = _canvas.currentNode;
          if (node != null) js.resizeRive(node);
        });
      });
    });
  }

  /// Puts the file back to its first frame and takes the button away again.
  void _restart() {
    final canvas = _canvas.currentNode;
    if (canvas != null) js.restartRive(canvas);
    setState(() => _over = false);
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
    final lang = LangScope.langOf(context);

    return div(key: viewportKey, classes: 'phone_column', [
      div(classes: 'phone_stage', [
        div(classes: 'rive_phone', [
          div(classes: 'phone_screen', [
            div(classes: 'phone_island', const []),
            // Jaspr has no canvas builder, so the element is spelled out.
            Component.element(
              tag: 'canvas',
              key: _canvas,
              attributes: {
                'role': 'img',
                'aria-label': Strings.gameLabel(lang),
              },
              children: const [],
            ),
            if (_over)
              div(classes: 'phone_over', [
                span(classes: 'over_title', [.text(Strings.gameOver(lang))]),
                button(
                  classes: 'over_button',
                  attributes: const {'type': 'button'},
                  onClick: _restart,
                  [.text(Strings.playAgain(lang))],
                ),
              ]),
          ]),
        ]),
      ]),
      p(classes: 'phone_caption', [.text(Strings.gameCaption(lang))]),
    ]);
  }
}
