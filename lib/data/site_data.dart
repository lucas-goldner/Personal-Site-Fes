/// All page content, extracted from the JSON files and hard-coded strings of
/// the previous Gatsby site so the sections stay declarative.
library;

import '../components/icons_data.dart';
import '../i18n/lang.dart';

/// Document metadata, previously `data/meta.json`.
class SiteMeta {
  static const title = 'Lucas Goldner - Persona(l) Portfolio Website';

  /// The line a search result prints under the title, and the one a link
  /// preview carries.
  ///
  /// The wording it replaced came from the Gatsby site and said only that this
  /// was the site of a web and mobile developer with all of his projects on
  /// it: nothing about Japan, Flutter or the credential, and the portfolio
  /// stopped being all of anything when it started opening on a sample.
  static const description =
      'Mobile engineer in Japan specialising in Flutter and Dart, and a '
      'Flutter & Dart Google Developer Expert. Apps, websites, talks and '
      'writing by Lucas Goldner.';

  /// Where the site answers from, for the canonical link and for the absolute
  /// URLs the social tags have to carry: a preview scraper has no page to
  /// resolve a relative one against.
  static const canonicalUrl = 'https://lucas-goldner.com/';
  static const shareImageUrl = '${canonicalUrl}img/og-card.jpg';
  static const shareImageAlt =
      'Lucas Goldner in front of Tokyo Tower, beside his name and the line '
      'Flutter, iOS and Android Engineer.';

  /// What the legal pages say about themselves, instead of inheriting a
  /// description that advertises them as a portfolio.
  static const legalDescription =
      'Imprint and privacy declaration for the apps and websites of Lucas Goldner.';

  /// Keywords describing what the page actually covers.
  ///
  /// Each entry is backed by something on the site: the roles the hero
  /// cycles through, the skill bars, the expertise cards and the project
  /// tiles.
  /// Gatsby was dropped because the site no longer uses it and no project
  /// references it.
  static const keywords =
      'Lucas Goldner, portfolio, personal website, mobile engineer, '
      'software developer, Flutter developer, iOS developer, '
      'Android developer, frontend engineer, backend engineer, '
      'Google Developer Expert, '
      'Flutter, Dart, SwiftUI, Jetpack Compose, Swift, Kotlin, '
      'React, Next.js, TypeScript, NestJS, MongoDB, PostgreSQL, '
      'Azure, GCP, Terraform, '
      'mobile architecture, testing, QA, mentoring, '
      'AI-assisted development, Claude Code, Jaspr';
  static const author = 'Lucas Goldner';
}

/// The scroll-snapped sections of the home page, in order.
///
/// The ids double as the anchor targets used by the navigation and the wheel
/// handler. The labels the navigation shows are in `Strings.navLabels`, in this
/// same order.
const sectionIds = ['home', 'about', 'services', 'portfolio', 'contact'];

/// A hobby icon floating over the hero panel.
///
/// The previous site picked `bottom` and the bob direction with `Math.random()`
/// on every render. Those values are frozen here instead: a random draw during
/// `build` would differ between the pre-rendered HTML and the hydrated client
/// tree, which breaks hydration. The numbers below were drawn from the same
/// distribution the React code used (70-80% for even indices, 10-20% for odd).
class HeroIcon {
  const HeroIcon(this.src, this.bottomPercent, {required this.moveUp});

  /// Path of the icon image.
  final String src;

  /// Distance from the bottom of the hero panel, in percent.
  final double bottomPercent;

  /// Whether the icon bobs up (`move-up`) or down (`move-down`).
  final bool moveUp;

  /// Candidate widths for [src]: a 40px variant beside the 100px original.
  ///
  /// The icons are 50px wide on desktop and 10px on phones, so a phone needs
  /// 40px even at 3x while a retina desktop needs the full 100px.
  String get srcset {
    final base = src.substring(0, src.length - '.webp'.length);
    return '$base-40.webp 40w, $src 100w';
  }
}

/// Layout width of a floating hero icon, mirroring `.float-image` in site.css.
const heroIconSizes = '(max-width: 991px) 10px, 50px';

const heroIcons = <HeroIcon>[
  HeroIcon('heroIcons/pc.webp', 74.2, moveUp: true),
  HeroIcon('heroIcons/brazil.webp', 13.6, moveUp: false),
  HeroIcon('heroIcons/party.webp', 78.1, moveUp: false),
  HeroIcon('heroIcons/tarot.webp', 11.4, moveUp: true),
  HeroIcon('heroIcons/japan.webp', 72.5, moveUp: true),
  HeroIcon('heroIcons/draw.webp', 17.9, moveUp: false),
  HeroIcon('heroIcons/video.webp', 76.3, moveUp: true),
  HeroIcon('heroIcons/controller.webp', 15.2, moveUp: false),
  HeroIcon('heroIcons/gym.webp', 70.8, moveUp: false),
  HeroIcon('heroIcons/inline.webp', 18.7, moveUp: true),
];

/// The photo of Lucas shown on the right half of the hero.
///
/// This is the largest thing on the page and the one the browser measures the
/// load against, so it is offered in four widths rather than one. The narrow
/// end matters most: a mid-range phone paints this at about 312 by 416, which
/// wants 600px of image, not the 1800px copy every visitor used to be sent.
const heroImage = 'person2x.webp';
const heroImageWidth = 1800;
const heroImageHeight = 2400;
const heroImageSrcset =
    'person2x-600.webp 600w, person2x-900.webp 900w, '
    'person2x-1200.webp 1200w, person2x.webp 1800w';

