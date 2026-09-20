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
    this.borderSide = false,
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

  /// Whether the card carries the vertical dividers of the middle column.
  final bool borderSide;

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
        'I build mobile applications across Flutter and native platforms, '
        'from polished UI and complex product features to platform-specific '
        'integrations. Flutter is my primary stack, while I also work with '
        'SwiftUI and Jetpack Compose when native development makes sense.',
    delay: 200,
    animation: 'fadeInLeft fast',
  ),
  Service(
    icon: faLaptopCode,
    title: 'Frontend Development',
    technologies: 'React \u00b7 Next.js \u00b7 TypeScript',
    text:
        'I build modern web applications using React, Next.js, and '
        'TypeScript, with a focus on maintainable components, responsive '
        'interfaces, good user experience, and clean integration with backend '
        'services.',
    delay: 400,
    animation: 'fadeInDown fast',
    borderSide: true,
  ),
  Service(
    icon: faServer,
    title: 'Backend & Infrastructure',
    technologies: 'NestJS \u00b7 MongoDB \u00b7 PostgreSQL \u00b7 Azure \u00b7 GCP \u00b7 Terraform',
    text:
        'I work across backend development and infrastructure, building APIs '
        'and services with NestJS, working with MongoDB and PostgreSQL, and '
        'deploying and managing cloud infrastructure using Azure, GCP, and '
        'Terraform.',
    delay: 600,
    animation: 'fadeInRight fast',
  ),
  Service(
    icon: faLayerGroup,
    title: 'Mobile Architecture',
    technologies: 'Architecture \u00b7 State Management \u00b7 Technical Design',
    text:
        'I work on scalable mobile architecture, state management, reusable '
        'components, technical design, platform boundaries, and engineering '
        'decisions that keep applications maintainable as products and teams '
        'grow.',
    delay: 800,
    animation: 'fadeInLeft fast',
  ),
  Service(
    icon: faVials,
    title: 'Testing & Quality',
    technologies: 'Widget \u00b7 Golden \u00b7 E2E \u00b7 QA',
    text:
        'I build quality into the development process through widget, golden, '
        'and end-to-end testing. I also work on QA planning, QA sheet '
        'creation, test-case definition, execution, bug tracking, regression '
        'testing, and improving release confidence.',
    delay: 1000,
    animation: 'fadeInUp fast',
    borderSide: true,
  ),
  Service(
    icon: faUsers,
    title: 'Team Growth & Mentoring',
    technologies: 'Code Reviews \u00b7 Mentoring \u00b7 Internal Education',
    text:
        'I help engineers grow through code reviews, technical feedback, '
        'mentoring, and knowledge sharing. I organize internal study '
        'sessions, prepare learning materials, explain technical concepts, '
        'and help engineers become more confident and independent.',
    delay: 1200,
    animation: 'fadeInRight fast',
  ),
  Service(
    icon: faRobot,
    title: 'AI-Assisted Engineering',
    technologies: 'Claude Code \u00b7 Agentic Development',
    text:
        'AI-assisted development is part of my primary engineering workflow. '
        'I use Claude Code for implementation, codebase exploration, '
        'debugging, refactoring, testing, and accelerating larger development '
        'tasks while keeping engineering decisions and code quality under '
        'human control.',
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

/// A project tile, previously `data/portfolio.json`.
class PortfolioItem {
  const PortfolioItem(this.id, this.title, this.category, this.link, this.image);

  /// Stable identity, carried over from the ids in the original portfolio.json.
  ///
  /// Two projects legitimately share a link (the FlowUs app and its landing
  /// page), so the link cannot be used to tell tiles apart.
  final int id;

  final String title;

  /// Used by the All / App / Website filter.
  final String category;
  final String link;
  final String image;
}

const portfolioItems = <PortfolioItem>[
  PortfolioItem(1, 'NFT Metro App (React Native)', 'App', 'https://nftmetro.com', 'projectImg/nifter.png'),
  PortfolioItem(
    2,
    'NFT Metro Landing Page (React)',
    'Website',
    'https://old-metro.vercel.app',
    'projectImg/nifterPage.png',
  ),
  PortfolioItem(3, 'Kawa Druck Home Page (React)', 'Website', 'https://kawa-druck.de', 'projectImg/kawaPage.png'),
  PortfolioItem(4, 'FlowUs Landing Page (NextJS)', 'Website', 'https://flowus.vercel.app', 'projectImg/flowUs.png'),
  PortfolioItem(5, 'FlowUs App (Swift)', 'App', 'https://flowus.vercel.app', 'projectImg/flowUsApp.png'),
  PortfolioItem(6, 'DailyTarot (Angular)', 'Website', 'https://tarot.lucas-goldner.com', 'projectImg/tarot.png'),
  PortfolioItem(
    7,
    'Daily Tarot (React Native)',
    'App',
    'https://play.google.com/store/apps/details?id=com.lucasgoldner.DailyTarotApp',
    'projectImg/DailyTarotApp.webp',
  ),
  PortfolioItem(
    8,
    'Golden a Netflix Clone (React)',
    'Website',
    'https://golden.lucas-goldner.com',
    'projectImg/golden.png',
  ),
  PortfolioItem(9, 'Part of Webnetes Team', 'Website', 'https://webnetes.dev', 'projectImg/webnetes.png'),
  PortfolioItem(
    10,
    'Old Persona(l) Site (NextJS)',
    'Website',
    'https://old.lucas-goldner.com',
    'projectImg/oldSite.png',
  ),
  PortfolioItem(11, 'Demon Programm (React)', 'Website', 'https://demon-program.vercel.app/', 'projectImg/demon.png'),
];

/// The Google Maps embed shown next to the contact form.
const mapEmbedUrl =
    'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2619.671296609889'
    '!2d9.254451415905514!3d48.95974450151858!2m3!1f0!2f0!3f0!3m2!1i1024!2i768'
    '!4f13.1!3m3!1m2!1s0x4799cd709411aa19%3A0x943b069597674234!2sHeerstra%C3%9Fe'
    '%2013%2C%2071711%20Murr!5e0!3m2!1sde!2sde!4v1615071789410!5m2!1sde!2sde';

/// The strings the hero's typewriter cycles through.
const typewriterStrings = [
  'Flutter Engineer',
  'iOS Engineer',
  'Android Engineer',
  'Backend Engineer',
  'Frontend Engineer',
];
