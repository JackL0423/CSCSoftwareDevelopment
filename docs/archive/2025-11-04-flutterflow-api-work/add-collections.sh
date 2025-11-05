#!/bin/bash

echo "🔧 Adding Collections to FlutterFlow via API..."

# Get API token
TOKEN=$(gcloud secrets versions access latest --secret="FLUTTERFLOW_LEAD_API_TOKEN" 2>/dev/null)
if [ -z "$TOKEN" ]; then
    echo "❌ Failed to retrieve API token"
    exit 1
fi

PROJECT_ID="c-s-c305-capstone-khj14l"
API_BASE="https://api.flutterflow.io/v2"

echo "📋 Step 1: Getting current project structure..."

# First, let's see what collections currently exist
curl -X GET "${API_BASE}/listPartitionedFileNames?projectId=${PROJECT_ID}" \
    -H "Authorization: Bearer $TOKEN" \
    -s | jq '.value.file_names[] | select(. | startswith("collection"))' 2>/dev/null | head -20

echo ""
echo "📦 Step 2: Creating new collections..."

# Create recipes collection YAML
cat > /tmp/recipes-collection.yaml << 'EOF'
name: recipes
description: Recipe collection for GlobalFlavors app
fields:
  - fieldName: recipe_name
    fieldType: string
    isRequired: true
  - fieldName: cuisine
    fieldType: string
    isRequired: true
  - fieldName: prep_time_minutes
    fieldType: int
    isRequired: true
  - fieldName: ingredients
    fieldType: string_list
    isRequired: false
  - fieldName: instructions
    fieldType: string_list
    isRequired: false
  - fieldName: image_url
    fieldType: image_path
    isRequired: false
  - fieldName: created_at
    fieldType: timestamp
    isRequired: false
EOF

# Create user_recipe_completions collection YAML
cat > /tmp/user_recipe_completions.yaml << 'EOF'
name: user_recipe_completions
description: Track user recipe completions
fields:
  - fieldName: user_id
    fieldType: string
    isRequired: true
  - fieldName: recipe_id
    fieldType: string
    isRequired: true
  - fieldName: recipe_name
    fieldType: string
    isRequired: true
  - fieldName: cuisine
    fieldType: string
    isRequired: false
  - fieldName: completed_at
    fieldType: timestamp
    isRequired: true
  - fieldName: session_id
    fieldType: string
    isRequired: false
  - fieldName: is_first_recipe
    fieldType: bool
    isRequired: false
  - fieldName: scroll_percentage
    fieldType: double
    isRequired: false
EOF

# Create retention_metrics collection YAML
cat > /tmp/retention_metrics.yaml << 'EOF'
name: retention_metrics
description: D7 retention metrics tracking
fields:
  - fieldName: cohort_date
    fieldType: string
    isRequired: true
  - fieldName: calculation_date
    fieldType: timestamp
    isRequired: true
  - fieldName: total_users
    fieldType: int
    isRequired: true
  - fieldName: retained_users
    fieldType: int
    isRequired: true
  - fieldName: retention_rate
    fieldType: double
    isRequired: true
  - fieldName: metric_type
    fieldType: string
    isRequired: false
EOF

# Function to add collection
add_collection() {
    local collection_name=$1
    local yaml_file=$2

    echo "Adding collection: $collection_name"

    # Base64 encode the YAML
    YAML_BASE64=$(base64 -w 0 "$yaml_file")

    # Try to update/create the collection
    response=$(curl -X POST "${API_BASE}/updateProjectByYaml" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -d "{
            \"projectId\": \"${PROJECT_ID}\",
            \"fileKey\": \"collection/id-${collection_name}\",
            \"projectYamlBytes\": \"${YAML_BASE64}\"
        }" \
        -s)

    echo "$response" | jq '.'

    # Check if successful
    if echo "$response" | grep -q '"success":true'; then
        echo "✅ Collection $collection_name added successfully!"
    else
        echo "⚠️ Issue with $collection_name - checking alternative approach..."
    fi
}

# Add each collection
add_collection "recipes" "/tmp/recipes-collection.yaml"
add_collection "user_recipe_completions" "/tmp/user_recipe_completions.yaml"
add_collection "retention_metrics" "/tmp/retention_metrics.yaml"

echo ""
echo "📝 Step 3: Adding fields to Users collection..."

# Download current users collection
echo "Downloading current Users collection schema..."
./scripts/download-yaml.sh --file "collection/id-users" > /tmp/download-users.log 2>&1

if [ -f "flutterflow-yamls/collection/id-users.yaml" ]; then
    echo "Found Users collection YAML, adding retention fields..."

    # Add retention fields to Users collection
    # This is complex as we need to preserve existing structure
    echo "⚠️ Users collection update requires manual addition of fields in FlutterFlow UI"
    echo "Add these fields to Users collection:"
    echo "  - cohort_date (String)"
    echo "  - d7_retention_eligible (Boolean)"
    echo "  - first_recipe_completed_at (DateTime)"
    echo "  - last_recipe_completed_at (DateTime)"
    echo "  - timezone (String)"
    echo "  - total_recipes_completed (Number)"
fi

echo ""
echo "✅ Collection setup attempted via API!"
echo ""
echo "📋 Please check FlutterFlow to see if the collections appear."
echo "If not visible, you may need to:"
echo "1. Refresh the FlutterFlow page"
echo "2. Manually create them in the UI following the field list above"