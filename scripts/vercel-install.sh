#!/usr/bin/env bash
# Installs the Dart SDK and the Jaspr CLI into the Vercel build container.
#
# Vercel's build image has no Dart toolchain, so it is downloaded here and
# cached under .vercel_dart for the build step to pick up.
set -euo pipefail

DART_CHANNEL="${DART_CHANNEL:-stable}"
DART_VERSION="${DART_VERSION:-latest}"
DART_ROOT="$PWD/.vercel_dart"

# The SDK ships as a .zip only, and the build image is not guaranteed to have
# `unzip`, so fall back to Python's zipfile module when it is missing.
extract() {
  local archive="$1" dest="$2"
  if command -v unzip >/dev/null 2>&1; then
    unzip -q "$archive" -d "$dest"
  elif command -v python3 >/dev/null 2>&1; then
    python3 -c 'import sys,zipfile; zipfile.ZipFile(sys.argv[1]).extractall(sys.argv[2])' "$archive" "$dest"
  else
    echo "Need either unzip or python3 to unpack the Dart SDK." >&2
    exit 1
  fi
  # Both paths drop the executable bit, so restore it on the SDK binaries.
  chmod +x "$dest"/dart-sdk/bin/dart "$dest"/dart-sdk/bin/dartaotruntime 2>/dev/null || true
}

if [ ! -x "$DART_ROOT/dart-sdk/bin/dart" ]; then
  echo "Downloading Dart SDK ($DART_CHANNEL/$DART_VERSION)..."
  mkdir -p "$DART_ROOT"
  curl -fsSL -o "$DART_ROOT/dartsdk.zip" \
    "https://storage.googleapis.com/dart-archive/channels/$DART_CHANNEL/release/$DART_VERSION/sdk/dartsdk-linux-x64-release.zip"
  extract "$DART_ROOT/dartsdk.zip" "$DART_ROOT"
  rm "$DART_ROOT/dartsdk.zip"
fi

export PATH="$DART_ROOT/dart-sdk/bin:$PWD/.pub-cache/bin:$PATH"
export PUB_CACHE="$PWD/.pub-cache"

dart --version
dart pub global activate jaspr_cli
dart pub get
