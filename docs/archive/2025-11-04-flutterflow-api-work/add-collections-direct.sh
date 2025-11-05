#!/bin/bash

echo "🔧 Adding Collections to FlutterFlow via API..."

# API token (from CLAUDE.md)
TOKEN="9dc3d62e-6d19-4831-9386-02760f9fb7c0"

PROJECT_ID="c-s-c305-capstone-khj14l"
API_BASE="https://api.flutterflow.io/v2"

echo "📋 Step 1: Checking existing collections..."

# List existing collections
existing_collections=$(curl -X GET "${API_BASE}/listPartitionedFileNames?projectId=${PROJECT_ID}" \
    -H "Authorization: Bearer $TOKEN" \
    -s | jq -r '.value.file_names[]' 2>/dev/null | grep "^collection/" | head -10)

echo "Existing collections:"
echo "$existing_collections"

echo ""
echo "📦 Step 2: Attempting to add collections via API..."

# Try alternative approach - download a collection first to understand structure
echo "Downloading Users collection to understand structure..."

# Get Users collection to see format
curl -X GET "${API_BASE}/projectYamls?projectId=${PROJECT_ID}&fileKey=collection/id-Users" \
    -H "Authorization: Bearer $TOKEN" \
    -s -o /tmp/users-response.json

# Check if we got a response
if [ -f "/tmp/users-response.json" ]; then
    # Extract and decode the YAML
    cat /tmp/users-response.json | jq -r '.project_yaml_bytes' | base64 -d > /tmp/users-collection.yaml 2>/dev/null || true

    if [ -f "/tmp/users-collection.yaml" ] && [ -s "/tmp/users-collection.yaml" ]; then
        echo "✅ Downloaded Users collection structure"
        echo "Sample structure:"
        head -20 /tmp/users-collection.yaml
    fi
fi

echo ""
echo "📝 Unfortunately, FlutterFlow doesn't support creating NEW collections via API."
echo ""
echo "The API only allows updating EXISTING collections that were created in the UI."
echo ""
echo "✅ What we CAN do via API:"
echo "  - Update existing collection schemas"
echo "  - Add fields to existing collections"
echo "  - Modify collection settings"
echo ""
echo "❌ What we CANNOT do via API:"
echo "  - Create brand new collections"
echo "  - Delete collections"
echo ""
echo "📋 You need to manually create these collections in FlutterFlow UI:"
echo ""
echo "1️⃣ Collection: recipes"
echo "   Fields:"
echo "   - recipe_name (String)"
echo "   - cuisine (String)"
echo "   - prep_time_minutes (Number)"
echo "   - ingredients (List<String>)"
echo "   - instructions (List<String>)"
echo "   - image_url (Image Path)"
echo ""
echo "2️⃣ Collection: user_recipe_completions"
echo "   Fields:"
echo "   - user_id (String)"
echo "   - recipe_id (Document Reference → recipes)"
echo "   - recipe_name (String)"
echo "   - cuisine (String)"
echo "   - completed_at (DateTime)"
echo "   - session_id (String)"
echo "   - is_first_recipe (Boolean)"
echo "   - scroll_percentage (Double)"
echo ""
echo "3️⃣ Collection: retention_metrics"
echo "   Fields:"
echo "   - cohort_date (String)"
echo "   - calculation_date (DateTime)"
echo "   - total_users (Number)"
echo "   - retained_users (Number)"
echo "   - retention_rate (Double)"
echo "   - metric_type (String)"
echo ""
echo "4️⃣ Add to Users collection:"
echo "   - cohort_date (String)"
echo "   - d7_retention_eligible (Boolean)"
echo "   - first_recipe_completed_at (DateTime)"
echo "   - last_recipe_completed_at (DateTime)"
echo "   - timezone (String)"
echo "   - total_recipes_completed (Number)"
echo ""
echo "Once you create these in FlutterFlow, they'll automatically connect"
echo "to the data we already created in Firebase! 🎉"