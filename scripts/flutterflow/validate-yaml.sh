#!/usr/bin/env bash
# Validate YAML changes before applying to FlutterFlow project

set -e
# Respectful backoff timings
MAX_RETRIES=8
BASE_SLEEP=2

http_post_json() {
    local url="$1"
    local payload="$2"
    local out_path="$3"
    local attempt=0
    local code=0

    while true; do
        attempt=$((attempt+1))
        code=$(curl -sS -w "%{http_code}" -H "Authorization: Bearer ${LEAD_TOKEN}" -H "Content-Type: application/json" -o "$out_path" -X POST "$url" -d "$payload" || echo 000)
        if [ "$code" = "200" ]; then
            echo "$code"
            return 0
        fi
        if [ $attempt -ge $MAX_RETRIES ]; then
            echo "$code"
            return 1
        fi
        sleep_sec=$(( BASE_SLEEP * (2 ** (attempt-1)) ))
        jitter=$(( RANDOM % 1000 ))
        sleep_time=$(awk -v s="$sleep_sec" -v j="$jitter" 'BEGIN { printf "%.3f", s + (j/1000.0) }')
        echo "  HTTP $code from $url. Retrying in ${sleep_time}s (attempt ${attempt}/${MAX_RETRIES})..."
        sleep "$sleep_time"
    done
}

# Load project configuration
PROJECT_ID="c-s-c305-capstone-khj14l"
API_BASE="https://api.flutterflow.io/v2"
BRANCH="JUAN-adding metric"  # Branch name (not URL-encoded for payload)

# Parse command line arguments
USE_MAIN=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --main)
            USE_MAIN=true
            shift
            ;;
        *)
            if [ -z "$FILE_KEY" ]; then
                FILE_KEY="$1"
            elif [ -z "$YAML_FILE" ]; then
                YAML_FILE="$1"
            fi
            shift
            ;;
    esac
done

if [ -z "$FILE_KEY" ] || [ -z "$YAML_FILE" ]; then
    echo "Usage: $0 [--main] <file-key> <yaml-file-path>"
    echo ""
    echo "Example: $0 app-details ./flutterflow-yamls/app-details.yaml"
    echo "Options:"
    echo "  --main    Validate against main branch instead of JUAN-adding metric"
    exit 1
fi

# Set branch
if [ "$USE_MAIN" = true ]; then
    echo "Using main branch"
else
    echo "Using JUAN-adding metric branch"
fi

# Check if file exists
if [ ! -f "$YAML_FILE" ]; then
    echo "Error: File not found: $YAML_FILE"
    exit 1
fi

# Get LEAD API token from Secret Manager
echo "Retrieving API token from Secret Manager..."
LEAD_TOKEN=$(gcloud secrets versions access latest --secret="FLUTTERFLOW_LEAD_API_TOKEN" --project=csc305project-475802 2>/dev/null)

if [ -z "$LEAD_TOKEN" ]; then
    echo "Error: Failed to retrieve LEAD API token"
    exit 1
fi

echo "Validating YAML file: $YAML_FILE"
echo "File key: $FILE_KEY"
echo ""

# Encode YAML file to base64
YAML_BASE64=$(base64 -w 0 "$YAML_FILE")

# Create JSON payload
if [ "$USE_MAIN" = true ]; then
    PAYLOAD=$(jq -n \
        --arg pid "$PROJECT_ID" \
        --arg fkey "$FILE_KEY" \
        --arg yaml "$YAML_BASE64" \
        '{
            projectId: $pid,
            fileKey: $fkey,
            projectYamlBytes: $yaml
        }')
else
    PAYLOAD=$(jq -n \
        --arg pid "$PROJECT_ID" \
        --arg fkey "$FILE_KEY" \
        --arg yaml "$YAML_BASE64" \
        --arg branch "$BRANCH" \
        '{
            projectId: $pid,
            fileKey: $fkey,
            projectYamlBytes: $yaml,
            branch: $branch
        }')
fi

# Validate YAML
echo "Calling validation API..."
TMP_RESP="$(mktemp)"
code=$(http_post_json "${API_BASE}/validateProjectYaml" "$PAYLOAD" "$TMP_RESP") || true

if [ "$code" != "200" ]; then
    echo "❌ Validation failed (HTTP $code)"
    head -c 160 "$TMP_RESP" 2>/dev/null | sed 's/.*/  >> &/'
    rm -f "$TMP_RESP"
    exit 1
fi

if jq -e '.success == true' "$TMP_RESP" >/dev/null 2>&1; then
    echo "✅ Validation successful!"
    echo ""
    echo "Response:"
    jq '.' "$TMP_RESP"
    rm -f "$TMP_RESP"
    exit 0
else
    echo "❌ Validation failed!"
    echo ""
    echo "Error details:"
    jq '.' "$TMP_RESP" 2>/dev/null || head -c 160 "$TMP_RESP"
    rm -f "$TMP_RESP"
    exit 1
fi
