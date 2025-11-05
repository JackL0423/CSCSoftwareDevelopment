#!/bin/bash
# Explore FlutterFlow API for custom code files

set -e

PROJECT_ID="c-s-c305-capstone-khj14l"
LEAD_TOKEN="9dc3d62e-6d19-4831-9386-02760f9fb7c0"
API_BASE="https://api.flutterflow.io/v2"

echo "Exploring FlutterFlow API for custom code endpoints..."
echo ""

echo "1. Listing all file names that contain 'custom':"
echo "================================================"
curl -s "${API_BASE}/listPartitionedFileNames?projectId=${PROJECT_ID}" \
  -H "Authorization: Bearer ${LEAD_TOKEN}" \
| jq -r '.value.file_names[]' | grep -i "custom"

echo ""
echo "2. Listing all file names (first 20):"
echo "====================================="
curl -s "${API_BASE}/listPartitionedFileNames?projectId=${PROJECT_ID}" \
  -H "Authorization: Bearer ${LEAD_TOKEN}" \
| jq -r '.value.file_names[]' | head -20
