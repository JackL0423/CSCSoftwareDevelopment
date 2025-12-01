#!/usr/bin/env bash
# upload-yaml-simple.sh - Clean FlutterFlow YAML upload script
# Uses correct API payload format per docs/guides/FLUTTERFLOW_API_GUIDE.md
#
# Usage: ./upload-yaml-simple.sh <file-key> <yaml-file-path>
# Example: ./upload-yaml-simple.sh api-endpoint/id-5esga ./flutterflow-yamls/api-endpoint/id-5esga.yaml

set -euo pipefail

# Configuration - use environment variables with fallbacks
PROJECT_ID="${FLUTTERFLOW_PROJECT_ID:-c-s-c305-capstone-khj14l}"
API_BASE="https://api.flutterflow.io/v2"
GCP_SECRETS_PROJECT="csc305project-475802"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Parse arguments
if [ $# -lt 2 ]; then
    echo -e "${RED}Usage: $0 <file-key> <yaml-file-path>${NC}"
    echo ""
    echo "Example: $0 api-endpoint/id-5esga ./flutterflow-yamls/api-endpoint/id-5esga.yaml"
    echo ""
    echo "Environment variables:"
    echo "  FLUTTERFLOW_PROJECT_ID  - Project ID (default: c-s-c305-capstone-khj14l)"
    echo "  FLUTTERFLOW_API_TOKEN   - API token (or loaded from GCP Secrets)"
    exit 1
fi

FILE_KEY="$1"
YAML_FILE="$2"

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
echo -e "${YELLOW}FlutterFlow YAML Upload${NC}"
echo "  Project ID: $PROJECT_ID"
echo "  File Key:   $FILE_KEY"
echo "  YAML File:  $YAML_FILE"
echo ""

# Step 1: Convert YAML to JSON-escaped string (NOT base64!)
echo "Step 1: Preparing YAML content..."
YAML_STRING=$(jq -Rs . "$YAML_FILE")

# Step 2: Validate first
echo "Step 2: Validating with FlutterFlow API..."
VALIDATE_RESPONSE=$(curl -sS -X POST "${API_BASE}/validateProjectYaml" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"projectId\":\"${PROJECT_ID}\",\"fileKey\":\"${FILE_KEY}\",\"fileContent\":${YAML_STRING}}")

# Check validation result
VALIDATE_SUCCESS=$(echo "$VALIDATE_RESPONSE" | jq -r '.success // false')
if [ "$VALIDATE_SUCCESS" != "true" ]; then
    echo -e "${RED}Validation FAILED${NC}"
    echo "$VALIDATE_RESPONSE" | jq .
    exit 1
fi
echo -e "${GREEN}Validation passed${NC}"

# Step 3: Upload using fileKeyToContent format
echo "Step 3: Uploading to FlutterFlow..."
UPLOAD_RESPONSE=$(curl -sS -X POST "${API_BASE}/updateProjectByYaml" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"projectId\":\"${PROJECT_ID}\",\"fileKeyToContent\":{\"${FILE_KEY}\":${YAML_STRING}}}")

# Check upload result
UPLOAD_SUCCESS=$(echo "$UPLOAD_RESPONSE" | jq -r '.success // false')
if [ "$UPLOAD_SUCCESS" != "true" ]; then
    echo -e "${RED}Upload FAILED${NC}"
    echo "$UPLOAD_RESPONSE" | jq .
    exit 1
fi

echo ""
echo -e "${GREEN}SUCCESS: YAML uploaded to FlutterFlow${NC}"
echo ""
echo "Next steps:"
echo "  1. Open FlutterFlow project in browser"
echo "  2. Push to GitHub from FlutterFlow UI"
echo "  3. Verify changes in GitHub"
