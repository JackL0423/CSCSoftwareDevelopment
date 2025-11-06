#!/usr/bin/env python3
import yaml
import base64
import json
import uuid

# Read the existing YAML
with open('/tmp/app-state.yaml', 'r') as f:
    data = yaml.safe_load(f)

# Function to generate a unique key
def generate_key():
    return ''.join(uuid.uuid4().hex[:8])

# Add our app state variables
# First, find where app state variables are stored
# They should be at the root level in a 'appStateFields' key

if 'appStateFields' not in data:
    data['appStateFields'] = []

# Current app state fields
existing_fields = {field['parameter']['identifier']['name'] for field in data.get('appStateFields', [])}

# Define our new fields
new_fields = [
    # Non-persisted variables
    {'name': 'currentRecipeId', 'type': 'String', 'persisted': False},
    {'name': 'currentRecipeName', 'type': 'String', 'persisted': False},
    {'name': 'currentRecipeCuisine', 'type': 'String', 'persisted': False},
    {'name': 'currentRecipePrepTime', 'type': 'Integer', 'persisted': False},
    {'name': 'recipeStartTime', 'type': 'DateTime', 'persisted': False},
    {'name': 'currentSessionId', 'type': 'String', 'persisted': False},
    {'name': 'sessionStartTime', 'type': 'DateTime', 'persisted': False},
    {'name': 'recipesCompletedThisSession', 'type': 'List<String>', 'persisted': False},
    # Persisted variables
    {'name': 'isUserFirstRecipe', 'type': 'Boolean', 'persisted': True, 'default': True},
    {'name': 'userCohortDate', 'type': 'String', 'persisted': True},
    {'name': 'userTimezone', 'type': 'String', 'persisted': True, 'default': 'UTC'},
]

# Add each field if it doesn't exist
for field_def in new_fields:
    if field_def['name'] not in existing_fields:
        field = {
            'parameter': {
                'identifier': {
                    'name': field_def['name'],
                    'key': generate_key()
                },
                'dataType': {},
                'description': ''
            },
            'persisted': field_def.get('persisted', False)
        }

        # Set the data type
        if field_def['type'] == 'List<String>':
            field['parameter']['dataType'] = {
                'listType': {
                    'scalarType': 'String'
                }
            }
        elif field_def['type'] == 'DateTime':
            field['parameter']['dataType'] = {
                'scalarType': 'Timestamp'
            }
        else:
            field['parameter']['dataType'] = {
                'scalarType': field_def['type']
            }

        # Add default value if specified
        if 'default' in field_def:
            if field_def['type'] == 'Boolean':
                field['defaultValue'] = {'boolValue': field_def['default']}
            elif field_def['type'] == 'String':
                field['defaultValue'] = {'stringValue': field_def['default']}

        data['appStateFields'].append(field)
        print(f"Added: {field_def['name']} ({field_def['type']}) - Persisted: {field_def.get('persisted', False)}")

# Save the modified YAML
with open('/tmp/app-state-updated.yaml', 'w') as f:
    yaml.dump(data, f, default_flow_style=False, sort_keys=False)

print("\n✅ App state variables added to YAML")
print("📝 Updated file saved to /tmp/app-state-updated.yaml")
