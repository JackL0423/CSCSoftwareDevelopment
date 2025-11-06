# FlutterFlow Automation Experiments

**Purpose:** Track time-boxed experiments to unlock 100% automation
**Primary Goal:** Discover method to create trigger/action file keys programmatically
**Success Criteria:** Find technique to eliminate manual UI seeding (5-10 min per page)

---

## Experiment Status Overview

| Priority | Experiment | Status | Result | Time Spent | Completion Date |
|----------|-----------|--------|--------|------------|-----------------|
| 1 | DevTools Network Capture | Pending | - | 0/30 min | Target: 2025-11-06 |
| 2 | Template Project Duplication | Pending | - | 0/20 min | Target: 2025-11-07 |
| 3 | Seeding Manifest Automation | Pending | - | 0/30 min | Target: 2025-11-07 |
| 4 | VS Code Extension Decompilation | Pending | - | 0/60 min | Target: 2025-11-08 |
| 5 | `/l/listProjects` Endpoint Test | Pending | - | 0/15 min | Target: 2025-11-08 |
| 6 | Batch Update with Wildcards | Pending | - | 0/20 min | Target: 2025-11-08 |
| 7 | API Key Permissions Test | Pending | - | 0/30 min | Target: 2025-11-09 |

**Legend:**
- Status: Pending | In Progress | Complete | Failed
- Result: Pass | Fail | Inconclusive | Blocked

---

## Priority 1: DevTools Network Capture

**Experiment ID:** EXP-001
**Status:** Pending
**Priority:** Critical (highest probability of success)
**Time Budget:** 30 minutes
**Assigned:** Automation Lead
**Target Date:** 2025-11-06 18:00

### Hypothesis

FlutterFlow UI makes undocumented API calls when creating triggers. Network trace will reveal create endpoints or file key generation parameters.

### Background

Current blocker: API can update existing file keys but cannot create new ones. If UI uses a create endpoint, we can replicate it programmatically.

### Method

**Setup (5 min):**
1. Open Chrome DevTools (F12)
2. Navigate to Network tab
3. Filter: XHR/Fetch only
4. Enable "Preserve log"
5. Navigate to test-project in FlutterFlow UI: `https://app.flutterflow.io/project/project-test-n8qaal`

**Execution (15 min):**
1. Clear network log
2. Navigate to HomePage in UI
3. Select Scaffold widget
4. Click "Actions & Logic" tab
5. Click "On Page Load" trigger
6. Add action: "Show Snackbar" with message "Test"
7. Click "Confirm" to save
8. Wait for UI to confirm save

**Data Collection (5 min):**
1. Stop network recording
2. Export HAR file: Right-click → "Save all as HAR with content"
3. Save to: `docs/evidence/devtools-trigger-creation-20251106.har`
4. Redact authorization tokens before committing

**Analysis (5 min):**
1. Search HAR for keywords:
   - `createTrigger`
   - `addAction`
   - `createAction`
   - `mutate`
   - File key pattern: `id-ON_INIT_STATE`
   - New file key value (not present before test)

2. Analyze suspicious requests:
   - Request method (POST likely)
   - Endpoint path
   - Payload structure (JSON)
   - Response body (does it include new file key?)

### Pass Criteria

**Strong Pass:** Find a POST request whose response includes a newly minted file key (format: `id-<8-char-alphanumeric>`) that was not present before the operation.

**Weak Pass:** Find a request that appears to be a create/mutation operation with suggestive naming (even if file key not visible in response).

### Fail Criteria

**Fail:** No new API endpoints observed beyond the 6 we already know (`/v2/listPartitionedFileNames`, `/v2/projectYamls`, `/v2/validateProjectYaml`, `/v2/updateProjectByYaml`, `/v2/syncCustomCodeChanges`, `/v2/l/listProjects`).

### Expected Outcome

**Most Likely:** Find that UI calls `/v2/updateProjectByYaml` with a file key that already exists (file key pre-generated on page creation).

**Best Case:** Discover undocumented endpoint like `/v2/createTriggerAction` or `/v2/generateFileKey`.

**Worst Case:** UI uses websocket or encrypted channel we cannot inspect.

### Risks

- Low risk: Read-only observation, no modifications
- Network trace may not capture all traffic if FlutterFlow uses websockets
- File key generation might happen server-side without client visibility

