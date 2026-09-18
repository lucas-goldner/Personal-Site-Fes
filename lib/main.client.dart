/// The entrypoint for the **client** environment.
///
/// Mounts and hydrates every `@client` component that was pre-rendered during
/// static generation.
library;

import 'package:jaspr/client.dart';

import 'main.client.options.dart';

void main() {
  Jaspr.initializeApp(options: defaultClientOptions);
  runApp(const ClientApp());
}
