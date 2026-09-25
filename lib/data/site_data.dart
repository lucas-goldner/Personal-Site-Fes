/// All page content, extracted from the JSON files and hard-coded strings of
/// the previous Gatsby site so the sections stay declarative.
library;

import '../components/icons_data.dart';

/// Document metadata, previously `data/meta.json`.
class SiteMeta {
  static const title = 'Lucas Goldner - Persona(l) Portfolio Website';
  static const description = 'Persona(l) site of a Web- and Mobile Developer with all of his projects';

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
/// handler; the labels are the navigation entries.
const sectionIds = ['home', 'about', 'services', 'portfolio', 'contact'];
const sectionLabels = ['Home', 'About', 'Expertise', 'Portfolio', 'Contact'];

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
}

const heroIcons = <HeroIcon>[
  HeroIcon('heroIcons/pc.png', 74.2, moveUp: true),
  HeroIcon('heroIcons/brazil.png', 13.6, moveUp: false),
  HeroIcon('heroIcons/party.png', 78.1, moveUp: false),
  HeroIcon('heroIcons/tarot.png', 11.4, moveUp: true),
  HeroIcon('heroIcons/japan.png', 72.5, moveUp: true),
  HeroIcon('heroIcons/draw.png', 17.9, moveUp: false),
  HeroIcon('heroIcons/video.png', 76.3, moveUp: true),
  HeroIcon('heroIcons/controller.png', 15.2, moveUp: false),
  HeroIcon('heroIcons/gym.png', 70.8, moveUp: false),
  HeroIcon('heroIcons/inline.png', 18.7, moveUp: true),
];

/// The photo of Lucas shown on the right half of the hero.
const heroImage = 'person2x.png';
const heroImageAlt = 'Lucas Goldner with inline skates posing in front of a graffiti wall';

/// Lucas's employer, linked from the about text.
const youtrustUrl = 'https://youtrust.jp/';

/// The Flutter Tokyo meetup Lucas organises, linked from the about text.
const flutterTokyoUrl = 'https://flutter-jp.connpass.com/';

/// The Google Developer Expert programme page, linked from the hero credential.
const gdeUrl = 'https://developers.google.com/community/experts';

/// Link behind the hero's "Download CV" button.
const cvUrl = 'https://drive.google.com/file/d/1iRmTNFP1dI41ZUowzwdVZeJGzOwKNIjE/view?usp=sharing';

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

  final String name;

  /// How far the bar fills, 0 to 100. Previously a 1-5 level rendered at
  /// `value * 20%`, which could not express the values this list needs.
  final int percent;

  /// The wording shown on the right of the bar.
  final String label;
}

