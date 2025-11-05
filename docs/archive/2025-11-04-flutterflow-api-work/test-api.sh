#!/bin/bash
LEAD_TOKEN="9dc3d62e-6d19-4831-9386-02760f9fb7c0"
PROJECT_ID="c-s-c305-capstone-khj14l"
API_BASE="https://api.flutterflow.io/v2"

curl -sS -X GET "${API_BASE}/projectYamls?projectId=${PROJECT_ID}&fileName=app-state" -H "Authorization: Bearer ${LEAD_TOKEN}" > /tmp/raw-api-response.json

echo "Response structure:"
jq 'keys' /tmp/raw-api-response.json

echo ""
echo "Value structure:"
jq '.value | keys' /tmp/raw-api-response.json

echo ""
echo "Base64 field length:"
jq '.value.projectYamlBytes | length' /tmp/raw-api-response.json

echo ""
echo "First 200 chars of base64:"
jq -r '.value.projectYamlBytes' /tmp/raw-api-response.json | cut -c1-200
