# FlutterFlow Trigger Wiring Automation

**Status**: Phase 1 - Research & Network Capture (In Progress)
**Created**: 2025-11-05
**Project**: CSC305 GlobalFlavors - D7 Retention Metrics

---

## Overview

This directory contains research, tooling, and samples for automating FlutterFlow page-level trigger wiring using network-replay automation.

**Approach**: Playwright auth + HTTP request replay (avoiding DOM automation)

**Goal**: Replace 2-hour manual UI wiring with ≤2 min automated tool

---

## Directory Structure

```
automation/
├── README.md                           # This file
├── research/                           # Phase 1 research output
│   ├── NETWORK_CAPTURE_GUIDE.md       # Step-by-step capture instructions
│   ├── network-capture-analysis.md    # Analysis of captured data (TBD)
│   ├── persist-call.curl.txt          # Captured cURL command (TBD)
│   ├── persist-call.har.json          # Captured HAR file (TBD)
│   └── persist-response.json          # Sample response (TBD)
├── samples/                            # Sanitized templates for replay
│   ├── headers.sample.json            # Request headers template (TBD)
│   └── wire_onPageLoad.sample.json    # Payload template (TBD)
├── backups/                            # Pre-change state backups (Phase 2)
│   └── YYYY-MM-DD-HH-MM/              # Timestamped backups
├── ff-wire.ts                          # Main automation tool (Phase 2)
├── batch.yaml                          # Batch wiring config (Phase 2)
├── package.json                        # Dependencies (Phase 2)
└── tsconfig.json                       # TypeScript config (Phase 2)
```

---

## Current Phase: Phase 1 - Research & Network Capture

**Objective**: Validate feasibility by capturing one real trigger wiring operation

**Target**: HomePage OnPageLoad → initializeUserSession

### How to Execute Phase 1

1. **Follow the capture guide**:
   ```bash
   cat automation/research/NETWORK_CAPTURE_GUIDE.md
   ```

2. **Open Chrome and FlutterFlow**:
   ```bash
   google-chrome https://app.flutterflow.io/project/[FLUTTERFLOW_PROJECT_ID]
   ```

3. **Complete all 10 steps** in NETWORK_CAPTURE_GUIDE.md

4. **Make go/no-go decision** based on captured data

### Expected Deliverables

- [ ] `research/persist-call.curl.txt` (sanitized)
- [ ] `research/persist-call.har.json` (sanitized)
- [ ] `samples/headers.sample.json` (template)
- [ ] `samples/wire_onPageLoad.sample.json` (template)
- [ ] `research/persist-response.json` (example)
- [ ] `research/network-capture-analysis.md` (analysis with go/no-go decision)

### Success Criteria

**GO to Phase 2** if:
- ✅ Persist call clearly identified
- ✅ Payload schema is readable (not encrypted)
- ✅ Auth can be replayed (tokens extractable)
- ✅ No CAPTCHA or anti-automation detected
- ✅ Request structure allows parameterization

**NO-GO** if:
- ❌ Persist call not found or unclear
- ❌ Payload is encrypted or obfuscated
- ❌ Auth requires live user interaction (CAPTCHA, etc.)
- ❌ Schema changes with each request (unstable)

---

## Future Phases

### Phase 2: Build Network-Replay Automation (6-8 hrs)

**Only proceed if Phase 1 validates feasibility**

**Deliverables**:
- TypeScript automation tool (`ff-wire.ts`)
- Batch configuration (`batch.yaml`)
- Idempotency and rollback features
- Documentation and tests

**CLI Usage** (planned):
```bash
# Single trigger
npx ts-node automation/ff-wire.ts \
  --page-id "Scaffold_r33su4wm" \
  --trigger "ON_PAGE_LOAD" \
  --action "initializeUserSession"

# Batch mode
npx ts-node automation/ff-wire.ts --batch automation/batch.yaml

# Rollback
npx ts-node automation/ff-wire.ts --rollback "Scaffold_r33su4wm" \
  --backup automation/backups/2025-11-05-14-30/Scaffold_r33su4wm.json
```

### Phase 3: Deploy Remaining Triggers (30-45 min)

**Tasks**:
- Run automation in batch mode for all 4 triggers
- Verify in FlutterFlow UI
- Test in preview mode
- Monitor production

---

## Background

### Why Network-Replay Instead of DOM Automation?

**Previous Approach** (Rejected):
- Playwright DOM automation
- Success rate: 15-30%
- Issue: FlutterFlow uses Shadow DOM, selectors fragile

**Current Approach** (Approved):
- Playwright for auth ONLY (stable)
- Replay captured HTTP requests (stable, FlutterFlow UI does this)
- Expected success rate: ≥95%

### Why Not YAML API?

FlutterFlow's YAML API does NOT expose page-level triggers (OnPageLoad, OnAuthSuccess):
- 609 YAML files analyzed
- Zero page-level trigger files found
- Only widget-level triggers (ON_TAP, etc.) exposed

### Why Not Manual Workflow?

Manual workflow is viable (2 hours for 4 triggers) but:
- Project scale: 10+ pages planned
- Manual: 10 pages × 2 hrs = 20 hrs ($3,000)
- Automated: 10 hrs build + 10 pages × 0.1 hr = 11 hrs ($1,650)
- ROI: $1,350 savings + reduced maintenance

---

## Integration with Existing Workflows

### Custom Action Deployment

Already solved via VS Code Extension:
- See: `docs/D7_RETENTION_DEPLOYMENT.md`
- Custom actions deployed successfully (3/3)
- No automation needed

### YAML API Operations

Already solved via scripts:
- `scripts/download-yaml.sh` - Download YAML files
- `scripts/validate-yaml.sh` - Validate changes
- `scripts/update-yaml.sh` - Update FlutterFlow project

### This Automation Fills Gap

**Solves**: Page-level trigger wiring (OnPageLoad, OnAuthSuccess)
**Does NOT solve**: Custom action creation (use VS Code Extension)

---

## Timeline & Budget

| Phase | Duration | Cost (@ $150/hr) | Status |
|-------|----------|------------------|--------|
| Phase 1: Research | 45-60 min | $112-150 | **IN PROGRESS** |
| Phase 2: Build Tool | 6-8 hrs | $900-1,200 | Pending Phase 1 |
| Phase 3: Deploy | 30-45 min | $75-112 | Pending Phase 2 |
| **Total** | **8-10 hrs** | **$1,087-1,462** | **1-2 weeks** |

---

## Next Steps

1. **Complete Phase 1** by following `research/NETWORK_CAPTURE_GUIDE.md`
2. **Review findings** in `research/network-capture-analysis.md`
3. **Make decision**: Go/no-go for Phase 2
4. **If GO**: Build automation tool (Phase 2)
5. **If NO-GO**: Use manual workflow, document blockers

---

## References

- **Main Context Doc**: `/CSCSoftwareDevelopment/CLAUDE.md`
- **Manual Wiring Guide**: `/docs/MANUAL_PAGE_TRIGGER_WIRING.md`
- **Deployment Status**: `/CSCSoftwareDevelopment/DEPLOYMENT_STATUS.md`
- **ChatGPT Analysis**: User-provided screenshots (Network-Replay Automation)

---

## Support

**Questions or Issues**:
1. Review `research/NETWORK_CAPTURE_GUIDE.md`
2. Check `research/network-capture-analysis.md` for decisions
3. Consult with Claude Code
4. Contact: [REDACTED]@example.edu

**Last Updated**: 2025-11-05
