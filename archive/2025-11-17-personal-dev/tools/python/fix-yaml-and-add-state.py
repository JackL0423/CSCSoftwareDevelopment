#!/usr/bin/env python3
import base64
import zipfile
import io
import re
import uuid
import json

# Read the API response
with open('/tmp/app-state-main.json', 'r') as f:
    response = json.load(f)

# Extract and decode the base64 data
yaml_bytes_b64 = response['value']['project_yaml_bytes']
yaml_bytes = base64.b64decode(yaml_bytes_b64)

# It's a zip file, extract it
with zipfile.ZipFile(io.BytesIO(yaml_bytes), 'r') as zip_file:
    # Get the first file in the zip
    file_list = zip_file.namelist()
    if file_list:
        with zip_file.open(file_list[0]) as yaml_file:
            yaml_content = yaml_file.read().decode('utf-8')

# Fix known formatting issues
# Fix concatenated lines
yaml_content = re.sub(r'(\w)name: CSC305Capstone', r'\1\nname: CSC305Capstone', yaml_content)
yaml_content = re.sub(r'(\w)identifier:', r'\1\nidentifier:', yaml_content)
yaml_content = re.sub(r'(\w)fields:', r'\1\nfields:', yaml_content)
yaml_content = re.sub(r'(\w)description:', r'\1\ndescription:', yaml_content)
yaml_content = re.sub(r'(\w)node:', r'\1\nnode:', yaml_content)
yaml_content = re.sub(r'(\w)type:', r'\1\ntype:', yaml_content)
yaml_content = re.sub(r'(\w)enabled:', r'\1\nenabled:', yaml_content)
yaml_content = re.sub(r'(\w)isUnlocked:', r'\1\nisUnlocked:', yaml_content)
yaml_content = re.sub(r'(\w)useMaterial2:', r'\1\nuseMaterial2:', yaml_content)
yaml_content = re.sub(r'(\w)currentEnvironment:', r'\1\ncurrentEnvironment:', yaml_content)
yaml_content = re.sub(r'(\w)applyFixesToGithub:', r'\1\napplyFixesToGithub:', yaml_content)
yaml_content = re.sub(r'(\w)enableGemini:', r'\1\nenableGemini:', yaml_content)
yaml_content = re.sub(r'(\w)rules:', r'\1\nrules:', yaml_content)

# Save the cleaned YAML
with open('/tmp/app-state-clean.yaml', 'w') as f:
    f.write(yaml_content)

print("✅ YAML extracted and cleaned")
print(f"File size: {len(yaml_content)} bytes")
print(f"Lines: {len(yaml_content.splitlines())}")

# Now let's check if appStateFields exists
lines = yaml_content.splitlines()
found_app_state = False
for i, line in enumerate(lines):
    if 'appStateFields:' in line or 'fields:' in line and i == len(lines) - 100:
        print(f"\nFound fields section at line {i+1}: {line}")
        found_app_state = True

if not found_app_state:
    print("\nNo appStateFields found - we'll need to add it")

# Generate app state fields to add
app_state_fields = """
appStateFields:
  - parameter:
      identifier:
        name: currentRecipeId
        key: {}
      dataType:
        scalarType: String
      description: "Track current recipe being viewed"
    persisted: false
  - parameter:
      identifier:
        name: currentRecipeName
        key: {}
      dataType:
        scalarType: String
      description: "Name of current recipe"
    persisted: false
  - parameter:
      identifier:
        name: currentRecipeCuisine
        key: {}
      dataType:
        scalarType: String
      description: "Cuisine type of current recipe"
    persisted: false
  - parameter:
      identifier:
        name: currentRecipePrepTime
        key: {}
      dataType:
        scalarType: Integer
      description: "Prep time in minutes"
    persisted: false
  - parameter:
      identifier:
        name: recipeStartTime
        key: {}
      dataType:
        scalarType: Timestamp
      description: "When user started viewing recipe"
    persisted: false
  - parameter:
      identifier:
        name: currentSessionId
        key: {}
      dataType:
        scalarType: String
      description: "Current session identifier"
    persisted: false
  - parameter:
      identifier:
        name: sessionStartTime
        key: {}
      dataType:
        scalarType: Timestamp
      description: "When session started"
    persisted: false
  - parameter:
      identifier:
        name: recipesCompletedThisSession
        key: {}
      dataType:
        listType:
          scalarType: String
      description: "List of recipes completed in current session"
    persisted: false
  - parameter:
      identifier:
        name: isUserFirstRecipe
        key: {}
      dataType:
        scalarType: Boolean
      description: "Whether this is user's first recipe"
    persisted: true
    defaultValue:
      boolValue: true
  - parameter:
      identifier:
        name: userCohortDate
        key: {}
      dataType:
        scalarType: String
      description: "User's cohort date for retention tracking"
    persisted: true
  - parameter:
      identifier:
        name: userTimezone
        key: {}
      dataType:
        scalarType: String
      description: "User's timezone"
    persisted: true
    defaultValue:
      stringValue: "UTC"
""".format(
    uuid.uuid4().hex[:8], uuid.uuid4().hex[:8], uuid.uuid4().hex[:8],
    uuid.uuid4().hex[:8], uuid.uuid4().hex[:8], uuid.uuid4().hex[:8],
    uuid.uuid4().hex[:8], uuid.uuid4().hex[:8], uuid.uuid4().hex[:8],
    uuid.uuid4().hex[:8], uuid.uuid4().hex[:8]
)

# Add appStateFields at the end of the file (before the last line if it's a simple value)
lines = yaml_content.splitlines()
if lines[-1].startswith('description:'):
    # Insert before the last line
    lines.insert(-1, app_state_fields)
else:
    # Add at the end
    lines.append(app_state_fields)

# Save the updated YAML
updated_yaml = '\n'.join(lines)
with open('/tmp/app-state-with-vars.yaml', 'w') as f:
    f.write(updated_yaml)

print("\n✅ App state variables added to YAML")
print("Saved to: /tmp/app-state-with-vars.yaml")

# Convert back to base64 for API upload
# First, compress it back to zip
zip_buffer = io.BytesIO()
with zipfile.ZipFile(zip_buffer, 'w', zipfile.ZIP_DEFLATED) as zip_file:
    zip_file.writestr('app-state.yaml', updated_yaml)

zip_data = zip_buffer.getvalue()
updated_b64 = base64.b64encode(zip_data).decode('utf-8')

# Save for upload
upload_data = {
    "projectId": "c-s-c305-capstone-khj14l",
    "fileKey": "app-state",
    "projectYamlBytes": updated_b64
}

with open('/tmp/app-state-upload.json', 'w') as f:
    json.dump(upload_data, f)

print("\n✅ Ready for upload!")
print("Upload data saved to: /tmp/app-state-upload.json")
