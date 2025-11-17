#!/usr/bin/env bash
set -euo pipefail

# Tail adb logcat filtered for Firebase Analytics messages
# Usage: ./scripts/tail-analytics.sh

if ! command -v adb >/dev/null 2>&1; then
  echo "adb not found. Please install Android platform-tools and ensure adb is on PATH." >&2
  exit 2
fi

echo "Tailing Firebase Analytics logs (press Ctrl+C to stop)..." >&2
adb logcat | grep -E "(^|\s)FA\s|FirebaseAnalytics|recipe_complete|session_start|user_session|initializeUserSession"
