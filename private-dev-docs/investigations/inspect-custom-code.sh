#!/bin/bash
# Inspect custom code structure

set -e

PROJECT_ID="c-s-c305-capstone-khj14l"
LEAD_TOKEN="9dc3d62e-6d19-4831-9386-02760f9fb7c0"
API_BASE="https://api.flutterflow.io/v2"

mkdir -p flutterflow-yamls

echo "Downloading custom-file/id-MAIN/custom-file-code..."
curl -s "${API_BASE}/projectYamls?projectId=${PROJECT_ID}&fileName=custom-file/id-MAIN/custom-file-code" \
  -H "Authorization: Bearer ${LEAD_TOKEN}" \
| jq -r '.value.projectYamlBytes // .value.project_yaml_bytes' \
| base64 --decode > flutterflow-yamls/custom-file-code.zip

echo "ZIP contents:"
unzip -l flutterflow-yamls/custom-file-code.zip

echo ""
echo "Extracting YAML..."
unzip -p flutterflow-yamls/custom-file-code.zip | head -100
