import 'dart:async';
import 'dart:math';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'in_viewport.dart';

/// Scrambled text that resolves into the real heading once it scrolls into view.
///
/// Port of `src/components/baffle-text`, which wrapped `baffle-react` with
/// `speed={50}` and the character set below. Spaces are preserved, matching
/// baffle's default `exclude: [' ']`.
class BaffleText extends StatefulComponent {
  const BaffleText({
    required this.text,
    required this.revealDuration,
    required this.revealDelay,
    this.onRevealed,
    this.revealCallbackDelay,
    super.key,
  });

  final String text;

  /// Milliseconds the reveal itself takes.
  final int revealDuration;

  /// Milliseconds to wait before the reveal starts.
  final int revealDelay;

  /// Called [revealCallbackDelay] milliseconds after the text enters the
  /// viewport. The sections use it to show their content once the heading has
  /// finished resolving.
  final void Function()? onRevealed;

  /// Delay for [onRevealed], the `callMethodTime` prop of the React component.
  final int? revealCallbackDelay;

  @override
  State<BaffleText> createState() => _BaffleTextState();
}

class _BaffleTextState extends State<BaffleText> with ViewportAware {
  static const _characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#\$%^&*';
  static const _tick = Duration(milliseconds: 50);

  final _random = Random();

  Timer? _scrambleTimer;
  Timer? _revealTimer;
  Timer? _callbackTimer;

  /// Indices that still show a random character.
  late Set<int> _obfuscated;

  /// The order in which characters resolve, shuffled like baffle does.
  late List<int> _revealOrder;

  String _display = '';
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _resetIndices();
    // Pre-rendered markup shows the plain text, exactly as baffle-react did on
    // the server; scrambling only starts once mounted in the browser.
    _display = component.text;

    if (kIsWeb) {
      _startScrambling();
      watchViewport(_startReveal);
    }
  }

  void _resetIndices() {
    final indices = <int>[
      for (var i = 0; i < component.text.length; i++)
        if (component.text[i] != ' ') i,
    ];
    _obfuscated = indices.toSet();
    _revealOrder = indices.toList()..shuffle(_random);
  }

  void _startScrambling() {
    _renderScramble();
    _scrambleTimer = Timer.periodic(_tick, (_) => _renderScramble());
  }

  void _renderScramble() {
    if (!mounted) return;
    final buffer = StringBuffer();
    for (var i = 0; i < component.text.length; i++) {
      if (_obfuscated.contains(i)) {
        buffer.write(_characters[_random.nextInt(_characters.length)]);
      } else {
        buffer.write(component.text[i]);
      }
    }
    setState(() => _display = buffer.toString());
  }

  void _startReveal() {
    final callbackDelay = component.revealCallbackDelay;
    if (callbackDelay != null && component.onRevealed != null) {
      _callbackTimer = Timer(Duration(milliseconds: callbackDelay), () {
        if (mounted) component.onRevealed!();
      });
    }

    _revealTimer = Timer(Duration(milliseconds: component.revealDelay), () {
      if (!mounted) return;
      final total = _revealOrder.length;
      if (total == 0) {
        _finish();
        return;
      }
      final stopwatch = Stopwatch()..start();
      _revealTimer = Timer.periodic(_tick, (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        final progress = stopwatch.elapsedMilliseconds / component.revealDuration;
        if (progress >= 1) {
          timer.cancel();
          stopwatch.stop();
          _finish();
          return;
        }
        final revealCount = (progress * total).floor();
        _obfuscated = _revealOrder.skip(revealCount).toSet();
      });
    });
  }

  void _finish() {
    _scrambleTimer?.cancel();
    _revealTimer?.cancel();
    if (!mounted) return;
    setState(() {
      _obfuscated = const {};
      _display = component.text;
      _done = true;
    });
  }

  @override
  void dispose() {
    _scrambleTimer?.cancel();
    _revealTimer?.cancel();
    _callbackTimer?.cancel();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return span(key: viewportKey, classes: 'baffle_text', [
      span([.text(_done ? component.text : _display)]),
    ]);
  }
}
