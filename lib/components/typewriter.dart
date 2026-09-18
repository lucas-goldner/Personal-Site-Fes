import 'dart:async';
import 'dart:math';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// The looping job title under the hero heading.
///
/// Port of the `typewriter-effect` widget the React hero used with
/// `{strings: [...], autoStart: true, loop: true}`. The markup and class names
/// match that library so the existing `.Typewriter span` rules still apply.
class Typewriter extends StatefulComponent {
  const Typewriter({required this.strings, super.key});

  final List<String> strings;

  @override
  State<Typewriter> createState() => _TypewriterState();
}

class _TypewriterState extends State<Typewriter> {
  /// typewriter-effect's 'natural' speeds: a random delay per character.
  static const _typeMinMs = 120;
  static const _typeMaxMs = 160;
  static const _deleteMinMs = 40;
  static const _deleteMaxMs = 80;

  /// The library's default `pauseFor` between finishing and deleting a string.
  static const _pause = Duration(milliseconds: 1500);

  final _random = Random();

  Timer? _timer;
  int _stringIndex = 0;
  int _charCount = 0;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    // Pre-rendered markup keeps the wrapper empty, as the library did on the
    // server; typing starts once mounted in the browser.
    if (kIsWeb && component.strings.isNotEmpty) {
      _schedule(Duration(milliseconds: _randomBetween(_typeMinMs, _typeMaxMs)));
    }
  }

  int _randomBetween(int min, int max) => min + _random.nextInt(max - min + 1);

  void _schedule(Duration delay) {
    _timer = Timer(delay, _step);
  }

  void _step() {
    if (!mounted) return;
    final current = component.strings[_stringIndex];

    if (!_deleting) {
      if (_charCount < current.length) {
        setState(() => _charCount++);
        _schedule(Duration(milliseconds: _randomBetween(_typeMinMs, _typeMaxMs)));
      } else {
        _deleting = true;
        _schedule(_pause);
      }
    } else {
      if (_charCount > 0) {
        setState(() => _charCount--);
        _schedule(Duration(milliseconds: _randomBetween(_deleteMinMs, _deleteMaxMs)));
      } else {
        _deleting = false;
        _stringIndex = (_stringIndex + 1) % component.strings.length;
        _schedule(Duration(milliseconds: _randomBetween(_typeMinMs, _typeMaxMs)));
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final text = component.strings.isEmpty ? '' : component.strings[_stringIndex].substring(0, _charCount);

    return div(
      classes: 'Typewriter',
      attributes: const {
        'data-testid': 'typewriter-wrapper',
      },
      [
        span(classes: 'Typewriter__wrapper', [.text(text)]),
        span(classes: 'Typewriter__cursor', [.text('|')]),
      ],
    );
  }
}