const skills = <Skill>[
  Skill('Flutter & Dart', 100, 'Primary Stack'),
  Skill('iOS & Swift', 85, 'Advanced'),
  Skill('Architecture & Scalability', 85, 'Advanced'),
  Skill('Testing & Quality', 80, 'Advanced'),
  Skill('TypeScript \u2014 Backend & Frontend', 75, 'Proficient'),
  Skill('Android & Kotlin', 50, 'Experienced'),
  Skill('AI-Assisted Development \u2014 Claude Code', 100, 'Primary Stack'),
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
  final String title;

  /// The stack behind the area, shown as a smaller line under the title.
  final String technologies;

  final String text;

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
    title: 'Mobile App Development',
    technologies: 'Flutter \u00b7 SwiftUI \u00b7 Jetpack Compose',
    text:
        'Flutter is my primary stack, with SwiftUI and Jetpack '
        'Compose when native makes more sense.',
    delay: 200,
    animation: 'fadeInLeft fast',
  ),
  Service(
    icon: faLaptopCode,
    title: 'Frontend Development',
    technologies: 'React \u00b7 Next.js \u00b7 TypeScript',
    text:
        'Modern web apps with maintainable components, responsive '
        'interfaces and clean backend integration.',
    delay: 400,
    animation: 'fadeInDown fast',
  ),
  Service(
    icon: faServer,
    title: 'Backend & Infrastructure',
    technologies: 'NestJS \u00b7 MongoDB \u00b7 PostgreSQL \u00b7 Azure \u00b7 GCP \u00b7 Terraform',
    text:
        'APIs and services, relational and document databases, and '
        'the cloud infrastructure they run on.',
    delay: 600,
    animation: 'fadeInRight fast',
  ),
  Service(
    icon: faLayerGroup,
    title: 'Mobile Architecture',
    technologies: 'Architecture \u00b7 State Management \u00b7 Technical Design',
    text:
        'Technical design and state management that keep an app '
        'maintainable as the product and the team grow.',
    delay: 800,
    animation: 'fadeInLeft fast',
  ),
  Service(
    icon: faVials,
    title: 'Testing & Quality',
    technologies: 'Widget \u00b7 Golden \u00b7 E2E \u00b7 QA',
    text:
        'Widget, golden and end-to-end tests, plus the QA planning '
        'and tracking that make releases predictable.',
    delay: 1000,
    animation: 'fadeInUp fast',
  ),
  Service(
    icon: faUsers,
    title: 'Team Growth & Mentoring',
    technologies: 'Code Reviews \u00b7 Mentoring \u00b7 Internal Education',
    text:
        'Code reviews, mentoring and study sessions that help '
        'engineers grow into confident, independent work.',
    delay: 1200,
    animation: 'fadeInRight fast',
  ),
  Service(
    icon: faRobot,
    title: 'AI-Assisted Engineering',
    technologies: 'Claude Code \u00b7 Agentic Development',
    text:
        'Claude Code across implementation, debugging and '
        'refactoring, with the engineering decisions and the code '
        'quality staying under human control.',
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
  final String text;
  final String symbol;

  /// Duration of the count-up animation, in seconds.
  final int duration;
}

/// The figures the counters count up to.
///
/// Kept apart from [counters] so the numbers can be bumped in one place
/// without touching the icons or the wording around them.
abstract final class Stats {
  static const appsShipped = 12;
  static const articlesPublished = 30;
  static const talksDelivered = 40;
}

const counters = <CounterData>[
  CounterData(faMobileAlt, Stats.appsShipped, 'Shipped', 'Apps', 2),
  CounterData(faPenNib, Stats.articlesPublished, 'Published', 'Articles', 3),
  CounterData(faMicrophoneAlt, Stats.talksDelivered, 'Delivered', 'Talks', 4),
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
  final String? meta;
}

