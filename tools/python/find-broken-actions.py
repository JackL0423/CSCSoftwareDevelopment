#!/usr/bin/env python3
"""
Find and fix broken actions in FlutterFlow YAML files
"""
import requests
import base64
import zipfile
import io
import json

API_BASE = "https://api.flutterflow.io/v2"
# TODO: Get token from GCP Secret Manager or environment variable
# TOKEN = os.getenv("FLUTTERFLOW_API_TOKEN") or subprocess.check_output([
#     "gcloud", "secrets", "versions", "access", "latest",
#     "--secret=FLUTTERFLOW_LEAD_API_TOKEN",
#     "--project=csc305project-475802"
# ]).decode().strip()
TOKEN = "[GET_FROM_GCP_SECRET_MANAGER]"
PROJECT_ID = "c-s-c305-capstone-khj14l"

headers = {"Authorization": f"Bearer {TOKEN}"}

# Broken fields to search for
broken_fields = ["userTags", "dietaryTags", "prefTags", "dietTags"]

print("🔍 Searching for broken field references in FlutterFlow project...\n")

# Get list of all files
response = requests.get(
    f"{API_BASE}/listPartitionedFileNames",
    params={"projectId": PROJECT_ID},
    headers=headers
)

file_list = response.json()['value']['file_names']
print(f"Total files to search: {len(file_list)}\n")

# Focus on action files
action_files = [f for f in file_list if 'action' in f or 'page' in f.split('/')[-1]]
print(f"Searching {len(action_files)} action/page files...\n")

found_issues = []

for i, file_key in enumerate(action_files):
    if i % 50 == 0:
        print(f"Progress: {i}/{len(action_files)} files checked...")

    try:
        # Download YAML
        response = requests.get(
            f"{API_BASE}/projectYamls",
            params={"projectId": PROJECT_ID, "fileKey": file_key},
            headers=headers
        )

        if not response.ok:
            continue

        data = response.json()
        if not data.get('success'):
            continue

        yaml_b64 = data['value']['project_yaml_bytes']
        yaml_bytes = base64.b64decode(yaml_b64)

        # Try to unzip
        try:
            with zipfile.ZipFile(io.BytesIO(yaml_bytes), 'r') as zf:
                yaml_content = zf.read(zf.namelist()[0]).decode('utf-8')
        except:
            yaml_content = yaml_bytes.decode('utf-8')

        # Check for broken fields
        for field in broken_fields:
            if field in yaml_content:
                found_issues.append({
                    'file': file_key,
                    'field': field,
                    'content_preview': yaml_content[:500]
                })
                print(f"✗ Found '{field}' in: {file_key}")
                break

    except Exception as e:
        pass

print(f"\n{'='*60}")
print(f"Found {len(found_issues)} files with broken field references")
print(f"{'='*60}\n")

for issue in found_issues:
    print(f"File: {issue['file']}")
    print(f"Field: {issue['field']}")
    print(f"-" * 60)

# Save results
with open('/tmp/broken-actions.json', 'w') as f:
    json.dump(found_issues, f, indent=2)

print(f"\n📝 Detailed results saved to: /tmp/broken-actions.json")