### Output Deliverables

- HAR file: `docs/evidence/devtools-trigger-creation-20251106.har` (redacted)
- Analysis summary: Update this section with findings
- If pass: Document new endpoint in FLUTTERFLOW_AUTOMATION_BLUEPRINT.md
- If fail: Update with negative result and move to next experiment

### Results

**Status:** Not started
**Completion Date:** -
**Time Spent:** 0 minutes
**Outcome:** -
**Findings:** -
**Next Steps:** -

---

## Priority 2: Template Project Duplication Analysis

**Experiment ID:** EXP-002
**Status:** Pending
**Priority:** High (could enable template-based automation)
**Time Budget:** 20 minutes
**Assigned:** Automation Lead
**Target Date:** 2025-11-07 12:00

### Hypothesis

Duplicating a page with existing triggers generates new file keys in a predictable, deterministic manner. If we can identify the pattern, we can generate valid file keys mathematically.

### Background

FlutterFlow UI has "Duplicate Page" feature. When duplicating, it must generate new file keys for all widgets and triggers. If this follows a pattern (e.g., original key + suffix, incremental IDs), we might predict new keys.

### Method

**Setup (3 min):**
1. Navigate to test-project in FlutterFlow UI
2. Confirm HomePage has OnPageLoad trigger (created in EXP-001 or manually if needed)
3. Download baseline file list:
   ```bash
   curl -sS "https://api.flutterflow.io/v2/listPartitionedFileNames?projectId=$(gcloud secrets versions access latest --secret="TEST_ID_API" --project=csc305project-475802 --account=juan_vallejo@uri.edu)" \
     -H "Authorization: Bearer $(gcloud secrets versions access latest --secret="FLUTTERFLOW_LEAD_API_TOKEN" --project=csc305project-475802 --account=juan_vallejo@uri.edu)" \
   | jq -r '.value.file_names[]' | sort > /tmp/files_before.txt
   ```

**Execution (5 min):**
1. In FlutterFlow UI, right-click HomePage
2. Select "Duplicate Page"
3. Name it "HomePageCopy"
4. Wait for duplication to complete

**Data Collection (5 min):**
1. Download updated file list:
   ```bash
   curl -sS ... | jq -r '.value.file_names[]' | sort > /tmp/files_after.txt
   ```

2. Diff the files:
   ```bash
   diff /tmp/files_before.txt /tmp/files_after.txt > /tmp/duplication_diff.txt
   cat /tmp/duplication_diff.txt
   ```

3. Identify all new file keys (lines starting with `>` in diff)

**Analysis (7 min):**
1. Extract HomePage file keys from before list:
   ```bash
   grep "id-Scaffold_ovus9vp3" /tmp/files_before.txt > /tmp/homepage_keys.txt
   ```

2. Extract HomePageCopy file keys from after list:
   ```bash
   # Identify the new page's Scaffold ID from diff
   NEW_PAGE_ID=$(grep "> page/id-Scaffold_" /tmp/duplication_diff.txt | head -1 | sed 's/.*id-Scaffold_\([^/]*\).*/\1/')
   echo "New page ID: $NEW_PAGE_ID"
   grep "id-Scaffold_${NEW_PAGE_ID}" /tmp/files_after.txt > /tmp/homepa gecopy_keys.txt
   ```

3. Compare structures:
   - Are file key formats identical (same path depth)?
   - Are 8-char keys sequential, derived, or random?
   - Is trigger structure copied identically?

4. Check for patterns:
   - Original trigger: `...action/id-gfsh0n1r`
   - New trigger: `...action/id-XXXXXXXX`
   - Relationship between `gfsh0n1r` and `XXXXXXXX`?

### Pass Criteria

**Strong Pass:** Deterministic relationship discovered (e.g., "New key = hash(original_key + page_id)", "New key = original_key + 1", "New key = original_key with suffix '_copy'").

**Weak Pass:** File keys are different but duplication preserves trigger structure perfectly. Even if keys are random, confirms duplication API exists.

### Fail Criteria

**Fail:** File keys are completely random with no discernible pattern, OR duplication doesn't copy triggers at all.

### Expected Outcome

**Most Likely:** File keys are random, but duplication operation is exposed via API (might find endpoint in DevTools during duplication).

