## 2025-11-05 additions

- Added automation for FlutterFlow trigger wiring via the official Project YAML API (v2).
- Introduced Test Lab scripts for synchronous Robo runs and GCS-based results collection.
- See `scripts/README.md` for categorized commands and `automation/wiring-manifest.json` for current wiring targets.

# D7 Retention Metrics - Deployment Status

**Last Updated:** 2025-11-05
**Project:** GlobalFlavors (c-s-c305-capstone-khj14l)
**Status:** Backend Complete, UI Wiring Pending

---

## Deployment Summary

### ✅ Completed

#### 1. Custom Dart Actions (2/3 deployed)
- **initializeUserSession** ✓
  - Purpose: Track user sessions and app opens
  - Parameters: None
  - Firestore writes: `user_sessions`, `users` collections

- **checkAndLogRecipeCompletion** ✓
  - Purpose: Log recipe completions with retention tracking
  - Parameters: recipeId, recipeName, cuisine, prepTimeMinutes, source, completionMethod
  - Firestore writes: `user_recipe_completions` collection

- **checkScrollCompletion** ⏭️
  - Status: SKIPPED (ScrollController parameter type not supported by FlutterFlow API)
  - Alternative: Button-based completion tracking

**Deployed via:** FlutterFlow API (`/v2/syncCustomCodeChanges`)
**Location:** `c_s_c305_capstone/lib/custom_code/actions/`
**Scripts:** `scripts/push-essential-actions-only.sh`

#### 2. Firebase Cloud Functions (4/4 deployed)
All functions deployed successfully to `csc-305-dev-project`:

- **calculateD7Retention** (us-central1) ✓
  - Type: Scheduled (Cloud Scheduler)
  - Schedule: Daily at 2 AM UTC
  - Purpose: Calculate D7 Repeat Recipe Rate for cohorts
  - Runtime: Node.js 20

- **calculateD7RetentionManual** (us-central1) ✓
  - Type: Callable (HTTPS)
  - Purpose: Manual/backfill retention calculations
  - Runtime: Node.js 20

- **getD7RetentionMetrics** (us-central1) ✓
  - Type: HTTPS endpoint
  - URL: https://us-central1-csc-305-dev-project.cloudfunctions.net/getD7RetentionMetrics
  - Purpose: Query retention metrics by cohort date
  - Runtime: Node.js 20

- **getRetentionTrend** (us-central1) ✓
  - Type: HTTPS endpoint
  - URL: https://us-central1-csc-305-dev-project.cloudfunctions.net/getRetentionTrend
  - Purpose: Get retention trend over time
  - Runtime: Node.js 20

**Deployed via:** Firebase CLI with service account authentication
**Scripts:** `scripts/deploy-firebase-with-serviceaccount.sh`
**Deployment Logs:** Successfully deployed 2025-11-05T19:53:49

#### 3. Firestore Composite Indexes (2/2 deployed)

- **user_recipe_completions** collection ✓
  - Fields: user_id (ASC), completed_at (ASC), is_first_recipe (ASC)
  - Purpose: Efficient querying of recipe completions in D1-D7 window

- **users** collection ✓
  - Fields: cohort_date (ASC), d7_retention_eligible (ASC)
  - Purpose: Fast retrieval of cohort users for retention calculation

**Deployed via:** Firebase CLI
**Config:** `firestore.indexes.json`

#### 4. App State Variables (12/12 configured)
All required state variables defined in FlutterFlow app-state:

| Variable | Type | Purpose |
|----------|------|---------|
| `currentRecipeId` | String | Current recipe being viewed |
| `currentRecipeName` | String | Name of current recipe |
| `currentRecipeCuisine` | String | Cuisine type |
| `currentRecipePrepTime` | Integer | Prep time in minutes |
| `currentRecipeSource` | String | Recipe source (featured/search/etc.) |
| `recipeStartTime` | DateTime | When recipe view started |
| `currentSessionId` | String | Session tracking ID |
| `sessionStartTime` | DateTime | When session started |
| `recipesViewedThisSession` | List<String> | Recipe IDs viewed |
| `recipesCompletedThisSession` | List<String> | Recipe IDs completed |
| `lastRecipeCompletedAt` | DateTime | Timestamp of last completion |
| `userCohortDate` | String | User's cohort date (YYYY-MM-DD) |

