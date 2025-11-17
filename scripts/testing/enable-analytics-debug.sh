#!/usr/bin/env bash
set -euo pipefail

# Enable Firebase Analytics debug logging on a connected device/emulator
# Usage: ./scripts/enable-analytics-debug.sh [package]

PKG="${1:-com.mycompany.csc305capstone}"

if ! command -v adb >/dev/null 2>&1; then
  echo "adb not found. Please install Android platform-tools and ensure adb is on PATH." >&2
  exit 2
fi

echo "Enabling Firebase Analytics debug for package: $PKG" >&2
adb shell setprop debug.firebase.analytics.app "$PKG" || true
adb shell setprop log.tag.FA VERBOSE || true
adb shell setprop log.tag.GoogleTagManager VERBOSE || true

echo "Done. Restart the app to begin seeing DebugView events." >&2