**Best Case:** Keys follow predictable pattern, we can generate valid keys mathematically.

**Worst Case:** Duplication is UI-only, no API equivalent.

### Risks

- Low risk: Test project only, can delete HomePageCopy afterward
- Duplication might not work if HomePage is incomplete
- Pattern might be complex (cryptographic hash, server-side state)

### Output Deliverables

- File list diffs: `/tmp/duplication_diff.txt`
- Analysis notes: Update this section
- If pass: Document duplication API endpoint (if discovered) and key generation pattern
- If fail: Confirm randomness, document negative result

### Results

**Status:** Not started
**Completion Date:** -
**Time Spent:** 0 minutes
**Outcome:** -
**Findings:** -
**Next Steps:** -

---

## Priority 3: Seeding Manifest Automation

**Experiment ID:** EXP-003
**Status:** Pending
**Priority:** High (fallback if file key creation cannot be automated)
**Time Budget:** 30 minutes
**Assigned:** Automation Lead
**Target Date:** 2025-11-07 18:00

### Hypothesis

Even if file key creation cannot be fully automated, we can create a streamlined seeding workflow that:
1. Guides a human through minimal UI clicks
2. Automatically captures newly created file keys via API
3. Saves to `file_key_registry.json` for subsequent automation use

Target: Reduce seeding time from 5-10 min/page to <2 min/page.

### Background

Current manual workflow: Navigate UI, click through multiple menus, add dummy actions, manually note file keys. Slow and error-prone.

Improved workflow: Script generates direct URLs to FlutterFlow UI locations, human clicks "Add Action", script auto-detects new file key.

### Method

**Setup (5 min):**
1. Create `scripts/seed-file-keys.sh`
2. Create test manifest:
   ```json
   {
     "project_id": "project-test-n8qaal",
     "pages": [
       {"name": "HomePage", "scaffold_id": "ovus9vp3", "triggers": ["ON_INIT_STATE"]},
       {"name": "Page2", "scaffold_id": "xyz123", "triggers": ["ON_INIT_STATE", "ON_PAGE_EXIT"]}
     ]
   }
   ```

**Script Implementation (10 min):**

```bash
#!/bin/bash
# scripts/seed-file-keys.sh

PROJECT_ID="$1"
MANIFEST_FILE="$2"

# Initialize output registry
REGISTRY_FILE="file_key_registry.json"
echo '{"file_keys": []}' > "$REGISTRY_FILE"

# Read manifest
PAGES=$(jq -r '.pages[] | @base64' "$MANIFEST_FILE")

for PAGE in $PAGES; do
  PAGE_DATA=$(echo "$PAGE" | base64 -d)
  PAGE_NAME=$(echo "$PAGE_DATA" | jq -r '.name')
  SCAFFOLD_ID=$(echo "$PAGE_DATA" | jq -r '.scaffold_id')
  TRIGGERS=$(echo "$PAGE_DATA" | jq -r '.triggers[]')

  echo "=== Seeding ${PAGE_NAME} ==="

  for TRIGGER in $TRIGGERS; do
    # Capture file list before
    curl -sS "https://api.flutterflow.io/v2/listPartitionedFileNames?projectId=${PROJECT_ID}" \
      -H "Authorization: Bearer ${TOKEN}" \
    | jq -r '.value.file_names[]' | sort > /tmp/before_${TRIGGER}.txt

    # Generate direct URL to trigger in FlutterFlow UI
    URL="https://app.flutterflow.io/project/${PROJECT_ID}/page/id-Scaffold_${SCAFFOLD_ID}?tab=actions&trigger=${TRIGGER}"
    echo "Please open this URL and add a dummy action:"
    echo "  $URL"
    echo ""
    echo "After adding the action and saving, press ENTER to continue..."
    read -r

    # Capture file list after
    curl -sS "https://api.flutterflow.io/v2/listPartitionedFileNames?projectId=${PROJECT_ID}" \
      -H "Authorization: Bearer ${TOKEN}" \
    | jq -r '.value.file_names[]' | sort > /tmp/after_${TRIGGER}.txt

    # Diff to find new file key
    NEW_KEY=$(diff /tmp/before_${TRIGGER}.txt /tmp/after_${TRIGGER}.txt | grep "^> .*trigger_actions/id-${TRIGGER}" | sed 's/^> //')

    if [ -n "$NEW_KEY" ]; then
      echo "[SUCCESS] Captured file key: $NEW_KEY"
      # Save to registry
      jq ".file_keys += [{\"page\": \"${PAGE_NAME}\", \"trigger\": \"${TRIGGER}\", \"file_key\": \"${NEW_KEY}\"}]" "$REGISTRY_FILE" > /tmp/registry.json && mv /tmp/registry.json "$REGISTRY_FILE"
    else
      echo "[FAIL] No new file key detected. Please try again."
    fi

    echo ""
  done
done

echo "=== Seeding complete ==="
echo "File key registry saved to: $REGISTRY_FILE"
cat "$REGISTRY_FILE"
```

