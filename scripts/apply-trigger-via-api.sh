#!/usr/bin/env bash
set -euo pipefail

# Render a template and push it to FlutterFlow via the v2 YAML API (ZIP path).

usage() {
  cat <<EOF
Usage: $0 --file-key <key> --template <path> [--branch <name>] [--non-blocking] [--action-name <name>] [--action-key <key>] [--params <json>]

Examples:
  $0 \
    --file-key 'page/id-Scaffold_cc3wywo1/page-widget-tree-outline/node/id-Scaffold_cc3wywo1/trigger_actions/id-ON_INIT_STATE/action/id-mbq0kcgb' \
    --template automation/templates/on_page_load_template.yaml \
    --action-name initializeUserSession \
    --action-key vpyil
EOF
}

FILE_KEY=""
TEMPLATE=""
BRANCH=""
NON_BLOCKING="false"
ACTION_NAME=""
ACTION_KEY=""
PARAMS_JSON=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --file-key) FILE_KEY="$2"; shift 2;;
    --template) TEMPLATE="$2"; shift 2;;
    --branch) BRANCH="$2"; shift 2;;
    --non-blocking) NON_BLOCKING="true"; shift;;
    --action-name) ACTION_NAME="$2"; shift 2;;
    --action-key) ACTION_KEY="$2"; shift 2;;
    --params) PARAMS_JSON="$2"; shift 2;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown arg: $1"; usage; exit 2;;
  esac
done

if [[ -z "$FILE_KEY" || -z "$TEMPLATE" ]]; then
  usage; exit 2
fi

OUT_YAML="/tmp/rendered_action.yaml"

VARS=(
  "ACTION_NAME=${ACTION_NAME:-initializeUserSession}"
  "CUSTOM_ACTION_KEY=${ACTION_KEY:-vpyil}"
  "NON_BLOCKING=${NON_BLOCKING}"
)

if [[ -n "$PARAMS_JSON" ]]; then
  PARAMS_FLAG=(--params "$PARAMS_JSON")
else
  PARAMS_FLAG=()
fi

python3 automation/wire_trigger.py \
  --template "$TEMPLATE" \
  --out "$OUT_YAML" \
  $(for v in "${VARS[@]}"; do printf -- "--var %q " "$v"; done) \
  ${PARAMS_FLAG[@]:-}

# Push via resilient uploader (zip path)
ARGS=(--file-key "$FILE_KEY" --yaml "$OUT_YAML" --method zip --no-validate)
if [[ -n "$BRANCH" ]]; then
  ARGS+=(--branch "$BRANCH")
fi

./scripts/update-yaml-v2.sh "${ARGS[@]}"