/// What the photo actually occupies, measured rather than assumed.
///
/// It was described as the full width of the window below the breakpoint. It
/// is not: the panel has padding, so a phone paints it at 72 to 77 percent,
/// and a tablet at up to 90. Claiming the whole width made the browser reach
/// a size up — 186KB where 58KB covers it — on the one image the load is
/// measured on.
const heroImageSizes = '(min-width: 992px) 47vw, (min-width: 700px) 90vw, 78vw';
const heroImageAlt = L(
  'Lucas Goldner with inline skates posing in front of a graffiti wall',
  '\u30a4\u30f3\u30e9\u30a4\u30f3\u30b9\u30b1\u30fc\u30c8\u3092\u5c65\u3044\u3066'
      '\u30b0\u30e9\u30d5\u30a3\u30c6\u30a3\u306e\u58c1\u306e\u524d\u306b\u7acb\u3064'
      'Lucas Goldner',
);

/// Lucas's employer, linked from the about text.
const youtrustUrl = 'https://youtrust.jp/';

/// The Flutter Tokyo meetup Lucas organises, linked from the about text.
const flutterTokyoUrl = 'https://flutter-jp.connpass.com/';

/// The Google Developer Expert programme page, linked from the hero credential.
const gdeUrl = 'https://developers.google.com/community/experts';

/// What the hero's CV button points at, per language.
///
/// The English one is the copy on Drive. The Japanese one is a file this site
/// serves, and the difference is load-bearing: an address of its own opens in
/// a tab, while a path into this site is handed over as a download. Whether it
/// starts with a scheme is the whole rule, so there is no second flag that can
/// disagree with the link it describes.
const cvLink = L(
  'https://drive.google.com/file/d/1iRmTNFP1dI41ZUowzwdVZeJGzOwKNIjE/view?usp=sharing',
  'cv/Lucas_Goldner_Japanese_CV.pdf',
);

/// One of the social links under the about text.
class SocialLink {
  const SocialLink(this.icon, this.url, this.label);

  final FaIcon icon;
  final String url;

  /// Accessible name for the link, since the icon carries no text.
  final String label;
}

const socialLinks = <SocialLink>[
  SocialLink(faXTwitter, 'https://www.twitter.lucas-goldner.com', 'X'),
  SocialLink(faGithub, 'https://github.lucas-goldner.com', 'GitHub'),
  // Font Awesome has no YOUTRUST mark, and none of the usual brand icon sets
  // carry one either, so the Google 'G' stands in for the developer profile and
  // a briefcase for YOUTRUST until real logos are supplied.
  SocialLink(faGoogle, 'https://me.developers.google.com/u/me', 'Google Developer Profile'),
  SocialLink(faLinkedin, 'https://www.linkedin.com/in/lucas-goldner/', 'LinkedIn'),
  SocialLink(faBriefcase, 'https://youtrust.jp/users/lucas', 'YOUTRUST'),
  SocialLink(faStackOverflow, 'https://stackoverflow.lucas-goldner.com', 'Stack Overflow'),
];

/// A skill bar in the about section.
class Skill {
  const Skill(this.name, this.percent, this.label);

  final L name;

  /// How far the bar fills, 0 to 100. Previously a 1-5 level rendered at
  /// `value * 20%`, which could not express the values this list needs.
  final int percent;

  /// The wording shown on the right of the bar.
  final L label;
}

const _primaryStack = L('Primary Stack', '\u30e1\u30a4\u30f3\u30b9\u30bf\u30c3\u30af');
const _advanced = L('Advanced', '\u4e0a\u7d1a');
const _proficient = L('Proficient', '\u5b9f\u52d9\u30ec\u30d9\u30eb');
const _experienced = L('Experienced', '\u7d4c\u9a13\u3042\u308a');

const skills = <Skill>[
  Skill(L.same('Flutter & Dart'), 100, _primaryStack),
  Skill(L.same('iOS & Swift'), 85, _advanced),
  Skill(
    L('Architecture & Scalability', '\u30a2\u30fc\u30ad\u30c6\u30af\u30c1\u30e3\u3068\u62e1\u5f35\u6027'),
    85,
    _advanced,
  ),
  Skill(L('Testing & Quality', '\u30c6\u30b9\u30c8\u3068\u54c1\u8cea'), 80, _advanced),
  Skill(
    L(
      'TypeScript \u2014 Backend & Frontend',
      'TypeScript \u2014 \u30d0\u30c3\u30af\u30a8\u30f3\u30c9\uff06\u30d5\u30ed\u30f3\u30c8\u30a8\u30f3\u30c9',
    ),
    75,
    _proficient,
  ),
  Skill(L.same('Android & Kotlin'), 50, _experienced),
  Skill(
    L('AI-Assisted Development \u2014 Claude Code', 'AI\u6d3b\u7528\u958b\u767a \u2014 Claude Code'),
    100,
    _primaryStack,
  ),
];

/// A card in the expertise section.
class Service {
  const Service({
    required this.icon,
    required this.title,
    required this.technologies,
    required this.text,
    required this.delay,
    required this.animation,
    this.featured = false,
  });

  final FaIcon icon;
  final L title;

  /// The stack behind the area, shown as a smaller line under the title.
  final L technologies;

  final L text;

  /// Delay in milliseconds before the card animates in.
  final int delay;

  /// The animate.css classes applied once the delay has elapsed.
  final String animation;

  /// The closing card, laid out as a full-width band rather than a column so
  /// it reads as a way of working rather than another platform.
  final bool featured;
}