**Configured via:** FlutterFlow YAML API
**Scripts:** `scripts/add-retention-variables.sh` (previously executed)

---

### ⏳ Pending (Manual UI Work Required)

#### 5. UI Action Wiring (0/4 completed)

**Critical Finding:** FlutterFlow's YAML API does NOT expose page-level triggers (OnPageLoad, OnAuthSuccess). These MUST be wired manually in the FlutterFlow UI.

**Required Manual Wiring:**

1. **HomePage** - OnPageLoad → `initializeUserSession`
   - Time: 15-20 minutes
   - Guide: `docs/MANUAL_PAGE_TRIGGER_WIRING.md` (Section 1)

2. **GoldenPath** - OnPageLoad → `initializeUserSession`
   - Time: 15-20 minutes
   - Guide: `docs/MANUAL_PAGE_TRIGGER_WIRING.md` (Section 2)

3. **Login/SIGNUPV1** - OnAuthSuccess → `initializeUserSession`
   - Time: 20-30 minutes
   - Guide: `docs/MANUAL_PAGE_TRIGGER_WIRING.md` (Section 3)

4. **RecipeViewPage** - Button OnTap → `checkAndLogRecipeCompletion`
   - Time: 20-30 minutes
   - Guide: `docs/MANUAL_PAGE_TRIGGER_WIRING.md` (Section 4)
   - **Purpose:** This manual wiring will reveal YAML schema for Phase 2 automation

**Total Time:** 90-130 minutes (one-time)
**Documentation:** `docs/MANUAL_PAGE_TRIGGER_WIRING.md`

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│ FlutterFlow App (c-s-c305-capstone-khj14l)                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  HomePage (OnPageLoad)                                      │
│  │                                                           │
│  └─> initializeUserSession() ───┐                          │
│                                   │                          │
│  GoldenPath (OnPageLoad)          │                          │
│  │                                │                          │
│  └─> initializeUserSession() ───┤                          │
│                                   │                          │
│  Login (OnAuthSuccess)            │                          │
│  │                                │                          │
│  └─> initializeUserSession() ───┼─> Firestore              │
│                                   │   ├─> user_sessions      │
│                                   │   └─> users (cohort)     │
│  RecipeViewPage                   │                          │
│  │                                │                          │
│  └─> [Mark Complete Button]      │                          │
│       │                           │                          │
│       └─> checkAndLogRecipeCompletion() ───> Firestore      │
│                                              └─> user_recipe_completions
│                                                               │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│ Firebase Backend (csc-305-dev-project)                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Cloud Scheduler (Daily 2 AM UTC)                          │
│  │                                                           │
│  └─> calculateD7Retention()                                │
│       │                                                      │
│       ├─> Query users by cohort_date                       │
│       ├─> Query user_recipe_completions (D1-D7)            │
│       ├─> Calculate D7 Repeat Recipe Rate                  │
│       └─> Write to retention_metrics collection            │
│                                                             │
│  HTTPS Endpoints                                            │
│  │                                                           │
│  ├─> getD7RetentionMetrics(?cohortDate=YYYY-MM-DD)        │
│  │    └─> Return metrics for specific cohort               │
│  │                                                           │
│  └─> getRetentionTrend(?days=30)                           │
│       └─> Return trend data over time period               │
│                                                             │
│  Firestore Collections                                      │
│  ├─> users                                                  │
│  ├─> user_sessions                                          │
│  ├─> user_recipe_completions                               │
│  └─> retention_metrics                                      │
│                                                             │
│  Composite Indexes                                          │
│  ├─> user_recipe_completions (user_id, completed_at, ...)  │
│  └─> users (cohort_date, d7_retention_eligible)            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## File Structure

