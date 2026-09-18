#!/usr/bin/env bash
# Builds the static site into build/jaspr.
#
# The EmailJS identifiers come from the Vercel project's environment variables.
# They are public EmailJS keys and are compiled into the client bundle, exactly
# as the GATSBY_* variables were before. When they are unset the contact form
# still renders but reports that sending failed.
set -euo pipefail

DART_ROOT="$PWD/.vercel_dart"
export PATH="$DART_ROOT/dart-sdk/bin:$PWD/.pub-cache/bin:$PATH"
export PUB_CACHE="$PWD/.pub-cache"

SITE_DOMAIN="${SITE_DOMAIN:-https://lucas-goldner.com}"

jaspr build \
  --verbose \
  --sitemap-domain "$SITE_DOMAIN" \
  --sitemap-exclude "^/404$" \
  --dart-define=EMAILJS_SERVICE_ID="${EMAILJS_SERVICE_ID:-}" \
  --dart-define=EMAILJS_TEMPLATE_ID="${EMAILJS_TEMPLATE_ID:-}" \
  --dart-define=EMAILJS_USER_ID="${EMAILJS_USER_ID:-}"
