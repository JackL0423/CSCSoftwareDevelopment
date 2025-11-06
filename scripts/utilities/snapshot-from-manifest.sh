#!/usr/bin/env bash
# Script Name: snapshot-from-manifest.sh
# Purpose: Download YAML for all file keys listed in a manifest to a timestamped snapshots/ directory
# Usage: ./scripts/snapshot-from-manifest.sh automation/wiring-manifest.json
# Author: Juan Vallejo
# Date: 2025-11-05
# Project: CSC305 GlobalFlavors D7 Retention Metrics
set -euo pipefail
trap 'echo "Error on line $LINENO" >&2' ERR

# Snapshot YAML bytes for all file keys in a manifest to local files under snapshots/.
# Usage: ./scripts/snapshot-from-manifest.sh automation/manifest/triggers.sample.json

MANIFEST="${1:-}"
OUT_DIR="snapshots/$(date +%Y%m%d-%H%M%S)"

if [[ -z "$MANIFEST" ]]; then
  echo "Usage: $0 <manifest.json>" >&2
  exit 2
fi

if ! command -v jq >/dev/null; then
  echo "jq is required" >&2
  exit 2
fi

mkdir -p "$OUT_DIR"

COUNT=$(jq 'length' "$MANIFEST")
echo "Snapshotting $COUNT file(s) to $OUT_DIR"

sanitize() {
  # Replace slashes and spaces for filesystem-safe names
  sed -e 's#[/ ]#_#g' -e 's#[^A-Za-z0-9_.-]#-#g'
}

for i in $(seq 0 $((COUNT-1))); do
  FILE_KEY=$(jq -r ".[$i].file_key // empty" "$MANIFEST")
  PAGE_NAME=$(jq -r ".[$i].page_name // ("entry_" + ($i|tostring))" "$MANIFEST")
  if [[ -z "$FILE_KEY" ]]; then
    echo "[$((i+1))/$COUNT] Skipping: missing file_key" >&2
    continue
  fi

  SAFE_NAME="${PAGE_NAME}_$(echo -n "$FILE_KEY" | sanitize).yaml"
  DEST="$OUT_DIR/$SAFE_NAME"
  echo "[$((i+1))/$COUNT] Downloading $FILE_KEY -> $DEST"
  ./scripts/download-yaml.sh "$FILE_KEY" > "$DEST" || {
    echo "  WARN: download returned non-zero for $FILE_KEY (API may return empty bytes)." >&2
  }
done

echo "Snapshot complete: $OUT_DIR"
