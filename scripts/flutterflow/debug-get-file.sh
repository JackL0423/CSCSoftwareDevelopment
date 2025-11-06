#!/usr/bin/env bash
set -euo pipefail
PROJECT_ID="c-s-c305-capstone-khj14l"
API_BASE="https://api.flutterflow.io/v2"
FILE_KEY="${1:-}"
if [[ -z "$FILE_KEY" ]]; then
  echo "Usage: $0 <file_key>" >&2
  exit 2
fi
LEAD_TOKEN=$(gcloud secrets versions access latest --secret="FLUTTERFLOW_LEAD_API_TOKEN" --project=csc305project-475802)
ENC_KEY=$(printf '%s' "$FILE_KEY" | jq -sRr @uri)
URL="${API_BASE}/projectYamls?projectId=${PROJECT_ID}&fileName=${ENC_KEY}"
echo "URL: $URL" >&2
OUT=$(mktemp)
curl -sS -H "Authorization: Bearer ${LEAD_TOKEN}" "$URL" -o "$OUT"
echo "HEAD:" >&2
sed -n '1,80p' "$OUT" >&2
echo "Keys:" >&2
jq -r 'keys, (.value|type?), (.value|keys?)' "$OUT" 2>/dev/null >&2 || true
echo "BYTES_FIELD=projectYamlBytes length:" >&2
jq -r '.value.projectYamlBytes | length' "$OUT" 2>/dev/null >&2 || true
echo "BYTES_FIELD=project_yaml_bytes length:" >&2
jq -r '.value.project_yaml_bytes | length' "$OUT" 2>/dev/null >&2 || true
cat "$OUT"
