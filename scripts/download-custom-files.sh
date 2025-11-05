#!/bin/bash
# Download custom code files from FlutterFlow

set -e

PROJECT_ID="c-s-c305-capstone-khj14l"
LEAD_TOKEN="9dc3d62e-6d19-4831-9386-02760f9fb7c0"
API_BASE="https://api.flutterflow.io/v2"

mkdir -p flutterflow-yamls

echo "Downloading custom-file/id-MAIN..."
curl -s "${API_BASE}/projectYamls?projectId=${PROJECT_ID}&fileName=custom-file/id-MAIN" \
  -H "Authorization: Bearer ${LEAD_TOKEN}" \
| jq -r '.value.projectYamlBytes // .value.project_yaml_bytes' \
| base64 --decode > flutterflow-yamls/custom-file-main.zip

unzip -p flutterflow-yamls/custom-file-main.zip "custom-file/id-MAIN.yaml" > flutterflow-yamls/custom-file-main.yaml

echo "Downloaded to: flutterflow-yamls/custom-file-main.yaml"
echo ""
echo "Contents:"
cat flutterflow-yamls/custom-file-main.yaml
