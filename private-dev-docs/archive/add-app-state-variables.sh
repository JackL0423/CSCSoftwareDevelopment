#!/bin/bash
# Automated script to add D7 retention tracking variables to FlutterFlow app-state
# Usage: ./scripts/add-app-state-variables.sh

set -e

# Configuration
PROJECT_ID="c-s-c305-capstone-khj14l"
API_BASE="https://api.flutterflow.io/v2"
LEAD_TOKEN="9dc3d62e-6d19-4831-9386-02760f9fb7c0"
WORK_DIR="/tmp/ff-automation"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Setup
echo -e "${GREEN}=== FlutterFlow App State Variable Automation ===${NC}"
echo ""
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# Step 1: Download current app-state.yaml
echo -e "${YELLOW}[1/6] Downloading current app-state.yaml...${NC}"
# Defensive: support both projectYamlBytes (docs) and project_yaml_bytes (actual)
curl -sS -X GET "${API_BASE}/projectYamls?projectId=${PROJECT_ID}&fileName=app-state" \
    -H "Authorization: Bearer ${LEAD_TOKEN}" \
| jq -r '.value.projectYamlBytes // .value.project_yaml_bytes' \
| tr -d '\n' \
| base64 --decode > app-state.zip

if ! file -b --mime-type app-state.zip | grep -q 'application/zip'; then
    echo -e "${RED}Error: Failed to download valid ZIP file${NC}"
    exit 1
fi

unzip -p app-state.zip app-state.yaml > app-state-original.yaml 2>/dev/null
echo -e "${GREEN}  ✓ Downloaded $(wc -l < app-state-original.yaml) lines${NC}"

# Create backup
cp app-state-original.yaml app-state-backup.yaml

# Step 2: Add retention variables
echo -e "${YELLOW}[2/6] Adding D7 retention variables...${NC}"

cat > add-variables.py << 'PYTHON_SCRIPT'
#!/usr/bin/env python3
import yaml
import random
import string
import sys

def generate_unique_key(existing_keys):
    while True:
        key = ''.join(random.choices(string.ascii_lowercase + string.digits, k=8))
        if key not in existing_keys:
            return key

def create_field(name, data_type, description, persisted, key):
    field = {
        'parameter': {
            'identifier': {
                'name': name,
                'key': key
            },
            'dataType': {},
            'description': description
        },
        'persisted': persisted
    }
    if data_type == 'String':
        field['parameter']['dataType']['scalarType'] = 'String'
    elif data_type == 'Integer':
        field['parameter']['dataType']['scalarType'] = 'Integer'
    elif data_type == 'Boolean':
        field['parameter']['dataType']['scalarType'] = 'Boolean'
    elif data_type == 'DateTime':
        field['parameter']['dataType']['scalarType'] = 'DateTime'
    return field

with open('app-state-original.yaml', 'r') as f:
    data = yaml.safe_load(f)

existing_keys = set()
existing_names = set()
for field in data['fields']:
    if 'parameter' in field and 'identifier' in field['parameter']:
        existing_keys.add(field['parameter']['identifier']['key'])
        existing_names.add(field['parameter']['identifier']['name'])

new_variables = [
    ('currentRecipeId', 'String', 'Current recipe being viewed/cooked', False),
    ('currentRecipeName', 'String', 'Name of current recipe', False),
    ('currentRecipeCuisine', 'String', 'Cuisine type of current recipe', False),
    ('currentRecipePrepTime', 'Integer', 'Prep time of current recipe (minutes)', False),
    ('recipeStartTime', 'DateTime', 'When user started current recipe', False),
    ('currentSessionId', 'String', 'Unique ID for current app session', False),
    ('sessionStartTime', 'DateTime', 'When current session started', False),
    ('recipesCompletedThisSession', 'Integer', 'Count of recipes completed in session', False),
    ('isUserFirstRecipe', 'Boolean', 'Track if user has completed first recipe', True),
    ('userCohortDate', 'DateTime', 'Date when user first signed up (for cohort analysis)', True),
    ('userTimezone', 'String', 'User timezone for time-based analytics', True),
]

added_count = 0
for name, data_type, description, persisted in new_variables:
    if name in existing_names:
        print(f"  ⚠️  Skipping {name} (already exists)")
        continue
    key = generate_unique_key(existing_keys)
    existing_keys.add(key)
    field = create_field(name, data_type, description, persisted, key)
    data['fields'].append(field)
    persist_str = " [PERSISTED]" if persisted else ""
    print(f"  ✓ Added {name} ({data_type}){persist_str}")
    added_count += 1

