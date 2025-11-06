#!/usr/bin/env bash
# Resilient uploader for FlutterFlow v2 API with JSON→ZIP fallback and retries
# Requires: jq, python3, zip, unzip, gcloud

set -euo pipefail

PROJECT_ID="c-s-c305-capstone-khj14l"
API_BASE="https://api.flutterflow.io/v2"
MAX_RETRIES=6
BASE_SLEEP=1.5

usage() {
  cat <<'USAGE'
Usage:
  update-yaml-v2.sh --file-key <key> --yaml <path> [--branch <name>] [--method auto|json|zip] [--no-validate]

Notes:
  - The file key MUST already exist (seeded in FlutterFlow UI).
  - method=auto: try JSON (fileKeyToContent) then ZIP (projectYamlBytes) on failure.

Example:
  ./scripts/update-yaml-v2.sh \
    --file-key "page/id-Scaffold_r33su4wm/page-widget-tree-outline/node/id-Scaffold_r33su4wm/trigger_actions/id-ON_INIT_STATE/action/id-2933j5kw" \
    --yaml trigger-templates/initializeUserSession_action.yaml \
    --branch "JUAN-adding metric" --method auto
USAGE
}

BRANCH=""
METHOD="auto"
DO_VALIDATE=1
FILE_KEY=""
YAML_PATH=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --file-key) FILE_KEY="$2"; shift 2;;
    --yaml) YAML_PATH="$2"; shift 2;;
    --branch) BRANCH="$2"; shift 2;;
    --method) METHOD="$2"; shift 2;;
    --no-validate) DO_VALIDATE=0; shift;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown arg: $1" >&2; usage; exit 2;;
  esac
done

[[ -z "$FILE_KEY" || -z "$YAML_PATH" ]] && { usage; exit 2; }
[[ -f "$YAML_PATH" ]] || { echo "YAML not found: $YAML_PATH" >&2; exit 2; }

echo "Retrieving API token..." >&2
LEAD_TOKEN=$(gcloud secrets versions access latest --secret="FLUTTERFLOW_LEAD_API_TOKEN" --project=csc305project-475802 2>/dev/null) || true
[[ -n "$LEAD_TOKEN" ]] || { echo "Error: missing FLUTTERFLOW_LEAD_API_TOKEN" >&2; exit 1; }

auth_hdr=(-H "Authorization: Bearer ${LEAD_TOKEN}" -H "Content-Type: application/json")

# Retry helper (POST)
retry_post() {
  local url="$1"; local payload="$2"; local attempt=0; local code; local body
  while :; do
    attempt=$((attempt+1))
    body=$(curl -sS -w "\n%{http_code}" -X POST "$url" "${auth_hdr[@]}" -d "$payload")
    code="${body##*$'\n'}"; body="${body%$'\n'*}"
    printf '%s\n' "$body"
    [[ "$code" == "200" ]] && return 0
    [[ $attempt -ge $MAX_RETRIES ]] && { echo "HTTP $code after $attempt attempts." >&2; return 1; }
    sleep_time=$(python3 - <<PY
import random
base=${BASE_SLEEP}; a=${attempt}
print(f"{base*2**(a-1)+random.random():.3f}")
PY
)
    echo "  HTTP $code. Retrying in ${sleep_time}s (attempt ${attempt}/${MAX_RETRIES})..." >&2
    sleep "$sleep_time"
  done
}

# Pre-check: ensure file key exists
echo "Checking file key existence..." >&2
LIST_URL="${API_BASE}/listPartitionedFileNames?projectId=${PROJECT_ID}"
if ! curl -sS -H "Authorization: Bearer ${LEAD_TOKEN}" "$LIST_URL" \
  | jq -e --arg k "$FILE_KEY" '.value.file_names[] | select(.==$k)' >/dev/null; then
  echo "Error: file key not found on server. Seed it in FlutterFlow UI first." >&2
  exit 3
fi

# Prepare YAML single-line (literal \n)
YAML_SINGLE_LINE=$(python3 - "$YAML_PATH" <<'PY'
import sys, pathlib
p=pathlib.Path(sys.argv[1])
txt=p.read_text()
print(txt.replace('\n','\\n'))
PY
)

