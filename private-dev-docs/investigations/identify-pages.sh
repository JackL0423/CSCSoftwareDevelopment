#!/bin/bash
# Download all pages and identify them by name/route

set -e

PROJECT_ID="c-s-c305-capstone-khj14l"
LEAD_TOKEN="9dc3d62e-6d19-4831-9386-02760f9fb7c0"
API_BASE="https://api.flutterflow.io/v2"

mkdir -p flutterflow-yamls/pages

echo "Downloading and identifying all pages..."
echo ""

PAGES=$(curl -s "${API_BASE}/listPartitionedFileNames?projectId=${PROJECT_ID}" \
  -H "Authorization: Bearer ${LEAD_TOKEN}" \
| jq -r '.value.file_names[]' \
| grep '^page/id-' \
| grep -v 'widget-tree' \
| grep -v 'trigger_actions' \
| grep -v 'action/' \
| sort)

for PAGE in $PAGES; do
    PAGE_ID=$(basename "$PAGE")
    echo "Downloading $PAGE_ID..."

    curl -s "${API_BASE}/projectYamls?projectId=${PROJECT_ID}&fileName=${PAGE}" \
      -H "Authorization: Bearer ${LEAD_TOKEN}" \
    | jq -r '.value.projectYamlBytes // .value.project_yaml_bytes' \
    | base64 --decode > "flutterflow-yamls/pages/${PAGE_ID}.zip"

    unzip -p "flutterflow-yamls/pages/${PAGE_ID}.zip" "${PAGE}.yaml" > "flutterflow-yamls/pages/${PAGE_ID}.yaml" 2>/dev/null || true

    # Extract name and route
    NAME=$(grep -A 1 "^name:" "flutterflow-yamls/pages/${PAGE_ID}.yaml" 2>/dev/null | grep "value:" | head -1 | sed 's/.*value: //' || echo "Unknown")
    ROUTE=$(grep "route:" "flutterflow-yamls/pages/${PAGE_ID}.yaml" 2>/dev/null | head -1 | sed 's/.*route: //' || echo "Unknown")

    echo "  Name: $NAME"
    echo "  Route: $ROUTE"
    echo "  File: flutterflow-yamls/pages/${PAGE_ID}.yaml"
    echo ""
done

echo "All pages downloaded to: flutterflow-yamls/pages/"