with open('app-state-modified.yaml', 'w') as f:
    yaml.dump(data, f, default_flow_style=False, sort_keys=False, allow_unicode=True)

print(f"\n  Total: {added_count} variables added, {len(data['fields'])} total")
sys.exit(0 if added_count > 0 else 1)
PYTHON_SCRIPT

chmod +x add-variables.py
if ! python3 add-variables.py; then
    echo -e "${YELLOW}  Note: No new variables added (may already exist)${NC}"
fi

# Step 3: Show diff
echo ""
echo -e "${YELLOW}[3/6] Changes to be made:${NC}"
if command -v diff > /dev/null; then
    diff -u app-state-original.yaml app-state-modified.yaml | tail -50 || true
fi
echo ""
echo "  Original: $(wc -l < app-state-original.yaml) lines"
echo "  Modified: $(wc -l < app-state-modified.yaml) lines"
echo "  Added:    $(($(wc -l < app-state-modified.yaml) - $(wc -l < app-state-original.yaml))) lines"

# Step 4: Validate with FlutterFlow API
echo ""
echo -e "${YELLOW}[4/6] Validating with FlutterFlow API...${NC}"
# Convert YAML to JSON string (escape newlines, quotes, etc.)
YAML_STRING=$(jq -Rs . app-state-modified.yaml)

VALIDATE_RESPONSE=$(curl -sS -X POST "${API_BASE}/validateProjectYaml" \
  -H "Authorization: Bearer ${LEAD_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"projectId\":\"${PROJECT_ID}\",\"fileKey\":\"app-state\",\"fileContent\":${YAML_STRING}}")

if echo "$VALIDATE_RESPONSE" | jq -e '.success == true' > /dev/null 2>&1; then
    echo -e "${GREEN}  ✓ Validation passed${NC}"
else
    echo -e "${RED}  ✗ Validation failed:${NC}"
    echo "$VALIDATE_RESPONSE" | jq '.'
    exit 1
fi

# Step 5: Confirm upload
echo ""
echo -e "${YELLOW}[5/6] Ready to upload to FlutterFlow${NC}"
read -p "  Upload changes to live FlutterFlow project? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo -e "${YELLOW}  Upload cancelled. Modified YAML saved to: ${WORK_DIR}/app-state-modified.yaml${NC}"
    echo -e "${YELLOW}  Backup saved to: ${WORK_DIR}/app-state-backup.yaml${NC}"
    exit 0
fi

# Step 6: Upload
echo -e "${YELLOW}[6/6] Uploading to FlutterFlow...${NC}"

UPLOAD_RESPONSE=$(curl -sS -X POST "${API_BASE}/updateProjectByYaml" \
  -H "Authorization: Bearer ${LEAD_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"projectId\":\"${PROJECT_ID}\",\"fileKeyToContent\":{\"app-state\":${YAML_STRING}}}")

if echo "$UPLOAD_RESPONSE" | jq -e '.success == true' > /dev/null 2>&1; then
    echo -e "${GREEN}  ✓ Upload successful!${NC}"
    echo ""
    echo -e "${GREEN}=== SUCCESS ===${NC}"
    echo "All retention variables have been added to FlutterFlow!"
    echo ""
    echo "Added variables:"
    echo "  Non-persisted (8):"
    echo "    • currentRecipeId, currentRecipeName, currentRecipeCuisine"
    echo "    • currentRecipePrepTime, recipeStartTime"
    echo "    • currentSessionId, sessionStartTime, recipesCompletedThisSession"
    echo ""
    echo "  Persisted (3):"
    echo "    • isUserFirstRecipe, userCohortDate, userTimezone"
    echo ""
    echo "Next steps:"
    echo "  1. Open FlutterFlow: https://app.flutterflow.io/project/${PROJECT_ID}"
    echo "  2. Go to App State to verify variables"
    echo "  3. Use variables in your pages and actions"
    echo ""
    echo "Files saved to: ${WORK_DIR}"
else
    echo -e "${RED}  ✗ Upload failed:${NC}"
    echo "$UPLOAD_RESPONSE" | jq '.'
    echo ""
    echo "Backup saved to: ${WORK_DIR}/app-state-backup.yaml"
    exit 1
fi
