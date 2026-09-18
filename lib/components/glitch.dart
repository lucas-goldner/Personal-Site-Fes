import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// The glitching name in the hero.
///
/// Port of `src/components/glitch`. The duplicated layers and their animations
/// come entirely from CSS, which reads the text from the `data-text` attribute.
class Glitch extends StatelessComponent {
  const Glitch(this.text, {super.key});

  final String text;

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'glitch',
      attributes: {'data-text': text},
      [.text(text)],
    );
  }
}