const services = <Service>[
  Service(
    icon: faMobile,
    title: L('Mobile App Development', '\u30e2\u30d0\u30a4\u30eb\u30a2\u30d7\u30ea\u958b\u767a'),
    technologies: L.same('Flutter \u00b7 SwiftUI \u00b7 Jetpack Compose'),
    text: L(
      'Flutter is my primary stack, with SwiftUI and Jetpack '
          'Compose when native makes more sense.',
      'Flutter\u3092\u30e1\u30a4\u30f3\u306b\u3001\u30cd\u30a4\u30c6\u30a3\u30d6\u304c'
          '\u9069\u3059\u308b\u5834\u9762\u3067\u306fSwiftUI\u3084Jetpack Compose\u3067'
          '\u958b\u767a\u3057\u307e\u3059\u3002',
    ),
    delay: 200,
    animation: 'fadeInLeft fast',
  ),
  Service(
    icon: faLaptopCode,
    title: L('Frontend Development', '\u30d5\u30ed\u30f3\u30c8\u30a8\u30f3\u30c9\u958b\u767a'),
    technologies: L.same('React \u00b7 Next.js \u00b7 TypeScript'),
    text: L(
      'Modern web apps with maintainable components, responsive '
          'interfaces and clean backend integration.',
      '\u4fdd\u5b88\u3057\u3084\u3059\u3044\u30b3\u30f3\u30dd\u30fc\u30cd\u30f3\u30c8\u3068'
          '\u30ec\u30b9\u30dd\u30f3\u30b7\u30d6\u306aUI\u3001\u305d\u3057\u3066'
          '\u7d20\u76f4\u306a\u30d0\u30c3\u30af\u30a8\u30f3\u30c9\u9023\u643a\u3067'
          '\u30e2\u30c0\u30f3\u306aWeb\u30a2\u30d7\u30ea\u3092\u3064\u304f\u308a\u307e\u3059\u3002',
    ),
    delay: 400,
    animation: 'fadeInDown fast',
  ),
  Service(
    icon: faServer,
    title: L('Backend & Infrastructure', '\u30d0\u30c3\u30af\u30a8\u30f3\u30c9\u3068\u30a4\u30f3\u30d5\u30e9'),
    technologies: L.same('NestJS \u00b7 MongoDB \u00b7 PostgreSQL \u00b7 Azure \u00b7 GCP \u00b7 Terraform'),
    text: L(
      'APIs and services, relational and document databases, and '
          'the cloud infrastructure they run on.',
      'API\u3068\u30b5\u30fc\u30d3\u30b9\u3001\u30ea\u30ec\u30fc\u30b7\u30e7\u30ca\u30eb'
          'DB\u3068\u30c9\u30ad\u30e5\u30e1\u30f3\u30c8DB\u3001\u305d\u3057\u3066'
          '\u305d\u308c\u3089\u3092\u52d5\u304b\u3059\u30af\u30e9\u30a6\u30c9'
          '\u57fa\u76e4\u307e\u3067\u3002',
    ),
    delay: 600,
    animation: 'fadeInRight fast',
  ),
  Service(
    icon: faLayerGroup,
    title: L('Mobile Architecture', '\u30e2\u30d0\u30a4\u30eb\u30a2\u30fc\u30ad\u30c6\u30af\u30c1\u30e3'),
    technologies: L(
      'Architecture \u00b7 State Management \u00b7 Technical Design',
      '\u30a2\u30fc\u30ad\u30c6\u30af\u30c1\u30e3 \u00b7 \u72b6\u614b\u7ba1\u7406 \u00b7 \u6280\u8853\u8a2d\u8a08',
    ),
    text: L(
      'Technical design and state management that keep an app '
          'maintainable as the product and the team grow.',
      '\u30d7\u30ed\u30c0\u30af\u30c8\u3068\u30c1\u30fc\u30e0\u304c\u5927\u304d\u304f'
          '\u306a\u3063\u3066\u3082\u4fdd\u5b88\u3067\u304d\u308b\u6280\u8853\u8a2d\u8a08\u3068'
          '\u72b6\u614b\u7ba1\u7406\u3092\u3002',
    ),
    delay: 800,
    animation: 'fadeInLeft fast',
  ),
  Service(
    icon: faVials,
    title: L('Testing & Quality', '\u30c6\u30b9\u30c8\u3068\u54c1\u8cea'),
    technologies: L.same('Widget \u00b7 Golden \u00b7 E2E \u00b7 QA'),
    text: L(
      'Widget, golden and end-to-end tests, plus the QA planning '
          'and tracking that make releases predictable.',
      'Widget\u30fbGolden\u30fbE2E\u30c6\u30b9\u30c8\u306b\u52a0\u3048\u3001'
          '\u30ea\u30ea\u30fc\u30b9\u3092\u4e88\u6e2c\u53ef\u80fd\u306b\u3059\u308b'
          'QA\u8a08\u753b\u3068\u7ba1\u7406\u307e\u3067\u3002',
    ),
    delay: 1000,
    animation: 'fadeInUp fast',
  ),
  Service(
    icon: faUsers,
    title: L('Team Growth & Mentoring', '\u30c1\u30fc\u30e0\u306e\u6210\u9577\u3068\u30e1\u30f3\u30bf\u30ea\u30f3\u30b0'),
    technologies: L(
      'Code Reviews \u00b7 Mentoring \u00b7 Internal Education',
      '\u30b3\u30fc\u30c9\u30ec\u30d3\u30e5\u30fc \u00b7 \u30e1\u30f3\u30bf\u30ea\u30f3\u30b0 \u00b7 \u793e\u5185\u52c9\u5f37\u4f1a',
    ),
    text: L(
      'Code reviews, mentoring and study sessions that help '
          'engineers grow into confident, independent work.',
      '\u30b3\u30fc\u30c9\u30ec\u30d3\u30e5\u30fc\u3084\u30e1\u30f3\u30bf\u30ea\u30f3\u30b0\u3001'
          '\u52c9\u5f37\u4f1a\u3092\u901a\u3058\u3066\u3001\u81ea\u8d70\u3067\u304d\u308b'
          '\u30a8\u30f3\u30b8\u30cb\u30a2\u306e\u6210\u9577\u3092\u652f\u3048\u307e\u3059\u3002',
    ),
    delay: 1200,
    animation: 'fadeInRight fast',
  ),
  Service(
    icon: faRobot,
    title: L('AI-Assisted Engineering', 'AI\u3092\u6d3b\u7528\u3057\u305f\u30a8\u30f3\u30b8\u30cb\u30a2\u30ea\u30f3\u30b0'),
    technologies: L(
      'Claude Code \u00b7 Agentic Development',
      'Claude Code \u00b7 \u30a8\u30fc\u30b8\u30a7\u30f3\u30c8\u958b\u767a',
    ),
    text: L(
      'Claude Code across implementation, debugging and '
          'refactoring, with the engineering decisions and the code '
          'quality staying under human control.',
      '\u5b9f\u88c5\u30fb\u30c7\u30d0\u30c3\u30b0\u30fb\u30ea\u30d5\u30a1\u30af\u30bf\u30ea\u30f3\u30b0\u306b'
          'Claude Code\u3092\u6d3b\u7528\u3057\u3064\u3064\u3001\u8a2d\u8a08\u5224\u65ad\u3068'
          '\u30b3\u30fc\u30c9\u54c1\u8cea\u306f\u4eba\u304c\u30b3\u30f3\u30c8\u30ed\u30fc\u30eb\u3057\u307e\u3059\u3002',
    ),
    delay: 1400,
    animation: 'fadeIn fast',
    featured: true,
  ),
];

