## Testing guide: retention metrics and analytics

This guide shows how to seed realistic data, observe Analytics in real time, and verify the D7 retention metric end to end.

### Prerequisites

- Firebase project: [FIREBASE_PROJECT_ID]
- Service account JSON with Firebase Admin permissions
  - Export path as: `export GOOGLE_APPLICATION_CREDENTIALS=/abs/path/service-account.json`
- Tools installed: Node 18+, npm, jq, firebase-tools, adb (for Android), curl

### 1) Create test Authentication users (optional)

Creates 20 users test_user_001..020@example.com with a common password.

```
scripts/create-test-users.sh --count 20 --domain example.com --password 'TestPass123!'
```

Outputs seeded_test_users.json with emails and UIDs.

### 2) Seed Firestore test data

Seeds user docs and user_recipe_completions across the last 7 days using a 70/20/10 distribution (none/repeat/power users):

```
scripts/seed-test-data.sh --users 20 --days 7
```

Writes doc timestamps for D0 (always) and additional completions for D1-D7 based on the distribution.

### 3) Build and run the app (optional)

Build a debug APK and enable Analytics debug mode for the package (Android):

```
cd c_s_c305_capstone
flutter build apk --debug
../scripts/enable-analytics-debug.sh com.mycompany.csc305capstone
../scripts/run-apk-local.sh build/app/outputs/flutter-apk/app-debug.apk
```

### 4) Observe Analytics live

Tail device logs for Analytics initialization and events:

```
scripts/tail-analytics.sh
```

Open DebugView in Firebase Console:

- https://console.firebase.google.com/project/[FIREBASE_PROJECT_ID]/analytics/debugview

Expected events: `session_start` (from initializeUserSession), `recipe_complete` (from checkAndLogRecipeCompletion).

### 5) Verify metrics path end-to-end

Run the automation to check Firestore, Analytics, and Functions:

```
scripts/verify-metrics-flow.sh --cohort-date YYYY-MM-DD --report
```

Outputs a summary similar to:

- ✅ Firestore: 15 users, 42 completions
- ✅ Analytics: Events observed in logcat sample
- ✅ Cloud Functions: Response OK (rate=23.5%)

### 6) Optional: Simulate Analytics via Measurement Protocol

If you have GA4 Measurement credentials (MEASUREMENT_ID and API_SECRET) and an APP_INSTANCE_ID from a device, you can push synthetic events:

```
export MEASUREMENT_ID=G-XXXXXXX
export API_SECRET=your_secret
export APP_INSTANCE_ID=from_device
scripts/simulate-analytics-events.sh --events 100 --days 7 --debug
```

Review events in DebugView. Prefer validating on-device due to app streams requiring a real app_instance_id.

### Troubleshooting

- DebugView not showing events
  - Ensure `enable-analytics-debug.sh` ran and device shows as connected (green dot)
  - Verify `google-services.json` is present and matches the dev project
  - Check logcat for Firebase initialization warnings

- Cloud Function returns empty metrics
  - Ensure Firestore has recent `user_recipe_completions`
  - Wait for the scheduled aggregation or call the manual function if available
  - Check function logs in Cloud Console

- Scripts fail with auth errors
  - Confirm `GOOGLE_APPLICATION_CREDENTIALS` points to a valid service account JSON
  - Ensure the SA has Firestore (Datastore Owner/Editor) and Firebase Admin API permissions
