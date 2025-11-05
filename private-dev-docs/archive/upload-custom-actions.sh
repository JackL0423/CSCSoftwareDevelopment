#!/bin/bash
# Upload Custom Actions to FlutterFlow via Update API
# Attempts to deploy Dart custom actions programmatically

set -e

PROJECT_ID="c-s-c305-capstone-khj14l"
LEAD_TOKEN="9dc3d62e-6d19-4831-9386-02760f9fb7c0"
API_BASE="https://api.flutterflow.io/v2"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "======================================"
echo "Upload Custom Actions to FlutterFlow"
echo "======================================"
echo ""

# Function to upload a custom action
upload_custom_action() {
    local action_name=$1
    local dart_file=$2
    local file_key=$3

    echo "Uploading $action_name..."

    # Read Dart code
    DART_CODE=$(cat "$dart_file")

    # Create YAML structure for custom action
    # This is an educated guess based on FlutterFlow's structure
    cat > "/tmp/${action_name}.yaml" <<EOF
name: ${action_name}
code: |
$(echo "$DART_CODE" | sed 's/^/  /')
EOF

    # Convert to JSON string
    YAML_STRING=$(jq -Rs . "/tmp/${action_name}.yaml")

    echo "Attempting upload with file key: ${file_key}"

    # Try to upload
    RESPONSE=$(curl -s -X POST "${API_BASE}/updateProjectByYaml" \
      -H "Authorization: Bearer ${LEAD_TOKEN}" \
      -H "Content-Type: application/json" \
      -d "{\"projectId\":\"${PROJECT_ID}\",\"fileKeyToContent\":{\"${file_key}\":${YAML_STRING}}}")

    echo "$RESPONSE" | jq .

    if echo "$RESPONSE" | jq -e '.success == true' > /dev/null; then
        echo -e "${GREEN}✅ Upload successful!${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️  Upload may have failed or file key incorrect${NC}"
        echo "Response: $RESPONSE"
        return 1
    fi
}

# Attempt different file key patterns
echo "Trying to upload custom actions..."
echo ""

# Try pattern 1: custom-code/actions/[name]
echo "Attempt 1: Using file key pattern 'custom-code/actions/initializeUserSession'"
upload_custom_action \
    "initializeUserSession" \
    "metrics-implementation/custom-actions/initializeUserSession.dart" \
    "custom-code/actions/initializeUserSession" || true

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Try pattern 2: custom-action/id-[name]
echo "Attempt 2: Using file key pattern 'custom-action/id-initializeUserSession'"
upload_custom_action \
    "initializeUserSession" \
    "metrics-implementation/custom-actions/initializeUserSession.dart" \
    "custom-action/id-initializeUserSession" || true

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo -e "${YELLOW}Note:${NC} If uploads are failing, it may be because:"
echo "1. Custom actions require creation via FlutterFlow UI first"
echo "2. The file key pattern is different than attempted"
echo "3. Custom code requires additional metadata not included"
echo ""
echo "To find the correct file key pattern, you can:"
echo "1. Create a test custom action in FlutterFlow UI"
echo "2. Run: ./scripts/explore-custom-code-api.sh"
echo "3. Look for the file key pattern in the output"
echo "4. Use that pattern in this script"
echo ""
echo "Alternatively, follow manual deployment instructions in:"
echo "  docs/RETENTION_IMPLEMENTATION_GUIDE.md"
