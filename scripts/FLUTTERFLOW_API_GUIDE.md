# FlutterFlow API Guide - YAML Download & Upload

**Quick Start for Teammates**

This guide shows you how to programmatically download and upload FlutterFlow project YAML files using the Growth Plan API.

---

## Prerequisites

- FlutterFlow Growth Plan (required for API access)
- Project ID: `[FLUTTERFLOW_PROJECT_ID]`
- LEAD API Token: (stored in GCP Secret Manager as `FLUTTERFLOW_LEAD_API_TOKEN`)
- Tools: `curl`, `jq`, `base64`, `unzip`

---

## Quick Start (2 Commands)

```bash
# 1. Download a YAML file
./scripts/download-yaml.sh --file app-state

# 2. Upload changes (use add-app-state-variables.sh for automated workflow)
./scripts/add-app-state-variables.sh
```

---

## Download YAML Files

### Using Our Script (Recommended)

```bash
# Download specific file
./scripts/download-yaml.sh --file app-state

# Downloaded files go to: flutterflow-yamls/
```

### Manual Download (Understanding the API)

```bash
TOKEN="your-lead-api-token"
PROJECT_ID="[FLUTTERFLOW_PROJECT_ID]"

curl -sS "https://api.flutterflow.io/v2/projectYamls?projectId=${PROJECT_ID}&fileName=app-state" \
  -H "Authorization: Bearer ${TOKEN}" \
| jq -r '.value.projectYamlBytes // .value.project_yaml_bytes' \
| tr -d '\n' \
| base64 --decode > app-state.zip

# Extract YAML from ZIP
unzip -p app-state.zip app-state.yaml > app-state.yaml
```

**Key Points:**
- Downloads return **base64-encoded ZIP files**
- Field name: `projectYamlBytes` OR `project_yaml_bytes` (both work)
- Always extract from ZIP before editing

---

## Upload YAML Changes

### Using Our Script (Recommended)

```bash
# Automated workflow: download → modify → validate → upload
./scripts/add-app-state-variables.sh
```

This script will:
1. Download current YAML
2. Add your changes
3. Validate with FlutterFlow API
4. Ask for confirmation
5. Upload to FlutterFlow

### Manual Upload (Understanding the API)

**IMPORTANT:** Upload format is DIFFERENT from download format!

```bash
TOKEN="your-lead-api-token"
PROJECT_ID="[FLUTTERFLOW_PROJECT_ID]"

# Step 1: Convert YAML to JSON string
YAML_STRING=$(jq -Rs . app-state.yaml)

# Step 2: Validate FIRST (always!)
curl -sS -X POST "https://api.flutterflow.io/v2/validateProjectYaml" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"projectId\":\"${PROJECT_ID}\",\"fileKey\":\"app-state\",\"fileContent\":${YAML_STRING}}"

# Step 3: Upload (if validation passed)
curl -sS -X POST "https://api.flutterflow.io/v2/updateProjectByYaml" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"projectId\":\"${PROJECT_ID}\",\"fileKeyToContent\":{\"app-state\":${YAML_STRING}}}"
```

**Key Points:**
- Uploads require **plain YAML string** (NOT base64, NOT ZIP!)
- Use `fileKeyToContent` for upload (NOT `fileName` or `fileContent`)
- Use `fileKey` for validation (NOT `fileName`)
- ALWAYS validate before uploading

---

## Common Pitfalls (What NOT to Do)

### ❌ WRONG: Uploading base64 ZIP

```bash
# This will return success but NOT save changes!
YAML_BASE64=$(cat app-state.zip | base64 -w 0)
curl ... -d '{"fileName":"app-state","fileContent":"'$YAML_BASE64'"}'
```

### ✅ RIGHT: Uploading plain YAML string

```bash
# This actually works!
YAML_STRING=$(jq -Rs . app-state.yaml)
curl ... -d '{"fileKeyToContent":{"app-state":'$YAML_STRING'}}'
```

### ❌ WRONG: Using wrong field names

```bash
# Validate with fileName (doesn't work)
-d '{"fileName":"app-state", ...}'  # WRONG

# Upload with fileName (doesn't work)
-d '{"fileName":"app-state", "fileContent": ...}'  # WRONG
```

### ✅ RIGHT: Using correct field names

