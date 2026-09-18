import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// The button with the four sliding corner squares.
///
/// The corners are CSS pseudo elements on the button and its inner span, so the
/// markup has to keep that exact nesting.
class HoverButton extends StatelessComponent {
  const HoverButton({
    required this.label,
    required this.onClick,
    this.hasError = false,
    super.key,
  });

  final String label;
  final VoidCallback onClick;

  /// Turns the corner squares red, as the contact form does on a failed submit.
  final bool hasError;

  @override
  Component build(BuildContext context) {
    return button(
      classes: 'hover-button${hasError ? ' error' : ''}',
      onClick: onClick,
      [
        span([.text(label)]),
      ],
    );
  }
}
