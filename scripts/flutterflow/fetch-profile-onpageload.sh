#!/usr/bin/env bash
set -euo pipefail

#!/usr/bin/env bash
set -euo pipefail

# Focused fetch for a page scaffold + trigger type (defaults to Profile + ON_PAGE_LOAD)
PROJECT_ID="c-s-c305-capstone-khj14l"
API_BASE="https://api.flutterflow.io/v2"

SCAFFOLD_ID="Scaffold_u4i23nvd"
TRIGGER_ID="ON_PAGE_LOAD"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --scaffold)
      SCAFFOLD_ID="$2"; shift 2 ;;
    --trigger)
      TRIGGER_ID="$2"; shift 2 ;;
    *) shift ;;
  esac
done

PREFIX="page/id-${SCAFFOLD_ID}/page-widget-tree-outline/node/id-${SCAFFOLD_ID}/trigger_actions/id-${TRIGGER_ID}"

echo "Retrieving API token..." >&2
LEAD_TOKEN=$(gcloud secrets versions access latest --secret="FLUTTERFLOW_LEAD_API_TOKEN" --project=csc305project-475802)

TMP_LIST=$(mktemp)
curl -sS -H "Authorization: Bearer ${LEAD_TOKEN}" "${API_BASE}/listPartitionedFileNames?projectId=${PROJECT_ID}" -o "$TMP_LIST"

echo "Filtered keys:" >&2
jq -r --arg p "$PREFIX" '.value.file_names[] | select(startswith($p))' "$TMP_LIST" | tee /tmp/profile_on_page_load_keys.txt

COUNT=$(wc -l < /tmp/profile_on_page_load_keys.txt || echo 0)
echo "Count: $COUNT" >&2

if [[ "$COUNT" -eq 0 ]]; then
  echo "No ON_PAGE_LOAD files found for Profile (Scaffold_u4i23nvd)." >&2
  exit 0
fi

while IFS= read -r key; do
  [[ -n "$key" ]] || continue
  ./scripts/download-yaml.sh --file "$key" || true
done < /tmp/profile_on_page_load_keys.txt

INDEX_PATH="flutterflow-yamls/${PREFIX}.yaml"
echo "--- Dump index YAML (if present) ---" >&2
if [[ -f "$INDEX_PATH" ]]; then
  echo "# $INDEX_PATH"
  sed -n '1,300p' "$INDEX_PATH"
else
  echo "Index YAML not found: $INDEX_PATH" >&2
fi

echo "--- Dump action YAMLs (if any) ---" >&2
while IFS= read -r key; do
  [[ -n "$key" ]] || continue
  if [[ "$key" == */action/* ]]; then
    path="flutterflow-yamls/${key}.yaml"
    if [[ -f "$path" ]]; then
      echo "# $path"
      sed -n '1,300p' "$path"
    fi
  fi
done < /tmp/profile_on_page_load_keys.txt