```bash
# Validate with fileKey
-d '{"fileKey":"app-state", "fileContent": ...}'  # CORRECT

# Upload with fileKeyToContent
-d '{"fileKeyToContent":{"app-state": ...}}'  # CORRECT
```

---

## API Endpoints Quick Reference

| Operation | Endpoint | Method | Key Fields |
|-----------|----------|--------|------------|
| List Files | `/v2/listPartitionedFileNames` | GET | `projectId` |
| Download | `/v2/projectYamls` | GET | `projectId`, `fileName` |
| Validate | `/v2/validateProjectYaml` | POST | `projectId`, `fileKey`, `fileContent` |
| Upload | `/v2/updateProjectByYaml` | POST | `projectId`, `fileKeyToContent` |

---

## Troubleshooting

### "Upload returns success but changes don't appear"

**Cause:** Wrong payload format (using `fileName` instead of `fileKeyToContent`)

**Fix:** Use `fileKeyToContent` with plain YAML string:
```bash
YAML_STRING=$(jq -Rs . your-file.yaml)
curl ... -d '{"projectId":"...","fileKeyToContent":{"app-state":'$YAML_STRING'}}'
```

### "Download returns truncated/corrupt data"

**Cause:** Field name casing or piping issues

**Fix:** Use defensive field access:
```bash
jq -r '.value.projectYamlBytes // .value.project_yaml_bytes'
```

### "Validation fails with 'invalid YAML'"

**Cause:** YAML syntax error or incorrect escaping

**Fix:**
1. Check YAML syntax: `yamllint your-file.yaml`
2. Use `jq -Rs .` to properly escape for JSON
3. Review API error message for specific issue

---

## Advanced: Field Naming Quirks

FlutterFlow's API uses mixed naming conventions:

| Context | Field Name | Format |
|---------|-----------|--------|
| Download response | `projectYamlBytes` OR `project_yaml_bytes` | Both work |
| Validate request | `fileKey`, `fileContent` | camelCase |
| Upload request | `fileKeyToContent` | camelCase |
| Download param | `fileName` | camelCase |

**Best Practice:** Support both snake_case and camelCase for downloads:
```bash
jq -r '.value.projectYamlBytes // .value.project_yaml_bytes'
```

---

## Branch Limitations

**IMPORTANT:** The Project APIs do NOT support branch selection.

- All operations target the **main/default branch only**
- No `branch` parameter exists in these endpoints
- To work on specific branches, use FlutterFlow UI for branching/merging

---

## Example: Adding a Variable to App State

```bash
# 1. Download current app-state
./scripts/download-yaml.sh --file app-state

# 2. Edit the YAML
nano flutterflow-yamls/app-state.yaml

# Add your variable following the existing format:
#  - parameter:
#      identifier:
#        name: myNewVariable
#        key: abc123de
#      dataType:
#        scalarType: String
#      description: "My new variable"
#    persisted: false

# 3. Validate
YAML_STRING=$(jq -Rs . flutterflow-yamls/app-state.yaml)
curl -sS -X POST "https://api.flutterflow.io/v2/validateProjectYaml" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"projectId\":\"[FLUTTERFLOW_PROJECT_ID]\",\"fileKey\":\"app-state\",\"fileContent\":${YAML_STRING}}"

# 4. Upload (if validation passed)
curl -sS -X POST "https://api.flutterflow.io/v2/updateProjectByYaml" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"projectId\":\"[FLUTTERFLOW_PROJECT_ID]\",\"fileKeyToContent\":{\"app-state\":${YAML_STRING}}}"

# 5. Verify in FlutterFlow UI
# Open https://app.flutterflow.io/project/[FLUTTERFLOW_PROJECT_ID]
# Go to App State → Check for your variable
```

---

## Available Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| `download-yaml.sh` | Download YAML files | `./scripts/download-yaml.sh --file app-state` |
| `add-app-state-variables.sh` | Complete automation for adding variables | `./scripts/add-app-state-variables.sh` |

---

## Getting Help

- FlutterFlow API Docs: https://api.flutterflow.io
- Team Lead: Jack Light ([REDACTED]@example.edu)
- FlutterFlow Support: support@flutterflow.io

---

## Success Story

**November 4, 2025:** Successfully added 11 D7 retention tracking variables to FlutterFlow using these scripts, after discovering the correct upload payload format.

**Key Learning:** Upload API silently fails if you use wrong payload format. Always use `fileKeyToContent` with plain YAML string!
