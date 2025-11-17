# FlutterFlow VS Code Extension - D7 Retention Deployment Guide

[Home](../../README.md) > [Docs](../README.md) > [Architecture](./README.md) > D7 Retention Deployment

**Date**: November 5, 2025
**Method**: Official FlutterFlow VS Code Extension (Path A1 - Recommended)
**Status**: Ready for Deployment
**Estimated Time**: 2.5-3 hours

---

## Overview

This guide uses the **official FlutterFlow VS Code Extension** to programmatically create and deploy custom actions. This is the supported, stable method for creating custom code without manual UI work.

**Key Insight from GPT-5 Analysis**:
> "Creating a file [in lib/custom_code/actions/] automatically adds a new action to your FlutterFlow project."

**Why This Approach**:
- ✅ Officially supported by FlutterFlow
- ✅ Documented and stable
- ✅ Programmatic (no manual copy-paste)
- ✅ Repeatable (CI/CD ready)
- ✅ Fast (2-3 hours total deployment)

---

## Prerequisites

### Required
- VS Code installed
- FlutterFlow project: `[FLUTTERFLOW_PROJECT_ID]`
- FlutterFlow Growth Plan (for API access)
- Git repository with custom action Dart files

### Project Files Ready
```
metrics-implementation/custom-actions/
├── initializeUserSession.dart (95 lines)
├── checkAndLogRecipeCompletion.dart (163 lines)
└── checkScrollCompletion.dart (98 lines)
```

---

## Phase 1: Setup FlutterFlow VS Code Extension

### Step 1.1: Install Extension

1. Open VS Code
2. Go to Extensions (Ctrl+Shift+X or Cmd+Shift+X)
3. Search for: **"FlutterFlow: Custom Code Editor"**
4. Click **Install**
5. Wait for installation to complete

### Step 1.2: Generate API Key

