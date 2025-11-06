# Manual Page-Level Trigger Wiring Guide

## Overview

This guide documents the ONE-TIME manual steps required to wire custom actions to page-level triggers in FlutterFlow. These triggers (OnPageLoad, OnAuthSuccess) are NOT exposed via the FlutterFlow YAML API and MUST be configured through the FlutterFlow UI.

**Time Required:** 60-90 minutes (one-time setup)
**Frequency:** One-time per page
**Required Access:** FlutterFlow project editor permissions

---

## Prerequisites

- FlutterFlow project: `[FLUTTERFLOW_PROJECT_ID]`
- Custom actions deployed:
  - `initializeUserSession`
  - `checkAndLogRecipeCompletion`
- Project URL: https://app.flutterflow.io/project/[FLUTTERFLOW_PROJECT_ID]

---

## Why Manual Wiring is Necessary

**Technical Limitation:** FlutterFlow's Growth Plan API provides read/write access to 591+ YAML files, but page-level triggers (OnPageLoad, OnAuthSuccess, etc.) are stored in a format that is:
1. Not exposed as separate YAML file keys
2. Not documented in the public API schema
3. Not successfully updatable via the `/updateProjectByYaml` endpoint

**Evidence:** Analysis of 609 YAML files found zero page-level trigger files. All trigger actions are widget-level only (ON_TAP, ON_LONG_PRESS, etc.).

**Automation Research:** Playwright UI automation was evaluated but rejected due to Shadow DOM incompatibility and high maintenance burden.

---

## Target Pages & Triggers

| Page Name | Page ID | Trigger Type | Custom Action | Purpose |
|-----------|---------|--------------|---------------|---------|
| HomePage | `Scaffold_r33su4wm` | On Page Load | `initializeUserSession` | Track app opens |
| GoldenPath | `Scaffold_cc3wywo1` | On Page Load | `initializeUserSession` | Track golden path entry |
| Login/SIGNUPV1 | `Scaffold_mjsj60cb` | On Auth Success | `initializeUserSession` | Track new user sessions |
| RecipeViewPage | `Scaffold_37j5qewi` | Widget OnTap | `checkAndLogRecipeCompletion` | Track recipe completions |

---

## Step-by-Step Instructions

### 1. HomePage - OnPageLoad Trigger

**Time:** 15-20 minutes

1. **Open Project**
   - Navigate to: https://app.flutterflow.io/project/[FLUTTERFLOW_PROJECT_ID]
   - Wait for project to load (~10-15 seconds)

2. **Navigate to HomePage**
   - Click **Pages** panel on the left sidebar
   - Locate and click **HomePage** in the page tree
   - Wait for page canvas to render

3. **Open Actions & Logic Panel**
   - Click on the **Scaffold** (root widget) in the widget tree
   - In the right properties panel, click **Actions & Logic** tab
   - Look for the **Page Lifecycle** section

4. **Add OnPageLoad Action**
   - Click **+ Add Action** button next to "On Page Load"
   - In the action selector dialog:
     - Scroll to **Custom Functions** section
     - Click **Custom Action**
   - Select `initializeUserSession` from the dropdown
   - *(This action has no parameters)*

5. **Save and Verify**
   - Click **Confirm** or **Save** button
   - Verify: You should see `initializeUserSession` listed under "On Page Load"
   - The action node should appear in the action flow diagram

**Verification:**
```
✓ Action Flow shows: On Page Load → initializeUserSession
✓ No error indicators (red icons) in the action flow
✓ Action parameters section is empty (expected)
```

---

### 2. GoldenPath - OnPageLoad Trigger

**Time:** 15-20 minutes

1. **Navigate to GoldenPath Page**
   - In **Pages** panel, click **GoldenPath**
   - Wait for page canvas to render

2. **Open Actions & Logic**
   - Click on the **Scaffold** (root widget)
   - Click **Actions & Logic** tab

3. **Add OnPageLoad Action**
   - Click **+ Add Action** next to "On Page Load"
   - Select **Custom Action** → `initializeUserSession`
   - Click **Confirm**

4. **Save and Verify**
   - Verify action appears in "On Page Load" trigger list
   - Check for no error indicators

**Verification:**
```
✓ Action Flow shows: On Page Load → initializeUserSession
✓ GoldenPath page has identical action configuration to HomePage
```

---

### 3. Login/SIGNUPV1 - OnAuthSuccess Trigger

**Time:** 20-30 minutes

**Note:** This is more complex because it requires finding the authentication widget/component and wiring to its success event.

1. **Navigate to Login Page**
   - In **Pages** panel, locate **SIGNUPV1** or **Login** page
   - Click to open

