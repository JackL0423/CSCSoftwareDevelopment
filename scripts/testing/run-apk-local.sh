#!/usr/bin/env bash
set -euo pipefail

# Install and launch a debug APK on a connected device/emulator
# Usage: ./scripts/run-apk-local.sh <apk_path> [package]

APK="${1:-}"
PKG="${2:-com.mycompany.csc305capstone}"

if [[ -z "$APK" || ! -f "$APK" ]]; then
  echo "Usage: $0 <apk_path> [package]" >&2
  exit 2
fi

if ! command -v adb >/dev/null 2>&1; then
  echo "adb not found. Please install Android platform-tools and ensure adb is on PATH." >&2
  exit 2
fi

echo "Installing $APK ..." >&2
adb install -r "$APK"

echo "Launching $PKG ..." >&2
adb shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1 || true

echo "App launched." >&2
