#!/bin/bash
# Validate YAML changes before applying to FlutterFlow project

set -e

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
LEAD_TOKEN=$(gcloud secrets versions access latest --secret="FLUTTERFLOW_LEAD_API_TOKEN" 2>/dev/null)

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
RESPONSE=$(curl -s -X POST "${API_BASE}/validateProjectYaml" \
    -H "Authorization: Bearer ${LEAD_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD")

# Check response
if echo "$RESPONSE" | grep -q '"success":true'; then
    echo "✅ Validation successful!"
    echo ""
    echo "Response:"
    echo "$RESPONSE" | jq '.'
    exit 0
else
    echo "❌ Validation failed!"
    echo ""
    echo "Error details:"
    echo "$RESPONSE" | jq '.'
    exit 1
fi
