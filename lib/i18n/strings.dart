/// Every piece of wording the site says in its own voice, in both languages.
///
/// Content that belongs to a thing — a skill bar, an expertise card, a project
/// tile — carries its own translation in `site_data.dart`. What is left here is
/// the chrome: headings, labels, placeholders and the handful of sentences the
/// page speaks directly.
library;

import 'lang.dart';

/// The chrome, as pairs.
abstract final class Strings {
  // The document itself.
  static const title = L(
    'Lucas Goldner - Persona(l) Portfolio Website',
    'Lucas Goldner — ポートフォリオサイト',
  );
  static const description = L(
    'Persona(l) site of a Web- and Mobile Developer with all of his projects',
    'Web・モバイル開発者 Lucas Goldner '
        'のポートフォリオサイト。'
        'これまでの仕事をまとめています。',
  );

  static String documentTitle(Lang lang) => title(lang);
  static String documentDescription(Lang lang) => description(lang);

  // Navigation.
  static const navHome = L('Home', 'ホーム');
  static const navAbout = L('About', 'プロフィール');
  static const navExpertise = L('Expertise', '専門分野');
  static const navPortfolio = L('Portfolio', 'ポートフォリオ');
  static const navContact = L('Contact', 'お問い合わせ');

  /// In the same order as `sectionIds`.
  static const navLabels = [navHome, navAbout, navExpertise, navPortfolio, navContact];

  static const languageLabel = L('Language', '言語');

  // Hero.
  static const downloadCv = L('Download CV', 'CVをダウンロード');

  // About.
  static const aboutEyebrow = L('About Me', '私について');
  static const aboutHeadline = L(
    'Mobile Engineer. Builder. Speaker.',
    'モバイルエンジニア。'
        'つくる人。登壇する人。',
  );
  static const aboutWorkBefore = L(
    'I’m a mobile engineer based in Japan, specializing in Flutter and Dart. At ',
    '日本を拠点に、FlutterとDartを専門とする'
        'モバイルエンジニアです。現在は',
  );
  static const aboutWorkAfter = L(
    ' I build and improve a large-scale production app, and contribute to technical '
        'direction, architecture, performance, testing and developer experience.',
    'で大規模なプロダクションアプリの'
        '開発と改善を担当し、技術的な'
        '方向性、アーキテクチャ、'
        'パフォーマンス、テスト、'
        '開発者体験にも貢献しています。',
  );
  static const aboutDeeperBefore = L(
    'I like digging deeper than the screens — Flutter internals, shaders and '
        'rendering, native iOS integrations and platform APIs. I’m also a ',
    '画面の向こう側を掘り下げるのが'
        '好きです。Flutterの内部実装、'
        'シェーダーとレンダリング、'
        'ネイティブiOS連携やプラット'
        'フォームAPIなど。また、',
  );
  static const aboutDeeperBetween = L(
    ' and an organizer of ',
    'でもあり、',
  );
  static const aboutDeeperAfter = L(
    ', where I share what I learn with the community.',
    'のオーガナイザーとして、'
        '学んだことをコミュニティに'
        '共有しています。',
  );
  static const aboutBackground = L(
    'Before Flutter I worked across Android, iOS, web, Unity and backend. That '
        'background still shapes how I work: understand the whole product, experiment '
        'with new technology, and turn ideas into things people can actually use.',
    'Flutterに出会う前は、Android、iOS、Web、'
        'Unity、バックエンドと幅広く'
        '開発してきました。その経験は'
        '今の働き方にも生きています。'
        'プロダクト全体を理解し、'
        '新しい技術を試し、アイデアを'
        '実際に使えるものにすること。',
  );
  static const aboutOutside = L(
    'Outside of work I’m usually building side projects, experimenting with UI '
        'ideas, writing technical articles, or preparing my next Flutter talk.',
    '仕事以外の時間は、個人開発を'
        'したり、UIのアイデアを試したり、'
        '技術記事を書いたり、次のFlutter'
        '登壇の準備をしていることが'
        '多いです。',
  );
  static const skillsHeading = L('My Skills', 'スキル');

  /// The credential in the hero and in the about text. A programme name, so it
  /// stays as it is written.
  static const gdeTitle = L.same('Flutter & Dart Google Developer Expert');

  // Expertise.
  static const expertiseEyebrow = L('Expertise', '専門分野');
  static const expertiseHeading = L('What I Do', 'できること');

  // Portfolio.
  static const portfolioHeading = L('Portfolio', 'ポートフォリオ');
  static const filterAll = L('All', 'すべて');
  static const previousPage = L('Previous page', '前のページ');
  static const nextPage = L('Next page', '次のページ');

  /// The portfolio categories, keyed by the English name the data uses.
  static const categories = <String, L>{
    'App': L('App', 'アプリ'),
    'Website': L('Website', 'ウェブサイト'),
    'Article': L('Article', '記事'),
    'Talk': L('Talk', '登壇'),
  };

  static String category(String name, Lang lang) => (categories[name] ?? L.same(name))(lang);

  // Contact.
  static const contactHeading = L('Contact', 'お問い合わせ');
  static const contactEyebrow = L('Get In Touch', 'お気軽にご連絡ください');
  static const fieldName = L('Name', 'お名前');
  static const fieldEmail = L('Email', 'メールアドレス');
  static const fieldPhone = L('Phone', '電話番号');
  static const fieldMessage = L('Message', 'メッセージ');
  static const sendMessage = L('Send Message', '送信する');
  static const sendSucceeded = L('Email sent!', '送信しました！');
  static const sendFailed = L(
    'Sending failed, please try again.',
    '送信に失敗しました。'
        'もう一度お試しください。',
  );

  // The game on the phone beside the form.
  static const gameLabel = L(
    'Flappy Bird game, built in Rive — tap to play',
    'Riveで作ったFlappy Birdゲーム — '
        'タップで遊べます',
  );
  static const gameCaption = L(
    'Fun is a feature. Get in touch and I’ll build one into your product.',
    '楽しさも機能のひとつ。'
        'ご相談いただければ、あなたの'
        'プロダクトにも組み込みます。',
  );
  static const gameOver = L('Game over', 'ゲームオーバー');
  static const playAgain = L('Play again', 'もう一度');

  // The 404 page.
  static const notFoundTitle = L('Error : 404', 'エラー : 404');
  static const notFoundText = L(
    'The page you are looking for could not be found',
    'お探しのページは見つかりませんでした',
  );
  static const notFoundHome = L('Home', 'ホーム');
}
