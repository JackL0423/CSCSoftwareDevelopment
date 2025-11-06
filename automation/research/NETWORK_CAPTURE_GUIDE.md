# Network Capture Guide - FlutterFlow Trigger Wiring

**Purpose**: Capture HTTP requests that FlutterFlow UI makes when wiring page-level triggers to reverse-engineer for automation.

**Target**: HomePage OnPageLoad → initializeUserSession trigger

**Duration**: 30-45 minutes

**Date**: 2025-11-05

---

## Prerequisites

- [ ] Chrome browser installed
- [ ] FlutterFlow account logged in ([REDACTED]@example.edu or project account)
- [ ] Project ID: [FLUTTERFLOW_PROJECT_ID]
- [ ] Custom action `initializeUserSession` deployed and available

---

## Step 1: Open Chrome DevTools (2 min)

1. **Launch Chrome**
   ```bash
   google-chrome https://app.flutterflow.io/project/[FLUTTERFLOW_PROJECT_ID]
   ```

2. **Open DevTools**
   - Press `F12` or `Ctrl+Shift+I`
   - Or right-click → Inspect

3. **Navigate to Network Tab**
   - Click "Network" tab in DevTools
   - **IMPORTANT**: Check "Preserve log" checkbox (top row)
   - Filter: Click "Fetch/XHR" to show only API calls
   - Optional: Click "Clear" (🚫) to start fresh

4. **Verify Recording**
   - Red circle icon should be filled (recording active)
   - If gray, click to start recording

---

## Step 2: Navigate to HomePage (3 min)

1. **In FlutterFlow UI**
   - Wait for project to load fully
   - Left sidebar → "Pages & Components"
   - Click "Pages" dropdown
   - Find and click "HomePage"

2. **Verify Page Loaded**
   - Canvas shows HomePage UI
   - Widget Tree visible on right
   - Properties panel shows page details

3. **Note Network Activity**
   - DevTools Network tab should show requests
   - Look for project load calls (ignore these for now)

---

## Step 3: Open Scaffold Properties (2 min)

1. **Select Root Scaffold Widget**
   - In Widget Tree (right panel)
   - Click the topmost widget (usually "Scaffold" or "Page Container")
   - Properties panel updates to show Scaffold options

2. **Navigate to Actions & Logic Tab**
   - Top of properties panel
   - Click "Actions & Logic" tab
   - Should see "Page Lifecycle" section

---

## Step 4: Wire OnPageLoad Trigger (5 min)

**IMPORTANT**: This is where we capture the persist call

1. **Before Adding Trigger**
   - In DevTools Network tab, scroll to bottom
   - Note the last request (for reference)

2. **Add On Page Load Trigger**
   - In "Page Lifecycle" section
   - Click "+ Add Action" next to "On Page Load"
   - Action selector modal opens

3. **Select Custom Action**
   - In action selector, scroll to "Custom Actions" section
   - Click "initializeUserSession"
   - Modal shows action details (no parameters for this action)

4. **Save the Action**
   - Click "Confirm" or "Add Action" button
   - FlutterFlow UI should show the action added to OnPageLoad
   - **WATCH NETWORK TAB**: New requests should appear immediately

---

## Step 5: Identify Persist Call (10-15 min)

**Critical Step**: Find the exact HTTP request that saved the trigger

1. **Filter Network Requests**
   - In DevTools Network tab, look at new requests AFTER clicking "Confirm"
   - Ignore: preflight OPTIONS requests
   - Focus on: POST or PUT requests

2. **Likely Endpoint Patterns**
   Look for URLs containing:
   - `/updateActionFlow`
   - `/mutation` or `/graphql`
   - `/project/update`
   - `/page/update`
   - Any POST with "action" or "trigger" in URL

3. **Click Each Candidate Request**
   - Click request in Network tab
   - View "Headers" tab:
     - Check Method (POST/PUT)
     - Check Request URL
     - Check Status (200 = success)
   - View "Payload" tab:
     - Look for page ID: `Scaffold_r33su4wm` or `HomePage`
     - Look for trigger type: `ON_PAGE_LOAD` or `onPageLoad`
     - Look for action reference: `initializeUserSession`

4. **Identify THE Persist Call**
   - The request that contains ALL of:
     - Page identifier
     - Trigger type (OnPageLoad)
     - Action reference (initializeUserSession)
   - Usually the LAST or second-to-last POST request

---

## Step 6: Extract Request Details (10-15 min)

Once you identify the persist call:

