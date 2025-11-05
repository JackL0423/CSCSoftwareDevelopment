#!/bin/bash
# Validate app-state.yaml changes

set -e

PROJECT_ID="c-s-c305-capstone-khj14l"
LEAD_TOKEN="9dc3d62e-6d19-4831-9386-02760f9fb7c0"
API_BASE="https://api.flutterflow.io/v2"

echo "Validating app-state.yaml..."

# Convert YAML to JSON string
YAML_STRING=$(jq -Rs . flutterflow-yamls/app-state.yaml)

# Validate with API
RESPONSE=$(curl -s -X POST "${API_BASE}/validateProjectYaml" \
  -H "Authorization: Bearer ${LEAD_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"projectId\":\"${PROJECT_ID}\",\"fileKey\":\"app-state\",\"fileContent\":${YAML_STRING}}")

echo "$RESPONSE" | jq .

# Check if validation succeeded
if echo "$RESPONSE" | jq -e '.success == true' > /dev/null; then
    echo ""
    echo "✅ Validation successful!"
    exit 0
else
    echo ""
    echo "❌ Validation failed!"
    exit 1
fi
