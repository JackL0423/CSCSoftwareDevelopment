#!/bin/bash
# List all pages in FlutterFlow project

set -e

PROJECT_ID="c-s-c305-capstone-khj14l"
LEAD_TOKEN="9dc3d62e-6d19-4831-9386-02760f9fb7c0"
API_BASE="https://api.flutterflow.io/v2"

echo "Listing all pages in FlutterFlow project..."
echo ""

curl -s "${API_BASE}/listPartitionedFileNames?projectId=${PROJECT_ID}" \
  -H "Authorization: Bearer ${LEAD_TOKEN}" \
| jq -r '.value.file_names[]' \
| grep '^page/id-' \
| grep -v 'widget-tree' \
| grep -v 'trigger_actions' \
| grep -v 'action/' \
| sort

echo ""
echo "To download a specific page:"
echo "  ./scripts/download-yaml.sh --file page/id-XXXXXX"