### Custom Code (Deployed)
```
c_s_c305_capstone/lib/custom_code/
├── actions/
│   ├── initialize_user_session.dart          ✓ Deployed
│   ├── check_and_log_recipe_completion.dart   ✓ Deployed
│   ├── check_scroll_completion.dart           ⏭️ Skipped
│   └── index.dart
└── widgets/
    └── index.dart                             (empty)
```

### Firebase Functions (Deployed)
```
functions/
├── index.js                                    ✓ Deployed (4 functions)
└── package.json                                (Node.js 20)
```

### Configuration Files
```
CSCSoftwareDevelopment/
├── firebase.json                               ✓ Updated (firestore config)
├── .firebaserc                                 ✓ Updated (project ID)
├── firestore.indexes.json                      ✓ Deployed
└── functions/
    └── package.json                            ✓ Updated (Node 20)
```

### Scripts (Automation)
```
scripts/
├── push-essential-actions-only.sh              ✓ Used for custom actions
├── deploy-firebase-with-serviceaccount.sh      ✓ Used for functions
├── download-yaml.sh                            ✓ Available
├── update-yaml.sh                              ✓ Available
├── validate-yaml.sh                            ✓ Available
└── list-yaml-files.sh                          ✓ Available
```

### Documentation
```
docs/
├── MANUAL_PAGE_TRIGGER_WIRING.md               ✓ Created (Phase 1)
├── D7_RETENTION_METRICS_GUIDE.md               ✓ Exists
├── METRICS.md                                  ✓ Exists
└── archive/
    ├── RETENTION_IMPLEMENTATION_GUIDE.md       (archived)
    └── D7-Retention-Variables-SUCCESS.md       (archived)
```

---

## IAM Permissions Granted

The following IAM roles were granted to enable service account deployment:

### Service Account: firebase-adminsdk-fbsvc@csc-305-dev-project.iam.gserviceaccount.com

| Role | Purpose | Resource |
|------|---------|----------|
| `roles/firebase.admin` | Firebase administration | Project-wide |
| `roles/cloudfunctions.developer` | Deploy Cloud Functions | Project-wide |
| `roles/cloudscheduler.admin` | Manage Cloud Scheduler jobs | Project-wide |
| `roles/serviceusage.serviceUsageConsumer` | Enable/use GCP APIs | Project-wide |
| `roles/iam.serviceAccountUser` | Act as service accounts | csc-305-dev-project@appspot.gserviceaccount.com |
| `roles/iam.serviceAccountUser` | Act as Compute Engine SA | 54503053415-compute@developer.gserviceaccount.com |

### Personal Account: vallejo.juan97@gmail.com

| Role | Purpose | Resource |
|------|---------|----------|
| `roles/iam.serviceAccountUser` | Grant SA permissions | Project-wide |
| `roles/owner` | Project administration | Project-wide |

---

## Next Steps

### Immediate (This Session)

1. **Execute Manual UI Wiring** (90-130 minutes)
   - Follow `docs/MANUAL_PAGE_TRIGGER_WIRING.md`
   - Wire 4 page triggers to custom actions
   - Test in FlutterFlow preview mode

2. **Download Updated YAMLs** (15 minutes)
   - Capture button/action YAML structure
   - Document custom action reference schema
   - Create `docs/CUSTOM_ACTION_YAML_SCHEMA.md`

### Phase 2 (Future Session)

3. **Create Automation Script** (4 hours)
   - Build `scripts/wire-custom-action-to-button.sh`
   - Automate button addition + action wiring for additional pages
   - Test on secondary pages (search results, featured recipes)

4. **Create Verification Scripts** (1 hour)
   - `scripts/verify-action-wiring.sh` - Check wiring status
   - `scripts/monitor-action-execution.sh` - Monitor Firebase data

### Phase 3 (Optional)

5. **AutoRunner Widget** (2 hours)
   - Create `lib/custom_code/widgets/auto_runner_widget.dart`
   - Inject into pages via YAML as OnPageLoad workaround
   - Evaluate if worth the complexity

### Phase 4 (Production)

