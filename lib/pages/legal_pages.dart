import 'package:jaspr/jaspr.dart';

import 'privacy_content.dart';
import 'tos_content.dart';

/// Impressum and privacy declaration.
class TosPage extends StatelessComponent {
  const TosPage({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      const Document.head(title: 'Impressum - Lucas Goldner'),
      const TosContent(),
    ]);
  }
}

/// Privacy policy for the apps and websites.
class PrivacyPage extends StatelessComponent {
  const PrivacyPage({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      const Document.head(title: 'Privacy Policy - Lucas Goldner'),
      const PrivacyContent(),
    ]);
  }
}