### 6.1 Copy as cURL

1. **Right-click the request** → "Copy" → "Copy as cURL (bash)"
2. **Save to file**:
   ```bash
   # Paste into terminal to create file
   cat > /home/jpv/Documents/School/school/CSC305PROJECT/CSCSoftwareDevelopment/automation/research/persist-call.curl.txt << 'EOF'
   [PASTE cURL HERE]
   EOF
   ```

### 6.2 Copy as HAR

1. **Right-click the request** → "Copy" → "Copy as HAR"
2. **Save to file**:
   ```bash
   cat > /home/jpv/Documents/School/school/CSC305PROJECT/CSCSoftwareDevelopment/automation/research/persist-call.har.json << 'EOF'
   [PASTE HAR HERE]
   EOF
   ```

### 6.3 Extract Request Headers

In DevTools, click the request → "Headers" tab:

**Document these headers**:
- `Authorization: Bearer <token>` (if present)
- `Cookie: <session cookies>` (if present)
- `Content-Type: application/json` (usually)
- `x-csrf-token:` (if present)
- `x-client-version:` (if present)
- Any other `x-*` or custom headers

**Save to sanitized template**:
```bash
cat > /home/jpv/Documents/School/school/CSC305PROJECT/CSCSoftwareDevelopment/automation/samples/headers.sample.json << 'EOF'
{
  "Authorization": "Bearer <REDACTED>",
  "Content-Type": "application/json",
  "Cookie": "<REDACTED>",
  "x-csrf-token": "<REDACTED>",
  "x-client-version": "..."
}
EOF
```

### 6.4 Extract Request Payload

In DevTools, click the request → "Payload" tab:

**Copy the JSON payload**:
- If "view source" available, click it for raw JSON
- Copy entire payload

**Save to sanitized template**:
```bash
cat > /home/jpv/Documents/School/school/CSC305PROJECT/CSCSoftwareDevelopment/automation/samples/wire_onPageLoad.sample.json << 'EOF'
{
  "projectId": "[FLUTTERFLOW_PROJECT_ID]",
  "pageId": "Scaffold_r33su4wm",
  "trigger": "ON_PAGE_LOAD",
  "action": {
    "type": "customAction",
    "name": "initializeUserSession",
    "parameters": {}
  }
}
EOF
```

**Note**: The actual payload structure may be different. Document EXACTLY what you see.

### 6.5 Extract Response

In DevTools, click the request → "Response" tab:

**Document**:
- Success indicator: `"success": true` or HTTP 200
- Any returned data (action ID, graph structure, etc.)

**Save example**:
```bash
cat > /home/jpv/Documents/School/school/CSC305PROJECT/CSCSoftwareDevelopment/automation/research/persist-response.json << 'EOF'
[PASTE RESPONSE HERE]
EOF
```

---

## Step 7: Check for Prerequisite Calls (5-10 min)

**Question**: Does FlutterFlow need to READ the action graph BEFORE writing?

1. **Look BEFORE the persist call**
   - In Network tab, check 1-3 requests BEFORE the persist POST
   - Look for GET requests to same endpoint or similar URL

2. **Likely Patterns**:
   - GET `/actionFlow?pageId=...`
   - GET `/page/Scaffold_r33su4wm/actions`
   - GraphQL query for action graph

3. **If Found**:
   - Copy as cURL and HAR (same process as Step 6)
   - Save to `automation/research/read-action-graph.curl.txt`
   - This is important for implementing idempotency

4. **If Not Found**:
   - Document: "No prerequisite read call found"
   - Persist call may be standalone

---

## Step 8: Verify Wiring Worked (3 min)

1. **In FlutterFlow UI**
   - Refresh page if needed
   - Navigate back to HomePage → Scaffold → Actions & Logic
   - Verify: "On Page Load" shows "initializeUserSession" action

2. **Test in Preview Mode** (optional but recommended)
   - Click "Preview" button (play icon)
   - Open browser console (F12 in preview window)
   - Navigate to HomePage
   - Check console for session initialization logs

---

## Step 9: Document Findings (10 min)

Create analysis document:

```bash
cat > /home/jpv/Documents/School/school/CSC305PROJECT/CSCSoftwareDevelopment/automation/research/network-capture-analysis.md << 'EOF'
# Network Capture Analysis - FlutterFlow Trigger Wiring

**Date**: 2025-11-05
**Operator**: [Your name]
**Target**: HomePage OnPageLoad → initializeUserSession

## Summary

[1-2 sentence summary of what you found]

## Persist Call Details

**Endpoint**: [Full URL]
**Method**: [POST/PUT/PATCH]
**Status**: [200 OK]

### Request Headers

```json
{
  "Authorization": "Bearer <REDACTED>",
  "Content-Type": "...",
  ...
}
```

### Request Payload

```json
{
  [FULL PAYLOAD STRUCTURE]
}
```

### Response

```json
{
  [RESPONSE STRUCTURE]
}
```

## Prerequisite Calls

[X] None found - persist is standalone
[ ] Read call found: [URL]

## Key Observations

- **Auth Method**: [Bearer token / Cookie / Firebase Auth / Other]
- **Payload Stability**: [Fixed schema / Dynamic / Unknown]
- **ID Generation**: [Client-side / Server-side / Pre-existing]
- **Idempotency**: [Can re-run safely / Creates duplicates / Unknown]

## Substitution Points

List fields that need parameterization for automation:

1. `pageId`: "Scaffold_r33su4wm" → Variable
2. `trigger`: "ON_PAGE_LOAD" → Variable
3. `action.name`: "initializeUserSession" → Variable
4. `action.parameters`: {} → Variable (if action has params)
5. [Any other dynamic fields]

## Go/No-Go Assessment

**Feasibility**: [HIGH / MEDIUM / LOW]

**Reasoning**:
- [ ] Persist call clearly identified
- [ ] Payload schema is readable (not encrypted)
- [ ] Auth can be replayed (tokens extractable)
- [ ] No CAPTCHA or anti-automation detected
- [ ] Request structure allows parameterization

**Decision**: [GO to Phase 2 / NO-GO / NEEDS MORE RESEARCH]

## Next Steps

[Based on decision, list what happens next]

---

**Files Saved**:
- `automation/research/persist-call.curl.txt`
- `automation/research/persist-call.har.json`
- `automation/samples/headers.sample.json`
- `automation/samples/wire_onPageLoad.sample.json`
- `automation/research/persist-response.json`

EOF
```

---

## Step 10: Sanitize Secrets (5 min)

**CRITICAL**: Remove all secrets from saved files

1. **Open each file in editor**
   ```bash
   cd /home/jpv/Documents/School/school/CSC305PROJECT/CSCSoftwareDevelopment/automation
   nano research/persist-call.curl.txt
   ```

2. **Replace sensitive data**:
   - Bearer tokens → `<REDACTED_TOKEN>`
   - Session cookies → `<REDACTED_COOKIE>`
   - Email addresses → `<REDACTED_EMAIL>`
   - User IDs → `<REDACTED_USER_ID>`
   - Any keys, secrets, passwords → `<REDACTED_SECRET>`

3. **Keep structure**:
   - DO NOT remove the field names
   - DO NOT change the JSON structure
   - Only replace VALUES

4. **Verify no secrets remain**:
   ```bash
   grep -r "Bearer " automation/
   grep -r "@uri.edu" automation/
   grep -r "juan" automation/
   ```

---

## Completion Checklist

**Files Created**:
- [ ] `automation/research/persist-call.curl.txt` (sanitized)
- [ ] `automation/research/persist-call.har.json` (sanitized)
- [ ] `automation/samples/headers.sample.json` (template)
- [ ] `automation/samples/wire_onPageLoad.sample.json` (template)
- [ ] `automation/research/persist-response.json` (example)
- [ ] `automation/research/network-capture-analysis.md` (analysis)

**Verification**:
- [ ] Trigger wiring successful in FlutterFlow UI
- [ ] Persist call clearly identified
- [ ] Request payload documented
- [ ] Auth mechanism understood
- [ ] All secrets sanitized
- [ ] Go/no-go decision made

---

## What's Next?

**If GO Decision**:
→ Proceed to Phase 2: Build network-replay automation tool

**If NO-GO Decision**:
→ Fall back to manual wiring workflow (2 hours for 4 triggers)
→ Document blockers for future FlutterFlow API improvements

**If NEEDS MORE RESEARCH**:
→ Wire second trigger (GoldenPath OnPageLoad) to compare payloads
→ Identify patterns and differences
→ Re-assess feasibility

---

## Support

**If stuck or unclear**:
1. Share the Network tab screenshot
2. Share the persist call details (sanitized)
3. Consult with Claude Code for analysis

**Contact**: Juan Vallejo ([REDACTED]@example.edu)
**Project**: CSC305 GlobalFlavors - D7 Retention Metrics