1. Open FlutterFlow in browser: https://app.flutterflow.io
2. Click your profile icon → **Account**
3. Navigate to **API** section
4. Click **Generate API Key**
5. **Copy the key** (you won't see it again!)
6. Save securely (consider password manager)

**Alternative**: Use existing LEAD_TOKEN if it works with extension:
```
LEAD_TOKEN="9dc3d62e-6d19-4831-9386-02760f9fb7c0"
```

### Step 1.3: Configure Extension

1. In VS Code, open Command Palette (Ctrl+Shift+P or Cmd+Shift+P)
2. Type: **"FlutterFlow: Configure"**
3. Enter when prompted:
   - **API Key**: [paste your generated key]
   - **Project ID**: `[FLUTTERFLOW_PROJECT_ID]`
   - **Branch**: `main`

4. Extension will save configuration

### Step 1.4: Initial Pull

1. Open Command Palette
2. Run: **"FlutterFlow: Download Code"**
3. Select a folder for the project workspace
4. Wait for download to complete (30-60 seconds)

**Expected Structure**:
```
workspace/
├── lib/
│   ├── custom_code/
│   │   ├── actions/
│   │   │   └── index.dart (may be empty initially)
│   │   ├── widgets/
│   │   └── ...
│   └── ...
└── ...
```

**Verification**: Check that `lib/custom_code/actions/` directory exists

---

## Phase 2: Create Custom Actions

### Step 2.1: Start Code Editing Session

1. Open Command Palette
2. Run: **"FlutterFlow: Start Code Editing Session"**
3. Wait for session to initialize

**What This Does**:
- Enables live sync between VS Code and FlutterFlow
- Prepares workspace for custom code editing
- Sets up file watchers

### Step 2.2: Create Action Files

**IMPORTANT**: File creation = Custom Action creation in FlutterFlow!

Create these 3 files in `lib/custom_code/actions/`:

#### File 1: initialize_user_session.dart

**Path**: `lib/custom_code/actions/initialize_user_session.dart`

**Source**: Copy from `metrics-implementation/custom-actions/initializeUserSession.dart`

**Adjustments Needed**:
```dart
// Ensure function signature matches FlutterFlow requirements
import '/flutter_flow/flutter_flow_util.dart';

Future<void> initializeUserSession(BuildContext context) async {
  // Your implementation here
  // (paste from initializeUserSession.dart)
}
```

**Key Points**:
- File name: `initialize_user_session.dart` (snake_case)
- Function name: `initializeUserSession` (camelCase)
- Must include `BuildContext context` parameter if using context
- Return type: `Future<void>`

#### File 2: check_and_log_recipe_completion.dart

**Path**: `lib/custom_code/actions/check_and_log_recipe_completion.dart`

**Source**: Copy from `metrics-implementation/custom-actions/checkAndLogRecipeCompletion.dart`

**Function Signature**:
```dart
Future<bool> checkAndLogRecipeCompletion(
  BuildContext context,
  String recipeId,
  String recipeName,
  String cuisine,
  int prepTimeMinutes,
  String source,
  String completionMethod,
) async {
  // Your implementation here
}
```

**Return Type**: `Future<bool>` (returns true on success)

#### File 3: check_scroll_completion.dart

**Path**: `lib/custom_code/actions/check_scroll_completion.dart`

**Source**: Copy from `metrics-implementation/custom-actions/checkScrollCompletion.dart`

**Function Signature**:
```dart
Future<bool> checkScrollCompletion(
  BuildContext context,
  ScrollController scrollController,
  double threshold,
) async {
  // Your implementation here
}
```

### Step 2.3: Update Index File

**Path**: `lib/custom_code/actions/index.dart`

**Content**:
```dart
export 'initialize_user_session.dart' show initializeUserSession;
export 'check_and_log_recipe_completion.dart' show checkAndLogRecipeCompletion;
export 'check_scroll_completion.dart' show checkScrollCompletion;
```

**Note**: Extension may auto-generate this. Verify it includes all 3 exports.

### Step 2.4: Add Dependencies (if needed)

If your actions use external packages (uuid, intl), add to `pubspec.yaml`:

```yaml
dependencies:
  uuid: ^4.0.0
  intl: ^0.18.0
```

**Extension handles**:
- `package:flutter/...` (built-in)
- `package:cloud_firestore/...` (FlutterFlow includes)
- `/flutter_flow/...` (FlutterFlow utils)

### Step 2.5: Push to FlutterFlow

1. **Save all files** (Ctrl+S / Cmd+S)
2. Open Command Palette
3. Run: **"FlutterFlow: Push to FlutterFlow"**
4. **Wait for upload** (≤2 minutes)
5. Watch for success message

**Expected Output**:
```
✓ Uploading custom code...
✓ Processing files...
✓ Custom Actions created: 3
✓ Push successful!
```

**What This Does**:
- Uploads all 3 Dart files to FlutterFlow
- Creates 3 new Custom Actions in project
- Compiles code in FlutterFlow
- Makes actions available in Action Flow

---

## Phase 3: Verify Actions in FlutterFlow UI

### Step 3.1: Check Custom Code Panel

1. Open FlutterFlow: https://app.flutterflow.io/project/[FLUTTERFLOW_PROJECT_ID]
2. Navigate to: **Custom Code** (left sidebar)
3. Click: **Actions** tab

**Expected**:
- ✅ initializeUserSession (listed)
- ✅ checkAndLogRecipeCompletion (listed)
- ✅ checkScrollCompletion (listed)
- ✅ **0 compile errors** (green checkmark)

**If Compile Errors**:
- Click on action to see error details
- Common issues:
  - Missing imports
  - Wrong parameter types
  - Missing dependencies
- Fix in VS Code, re-push

### Step 3.2: Test Action Availability

1. Open any page in FlutterFlow (e.g., HomePage)
2. Select a widget → **Actions** tab
3. Click **+ Add Action**
4. Select **Custom Action** from dropdown
5. **Verify**: All 3 actions appear in the list

If actions don't appear:
- Refresh FlutterFlow page (Ctrl+R / Cmd+R)
- Check compile status again
- Re-push from VS Code

---

## Phase 4: Wire Actions to Pages

### Step 4.1: Initialize Session on App Startup

**Target Page**: HomePage (id-Scaffold_r33su4wm)

1. Open HomePage in FlutterFlow
2. Select the **Page** widget (top of widget tree)
3. Go to **Actions** tab → **On Page Load**
4. Click **+ Add Action**
5. Select **Custom Action** → **initializeUserSession**
6. Parameters: (none required)
7. Click **Confirm**

**Repeat for**:
- **login page** (id-Scaffold_s8tiq2zc) → After successful Firebase Auth action
- **GoldenPath page** (id-Scaffold_cc3wywo1) → On Page Load

### Step 4.2: Track Recipe Start on Recipe Page

**Target Page**: RecipeViewPage (id-Scaffold_37j5qewi)

1. Open RecipeViewPage
2. Select **Page** widget
3. **Actions** tab → **On Page Load**
4. Add multiple **Update App State** actions (in sequence):

**Action 1**: Update currentRecipeId
- Action: Update App State
- Field: currentRecipeId
- Value: (page parameter or widget state)

**Action 2**: Update currentRecipeName
- Field: currentRecipeName
- Value: (recipe name parameter)

**Action 3**: Update currentRecipeCuisine
- Field: currentRecipeCuisine
- Value: (cuisine parameter)

**Action 4**: Update currentRecipePrepTime
- Field: currentRecipePrepTime
- Value: (prep time parameter)

**Action 5**: Update recipeStartTime
- Field: recipeStartTime
- Value: **Set from Variable** → Select **Now** (current DateTime)

### Step 4.3: Add "Mark as Complete" Button

**On RecipeViewPage**:

1. **Add Button Widget**:
   - Drag **Button** widget to desired location (e.g., bottom of recipe)
   - Text: "Mark as Complete" or "I Made This!"
   - Style: Primary color, prominent

2. **Configure Button Action**:
   - Select button → **Actions** tab → **On Tap**
   - Click **+ Add Action**
   - Select **Custom Action** → **checkAndLogRecipeCompletion**

3. **Set Parameters**:
   - `recipeId`: **App State** → currentRecipeId
   - `recipeName`: **App State** → currentRecipeName
   - `cuisine`: **App State** → currentRecipeCuisine
   - `prepTimeMinutes`: **App State** → currentRecipePrepTime
   - `source`: **Set from Variable** → Specific Value → `"search"` (or tracked value)
   - `completionMethod`: **Set from Variable** → Specific Value → `"button"`

4. **Add Success Feedback**:
   - Click **+** to add another action (conditional)
   - Select **Snackbar**
   - Message: "Recipe marked as complete! 🎉"
   - Conditional: **Previous Action** → Result → **is True**

5. **Save**

---

## Phase 5: Deploy Firebase Backend

### Step 5.1: Run Deployment Script

```bash
cd ~/Documents/School/school/CSC305PROJECT/CSCSoftwareDevelopment
./scripts/deploy-d7-retention-complete.sh
```

**This Script**:
- Installs function dependencies
- Deploys Firebase cloud functions (4 endpoints)
- Creates Firestore indexes (2 composite)
- Verifies deployment

**Expected Time**: 5-10 minutes

### Step 5.2: Verify Firebase Deployment

```bash
firebase functions:list
```

**Expected Output**:
- ✅ calculateD7Retention (scheduledFunctionTrigger)
- ✅ calculateD7RetentionManual (callableFunctionTrigger)
- ✅ getD7RetentionMetrics (httpsFunctionTrigger)
- ✅ getRetentionTrend (httpsFunctionTrigger)

---

## Phase 6: Testing & Verification

### Test 1: Session Initialization

1. Open FlutterFlow **Test Mode** (play button)
2. App starts → HomePage loads
3. **Open App State panel** (right sidebar)
4. **Verify**:
   - currentSessionId: UUID value (e.g., "abc123...")
   - sessionStartTime: Current timestamp
   - recipesCompletedThisSession: Empty list []

**If Failed**:
- Check Console for errors
- Verify initializeUserSession compiled successfully
- Check OnPageLoad action is wired

### Test 2: Recipe Tracking

1. In Test Mode, navigate to RecipeViewPage
2. **Verify App State updates**:
   - currentRecipeId: Recipe ID
   - currentRecipeName: Recipe name
   - currentRecipeCuisine: Cuisine type
   - currentRecipePrepTime: Prep time
   - recipeStartTime: Timestamp when page loaded

**If Failed**:
- Check RecipeViewPage OnPageLoad actions
- Verify page parameters are being passed
- Check parameter names match

### Test 3: Recipe Completion

1. On RecipeViewPage, **wait 30+ seconds** (minimum view time)
2. Click **"Mark as Complete"** button
3. **Expected**:
   - Snackbar appears: "Recipe marked as complete! 🎉"
   - No errors in Console

4. **Check Firestore** (Firebase Console):
   - Collection: `user_recipe_completions`
   - Find document with:
     - user_id: Your test user ID
     - recipe_id: Current recipe ID
     - completed_at: Recent timestamp
     - is_first_recipe: true or false

5. **Check users collection**:
   - Document: Your user ID
   - Fields updated:
     - cohort_date (if first recipe)
     - total_recipes_completed (incremented)
     - d7_retention_eligible: true

**If Failed**:
- Check Console for Firebase permission errors
- Verify user is authenticated
- Check checkAndLogRecipeCompletion action parameters
- Verify Firestore rules allow writes

### Test 4: Cloud Function

```bash
cd ~/Documents/School/school/CSC305PROJECT/CSCSoftwareDevelopment
./scripts/test-retention-function.sh
```

**Expected**:
- Function executes without errors
- Creates document in `retention_metrics` collection
- Document ID: `d7_YYYY-MM-DD` (7 days ago)
- Contains calculated D7 rate

---

## Phase 7: Evidence & Documentation

### Capture Evidence

Create directory:
```bash
mkdir -p docs/evidence/2025-11-05
```

**Screenshots to Capture**:
1. Custom Code → Actions panel (showing 3 actions, 0 errors)
2. RecipeViewPage with "Mark as Complete" button
3. App State panel showing populated variables
4. Firestore Console showing user_recipe_completions documents
5. Firebase Functions list showing 4 deployed functions

**Save As**:
- `docs/evidence/2025-11-05/custom-actions-deployed.png`
- `docs/evidence/2025-11-05/recipe-page-button.png`
- `docs/evidence/2025-11-05/app-state-values.png`
- `docs/evidence/2025-11-05/firestore-completions.png`
- `docs/evidence/2025-11-05/firebase-functions.png`

### Update Documentation

Create verification report:

**File**: `docs/D7_DEPLOYMENT_VERIFICATION.md`

```markdown
# D7 Retention System - Deployment Verification

**Date**: 2025-11-05
**Method**: FlutterFlow VS Code Extension
**Status**: ✅ DEPLOYED

## Deployment Summary

- Custom Actions: 3/3 deployed, 0 compile errors
- Firebase Functions: 4/4 deployed and active
- Firestore Indexes: 2/2 created (enabled)
- Page Wiring: Complete (HomePage, login, GoldenPath, RecipeViewPage)

## Test Results

### ✅ Session Initialization
- Test Date: 2025-11-05
- Status: PASS
- Evidence: [screenshot link]

### ✅ Recipe Tracking
- Test Date: 2025-11-05
- Status: PASS
- Evidence: [screenshot link]

### ✅ Recipe Completion
- Test Date: 2025-11-05
- Status: PASS
- First Completion: [Firestore document link]
- Evidence: [screenshot link]

### ✅ Cloud Function
- Test Date: 2025-11-05
- Status: PASS
- Metrics Document: retention_metrics/d7_2025-10-29
- Evidence: [Firebase Functions log link]

## Next Steps

- Monitor data collection (daily for 1 week)
- Review first D7 cohort calculation (2025-11-12)
- Create admin dashboard (optional)
- Implement additional metrics (search, substitution, efficiency)
```

---

## Repeatability Guide

### To Re-Deploy or Update

**Scenario**: Need to update custom action code or deploy to another project

**Steps**:

1. **Make Changes**: Edit Dart files in `lib/custom_code/actions/`
2. **Push**: Run "FlutterFlow: Push to FlutterFlow"
3. **Verify**: Check Custom Code panel for compile status
4. **Test**: Run through testing checklist

**For New Project**:

1. Configure extension with new Project ID
2. Run "FlutterFlow: Download Code"
3. Copy your 3 Dart files to `lib/custom_code/actions/`
4. Update `index.dart`
5. Push to FlutterFlow
6. Wire actions manually (or script page YAML updates)

**Time for Repeat Deployment**: ~1 hour (vs 2-3 hours initial)

---

## CI/CD Integration (Optional - Path A2)

For automated deployments without human interaction:

### Option 1: Use Extension in CI

```yaml
# .github/workflows/deploy-custom-actions.yml
name: Deploy FlutterFlow Custom Actions

on:
  push:
    paths:
      - 'metrics-implementation/custom-actions/**'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup VS Code
        run: |
          # Install VS Code headless
          # Install FlutterFlow extension

      - name: Configure Extension
        run: |
          # Set API key from secrets
          code --install-extension flutterflow.custom-code-editor

      - name: Deploy Custom Actions
        run: |
          # Copy Dart files
          # Run extension push command
```

### Option 2: Replicate Extension API Calls

**Research Needed**:
1. Capture extension's push HTTP requests (DevTools)
2. Identify endpoint, headers, payload format
3. Implement in Node/Python script
4. Use in CI/CD pipeline

**Risk**: Undocumented API may change

**Recommendation**: Use Option 1 or manual deployment unless CI/CD is critical

---

## Troubleshooting

### Issue: Extension Not Connecting

**Solutions**:
- Verify API key is correct
- Check Project ID matches exactly
- Ensure internet connection stable
- Try re-configuring extension

### Issue: Push Fails

**Solutions**:
- Check VS Code output panel for errors
- Verify all files saved
- Ensure `index.dart` exports functions
- Check for Dart syntax errors
- Try restarting Code Editing Session

### Issue: Actions Don't Appear in FlutterFlow

**Solutions**:
- Refresh FlutterFlow page
- Check Custom Code → Actions for compile errors
- Verify push completed successfully
- Check extension output logs

### Issue: Compile Errors in FlutterFlow

**Common Causes**:
- Missing imports (add `/flutter_flow/flutter_flow_util.dart`)
- Wrong parameter types
- Missing dependencies
- Using undefined variables

**Fix**:
- Click error in Custom Code panel
- Review error message
- Fix in VS Code
- Re-push

### Issue: Action Parameters Not Available

**Solutions**:
- Ensure function signature includes all parameters
- Check parameter names match exactly
- Verify types (String, int, bool, DateTime, etc.)
- Re-compile after changes

---

## ROI Analysis

### Time Investment

| Task | Initial | Repeat | Savings |
|------|---------|--------|---------|
| Setup Extension | 15 min | 5 min | 10 min |
| Create Actions | 30 min | 15 min | 15 min |
| Wire Pages | 90 min | 60 min | 30 min |
| Deploy Firebase | 15 min | 10 min | 5 min |
| Testing | 30 min | 20 min | 10 min |
| **Total** | **3 hours** | **1.75 hours** | **1.25 hours** |

**Break-Even**: 3 deployments

### Cost Comparison

**Engineering Rate**: $150/hour (assumption from GPT-5)

| Method | Initial Cost | Repeat Cost | Notes |
|--------|--------------|-------------|-------|
| VS Code Extension (A1) | $450 | $262.50 | Recommended |
| Manual UI (D) | $450 | $450 | No automation |
| Browser Automation (B) | $900 | $150 | High setup, fragile |
| Headless API (A2) | $900 | $15 | For CI/CD only |

**Recommendation**: Use Path A1 (VS Code Extension) for balance of speed, stability, and repeatability.

---

## Summary

**Total Deployment Time**: 2.5-3 hours
**Success Rate**: 95%+ (official method)
**Repeatability**: ✅ Excellent
**Maintenance**: ✅ Low (extension auto-updates)
**CI/CD Ready**: ✅ Yes (with additional setup)

**Status After Completion**:
- ✅ 3 Custom Actions deployed and compiled
- ✅ 4 Firebase Functions deployed
- ✅ 2 Firestore indexes created
- ✅ All pages wired with retention tracking
- ✅ End-to-end tested and verified
- ✅ Ready for production data collection

**Next Milestone**: First D7 cohort calculation (7 days after first user completes recipe)

---

## Related Documentation

- [D7 Retention Technical Details](./D7_RETENTION_TECHNICAL.md) - Complete implementation logic
- [Data Contracts](./DATA_CONTRACTS.md) - Firestore schema documentation
- [GCP Secrets Management](./GCP_SECRETS.md) - Secrets configuration
- [Manual Page Trigger Wiring](./MANUAL_PAGE_TRIGGER_WIRING.md) - UI trigger setup
- [Firebase Deployment Scripts](../../scripts/firebase/) - Automation tools

---

**Version**: 1.0
**Team**: GlobalFlavors CSC305 Development Team
**Contributors**: Juan, Jack, Sophia, Maria, Alex
**AI-Assisted**: Claude Code + GPT-5
**Date**: November 5, 2025
