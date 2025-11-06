#!/usr/bin/env bash
# Script Name: apply-all-triggers.sh
# Purpose: Apply multiple trigger wiring updates from a manifest via FlutterFlow Project YAML API
# Usage: ./scripts/apply-all-triggers.sh automation/wiring-manifest.json
# Author: Juan Vallejo
# Date: 2025-11-05
# Project: CSC305 GlobalFlavors D7 Retention Metrics
set -euo pipefail
trap 'echo "Error on line $LINENO" >&2' ERR

# Apply all triggers from a manifest JSON.
# Each entry must include at least:
#   {
#     "page_name": "GoldenPath",
#     "file_key": "page/id-Scaffold_cc3wywo1/.../action/id-mbq0kcgb",
#     "template": "automation/templates/on_page_load_template.yaml",
#     "action_name": "initializeUserSession",
#     "action_key": "vpyil",
#     "params": {}
#   }

MANIFEST="${1:-}"
if [[ -z "$MANIFEST" ]]; then
  echo "Usage: $0 <manifest.json>" >&2
  exit 2
fi

if ! command -v jq >/dev/null; then
  echo "jq is required" >&2
  exit 2
fi

COUNT=$(jq 'length' "$MANIFEST")
echo "Applying $COUNT trigger(s) from $MANIFEST"

for i in $(seq 0 $((COUNT-1))); do
  ENTRY=$(jq -r ".[$i]" "$MANIFEST")
  FILE_KEY=$(jq -r '.file_key // empty' <<<"$ENTRY")
  TEMPLATE=$(jq -r '.template // empty' <<<"$ENTRY")
  ACTION_NAME=$(jq -r '.action_name // "initializeUserSession"' <<<"$ENTRY")
  ACTION_KEY=$(jq -r '.action_key // "vpyil"' <<<"$ENTRY")
  NON_BLOCKING=$(jq -r '.non_blocking // false' <<<"$ENTRY")
  PARAMS=$(jq -c '.params // {}' <<<"$ENTRY")

  if [[ -z "$FILE_KEY" || -z "$TEMPLATE" ]]; then
    echo "[$((i+1))/$COUNT] Skipping: missing file_key or template" >&2
    continue
  fi

  echo "[$((i+1))/$COUNT] Applying to $FILE_KEY using $TEMPLATE (action=$ACTION_NAME)"
  ./scripts/apply-trigger-via-api.sh \
    --file-key "$FILE_KEY" \
    --template "$TEMPLATE" \
    --action-name "$ACTION_NAME" \
    --action-key "$ACTION_KEY" \
    --params "$PARAMS"
done

echo "All manifest entries processed."