/// A count-up figure in the strip below the expertise cards.
class CounterData {
  const CounterData(this.icon, this.value, this.text, this.symbol, this.duration);

  final FaIcon icon;
  final int value;
  final L text;
  final L symbol;

  /// Duration of the count-up animation, in seconds.
  final int duration;
}

/// The figures the counters count up to.
///
/// Kept apart from [counters] so the numbers can be bumped in one place
/// without touching the icons or the wording around them.
abstract final class Stats {
  /// Counted by hand: more apps have shipped than are listed in the grid,
  /// which only carries the ones still worth linking to.
  static const appsShipped = 12;

  /// Counted from the grid, so the figures cannot drift away from the tiles
  /// sitting above them as the list of record grows.
  static final articlesPublished = _tilesIn('Article');
  static final talksDelivered = _tilesIn('Talk');

  static int _tilesIn(String category) => portfolioItems.where((item) => item.category == category).length;
}

/// Not const, because two of the three figures are counted at startup.
final counters = <CounterData>[
  CounterData(
    faMobileAlt,
    Stats.appsShipped,
    L('Shipped', '\u30ea\u30ea\u30fc\u30b9'),
    L('Apps', '\u30a2\u30d7\u30ea'),
    2,
  ),
  CounterData(
    faPenNib,
    Stats.articlesPublished,
    L('Published', '\u516c\u958b'),
    L('Articles', '\u8a18\u4e8b'),
    3,
  ),
  CounterData(
    faMicrophoneAlt,
    Stats.talksDelivered,
    L('Delivered', '\u767a\u8868'),
    L('Talks', '\u767b\u58c7'),
    4,
  ),
];

/// A tile in the portfolio grid.
class PortfolioItem {
  const PortfolioItem({
    required this.id,
    required this.title,
    required this.category,
    required this.link,
    this.image,
    this.meta,
  });

  /// Stable identity, so switching category rebuilds a tile rather than
  /// reusing a tilt handler bound to a different one. Links cannot stand in:
  /// an app and its landing page can point at the same place.
  final int id;

  final String title;

  /// Used by the All / App / Website / Article / Talk filter. The filter row
  /// follows the order the categories first appear in [portfolioItems].
  final String category;

  final String link;

  /// Screenshot for the tile. Articles and talks have none, so those tiles
  /// fall back to the title and [meta] on a plain panel.
  final String? image;

  /// The line under the title on a tile without a screenshot: the publication
  /// or the event, and the year.
  ///
  /// Most of these are names — a conference, a blog, a stack — and read the
  /// same in both languages, so they are [L.same].
  final L? meta;
}

