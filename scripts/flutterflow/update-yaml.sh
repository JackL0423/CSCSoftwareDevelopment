#!/usr/bin/env bash
# update-yaml.sh - Upload YAML changes to FlutterFlow project
#
# Usage: ./update-yaml.sh [options] <file-key> <yaml-file-path>
# Example: ./update-yaml.sh app-state ./flutterflow-yamls/app-state.yaml
#
# NOTE: FlutterFlow API does NOT support branch selection.
#       All operations target the main/default branch only.
#       See docs/guides/FLUTTERFLOW_API_GUIDE.md for details.

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

# Parse command line arguments
SKIP_VALIDATION=false
NO_CONFIRM=false
FILE_KEY=""
YAML_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-validation)
            SKIP_VALIDATION=true
            shift
            ;;
        --no-confirm)
            NO_CONFIRM=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [options] <file-key> <yaml-file-path>"
            echo ""
            echo "Upload YAML changes to FlutterFlow project."
            echo ""
            echo "Arguments:"
            echo "  file-key        FlutterFlow file identifier (e.g., app-state, api-endpoint/id-5esga)"
            echo "  yaml-file-path  Path to the YAML file to upload"
            echo ""
            echo "Options:"
            echo "  --skip-validation  Skip validation step (not recommended)"
            echo "  --no-confirm       Skip confirmation prompt (for automation)"
            echo "  --help, -h         Show this help message"
            echo ""
            echo "Environment variables:"
            echo "  FLUTTERFLOW_PROJECT_ID   Project ID (default: c-s-c305-capstone-khj14l)"
            echo "  FLUTTERFLOW_API_TOKEN    API token (or loaded from GCP Secrets)"
            echo ""
            echo "Examples:"
            echo "  $0 app-state ./flutterflow-yamls/app-state.yaml"
            echo "  $0 --no-confirm api-endpoint/id-5esga ./flutterflow-yamls/api-endpoint/id-5esga.yaml"
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
    echo "Usage: $0 [options] <file-key> <yaml-file-path>"
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
echo -e "${YELLOW}FlutterFlow YAML Update${NC}"
echo "  Project ID: $PROJECT_ID"
echo "  File Key:   $FILE_KEY"
echo "  YAML File:  $YAML_FILE"
echo ""

# Convert YAML to JSON-escaped string (NOT base64!)
# Per docs/guides/FLUTTERFLOW_API_GUIDE.md: uploads require plain YAML string
YAML_STRING=$(jq -Rs . "$YAML_FILE")

# Step 1: Validate (unless skipped)
if [ "$SKIP_VALIDATION" = false ]; then
    echo "Step 1: Validating YAML with FlutterFlow API..."

    VALIDATE_RESPONSE=$(curl -sS -X POST "${API_BASE}/validateProjectYaml" \
        -H "Authorization: Bearer ${TOKEN}" \
        -H "Content-Type: application/json" \
        -d "{\"projectId\":\"${PROJECT_ID}\",\"fileKey\":\"${FILE_KEY}\",\"fileContent\":${YAML_STRING}}")

    VALIDATE_SUCCESS=$(echo "$VALIDATE_RESPONSE" | jq -r '.success // false')
    if [ "$VALIDATE_SUCCESS" != "true" ]; then
        echo -e "${RED}Validation FAILED${NC}"
        echo ""
        echo "Error details:"
        echo "$VALIDATE_RESPONSE" | jq .
        exit 1
    fi
    echo -e "${GREEN}Validation passed${NC}"
    echo ""
else
    echo -e "${YELLOW}Step 1: Skipping validation (--skip-validation)${NC}"
    echo ""
fi

# Step 2: Confirmation
if [ "$NO_CONFIRM" = false ]; then
    echo "Step 2: Confirmation"
    read -p "Are you sure you want to update the FlutterFlow project? (yes/no): " CONFIRM

    if [ "$CONFIRM" != "yes" ]; then
        echo "Update cancelled."
        exit 0
    fi
    echo ""
else
    echo "Step 2: Auto-confirming update (--no-confirm)"
    echo ""
fi

# Step 3: Upload using fileKeyToContent format
echo "Step 3: Uploading to FlutterFlow..."

UPLOAD_RESPONSE=$(curl -sS -X POST "${API_BASE}/updateProjectByYaml" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"projectId\":\"${PROJECT_ID}\",\"fileKeyToContent\":{\"${FILE_KEY}\":${YAML_STRING}}}")

UPLOAD_SUCCESS=$(echo "$UPLOAD_RESPONSE" | jq -r '.success // false')
if [ "$UPLOAD_SUCCESS" != "true" ]; then
    echo -e "${RED}Upload FAILED${NC}"
    echo ""
    echo "Error details:"
    echo "$UPLOAD_RESPONSE" | jq .
    exit 1
fi

echo ""
echo -e "${GREEN}SUCCESS: YAML uploaded to FlutterFlow${NC}"
echo ""
echo "Next steps:"
echo "  1. Verify changes in FlutterFlow UI"
echo "  2. Test your app thoroughly"
echo "  3. Push to GitHub from FlutterFlow (if connected)"
echo "  4. Commit your local YAML changes to git"
