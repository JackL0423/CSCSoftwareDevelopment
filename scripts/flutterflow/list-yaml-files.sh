#!/bin/bash
# List all editable YAML files in the FlutterFlow project

set -e

# Load project configuration
PROJECT_ID="c-s-c305-capstone-khj14l"
API_BASE="https://api.flutterflow.io/v2"

# Get LEAD API token from Secret Manager
echo "Retrieving API token from Secret Manager..."
LEAD_TOKEN=$(gcloud secrets versions access latest --secret="FLUTTERFLOW_LEAD_API_TOKEN" --project=csc305project-475802 2>/dev/null)

if [ -z "$LEAD_TOKEN" ]; then
    echo "Error: Failed to retrieve LEAD API token"
    exit 1
fi

echo "Fetching YAML file list from FlutterFlow..."
RESPONSE=$(curl -s -X GET "${API_BASE}/listPartitionedFileNames?projectId=${PROJECT_ID}" \
    -H "Authorization: Bearer ${LEAD_TOKEN}")

# Check if request was successful
if ! echo "$RESPONSE" | grep -q '"success":true'; then
    echo "Error: API request failed"
    echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
    exit 1
fi

# Extract and display file names
echo ""
echo "Available YAML files:"
echo "===================="
echo "$RESPONSE" | jq -r '.value.file_names[]' | sort

# Display count
FILE_COUNT=$(echo "$RESPONSE" | jq '.value.file_names | length')
echo ""
echo "Total files: $FILE_COUNT"

# Display version info
echo ""
echo "Project Version Info:"
echo "$RESPONSE" | jq '.value.version_info'
