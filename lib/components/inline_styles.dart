/// Reads the site stylesheet off disk at build time so it can go into the
/// document head as a `<style>` block instead of a `<link>`.
library;

import 'dart:io';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Where the stylesheet lives, relative to the project root.
const _stylesheet = 'web/styles/site.css';

/// The stylesheet, read once and reused for every route.
final String _css = _readStylesheet();

/// The site stylesheet as an inline `<style>` element.
///
/// A `<link>` in the head blocks rendering until the stylesheet comes back, and
/// nothing in it — including the six `@font-face` sources — is even discovered
/// before then. Gzipped the whole thing is well under 10 KiB, so folding it
/// into the document trades a round trip for a handful of kilobytes and lets
/// the fonts start downloading alongside the hero image rather than after it.
Component inlineSiteStyles() =>
    Component.element(tag: 'style', children: [RawText(_css)]);

String _readStylesheet() {
  final file = _locate();
  if (file == null) {
    // Never degrade quietly. A missing stylesheet renders a page that looks
    // catastrophically broken but returns 200, so fail the build instead.
    throw StateError(
      'Could not find $_stylesheet above ${Directory.current.path}. '
      'The document head inlines it, so the build cannot continue without it.',
    );
  }
  // The file is authored to sit at /styles/site.css, so its font sources climb
  // one directory. Inlined into a document they would resolve against the
  // page's own address instead, which differs per route, so make them absolute.
  return _compact(
    file.readAsStringSync().replaceAll('url(../fonts/', 'url(/fonts/'),
  );
}

/// Drops the working notes and the indentation, keeping the licence banners.
///
/// The stylesheet is written to be read, and once it is inlined every one of
/// those comments rides along in every document. Stripping them is worth about
/// a kilobyte compressed. Only whitespace containing a line break is touched,
/// so spacing that a selector or a `content` string depends on is left alone —
/// a full minifier would buy another 200 bytes and a class of silent bugs.
String _compact(String css) {
  final banners = <String>[];
  var out = css.replaceAllMapped(RegExp(r'/\*!.*?\*/', dotAll: true), (m) {
    banners.add(m[0]!);
    return '\u0000${banners.length - 1}\u0000';
  });
  out = out.replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '');
  out = out.replaceAll(RegExp(r'[ \t]*\n[ \t\n]*'), '\n');
  return out
      .replaceAllMapped(
        RegExp(r'\u0000(\d+)\u0000'),
        (m) => banners[int.parse(m[1]!)],
      )
      .trim();
}

/// Walks up from the working directory looking for the stylesheet.
///
/// `jaspr build` runs this from the project root, but resolving it by search
/// keeps the lookup working from a subdirectory too.
File? _locate() {
  for (var dir = Directory.current; ; dir = dir.parent) {
    final file = File('${dir.path}/$_stylesheet');
    if (file.existsSync()) return file;
    if (dir.path == dir.parent.path) return null;
  }
}
