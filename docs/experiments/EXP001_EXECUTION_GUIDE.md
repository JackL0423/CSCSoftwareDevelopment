# EXP-001: DevTools Network Capture - Execution Guide

**Experiment ID:** EXP-001
**Time Budget:** 30 minutes
**Date:** 2025-11-06
**Priority:** Critical (highest probability of success)

---

## Objective

Capture FlutterFlow UI network traffic during manual trigger creation to discover undocumented API endpoints that enable file key generation.

**Pass Criteria:** Find a POST request whose response includes a newly minted file key (format: `id-<8-char-alphanumeric>`).

---

## Pre-Flight Checklist

- [ ] Chrome browser installed
- [ ] Test project accessible: `https://app.flutterflow.io/project/project-test-n8qaal`
- [ ] FlutterFlow account logged in
- [ ] Test project has HomePage with no OnPageLoad trigger yet (or create new page)
- [ ] 30 minutes available (no interruptions)

---

## Step-by-Step Execution

### Phase 1: Setup (5 minutes)

**1. Open Chrome DevTools**
```bash
# Launch Chrome (if not already open)
google-chrome --new-window https://app.flutterflow.io/project/project-test-n8qaal
```

**2. Open DevTools**
- Press `F12` or `Ctrl+Shift+I` (Linux) / `Cmd+Option+I` (Mac)
- Click **Network** tab
- Enable **Preserve log** (checkbox at top)
- Set filter to **Fetch/XHR** only

**3. Clear Network Log**
- Click trash icon (Clear) in Network tab
- Confirm no requests showing

**4. Navigate to Test Project**
- URL: `https://app.flutterflow.io/project/project-test-n8qaal`
- Wait for project to fully load
- Confirm you see HomePage in page tree

---

### Phase 2: Baseline Capture (5 minutes)

**5. Capture Current File List**

Open terminal and run:

```bash
source scripts/common-functions.sh
load_flutterflow_secrets

# Save before state
TEST_PROJECT_ID=$(gcloud secrets versions access latest --secret="TEST_ID_API" --project=csc305project-475802 --account=juan_vallejo@uri.edu)

curl -sS "https://api.flutterflow.io/v2/listPartitionedFileNames?projectId=${TEST_PROJECT_ID}" \
  -H "Authorization: Bearer ${FLUTTERFLOW_LEAD_API_TOKEN}" \
  -H "Content-Type: application/json" \
| jq -r '.value.file_names[]' | sort > /tmp/exp001_before.txt

echo "Before state captured: $(wc -l < /tmp/exp001_before.txt) files"
```

**6. Identify Target Page**

In terminal:
```bash
# Check if HomePage has OnPageLoad trigger already
grep "id-Scaffold_ovus9vp3.*ON_INIT_STATE" /tmp/exp001_before.txt

# If found, use different page or create new one
# If not found, proceed with HomePage
```

**Decision:**
- [ ] HomePage has no trigger → Use HomePage
- [ ] HomePage has trigger → Create new test page "TestPage" in UI first, then return here

---

### Phase 3: Trigger Creation with Traffic Capture (10 minutes)

**7. Clear DevTools Network Log Again**
- Click trash icon to clear any navigation requests
- Confirm clean slate

**8. Navigate to Page in UI**
- In FlutterFlow left sidebar, click **HomePage** (or TestPage)
- Widget tree should appear in main panel

**9. Select Root Widget**
- Click on **Scaffold** widget (root of page tree)
- Properties panel appears on right

**10. Open Actions Tab**
- Click **Actions & Logic** button (lightning bolt icon, usually top-right)
- Wait for actions panel to load

**11. Add OnPageLoad Trigger - START OBSERVATION**

**IMPORTANT:** From this point forward, watch DevTools Network tab closely.

- Click **On Page Load** section (or "+ Add Action" if first trigger)
- A dialog/panel should appear
- **Observe Network Tab:** Any XHR/Fetch requests?

