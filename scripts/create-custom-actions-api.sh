#!/bin/bash
# Attempt to create custom actions via FlutterFlow API
# Tries multiple file key patterns to find the correct one

set -e

PROJECT_ID="c-s-c305-capstone-khj14l"
LEAD_TOKEN="9dc3d62e-6d19-4831-9386-02760f9fb7c0"
API_BASE="https://api.flutterflow.io/v2"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "=========================================="
echo "Creating Custom Actions via FlutterFlow API"
echo "=========================================="
echo ""

# Function to try uploading a custom action with a specific file key pattern
try_upload_custom_action() {
    local action_name=$1
    local dart_file=$2
    local file_key=$3
    local yaml_structure=$4

    echo -e "${BLUE}Attempting: $file_key${NC}"

    # Create YAML based on structure type
    case $yaml_structure in
        "simple")
            # Simple YAML with just code
            YAML_CONTENT=$(cat <<EOF
name: ${action_name}
code: |
$(cat "$dart_file" | sed 's/^/  /')
EOF
)
            ;;
        "metadata")
            # YAML with metadata
            YAML_CONTENT=$(cat <<EOF
name: ${action_name}
description: "Custom action for retention tracking"
returnType: "Future<void>"
parameters: []
code: |
$(cat "$dart_file" | sed 's/^/  /')
EOF
)
            ;;
        "dart-only")
            # Just the Dart code
            YAML_CONTENT=$(cat "$dart_file")
            ;;
    esac

    # Convert to JSON string
    YAML_STRING=$(echo "$YAML_CONTENT" | jq -Rs .)

    # Validate first
    echo "  Validating..."
    VALIDATE_RESPONSE=$(curl -s -X POST "${API_BASE}/validateProjectYaml" \
      -H "Authorization: Bearer ${LEAD_TOKEN}" \
      -H "Content-Type: application/json" \
      -d "{\"projectId\":\"${PROJECT_ID}\",\"fileKey\":\"${file_key}\",\"fileContent\":${YAML_STRING}}")

    if echo "$VALIDATE_RESPONSE" | jq -e '.success == true' > /dev/null 2>&1; then
        echo -e "  ${GREEN}✅ Validation passed${NC}"

        # Try upload
        echo "  Uploading..."
        UPLOAD_RESPONSE=$(curl -s -X POST "${API_BASE}/updateProjectByYaml" \
          -H "Authorization: Bearer ${LEAD_TOKEN}" \
          -H "Content-Type: application/json" \
          -d "{\"projectId\":\"${PROJECT_ID}\",\"fileKeyToContent\":{\"${file_key}\":${YAML_STRING}}}")

        if echo "$UPLOAD_RESPONSE" | jq -e '.success == true' > /dev/null 2>&1; then
            echo -e "  ${GREEN}✅✅ Upload successful!${NC}"
            echo ""
            return 0
        else
            echo -e "  ${YELLOW}⚠️  Upload returned: $(echo "$UPLOAD_RESPONSE" | jq -r '.reason // "unknown"')${NC}"
        fi
    else
        echo -e "  ${YELLOW}⚠️  Validation failed: $(echo "$VALIDATE_RESPONSE" | jq -r '.reason // "unknown"')${NC}"
    fi

    echo ""
    return 1
}

# Try different patterns for initializeUserSession
echo "=========================================="
echo "Pattern Testing for: initializeUserSession"
echo "=========================================="
echo ""

DART_FILE="metrics-implementation/custom-actions/initializeUserSession.dart"
ACTION_NAME="initializeUserSession"

# Pattern 1: custom-code/actions/[name]
try_upload_custom_action "$ACTION_NAME" "$DART_FILE" "custom-code/actions/${ACTION_NAME}" "simple" && \
    echo -e "${GREEN}SUCCESS with pattern: custom-code/actions/[name]${NC}" && exit 0

# Pattern 2: custom-action/[name]
try_upload_custom_action "$ACTION_NAME" "$DART_FILE" "custom-action/${ACTION_NAME}" "simple" && \
    echo -e "${GREEN}SUCCESS with pattern: custom-action/[name]${NC}" && exit 0

# Pattern 3: custom-file/id-[name]
try_upload_custom_action "$ACTION_NAME" "$DART_FILE" "custom-file/id-${ACTION_NAME}" "simple" && \
    echo -e "${GREEN}SUCCESS with pattern: custom-file/id-[name]${NC}" && exit 0

# Pattern 4: With metadata
try_upload_custom_action "$ACTION_NAME" "$DART_FILE" "custom-code/actions/${ACTION_NAME}" "metadata" && \
    echo -e "${GREEN}SUCCESS with pattern: custom-code/actions/[name] + metadata${NC}" && exit 0

# Pattern 5: Just Dart code
try_upload_custom_action "$ACTION_NAME" "$DART_FILE" "custom-code/actions/${ACTION_NAME}" "dart-only" && \
    echo -e "${GREEN}SUCCESS with pattern: custom-code/actions/[name] dart-only${NC}" && exit 0

# Pattern 6: actions/[name]
try_upload_custom_action "$ACTION_NAME" "$DART_FILE" "actions/${ACTION_NAME}" "simple" && \
    echo -e "${GREEN}SUCCESS with pattern: actions/[name]${NC}" && exit 0

echo "=========================================="
echo -e "${RED}All patterns failed${NC}"
echo "=========================================="
echo ""
echo "Custom actions likely need to be created via FlutterFlow UI first."
echo ""
echo "Next steps:"
echo "1. Create ONE test custom action in FlutterFlow UI"
echo "2. Run: ./scripts/explore-custom-code-api.sh | grep -i action"
echo "3. Find the file key pattern"
echo "4. Update this script with the correct pattern"
echo "5. Re-run to upload all custom actions"
echo ""
exit 1
