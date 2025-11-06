#!/bin/bash

echo "🔧 Downloading all FlutterFlow YAML files..."

TOKEN="[REDACTED]"
PROJECT_ID="c-s-c305-capstone-khj14l"
API_BASE="https://api.flutterflow.io/v2"

# Create download directory
OUTPUT_DIR="flutterflow-project-yamls"
mkdir -p "$OUTPUT_DIR"

echo "📋 Step 1: Getting list of all YAML files..."

# Get list of all files
response=$(curl -X GET "${API_BASE}/listPartitionedFileNames?projectId=${PROJECT_ID}" \
    -H "Authorization: Bearer $TOKEN" \
    -s)

# Save response for debugging
echo "$response" > "$OUTPUT_DIR/file-list.json"

# Extract file names
file_count=$(echo "$response" | jq -r '.value.file_names | length' 2>/dev/null)

if [ -z "$file_count" ] || [ "$file_count" = "null" ]; then
    echo "❌ Failed to get file list"
    exit 1
fi

echo "Found $file_count YAML files to download"

# Extract important files first
important_files=(
    "app-state"
    "app-details"
    "theme"
    "authentication"
    "platforms"
)

echo ""
echo "📦 Step 2: Downloading important files first..."

for file_key in "${important_files[@]}"; do
    echo -n "Downloading $file_key... "

    # Download the file
    file_response=$(curl -X GET "${API_BASE}/projectYamls?projectId=${PROJECT_ID}&fileKey=${file_key}" \
        -H "Authorization: Bearer $TOKEN" \
        -s)

    # Check if successful
    if echo "$file_response" | grep -q '"success":true'; then
        # Extract and decode the YAML
        echo "$file_response" | jq -r '.value.project_yaml_bytes' | base64 -d > "$OUTPUT_DIR/${file_key}.zip" 2>/dev/null

        # Try to unzip
        if [ -f "$OUTPUT_DIR/${file_key}.zip" ]; then
            unzip -p "$OUTPUT_DIR/${file_key}.zip" > "$OUTPUT_DIR/${file_key}.yaml" 2>/dev/null

            if [ -s "$OUTPUT_DIR/${file_key}.yaml" ]; then
                echo "✅ Success ($(wc -l < "$OUTPUT_DIR/${file_key}.yaml") lines)"
            else
                echo "⚠️ Empty or binary file"
                # Save raw base64 for analysis
                echo "$file_response" | jq -r '.value.project_yaml_bytes' > "$OUTPUT_DIR/${file_key}.base64"
            fi
            rm "$OUTPUT_DIR/${file_key}.zip" 2>/dev/null
        else
            echo "⚠️ Failed to decode"
        fi
    else
        echo "❌ Failed"
    fi
done

echo ""
echo "📂 Step 3: Checking for collection files..."

# Get all collection files
collection_files=$(echo "$response" | jq -r '.value.file_names[]' 2>/dev/null | grep "^collection/" | head -10)

if [ ! -z "$collection_files" ]; then
    mkdir -p "$OUTPUT_DIR/collections"

    echo "$collection_files" | while read -r file_key; do
        if [ ! -z "$file_key" ]; then
            echo -n "Downloading $file_key... "

            file_response=$(curl -X GET "${API_BASE}/projectYamls?projectId=${PROJECT_ID}&fileKey=${file_key}" \
                -H "Authorization: Bearer $TOKEN" \
                -s)

            if echo "$file_response" | grep -q '"success":true'; then
                # Create safe filename
                safe_name=$(echo "$file_key" | tr '/' '_')
                echo "$file_response" | jq -r '.value.project_yaml_bytes' | base64 -d > "$OUTPUT_DIR/collections/${safe_name}.zip" 2>/dev/null
                unzip -p "$OUTPUT_DIR/collections/${safe_name}.zip" > "$OUTPUT_DIR/collections/${safe_name}.yaml" 2>/dev/null

                if [ -s "$OUTPUT_DIR/collections/${safe_name}.yaml" ]; then
                    echo "✅ Success"
                else
                    echo "⚠️ Empty"
                fi
                rm "$OUTPUT_DIR/collections/${safe_name}.zip" 2>/dev/null
            else
                echo "❌ Failed"
            fi
        fi
    done
else
    echo "No collection files found"
fi

echo ""
echo "📊 Download Summary:"
echo "-------------------"
echo "Downloaded files are in: $OUTPUT_DIR/"
echo ""
ls -la "$OUTPUT_DIR/" | head -20

echo ""
echo "To view a file:"
echo "  cat $OUTPUT_DIR/app-state.yaml | head -50"
echo ""
echo "To see the file structure:"
echo "  ls -la $OUTPUT_DIR/"
