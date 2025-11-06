#!/usr/bin/env bash
# Push custom actions to FlutterFlow using the syncCustomCodeChanges API
# This replicates what the VS Code Extension does

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_DIR="$PROJECT_ROOT/c_s_c305_capstone"

echo "════════════════════════════════════════════════════════════"
echo "  Push Custom Actions to FlutterFlow (API Direct)"
echo "════════════════════════════════════════════════════════════"
echo ""

# Configuration
PROJECT_ID="c-s-c305-capstone-khj14l"
BRANCH_NAME=""  # Empty for main branch
UUID=$(uuidgen)
API_BASE="https://api.flutterflow.io/v2"

# Get API token from Secret Manager
echo "🔐 Retrieving API token from Secret Manager..."
LEAD_TOKEN=$(gcloud secrets versions access latest \
    --secret="FLUTTERFLOW_LEAD_API_TOKEN" \
    --project=csc305project-475802 2>/dev/null)

if [ -z "$LEAD_TOKEN" ]; then
    echo "❌ Error: Failed to retrieve API token"
    exit 1
fi

echo "✅ API token retrieved"
echo ""

# Change to project directory
cd "$PROJECT_DIR"

# Create ZIP of custom action files
echo "📦 Creating ZIP of custom actions..."
TEMP_ZIP="/tmp/ff_custom_code_$UUID.zip"
cd lib/custom_code/actions
zip -q "$TEMP_ZIP" *.dart
cd -

# Convert ZIP to base64
echo "🔄 Converting ZIP to base64..."
ZIPPED_CUSTOM_CODE=$(base64 -w 0 "$TEMP_ZIP")

# Read pubspec.yaml
echo "📄 Reading pubspec.yaml..."
SERIALIZED_YAML=$(cat pubspec.yaml)

# Read file_map.json
echo "📋 Reading file_map.json..."
FILE_MAP=$(cat .vscode/file_map.json | jq -c 'with_entries(select(.value.type != "D"))')

# Create function_changes.json if it doesn't exist
if [ ! -f "lib/flutter_flow/function_changes.json" ]; then
    echo "{}" > lib/flutter_flow/function_changes.json
fi

FUNCTIONS_MAP=$(cat lib/flutter_flow/function_changes.json 2>/dev/null || echo "{}")

echo ""
echo "🚀 Pushing to FlutterFlow..."
echo "   Project ID: $PROJECT_ID"
echo "   Branch: main"
echo "   UUID: $UUID"
echo "   ZIP size: $(wc -c < "$TEMP_ZIP") bytes"
echo ""

# Create JSON payload
JSON_PAYLOAD=$(jq -n \
    --arg project_id "$PROJECT_ID" \
    --arg zipped_custom_code "$ZIPPED_CUSTOM_CODE" \
    --arg uid "$UUID" \
    --arg branch_name "$BRANCH_NAME" \
    --arg serialized_yaml "$SERIALIZED_YAML" \
    --argjson file_map "$FILE_MAP" \
    --argjson functions_map "$FUNCTIONS_MAP" \
    '{
        project_id: $project_id,
        zipped_custom_code: $zipped_custom_code,
        uid: $uid,
        branch_name: $branch_name,
        serialized_yaml: $serialized_yaml,
        file_map: ($file_map | tojson),
        functions_map: ($functions_map | tojson)
    }')

# Call API
HTTP_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
    "${API_BASE}/syncCustomCodeChanges" \
    -H "Authorization: Bearer ${LEAD_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "$JSON_PAYLOAD")

# Parse response
HTTP_CODE=$(echo "$HTTP_RESPONSE" | tail -n1)
RESPONSE_BODY=$(echo "$HTTP_RESPONSE" | sed '$d')

# Clean up
rm -f "$TEMP_ZIP"

echo ""
echo "════════════════════════════════════════════════════════════"

if [ "$HTTP_CODE" -eq 200 ]; then
    echo "✅ SUCCESS - Custom Actions Pushed to FlutterFlow!"
    echo "════════════════════════════════════════════════════════════"
    echo ""
    echo "Response:"
    echo "$RESPONSE_BODY" | jq -r '.' 2>/dev/null || echo "$RESPONSE_BODY"
    echo ""
    echo "Next steps:"
    echo "  1. Verify in FlutterFlow UI:"
    echo "     https://app.flutterflow.io/project/${PROJECT_ID}"
    echo "  2. Navigate to: Custom Code → Actions"
    echo "  3. Confirm 3 actions appear with 0 compile errors:"
    echo "     - initializeUserSession"
    echo "     - checkAndLogRecipeCompletion"
    echo "     - checkScrollCompletion"
    echo ""
else
    echo "❌ FAILED - HTTP Status: $HTTP_CODE"
    echo "════════════════════════════════════════════════════════════"
    echo ""
    echo "Error response:"
    echo "$RESPONSE_BODY" | jq -r '.' 2>/dev/null || echo "$RESPONSE_BODY"
    echo ""
    exit 1
fi
