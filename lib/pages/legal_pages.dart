import 'package:jaspr/jaspr.dart';

import '../components/social_tags.dart';
import '../data/site_data.dart';
import 'privacy_content.dart';
import 'tos_content.dart';

const _tosTitle = 'Impressum - Lucas Goldner';
const _privacyTitle = 'Privacy Policy - Lucas Goldner';

/// Impressum and privacy declaration.
class TosPage extends StatelessComponent {
  const TosPage({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      // Its own description and address: the site-wide description advertises
      // a portfolio, which this is not, and a canonical pointing at the front
      // page would ask a search engine to index that instead of this.
      Document.head(
        title: _tosTitle,
        meta: const {'description': SiteMeta.legalDescription},
        children: pageSocialTags(
          title: _tosTitle,
          description: SiteMeta.legalDescription,
          path: 'tos',
        ),
      ),
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
      Document.head(
        title: _privacyTitle,
        meta: const {'description': SiteMeta.legalDescription},
        children: pageSocialTags(
          title: _privacyTitle,
          description: SiteMeta.legalDescription,
          path: 'privacy',
        ),
      ),
      const PrivacyContent(),
    ]);
  }
}
