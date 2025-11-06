#!/bin/bash
# Download YAML files from FlutterFlow project

set -e

# Load project configuration
PROJECT_ID="c-s-c305-capstone-khj14l"
API_BASE="https://api.flutterflow.io/v2"
OUTPUT_DIR="flutterflow-yamls"

# Parse command line arguments
SPECIFIC_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --file)
            SPECIFIC_FILE="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

# Get LEAD API token from Secret Manager
echo "Retrieving API token from Secret Manager..."
LEAD_TOKEN=$(gcloud secrets versions access latest --secret="FLUTTERFLOW_LEAD_API_TOKEN" --project=csc305project-475802 2>/dev/null)

if [ -z "$LEAD_TOKEN" ]; then
    echo "Error: Failed to retrieve LEAD API token"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Respectful backoff timings
MAX_RETRIES=8
BASE_SLEEP=2

# Function: HTTP GET JSON with retry/backoff. Writes body to path given as $2 and echoes HTTP code.
http_get_json() {
    local url="$1"
    local out_path="$2"
    local attempt=0
    local code=0

    while true; do
        attempt=$((attempt+1))
        code=$(curl -sS -w "%{http_code}" -H "Authorization: Bearer ${LEAD_TOKEN}" -o "$out_path" "$url" || echo 000)

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
        echo "  HTTP $code. Retrying in ${sleep_time}s (attempt ${attempt}/${MAX_RETRIES})..."
        sleep "$sleep_time"
    done
}

# Function to download and decode a single YAML file
download_yaml() {
    local file_key="$1"
    local output_path="${OUTPUT_DIR}/${file_key}.yaml"
    local zip_path="${OUTPUT_DIR}/${file_key}.zip"
    local tmp_json="$(mktemp)"

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
        echo "  Error: Failed to download JSON for $file_key (HTTP $code)"
        rm -f "$tmp_json"
        return 1
    fi

    # Extract base64 zip bytes (support both fields)
    if ! jq -er '.value.projectYamlBytes // .value.project_yaml_bytes' "$tmp_json" \
        | tr -d '\n' \
        | base64 --decode > "$zip_path" 2>/dev/null; then
        echo "  Error: Response did not contain valid base64 zip bytes"
        head -c 120 "$tmp_json" 2>/dev/null | sed 's/.*/  >> &/'
        rm -f "$tmp_json"
        return 1
    fi
    rm -f "$tmp_json"

    # Check if we got a valid ZIP file
    if ! file -b --mime-type "$zip_path" | grep -q 'application/zip'; then
        echo "  Error: Downloaded file is not a valid ZIP (got $(file -b --mime-type "$zip_path"))"
        return 1
    fi

    # Extract YAML from ZIP
    if ! unzip -p "$zip_path" "${file_key}.yaml" > "$output_path" 2>/dev/null; then
        echo "  Error: Failed to extract YAML from ZIP"
        return 1
    fi

    # Clean up ZIP file
    rm -f "$zip_path"

    echo "  Saved to: $output_path ($(wc -l < "$output_path") lines)"
    # Gentle pacing to avoid rate limits
    sleep 0.2
}

# Download specific file or all files
if [ -n "$SPECIFIC_FILE" ]; then
    download_yaml "$SPECIFIC_FILE"
else
    echo "Fetching file list..."
    TMP_LIST_JSON="$(mktemp)"
    LIST_URL="${API_BASE}/listPartitionedFileNames?projectId=${PROJECT_ID}"
    code=$(http_get_json "$LIST_URL" "$TMP_LIST_JSON") || true

    if [ "$code" != "200" ]; then
        echo "Error: Failed to retrieve file list (HTTP $code)"
        rm -f "$TMP_LIST_JSON"
        exit 1
    fi

    FILE_LIST=$(jq -r '.value.file_names[]' "$TMP_LIST_JSON" 2>/dev/null || true)
    rm -f "$TMP_LIST_JSON"

    if [ -z "$FILE_LIST" ]; then
        echo "Error: Failed to retrieve file list"
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
echo "Download complete! Files saved to: $OUTPUT_DIR/"
