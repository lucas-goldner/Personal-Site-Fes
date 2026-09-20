// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:persona_site/components/gde_badge.dart' as _gde_badge;
import 'package:persona_site/components/progress.dart' as _progress;
import 'package:persona_site/pages/home_page.dart' as _home_page;
import 'package:persona_site/sections/about.dart' as _about;
import 'package:persona_site/sections/services.dart' as _services;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',
  clients: {_home_page.HomeApp: ClientTarget<_home_page.HomeApp>('home_page')},
  styles: () => [
    ..._gde_badge.GdeBadge.styles,
    ..._progress.Progress.styles,
    ..._about.About.styles,
    ..._services.Services.styles,
  ],
);