# Optional validation (JSON only)
VALIDATION_FAILED=2
if [[ "$DO_VALIDATE" -eq 1 ]]; then
  echo "Validating (validateProjectYaml JSON mode)..." >&2
  VALIDATE_PAYLOAD=$(jq -n \
    --arg pid "$PROJECT_ID" \
    --arg key "$FILE_KEY" \
    --arg yaml "$YAML_SINGLE_LINE" \
    '{projectId:$pid, fileKey:$key, fileContent:$yaml}')
  vbody=$(retry_post "${API_BASE}/validateProjectYaml" "$VALIDATE_PAYLOAD") || true
  echo "$vbody" | jq '.' || true
  if echo "$vbody" | jq -e '.success==true' >/dev/null 2>&1; then
    VALIDATION_FAILED=0
  else
    VALIDATION_FAILED=1
  fi
else
  echo "Validation skipped per --no-validate" >&2
fi

# JSON update
update_json() {
  echo "Updating via JSON (fileKeyToContent)..." >&2
  if [[ -n "$BRANCH" ]]; then
    UPDATE_PAYLOAD=$(jq -n --arg pid "$PROJECT_ID" --arg key "$FILE_KEY" --arg yaml "$YAML_SINGLE_LINE" --arg br "$BRANCH" '{projectId:$pid, fileKeyToContent:{($key):$yaml}, branch:$br}')
  else
    UPDATE_PAYLOAD=$(jq -n --arg pid "$PROJECT_ID" --arg key "$FILE_KEY" --arg yaml "$YAML_SINGLE_LINE" '{projectId:$pid, fileKeyToContent:{($key):$yaml}}')
  fi
  ubody=$(retry_post "${API_BASE}/updateProjectByYaml" "$UPDATE_PAYLOAD") || return 1
  echo "$ubody" | jq '.' || true
  echo "$ubody" | jq -e '.success==true' >/dev/null 2>&1
}

# ZIP update
make_zip() {
  local out="$1"
  python3 - "$out" "$FILE_KEY" "$YAML_PATH" <<'PY'
import sys, zipfile, os, pathlib
out=sys.argv[1]; file_key=sys.argv[2]; yaml_path=pathlib.Path(sys.argv[3])
data=yaml_path.read_bytes()
entry=f"{file_key}.yaml"
os.makedirs(os.path.dirname(out), exist_ok=True)
with zipfile.ZipFile(out,'w',compression=zipfile.ZIP_DEFLATED) as z:
    z.writestr(entry, data)
PY
}

update_zip() {
  echo "Updating via ZIP (projectYamlBytes)..." >&2
  tmpzip="$(mktemp).zip"
  make_zip "$tmpzip"
  ZIP_B64=$(base64 -w0 "$tmpzip")
  rm -f "$tmpzip"
  if [[ -n "$BRANCH" ]]; then
    UPDATE_PAYLOAD=$(jq -n --arg pid "$PROJECT_ID" --arg fk "$FILE_KEY" --arg b64 "$ZIP_B64" --arg br "$BRANCH" '{projectId:$pid, fileKey:$fk, projectYamlBytes:$b64, branch:$br}')
  else
    UPDATE_PAYLOAD=$(jq -n --arg pid "$PROJECT_ID" --arg fk "$FILE_KEY" --arg b64 "$ZIP_B64" '{projectId:$pid, fileKey:$fk, projectYamlBytes:$b64}')
  fi
  ubody=$(retry_post "${API_BASE}/updateProjectByYaml" "$UPDATE_PAYLOAD") || return 1
  echo "$ubody" | jq '.' || true
  echo "$ubody" | jq -e '.success==true' >/dev/null 2>&1
}

rc=1
case "$METHOD" in
  json) if update_json; then rc=0; else rc=$?; fi ;;
  zip)  if update_zip;  then rc=0; else rc=$?; fi ;;
  auto)
    if [[ "$VALIDATION_FAILED" -eq 0 ]]; then
      if update_json; then rc=0; else rc=$?; fi
    else
      update_json || true
      if update_zip; then rc=0; else rc=$?; fi
    fi
    ;;
  *) echo "Unknown method: $METHOD" >&2; exit 2 ;;
esac

if [[ ${rc:-0} -ne 0 ]]; then
  echo "Update failed." >&2
  exit 4
fi

echo "Update succeeded."
