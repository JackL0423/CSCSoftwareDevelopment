# Quick Start: Run EXP-001 Now

**Time:** 30 minutes
**Objective:** Discover file key creation endpoint
**Potential Outcome:** Unlock 100% automation

---

## What You're About To Do

Capture network traffic while manually adding a trigger in FlutterFlow UI. Look for undocumented API endpoints that create file keys.

---

## Prerequisites (2 minutes)

```bash
# 1. Verify tools installed
curl --version | head -1
jq --version
google-chrome --version

# 2. Load secrets
source scripts/common-functions.sh
load_flutterflow_secrets

# 3. Confirm test project accessible
TEST_PROJECT_ID=$(gcloud secrets versions access latest --secret="TEST_ID_API" --project=csc305project-475802 --account=juan_vallejo@uri.edu)
echo "Test Project: $TEST_PROJECT_ID"
echo "URL: https://app.flutterflow.io/project/$TEST_PROJECT_ID"
```

---

## Execute (30 minutes)

### Option A: Follow Detailed Guide

```bash
# Open the comprehensive execution guide
cat docs/EXP001_EXECUTION_GUIDE.md

# Or open in browser
xdg-open docs/EXP001_EXECUTION_GUIDE.md
```

### Option B: Quick Steps (Experienced Users)

**1. Capture Before State (2 min)**
```bash
curl -sS "https://api.flutterflow.io/v2/listPartitionedFileNames?projectId=${TEST_PROJECT_ID}" \
  -H "Authorization: Bearer ${FLUTTERFLOW_LEAD_API_TOKEN}" \
| jq -r '.value.file_names[]' | sort > /tmp/exp001_before.txt
```

**2. Open Chrome with DevTools (3 min)**
- Navigate to: `https://app.flutterflow.io/project/${TEST_PROJECT_ID}`
- Press F12, go to Network tab
- Filter: Fetch/XHR only
- Enable: Preserve log

**3. Add Trigger in UI (10 min)**
- Click HomePage in page tree
- Select Scaffold widget
- Click "Actions & Logic"
- Add "On Page Load" → "Show Snackbar"
- Save
- **OBSERVE NETWORK TAB FOR ALL REQUESTS**

**4. Export HAR (2 min)**
- Right-click in Network tab → "Save all as HAR with content"
- Save to: `docs/evidence/devtools-trigger-creation-20251106-$(date +%H%M%S).har`

**5. Capture After State (2 min)**
```bash
curl -sS "https://api.flutterflow.io/v2/listPartitionedFileNames?projectId=${TEST_PROJECT_ID}" \
  -H "Authorization: Bearer ${FLUTTERFLOW_LEAD_API_TOKEN}" \
| jq -r '.value.file_names[]' | sort > /tmp/exp001_after.txt

# Show new file keys
diff /tmp/exp001_before.txt /tmp/exp001_after.txt | grep "^>" | grep "trigger_actions"
```

**6. Analyze HAR (10 min)**
```bash
bash scripts/analyze-har.sh docs/evidence/devtools-trigger-creation-*.har | less
```

**7. Redact & Commit (3 min)**
```bash
bash scripts/redact-har.sh docs/evidence/devtools-trigger-creation-*.har

git add docs/evidence/*-REDACTED.har
git add docs/EXPERIMENTS.md  # After updating results
git commit -m "exp: Complete EXP-001 DevTools capture"
```

---

## What To Look For

### PASS Criteria

Find POST request with response containing:
```json
{
  "actionId": "id-abc12345",
  "fileKey": "page/.../trigger_actions/.../action/id-abc12345"
}
```

OR

Request URL like:
- `/v2/createTrigger`
- `/v2/addAction`
- `/v2/generateFileKey`
- `/v2/mutations/...`

### FAIL Criteria

Only see:
- `/v2/updateProjectByYaml` with pre-existing file keys
- No POST requests during trigger creation
- File keys appeared but not visible in any request/response

---

## After Experiment

### If PASS:
```bash
# Document new endpoint
nano docs/FLUTTERFLOW_AUTOMATION_BLUEPRINT.md
# Add to Section 2.2 (API Endpoints)

# Test endpoint programmatically
nano scripts/test-create-endpoint.sh
# Try calling discovered endpoint with curl

# Update EXPERIMENTS.md
# Mark EXP-001 as PASS, document findings
```

### If FAIL:
```bash
# Update EXPERIMENTS.md
nano docs/EXPERIMENTS.md
# Mark EXP-001 as FAIL, document what was NOT found

# Schedule EXP-002 for tomorrow
# Template duplication analysis (20 min)
```

---

## Troubleshooting

**No network requests captured**
- Ensure "Preserve log" enabled
- Ensure "Fetch/XHR" filter selected
- Try adding a different action type

**No new file keys in diff**
- Wait 60 seconds, retry `listPartitionedFileNames`
- Check FlutterFlow UI for error messages
- Verify trigger actually saved (visible in UI)

**HAR file too large (>50MB)**
- Only capture from step 3 onwards (clear log before trigger creation)
- Export only relevant time window

**Can't find action ID in HAR**
- Expected if generated server-side
- Still look for creation-related endpoints
- Check request URLs and methods

---

## Time Estimate

| Task | Time |
|------|------|
| Prerequisites | 2 min |
| Before capture | 2 min |
| DevTools setup | 3 min |
| UI interaction | 10 min |
| HAR export | 2 min |
| After capture | 2 min |
| HAR analysis | 10 min |
| Documentation | 5 min |
| **Total** | **36 min** |

---

## Success Metrics

**Any outcome is valuable:**
- PASS: Discovered new endpoint → Implement immediately
- FAIL: Confirmed no create endpoint → Move to EXP-002
- BLOCKED: Technical issue → Troubleshoot, retry

**This experiment cannot hurt the automation:**
- Worst case: No new information (proceed to next experiment)
- Best case: 100% automation unlocked today

---

## Questions?

**"Should I use production or test project?"**
→ **Test project** (`project-test-n8qaal`). Safer, cleaner baseline.

**"What if I see dozens of requests?"**
→ Focus on POST requests to `/v2/` endpoints. Ignore asset loading, analytics.

**"Do I need to understand the HAR file format?"**
→ No. The analyze-har.sh script does the heavy lifting. Just look for NEW endpoints.

**"What if the experiment takes longer than 30 min?"**
→ Time-box strictly. If not done in 40 min, stop and document progress. Move to EXP-002.

---

## Ready?

**Start now:**
```bash
# 1. Load secrets
source scripts/common-functions.sh
load_flutterflow_secrets

# 2. Open execution guide in parallel
cat docs/EXP001_EXECUTION_GUIDE.md

# 3. Start timer
date && echo "EXP-001 Started"
```

**OR schedule for later:**
- Best time: When you have uninterrupted 30-40 minutes
- Browser: Chrome/Chromium (Firefox DevTools work but different UI)
- Environment: Quiet, focused

---

**Good luck! This could be the breakthrough.**

*Last Updated: 2025-11-06 06:00 UTC*
