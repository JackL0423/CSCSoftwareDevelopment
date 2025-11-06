# D7 Retention Variables - Successfully Added via FlutterFlow API

**Date:** November 4, 2025
**Status:** ✅ Complete
**Impact:** 11 new app state variables ready for retention tracking

---

## Executive Summary

Successfully added 11 D7 retention tracking variables to the GlobalFlavors FlutterFlow project using the Growth Plan API. Discovered and fixed a critical API payload format issue that was preventing uploads from persisting. All scripts now production-ready and shareable with team.

**Key Metric:** 11 variables added programmatically (9 original → 20 total)

---

## Problem Solved

### The Challenge
FlutterFlow's `/v2/updateProjectByYaml` API endpoint was accepting requests and returning `success: true`, but changes were NOT being saved to the project.

### Root Cause
**Wrong payload format** - We were sending base64-encoded ZIP files (like the download format), but uploads require plain YAML strings with a different JSON structure.

### The Fix
Changed from:
```json
{
  "fileName": "app-state",
  "fileContent": "<base64-encoded-zip>"
}
```

To:
```json
{
  "fileKeyToContent": {
    "app-state": "<plain-yaml-string>"
  }
}
```

---

## Variables Added

| Variable Name | Data Type | Persisted | Purpose |
|---------------|-----------|-----------|---------|
| currentRecipeId | String | No | Current recipe being viewed/cooked |
| currentRecipeName | String | No | Name of current recipe |
| currentRecipeCuisine | String | No | Cuisine type of current recipe |
| currentRecipePrepTime | Integer | No | Prep time in minutes |
| recipeStartTime | DateTime | No | When user started current recipe |
| currentSessionId | String | No | Unique ID for current app session |
| sessionStartTime | DateTime | No | When current session started |
| recipesCompletedThisSession | Integer | No | Count of recipes completed |
| **isUserFirstRecipe** | **Boolean** | **Yes** | Track if user completed first recipe |
| **userCohortDate** | **DateTime** | **Yes** | User signup date (cohort analysis) |
| **userTimezone** | **String** | **Yes** | User timezone for analytics |

**Non-persisted:** 8 variables (session/recipe tracking)
**Persisted:** 3 variables (user cohort tracking)

---

## Solution Delivered

### 1. Fixed API Scripts

**`scripts/download-yaml.sh`**
- Defensive field name handling (supports both `projectYamlBytes` and `project_yaml_bytes`)
- Proper ZIP extraction and validation
- Production-ready for team use

**`scripts/add-app-state-variables.sh`**
- End-to-end automation: download → modify → validate → upload
- Correct API payload formats
- Safety checks and confirmations
- Reusable for future variable additions

### 2. Documentation Created

**`scripts/FLUTTERFLOW_API_GUIDE.md`**
- Beginner-friendly guide for teammates
- Copy-paste ready examples
- Common pitfalls explained
- Troubleshooting section

**`docs/archive/2025-11-04-flutterflow-api-work/`**
- Development files archived
- Reference for future debugging

---

## Key Learnings

### API Quirks Discovered

1. **Download ≠ Upload Format**
   - Downloads: base64-encoded ZIP files
   - Uploads: plain YAML strings (NO ZIP, NO base64)

2. **Field Name Inconsistency**
   - Docs say: `projectYamlBytes` (camelCase)
   - API returns: `project_yaml_bytes` (snake_case) *also works*
   - Solution: Support both with `// ` operator in jq

3. **Endpoint Field Names**
   - Download: uses `fileName` parameter
   - Validate: uses `fileKey` + `fileContent`
   - Upload: uses `fileKeyToContent`
   - Each endpoint has its own naming convention!

4. **Branch Limitations**
   - Project APIs do NOT support branch selection
   - All operations target main branch only
   - Must use FlutterFlow UI for branching

5. **Silent Failures**
   - Wrong payload format returns `success: true` but doesn't save
   - No error message, just silently ignored
   - Critical to verify uploads by re-downloading

### What GPT-5 Got Right

✅ Correct workflow: validate before upload
✅ Remove branch parameter (not supported)
✅ Direct piping instead of command substitution
✅ ZIP files encoded as base64 in downloads

### What GPT-5 Got Wrong

❌ Field name: Suggested `projectYamlBytes` but `project_yaml_bytes` is what actually works
❌ Initially: Didn't catch that upload format is completely different from download

