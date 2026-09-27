/// The tags a link preview reads.
///
/// Written as elements rather than through the document's meta map because
/// Open Graph is keyed on `property`, which the map cannot produce: it emits
/// `name`, and the parsers that matter look for the other one.
library;

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/site_data.dart';

/// What is true of every page: who the site belongs to and what a preview of
/// it looks like.
///
/// The title, the description and the address are not here. They belong to
/// whichever page is being shared, and a second copy of a tag is worse than
/// none — a scraper takes the first it meets, which would be the wrong one.
List<Component> get siteSocialTags => [
  _property('og:type', 'website'),
  _property('og:site_name', SiteMeta.author),
  _property('og:image', SiteMeta.shareImageUrl),
  // Stated so a preview can hold the right shape before the image lands.
  _property('og:image:width', '1200'),
  _property('og:image:height', '630'),
  _property('og:image:alt', SiteMeta.shareImageAlt),
  _property('og:locale', 'en_US'),
  // X takes the rest from the Open Graph tags; this is the one of its own it
  // needs, to show the wide card instead of a thumbnail.
  meta(name: 'twitter:card', content: 'summary_large_image'),
  meta(name: 'twitter:image:alt', content: SiteMeta.shareImageAlt),
];

/// What one page says about itself.
///
/// [path] is relative to the site root and is resolved against it, because a
/// scraper reads these without a page to resolve a relative address against.
/// A canonical pointing somewhere other than the page holding it tells a
/// search engine to index that other page instead, so every page states its
/// own rather than inheriting one.
List<Component> pageSocialTags({
  required String title,
  required String description,
  String path = '',
}) {
  final url = '${SiteMeta.canonicalUrl}$path';
  return [
    link(href: url, rel: 'canonical'),
    _property('og:title', title),
    _property('og:description', description),
    _property('og:url', url),
  ];
}

Component _property(String property, String content) =>
    meta(attributes: {'property': property, 'content': content});
