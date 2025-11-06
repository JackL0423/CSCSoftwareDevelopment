# Quick Start - Network Capture (Phase 1)

**Time Required**: 45-60 minutes
**Objective**: Capture HTTP traffic to validate automation feasibility

---

## Pre-Flight Checklist

Before starting, verify:

```bash
cd /home/jpv/Documents/School/school/CSC305PROJECT/CSCSoftwareDevelopment

# Check automation directory exists
ls -la automation/
# Should show: research/, samples/, backups/

# Check guide exists
cat automation/research/NETWORK_CAPTURE_GUIDE.md | head -20

# Check Chrome is installed
which google-chrome
```

---

## Step-by-Step Execution

### 1. Open Capture Guide (2 min)

```bash
# Open in text editor for reference
nano automation/research/NETWORK_CAPTURE_GUIDE.md

# OR print to terminal
cat automation/research/NETWORK_CAPTURE_GUIDE.md | less
```

### 2. Launch Chrome with FlutterFlow (3 min)

```bash
# Open FlutterFlow project
google-chrome https://app.flutterflow.io/project/c-s-c305-capstone-khj14l &

# Wait for project to load
# Login if needed (juan_vallejo@uri.edu or project account)
```

### 3. Open Chrome DevTools (1 min)

- Press `F12` in Chrome
- Click "Network" tab
- ✅ Check "Preserve log" checkbox
- Filter: Click "Fetch/XHR" button
- Click "Clear" (🚫) to start fresh

### 4. Navigate to HomePage (2 min)

- FlutterFlow UI → "Pages & Components" (left sidebar)
- Click "Pages" dropdown
- Find and click "HomePage"
- Verify: Canvas shows HomePage UI

### 5. Wire the Trigger (10 min)

**CRITICAL: Watch Network tab during this step**

1. In Widget Tree (right panel), click "Scaffold" (root widget)
2. Click "Actions & Logic" tab (top of properties panel)
3. In "Page Lifecycle" section, click "+ Add Action" next to "On Page Load"
4. In action selector modal:
   - Scroll to "Custom Actions" section
   - Click "initializeUserSession"
   - Click "Confirm" or "Add Action"
5. **IMMEDIATELY look at Network tab** for new requests

### 6. Identify Persist Call (15 min)

**Look for POST/PUT requests AFTER clicking "Confirm"**

Likely patterns:
- `/updateActionFlow`
- `/mutation` or `/graphql`
- `/project/update`
- `/page/update`

**Click each candidate request**:
- Check "Headers" tab → Method (POST/PUT), URL, Status (200)
- Check "Payload" tab → Look for:
  - Page ID: `Scaffold_r33su4wm` or `HomePage`
  - Trigger: `ON_PAGE_LOAD` or `onPageLoad`
  - Action: `initializeUserSession`

**When found**:
- This is THE persist call
- Continue to Step 7

### 7. Extract Data (20 min)

#### 7a. Copy as cURL

Right-click request → Copy → Copy as cURL (bash)

```bash
# Paste into terminal
cat > automation/research/persist-call.curl.txt << 'EOF'
[PASTE cURL COMMAND HERE - Ctrl+Shift+V]
EOF
```

#### 7b. Copy as HAR

Right-click request → Copy → Copy as HAR

```bash
# Paste into terminal
cat > automation/research/persist-call.har.json << 'EOF'
[PASTE HAR JSON HERE - Ctrl+Shift+V]
EOF
```

#### 7c. Extract Headers

In DevTools, click request → "Headers" tab

Update template:
```bash
nano automation/samples/headers.sample.json
```

Replace placeholders with actual values:
- `Authorization: Bearer <token>`
- `Cookie: <session cookies>`
- Any `x-*` custom headers

**IMPORTANT**: Keep `<REDACTED>` for now, we'll sanitize later

#### 7d. Extract Payload

In DevTools, click request → "Payload" tab → "view source" (if available)

Update template:
```bash
nano automation/samples/wire_onPageLoad.sample.json
```

Replace entire content with ACTUAL payload structure you see.

**DO NOT GUESS** - document EXACTLY what you see.

#### 7e. Extract Response

In DevTools, click request → "Response" tab

```bash
cat > automation/research/persist-response.json << 'EOF'
[PASTE RESPONSE JSON HERE - Ctrl+Shift+V]
EOF
```

### 8. Sanitize Secrets (10 min)

**CRITICAL: Remove all secrets before git commit**

```bash
cd automation

# Edit each file and replace secrets
nano research/persist-call.curl.txt
# Replace Bearer tokens → <REDACTED_TOKEN>
# Replace cookies → <REDACTED_COOKIE>
# Replace email addresses → <REDACTED_EMAIL>

nano research/persist-call.har.json
# Same as above

nano samples/headers.sample.json
# Same as above

nano samples/wire_onPageLoad.sample.json
# Replace user IDs, emails, secrets → <REDACTED_*>

# Verify no secrets remain
grep -r "Bearer " . 2>/dev/null | grep -v "REDACTED" | grep -v "_comment"
grep -r "@uri.edu" . 2>/dev/null | grep -v "REDACTED" | grep -v "_comment"
```