**Execution (10 min):**
1. Run script with test manifest (2 pages, 3 triggers total)
2. Follow prompts, add dummy actions in UI
3. Measure time per page

**Analysis (5 min):**
1. Calculate time per page: Total time / number of pages
2. Verify all file keys captured correctly
3. Test registry: Can subsequent automation use these keys?

### Pass Criteria

**Strong Pass:** Seeding workflow takes ≤2 minutes per page (down from 5-10 min). 100% of file keys captured correctly.

**Weak Pass:** Workflow is faster than pure manual (≤4 min/page) and reduces errors.

### Fail Criteria

**Fail:** Workflow is not significantly faster, or file key capture is unreliable (<90% success rate).

### Expected Outcome

**Most Likely:** Pass. Workflow streamlines seeding, makes it tolerable for small projects (≤20 pages = ≤40 min one-time).

**Best Case:** Strong pass. Combined with file_key_registry.json, achieves 95%+ automation acceptance.

### Risks

- Low risk: Script is interactive, human controls all UI actions
- URL generation might not work if FlutterFlow UI structure changes
- Timing issue: API might not immediately reflect new file keys (may need sleep/retry)

### Output Deliverables

- Script: `scripts/seed-file-keys.sh`
- Test registry: `file_key_registry.json`
- Time measurements: Update this section
- If pass: Recommend adoption as fallback strategy
- If fail: Document why workflow is not effective

### Results

**Status:** Not started
**Completion Date:** -
**Time Spent:** 0 minutes
**Outcome:** -
**Findings:** -
**Next Steps:** -

---

## Priority 4: VS Code Extension Decompilation

**Experiment ID:** EXP-004
**Status:** Pending
**Priority:** Medium (exploratory, may reveal undocumented APIs)
**Time Budget:** 60 minutes
**Assigned:** Tools Engineer
**Target Date:** 2025-11-08 18:00

### Hypothesis

The FlutterFlow VS Code Extension can add custom actions programmatically. It likely uses undocumented API endpoints or has elevated authentication permissions that we can replicate.

### Background

VS Code Extension allows developers to add custom Dart actions to FlutterFlow projects directly from VS Code. This creates file keys. If we understand how, we might replicate it.

### Method

**Setup (10 min):**
1. Download FlutterFlow VS Code Extension:
   - Visit: https://marketplace.visualstudio.com/items?itemName=FlutterFlow.flutterflow-extension
   - Click "Download Extension" (`.vsix` file)
   - Save to: `/tmp/flutterflow-extension.vsix`

