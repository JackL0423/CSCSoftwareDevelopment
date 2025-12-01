#!/usr/bin/env bash
# download-yaml.sh - Download YAML files from FlutterFlow project
#
# Usage: ./download-yaml.sh --file <file-key>
# Example: ./download-yaml.sh --file app-state
#
# NOTE: FlutterFlow API does NOT support branch selection.
#       All operations target the main/default branch only.
#       See docs/guides/FLUTTERFLOW_API_GUIDE.md for details.

set -euo pipefail

# Configuration - use environment variables with fallbacks
PROJECT_ID="${FLUTTERFLOW_PROJECT_ID:-c-s-c305-capstone-khj14l}"
API_BASE="https://api.flutterflow.io/v2"
OUTPUT_DIR="flutterflow-yamls"
GCP_SECRETS_PROJECT="csc305project-475802"

# Retry settings
MAX_RETRIES=8
BASE_SLEEP=2

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Parse command line arguments
SPECIFIC_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --file)
            SPECIFIC_FILE="$2"
            shift 2
            ;;
        --output-dir)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 --file <file-key> [--output-dir <dir>]"
            echo ""
            echo "Download YAML files from FlutterFlow project."
            echo ""
            echo "Options:"
            echo "  --file <key>       Specific file to download (e.g., app-state)"
            echo "  --output-dir <dir> Output directory (default: flutterflow-yamls)"
            echo "  --help, -h         Show this help message"
            echo ""
            echo "Environment variables:"
            echo "  FLUTTERFLOW_PROJECT_ID   Project ID (default: c-s-c305-capstone-khj14l)"
            echo "  FLUTTERFLOW_API_TOKEN    API token (or loaded from GCP Secrets)"
            echo ""
            echo "Examples:"
            echo "  $0 --file app-state"
            echo "  $0 --file api-endpoint/id-5esga"
            echo "  $0  # Download all files"
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done

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

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Function: HTTP GET JSON with retry/backoff
http_get_json() {
    local url="$1"
    local out_path="$2"
    local attempt=0
    local code=0

    while true; do
        attempt=$((attempt+1))
        code=$(curl -sS -w "%{http_code}" \
            -H "Authorization: Bearer ${TOKEN}" \
            -o "$out_path" "$url" || echo 000)

        if [ "$code" = "200" ]; then
            echo "$code"
            return 0
        fi

        if [ $attempt -ge $MAX_RETRIES ]; then
            echo "$code"
            return 1
        fi

        # Exponential backoff with jitter
        sleep_sec=$(( BASE_SLEEP * (2 ** (attempt-1)) ))
        jitter=$(( RANDOM % 1000 ))
        sleep_time=$(awk -v s="$sleep_sec" -v j="$jitter" 'BEGIN { printf "%.3f", s + (j/1000.0) }')
        echo "  HTTP $code. Retrying in ${sleep_time}s (attempt ${attempt}/${MAX_RETRIES})..." >&2
        sleep "$sleep_time"
    done
}

# Function to download and decode a single YAML file
download_yaml() {
    local file_key="$1"
    local output_path="${OUTPUT_DIR}/${file_key}.yaml"
    local zip_path="${OUTPUT_DIR}/${file_key}.zip"
    local tmp_json
    tmp_json="$(mktemp)"

    # Create subdirectories if needed
    mkdir -p "$(dirname "$output_path")"

    echo "Downloading: $file_key..."

    # URL-encode file key to be safe in query param
    local encoded_key
    encoded_key=$(printf '%s' "$file_key" | jq -sRr @uri)

    # Download JSON with retry/backoff
    local url="${API_BASE}/projectYamls?projectId=${PROJECT_ID}&fileName=${encoded_key}"
    local code
    code=$(http_get_json "$url" "$tmp_json") || true

    if [ "$code" != "200" ]; then
        echo -e "  ${RED}Error: Failed to download JSON for $file_key (HTTP $code)${NC}"
        rm -f "$tmp_json"
        return 1
    fi

    # Extract base64 zip bytes (support both fields)
    if ! jq -er '.value.projectYamlBytes // .value.project_yaml_bytes' "$tmp_json" \
        | tr -d '\n' \
        | base64 --decode > "$zip_path" 2>/dev/null; then
        echo -e "  ${RED}Error: Response did not contain valid base64 zip bytes${NC}"
        head -c 120 "$tmp_json" 2>/dev/null | sed 's/.*/  >> &/'
        rm -f "$tmp_json"
        return 1
    fi
    rm -f "$tmp_json"

    # Check if we got a valid ZIP file
    if ! file -b --mime-type "$zip_path" | grep -q 'application/zip'; then
        echo -e "  ${RED}Error: Downloaded file is not a valid ZIP (got $(file -b --mime-type "$zip_path"))${NC}"
        return 1
    fi

    # Extract YAML from ZIP
    if ! unzip -p "$zip_path" "${file_key}.yaml" > "$output_path" 2>/dev/null; then
        echo -e "  ${RED}Error: Failed to extract YAML from ZIP${NC}"
        return 1
    fi

    # Clean up ZIP file
    rm -f "$zip_path"

    echo -e "  ${GREEN}Saved to: $output_path ($(wc -l < "$output_path") lines)${NC}"
    # Gentle pacing to avoid rate limits
    sleep 0.2
}

# Main execution
echo ""
echo -e "${YELLOW}FlutterFlow YAML Download${NC}"
echo "  Project ID: $PROJECT_ID"
echo "  Output Dir: $OUTPUT_DIR"
echo ""

# Download specific file or all files
if [ -n "$SPECIFIC_FILE" ]; then
    download_yaml "$SPECIFIC_FILE"
else
    echo "Fetching file list..."
    TMP_LIST_JSON="$(mktemp)"
    LIST_URL="${API_BASE}/listPartitionedFileNames?projectId=${PROJECT_ID}"
    code=$(http_get_json "$LIST_URL" "$TMP_LIST_JSON") || true

    if [ "$code" != "200" ]; then
        echo -e "${RED}Error: Failed to retrieve file list (HTTP $code)${NC}"
        rm -f "$TMP_LIST_JSON"
        exit 1
    fi

    FILE_LIST=$(jq -r '.value.file_names[]' "$TMP_LIST_JSON" 2>/dev/null || true)
    rm -f "$TMP_LIST_JSON"

    if [ -z "$FILE_LIST" ]; then
        echo -e "${RED}Error: Failed to retrieve file list${NC}"
        exit 1
    fi

    FILE_COUNT=$(echo "$FILE_LIST" | wc -l)
    echo "Downloading $FILE_COUNT files..."
    echo ""

    CURRENT=0
    while IFS= read -r file_key; do
        CURRENT=$((CURRENT + 1))
        echo "[$CURRENT/$FILE_COUNT] $file_key"
        download_yaml "$file_key" || true
    done <<< "$FILE_LIST"
fi

echo ""
echo -e "${GREEN}Download complete!${NC} Files saved to: $OUTPUT_DIR/"
