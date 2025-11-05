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
LEAD_TOKEN=$(gcloud secrets versions access latest --secret="FLUTTERFLOW_LEAD_API_TOKEN" 2>/dev/null)

if [ -z "$LEAD_TOKEN" ]; then
    echo "Error: Failed to retrieve LEAD API token"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Function to download and decode a single YAML file
download_yaml() {
    local file_key="$1"
    local output_path="${OUTPUT_DIR}/${file_key}.yaml"
    local zip_path="${OUTPUT_DIR}/${file_key}.zip"

    # Create subdirectories if needed
    mkdir -p "$(dirname "$output_path")"

    echo "Downloading: $file_key..."

    # Download and decode directly (no command substitution)
    # Defensive: support both projectYamlBytes (docs) and project_yaml_bytes (actual)
    curl -sS -X GET "${API_BASE}/projectYamls?projectId=${PROJECT_ID}&fileName=${file_key}" \
        -H "Authorization: Bearer ${LEAD_TOKEN}" \
    | jq -r '.value.projectYamlBytes // .value.project_yaml_bytes' \
    | tr -d '\n' \
    | base64 --decode > "$zip_path"

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
}

# Download specific file or all files
if [ -n "$SPECIFIC_FILE" ]; then
    download_yaml "$SPECIFIC_FILE"
else
    echo "Fetching file list..."
    FILE_LIST=$(curl -s -X GET "${API_BASE}/listPartitionedFileNames?projectId=${PROJECT_ID}" \
        -H "Authorization: Bearer ${LEAD_TOKEN}" | jq -r '.value.fileNames[]')

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