/// The App Store apps, the sites, and the writing and speaking.
///
/// The articles and talks are kept in step with
/// https://github.com/lucas-goldner/Talks-Articles-Events, which is the list
/// of record for them.
///
/// The app tiles carry the App Store artwork for each app: four of them taken
/// from the appiconset in their own repository, and ReadOn's exported from the
/// Icon Composer document that has no flat version in source.
///
/// The four flat ones are cut to the shape of the ReadOn icon, using its own
/// alpha channel as the stencil rather than a border-radius, so every tile
/// carries the same squircle by construction.
const portfolioItems = <PortfolioItem>[
  PortfolioItem(
    id: 1,
    title: 'Pushup Bro',
    category: 'App',
    link: 'https://apps.apple.com/jp/app/pushup-bro/id1673181014',
    image: 'projectImg/appPushupBro.webp',
    meta: L('iOS \u00b7 Push-up tracking with AirPods', 'iOS \u00b7 AirPods\u3067\u8155\u7acb\u3066\u4f0f\u305b\u3092\u8a18\u9332'),
  ),
  PortfolioItem(
    id: 2,
    title: 'Japanana',
    category: 'App',
    link: 'https://apps.apple.com/jp/app/japanana-japanese-grammar/id6476447175',
    image: 'projectImg/appJapanana.webp',
    meta: L('iOS \u00b7 Japanese grammar', 'iOS \u00b7 \u65e5\u672c\u8a9e\u6587\u6cd5'),
  ),
  PortfolioItem(
    id: 3,
    title: 'Giro',
    category: 'App',
    link: 'https://apps.apple.com/jp/app/giro-mark-past-walks/id6737528413',
    image: 'projectImg/appGiro.webp',
    meta: L('iOS \u00b7 Marking past walks', 'iOS \u00b7 \u6b69\u3044\u305f\u9053\u3092\u8a18\u9332'),
  ),
  PortfolioItem(
    id: 4,
    title: 'ReadOn',
    category: 'App',
    link: 'https://apps.apple.com/jp/app/readon-read-in-any-language/id6757393728',
    image: 'projectImg/appReadOn.webp',
    meta: L('iOS \u00b7 Reading in any language', 'iOS \u00b7 \u3069\u3093\u306a\u8a00\u8a9e\u3067\u3082\u8aad\u3080'),
  ),
  PortfolioItem(
    id: 5,
    title: 'Dream Lucid Now!',
    category: 'App',
    link: 'https://apps.apple.com/jp/app/dream-lucid-now-dreams-sleep/id6752128546',
    image: 'projectImg/appDreamLucid.webp',
    meta: L('iOS \u00b7 Dreams and sleep', 'iOS \u00b7 \u5922\u3068\u7761\u7720'),
  ),
  PortfolioItem(
    id: 10,
    title: 'Personal Website',
    category: 'Website',
    link: 'https://lucas-goldner.com',
    image: 'projectImg/personalSite.webp',
    meta: L.same('Jaspr \u00b7 Dart'),
  ),
  PortfolioItem(
    id: 11,
    title: 'FlowUs Website',
    category: 'Website',
    link: 'https://flowus-website-6llv9x8c6-lucas-goldner.vercel.app/',
    image: 'projectImg/flowUs.webp',
    meta: L.same('Next.js'),
  ),
  PortfolioItem(
    id: 12,
    title: 'Kawa Druck Homepage',
    category: 'Website',
    link: 'https://kawa-druck.de',
    image: 'projectImg/kawaPage.webp',
    meta: L.same('React'),
  ),
  PortfolioItem(
    id: 13,
    title: 'NFT Metro Website',
    category: 'Website',
    link: 'https://old-metro.vercel.app',
    image: 'projectImg/nifterPage.webp',
    meta: L.same('React'),
  ),
  PortfolioItem(
    id: 14,
    title: 'Golden Website',
    category: 'Website',
    link: 'https://golden.lucas-goldner.com',
    image: 'projectImg/golden.webp',
    meta: L.same('React'),
  ),
  PortfolioItem(
    id: 20,
    title: 'Building a City #2: The Storefronts',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/app-architecture-2',
    image: 'projectImg/article20.webp',
    meta: L.same('YOUTRUST Tech Blog'),
  ),
  PortfolioItem(
    id: 21,
    title:
        'Before Technology, There Were People — A Talk at Open Seminar '
        '2026 @ Okayama',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/open-seminar-okayama',
    image: 'projectImg/article21.webp',
    meta: L.same('YOUTRUST Tech Blog'),
  ),
  PortfolioItem(
    id: 22,
    title:
        'My First Presentation at iOSDC Japan 2026: A Flutter Engineer\'s '
        'Perspective on Cross-Platform Development',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/iosdc-2026',
    image: 'projectImg/article22.webp',
    meta: L.same('YOUTRUST Tech Blog'),
  ),
  PortfolioItem(
    id: 23,
    title: 'Building a City #1: The Master Plan',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/app-architecture-1',
    image: 'projectImg/article23.webp',
    meta: L.same('YOUTRUST Tech Blog'),
  ),
  PortfolioItem(
    id: 24,
    title:
        'He cooked: Crafting a Sexy Drawer Using Only Standard Flutter '
        'Features',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/sexy-drawer',
    image: 'projectImg/article24.webp',
    meta: L.same('YOUTRUST Tech Blog'),
  ),
  PortfolioItem(
    id: 25,
    title:
        'Eliminating Manual Authentication Code Entry in iOS 26: Teaching '
        'the Keyboard Summoning Magic',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/ios-26-one-time-code-keyboard',
    image: 'projectImg/article25.webp',
    meta: L.same('YOUTRUST Tech Blog'),
  ),
  PortfolioItem(
    id: 26,
    title:
        'Graduating from custom_lint: Completely Porting 13 Unique '
        'Flutter Lint Rules to Dart Analyzer Plugin',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/analyzer-plugins',
    image: 'projectImg/article26.webp',
    meta: L.same('YOUTRUST Tech Blog'),
  ),
  PortfolioItem(
    id: 27,
    title: 'Implementing 1-on-1 Voice Calls in YOUTRUST: An S-Rank Challenge',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/flutter-phone-call',
    image: 'projectImg/article27.webp',
    meta: L.same('YOUTRUST Tech Blog'),
  ),
  PortfolioItem(
    id: 28,
    title: 'Flutter Kaigi 2025 Participation Report',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/2025/11/14/223527',
    image: 'projectImg/article28.webp',
    meta: L.same('YOUTRUST Tech Blog'),
  ),
  PortfolioItem(
    id: 29,
    title: 'DevFest 2025 Greater Kwansai @Kobe Report',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/devfest-2025-kwansai',
    image: 'projectImg/article29.webp',
    meta: L.same('YOUTRUST Tech Blog'),
  ),
  PortfolioItem(
    id: 30,
    title: 'Fluttercon 2025 Day 3: Career Change Through Courage',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/fluttercon-2025-3',
    image: 'projectImg/article30.webp',
    meta: L.same('YOUTRUST Tech Blog'),
  ),
  PortfolioItem(
    id: 31,
    title: 'Fluttercon 2025 Day 2: Discovering New Worlds',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/fluttercon-2025-2',
    image: 'projectImg/article31.webp',
    meta: L.same('YOUTRUST Tech Blog'),
  ),
  PortfolioItem(
    id: 32,
    title: 'Flutterエンジニアの聖地へ：Fluttercon 2025 Day 1 の記録',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/fluttercon-2025-1',
    image: 'projectImg/article32.webp',
    meta: L.same('YOUTRUST Tech Blog'),
  ),
  PortfolioItem(
    id: 33,
    title:
        'App Engineers Can Also Create Animations!! Creating '
        'Next-Generation UI Experiences with Flutter x Rive',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/rive-animation-flutter',
    image: 'projectImg/article33.webp',
    meta: L.same('YOUTRUST Tech Blog'),
  ),
  PortfolioItem(
    id: 34,
    title:
        'The Liquid Glass Debate That Shook the Flutter Community — and '
        'How to Implement It',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/liquid-glass-in-flutter',
    image: 'projectImg/article34.webp',
    meta: L.same('YOUTRUST Tech Blog'),
  ),
  PortfolioItem(
    id: 35,
    title: '拙者、FlutterNinjas2025にて修行して参った！',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/flutterninjas2025-day-one',
    image: 'projectImg/article35.webp',
    meta: L.same('YOUTRUST Tech Blog'),
  ),
  PortfolioItem(
    id: 36,
    title: '美味しいチーズ牛丼を通じて、ListView.builderのfindChildIndexCallbackについて学びませんか？',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/flutter-findchildindexcallback',
    image: 'projectImg/article36.webp',
    meta: L.same('YOUTRUST Tech Blog'),
  ),
  PortfolioItem(
    id: 37,
    title: 'AndroidでFlutterアプリでイメージ選択に気をつけろ',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/flutter-image-picking-android',
    image: 'projectImg/article37.webp',
    meta: L.same('YOUTRUST Tech Blog'),
  ),
  PortfolioItem(
    id: 38,
    title: 'テキスト入力のUXを改善しました',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/app-text-ux-improvements',
    image: 'projectImg/article38.webp',
    meta: L.same('YOUTRUST Tech Blog'),
  ),
  PortfolioItem(
    id: 39,
    title: 'FlutterKaigi 2024に参加してきました！',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/2024/11/27/184941',
    image: 'projectImg/article39.webp',
    meta: L.same('YOUTRUST Tech Blog'),
  ),
  PortfolioItem(
    id: 40,
    title: 'Flutter Connection参加レポート',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/2024/08/07/184732',
    image: 'projectImg/article40.webp',
    meta: L.same('YOUTRUST Tech Blog'),
  ),
  PortfolioItem(
    id: 41,
    title: 'Flutter エレメントエンべディング・アプリを ウェブサイト内に入れられるの力！AngularやReactまでもできる！',
    category: 'Article',
    link: 'https://qiita.com/LucasGoldner/items/64b9e74f5b982465cf76',
    image: 'projectImg/article41.webp',
    meta: L.same('Qiita · Zenn'),
  ),
  PortfolioItem(
    id: 42,
    title:
        'Flutter Element Embedding — Unleashing the Power of Integrating '
        'Flutter Apps into Websites, including React-powered ones!',
    category: 'Article',
    link:
        'https://medium.com/@lucas.goldner/flutter-element-embedding-unleashing-the-power-of-integrating-flutter-apps-into-websites-e91c84c13f2d',
    image: 'projectImg/article42.webp',
    meta: L.same('Medium'),
  ),
  PortfolioItem(
    id: 43,
    title: '僕の最初のテックトーク、どうやって乗り越えたか - Fluttercon2023',
    category: 'Article',
    link: 'https://qiita.com/LucasGoldner/items/7583c9bc1316286b9121',
    image: 'projectImg/article43.webp',
    meta: L.same('Qiita'),
  ),
  PortfolioItem(
    id: 44,
    title: 'How I Survived My First BIG Tech Presentation — Fluttercon 2023',
    category: 'Article',
    link:
        'https://medium.com/@lucas.goldner/how-i-survived-my-first-big-tech-presentation-fluttercon-2023-f6c1c10f0263',
    image: 'projectImg/article44.webp',
    meta: L.same('Medium'),
  ),
  PortfolioItem(
    id: 45,
    title: 'Flutterで簡単プレゼンをする - FlutterShow⚡',
    category: 'Article',
    link: 'https://qiita.com/LucasGoldner/items/225a793035820137fc18',
    image: 'projectImg/article45.webp',
    meta: L.same('Qiita'),
  ),
  PortfolioItem(
    id: 46,
    title: 'Presentations made easy in Flutter -FlutterShow⚡',
    category: 'Article',
    link: 'https://medium.com/@lucas.goldner/presentations-made-easy-in-flutter-fluttershow-79ab316253b5',
    image: 'projectImg/article46.webp',
    meta: L.same('Medium'),
  ),
  PortfolioItem(
    id: 100,
    title:
        'Technology Didn’t Change My Life. People Did. — How Flutter '
        'Opened Up My World',
    category: 'Talk',
    link: 'https://okayama.open-seminar.org/detail/?speaker=lucas',
    image: 'projectImg/talk100.webp',
    meta: L.same('岡山Open Seminar 2026'),
  ),
  PortfolioItem(
    id: 101,
    title:
        'Calls don\'t end when they connect - The back end of call '
        'functionality with CallKit',
    category: 'Talk',
    link: 'https://fortee.jp/iosdc-japan-2026/proposal/db0b002a-ed2b-47e8-b798-3b8f8bcc4007',
    image: 'projectImg/talk101.webp',
    meta: L.same('iOSDC Japan 2026'),
  ),
  PortfolioItem(
    id: 102,
    title:
        'Beyond the Keynote — Google I/O 2026: Hands-on with the Latest '
        'Flutter Information',
    category: 'Talk',
    link: 'https://gdgkwansai.connpass.com/event/391029/',
    image: 'projectImg/talk102.webp',
    meta: L.same('Google I/O Extended Kwansai 2026'),
  ),
  PortfolioItem(
    id: 103,
    title:
        'Beyond the Keynote: Experiencing the Latest Flutter Information '
        'from Google I/O 2026',
    category: 'Talk',
    link: 'https://gdg-tokyo.connpass.com/event/394136/',
    image: 'projectImg/talk103.webp',
    meta: L.same('Google I/O Extended Tokyo 2026'),
  ),
  PortfolioItem(
    id: 104,
    title: 'JSからDartへ：React Native開発者のFlutter初体験',
    category: 'Talk',
    link: 'https://react-native-meetup.connpass.com/event/390014/',
    image: 'projectImg/talk104.webp',
    meta: L.same('React Native Meetup'),
  ),
  PortfolioItem(
    id: 105,
    title: 'Mobile App Development: A Community Learning Experience',
    category: 'Talk',
    link: 'https://wantedly.connpass.com/event/377759/',
    image: 'projectImg/talk105.webp',
    meta: L.same('Mobile勉強会 #23'),
  ),
  PortfolioItem(
    id: 106,
    title: 'もうバグは許さない — Flutter E2Eテスト最終対策',
    category: 'Talk',
    link: 'https://assign.connpass.com/event/378631/',
    image: 'projectImg/talk106.webp',
    meta: L.same('もうバグは許さない — Flutter E2Eテスト最終対策'),
  ),
  PortfolioItem(
    id: 107,
    title: '[Keynote] Flutter in 2026',
    category: 'Talk',
    link: 'https://okayama-dot-flutter.connpass.com/event/378340/',
    image: 'projectImg/talk107.webp',
    meta: L.same('岡山.Flutter #1'),
  ),
  PortfolioItem(
    id: 108,
    title: 'My recent struggles with Flutter',
    category: 'Talk',
    link: 'https://flutter-jp.connpass.com/event/374220/',
    image: 'projectImg/talk108.webp',
    meta: L.same('Flutter Tokyo'),
  ),
  PortfolioItem(
    id: 109,
    title: 'Flutterで実現する「120％ネイティブ」なLiquid Glassエフェクト',
    category: 'Talk',
    link: 'https://gdg-tokyo.connpass.com/event/369416/',
    image: 'projectImg/talk109.webp',
    meta: L.same('GDG Tokyo'),
  ),
  PortfolioItem(
    id: 110,
    title: '[Keynote] The Flutter Effect',
    category: 'Talk',
    link: 'https://2025.flutterkaigi.jp/',
    image: 'projectImg/talk110.webp',
    meta: L.same('FlutterKaigi 2025'),
  ),
  PortfolioItem(
    id: 111,
    title: 'Flutterの“秘密の超能力”がヤバい！【誰も気づいていない】',
    category: 'Talk',
    link: 'https://www.youtube.com/watch?v=uzsZnsmbOmU&t=5948s',
    image: 'projectImg/talk111.webp',
    meta: L('DevFest 2025 Greater Kwansai · Recording', 'DevFest 2025 Greater Kwansai · 録画'),
  ),
  PortfolioItem(
    id: 112,
    title: 'No More Anxiety: iOS Extensions in Flutter',
    category: 'Talk',
    link: 'https://www.youtube.com/watch?v=b8lfmkBB0vg',
    image: 'projectImg/talk112.webp',
    meta: L('Fluttercon EU 2025 · Recording', 'Fluttercon EU 2025 · 録画'),
  ),
  PortfolioItem(
    id: 113,
    title: 'Flutter Sceneで3D表現に挑戦！試行錯誤から学んだこと',
    category: 'Talk',
    link: 'https://youtrust.jp/lp/knowledgenight-vol2-flutter-online',
    image: 'projectImg/talk113.webp',
    meta: L.same('YOUTRUST Knowledge Night vol.2 Flutter'),
  ),
  PortfolioItem(
    id: 114,
    title:
        'Write integration tests as high-quality as Wagyu beef with '
        'Patrol! (MVP 🏆)',
    category: 'Talk',
    link: 'https://fluttergakkai.connpass.com/event/359514/',
    image: 'projectImg/talk114.webp',
    meta: L.same('FlutterGakkai'),
  ),
  PortfolioItem(
    id: 115,
    title:
        'Create a Multi-Million-Download App for Free! The Power of the '
        'Smartphone-Compatible AI ‘Gemma’',
    category: 'Talk',
    link: 'https://www.youtube.com/watch?v=rIPHc6IhqAE&t=169s&ab_channel=GDGTokyo',
    image: 'projectImg/talk115.webp',
    meta: L('Google I/O Extended Tokyo 2025 · Recording', 'Google I/O Extended Tokyo 2025 · 録画'),
  ),
  PortfolioItem(
    id: 116,
    title:
        'Recreating Liquid Glass in Flutter: Embracing the New UI Era of '
        'iOS 26 + Panel talk',
    category: 'Talk',
    link: 'https://flutter-jp.connpass.com/event/359088/',
    image: 'projectImg/talk116.webp',
    meta: L.same('Flutter Tokyo #9'),
  ),
  PortfolioItem(
    id: 117,
    title: 'ListView.builderの謎：効率的リスト構築の秘密を解明',
    category: 'Talk',
    link: 'https://enechange-meetup.connpass.com/event/347260/',
    image: 'projectImg/talk117.webp',
    meta: L.same('Flutter開発の舞台裏！3社のエンジニアがおくるLTナイト'),
  ),
  PortfolioItem(
    id: 118,
    title: 'Part of Team Flutter',
    category: 'Talk',
    link: 'https://dena.connpass.com/event/339747/',
    image: 'projectImg/talk118.webp',
    meta: L.same('突撃！隣のモバイルプラットフォーム！'),
  ),
  PortfolioItem(
    id: 119,
    title: 'テキスト入力のUXを改善',
    category: 'Talk',
    link: 'https://yumemi.connpass.com/event/340473/',
    image: 'projectImg/talk119.webp',
    meta: L.same('YOUTRUST x ビビッドガーデン x ゆめみ Flutter LT会@渋谷 #7'),
  ),
  PortfolioItem(
    id: 120,
    title: '僕のstate restorationアカデミア',
    category: 'Talk',
    link: 'https://www.youtube.com/watch?v=ZEpcXKXSIyI',
    image: 'projectImg/talk120.webp',
    meta: L('FlutterKaigi 2024 · Recording', 'FlutterKaigi 2024 · 録画'),
  ),
  PortfolioItem(
    id: 121,
    title: 'Don’t Leave Your Assets in Their Pajamas—Transform Them!',
    category: 'Talk',
    link: 'https://www.meetup.com/de-DE/fluttervienna/events/303135184/?eventOrigin=group_events_list',
    image: 'projectImg/talk121.webp',
    meta: L.same('22nd Flutter Vienna Meetup at LEAN-CODERS'),
  ),
  PortfolioItem(
    id: 122,
    title:
        'Saving data before the app getting killed! Easy state '
        'restoration with Flutter',
    category: 'Talk',
    link:
        'https://www.droidcon.com/2024/09/03/saving-data-before-the-app-getting-killed-easy-state-restoration-with-flutter/',
    meta: L('Fluttercon 2024 · Recording', 'Fluttercon 2024 · 録画'),
  ),
  PortfolioItem(
    id: 123,
    title: 'Flutter Web Laughs: Element Embedding Made Easy',
    category: 'Talk',
    link: 'https://www.youtube.com/watch?v=Hhq5PRD6c3I',
    image: 'projectImg/talk123.webp',
    meta: L('Flutterconnection 2024 · Recording', 'Flutterconnection 2024 · 録画'),
  ),
  PortfolioItem(
    id: 124,
    title: 'flutterでエレメントエンベディング',
    category: 'Talk',
    link: 'https://www.youtube.com/live/uuaxvgKrDtE?feature=shared&t=25508',
    image: 'projectImg/talk124.webp',
    meta: L('GDG DevFest Tokyo 2023 · Recording', 'GDG DevFest Tokyo 2023 · 録画'),
  ),
  PortfolioItem(
    id: 125,
    title: 'Comparing ways of accessing native functionality',
    category: 'Talk',
    link: 'https://droidcon.com/2023/08/07/comparing-ways-of-accessing-native-functionality/',
    meta: L('Fluttercon 2023 · Recording', 'Fluttercon 2023 · 録画'),
  ),
];

