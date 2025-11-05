#!/bin/bash
# Test single custom action upload and show raw response

set -e

PROJECT_ID="c-s-c305-capstone-khj14l"
LEAD_TOKEN="9dc3d62e-6d19-4831-9386-02760f9fb7c0"
API_BASE="https://api.flutterflow.io/v2"

echo "Testing single custom action upload..."
echo ""

DART_FILE="metrics-implementation/custom-actions/initializeUserSession.dart"
FILE_KEY="custom-code/actions/initializeUserSession"

# Create simple YAML
YAML_CONTENT=$(cat <<EOF
name: initializeUserSession
code: |
$(cat "$DART_FILE" | sed 's/^/  /')
EOF
)

# Convert to JSON string
YAML_STRING=$(echo "$YAML_CONTENT" | jq -Rs .)

echo "File key: $FILE_KEY"
echo ""

# Try upload and show RAW response
echo "Upload response (raw):"
RESPONSE=$(curl -s -X POST "${API_BASE}/updateProjectByYaml" \
  -H "Authorization: Bearer ${LEAD_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"projectId\":\"${PROJECT_ID}\",\"fileKeyToContent\":{\"${FILE_KEY}\":${YAML_STRING}}}")

echo "$RESPONSE"
echo ""
echo "Response length: $(echo "$RESPONSE" | wc -c) characters"
echo ""

# Try to parse as JSON
if echo "$RESPONSE" | jq . 2>/dev/null; then
    echo "✅ Valid JSON"

    if echo "$RESPONSE" | jq -e '.success == true' > /dev/null; then
        echo "✅ Success!  "
    else
        echo "❌ API returned success=false"
        echo "Reason: $(echo "$RESPONSE" | jq -r '.reason // "none"')"
    fi
else
    echo "❌ Invalid JSON response"
fi
