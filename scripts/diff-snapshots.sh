#!/usr/bin/env bash
# Script Name: diff-snapshots.sh
# Purpose: Compare two snapshot directories created by snapshot-from-manifest.sh
# Usage: ./scripts/diff-snapshots.sh snapshots/<before> snapshots/<after>
# Author: Juan Vallejo
# Date: 2025-11-05
# Project: CSC305 GlobalFlavors D7 Retention Metrics
set -euo pipefail
trap 'echo "Error on line $LINENO" >&2' ERR

# Compare two snapshot directories created by snapshot-from-manifest.sh
# Usage: ./scripts/diff-snapshots.sh snapshots/20251105-120000 snapshots/20251105-121000

LEFT="${1:-}"
RIGHT="${2:-}"

if [[ -z "$LEFT" || -z "$RIGHT" ]]; then
  echo "Usage: $0 <left_snapshot_dir> <right_snapshot_dir>" >&2
  exit 2
fi

if [[ ! -d "$LEFT" || ! -d "$RIGHT" ]]; then
  echo "Both arguments must be directories" >&2
  exit 2
fi

echo "Comparing $LEFT <-> $RIGHT"

# Show file presence differences
echo "\n== File lists =="
comm -3 <(cd "$LEFT" && find . -type f | sort) <(cd "$RIGHT" && find . -type f | sort) || true

# For common files, show unified diffs where content differs
echo "\n== Diffs (unified) =="
common_files=$(comm -12 <(cd "$LEFT" && find . -type f | sort) <(cd "$RIGHT" && find . -type f | sort))
ret=0
while IFS= read -r f; do
  if ! diff -q "$LEFT/$f" "$RIGHT/$f" >/dev/null 2>&1; then
    echo "\n--- $f ---"
    diff -u "$LEFT/$f" "$RIGHT/$f" || ret=$?
  fi
done <<< "$common_files"

exit 0
