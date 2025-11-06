# FlutterFlow API Upload Issue Report

**Date:** November 4, 2025
**Project ID:** [FLUTTERFLOW_PROJECT_ID]
**Plan:** Growth Plan (API access enabled)
**Issue:** updateProjectByYaml endpoint returns success but doesn't persist changes

---

## Problem Summary

The `/v2/updateProjectByYaml` API endpoint accepts YAML updates and returns `{"success": true}`, but the changes are **NOT persisted** to the FlutterFlow project.

### Evidence

1. **Upload API Response:**
   ```json
   {
     "success": true,
     "reason": null,
     "value": ""
   }
   ```

2. **Verification Download Shows NO Changes:**
   - Downloaded app-state.yaml immediately after "successful" upload
   - Still contains only original 9 variables
   - None of the 11 new variables are present
   - File is identical to pre-upload state

3. **FlutterFlow UI Confirmation:**
   - Checked App State page in FlutterFlow UI
   - Only 9 original variables visible
   - No new retention variables present

---

## API Calls Used

### 1. Validation (WORKS)

**Endpoint:** `POST /v2/validateProjectYaml`

**Request:**
```json
{
  "projectId": "[FLUTTERFLOW_PROJECT_ID]",
  "fileName": "app-state",
  "fileContent": "<base64-encoded-zip>"
}
```

**Response:**
```json
{
  "success": true,
  "reason": null,
  "value": ""
}
```

✅ **Result:** Validation works correctly - detects valid/invalid YAML

---

### 2. Upload (BROKEN - Returns success but doesn't save)

**Endpoint:** `POST /v2/updateProjectByYaml`

**Request:**
```json
{
  "projectId": "[FLUTTERFLOW_PROJECT_ID]",
  "fileName": "app-state",
  "fileContent": "<base64-encoded-zip>"
}
```

**Response:**
```json
{
  "success": true,
  "reason": null,
  "value": ""
}
```

❌ **Result:** Returns success but changes are NOT saved to FlutterFlow

---

### 3. Download (WORKS)

**Endpoint:** `GET /v2/projectYamls?projectId=[FLUTTERFLOW_PROJECT_ID]&fileName=app-state`

**Response:**
```json
{
  "success": true,
  "reason": null,
  "value": {
    "version_info": {
      "partitioner_version": 7,
      "project_schema_fingerprint": "7187d822b3f49f947ca130c043831db422c37c53"
    },
    "project_yaml_bytes": "<base64-encoded-zip>"
  }
}
```

✅ **Result:** Download works correctly

---

## Field Naming Discoveries

### GPT-5's Previous Guidance Was Partially Wrong

**GPT-5 Recommended (INCORRECT):**
- Field name: `projectYamlBytes` (camelCase)
- Result: Returns null/0 bytes

**Actually Correct:**
- Field name: `project_yaml_bytes` (snake_case)
- Result: Returns valid ZIP data

**API Uses Mixed Conventions:**
- Download response: `.value.project_yaml_bytes` (snake_case) ✅
- Upload request: `fileContent` (camelCase) ❓
- Parameter name: `fileName` (camelCase) ✅

---

## Questions for GPT-5 / FlutterFlow Support

### 1. Upload Endpoint
**Q:** Is `/v2/updateProjectByYaml` the correct endpoint for uploading YAML changes on Growth Plan?

**Alternative possibilities:**
- Different endpoint name?
- Different HTTP method (PUT instead of POST)?
- Additional required parameters?

### 2. Payload Format
**Q:** What is the correct JSON payload format for uploading YAML?

**Tried:**
```json
{
  "projectId": "[FLUTTERFLOW_PROJECT_ID]",
  "fileName": "app-state",
  "fileContent": "<base64>"
}
```

**Should it be:**
- `fileContent` or `project_yaml_bytes` or `projectYamlBytes`?
- `fileName` or `fileKey`?
- Any additional fields required?

### 3. Branch Support
**Q:** How do we specify which branch to upload to?

**Current behavior:** No branch parameter used, appears to target... nothing?