2. Extract `.vsix` (it's a ZIP):
   ```bash
   cd /tmp
   unzip flutterflow-extension.vsix -d flutterflow-extension
   cd flutterflow-extension
   ```

**Code Inspection (30 min):**
1. Find main extension code:
   ```bash
   find . -name "*.js" -o -name "*.ts" | head -20
   cat extension.js  # Or main TypeScript file
   ```

2. Search for API endpoint strings:
   ```bash
   grep -r "api.flutterflow.io" .
   grep -r "/v2/" .
   grep -r "createTrigger\|createAction\|addAction" .
   grep -r "Authorization" .
   ```

3. Look for authentication logic:
   - How does Extension get API token?
   - Is it different from Growth Plan API key?
   - Are there additional headers or permissions?

4. Identify custom action addition workflow:
   - Search for functions related to "add action", "create action"
   - Trace API calls from UI action to network request

**Network Traffic Capture (15 min):**
1. Install Extension in VS Code
2. Open FlutterFlow-connected project
3. Use Wireshark or Charles Proxy to capture traffic
4. Add a custom action via Extension
5. Analyze captured requests:
   - Endpoint URL
   - Request method and headers
   - Payload structure

**Analysis (5 min):**
1. Compare Extension's API calls to our known endpoints
2. Identify any new/undocumented endpoints
3. Check if authentication is different (OAuth vs API key)

### Pass Criteria

**Strong Pass:** Discover undocumented endpoint(s) that enable file key creation (e.g., `/v2/internal/createTriggerKey`).

**Weak Pass:** Find that Extension uses elevated permissions (different auth token) that we can request from FlutterFlow support.

### Fail Criteria

**Fail:** Extension uses same endpoints we already know, no new insights. OR Extension code is heavily obfuscated/minified, impossible to analyze.

### Expected Outcome

**Most Likely:** Extension uses `/v2/syncCustomCodeChanges` (which we already use) and `/v2/updateProjectByYaml`. File keys are still UI-generated.

**Best Case:** Find internal/admin endpoint that we can call with proper authentication.

**Worst Case:** Code is obfuscated, network traffic is encrypted or uses proprietary protocol.

### Risks

- Low risk: Extension is publicly distributed, decompilation is legal for research
- Time risk: If heavily obfuscated, 60 min may not be enough
- May require VS Code setup if not already installed

### Output Deliverables

- Decompilation notes: Update this section with findings
- Network capture (if performed): `docs/evidence/vscode-extension-traffic.har`
- If pass: Document new endpoint(s) in FLUTTERFLOW_AUTOMATION_BLUEPRINT.md
- If fail: Document negative result, confirm Extension uses known APIs

### Results

**Status:** Not started
**Completion Date:** -
**Time Spent:** 0 minutes
**Outcome:** -
**Findings:** -
**Next Steps:** -

---

## Additional Experiments (Lower Priority)

### EXP-005: `/l/listProjects` Endpoint Test

**Time Budget:** 15 minutes
**Target:** 2025-11-08

Test undocumented `/l/listProjects` endpoint. May reveal project structure or metadata API that includes file key generation info.

### EXP-006: Batch Update with Wildcards

**Time Budget:** 20 minutes
**Target:** 2025-11-08

Test if `fileKeyToContent` accepts wildcard patterns:
```json
{
  "fileKeyToContent": {
    "page/*/trigger_actions/id-ON_INIT_STATE/action/*": "..."
  }
}
```

If wildcards work, might enable mass creation.

### EXP-007: API Key Permissions Test

**Time Budget:** 30 minutes
**Target:** 2025-11-09

Generate multiple API keys in FlutterFlow settings. Test if different keys have different scopes (read-only vs admin, etc.). One key might have create permissions.

---

## Experiment Decision Tree

```
Start: File key creation blocker

├─ EXP-001 (DevTools) → PASS?
│  ├─ Yes: Document endpoint, implement automation
│  └─ No: Continue to EXP-002

├─ EXP-002 (Duplication) → PASS?
│  ├─ Yes: Implement template-based automation
│  └─ No: Continue to EXP-003

├─ EXP-003 (Seeding Manifest) → PASS?
│  ├─ Yes: Adopt as fallback, achieve 95%+ automation
│  └─ No: Continue to EXP-004

├─ EXP-004 (VS Code Extension) → PASS?
│  ├─ Yes: Implement discovered endpoints
│  └─ No: Run EXP-005, EXP-006, EXP-007

└─ All Fail → DECISION: Accept manual seeding (EXP-003 workflow) OR investigate alternative platforms
```

---

## Success Metrics

**Experiment Phase Success:** At least 1 experiment passes with actionable solution.

**Target Outcomes:**
- **Best:** EXP-001 or EXP-004 reveals create endpoint → 100% automation achieved
- **Good:** EXP-002 enables template-based automation → 98% automation, minimal seeding
- **Acceptable:** EXP-003 streamlines seeding → 95% automation with <30 min one-time seeding

**Failure Threshold:** All 7 experiments fail → Escalate to Project Lead for platform decision (stay with FlutterFlow vs migrate).

---

## Version History

| Date | Version | Changes |
|------|---------|---------|
| 2025-11-06 | 1.0 | Initial experiment tracker with 7 time-boxed experiments, pass/fail criteria, and decision tree |

---

**Next Update:** After each experiment completion

---

**End of Experiments Tracker**