**Correction:** After we provided detailed error report, GPT-5 correctly identified the `fileKeyToContent` requirement

---

## Verification

### API Verification
```bash
# Downloaded after upload
curl .../projectYamls?fileName=app-state | ...
# Result: 20 variables (confirmed)
```

### FlutterFlow UI Verification
- ✅ All 20 variables visible in App State page
- ✅ Correct data types (String, Integer, DateTime, Boolean)
- ✅ Persistence flags correctly set (3 persisted, 8 non-persisted)
- ✅ Screenshots confirm upload success

---

## Ready for Implementation

These variables enable D7 retention tracking:

**Session Tracking:**
- Track unique sessions with `currentSessionId` and `sessionStartTime`
- Count completed recipes per session with `recipesCompletedThisSession`

**Recipe Engagement:**
- Monitor current recipe with `currentRecipeId`, `currentRecipeName`, `currentRecipeCuisine`
- Track time spent with `recipeStartTime` and `currentRecipePrepTime`

**Cohort Analysis:**
- Identify new users with `isUserFirstRecipe`
- Group users by signup date with `userCohortDate`
- Normalize time zones with `userTimezone`

**Next Steps:**
1. Implement session initialization logic
2. Add recipe start/complete tracking
3. Set cohort date on first user registration
4. Calculate D7 retention metrics

---

## Team Resources

**For Teammates:**
- 📖 Read: `scripts/FLUTTERFLOW_API_GUIDE.md` - Everything you need to work with FlutterFlow API
- 🔧 Use: `scripts/download-yaml.sh` - Download YAML files
- 🤖 Use: `scripts/add-app-state-variables.sh` - Automated variable addition

**For Reference:**
- 📁 Archive: `docs/archive/2025-11-04-flutterflow-api-work/` - Development files
- 📝 Context: `CLAUDE.md` - Updated with API success info

---

## Timeline

| Time | Activity |
|------|----------|
| Morning | Initial attempt - upload appeared to work but changes didn't persist |
| Mid-day | Created detailed error report, consulted GPT-5 |
| Afternoon | GPT-5 identified correct payload format (`fileKeyToContent`) |
| Evening | Fixed scripts, tested, verified in UI - SUCCESS! |
| Wrap-up | Created documentation and teammate guide |

**Total Time:** ~6 hours (including debugging and documentation)

---

## Success Metrics

- ✅ 11 variables added programmatically
- ✅ 100% upload success rate after fix
- ✅ All variables verified in FlutterFlow UI
- ✅ Scripts production-ready and documented
- ✅ Teammate guide created for knowledge sharing
- ✅ Automation pipeline reusable for future changes

---

## Technical Details

**Project ID:** [FLUTTERFLOW_PROJECT_ID]
**FlutterFlow Plan:** Growth (API-enabled)
**API Version:** v2
**Tools Used:** curl, jq, Python 3, PyYAML, bash
**Authentication:** Bearer token (LEAD API token)

**Corrected API Format:**
```bash
# Download (GET)
curl .../projectYamls?fileName=app-state
→ Returns: base64-encoded ZIP

# Validate (POST)
{
  "projectId": "...",
  "fileKey": "app-state",
  "fileContent": "<yaml-string>"
}

# Upload (POST)
{
  "projectId": "...",
  "fileKeyToContent": {
    "app-state": "<yaml-string>"
  }
}
```

---

## Lessons Learned

1. **Always verify uploads** by re-downloading and checking UI
2. **API documentation may be incomplete** - test assumptions
3. **Support both field naming conventions** (snake_case AND camelCase)
4. **Silent failures are dangerous** - API returning success doesn't guarantee persistence
5. **Validate before upload** - always use validation endpoint first
6. **Document as you go** - saved hours by creating clear guides
7. **GPT-5 is helpful but not infallible** - verify AI recommendations

---

## Future Work

- [ ] Implement D7 retention tracking logic using these variables
- [ ] Add Firebase Analytics integration for retention events
- [ ] Create dashboard for cohort analysis
- [ ] Set up automated D7 retention reports
- [ ] Consider adding D1, D3, D14, D30 retention metrics

---

**Contributors:** Juan Vallejo
**Reviewed:** Verified in FlutterFlow UI
**Status:** Ready for production use

---

**End of Report**