2. **Locate Authentication Widget**
   - In the widget tree, look for:
     - **LoginButton** widget
     - **FirebaseAuth** component
     - **AuthForm** custom component
   - Click on the authentication trigger widget

3. **Open Actions & Logic**
   - With auth widget selected, click **Actions & Logic** tab
   - Look for **On Tap** or **On Submit** trigger
   - You should see existing Firebase authentication actions

4. **Add Action AFTER Firebase Auth**
   - Scroll to the END of the existing action chain
   - Click **+ Add Action** (add as LAST action in chain)
   - Select **Custom Action** → `initializeUserSession`
   - Click **Confirm**

5. **Order Verification**
   - **Critical:** Ensure action order is:
     1. Firebase Email/Password Sign In
     2. (Optional) Navigate to Home
     3. **initializeUserSession** ← Must be AFTER auth

6. **Save and Verify**
   - Check action flow diagram shows correct sequence
   - Verify no error indicators

**Verification:**
```
✓ Action chain includes initializeUserSession as final action
✓ Action runs AFTER successful Firebase authentication
✓ No conditional logic blocking execution
```

**Alternative Approach (if widget-based wiring is complex):**
If the Login button's action flow is too complex:
1. Add initializeUserSession to the **destination page's OnPageLoad** instead
2. E.g., wire it to HomePage OnPageLoad (already done in Step 1)
3. This achieves the same goal (user session starts after login)

---

### 4. RecipeViewPage - Button OnTap Trigger

**Time:** 20-30 minutes

**Note:** This will be done MANUALLY first to reverse-engineer the YAML schema. In Phase 2, we'll automate similar button additions.

1. **Navigate to RecipeViewPage**
   - In **Pages** panel, click **RecipeViewPage**
   - Wait for page canvas to load

2. **Add "Mark as Complete" Button**
   - Scroll to the bottom of the recipe details section
   - Click **+ Widget** button
   - Search for and select **Button** widget
   - Place it at the bottom of the Column/ListView

3. **Configure Button Properties**
   - Select the new button
   - In **Properties** panel:
     - **Text:** "Mark as Complete"
     - **Button Type:** Filled
     - **Fill Color:** Primary color (theme)
     - **Border Radius:** 8px
     - **Width:** Fill width
     - **Height:** 48px

4. **Add OnTap Action**
   - With button selected, click **Actions & Logic** tab
   - Click **+ Add Action** next to "On Tap"
   - Select **Custom Action** → `checkAndLogRecipeCompletion`

5. **Configure Action Parameters**

   The action requires 6 parameters. Set them as follows:

   | Parameter | Type | Value | Source |
   |-----------|------|-------|--------|
   | `recipeId` | String | Recipe ID | Page Parameter: `recipeId` |
   | `recipeName` | String | Recipe Name | Page Parameter: `recipeName` |
   | `cuisine` | String | Cuisine Type | Page Parameter: `cuisine` |
   | `prepTimeMinutes` | Integer | Prep Time | Page Parameter: `prepTimeMinutes` |
   | `source` | String | "featured" | Literal: "featured" |
   | `completionMethod` | String | "button" | Literal: "button" |

   **Setting Parameters:**
   - For each parameter, click the **Set from Variable** icon
   - Select source type (Page Parameter or Literal)
   - Choose the corresponding value from dropdown

6. **Save and Verify**
   - Click **Confirm** to save action
   - Verify all 6 parameters are filled (no red warnings)
   - Check action flow diagram shows parameter bindings

**Verification:**
```
✓ Button visible at bottom of recipe details
✓ OnTap action: checkAndLogRecipeCompletion
✓ All 6 parameters configured correctly
✓ recipeId parameter bound to page parameter (not hardcoded)
```

---

## Post-Wiring Steps

### Download Updated YAMLs for Schema Analysis

After completing manual wiring, download the updated YAML files to discover the schema:

```bash
cd /home/jpv/Documents/School/school/CSC305PROJECT/CSCSoftwareDevelopment

# Download updated pages
./scripts/download-yaml.sh --file page/id-Scaffold_r33su4wm
./scripts/download-yaml.sh --file page/id-Scaffold_cc3wywo1
./scripts/download-yaml.sh --file page/id-Scaffold_mjsj60cb
./scripts/download-yaml.sh --file page/id-Scaffold_37j5qewi

# Find newly created trigger action files
find flutterflow-yamls/page -name "*.yaml" -path "*/trigger_actions/*" -newer flutterflow-yamls/app-state.yaml

# Inspect button trigger action structure
cat flutterflow-yamls/page/id-Scaffold_37j5qewi/page-widget-tree-outline/node/id-Button*/trigger_actions/id-ON_TAP/action/*.yaml
```

This will reveal the exact YAML schema for custom action references, enabling Phase 2 automation.

---

## Testing & Verification

