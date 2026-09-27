import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// The button with the four sliding corner squares.
///
/// The corners are CSS pseudo elements on the button and its inner span, so the
/// markup has to keep that exact nesting.
class HoverButton extends StatelessComponent {
  const HoverButton({
    required this.label,
    this.onClick,
    this.href,
    this.download = false,
    this.hasError = false,
    super.key,
  }) : assert(
         (onClick == null) != (href == null),
         'a HoverButton either does something or goes somewhere, not both',
       );

  final String label;

  /// What it does, for the button that submits the contact form.
  final VoidCallback? onClick;

  /// Where it goes, for the button that fetches the CV.
  ///
  /// Given one of these it renders as a real anchor rather than a button with
  /// a click handler, so it can be opened in a new tab from the context menu,
  /// middle-clicked, or copied — which is what somebody reaching for a CV is
  /// liable to do.
  final String? href;

  /// Hands [href] over as a file instead of navigating to it.
  ///
  /// Only meaningful for a file this site serves: the attribute is ignored on
  /// a cross-origin address, which is why the one on Drive still opens a tab.
  final bool download;

  /// Turns the corner squares red, as the contact form does on a failed submit.
  final bool hasError;

  @override
  Component build(BuildContext context) {
    final classes = 'hover-button${hasError ? ' error' : ''}';
    final inner = [
      span([.text(label)]),
    ];

    if (href case final target?) {
      return a(
        href: target,
        classes: classes,
        target: download ? null : Target.blank,
        attributes: {
          if (download) 'download': '',
          if (!download) 'rel': 'noopener noreferrer',
        },
        inner,
      );
    }
    return button(classes: classes, onClick: onClick, inner);
  }
}
