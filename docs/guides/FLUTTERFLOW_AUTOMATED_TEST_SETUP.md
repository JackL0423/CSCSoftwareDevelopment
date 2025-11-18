# FlutterFlow Automated Test Setup Guide

**Purpose**: Step-by-step instructions for creating automated tests in FlutterFlow UI for US3 (Backend Management) and US4 (Golden Path).

**Last Updated**: November 17, 2025
**Test Framework**: FlutterFlow Automated Tests → Flutter integration_test
**Execution Environment**: Firebase Studio with Android Emulator

---

## Table of Contents

1. [Prerequisites & Setup](#prerequisites--setup)
2. [US3: Backend Management Tests](#us3-backend-management-tests)
3. [US4: Golden Path Test](#us4-golden-path-test)
4. [Running Tests in Firebase Studio](#running-tests-in-firebase-studio)
5. [Troubleshooting](#troubleshooting)
6. [Success Criteria](#success-criteria)

---

## Prerequisites & Setup

### Before You Start

**Required Access:**
- [ ] FlutterFlow account with edit access to GlobalFlavors project
- [ ] Google account for Firebase Studio
- [ ] GitHub account (for pushing FlutterFlow code)

**Test Data Setup:**
```bash
# Run these scripts to seed test data (from project root)
cd /home/jpv/Documents/School/school/CSC305PROJECT/CSCSoftwareDevelopment

# 1. Create test users (if not already done)
scripts/testing/create-test-users.sh --count 5 --domain example.com --password 'TestPass123!'

# 2. Seed Firestore with test data
scripts/testing/seed-test-data.sh --users 5 --days 7
```

**Test User Credentials:**
```
Email: test_user_001@example.com
Password: TestPass123!
```

### FlutterFlow Automated Tests Location

1. Open FlutterFlow project: https://app.flutterflow.io/project/csc305-capstone-kfj14hzab-tests
2. Navigate to: **Automated Tests** (icon in left sidebar)
3. You'll see the interface shown in your screenshot

---

## US3: Backend Management Tests

**Objective**: Verify Firebase SDK connection and Firestore data access for backend management features.

**Test Group**: Backend Management

### Step 1: Create Test Group (One-Time Setup)

1. In FlutterFlow → Automated Tests
2. Under "Groups", click **"Click to create a new test group"**
3. Enter group name: `Backend-Management`
4. Click **Save**

---

### Test Case 3.1: Firebase SDK Connection

**Test Name**: `US3-Test1-Firebase-SDK-Connection`

**Objective**: Verify app successfully initializes Firebase SDK and connects to Firestore.

**Pre-conditions**:
- User has Firebase Admin SDK credentials configured
- Firestore `users` collection exists with at least 1 document

#### Steps to Create in FlutterFlow:

1. Click **"+ Create New"** button (top right)
2. **Test Details**:
   - Test Name: `US3-Test1-Firebase-SDK-Connection`
   - Description: `Verify Firebase SDK initializes and connects to Firestore users collection`
   - Group: Select `Backend-Management`
3. Click **"Add Test Step"**

**Test Step 1: Wait for App Initialization**
- Step Type: **Wait to Load (Pump & Settle)**
- Duration: `3000` ms
- Description: `Allow Firebase SDK to initialize`

**Test Step 2: Verify Users Collection Access**
- Step Type: **Expect Result**
- Find By: **Text**
- Text to Find: `users` (or verify a known user email like `test_user_001@example.com`)
- Description: `Verify users collection query returns data`

**Expected Result**:
✅ Test passes if Firebase connects and users collection returns documents without errors.

---

### Test Case 3.2: View Users Collection Data

**Test Name**: `US3-Test2-View-Users-Collection`

**Objective**: Verify app can read and display user data from Firestore `users` collection.

**Expected Fields**: email, uid, display_name, created_time

#### Steps to Create in FlutterFlow:

1. Click **"+ Create New"**
2. **Test Details**:
   - Test Name: `US3-Test2-View-Users-Collection`
   - Description: `Query users collection and verify expected fields are present`
   - Group: `Backend-Management`

**Test Step 1: Navigate to Data View (if applicable)**
- **NOTE**: If your app has a dedicated admin/data view screen, add navigation here
- Step Type: **Interact with Widget**
- Widget: `AdminMenuButton` (or equivalent)
- Action: **Tap**

**Test Step 2: Wait for Data Load**
- Step Type: **Wait to Load (Pump & Settle)**
- Duration: `2000` ms

**Test Step 3: Verify User Email Field**
- Step Type: **Expect Result**
- Find By: **Text**
- Text: `test_user_001@example.com` (or any known test user email)

**Test Step 4: Verify Display Name Field**
- Step Type: **Expect Result**
- Find By: **Text**
- Text: `Test User` (or expected display name)

**Expected Result**:
✅ All expected fields (email, uid, display_name, created_time) are readable and properly formatted.

---

### Test Case 3.3: View Recipes Collection Data

**Test Name**: `US3-Test3-View-Recipes-Collection`

**Objective**: Verify app can query recipes collection and filter by category (e.g., Italian).

**Expected Fields**: title, desc, ingredientName

#### Steps to Create in FlutterFlow:

1. Click **"+ Create New"**
2. **Test Details**:
   - Test Name: `US3-Test3-View-Recipes-Collection`
   - Description: `Query recipes collection for Italian category and verify fields`
   - Group: `Backend-Management`

**Test Step 1: Navigate to Recipes View (if applicable)**
- Step Type: **Interact with Widget**
- Widget: `RecipesBrowserButton` (or search bar)
- Action: **Tap**

**Test Step 2: Filter by Category**
- Step Type: **Interact with Widget**
- Widget: `CategoryFilter` (dropdown or filter button)
- Action: **Select** or **Tap**
- Value: `Italian`

**Test Step 3: Wait for Query Results**
- Step Type: **Wait to Load (Pump & Settle)**
- Duration: `2000` ms

**Test Step 4: Verify Recipe Title Present**
- Step Type: **Expect Result**
- Find By: **Text**
- Text: `Pasta Carbonara` (or known Italian recipe title)

**Test Step 5: Verify Recipe Description Visible**
- Step Type: **Expect Result**
- Find By: **Text**
- Text: Contains `Italian` or recipe description snippet

**Test Step 6: Verify Ingredient List**
- Step Type: **Expect Result**
- Find By: **Text**
- Text: `Spaghetti` or `Guanciale` (known ingredients from test data)

**Expected Result**:
✅ Query returns at least 5 Italian recipes with populated title, desc, and ingredientName fields.

---

### Test Case 3.4: Access Retention Metrics Collection

**Test Name**: `US3-Test4-Access-Retention-Metrics`

**Objective**: Verify app can access `retention_metrics` collection with recent D7 retention data.

**Expected Fields**: cohort_date, retention_rate (0.0-1.0), calculation_date (within last 24 hours)

#### Steps to Create in FlutterFlow:

1. Click **"+ Create New"**
2. **Test Details**:
   - Test Name: `US3-Test4-Access-Retention-Metrics`
   - Description: `Verify retention_metrics collection is accessible with valid D7 data`
   - Group: `Backend-Management`

**Test Step 1: Navigate to Analytics/Admin Dashboard**
- Step Type: **Interact with Widget**
- Widget: `AnalyticsButton` or `AdminDashboard` (if UI exists)
- Action: **Tap**

**Test Step 2: Wait for Metrics Load**
- Step Type: **Wait to Load (Pump & Settle)**
- Duration: `3000` ms (Cloud Function may need time)

**Test Step 3: Verify Cohort Date Visible**
- Step Type: **Expect Result**
- Find By: **Text**
- Text: `2025-11-` (recent cohort date format)

**Test Step 4: Verify Retention Rate Range**
- Step Type: **Expect Result**
- Find By: **Text**
- Text: `0.` or `%` (retention rate displayed as decimal or percentage)
- **NOTE**: FlutterFlow may not support numeric range assertions, so verify text presence

**Test Step 5: Verify Calculation Timestamp**
- Step Type: **Expect Result**
- Find By: **Text**
- Text: `2025-11-1` (today's date or within last 24 hours)

**Expected Result**:
✅ retention_metrics collection returns valid data with retention_rate between 0.0 and 1.0, calculation_date within last 24 hours.

---

## US4: Golden Path Test

**Objective**: Complete end-to-end user flow: Dashboard → Search → Find Recipes → Select Recipe → View Recipe Details.

**Test Group**: Golden-Path

### Step 1: Create Test Group (One-Time Setup)

1. In FlutterFlow → Automated Tests
2. Under "Groups", click **"Click to create a new test group"**
3. Enter group name: `Golden-Path`
4. Click **Save**

---

### Test Case 4.1: Complete Golden Path Flow

**Test Name**: `US4-GoldenPath-Complete-Flow`

**Objective**: Verify complete user journey from login through recipe selection and viewing details.

**Pre-conditions**:
- Test user account exists: test_user_001@example.com / TestPass123!
- Recipes collection has Italian recipes (Pasta Carbonara)
- Search functionality is implemented

#### Steps to Create in FlutterFlow:

1. Click **"+ Create New"**
2. **Test Details**:
   - Test Name: `US4-GoldenPath-Complete-Flow`
   - Description: `End-to-end test of dashboard → search → recipe selection → detail view`
   - Group: `Golden-Path`

---

#### Phase 1: Login

**Test Step 1: Enter Email**
- Step Type: **Interact with Widget**
- Widget: `EmailTextField` (find widget by key or label)
- Action: **Enter Text**
- Text: `test_user_001@example.com`

**Test Step 2: Enter Password**
- Step Type: **Interact with Widget**
- Widget: `PasswordTextField`
- Action: **Enter Text**
- Text: `TestPass123!`

**Test Step 3: Tap Sign In Button**
- Step Type: **Interact with Widget**
- Widget: `SignInButton`
- Action: **Tap**

**Test Step 4: Wait for Authentication**
- Step Type: **Wait to Load (Pump & Settle)**
- Duration: `3000` ms
- Description: `Wait for Firebase Auth and navigation to home screen`

---

#### Phase 2: Verify Dashboard/Home Screen

**Test Step 5: Verify Home Screen Loaded**
- Step Type: **Expect Result**
- Find By: **Text**
- Text: `Dashboard` OR `Home` OR `Discover Recipes` (expected home screen title)
- Description: `Confirm successful login and navigation to home`

**Test Step 6: Verify Search Bar Visible**
- Step Type: **Expect Result**
- Find By: **Text**
- Text: `Search` OR `Find Recipes` (A/B test variant, see ABTEST.md)
- Description: `Verify search functionality is available`

---

#### Phase 3: Search for Recipe

**Test Step 7: Tap Search Bar**
- Step Type: **Interact with Widget**
- Widget: `SearchBar` or `SearchTextField`
- Action: **Tap**

**Test Step 8: Enter Search Query**
- Step Type: **Interact with Widget**
- Widget: `SearchTextField`
- Action: **Enter Text**
- Text: `Pasta` (or `Italian` for category search)

**Test Step 9: Submit Search**
- **Option A**: Tap search button
  - Step Type: **Interact with Widget**
  - Widget: `SearchButton` or `SubmitSearchButton`
  - Action: **Tap**
- **Option B**: Press enter (if supported by FlutterFlow test framework)

**Test Step 10: Wait for Search Results**
- Step Type: **Wait to Load (Pump & Settle)**
- Duration: `2000` ms
- Description: `Wait for Firestore query results to load`

---

#### Phase 4: Verify Search Results

**Test Step 11: Verify Recipe Card Visible**
- Step Type: **Expect Result**
- Find By: **Text**
- Text: `Pasta Carbonara` (known recipe from test data)
- Description: `Confirm search results display expected recipe`

**Test Step 12: Verify Recipe Category**
- Step Type: **Expect Result**
- Find By: **Text**
- Text: `Italian` (category label on recipe card)

**Test Step 13: Verify Difficulty Badge**
- Step Type: **Expect Result**
- Find By: **Text**
- Text: `Medium` (or `Easy`/`Hard` depending on test data)

---

#### Phase 5: Select Recipe

**Test Step 14: Tap Recipe Card**
- Step Type: **Interact with Widget**
- Widget: `RecipeCard_PastaCarbonara` (or generic `RecipeCard` if no specific key)
- Action: **Tap**
- **NOTE**: You may need to tap on the recipe title text instead of the card

**Test Step 15: Wait for Recipe Detail Page Load**
- Step Type: **Wait to Load (Pump & Settle)**
- Duration: `3000` ms
- Description: `Allow recipe detail page to load with all data`

---

#### Phase 6: Verify Recipe Detail View

**Test Step 16: Verify Recipe Title**
- Step Type: **Expect Result**
- Find By: **Text**
- Text: `Pasta Carbonara`
- Description: `Confirm correct recipe detail page loaded`

**Test Step 17: Verify Recipe Description**
- Step Type: **Expect Result**
- Find By: **Text**
- Text: `Authentic` OR `Roman` (keywords from descLong field)

**Test Step 18: Verify Ingredients Section**
- Step Type: **Expect Result**
- Find By: **Text**
- Text: `Ingredients` (section header)

**Test Step 19: Verify Specific Ingredient**
- Step Type: **Expect Result**
- Find By: **Text**
- Text: `Spaghetti` OR `Guanciale` (from ingredientNames array)

**Test Step 20: Verify Ingredient Quantity**
- Step Type: **Expect Result**
- Find By: **Text**
- Text: `400g` OR `200g` (from ingredientQuantities array)

**Test Step 21: Verify Preparation Steps Section**
- Step Type: **Expect Result**
- Find By: **Text**
- Text: `Preparation` OR `Instructions` (section header)

**Test Step 22: Verify Prep Time**
- Step Type: **Expect Result**
- Find By: **Text**
- Text: `30 minutes` OR `30 min` (from prep field)

**Test Step 23: Verify Difficulty Level**
- Step Type: **Expect Result**
- Find By: **Text**
- Text: `Medium` (from difficulty field)

---

**Expected Result**:
✅ User successfully completes golden path: login → home → search → results → recipe detail with all fields populated.

---

## Running Tests in Firebase Studio

FlutterFlow builds the automated tests but **does not execute them**. You must use **Firebase Studio** (or Android Studio) with an Android emulator.

### Prerequisites

**Required Tools**:
- Google account
- Firebase Studio access: https://idx.google.com/
- FlutterFlow GitHub app installed (to push code)

---

### Step 1: Push FlutterFlow Project to GitHub

1. **In FlutterFlow**:
   - Open **Developer Menu** (`</>` icon in toolbar)
   - Click **"View Code"**

2. **Push to Repository**:
   - Click **"Push to Repository"**
   - **IMPORTANT**: Do NOT merge to main branch
   - Keep code on `flutterflow` branch (as per lesson instructions)

3. **Verify Push**:
   - Check your GitHub repository
   - Confirm `flutterflow` branch has latest commits
   - Verify `integration_test/test.dart` file exists

---

### Step 2: Set Up Firebase Studio Workspace

1. **Go to Firebase Studio**: https://idx.google.com/
2. **Login** with your Google account
3. **Create New Workspace**:
   - Click **"New Workspace"**
   - Select **"Flutter"** template (may need to search templates)
   - Wait 2-5 minutes for environment to initialize

4. **Delete Default Files** (important!):
   - In Firebase Studio file explorer
   - Delete all files/folders EXCEPT:
     - `.idx/` folder
     - `.vscode/` folder
   - Right-click → **"Delete Permanently"**

---

### Step 3: Clone FlutterFlow Branch

1. **Open Terminal in Firebase Studio**:
   - Hamburger menu (top left) → **"New Terminal"**

2. **Clone Your FlutterFlow Branch**:
   ```bash
   git clone --branch flutterflow <your-github-repo-url>
   ```

   Example:
   ```bash
   git clone --branch flutterflow https://github.com/JackL0423/CSCSoftwareDevelopment.git
   ```

3. **Move Files to Root**:
   ```bash
   # Drag all folders/files from cloned directory into root of IDX
   # OR use terminal:
   mv CSCSoftwareDevelopment/* .
   rm -rf CSCSoftwareDevelopment
   ```

4. **Verify Structure**:
   - File tree should now look similar to before you deleted default files
   - Verify `integration_test/test.dart` exists

---

### Step 4: Run the Tests

1. **Start Your App**:
   - In Firebase Studio, click dropdown where it says "Web"
   - Select **"Android"** tab
   - Click **"Hard Restart"** to run app
   - **Wait 5-10 minutes** for first build (subsequent runs are faster)

2. **Verify App Running**:
   - Android emulator should appear showing your app
   - Test login manually if needed

3. **Run Integration Tests**:
   ```bash
   flutter test integration_test/test.dart
   ```

4. **Watch Test Execution**:
   - **IMPORTANT**: Watch the Android emulator, NOT just the terminal
   - Tests will interact with UI (enter text, tap buttons, etc.)
   - Terminal will show test progress and results

---

### Step 5: Interpret Test Results

**Successful Test Output**:
```
00:01 +0: US3-Test1-Firebase-SDK-Connection
00:03 +1: US3-Test2-View-Users-Collection
00:05 +2: US3-Test3-View-Recipes-Collection
00:08 +3: US3-Test4-Access-Retention-Metrics
00:12 +4: US4-GoldenPath-Complete-Flow
00:25 +5: All tests passed!
```

**Failed Test Output**:
```
00:05 +2 -1: US3-Test3-View-Recipes-Collection [E]
  Expected: find one widget with text "Pasta Carbonara"
  Actual: _WidgetTypeFinder:<zero widgets with text "Pasta Carbonara">
```

**Common Failure Reasons**:
- Widget not found → Check widget name/key in FlutterFlow
- Text not found → Verify expected text matches exactly (case-sensitive)
- Timeout → Increase "Wait to Load" duration

---

### Step 6: Update Tests and Re-Run

**After Each FlutterFlow Change**:

1. **In FlutterFlow**: Make test changes → **Push to Repository**
2. **In Firebase Studio**:
   ```bash
   git pull
   ```
3. **Re-run tests**:
   ```bash
   flutter test integration_test/test.dart
   ```

**NOTE**: Re-cloning entire repo is easiest but slower. Use `git pull` for faster updates.

---

## Troubleshooting

### Widget Not Found

**Error**: `Expected: find one widget with text "X". Actual: zero widgets`

**Solutions**:
1. **Check exact text/label** in FlutterFlow UI (case-sensitive, check for extra spaces)
2. **Use widget keys instead of text**:
   - In FlutterFlow: Select widget → Properties → **Set Widget Key**
   - In test: Find By **Key** instead of Text
3. **Increase wait time** before assertion:
   - Add **Wait to Load (3000ms)** before Expect Result
4. **Verify page navigation** completed before checking widget

---

### Test Times Out

**Error**: `Test timed out after 30 seconds`

**Solutions**:
1. **Increase Wait to Load durations**:
   - Firebase initialization: 3000-5000ms
   - Firestore queries: 2000-3000ms
   - Page navigation: 2000-3000ms
2. **Check network connectivity** in emulator
3. **Verify Firebase services are accessible** from emulator

---

### Authentication Fails

**Error**: `User not authenticated` or test can't proceed past login

**Solutions**:
1. **Verify test user exists** in Firebase Authentication:
   ```bash
   scripts/testing/create-test-users.sh --count 1 --domain example.com --password 'TestPass123!'
   ```
2. **Check credentials match exactly** (case-sensitive)
3. **Wait longer after login** (try 5000ms instead of 3000ms)
4. **Enable email/password auth** in Firebase Console if not already enabled

---

### Firestore Data Not Found

**Error**: Tests pass but data verification fails (e.g., wrong retention rate)

**Solutions**:
1. **Seed test data** before running tests:
   ```bash
   scripts/testing/seed-test-data.sh --users 5 --days 7
   ```
2. **Verify Firestore indexes** exist (see DEPLOYMENT_STATUS.md)
3. **Run D7 retention calculation** manually:
   ```bash
   scripts/testing/test-retention-function.sh
   ```
4. **Check Firestore rules** allow read access for test user

---

### Search Returns No Results

**Error**: Recipe search finds zero results

**Solutions**:
1. **Verify recipes exist** in Firestore `recipes` collection
2. **Check search query spelling** matches recipe titles
3. **Try broader search terms**:
   - Instead of "Pasta Carbonara" → try "Pasta" or "Italian"
4. **Verify search functionality** works manually in FlutterFlow preview

---

### A/B Test Variant Issues

**Error**: Test expects "Search" but app shows "Find Recipes" (or vice versa)

**Solution**:
- **Use OR conditions** in test assertions (if FlutterFlow supports)
- **OR**: Create two separate tests, one for each variant
- **Reference**: See ABTEST.md for Remote Config parameter `search_button_text`

---

## Success Criteria

### US3: Backend Management Tests

✅ All 4 tests pass:
1. Firebase SDK connects successfully
2. Users collection data readable with expected fields
3. Recipes collection filterable by category with ≥5 results
4. Retention metrics collection accessible with valid D7 data (retention_rate 0.0-1.0, recent calculation_date)

### US4: Golden Path Test

✅ Complete flow test passes:
1. User successfully logs in
2. Dashboard/home screen loads
3. Search bar accepts input
4. Search results display expected recipes
5. Recipe selection navigates to detail page
6. Recipe detail page shows all required fields:
   - Title
   - Description
   - Ingredients with quantities
   - Preparation steps
   - Prep time
   - Difficulty level

### Test Execution

✅ All tests complete in under 60 seconds total
✅ Zero failed assertions
✅ No timeout errors
✅ Android emulator shows expected UI interactions

---

## Additional Resources

**Related Documentation**:
- [TESTCASES.md](../TESTCASES.md) - Test case presentation links
- [TESTING_GUIDE.md](../implementation/TESTING_GUIDE.md) - Firebase test data seeding
- [ABTEST.md](../ABTEST.md) - A/B test variants (search button text)
- [DEPLOYMENT_STATUS.md](../architecture/DEPLOYMENT_STATUS.md) - Backend deployment status

**FlutterFlow Docs**:
- Automated Tests: https://docs.flutterflow.io/testing/automated-tests
- Running Tests: https://docs.flutterflow.io/testing/automated-tests#run-tests

**Firebase Studio Docs**:
- Getting Started: https://idx.google.com/docs

---

## Quick Reference: Test Creation Checklist

### Before Creating Tests

- [ ] FlutterFlow project accessible
- [ ] Test users created (`scripts/testing/create-test-users.sh`)
- [ ] Test data seeded (`scripts/testing/seed-test-data.sh`)
- [ ] Know test user credentials (test_user_001@example.com / TestPass123!)

### Creating Each Test

- [ ] Click "+ Create New" in Automated Tests
- [ ] Enter test name (US3-Test1-*, US4-GoldenPath-*)
- [ ] Assign to test group (Backend-Management or Golden-Path)
- [ ] Add test steps in order
- [ ] Use "Wait to Load" after interactions (2000-3000ms)
- [ ] Use "Expect Result" → "Find By Text" for verifications
- [ ] Save test

### Running Tests

- [ ] Push FlutterFlow code to GitHub (flutterflow branch)
- [ ] Create Firebase Studio workspace (Flutter template)
- [ ] Clone flutterflow branch
- [ ] Run `flutter test integration_test/test.dart`
- [ ] Verify all tests pass (watch emulator)

---

**End of Guide** - Good luck with your automated testing! 🎯