### 9. Document Analysis (15 min)

```bash
# Copy template to working file
cp automation/research/network-capture-analysis.template.md \
   automation/research/network-capture-analysis.md

# Edit and fill in all sections
nano automation/research/network-capture-analysis.md
```

**Fill in**:
- Summary (1-2 sentences)
- Persist call details (endpoint, method, status)
- Request headers (actual structure)
- Request payload (actual structure)
- Response (actual structure)
- Substitution points (which fields to parameterize)
- Go/no-go assessment

**Make decision**:
- ✅ GO to Phase 2 if all criteria met
- ❌ NO-GO if blockers found
- 🔄 NEEDS MORE RESEARCH if uncertain

### 10. Verify & Commit (5 min)

```bash
cd /home/jpv/Documents/School/school/CSC305PROJECT/CSCSoftwareDevelopment

# Check files created
ls -la automation/research/
ls -la automation/samples/

# Verify secrets sanitized
grep -r "Bearer " automation/ | grep -v "REDACTED" | wc -l
# Should output: 0

# Stage changes
git add automation/

# Review what you're committing
git status
git diff --staged

# Commit
git commit -m "feat(automation): Phase 1 network capture complete

- Captured FlutterFlow persist call for OnPageLoad trigger
- Documented request/response structure
- Created sanitized payload templates
- Feasibility assessment: [GO/NO-GO/RESEARCH]

Refs: Phase 1 of network-replay automation
"

# Push to branch
git push origin JUAN-adding-metric
```

---

## Completion Checklist

After finishing, verify:

**Files Created**:
- [ ] `automation/research/persist-call.curl.txt` (sanitized)
- [ ] `automation/research/persist-call.har.json` (sanitized)
- [ ] `automation/samples/headers.sample.json` (populated)
- [ ] `automation/samples/wire_onPageLoad.sample.json` (populated)
- [ ] `automation/research/persist-response.json` (example)
- [ ] `automation/research/network-capture-analysis.md` (complete)

**Quality Checks**:
- [ ] All secrets sanitized (Bearer tokens, cookies, emails)
- [ ] Payload structure documented exactly as seen
- [ ] Substitution points identified
- [ ] Go/no-go decision made with reasoning

**Git**:
- [ ] Changes committed to JUAN-adding-metric branch
- [ ] Pushed to GitHub
- [ ] No secrets in commit history

---

## What's Next?

### If GO Decision

→ **Proceed to Phase 2**: Build automation tool

**Next session**:
1. Create `automation/ff-wire.ts` skeleton
2. Implement Playwright auth module
3. Test single trigger wiring

**Timeline**: 6-8 hours over 3-5 days

### If NO-GO Decision

→ **Fall back to manual workflow**

**Next session**:
1. Follow `docs/MANUAL_PAGE_TRIGGER_WIRING.md`
2. Wire remaining 3 triggers manually (90-120 min)
3. Document blockers for future reference

### If NEEDS MORE RESEARCH

→ **Capture more data**

**Next session**:
1. Wire GoldenPath OnPageLoad (second trigger)
2. Capture network traffic again
3. Compare payloads to identify patterns
4. Re-assess feasibility

---

## Troubleshooting

### "I can't find the persist call"

- Check if you filtered to "Fetch/XHR" only → Try "All"
- Look for GraphQL mutations (may be in single `/graphql` endpoint)
- Clear network log, wire trigger again, watch closely
- Try different trigger type (ON_AUTH_SUCCESS instead)

### "Payload is encrypted or unreadable"

- Check "Payload" tab → "view parsed" vs "view source"
- Check if base64 encoded (decode first)
- If truly encrypted → NO-GO decision

### "Chrome DevTools crashed or lost recording"

- Enable "Preserve log" checkbox (top of Network tab)
- Increase DevTools memory (Settings → Preferences)
- Save HAR file before closing DevTools (right-click → Save all as HAR)

### "Not sure if this is the right request"

- Look for Status 200 (success)
- Look for payload containing page/action identifiers
- Check Response tab for success message
- If multiple candidates, document all, compare

---

## Support

**Stuck?** Review:
1. `automation/research/NETWORK_CAPTURE_GUIDE.md` (detailed steps)
2. `automation/README.md` (context and overview)
3. ChatGPT analysis screenshots (reference implementation)

**Questions**: Consult Claude Code or contact juan_vallejo@uri.edu

---

**Estimated Time**: 45-60 minutes
**Next Milestone**: Phase 2 automation build (if GO decision)
