#!/usr/bin/env bash
# Update a single FlutterFlow YAML file by providing raw YAML content using fileKeyToContent
set -euo pipefail

PROJECT_ID="c-s-c305-capstone-khj14l"
API_BASE="https://api.flutterflow.io/v2"
BRANCH="JUAN-adding metric"

usage() {
  echo "Usage: $0 [--main | --branch <name>] <file-key> <yaml-file>" >&2
  exit 2
}

USE_MAIN=false
if [[ $# -lt 2 ]]; then usage; fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --main) USE_MAIN=true; shift ;;
    --branch) BRANCH="$2"; shift 2 ;;
    *) break ;;
  esac
done

FILE_KEY="${1:-}"; YAML_FILE="${2:-}"
[[ -z "$FILE_KEY" || -z "$YAML_FILE" ]] && usage
[[ -f "$YAML_FILE" ]] || { echo "File not found: $YAML_FILE" >&2; exit 1; }

echo "Retrieving API token..." >&2
LEAD_TOKEN=$(gcloud secrets versions access latest --secret="FLUTTERFLOW_LEAD_API_TOKEN" --project=csc305project-475802)

# Convert YAML to a single-line string with literal \n characters
YAML_SINGLE_LINE=$(python3 - "$YAML_FILE" <<'PY'
import sys, pathlib
p = pathlib.Path(sys.argv[1])
txt = p.read_text()
# Ensure we normalize line endings and escape backslashes and quotes safely for JSON
txt = txt.replace('\r\n','\n').replace('\r','\n')
print(txt.replace('\\','\\\\').replace('"','\\"').replace('\n','\\n'))
PY
)

echo "Preparing payload using fileKeyToContent for $FILE_KEY" >&2

# Build payload; include branch unless --main
if $USE_MAIN; then
  PAYLOAD=$(jq -n --arg pid "$PROJECT_ID" --arg key "$FILE_KEY" --arg yaml "$YAML_SINGLE_LINE" '{projectId:$pid, fileKeyToContent: {($key): $yaml}}')
else
  PAYLOAD=$(jq -n --arg pid "$PROJECT_ID" --arg key "$FILE_KEY" --arg yaml "$YAML_SINGLE_LINE" --arg br "$BRANCH" '{projectId:$pid, fileKeyToContent: {($key): $yaml}, branch:$br}')
fi

echo "Calling updateProjectByYaml..." >&2
RESP=$(curl -sS -X POST "${API_BASE}/updateProjectByYaml" -H "Authorization: Bearer ${LEAD_TOKEN}" -H "Content-Type: application/json" -d "$PAYLOAD")
echo "$RESP" | jq '.' 2>/dev/null || echo "$RESP"
