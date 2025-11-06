#!/bin/bash

API_BASE="https://api.flutterflow.io/v2"
TOKEN="[REDACTED]"
PROJECT_ID="c-s-c305-capstone-khj14l"

# Broken fields to search for
broken_fields=("userTags" "dietaryTags" "prefTags" "dietTags")

echo "🔍 Searching for broken field references in FlutterFlow project..."
echo ""

# Get list of all files
curl -s -X GET "${API_BASE}/listPartitionedFileNames?projectId=${PROJECT_ID}" \
    -H "Authorization: Bearer $TOKEN" > /tmp/all-files.json

total_files=$(cat /tmp/all-files.json | jq -r '.value.file_names | length')
echo "Total files: $total_files"
echo ""

# Extract action and page files
cat /tmp/all-files.json | jq -r '.value.file_names[]' | \
    grep -E "action|page/id-" > /tmp/action-files.txt

action_count=$(wc -l < /tmp/action-files.txt)
echo "Searching $action_count action/page files..."
echo ""

> /tmp/broken-files.txt

count=0
while read -r file_key; do
    count=$((count + 1))

    if [ $((count % 100)) -eq 0 ]; then
        echo "Progress: $count/$action_count files checked..."
    fi

    # Download YAML
    response=$(curl -s -X GET "${API_BASE}/projectYamls?projectId=${PROJECT_ID}&fileKey=${file_key}" \
        -H "Authorization: Bearer $TOKEN")

    # Check if successful
    if ! echo "$response" | grep -q '"success":true'; then
        continue
    fi

    # Extract and decode YAML
    yaml_content=$(echo "$response" | jq -r '.value.project_yaml_bytes' | base64 -d 2>/dev/null)

    # Try to unzip if it's a zip file
    if echo "$yaml_content" | head -c 2 | grep -q "PK"; then
        echo "$yaml_content" > /tmp/temp.zip
        yaml_content=$(unzip -p /tmp/temp.zip 2>/dev/null || echo "$yaml_content")
    fi

    # Check for broken fields
    for field in "${broken_fields[@]}"; do
        if echo "$yaml_content" | grep -q "$field"; then
            echo "✗ Found '$field' in: $file_key"
            echo "$file_key|$field" >> /tmp/broken-files.txt
            break
        fi
    done

done < /tmp/action-files.txt

echo ""
echo "========================================================"
found_count=$(wc -l < /tmp/broken-files.txt 2>/dev/null || echo "0")
echo "Found $found_count files with broken field references"
echo "========================================================"
echo ""

if [ -s /tmp/broken-files.txt ]; then
    echo "Files with issues:"
    cat /tmp/broken-files.txt | while IFS='|' read -r file field; do
        echo "  - $file (field: $field)"
    done
else
    echo "No broken field references found!"
fi

echo ""
echo "📝 Results saved to: /tmp/broken-files.txt"
