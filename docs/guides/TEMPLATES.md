# Communication Templates

[Home](../../README.md) > [Docs](../README.md) > [Guides](./README.md) > Templates

> **Ready-to-use templates for commits, PRs, documentation, and team communication**

**Last Updated**: November 17, 2025
**Project**: GlobalFlavors CSC305 Capstone

---

## Overview

This document provides standardized templates for common development tasks to ensure consistent, professional communication across the project.

**See also**: [CONTRIBUTING.md](../../CONTRIBUTING.md) for full communication standards.

---

## Table of Contents

1. [Status / Worklog Update](#status--worklog-update)
2. [Commit Message](#commit-message)
3. [Pull Request Description](#pull-request-description)
4. [Architecture Decision Record (ADR)](#architecture-decision-record-adr)
5. [Meeting Notes / Action Register](#meeting-notes--action-register)
6. [Compliance Checklist](#compliance-checklist)

---

## Status / Worklog Update

Use for daily updates, sprint reports, or task completion summaries.

```markdown
**Summary:** <1-2 sentence description of work completed>

**Outcome:** <measurable results, acceptance criteria met>

**Implementation:**
- Step 1: ...
- Step 2: ...
- Key files: ...

**Evidence:** <commit SHAs, screenshots, metrics>

**Risks & Mitigations:**
- Risk 1 → Mitigation 1

**Next Actions:** <what needs to happen next>

**Open Questions:** <if any>
```

### Example

```markdown
**Summary:** Implemented D7 retention metrics calculation with automated daily Cloud Function

**Outcome:**
- calculateD7Retention function deployed to production
- Scheduled to run daily at 2 AM UTC
- Verified 100% success rate on test cohort (15 users)

**Implementation:**
- Created Cloud Function with cohort-based calculation logic
- Added Cloud Scheduler trigger (cron: 0 2 * * *)
- Deployed via service account authentication
- Key files: functions/src/retention.ts, firestore.indexes.json

**Evidence:**
- Commit: d5c2748
- Test run logs: 15/15 users calculated successfully
- Metrics: 60% D7 retention rate (9/15 users)

**Risks & Mitigations:**
- Risk: Scheduler misconfiguration → Mitigation: Added Cloud Scheduler validation step
- Risk: Timezone confusion → Mitigation: Documented UTC explicitly

**Next Actions:** Monitor first 7 days of production data

**Open Questions:** None
```

---

## Commit Message

**Format**: Conventional Commits

```
<type>(<scope>): <imperative summary>

Why:
- Problem/goal with baseline metric

What:
- Key code/config changes
- Files modified

Impact:
- Metrics, risk assessment, user-facing effects

Refs: #<issue> SHA:<short>
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `refactor`: Code restructuring (no behavior change)
- `test`: Adding/updating tests
- `chore`: Maintenance, dependencies, tooling

### Example

```
feat(retention): add D7 retention metric calculation

Why:
- Need automated tracking of 7-day user engagement
- Manual calculation taking 2 hrs/week
- Baseline: 0% coverage

What:
- Created calculateD7Retention Cloud Function
- Added Firestore composite indexes (user_id, completed_at)
- Deployed Cloud Scheduler (daily 2 AM UTC)
- Files: functions/src/retention.ts, firestore.indexes.json

Impact:
- Automated: 2 hrs/week → 0 manual effort (100% reduction)
- Coverage: 0% → 100% of active users
- Latency: Real-time cohort calculation (<5s per user)
- Risk: LOW (read-only queries, no user-facing changes)

Refs: #42 SHA:d5c2748
```

---

## Pull Request Description

Use for all pull requests (required before merge).

```markdown
**Context**
- Business/technical rationale
- Current state (baseline)

**Change**
- What changed: modules, endpoints, migrations
- Architecture decisions

**Validation**
- Tests run, environments tested
- Sample inputs/outputs

**Impact**
- User/system impact
- Rollout/rollback plan

**Risks & Mitigations**
- Risk 1 → Mitigation 1

**Checklist**
- [ ] Documentation updated
- [ ] Tests added/passing
- [ ] Backward compatible
- [ ] Secrets redacted
```

### Example

```markdown
**Context**
- Business need: Track 7-day user retention to measure engagement
- Current state: Manual spreadsheet tracking (2 hrs/week, 0% coverage)
- Gap: No automated cohort analysis

**Change**
- Added 4 Cloud Functions (calculateD7Retention, getD7RetentionMetrics, etc.)
- Created 2 Firestore composite indexes
- Deployed Cloud Scheduler for daily automation
- Architecture: Cohort-based calculation with caching

**Validation**
- Unit tests: 12/12 passing
- Integration tests: Test cohort (15 users) → 100% success rate
- Environments: Staging verified, production deployed
- Sample: Cohort 2025-11-10 → 60% retention (9/15 users)

**Impact**
- User impact: NONE (backend only, no UI changes)
- System impact: +4 Cloud Functions, +1 scheduled job
- Rollout: Gradual (staging 1 day, production after verification)
- Rollback: Delete Cloud Scheduler job, disable functions

**Risks & Mitigations**
- Risk: Scheduler fails silently → Mitigation: Added monitoring alert (missed runs)
- Risk: Index creation timeout → Mitigation: Created indexes before deploying functions

**Checklist**
- [x] Documentation updated (docs/architecture/D7_RETENTION_DEPLOYMENT.md)
- [x] Tests added/passing (12 unit tests, 3 integration tests)
- [x] Backward compatible (no breaking changes to existing data)
- [x] Secrets redacted (all API keys in GCP Secret Manager)
```

---

## Architecture Decision Record (ADR)

Use for documenting significant technical decisions.

```markdown
# ADR-<id>: <decision title>

**Date:** YYYY-MM-DD

## Context
<Problem, drivers, constraints, non-goals>

## Decision
<What was decided and why>

## Consequences
**Positive:**
- Benefit 1
- Benefit 2

**Negative:**
- Tradeoff 1
- Tradeoff 2

## Alternatives Considered
- **Option A:** <pros/cons>
- **Option B:** <pros/cons>

## Evidence
<Benchmarks, tickets, links, commit SHAs>
```

### Example

```markdown
# ADR-003: Use ZIP Compression for FlutterFlow Bulk Uploads

**Date:** 2025-11-06

## Context
- Problem: Bulk uploads of 24+ YAML files hitting rate limits (HTTP 429)
- Driver: Need to upload 50-100 files efficiently for batch operations
- Constraint: FlutterFlow API has undocumented rate limits
- Non-goal: Individual file uploads (already solved)

## Decision
Use ZIP compression method for all bulk uploads >10 files instead of JSON method.

## Consequences
**Positive:**
- 26-53% smaller payloads (5.1 KB vs 6.9 KB for 10 files)
- No rate limiting at 24 files (JSON method failed)
- 96-97% faster than serial uploads
- More network-efficient for remote team

**Negative:**
- Slightly more complex debugging (binary format vs JSON)
- Ceiling not yet tested (unknown limit beyond 24 files)
- Requires base64 encoding/decoding

## Alternatives Considered
- **JSON bulk upload:** Simpler debugging, explicit file mapping
  - Pros: Easier to inspect payloads
  - Cons: Hit rate limit at 24 files, 53% larger payloads
- **Parallel serial uploads:** No rate limiting
  - Pros: Simple, no batching complexity
  - Cons: 3x slower than ZIP, more API calls

## Evidence
- Benchmarks: logs/ZIP_VS_JSON_FINDINGS.md
- Test artifacts: logs/payload-zip-*.json
- Commits: 1b3867e (ZIP implementation)
- Performance: 24 files in 5s (ZIP) vs HTTP 429 (JSON)
```

---

## Meeting Notes / Action Register

Use for team meetings, standup notes, decision logs.

```markdown
**Date:** YYYY-MM-DD HH:MM-HH:MM
**Attendees:** <names>
**Purpose:** <meeting objective>

**Decisions:**
- D1: <decision> (owner: X)

**Actions:**
- A1: <owner> → <action> (timeline: YYYY-MM-DD)

**Notes:**
- <bullet points, key discussion items>

**Open Questions:**
- Q1: <question> (needs input from: X)
```

### Example

```markdown
**Date:** 2025-11-05 14:00-14:30
**Attendees:** Jack Light, Juan Vallejo, CSC305 Team
**Purpose:** Review D7 retention metrics deployment

**Decisions:**
- D1: Deploy to production after 24-hour staging verification (owner: Juan)
- D2: Manual UI wiring for page triggers (API doesn't support automation) (owner: Juan)

**Actions:**
- A1: Juan → Complete manual UI wiring for 4 page triggers (timeline: 2025-11-06)
- A2: Jack → Review deployment documentation (timeline: 2025-11-06)
- A3: Team → Monitor first 7 days of production data (timeline: 2025-11-12)

**Notes:**
- FlutterFlow YAML API limitation discovered: page-level triggers not exposed
- Playwright automation rejected (Shadow DOM incompatibility)
- Hybrid approach approved: backend via API, frontend via UI

**Open Questions:**
- Q1: Can we reverse-engineer widget trigger schema? (needs research: Juan, timeline: Phase 2)
```

---

## Compliance Checklist

Before submitting documentation, commits, pull requests, or responses, verify:

- [ ] **Summary** is objective and concise (≤2 sentences)
- [ ] **Outcomes** are measurable with baselines (numbers, percentages, timings)
- [ ] **Implementation** is reproducible (commands, file paths, step-by-step)
- [ ] **Evidence** cited (commit SHAs, logs, screenshots, metrics)
- [ ] **Risks** and next actions are explicit
- [ ] **No banned words** (sprint, quick win, ASAP, significant without quantification)
- [ ] **Dates** use ISO 8601 (YYYY-MM-DD), times are 24-hour with timezone
- [ ] **No secrets** (API keys, credentials, PII) exposed
- [ ] **Assumptions** listed with verification steps (if applicable)
- [ ] **Units** included for all measurements (ms, KB, %, files, users)

---

## Session Primer for AI Interactions

When starting a new Claude/AI session, paste this primer:

```
Follow Communication Style & Standards from CLAUDE.md and CONTRIBUTING.md.
Use default response structure (Summary, Outcome, Implementation, Evidence,
Risks, Next Actions, Open Questions). Avoid buzzwords and hype. Quantify
results, cite evidence, and list assumptions with verification steps. Use
ISO 8601 dates, SI units, and descriptive links. Focus on execution and
measurable outcomes.
```

---

## Documentation Template

Use this template for new documentation files:

```markdown
# Document Title

[Home](../../README.md) > [Docs](../README.md) > [Category](./README.md) > Document Title

> **Brief description of what this document covers**

**Team**: GlobalFlavors CSC305 Development Team
**Contributors**: Juan, Jack, Sophia, Maria, Alex
**AI-Assisted**: [Claude Code/GPT-5/None]
**Last Updated**: YYYY-MM-DD
**Status**: [Draft/Ready/Archived]

---

## Overview

Brief introduction to the topic (2-3 sentences).

## [Main Section 1]

Content here...

## [Main Section 2]

Content here...

## Related Documentation

- [Related Doc 1](../path/to/doc.md) - Description
- [Related Doc 2](../path/to/doc.md) - Description
- [Related Doc 3](../path/to/doc.md) - Description

---

**Last Updated**: YYYY-MM-DD
**Maintainer**: GlobalFlavors Team
**Questions?**: See [CONTRIBUTING.md](../../CONTRIBUTING.md)
```

**Key Elements**:
- ✅ Breadcrumb navigation (Home > Docs > Category > Current)
- ✅ Team attribution (not individual authors)
- ✅ AI assistance disclosure (if applicable)
- ✅ Related Documentation section (for cross-linking)
- ✅ Last updated date
- ✅ Clear structure with headings

**File Naming**:
- Use UPPERCASE_SNAKE_CASE for major guides: `YAML_EDITING_GUIDE.md`
- Use lowercase-kebab-case for specific docs: `d7-retention-overview.md`
- Use descriptive names that match content

---

## Additional Resources

- **Full Communication Standards**: [CONTRIBUTING.md](../../CONTRIBUTING.md)
- **Code of Conduct**: [CODE_OF_CONDUCT.md](../../CODE_OF_CONDUCT.md)
- **Change Log**: [CHANGELOG.md](../../CHANGELOG.md)
- **Main Context**: [CLAUDE.md](../../CLAUDE.md)

---

**Last Updated**: November 17, 2025
**Maintainer**: GlobalFlavors Team