/// The App Store apps, the sites, and the writing and speaking.
///
/// The articles and talks are kept in step with
/// https://github.com/lucas-goldner/Talks-Articles-Events, which is the list
/// of record for them.
///
/// TODO(lucas): none of the apps has artwork in the repository, so they stand
/// as panels; drop an icon into web/projectImg and set `image` to turn one
/// into a picture tile.
const portfolioItems = <PortfolioItem>[
  PortfolioItem(
    id: 1,
    title: 'Pushup Bro',
    category: 'App',
    link: 'https://apps.apple.com/jp/app/pushup-bro/id1673181014',
    meta: 'iOS \u00b7 Push-up tracking with AirPods',
  ),
  PortfolioItem(
    id: 2,
    title: 'Japanana',
    category: 'App',
    link: 'https://apps.apple.com/jp/app/japanana-japanese-grammar/id6476447175',
    meta: 'iOS \u00b7 Japanese grammar',
  ),
  PortfolioItem(
    id: 3,
    title: 'Giro',
    category: 'App',
    link: 'https://apps.apple.com/jp/app/giro-mark-past-walks/id6737528413',
    meta: 'iOS \u00b7 Marking past walks',
  ),
  PortfolioItem(
    id: 4,
    title: 'ReadOn',
    category: 'App',
    link: 'https://apps.apple.com/jp/app/readon-read-in-any-language/id6757393728',
    meta: 'iOS \u00b7 Reading in any language',
  ),
  PortfolioItem(
    id: 5,
    title: 'Dream Lucid Now!',
    category: 'App',
    link: 'https://apps.apple.com/jp/app/dream-lucid-now-dreams-sleep/id6752128546',
    meta: 'iOS \u00b7 Dreams and sleep',
  ),
  PortfolioItem(
    id: 10,
    title: 'Personal Website',
    category: 'Website',
    link: 'https://lucas-goldner.com',
    image: 'projectImg/personalSite.jpg',
    meta: 'Jaspr \u00b7 Dart',
  ),
  PortfolioItem(
    id: 11,
    title: 'FlowUs Website',
    category: 'Website',
    link: 'https://flowus.vercel.app',
    image: 'projectImg/flowUs.png',
    meta: 'Next.js',
  ),
  PortfolioItem(
    id: 12,
    title: 'Kawa Druck Homepage',
    category: 'Website',
    link: 'https://kawa-druck.de',
    image: 'projectImg/kawaPage.png',
    meta: 'React',
  ),
  PortfolioItem(
    id: 13,
    title: 'NFT Metro Website',
    category: 'Website',
    link: 'https://old-metro.vercel.app',
    image: 'projectImg/nifterPage.png',
    meta: 'React',
  ),
  PortfolioItem(
    id: 14,
    title: 'Golden Website',
    category: 'Website',
    link: 'https://golden.lucas-goldner.com',
    image: 'projectImg/golden.png',
    meta: 'React',
  ),
  PortfolioItem(
    id: 20,
    title: '拙者、FlutterNinjas2025にて修行して参った！',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/flutterninjas2025-day-one',
    meta: 'YOUTRUST Tech Blog',
  ),
  PortfolioItem(
    id: 21,
    title: '美味しいチーズ牛丼を通じて、ListView.builderのfindChildIndexCallbackについて学びませんか？',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/flutter-findchildindexcallback',
    meta: 'YOUTRUST Tech Blog',
  ),
  PortfolioItem(
    id: 22,
    title: 'AndroidでFlutterアプリでイメージ選択に気をつけろ',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/flutter-image-picking-android',
    meta: 'YOUTRUST Tech Blog',
  ),
  PortfolioItem(
    id: 23,
    title: 'テキスト入力のUXを改善しました',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/app-text-ux-improvements',
    meta: 'YOUTRUST Tech Blog',
  ),
  PortfolioItem(
    id: 24,
    title: 'FlutterKaigi 2024に参加してきました！',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/2024/11/27/184941',
    meta: 'YOUTRUST Tech Blog',
  ),
  PortfolioItem(
    id: 25,
    title: 'Flutter Connection参加レポート',
    category: 'Article',
    link: 'https://tech.youtrust.co.jp/entry/2024/08/07/184732',
    meta: 'YOUTRUST Tech Blog',
  ),
  PortfolioItem(
    id: 26,
    title: 'Flutter エレメントエンべディング・アプリを ウェブサイト内に入れられるの力！AngularやReactまでもできる！',
    category: 'Article',
    link: 'https://qiita.com/LucasGoldner/items/64b9e74f5b982465cf76',
    meta: 'Qiita \u00b7 Zenn',
  ),
  PortfolioItem(
    id: 27,
    title:
        'Flutter Element Embedding \u2014 Unleashing the Power of Integrating Flutter Apps into Websites, including React-powered ones!',
    category: 'Article',
    link:
        'https://medium.com/@lucas.goldner/flutter-element-embedding-unleashing-the-power-of-integrating-flutter-apps-into-websites-e91c84c13f2d',
    meta: 'Medium',
  ),
  PortfolioItem(
    id: 28,
    title: '僕の最初のテックトーク、どうやって乗り越えたか - Fluttercon2023',
    category: 'Article',
    link: 'https://qiita.com/LucasGoldner/items/7583c9bc1316286b9121',
    meta: 'Qiita',
  ),
  PortfolioItem(
    id: 29,
    title: 'How I Survived My First BIG Tech Presentation \u2014 Fluttercon 2023',
    category: 'Article',
    link:
        'https://medium.com/@lucas.goldner/how-i-survived-my-first-big-tech-presentation-fluttercon-2023-f6c1c10f0263',
    meta: 'Medium',
  ),
  PortfolioItem(
    id: 30,
    title: 'Flutterで簡単プレゼンをする - FlutterShow⚡',
    category: 'Article',
    link: 'https://qiita.com/LucasGoldner/items/225a793035820137fc18',
    meta: 'Qiita',
  ),
  PortfolioItem(
    id: 31,
    title: 'Presentations made easy in Flutter - FlutterShow⚡',
    category: 'Article',
    link: 'https://medium.com/@lucas.goldner/presentations-made-easy-in-flutter-fluttershow-79ab316253b5',
    meta: 'Medium',
  ),
  PortfolioItem(
    id: 40,
    title: 'ListView.builderの謎：効率的リスト構築の秘密を解明',
    category: 'Talk',
    link: 'https://enechange-meetup.connpass.com/event/347260/',
    meta: 'Flutter開発の舞台裏！3社のエンジニアがおくるLTナイト',
  ),
  PortfolioItem(
    id: 41,
    title: 'Part of Team Flutter',
    category: 'Talk',
    link: 'https://dena.connpass.com/event/339747/',
    meta: '突撃！隣のモバイルプラットフォーム！',
  ),
  PortfolioItem(
    id: 42,
    title: 'テキスト入力のUXを改善',
    category: 'Talk',
    link: 'https://yumemi.connpass.com/event/340473/',
    meta: 'YOUTRUST x ビビッドガーデン x ゆめみ Flutter LT会@渋谷 #7',
  ),
  PortfolioItem(
    id: 43,
    title: '僕のstate restorationアカデミア',
    category: 'Talk',
    link: 'https://www.youtube.com/watch?v=ZEpcXKXSIyI',
    meta: 'FlutterKaigi 2024 \u00b7 Recording',
  ),
  PortfolioItem(
    id: 44,
    title: 'Don\u2019t Leave Your Assets in Their Pajamas\u2014Transform Them!',
    category: 'Talk',
    link: 'https://www.meetup.com/de-DE/fluttervienna/events/303135184/',
    meta: '22nd Flutter Vienna Meetup',
  ),
  PortfolioItem(
    id: 45,
    title: 'Saving data before the app getting killed! Easy state restoration with Flutter',
    category: 'Talk',
    link:
        'https://www.droidcon.com/2024/09/03/saving-data-before-the-app-getting-killed-easy-state-restoration-with-flutter/',
    meta: 'Fluttercon 2024 \u00b7 Recording',
  ),
  PortfolioItem(
    id: 46,
    title: 'Flutter Web Laughs: Element Embedding Made Easy',
    category: 'Talk',
    link: 'https://www.youtube.com/watch?v=Hhq5PRD6c3I',
    meta: 'Flutterconnection 2024 \u00b7 Recording',
  ),
  PortfolioItem(
    id: 47,
    title: 'flutterでエレメントエンベディング',
    category: 'Talk',
    link: 'https://www.youtube.com/live/uuaxvgKrDtE?feature=shared&t=25508',
    meta: 'GDG DevFest Tokyo 2023 \u00b7 Recording',
  ),
  PortfolioItem(
    id: 48,
    title: 'Comparing ways of accessing native functionality',
    category: 'Talk',
    link: 'https://droidcon.com/2023/08/07/comparing-ways-of-accessing-native-functionality/',
    meta: 'Fluttercon 2023 \u00b7 Recording',
  ),
];

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

/// What a screen reader gets in place of a bare canvas. It describes the
/// thing itself, which the line underneath the phone no longer does.
const riveSceneLabel = 'Flappy Bird game, built in Rive \u2014 tap to play';

/// The line under the phone. The game is the argument; this is the ask.
const riveSceneCaption = 'Fun is a feature. Get in touch and I\'ll build one into your product.';

/// The strings the hero's typewriter cycles through.
const typewriterStrings = [
  'Flutter Engineer',
  'iOS Engineer',
  'Android Engineer',
  'Backend Engineer',
  'Frontend Engineer',
];
