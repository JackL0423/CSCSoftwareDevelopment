#!/usr/bin/env bash
# validate-yaml.sh - Validate YAML changes before applying to FlutterFlow project
#
# Usage: ./validate-yaml.sh <file-key> <yaml-file-path>
# Example: ./validate-yaml.sh app-state ./flutterflow-yamls/app-state.yaml
#
# NOTE: FlutterFlow API does NOT support branch selection.
#       All operations target the main/default branch only.
#       See docs/guides/FLUTTERFLOW_API_GUIDE.md for details.

set -euo pipefail

# Configuration - use environment variables with fallbacks
PROJECT_ID="${FLUTTERFLOW_PROJECT_ID:-c-s-c305-capstone-khj14l}"
API_BASE="https://api.flutterflow.io/v2"
GCP_SECRETS_PROJECT="csc305project-475802"

# Retry settings
MAX_RETRIES=8
BASE_SLEEP=2

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# HTTP POST with retry and exponential backoff
http_post_json() {
    local url="$1"
    local payload="$2"
    local out_path="$3"
    local attempt=0
    local code=0

    while true; do
        attempt=$((attempt+1))
        code=$(curl -sS -w "%{http_code}" \
            -H "Authorization: Bearer ${TOKEN}" \
            -H "Content-Type: application/json" \
            -o "$out_path" \
            -X POST "$url" \
            -d "$payload" || echo 000)

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
        echo "  HTTP $code from $url. Retrying in ${sleep_time}s (attempt ${attempt}/${MAX_RETRIES})..." >&2
        sleep "$sleep_time"
    done
}

# Parse command line arguments
FILE_KEY=""
YAML_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --help|-h)
            echo "Usage: $0 <file-key> <yaml-file-path>"
            echo ""
            echo "Validate YAML changes with FlutterFlow API before uploading."
            echo ""
            echo "Arguments:"
            echo "  file-key        FlutterFlow file identifier (e.g., app-state)"
            echo "  yaml-file-path  Path to the YAML file to validate"
            echo ""
            echo "Environment variables:"
            echo "  FLUTTERFLOW_PROJECT_ID   Project ID (default: c-s-c305-capstone-khj14l)"
            echo "  FLUTTERFLOW_API_TOKEN    API token (or loaded from GCP Secrets)"
            echo ""
            echo "Example:"
            echo "  $0 app-state ./flutterflow-yamls/app-state.yaml"
            exit 0
            ;;
        --main)
            # Deprecated flag - API doesn't support branches
            echo -e "${YELLOW}Warning: --main flag is deprecated. FlutterFlow API always targets main branch.${NC}"
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

# Validate arguments
if [ -z "$FILE_KEY" ] || [ -z "$YAML_FILE" ]; then
    echo -e "${RED}Error: Missing required arguments${NC}"
    echo ""
    echo "Usage: $0 <file-key> <yaml-file-path>"
    echo "Run '$0 --help' for more information."
    exit 1
fi

# Check file exists
if [ ! -f "$YAML_FILE" ]; then
    echo -e "${RED}Error: File not found: $YAML_FILE${NC}"
    exit 1
fi

# Get API token - try environment variable first, then GCP Secret Manager
if [ -n "${FLUTTERFLOW_API_TOKEN:-}" ]; then
    TOKEN="$FLUTTERFLOW_API_TOKEN"
    echo -e "${GREEN}Using FLUTTERFLOW_API_TOKEN from environment${NC}"
elif [ -n "${LEAD_TOKEN:-}" ]; then
    TOKEN="$LEAD_TOKEN"
    echo -e "${GREEN}Using LEAD_TOKEN from environment${NC}"
else
    echo "Retrieving API token from GCP Secret Manager..."
    TOKEN=$(gcloud secrets versions access latest \
        --secret="FLUTTERFLOW_LEAD_API_TOKEN" \
        --project="$GCP_SECRETS_PROJECT" 2>/dev/null) || {
        echo -e "${RED}Error: Failed to retrieve API token${NC}"
        echo "Make sure you're authenticated: gcloud auth login"
        exit 1
    }
fi

echo ""
echo -e "${YELLOW}FlutterFlow YAML Validation${NC}"
echo "  Project ID: $PROJECT_ID"
echo "  File Key:   $FILE_KEY"
echo "  YAML File:  $YAML_FILE"
echo ""

# Convert YAML to JSON-escaped string (NOT base64!)
# Per docs/guides/FLUTTERFLOW_API_GUIDE.md: validation uses fileContent with plain YAML
YAML_STRING=$(jq -Rs . "$YAML_FILE")

# Create payload - use fileContent (not projectYamlBytes!)
PAYLOAD=$(jq -n \
    --arg pid "$PROJECT_ID" \
    --arg fkey "$FILE_KEY" \
    --argjson yaml "$YAML_STRING" \
    '{
        projectId: $pid,
        fileKey: $fkey,
        fileContent: $yaml
    }')

# Validate YAML
echo "Calling validation API..."
TMP_RESP="$(mktemp)"
code=$(http_post_json "${API_BASE}/validateProjectYaml" "$PAYLOAD" "$TMP_RESP") || true

if [ "$code" != "200" ]; then
    echo -e "${RED}Validation failed (HTTP $code)${NC}"
    head -c 500 "$TMP_RESP" 2>/dev/null | sed 's/.*/  >> &/'
    rm -f "$TMP_RESP"
    exit 1
fi

if jq -e '.success == true' "$TMP_RESP" >/dev/null 2>&1; then
    echo -e "${GREEN}Validation successful!${NC}"
    echo ""
    echo "Response:"
    jq '.' "$TMP_RESP"
    rm -f "$TMP_RESP"
    exit 0
else
    echo -e "${RED}Validation failed!${NC}"
    echo ""
    echo "Error details:"
    jq '.' "$TMP_RESP" 2>/dev/null || head -c 500 "$TMP_RESP"
    rm -f "$TMP_RESP"
    exit 1
fi