/// The tiles the All filter opens on.
///
/// All used to mean every tile in order, which put a row of app icons above a
/// row of websites and pushed the writing and the speaking onto page two: the
/// first thing anyone saw said nothing about most of the work. It is a chosen
/// sample now — a few apps and sites by hand, and the newest articles and
/// talks, which stay current on their own because the list of record is kept
/// newest first.
final showcaseItems = dealByKind([
  _picked(const [5, 1, 4]), // Dream Lucid Now!, Pushup Bro, ReadOn
  _newest('Talk', 3),
  _picked(const [10, 11]), // the personal site, FlowUs
  _newest('Article', 2),
]);

/// The tiles with these ids, in the order the ids are written.
///
/// An id that matches nothing is passed over rather than thrown on: a tile
/// renamed out from under this list should cost the showcase one entry, not
/// the whole section.
List<PortfolioItem> _picked(List<int> ids) => [
  for (final id in ids) ...portfolioItems.where((item) => item.id == id),
];

/// The newest [count] tiles of a category, which is the front of the list.
List<PortfolioItem> _newest(String category, int count) =>
    portfolioItems.where((item) => item.category == category).take(count).toList();

/// Deals one tile from each pile in turn until the piles run out.
///
/// A grid filled straight from the list of record is a block of apps, then a
/// block of sites, then pages of nothing but articles. Dealing them round by
/// round instead means a row holds several kinds, and a pile that runs out
/// early simply stops being dealt from rather than leaving a gap.
List<PortfolioItem> dealByKind(List<List<PortfolioItem>> piles) {
  final deepest = piles.fold<int>(0, (deepest, pile) => pile.length > deepest ? pile.length : deepest);
  return [
    for (var round = 0; round < deepest; round++)
      for (final pile in piles)
        if (round < pile.length) pile[round],
  ];
}