6. **Deploy to Production**
   - Test all actions in FlutterFlow preview
   - Run `flutter build web`
   - Deploy to hosting
   - Monitor Firebase Analytics and Firestore

7. **Monitor & Iterate**
   - Wait 7 days for first D7 cohort data
   - Review retention metrics
   - Adjust tracking as needed

---

## Testing Checklist

### Pre-Production Testing

- [ ] initializeUserSession fires on HomePage load
- [ ] initializeUserSession fires on Login success
- [ ] initializeUserSession fires on GoldenPath load
- [ ] checkAndLogRecipeCompletion fires on button click
- [ ] All action parameters binding correctly
- [ ] Firestore `user_sessions` collection populating
- [ ] Firestore `user_recipe_completions` collection populating
- [ ] Firebase Analytics events appearing (24-hour delay)
- [ ] No console errors in preview mode
- [ ] Custom Code panel shows 0 compilation errors

### Post-Production Monitoring

- [ ] Cloud Function `calculateD7Retention` runs daily at 2 AM UTC
- [ ] `retention_metrics` collection receiving daily updates
- [ ] D7 Repeat Recipe Rate calculating correctly
- [ ] HTTPS endpoints returning valid data
- [ ] Cloud Functions logs show no errors
- [ ] Firestore indexes performing efficiently (no warnings)

---

## Troubleshooting Reference

Common issues and solutions documented in:
- `docs/MANUAL_PAGE_TRIGGER_WIRING.md` (Section: Troubleshooting)
- Firebase Functions logs: `firebase functions:log --project csc-305-dev-project`
- Firestore console: https://console.firebase.google.com/project/csc-305-dev-project/firestore

---

## Key Learnings

### What Worked

✅ FlutterFlow API for custom action deployment (VS Code Extension alternative)
✅ Direct Firebase deployment with service account credentials
✅ YAML API for app state variable configuration
✅ Comprehensive IAM permission management via gcloud CLI

### What Didn't Work

❌ Playwright UI automation (Shadow DOM incompatibility)
❌ Page-level trigger automation via YAML API (not exposed)
❌ ScrollController parameter type (FlutterFlow limitation)

### Optimal Approach

✅ **Hybrid Strategy:** Manual UI for page triggers + YAML automation for widgets
✅ **Accept Platform Limits:** Work with FlutterFlow's capabilities, not against them
✅ **Document Everything:** Clear guides enable fast one-time manual work
✅ **Automate Where Possible:** Scripts for repeatable widget-level tasks

---

## Cost & Time Analysis

### Development Time Invested

| Phase | Time | Status |
|-------|------|--------|
| Custom Actions (API push) | 2 hours | ✓ Complete |
| Firebase Backend deployment | 4 hours | ✓ Complete |
| IAM permission troubleshooting | 2 hours | ✓ Complete |
| YAML API research | 3 hours | ✓ Complete |
| Automation research (Playwright, etc.) | 4 hours | ✓ Complete |
| Documentation | 3 hours | ✓ Complete |
| **Total** | **18 hours** | **83% Complete** |

### Remaining Work

| Phase | Time | Status |
|-------|------|--------|
| Manual UI wiring | 2 hours | ⏳ Pending |
| YAML schema discovery | 1 hour | ⏳ Pending |
| Automation script creation | 4 hours | ⏳ Future |
| Testing & verification | 2 hours | ⏳ Future |
| **Total** | **9 hours** | **17% Pending** |

**Project Total:** 27 hours (18 complete + 9 pending)

---

## Contacts & Resources

- **FlutterFlow Project:** https://app.flutterflow.io/project/c-s-c305-capstone-khj14l
- **Firebase Console:** https://console.firebase.google.com/project/csc-305-dev-project
- **GitHub Repository:** (Your GitHub URL)
- **Team Lead:** Juan Vallejo (juan_vallejo@uri.edu)
- **Course:** CSC305 Software Development Capstone, URI

---

**Status:** Backend deployment complete. UI wiring requires 2 hours of manual work in FlutterFlow UI. Follow `docs/MANUAL_PAGE_TRIGGER_WIRING.md` to proceed.
