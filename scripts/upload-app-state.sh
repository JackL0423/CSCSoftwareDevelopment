#!/bin/bash
# Upload app-state.yaml to FlutterFlow

set -e

PROJECT_ID="c-s-c305-capstone-khj14l"
LEAD_TOKEN="9dc3d62e-6d19-4831-9386-02760f9fb7c0"
API_BASE="https://api.flutterflow.io/v2"

echo "Uploading app-state.yaml to FlutterFlow..."

# Convert YAML to JSON string
YAML_STRING=$(jq -Rs . flutterflow-yamls/app-state.yaml)

# Upload with API
RESPONSE=$(curl -s -X POST "${API_BASE}/updateProjectByYaml" \
  -H "Authorization: Bearer ${LEAD_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"projectId\":\"${PROJECT_ID}\",\"fileKeyToContent\":{\"app-state\":${YAML_STRING}}}")

echo "$RESPONSE" | jq .

# Check if upload succeeded
if echo "$RESPONSE" | jq -e '.success == true' > /dev/null; then
    echo ""
    echo "✅ Upload successful! Changes are now live in FlutterFlow."
    exit 0
else
    echo ""
    echo "❌ Upload failed!"
    exit 1
fi
