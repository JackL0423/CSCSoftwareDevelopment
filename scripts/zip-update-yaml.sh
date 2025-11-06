#!/usr/bin/env bash
# Package a YAML into a zip with the correct internal path (<file-key>.yaml) and update via projectYamlBytes
set -euo pipefail

PROJECT_ID="c-s-c305-capstone-khj14l"
API_BASE="https://api.flutterflow.io/v2"
BRANCH="JUAN-adding metric"

usage(){ echo "Usage: $0 [--main | --branch <name>] [--skip-validate] <file-key> <yaml-file>" >&2; exit 2; }
USE_MAIN=false
SKIP_VALIDATE=false
[[ $# -lt 2 ]] && usage

while [[ $# -gt 0 ]]; do
  case "$1" in
    --main) USE_MAIN=true; shift ;;
    --branch) BRANCH="$2"; shift 2 ;;
    --skip-validate) SKIP_VALIDATE=true; shift ;;
    *) break ;;
  esac
done

FILE_KEY="${1:-}"; YAML_FILE="${2:-}"
[[ -z "$FILE_KEY" || -z "$YAML_FILE" ]] && usage
[[ -f "$YAML_FILE" ]] || { echo "File not found: $YAML_FILE" >&2; exit 1; }

echo "Retrieving API token..." >&2
LEAD_TOKEN=$(gcloud secrets versions access latest --secret="FLUTTERFLOW_LEAD_API_TOKEN" --project=csc305project-475802)

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

# Create the exact internal path
INTERNAL_PATH="${FILE_KEY}.yaml"
mkdir -p "$TMPDIR/$(dirname "$INTERNAL_PATH")"
cp "$YAML_FILE" "$TMPDIR/$INTERNAL_PATH"

ZIP_PATH="$TMPDIR/payload.zip"
(cd "$TMPDIR" && zip -q -r "$ZIP_PATH" "$INTERNAL_PATH")

YAML_B64=$(base64 -w 0 "$ZIP_PATH")

if $USE_MAIN; then
  PAYLOAD=$(jq -n --arg pid "$PROJECT_ID" --arg fkey "$FILE_KEY" --arg bytes "$YAML_B64" '{projectId:$pid, fileKey:$fkey, projectYamlBytes:$bytes}')
else
  PAYLOAD=$(jq -n --arg pid "$PROJECT_ID" --arg fkey "$FILE_KEY" --arg bytes "$YAML_B64" --arg br "$BRANCH" '{projectId:$pid, fileKey:$fkey, projectYamlBytes:$bytes, branch:$br}')
fi

if ! $SKIP_VALIDATE; then
  echo "Validating..." >&2
  VAL=$(curl -sS -X POST "${API_BASE}/validateProjectYaml" -H "Authorization: Bearer ${LEAD_TOKEN}" -H "Content-Type: application/json" -d "$PAYLOAD")
  echo "$VAL" | jq '.' 2>/dev/null >/dev/null || { echo "$VAL"; exit 1; }
  if ! echo "$VAL" | grep -q '"success":true'; then
    echo "❌ Validation failed (continuing may still work; pass --skip-validate to suppress)." >&2
  else
    echo "✅ Validation passed" >&2
  fi
fi

echo "Updating..." >&2
UPD=$(curl -sS -X POST "${API_BASE}/updateProjectByYaml" -H "Authorization: Bearer ${LEAD_TOKEN}" -H "Content-Type: application/json" -d "$PAYLOAD")
echo "$UPD" | jq '.' 2>/dev/null || echo "$UPD"
