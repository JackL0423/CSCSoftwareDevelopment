#!/usr/bin/env bash
# Bulk download ALL YAML files from FlutterFlow project in a single API call
# Discovery: Omitting fileName parameter returns all files as one ZIP

set -e

# Default configuration
DEFAULT_PROJECT_ID="c-s-c305-capstone-khj14l"
DEFAULT_OUTPUT_DIR="flutterflow-yamls"
API_BASE="https://api.flutterflow.io/v2"
GCP_PROJECT="csc305project-475802"

# Parse arguments
PROJECT_ID="${PROJECT_ID:-$DEFAULT_PROJECT_ID}"
OUTPUT_DIR="$DEFAULT_OUTPUT_DIR"
FORCE=false

show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

Download all YAML files from FlutterFlow project in a single bulk API call.

Options:
    --output DIR    Output directory (default: flutterflow-yamls/)
    --force         Overwrite existing directory
    --project ID    FlutterFlow project ID (default: from env or $DEFAULT_PROJECT_ID)
    --help          Show this help

Environment Variables:
    PROJECT_ID      Override default project ID

Examples:
    # Download all files to default directory
    $0

    # Download to custom directory
    $0 --output my-yamls/

    # Use test project
    PROJECT_ID="project-test-n8qaal" $0

    # Force re-download
    $0 --force
EOF
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --output|--dest)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --project)
            PROJECT_ID="$2"
            shift 2
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Check if output directory exists
if [ -d "$OUTPUT_DIR" ] && [ "$FORCE" != "true" ]; then
    echo "Error: Output directory '$OUTPUT_DIR' already exists"
    echo "Use --force to overwrite or choose a different directory with --output"
    exit 1
fi

# Get API token from Secret Manager
echo "Retrieving API token from Secret Manager..."
LEAD_TOKEN=$(gcloud secrets versions access latest \
    --secret="FLUTTERFLOW_LEAD_API_TOKEN" \
    --project="$GCP_PROJECT" 2>/dev/null)

if [ -z "$LEAD_TOKEN" ]; then
    echo "Error: Failed to retrieve API token from Secret Manager"
    exit 1
fi

# Create temp directory
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

echo ""
echo "=== FlutterFlow Bulk Download ==="
echo "Project ID: $PROJECT_ID"
echo "Output: $OUTPUT_DIR"
echo ""

# Download all files (omit fileName parameter for bulk download)
echo "Downloading all project YAMLs..."
START_TIME=$(date +%s)

RESPONSE_FILE="$TEMP_DIR/response.json"
curl -sS \
    -H "Authorization: Bearer ${LEAD_TOKEN}" \
    -H "Content-Type: application/json" \
    "${API_BASE}/projectYamls?projectId=${PROJECT_ID}" \
    -o "$RESPONSE_FILE"

# Check for success
SUCCESS=$(jq -r '.success // false' "$RESPONSE_FILE")
if [ "$SUCCESS" != "true" ]; then
    echo "Error: API call failed"
    jq '.' "$RESPONSE_FILE"
    exit 1
fi

# Extract base64 content (try both field names)
BASE64_CONTENT=$(jq -r '.value.projectYamlBytes // .value.project_yaml_bytes // empty' "$RESPONSE_FILE")

if [ -z "$BASE64_CONTENT" ]; then
    echo "Error: Could not find base64 content in response"
    echo "Response keys:"
    jq 'keys' "$RESPONSE_FILE"
    exit 1
fi

# Decode and extract
echo "Decoding and extracting..."
ZIP_FILE="$TEMP_DIR/all-files.zip"
echo "$BASE64_CONTENT" | base64 -d > "$ZIP_FILE"

# Remove old directory if --force
if [ "$FORCE" = "true" ] && [ -d "$OUTPUT_DIR" ]; then
    echo "Removing existing directory: $OUTPUT_DIR"
    rm -rf "$OUTPUT_DIR"
fi

# Create output directory and extract
mkdir -p "$OUTPUT_DIR"
unzip -q "$ZIP_FILE" -d "$OUTPUT_DIR"

# Count files
FILE_COUNT=$(find "$OUTPUT_DIR" -name "*.yaml" -o -name "*.yml" | wc -l)
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo ""
echo "=== Download Complete ==="
echo "✓ Files downloaded: $FILE_COUNT YAML files"
echo "✓ Time taken: ${DURATION} seconds"
echo "✓ Location: $(pwd)/$OUTPUT_DIR"
echo ""
