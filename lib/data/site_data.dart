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
  /// cycles through, the skill bars, the service cards and the project tiles.
  /// Gatsby was dropped because the site no longer uses it and no project
  /// references it.
  static const keywords =
      'Lucas Goldner, portfolio, personal website, software developer, '
      'app developer, web developer, iOS developer, Android developer, '
      'frontend engineer, backend engineer, mobile development, '
      'Flutter, Dart, Swift, Kotlin, '
      'Java, TypeScript, JavaScript, Python, React, React Native, Angular, '
      'Next.js, Jaspr, microservices';
  static const author = 'Lucas Goldner';
}

/// The scroll-snapped sections of the home page, in order.
///
/// The ids double as the anchor targets used by the navigation and the wheel
/// handler; the labels are the navigation entries.
const sectionIds = ['home', 'about', 'services', 'portfolio', 'contact'];
const sectionLabels = ['Home', 'About', 'Services', 'Portfolio', 'Contact'];

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
  const SocialLink(this.icon, this.url);

  final FaIcon icon;
  final String url;
}

const socialLinks = <SocialLink>[
  SocialLink(faGithub, 'https://github.lucas-goldner.com'),
  SocialLink(faLinkedin, 'https://linkedin.lucas-goldner.com'),
  SocialLink(faYoutube, 'https://youtube.lucas-goldner.com'),
  SocialLink(faTwitter, 'https://www.twitter.lucas-goldner.com'),
  SocialLink(faStackOverflow, 'https://stackoverflow.lucas-goldner.com'),
];

/// A skill bar in the about section.
class Skill {
  const Skill(this.name, this.value, this.label);

  final String name;

  /// Level from 1 to 5; the bar is rendered at `value * 20%`.
  final int value;

  /// The wording shown on the right of the bar.
  final String label;
}

const skills = <Skill>[
  Skill('Dart', 5, 'Most comfortable'),
  Skill('TypeScript', 4, 'Advanced'),
  Skill('Java', 3, 'Comfortable'),
  Skill('Swift', 4, 'Advanced'),
  Skill('Python', 3, 'Comfortable'),
  Skill('Kotlin', 2, 'Basic'),
];

/// A card in the services section.
class Service {
  const Service({
    required this.icon,
    required this.title,
    required this.text,
    required this.delay,
    required this.animation,
    this.borderSide = false,
    this.solid = false,
  });

  final FaIcon icon;
  final String title;
  final String text;

  /// Delay in milliseconds before the card animates in.
  final int delay;

  /// The animate.css classes applied once the delay has elapsed.
  final String animation;

  /// Whether the card carries the vertical dividers of the middle column.
  final bool borderSide;

  /// Solid icons render one size smaller than brand icons.
  final bool solid;
}

const services = <Service>[
  Service(
    icon: faReact,
    title: 'Front-End React',
    text:
        'React is my first and also my favourite library to create '
        'websites. It is easy to get in, but the learn curve I would '
        'argue is big. Learning React really changed how I code '
        'personally. I can create amazing websites today in more or less '
        'two - three days, if I have enough time.',
    delay: 200,
    animation: 'fadeInLeft fast',
  ),
  Service(
    icon: faApple,
    title: 'IOS Apps',
    text:
        'Funnily enough I started IOS Development, because my friend '
        'needed help in his app. I had no idea of Swift, but I was able '
        'to help him out quickly. I have built already an entire social '
        'media app, a workout tracker, a jogging tracker and even '
        'voicechat with WebRTC.',
    delay: 400,
    animation: 'fadeInDown fast',
    borderSide: true,
  ),
  Service(
    icon: faMobile,
    title: 'React Native Apps',
    text:
        'When I found out about this framework I was really excited to '
        'try it out. React is my favourite library already and making '
        'apps with it seams like a dream. Crossplattform might be the '
        'future, so it is good, that I already launched a React Native '
        'app.',
    delay: 600,
    animation: 'fadeInRight fast',
  ),
  Service(
    icon: faAndroid,
    title: 'Android Apps',
    text:
        'This is where I really started coding. I made an entire social '
        'media app in Java by myself in around two - three months. It '
        'really changed the way I code. At the moment I am trying to get '
        'into Kotlin too.',
    delay: 800,
    animation: 'fadeInLeft fast',
  ),
  Service(
    icon: faAngular,
    title: 'Front-End Angular',
    text:
        'Yes I am able to make websites with Angular. Would I like to use '
        'React instead ? Yes, because I am much faster with React, but if '
        'you really need a website in Angular for some reason I can do '
        'that too.',
    delay: 1000,
    animation: 'fadeInUp fast',
    borderSide: true,
    solid: true,
  ),
  Service(
    icon: faServer,
    title: 'Microservices',
    text:
        'You need an API, a websocket server, a bot, a database ? Great '
        'because I have already worked on them all. Normally I use '
        'Javascript, to work on things as these, but I am also good in '
        'working with GO or Python.',
    delay: 1200,
    animation: 'fadeInRight fast',
    solid: true,
  ),
];

/// A count-up figure in the strip below the services.
class CounterData {
  const CounterData(this.icon, this.value, this.text, this.symbol, this.duration);

  final FaIcon icon;
  final int value;
  final String text;
  final String symbol;

  /// Duration of the count-up animation, in seconds.
  final int duration;
}

const counters = <CounterData>[
  CounterData(faSmileBeam, 4, 'Coding', 'Years', 2),
  CounterData(faPizzaSlice, 21, 'Finished', 'Projects', 5),
  CounterData(faCode, 749836, 'of Code', 'Lines', 15),
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
