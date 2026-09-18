#!/usr/bin/env bash
# Installs the Dart SDK and the Jaspr CLI into the Vercel build container.
#
# Vercel's build image has no Dart toolchain, so it is downloaded here and
# cached under .vercel_dart for the build step to pick up.
set -euo pipefail

DART_CHANNEL="${DART_CHANNEL:-stable}"
DART_VERSION="${DART_VERSION:-latest}"
DART_ROOT="$PWD/.vercel_dart"

if [ ! -x "$DART_ROOT/dart-sdk/bin/dart" ]; then
  echo "Downloading Dart SDK ($DART_CHANNEL/$DART_VERSION)..."
  mkdir -p "$DART_ROOT"
  curl -fsSL -o "$DART_ROOT/dartsdk.zip" \
    "https://storage.googleapis.com/dart-archive/channels/$DART_CHANNEL/release/$DART_VERSION/sdk/dartsdk-linux-x64-release.zip"
  unzip -q "$DART_ROOT/dartsdk.zip" -d "$DART_ROOT"
  rm "$DART_ROOT/dartsdk.zip"
fi

export PATH="$DART_ROOT/dart-sdk/bin:$PWD/.pub-cache/bin:$PATH"
export PUB_CACHE="$PWD/.pub-cache"

dart --version
dart pub global activate jaspr_cli
dart pub get
