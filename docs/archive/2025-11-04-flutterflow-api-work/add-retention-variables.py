#!/usr/bin/env python3
"""
Add D7 retention tracking variables to FlutterFlow app-state.yaml
"""

import yaml
import random
import string
import sys

def generate_unique_key(existing_keys):
    """Generate a unique 8-character alphanumeric key"""
    while True:
        key = ''.join(random.choices(string.ascii_lowercase + string.digits, k=8))
        if key not in existing_keys:
            return key

def create_field(name, data_type, description, persisted, key):
    """Create a field structure matching FlutterFlow format"""
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

    # Set the correct dataType structure
    if data_type == 'String':
        field['parameter']['dataType']['scalarType'] = 'String'
    elif data_type == 'Integer':
        field['parameter']['dataType']['scalarType'] = 'Integer'
    elif data_type == 'Boolean':
        field['parameter']['dataType']['scalarType'] = 'Boolean'
    elif data_type == 'DateTime':
        field['parameter']['dataType']['scalarType'] = 'DateTime'

    return field

def main():
    input_file = '/tmp/app-state.yaml'
    output_file = '/tmp/app-state-modified.yaml'

    # Load existing YAML
    print(f"Loading {input_file}...")
    with open(input_file, 'r') as f:
        data = yaml.safe_load(f)

    if not data or 'fields' not in data:
        print("Error: Invalid YAML structure")
        sys.exit(1)

    # Collect existing keys
    existing_keys = set()
    for field in data['fields']:
        if 'parameter' in field and 'identifier' in field['parameter']:
            existing_keys.add(field['parameter']['identifier']['key'])

    print(f"Found {len(existing_keys)} existing variables")

    # Check if variables already exist
    existing_names = {field['parameter']['identifier']['name']
                     for field in data['fields']
                     if 'parameter' in field and 'identifier' in field['parameter']}

    # Define the 11 new retention variables
    new_variables = [
        # Non-persisted (8 variables)
        ('currentRecipeId', 'String', 'Current recipe being viewed/cooked', False),
        ('currentRecipeName', 'String', 'Name of current recipe', False),
        ('currentRecipeCuisine', 'String', 'Cuisine type of current recipe', False),
        ('currentRecipePrepTime', 'Integer', 'Prep time of current recipe (minutes)', False),
        ('recipeStartTime', 'DateTime', 'When user started current recipe', False),
        ('currentSessionId', 'String', 'Unique ID for current app session', False),
        ('sessionStartTime', 'DateTime', 'When current session started', False),
        ('recipesCompletedThisSession', 'Integer', 'Count of recipes completed in session', False),

        # Persisted (3 variables)
        ('isUserFirstRecipe', 'Boolean', 'Track if user has completed first recipe', True),
        ('userCohortDate', 'DateTime', 'Date when user first signed up (for cohort analysis)', True),
        ('userTimezone', 'String', 'User timezone for time-based analytics', True),
    ]

    # Add new variables
    added_count = 0
    skipped_count = 0

    for name, data_type, description, persisted in new_variables:
        if name in existing_names:
            print(f"  ⚠️  Skipping {name} (already exists)")
            skipped_count += 1
            continue

        key = generate_unique_key(existing_keys)
        existing_keys.add(key)

        field = create_field(name, data_type, description, persisted, key)
        data['fields'].append(field)

        persist_str = " [PERSISTED]" if persisted else ""
        print(f"  ✅ Added {name} ({data_type}){persist_str} - key: {key}")
        added_count += 1

    # Write modified YAML
    print(f"\nWriting to {output_file}...")
    with open(output_file, 'w') as f:
        yaml.dump(data, f, default_flow_style=False, sort_keys=False, allow_unicode=True)

    print(f"\n✅ Success!")
    print(f"   Added: {added_count} variables")
    print(f"   Skipped: {skipped_count} variables (already exist)")
    print(f"   Total variables: {len(data['fields'])}")
    print(f"\nModified YAML saved to: {output_file}")

if __name__ == '__main__':
    main()