**12. Select Action Type**
- In action selector, choose: **Backend Query** → **Show Snackbar**
- (Simple action, doesn't matter for this test)
- Message: "Test trigger"
- **Observe Network Tab:** Any requests?

**13. Confirm/Save**
- Click **Confirm** or **Save** button
- Wait for UI to indicate save complete (usually green checkmark or toast notification)
- **Observe Network Tab:** Any requests during save?

**14. Wait for Sync**
- Wait 10-15 seconds for FlutterFlow to sync changes
- **Observe Network Tab:** Any additional requests?

---

### Phase 4: Traffic Analysis (10 minutes)

**15. Export HAR File**
- In DevTools Network tab, right-click in request list
- Select "**Save all as HAR with content**"
- Save to: `docs/evidence/devtools-trigger-creation-20251106-HHMMSS.har`
- **Do NOT commit this file yet** (contains auth token)

**16. Quick Visual Scan**

In DevTools, look for suspicious requests:

**What to look for:**
- Request URL contains: `createTrigger`, `addAction`, `createAction`, `mutate`, `action`, `trigger`
- Request Method: **POST** or **PUT**
- Status: **200 OK** or **201 Created**
- Response Preview contains: `id-` followed by 8 alphanumeric characters

**17. Capture After State**

In terminal:
```bash
# Save after state
curl -sS "https://api.flutterflow.io/v2/listPartitionedFileNames?projectId=${TEST_PROJECT_ID}" \
  -H "Authorization: Bearer ${FLUTTERFLOW_LEAD_API_TOKEN}" \
  -H "Content-Type: application/json" \
| jq -r '.value.file_names[]' | sort > /tmp/exp001_after.txt

echo "After state captured: $(wc -l < /tmp/exp001_after.txt) files"

# Diff to find new file keys
echo ""
echo "=== New File Keys (If Any) ==="
diff /tmp/exp001_before.txt /tmp/exp001_after.txt | grep "^>" | sed 's/^> //'

echo ""
echo "=== New Trigger Actions (Expected) ==="
diff /tmp/exp001_before.txt /tmp/exp001_after.txt | grep "^>" | grep "trigger_actions"
```

**Expected Output:**
```
> page/id-Scaffold_ovus9vp3/page-widget-tree-outline/node/id-Scaffold_ovus9vp3/trigger_actions/id-ON_INIT_STATE/action/id-XXXXXXXX
```

**Note the action ID:** `id-XXXXXXXX` (8 characters)

---

### Phase 5: HAR Analysis (15 minutes if needed)

**18. Run HAR Analysis Script**

```bash
# Analyze HAR file for interesting endpoints
bash scripts/analyze-har.sh docs/evidence/devtools-trigger-creation-20251106-*.har
```

(Script will be created below)

**19. Manual HAR Inspection**

Open HAR file in text editor:
```bash
jq . docs/evidence/devtools-trigger-creation-20251106-*.har > /tmp/exp001_har_pretty.json
nano /tmp/exp001_har_pretty.json
```

**Search for (Ctrl+W in nano):**
- Search 1: The action ID from step 17 (`id-XXXXXXXX`)
- Search 2: `"method": "POST"`
- Search 3: `trigger_actions`
- Search 4: `ON_INIT_STATE`

**Look for:**
- Request that mentions the new action ID
- Request sent BEFORE action ID appeared in file list
- Response that contains the action ID for the first time

---

## Expected Outcomes

### Outcome A: PASS (Best Case)

**Found:** POST request to undocumented endpoint (e.g., `/v2/internal/createTriggerAction`, `/v2/mutations/addAction`)

**Response contains:**
```json
{
  "success": true,
  "actionId": "id-XXXXXXXX",
  "fileKey": "page/.../trigger_actions/id-ON_INIT_STATE/action/id-XXXXXXXX"
}
```

**Next Steps:**
1. Document endpoint in EXPERIMENTS.md and BLUEPRINT.md
2. Test endpoint programmatically (create script to call it)
3. If successful, integrate into automation workflows
4. **Result: 100% automation achieved**

---

### Outcome B: WEAK PASS (Good Case)

**Found:** POST request to `/v2/updateProjectByYaml` with file key that DID NOT exist before

**Implication:** File key was generated elsewhere (possibly on page creation, not trigger creation)

**Next Steps:**
1. Repeat experiment with new page creation (capture when page created, not just trigger)
2. Look for page creation endpoint
3. If found, automate page creation → inherit trigger file keys

---

### Outcome C: FAIL (Expected Case)

**Found:** Only `/v2/updateProjectByYaml` requests with file keys that already existed

**Implication:** File keys pre-generated during page creation (earlier step)

**Next Steps:**
1. Mark EXP-001 as FAIL in EXPERIMENTS.md
2. Proceed to EXP-002 (Template Duplication) tomorrow
3. Fallback to EXP-003 (Seeding Manifest) if EXP-002 also fails

---

### Outcome D: BLOCKED (Troubleshooting Needed)

**Issue:** No new file keys appeared in after state (step 17 diff was empty)

**Possible Causes:**
- Trigger save failed in UI (check for error messages)
- Network lag (wait 60 seconds, re-run step 17)
- Test project permission issue

**Troubleshooting:**
1. Verify in UI: Does trigger show in Actions panel?
2. Re-run: `listPartitionedFileNames` after 1 minute
3. Try with different page or different trigger type
4. Check FlutterFlow UI for error messages

---

## Recording Results

**20. Update EXPERIMENTS.md**

```bash
nano docs/EXPERIMENTS.md
```

Find "EXP-001" section, update **Results** subsection:

```markdown
### Results

**Status:** Complete
**Completion Date:** 2025-11-06 HH:MM:SS
**Time Spent:** XX minutes
**Outcome:** PASS / WEAK PASS / FAIL / BLOCKED

**Findings:**
- [Describe what you found]
- [List any new endpoints discovered]
- [Include request/response samples]

**New File Keys Created:**
- page/.../action/id-XXXXXXXX (action ID: XXXXXXXX)

**API Requests Observed:**
- POST /v2/updateProjectByYaml (known endpoint)
- POST /v2/??? (if new endpoint found)

**Next Steps:**
- [What to do based on outcome]
```

**21. Redact HAR File**

```bash
# Redact authorization token before committing
bash scripts/redact-har.sh docs/evidence/devtools-trigger-creation-20251106-*.har
```

(Script will be created below)

**22. Commit Evidence**

```bash
git add docs/evidence/devtools-trigger-creation-*-REDACTED.har
git add docs/EXPERIMENTS.md
git commit -m "exp: Complete EXP-001 DevTools network capture

- Captured traffic during manual trigger creation
- Outcome: [PASS/FAIL]
- [Brief summary of findings]
- Evidence: HAR file (redacted)

Refs: EXP-001, EXPERIMENTS.md"
```

---

## Time Tracking

**Actual Time Breakdown:**

| Phase | Planned | Actual | Notes |
|-------|---------|--------|-------|
| Setup | 5 min | ___ min | |
| Baseline | 5 min | ___ min | |
| Capture | 10 min | ___ min | |
| Analysis | 10 min | ___ min | |
| **Total** | **30 min** | **___ min** | |

---

## Safety Notes

- **Low Risk:** Read-only observation, no modifications to production project
- **Test Project:** Using `project-test-n8qaal`, not production
- **Auth Token:** Redact from HAR before committing
- **Reversible:** Can delete test trigger after experiment

---

## Questions During Execution?

**Issue:** DevTools not showing XHR requests
- **Fix:** Ensure "Fetch/XHR" filter is selected, not "All"

**Issue:** Too many requests, can't find relevant ones
- **Fix:** Clear log before step 11, only capture during action creation

**Issue:** HAR file too large (>10MB)
- **Fix:** Only save requests after clearing log at step 11

**Issue:** Can't find action ID in HAR
- **Fix:** Action ID might be generated server-side, not visible in response (expected)

---

## Success Criteria Reminder

**Strong Pass:** Find POST request with new file key in response
**Weak Pass:** Find request that appears to be create/mutation
**Fail:** Only see updateProjectByYaml with pre-existing keys

**Any outcome is valuable data.**

---

**End of Execution Guide**

*Start timer when beginning Phase 1. Good luck!*