### Test in FlutterFlow Preview Mode

1. **Test HomePage OnPageLoad:**
   - Click **Run** button in FlutterFlow
   - Open browser console (F12)
   - Navigate to HomePage
   - Check console logs for `initializeUserSession` execution
   - Verify Firebase Analytics event: `session_start`

2. **Test GoldenPath OnPageLoad:**
   - In preview, navigate to GoldenPath page
   - Check console for action execution
   - Verify session tracking continues

3. **Test Login OnAuthSuccess:**
   - In preview, go to Login page
   - Sign in with test credentials
   - After successful auth, check console
   - Verify `initializeUserSession` runs post-auth
   - Check Firestore `user_sessions` collection for new entry

4. **Test Recipe Completion Button:**
   - Navigate to RecipeViewPage in preview
   - Click "Mark as Complete" button
   - Check console logs for `checkAndLogRecipeCompletion` call
   - Verify Firestore `user_recipe_completions` collection updated
   - Check all parameters (recipeId, recipeName, etc.) are correct

### Monitor Firebase Data

```bash
# Check Firebase Analytics (wait 24 hours for data)
# Navigate to: Firebase Console > Analytics > Events
# Look for:
# - session_start (from initializeUserSession)
# - recipe_completed (from checkAndLogRecipeCompletion)

# Check Firestore collections immediately
# Firebase Console > Firestore Database
# Collections to verify:
# - user_sessions (should have new documents)
# - user_recipe_completions (should have completion records)
# - users (should have updated cohort_date, d7_retention_eligible fields)
```

---

## Troubleshooting

### Issue: Custom Action Not Appearing in Dropdown

**Symptom:** `initializeUserSession` or `checkAndLogRecipeCompletion` not visible in Custom Action selector

**Solution:**
1. Verify custom actions were pushed via VS Code Extension
2. In FlutterFlow UI, go to **Custom Code** panel
3. Check **Actions** tab shows both actions
4. If missing, re-push via VS Code:
   ```bash
   cd c_s_c305_capstone
   # Open in VS Code
   # Command Palette: "FlutterFlow: Push to FlutterFlow"
   ```
5. Refresh FlutterFlow browser page

### Issue: Action Has Compilation Errors

**Symptom:** Red error icon next to action in Custom Code panel

**Solution:**
1. Click on the action to view error details
2. Common issues:
   - Missing imports
   - Undefined parameters
   - Type mismatches
3. Fix errors in VS Code, push again

### Issue: Parameters Not Binding Correctly

**Symptom:** RecipeViewPage button shows "Set from Variable" warnings

**Solution:**
1. Verify page parameters exist:
   - Click page Scaffold → Properties → Page Parameters
   - Ensure recipeId, recipeName, cuisine, prepTimeMinutes are defined
2. If missing, add page parameters via UI
3. Re-bind action parameters to page parameters

### Issue: OnAuthSuccess Not Firing

**Symptom:** initializeUserSession doesn't run after login

**Solution:**
1. Check action placement: MUST be AFTER Firebase auth action
2. Verify no conditional logic blocking execution
3. Check Firebase Auth configuration is working
4. Alternative: Move to destination page's OnPageLoad

---

## Time & Effort Summary

| Task | Time (minutes) | Cumulative |
|------|----------------|------------|
| HomePage OnPageLoad | 15-20 | 20 |
| GoldenPath OnPageLoad | 15-20 | 40 |
| Login OnAuthSuccess | 20-30 | 70 |
| RecipeViewPage Button | 20-30 | 100 |
| Testing & Verification | 20-30 | 130 |
| **Total** | **90-130 min** | **2 hours** |

**One-time cost:** This manual wiring is done ONCE per page. Future pages can be automated (for widget-level triggers only).

---

## Next Steps

1. **Complete manual wiring** (this guide) - 2 hours
2. **Download YAMLs** for schema analysis - 15 minutes
3. **Phase 2:** Reverse-engineer custom action YAML format - 2 hours
4. **Phase 3:** Create automation for additional buttons - 4 hours
5. **Phase 4:** Create AutoRunner widget (optional) - 2 hours

---

## Reference

- FlutterFlow Project: https://app.flutterflow.io/project/[FLUTTERFLOW_PROJECT_ID]
- Custom Actions Source: `/home/jpv/Documents/School/school/CSC305PROJECT/CSCSoftwareDevelopment/c_s_c305_capstone/lib/custom_code/actions/`
- Firebase Console: https://console.firebase.google.com/project/[FIREBASE_PROJECT_ID]
- D7 Retention Guide: `docs/D7_RETENTION_METRICS_GUIDE.md`

---

**Last Updated:** 2025-11-05
**Status:** Ready for execution
**Estimated Completion:** 2 hours hands-on time
