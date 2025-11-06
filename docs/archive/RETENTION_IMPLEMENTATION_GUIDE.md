# D7 Retention Metric - Implementation Guide

**Last Updated**: November 4, 2025
**Status**: Ready for FlutterFlow Deployment
**Prerequisites**: App State variables configured, data types fixed

---

## Table of Contents

1. [Phase 1: Deploy Custom Actions to FlutterFlow](#phase-1-deploy-custom-actions-to-flutterflow)
2. [Phase 2: Wire Actions to App Pages](#phase-2-wire-actions-to-app-pages)
3. [Phase 3: Deploy Firebase Cloud Function](#phase-3-deploy-firebase-cloud-function)
4. [Phase 4: Create Firestore Indexes](#phase-4-create-firestore-indexes)
5. [Phase 5: Testing & Verification](#phase-5-testing--verification)

---

## Phase 1: Deploy Custom Actions to FlutterFlow

### Overview

Deploy 3 custom Dart actions to FlutterFlow that handle session tracking and recipe completion logging.

### Custom Action 1: initializeUserSession

**Purpose**: Initialize session tracking when app starts or user logs in

**Steps:**

1. **Open FlutterFlow Project**
   - Navigate to https://app.flutterflow.io
   - Open project: `c-s-c305-capstone-khj14l` (GlobalFlavors)

2. **Create Custom Action**
   - Click **Custom Code** in left sidebar
   - Select **Actions** tab
   - Click **+ Add Action**
   - Name: `initializeUserSession`

3. **Copy Action Code**
   - Open local file: `metrics-implementation/custom-actions/initializeUserSession.dart`
   - Copy ENTIRE file contents (95 lines)
   - Paste into FlutterFlow code editor

4. **Configure Action Settings**
   - **Return Type**: `Future<void>`
   - **Parameters**: None
   - **Description**: "Initialize user session tracking and set cohort data"

5. **Add Dependencies (if not already present)**
   - Click **Pub Dependency** button
   - Add: `uuid: ^4.0.0` (for UUID generation)
   - Add: `intl: ^0.18.0` (for date formatting)

6. **Save Action**
   - Click **Save** button
   - Wait for compilation to complete
   - Verify no errors in bottom panel

### Custom Action 2: checkAndLogRecipeCompletion

**Purpose**: Main completion tracking - logs recipe completions to Firestore and Analytics

**Steps:**

1. **Create Custom Action**
   - In Custom Code > Actions tab
   - Click **+ Add Action**
   - Name: `checkAndLogRecipeCompletion`

2. **Copy Action Code**
   - Open local file: `metrics-implementation/custom-actions/checkAndLogRecipeCompletion.dart`
   - Copy ENTIRE file contents (163 lines)
   - Paste into FlutterFlow code editor

3. **Configure Action Settings**
   - **Return Type**: `Future<bool>`
   - **Parameters**:
     - `recipeId` (String, required)
     - `recipeName` (String, required)
     - `cuisine` (String, required)
     - `prepTimeMinutes` (int, required)
     - `source` (String, required) - values: "search", "featured", "recommended"
     - `completionMethod` (String, required) - values: "button", "scroll"
   - **Description**: "Log recipe completion to Firestore and check if first recipe"

4. **Add Dependencies**
   - Add: `uuid: ^4.0.0`
   - Add: `intl: ^0.18.0`

5. **Save Action**
   - Click **Save**
   - Wait for compilation
   - Verify no errors

### Custom Action 3: checkScrollCompletion

**Purpose**: Detect when user scrolls 90% through recipe page (for future use)

**Steps:**

1. **Create Custom Action**
   - In Custom Code > Actions tab
   - Click **+ Add Action**
   - Name: `checkScrollCompletion`

2. **Copy Action Code**
   - Open local file: `metrics-implementation/custom-actions/checkScrollCompletion.dart`
   - Copy ENTIRE file contents (98 lines)
   - Paste into FlutterFlow code editor

3. **Configure Action Settings**
   - **Return Type**: `Future<bool>`
   - **Parameters**:
     - `scrollController` (ScrollController, required)
     - `threshold` (double, optional, default: 0.9)
   - **Description**: "Check if user has scrolled past threshold percentage"

4. **Save Action**
   - Click **Save**
   - Verify compilation success

### Verification Checklist

- [ ] All 3 custom actions compile without errors
- [ ] Dependencies added (uuid, intl)
- [ ] Action names match exactly: `initializeUserSession`, `checkAndLogRecipeCompletion`, `checkScrollCompletion`
- [ ] Parameter types and names match specifications

---

## Phase 2: Wire Actions to App Pages

### Overview

Connect custom actions to app events and user interactions.

### 2.1: Initialize Session on App Startup

**Page**: Splash Screen / Home Page (whichever loads first)

**Steps:**

1. **Navigate to Startup Page**
   - In FlutterFlow, open the first page that loads (likely Splash or Home)
   - Click on the page widget in widget tree

2. **Add OnInit Action**
   - Click **Actions** tab in right panel
   - Find **On Page Load** or **OnInit** trigger
   - Click **+ Add Action**

3. **Configure Action**
   - Action Type: **Custom Action**
   - Select: `initializeUserSession`
   - No parameters needed

4. **Test**
   - Click **Test Mode** (play button)
   - Verify no errors in console
   - Check App State variables populate (currentSessionId should be set)

### 2.2: Initialize Session on Login Success

**Page**: Login Page

**Steps:**

1. **Navigate to Login Page**
   - Open login page widget

2. **Find Login Button Action Chain**
   - Click login button widget
   - Open Actions tab
   - Find the **OnTap** action that handles successful login

3. **Add Action After Login Success**
   - In the action chain, AFTER Firebase Auth login
   - Add **Custom Action**: `initializeUserSession`
   - Place it before navigation to home

4. **Test**
   - Test login flow in Test Mode
   - Verify session initializes after login

### 2.3: Initialize Session on GoldenPath Page Load

**Page**: GoldenPath Page

**Steps:**

1. **Navigate to GoldenPath Page**
   - Open GoldenPath widget

2. **Add OnInit Action**
   - Page widget > Actions > On Page Load
   - Add Custom Action: `initializeUserSession`

3. **Save**

### 2.4: Track Recipe Start Time

**Page**: Recipe Detail/View Page

**Steps:**

1. **Navigate to Recipe Detail Page**
   - Open recipe_view_page or similar widget

2. **Add OnInit Actions**
   - Page widget > Actions > On Page Load
   - Add action sequence:

   **Action 1: Update App State - currentRecipeId**
   - Action: Update App State
   - Variable: `currentRecipeId`
   - Value: `Widget State > recipeId` (or page parameter)

   **Action 2: Update App State - currentRecipeName**
   - Action: Update App State
   - Variable: `currentRecipeName`
   - Value: `Widget State > recipeName` (or page parameter)

   **Action 3: Update App State - currentRecipeCuisine**
   - Action: Update App State
   - Variable: `currentRecipeCuisine`
   - Value: `Widget State > cuisine` (or page parameter)

   **Action 4: Update App State - currentRecipePrepTime**
   - Action: Update App State
   - Variable: `currentRecipePrepTime`
   - Value: `Widget State > prepTime` (or page parameter)

   **Action 5: Update App State - recipeStartTime**
   - Action: Update App State
   - Variable: `recipeStartTime`
   - Value: `Now` (select from dropdown - current DateTime)

3. **Verify Page Parameters**
   - Ensure recipe page receives: recipeId, recipeName, cuisine, prepTime
   - Add page parameters if missing

### 2.5: Add "Mark as Complete" Button

**Page**: Recipe Detail/View Page

**Steps:**

1. **Add Button Widget**
   - In recipe detail page, scroll to bottom layout
   - Add **Button** widget
   - Position: Bottom of page (after ingredients/instructions)
   - Text: "Mark as Complete" or "I Made This!"
   - Style: Primary color, prominent

2. **Configure Button Action**
   - Click button > Actions > OnTap
   - Action Type: **Custom Action**
   - Select: `checkAndLogRecipeCompletion`

3. **Set Parameters**
   - `recipeId`: `App State > currentRecipeId`
   - `recipeName`: `App State > currentRecipeName`
   - `cuisine`: `App State > currentRecipeCuisine`
   - `prepTimeMinutes`: `App State > currentRecipePrepTime`
   - `source`: `"search"` (or Widget State variable if tracked)
   - `completionMethod`: `"button"` (hardcode string)

4. **Add Conditional Visibility (Optional)**
   - Button > Conditional > Visibility
   - Only show if user is authenticated: `Authenticated User > Logged In`

5. **Add Success Feedback**
   - After custom action, add **Show Snackbar** action
   - Conditional: If action returns true
   - Message: "Recipe marked as complete! 🎉"

6. **Test**
   - Open recipe page in Test Mode
   - Click "Mark as Complete" button
   - Verify snackbar appears
   - Check Firestore console for new document in `user_recipe_completions`

### Verification Checklist

- [ ] Session initializes on app startup
- [ ] Session initializes after login
- [ ] Session initializes on GoldenPath page
- [ ] Recipe start time sets when recipe page opens
- [ ] "Mark as Complete" button visible on recipe page
- [ ] Button click logs completion (check Firestore)
- [ ] Snackbar confirmation shows on success

---

## Phase 3: Deploy Firebase Cloud Function

### Overview

Deploy the `calculateD7Retention` cloud function to run daily retention calculations.

### 3.1: Set Up Firebase Functions Directory

**Steps:**

1. **Navigate to Project Root**
   ```bash
   cd ~/Documents/School/school/CSC305PROJECT/CSCSoftwareDevelopment
   ```

2. **Check if Functions Already Initialized**
   ```bash
   ls -la functions/
   ```

3. **If Not Initialized, Initialize Firebase Functions**
   ```bash
   firebase init functions
   ```

   - Choose: Existing project
   - Select: Your Firebase project (GlobalFlavors)
   - Language: JavaScript
   - ESLint: Yes (recommended)
   - Install dependencies: Yes

### 3.2: Copy Cloud Function Code

**Steps:**

1. **Copy Function File**
   ```bash
   cp metrics-implementation/cloud-functions/calculateD7Retention.js functions/index.js
   ```

   **OR**, if functions/index.js already exists:

   ```bash
   cat metrics-implementation/cloud-functions/calculateD7Retention.js >> functions/index.js
   ```

2. **Install Dependencies**
   ```bash
   cd functions
   npm install firebase-functions@latest firebase-admin@latest
   cd ..
   ```

3. **Verify package.json**
   ```bash
   cat functions/package.json
   ```

   Should include:
   ```json
   {
     "dependencies": {
       "firebase-functions": "^5.0.0",
       "firebase-admin": "^12.0.0"
     }
   }
   ```

### 3.3: Deploy to Firebase

**Steps:**

1. **Deploy Functions**
   ```bash
   firebase deploy --only functions
   ```

2. **Wait for Deployment**
   - Takes 2-5 minutes
   - Watch for success message

3. **Verify Deployment**
   ```bash
   firebase functions:list
   ```

   Should show:
   - `calculateD7Retention` (scheduled)
   - `calculateD7RetentionManual` (callable)
   - `getD7RetentionMetrics` (https)
   - `getRetentionTrend` (https)

### 3.4: Enable Cloud Scheduler

**Steps:**

1. **Open Firebase Console**
   - Navigate to: https://console.firebase.google.com
   - Select your project

2. **Navigate to Cloud Scheduler**
   - Click **Functions** in left sidebar
   - Find `calculateD7Retention`
   - Verify schedule: "every day 02:00" (2 AM UTC)

3. **Run Manual Test**
   ```bash
   # Test with specific cohort date (7 days ago)
   COHORT_DATE=$(date -d "7 days ago" +%Y-%m-%d)

   # Call manual trigger
   firebase functions:shell
   # In shell:
   calculateD7RetentionManual({cohortDate: "2025-10-28"})
   ```

4. **Check Firestore**
   - Open Firebase Console > Firestore
   - Collection: `retention_metrics`
   - Document: `d7_YYYY-MM-DD` (your cohort date)
   - Verify metrics calculated

### Verification Checklist

- [ ] Firebase Functions initialized in project
- [ ] Dependencies installed (firebase-functions, firebase-admin)
- [ ] calculateD7Retention.js deployed successfully
- [ ] All 4 functions listed in Firebase Console
- [ ] Cloud Scheduler shows daily 2 AM schedule
- [ ] Manual test creates document in retention_metrics collection

---

## Phase 4: Create Firestore Indexes

### Overview

Create composite indexes for efficient retention queries.

### 4.1: Create Composite Index for user_recipe_completions

**Steps:**

1. **Open Firebase Console**
   - Navigate to: https://console.firebase.google.com
   - Select your project
   - Click **Firestore Database** in left sidebar

2. **Navigate to Indexes Tab**
   - Click **Indexes** tab at top
   - Click **Composite** sub-tab

3. **Create Index**
   - Click **Create Index** button

4. **Configure Index**
   - **Collection ID**: `user_recipe_completions`
   - **Fields to index**:
     1. Field: `user_id`, Order: Ascending
     2. Field: `completed_at`, Order: Ascending
     3. Field: `is_first_recipe`, Order: Ascending
   - **Query scopes**: Collection

5. **Create Index**
   - Click **Create** button
   - Wait 2-5 minutes for index to build
   - Status will change from "Building" to "Enabled"

### 4.2: Create Index for users Collection (Optional but Recommended)

**Steps:**

1. **Create Index**
   - Click **Create Index** button

2. **Configure Index**
   - **Collection ID**: `users`
   - **Fields to index**:
     1. Field: `cohort_date`, Order: Ascending
     2. Field: `d7_retention_eligible`, Order: Ascending
   - **Query scopes**: Collection

3. **Create**
   - Click **Create**
   - Wait for "Enabled" status

### 4.3: Verify Indexes

**Steps:**

1. **Check Index Status**
   - In Firestore > Indexes > Composite tab
   - Verify both indexes show "Enabled" status

2. **Test Query**
   - Open Firestore > Data tab
   - Collection: `user_recipe_completions`
   - Try filter: `user_id == [some_user_id]` AND `is_first_recipe == false`
   - Should return results without error

### Verification Checklist

- [ ] Composite index created for user_recipe_completions (user_id, completed_at, is_first_recipe)
- [ ] Composite index created for users (cohort_date, d7_retention_eligible)
- [ ] Both indexes show "Enabled" status
- [ ] Test queries run without "needs index" errors

---

## Phase 5: Testing & Verification

### Overview

End-to-end testing of D7 retention tracking system.

### 5.1: Test Session Initialization

**Steps:**

1. **Open FlutterFlow Test Mode**
   - Click **Test Mode** (play button icon)

2. **Check App State**
   - Open **App State** panel
   - Verify variables populated:
     - `currentSessionId`: Should be a UUID
     - `sessionStartTime`: Current timestamp
     - `recipesCompletedThisSession`: Empty list []
     - `isUserFirstRecipe`: true or false based on user
     - `userCohortDate`: User's cohort date (if exists)
     - `userTimezone`: Auto-detected timezone

3. **Test Login Flow**
   - Log in with test user
   - Verify session reinitializes
   - Check App State updates

### 5.2: Test Recipe Completion Flow

**Steps:**

1. **Navigate to Recipe Page**
   - In Test Mode, open any recipe detail page

2. **Verify Recipe Variables Set**
   - Check App State:
     - `currentRecipeId`: Should match recipe
     - `currentRecipeName`: Recipe name
     - `currentRecipeCuisine`: Cuisine type
     - `currentRecipePrepTime`: Prep time
     - `recipeStartTime`: Timestamp

3. **Wait 30+ Seconds**
   - Minimum view time requirement

4. **Click "Mark as Complete" Button**
   - Should see success snackbar
   - Check console for Firebase Analytics event

5. **Verify Firestore Write**
   - Open Firebase Console > Firestore
   - Collection: `user_recipe_completions`
   - Find document with:
     - `user_id`: Your test user ID
     - `recipe_id`: Current recipe ID
     - `completed_at`: Recent timestamp
     - `is_first_recipe`: true (if first) or false

6. **Check users Collection**
   - Collection: `users`
   - Document: Your user ID
   - Verify fields:
     - `first_recipe_completed_at`: Set (if first recipe)
     - `cohort_date`: YYYY-MM-DD format
     - `d7_retention_eligible`: true
     - `total_recipes_completed`: Incremented

7. **Complete Second Recipe**
   - Navigate to different recipe
   - Mark as complete
   - Verify `is_first_recipe`: false in completion document

### 5.3: Test Cloud Function (Manual Trigger)

**Steps:**

1. **Create Test Data**
   - In Firestore, manually create or use existing:
     - 2+ users with `cohort_date` = 7 days ago
     - Each user with 1+ completion in `user_recipe_completions`
     - At least 1 user with 2+ completions (repeat recipe)

2. **Trigger Function Manually**
   ```bash
   cd ~/Documents/School/school/CSC305PROJECT/CSCSoftwareDevelopment

   # Calculate cohort date (7 days ago)
   COHORT_DATE=$(date -d "7 days ago" +%Y-%m-%d)
   echo "Testing cohort: $COHORT_DATE"

   # TODO: Call function via Firebase Admin or gcloud
   # (Requires Firebase CLI authentication)
   ```

3. **Check Function Logs**
   - Firebase Console > Functions > Logs
   - Look for `calculateD7Retention` execution
   - Verify no errors

4. **Check Output**
   - Firestore > Collection: `retention_metrics`
   - Document ID: `d7_YYYY-MM-DD` (your cohort date)
   - Verify fields:
     - `cohort_date`
     - `cohort_size`
     - `users_with_repeat_recipes`
     - `d7_repeat_recipe_rate`
     - `retention_category`

### 5.4: Verify Scheduled Execution

**Steps:**

1. **Wait for Next Scheduled Run**
   - Function runs daily at 2 AM UTC
   - Check logs next morning

2. **Check Cloud Scheduler**
   - Firebase Console > Functions
   - Find `calculateD7Retention`
   - Click "View in Cloud Scheduler"
   - Verify last run status: "Success"

3. **Verify Daily Metrics**
   - Firestore > `retention_metrics`
   - Should see new document daily: `d7_YYYY-MM-DD`

### Complete Testing Checklist

- [ ] Session initializes on app startup with valid UUID
- [ ] Session initializes after login
- [ ] Recipe start time sets when opening recipe page
- [ ] "Mark as Complete" button works
- [ ] First recipe completion creates user cohort
- [ ] Completion document written to user_recipe_completions
- [ ] users collection updated with cohort data
- [ ] Second recipe completion has is_first_recipe = false
- [ ] recipesCompletedThisSession tracks IDs correctly
- [ ] Cloud function runs manually without errors
- [ ] Retention metrics document created in Firestore
- [ ] D7 rate calculated correctly (manual verification)
- [ ] Scheduled function runs daily at 2 AM UTC
- [ ] No errors in Firebase Function logs

---

## Troubleshooting

### Issue: Custom action won't compile

**Solutions:**
- Verify all dependencies added (uuid, intl)
- Check for typos in parameter names
- Ensure return type matches code
- Check FlutterFlow error panel for specific errors

### Issue: App State variables not updating

**Solutions:**
- Verify action is wired to page event (OnInit, OnTap)
- Check parameter bindings match App State variable names
- Test in Test Mode with App State panel open
- Verify user is authenticated (for Firestore writes)

### Issue: Firestore write fails

**Solutions:**
- Check Firebase Console > Firestore > Rules
- Verify user is authenticated
- Check collection names match code exactly
- Look for errors in FlutterFlow console
- Verify Firestore is enabled in Firebase project

### Issue: Cloud function won't deploy

**Solutions:**
- Verify Firebase CLI authenticated: `firebase login`
- Check project selected: `firebase use --add`
- Install dependencies: `cd functions && npm install`
- Check for syntax errors in index.js
- Verify billing enabled on Firebase project

### Issue: Index creation fails

**Solutions:**
- Verify collection exists in Firestore
- Check field names match exactly (case-sensitive)
- Wait for index to finish building (can take 5+ minutes)
- Delete and recreate index if stuck in "Building"

### Issue: Retention calculation returns 0

**Solutions:**
- Verify test users have cohort_date 7 days ago
- Check users have d7_retention_eligible = true
- Verify completion documents exist in user_recipe_completions
- Check timestamps are within D1-D7 window
- Review cloud function logs for query errors

---

## Next Steps After Implementation

### 1. Monitor Initial Data Collection
- Week 1: Verify completions logging correctly
- Week 2: Check first cohort retention calculation (D7 after first users)
- Month 1: Review retention trends, identify patterns

### 2. Build Admin Dashboard (Optional Enhancement)
- Create FlutterFlow admin page
- Call `getD7RetentionMetrics` HTTP endpoint
- Display charts: D7 rate over time, cohort comparisons
- Add drill-down into user-level details

### 3. Implement Additional Metrics
- Recipe Search Engagement (Metric 2)
- Ingredient Substitution Tracking (Metric 3)
- User Search Efficiency (Metric 4)

### 4. Expand Retention Tracking
- D1 retention (1-day repeat rate)
- D3 retention
- D14 retention
- D30 retention
- Compare across cohorts

### 5. Set Up Alerts
- Implement email notifications in `sendRetentionAlert`
- Add Slack webhook for team alerts
- Configure thresholds (e.g., alert if D7 < 12%)

### 6. A/B Testing Integration
- Connect retention metrics to A/B test variants
- Measure impact of features on D7 rate
- Use retention as primary success metric

---

## Summary

This implementation guide provides complete step-by-step instructions for deploying D7 retention tracking to the GlobalFlavors FlutterFlow project.

**What's Automated:**
- Session tracking initialization
- Recipe completion logging
- Firestore data writes
- Daily retention calculations
- Cohort analysis

**What's Manual (UI Configuration):**
- Adding custom actions to FlutterFlow
- Wiring actions to page events
- Adding "Mark as Complete" button
- Firebase function deployment
- Firestore index creation

**Expected Timeline:**
- Phase 1 (Custom Actions): 30-45 minutes
- Phase 2 (Wiring): 45-60 minutes
- Phase 3 (Cloud Function): 20-30 minutes
- Phase 4 (Indexes): 10-15 minutes
- Phase 5 (Testing): 30-45 minutes
- **Total**: 2.5-3.5 hours

**Post-Implementation:**
- Data collection begins immediately
- First D7 cohort calculated 7 days after first user
- Ongoing daily calculations at 2 AM UTC

---

**Document Version**: 1.0
**Last Updated**: November 4, 2025
**Author**: Juan Vallejo (with Claude Code assistance)
**Status**: Ready for Deployment