/// The Rive file playing on the phone beside the contact form.
///
/// It replaces a Google Maps embed that pinned a private address, and one in
/// the wrong country at that.
const riveScene = 'rive/flappy_flap_flap.riv';

/// The artboard and state machine to run.
///
/// The file's default artboard is only the scene: the bird sits on the floor
/// and nothing responds to a tap. This one nests that scene together with the
/// score and the hitbox, and is the one that actually plays.
const riveArtboard = 'contrOL ya heard';
const riveStateMachine = 'flappy flap flap';

/// What the file says when the bird dies.
///
/// It reports nothing directly: it enters a state and fires a sound event.
/// Either name arriving is taken as the end of a run, so renaming one of them
/// in the editor does not leave the restart button unreachable.
const riveDeathSignals = <String>['hitBOxx 0', 'death sound'];

/// How long the file's opening iris takes, in seconds.
///
/// The game opens behind a circular mask that widens until the screen is
/// clear. A tap during that sends the state machine straight into play and
/// leaves the mask frozen part-open, black in every corner for the rest of the
/// run, so taps are held until it has finished. The number is the `loading`
/// animation's own length, 60 frames at 60fps; it is here beside the artboard
/// and state machine names because, like them, it comes from the file.
const riveIntroSeconds = 1.0;

/// The strings the hero's typewriter cycles through.
const typewriterStrings = [
  L('Flutter Engineer', 'Flutter\u30a8\u30f3\u30b8\u30cb\u30a2'),
  L('iOS Engineer', 'iOS\u30a8\u30f3\u30b8\u30cb\u30a2'),
  L('Android Engineer', 'Android\u30a8\u30f3\u30b8\u30cb\u30a2'),
  L('Backend Engineer', '\u30d0\u30c3\u30af\u30a8\u30f3\u30c9\u30a8\u30f3\u30b8\u30cb\u30a2'),
  L('Frontend Engineer', '\u30d5\u30ed\u30f3\u30c8\u30a8\u30f3\u30b8\u30cb\u30a2'),
];