**Need:**
- How to upload to specific branch via API?
- If branch not supported, how to work with main branch via API?

### 4. Authorization
**Q:** Does the LEAD token have the correct permissions for YAML uploads?

**Current token:** `[REDACTED]`

**Confirmed working for:**
- ✅ Download YAML
- ✅ Validate YAML
- ❌ Upload YAML

### 5. API Documentation
**Q:** Where is the complete, accurate API documentation for Growth Plan features?

**Need:**
- Full list of available endpoints
- Request/response schemas
- Example curl commands
- Error codes and meanings

---

## What We've Confirmed Works

1. ✅ **Authentication:** LEAD token works for read operations
2. ✅ **Download:** Can successfully download YAML files as ZIP → base64
3. ✅ **Validation:** Can validate YAML changes before upload
4. ✅ **YAML Modification:** Python script successfully adds variables to YAML
5. ✅ **Field Names:** `project_yaml_bytes` (snake_case) works for downloads

---

## What's Broken

1. ❌ **Upload:** `/v2/updateProjectByYaml` doesn't persist changes
2. ❌ **Branch Support:** No way to specify branch in API calls
3. ❌ **Documentation:** No clear API docs for upload operations

---

## Data Details

### Original YAML
- **Lines:** 74
- **Variables:** 9
- **File size:** ~4KB

### Modified YAML
- **Lines:** 163
- **Variables:** 20 (9 original + 11 new)
- **File size:** ~7.6KB
- **Changes:** Added 11 retention tracking variables

### New Variables to Add
```yaml
# Non-persisted (8)
- currentRecipeId (String)
- currentRecipeName (String)
- currentRecipeCuisine (String)
- currentRecipePrepTime (Integer)
- recipeStartTime (DateTime)
- currentSessionId (String)
- sessionStartTime (DateTime)
- recipesCompletedThisSession (Integer)

# Persisted (3)
- isUserFirstRecipe (Boolean)
- userCohortDate (DateTime)
- userTimezone (String)
```

---

## Files Available for Review

All files saved to: `/tmp/`

1. **app-state-modified.yaml** - Modified YAML with 11 new variables
2. **app-state-modified.zip** - ZIP file sent to API
3. **verify-app-state.yaml** - Current state from FlutterFlow (shows upload failed)
4. **raw-api-response.json** - Raw API response showing field structure

---

## Expected Behavior

When we POST to `/v2/updateProjectByYaml` with valid YAML:

**Expected:**
1. API validates the YAML
2. API saves changes to FlutterFlow project
3. Changes visible in FlutterFlow UI immediately
4. Changes persist across sessions
5. Returns success: true

**Actual:**
1. ✅ API appears to validate (no errors)
2. ❌ API does NOT save changes
3. ❌ Changes NOT visible in UI
4. ❌ No persistence
5. ✅ Returns success: true (misleading!)

---

## Request for GPT-5

Please provide:

1. **Correct upload endpoint and payload format** for Growth Plan
2. **How to specify branch** when uploading via API
3. **Why validation works but upload doesn't** despite both returning success
4. **Complete API documentation** or link to official docs
5. **Alternative approach** if programmatic YAML upload isn't supported

We have a working download + validation pipeline but cannot complete the workflow without a functional upload mechanism.

---

## Technical Environment

- **FlutterFlow Plan:** Growth (paid, API-enabled)
- **Project ID:** [FLUTTERFLOW_PROJECT_ID]
- **Auth Method:** Bearer token (LEAD API token)
- **Tools:** curl, jq, Python 3, PyYAML
- **Verified:** All request/response JSON is valid
- **Network:** All API calls succeed (HTTP 200), no network errors

---

## Urgency

**High** - This is blocking automated FlutterFlow workflow development. Manual UI entry of 11 variables is inefficient and defeats the purpose of the Growth Plan's API access.

We've successfully:
- ✅ Fixed GPT-5's previous incorrect guidance about field names
- ✅ Built complete automation pipeline
- ✅ Validated all YAML changes
- ⏸️ **Blocked at upload step** due to API not persisting changes

---

**End of Report**
