#!/usr/bin/env bash
# Update FlutterFlow project with modified YAML files

set -e

# Load project configuration
PROJECT_ID="c-s-c305-capstone-khj14l"
API_BASE="https://api.flutterflow.io/v2"
BRANCH="JUAN-adding metric"  # Branch name

# Parse command line arguments
SKIP_VALIDATION=false
USE_MAIN=false
NO_CONFIRM=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-validation)
            SKIP_VALIDATION=true
            shift
            ;;
        --main)
            USE_MAIN=true
            shift
            ;;
        --no-confirm)
            NO_CONFIRM=true
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
    echo "Usage: $0 [--skip-validation] [--main] [--no-confirm] <file-key> <yaml-file-path>"
    echo ""
    echo "Example: $0 app-details ./flutterflow-yamls/app-details.yaml"
    echo ""
    echo "Options:"
    echo "  --skip-validation  Skip validation step (not recommended)"
    echo "  --main            Update main branch instead of JUAN-adding metric"
    echo "  --no-confirm      Skip confirmation prompt (for automation)"
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

# Validate first unless skipped
if [ "$SKIP_VALIDATION" = false ]; then
    echo "Step 1: Validating YAML..."
    VALIDATE_RESPONSE=$(curl -s -X POST "${API_BASE}/validateProjectYaml" \
        -H "Authorization: Bearer ${LEAD_TOKEN}" \
        -H "Content-Type: application/json" \
        -d "$PAYLOAD")

    if ! echo "$VALIDATE_RESPONSE" | grep -q '"success":true'; then
        echo "❌ Validation failed! Aborting update."
        echo ""
        echo "Error details:"
        echo "$VALIDATE_RESPONSE" | jq '.'
        exit 1
    fi
    echo "✅ Validation passed"
    echo ""
fi

# Update the project
echo "Step 2: Updating FlutterFlow project..."
echo "File key: $FILE_KEY"
echo "YAML file: $YAML_FILE"
echo ""

if [ "$NO_CONFIRM" = false ]; then
    read -p "Are you sure you want to update the FlutterFlow project? (yes/no): " CONFIRM

    if [ "$CONFIRM" != "yes" ]; then
        echo "Update cancelled."
        exit 0
    fi
else
    echo "Auto-confirming update (--no-confirm flag set)..."
fi

echo "Applying update..."
UPDATE_RESPONSE=$(curl -s -X POST "${API_BASE}/updateProjectByYaml" \
    -H "Authorization: Bearer ${LEAD_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD")

# Check response
if echo "$UPDATE_RESPONSE" | grep -q '"success":true'; then
    echo "✅ Update successful!"
    echo ""
    echo "Response:"
    echo "$UPDATE_RESPONSE" | jq '.'

    echo ""
    echo "⚠️  Remember to:"
    echo "1. Verify changes in FlutterFlow UI"
    echo "2. Test your app thoroughly"
    echo "3. Commit your local YAML changes to git"
else
    echo "❌ Update failed!"
    echo ""
    echo "Error details:"
    echo "$UPDATE_RESPONSE" | jq '.'
    exit 1
fi
