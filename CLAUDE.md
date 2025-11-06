## 2025-11-05 updates

- Added automation scripts for FlutterFlow YAML API wiring and Firebase Test Lab verification. See `scripts/README.md` for index and usage.
- New verification helpers: `snapshot-from-manifest.sh`, `diff-snapshots.sh`, `run-robo-sync.sh`, `collect-testlab-results.sh`.
- Classmate summary at `README_Juan_2025-11-05.md` and docs index at `docs/INDEX.md`.

# CLAUDE.md - AI Assistant Context for CSC305 GlobalFlavors Project

> **Purpose**: This document provides comprehensive context for AI assistants (like Claude Code) working on the GlobalFlavors FlutterFlow project. It contains all essential information, credentials locations, workflows, and project structure.

**Last Updated**: November 5, 2025
**Project Status**: Active Development - D7 Retention Metrics Backend Deployed
**Current Branch**: JUAN-adding-metric

---

## Table of Contents

1. [Communication Style & Standards](#communication-style--standards)
2. [Project Overview](#project-overview)
3. [FlutterFlow Configuration](#flutterflow-configuration)
4. [GCP & Secret Management](#gcp--secret-management)
5. [Development Environment](#development-environment)
6. [GitHub Configuration](#github-configuration)
7. [YAML Editing Workflow](#yaml-editing-workflow)
8. [API Reference](#api-reference)
9. [Security & Best Practices](#security--best-practices)
10. [Branch Strategy](#branch-strategy)
11. [D7 Retention Metrics Deployment](#d7-retention-metrics-deployment)
12. [Firebase Backend](#firebase-backend)
13. [FlutterFlow Action Wiring](#flutterflow-action-wiring)
14. [Troubleshooting](#troubleshooting)

---

## Communication Style & Standards

**Purpose:** Guide all project communication toward professional, effective delivery in code, documentation, commits, and AI interactions.

**Prime Directive:** Output must be professional, objective, and implementation-focused. Favor facts, evidence, and measurable outcomes over opinion or hype.

### Core Principles

- **Professional but approachable:** Maintain the tone of a senior technical consultant
- **Execution-focused:** Emphasize concrete actions and measurable results
- **Evidence-based:** Support claims with data, metrics, logs, or commits
- **Technically precise:** Use accurate terminology without unnecessary jargon

### Standards Framework

#### MUST

- Use clear, direct language in active voice
- State measurable outcomes (quantities, timings, error rates, improvements)
- Provide implementation details sufficient for reproduction
- Document assumptions explicitly when information is incomplete
- Follow consistent formatting: ISO 8601 dates (YYYY-MM-DD), 24-hour time, SI units
- Use US English spelling and grammar
- Redact or mask secrets, credentials, internal URLs, and PII

#### SHOULD

- Support claims with evidence (commit SHAs, logs, metrics, screenshots)
- Use structured responses with clear sections
- Keep paragraphs concise (4 lines or less) and favor lists
- Include verification steps for assumptions
- Cite baselines when reporting improvements (Before → After)
- Use descriptive link anchors (not "click here")

#### AVOID

- Agile/startup buzzwords: "sprint," "quick win," "low-hanging fruit," "north star"
- Pressure language: "crush the deadline," "ASAP!!," "blocker panic"
- Vague qualifiers without data: "significant," "robust," "soon," "better"
- Overpromising: Do not commit to background work or future results beyond current scope
- Excessive technical jargon that obscures meaning

### Term Preferences

Use these professional alternatives:

| Avoid | Prefer |
|-------|--------|
| sprint | iteration, phase, development cycle |
| quick win | narrow-scope improvement, targeted enhancement |
| deadline | target date, timeline, completion date |
| optimize (alone) | reduce latency from X to Y, improve throughput by Z% |
| significant/substantial | quantify: 23% improvement, 450ms reduction |
| ASAP/urgent!!! | specify date: by 2025-11-08, within 48 hours |

### Default Response Structure

Use this structure for status updates, analyses, and technical explanations:

```
**Summary** — What changed or what is proposed (1-2 sentences)

**Outcome** — Measurable results or acceptance criteria

**Implementation** — Key steps, interfaces, configs, commands
- Step 1: ...
- Step 2: ...

**Evidence** — Metrics, logs, screenshots, commit SHAs

**Risks & Mitigations** — Known risks and mitigation plans
- Risk: ... → Mitigation: ...

**Next Actions** — Concrete steps with context

**Open Questions** — Items requiring decisions or additional data (if any)
```

If a section is not applicable, include the header with "N/A" to make omissions explicit.

### Documentation Mechanics

- **Voice:** Active, direct ("Implemented feature X," "This endpoint handles...")
- **Tense:** Past for completed work, present for facts, imperative for instructions
- **Numbers:** Use numerals with units and baselines (500ms → 320ms, +12 variables)
- **Dates/Times:** ISO 8601 format (2025-11-04), 24-hour time with timezone if relevant
- **Code:** Fenced blocks with language hints; minimal runnable snippets
- **Links:** Descriptive anchors with context or version when relevant

### Uncertainty & Assumptions Protocol

When information is incomplete or uncertain:

**State Assumptions:**
- List explicit assumptions (A1: X, A2: Y)
- Describe impact if assumptions prove false

**Provide Verification:**
- Include fastest test or query to validate
- Offer viable fallback if verification fails

**Example:**
```
Assumptions:
- A1: API rate limit is 100 req/min
- A2: Database has index on user_id column

Verification: Run `curl -I https://api.../health` to check rate limit headers

Impact if false: Throughput may drop 40% if A1 is 60 req/min
```

### Ready-to-Use Templates

#### A) Status / Worklog Update

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

#### B) Commit Message (Conventional Format)

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

#### C) Pull Request Description

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

#### D) Architecture Decision Record (ADR)

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

#### E) Meeting Notes / Action Register

```markdown
**Date:** 2025-11-04 14:00-14:30
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

### Compliance Checklist

Before submitting documentation, commits, or responses:

- [ ] Summary is objective and concise (≤2 sentences)
- [ ] Outcomes are measurable with baselines
- [ ] Implementation is reproducible
- [ ] Evidence cited (metrics, commits, logs)
- [ ] Risks and next actions are explicit
- [ ] No banned words, hype, or pressure language
- [ ] Dates use ISO 8601, times are 24-hour, units are included
- [ ] No secrets, PII, or internal URLs exposed
- [ ] Assumptions listed with verification steps (if applicable)

### Session Primer for AI Interactions

When starting a new Claude session, use this primer:

```
Follow Communication Style & Standards from CLAUDE.md. Use default response
structure (Summary, Outcome, Implementation, Evidence, Risks, Next Actions,
Open Questions). Avoid buzzwords and hype. Quantify results, cite evidence,
and list assumptions with verification steps. Use ISO 8601 dates, SI units,
and descriptive links. Focus on execution and measurable outcomes.
```

---

## Project Overview

**Project Name**: GlobalFlavors
**Course**: CSC305 Software Development Capstone
**Institution**: University of Rhode Island
**Team Lead**: Juan Vallejo (juan_vallejo@uri.edu)

### Description

GlobalFlavors is a mobile application built with FlutterFlow that helps users discover and explore international cuisines. The app features recipe browsing, user authentication, and personalized recommendations.

### Key Documents

- **Business Plan**: `docs/BUSINESSPLAN.md`
- **User Research**: `docs/UserResarch.md`, `docs/CSCCapstone-User-Research-10-14-25.csv`
- **Personas**: `docs/PERSONAS.md`
- **Metrics Plan**: `docs/METRICS.md`
- **A/B Testing**: `docs/ABTEST.md`
- **Code of Conduct**: `docs/CONDUCT.md`

---

## FlutterFlow Configuration

### Project Details

- **Project ID**: `c-s-c305-capstone-khj14l`
- **Plan**: Growth Plan (activated November 4, 2025)
- **API Base URL**: `https://api.flutterflow.io/v2/`
- **Total YAML Files**: 591 editable files
- **Partitioner Version**: 7
- **Schema Fingerprint**: `7187d822b3f49f947ca130c043831db422c37c53`

### Growth Plan Capabilities

The Growth Plan provides full programmatic access to edit the FlutterFlow project:

✅ **Available Features:**
- YAML file listing (`/v2/listPartitionedFileNames`)
- YAML download (`/v2/projectYamls`)
- YAML validation (`/v2/validateProjectYaml`)
- YAML updates (`/v2/updateProjectByYaml`)
- Full project editing via API
- No UI-only restrictions

❌ **Important Note:**
- FlutterFlow branches can ONLY be created in the FlutterFlow UI
- Git branches are managed locally (see Branch Strategy section)

### Authentication

FlutterFlow API uses **Bearer Token authentication**. The token is stored in GCP Secret Manager as `FLUTTERFLOW_LEAD_API_TOKEN`.

**Retrieve Token:**
```bash
gcloud secrets versions access latest --secret="FLUTTERFLOW_LEAD_API_TOKEN" --project=csc305project-475802
```

**Note**: Token value is stored securely in GCP Secret Manager and should never be hardcoded or documented.

---

## GCP & Secret Management

### Google Cloud Platform Setup

**Multi-Project Architecture**:

This project uses **two separate GCP projects** with distinct purposes:

1. **Secrets Project** (`csc305project-475802`)
   - Purpose: Secure credential storage via Secret Manager
   - Owner: juan_vallejo@uri.edu
   - Organization: uri.edu (698125975939)
   - Secret Manager: **ENABLED**
   - Used by: All scripts requiring API tokens/credentials

2. **Firebase Project** (`csc-305-dev-project`)
   - Purpose: Backend services (Cloud Functions, Firestore, Firebase)
   - Admin: juan_vallejo@uri.edu + team
   - Organization: Standalone (no org parent)
   - Secret Manager: **DISABLED** (not needed)
   - Used by: Firebase CLI, deployment scripts

**⚠️ IMPORTANT**: All `gcloud secrets` commands MUST specify `--project=csc305project-475802` because the default project (`csc-305-dev-project`) does not have Secret Manager enabled.

### Multi-Account Configuration

Three Google accounts are configured with different access levels:

1. **Personal Account** (juan.vallejo@jpteq.com)
   - Primary development account
   - Git commits for non-school projects

2. **School Account** (juan_vallejo@uri.edu)
   - Used for this CSC305 project
   - Git commits configured locally for this repo only
   - GitHub authentication

3. **Project Account** (specific to GlobalFlavors)
   - FlutterFlow project access
   - API token generation

### Secret Manager

**9 Secrets Configured:**

| Secret Name | Purpose | Usage |
|-------------|---------|-------|
| `FLUTTERFLOW_LEAD_API_TOKEN` | API authentication | YAML editing, project access |
| `FIREBASE_PROJECT_ID` | Firebase integration | Backend services |
| `GEMINI_API_KEY` | AI features | Recipe recommendations |
| `FIREBASE_API_KEY` | Firebase auth | User authentication |
| `FIREBASE_AUTH_DOMAIN` | Firebase auth | Auth redirects |
| `FIREBASE_STORAGE_BUCKET` | Firebase storage | Image uploads |
| `FIREBASE_MESSAGING_SENDER_ID` | Push notifications | FCM |
| `FIREBASE_APP_ID` | Firebase app config | App initialization |
| `FIREBASE_MEASUREMENT_ID` | Analytics | Usage tracking |

**Access Secrets:**
```bash
# List all secrets (MUST specify project)
gcloud secrets list --project=csc305project-475802

# Get specific secret (MUST specify project)
gcloud secrets versions access latest --secret="SECRET_NAME" --project=csc305project-475802

# Verify active account
gcloud auth list

# Verify current project
gcloud config get-value project
```

### Security Configuration

- **SSH Keys**: ed25519 (secure, modern algorithm)
- **Permissions**: Private keys at 600, public keys at 644
- **GitHub Token**: Stored in system keyring (not in files)
- **.gitignore**: 397+ lines protecting secrets
- **No secrets in code**: All credentials via Secret Manager

---

## Development Environment

### Installed Tools

| Tool | Version | Purpose |
|------|---------|---------|
| **Flutter SDK** | 3.24.5 (stable) | Flutter development |
| **Dart SDK** | 3.5.4 | Dart runtime |
| **Android SDK** | API 34 (Android 14) | Android builds |
| **Android Toolchain** | build-tools 34.0.0 | Android compilation |
| **GitHub CLI** | 2.65.0 | GitHub integration |
| **Git** | 2.43.0+ | Version control |
| **gcloud CLI** | Latest | GCP access |
| **jq** | Latest | JSON processing |

### PATH Configuration

**Added to `~/.bashrc`:**
```bash
# Flutter SDK
export PATH="$HOME/flutter/bin:$PATH"

# Android SDK
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH
```

### Flutter Doctor Status

```
✓ Flutter (Channel stable, 3.24.5)
✓ Android toolchain - develop for Android devices (API 34)
✓ Linux toolchain - develop for Linux desktop
✓ Chrome - develop for the web
! Android Studio (not installed) - NOT CRITICAL (SDK tools work)
✓ Connected device (3 available)
✓ Network resources
```

### System Specifications

- **OS**: Linux 6.14.0-35-generic (Ubuntu-based)
- **Architecture**: x86_64
- **Display**: GNOME/X11
- **Development Tools**: clang, cmake, ninja-build, GTK3

---

## GitHub Configuration

### Repository Setup

- **Repository**: CSCSoftwareDevelopment
- **GitHub User**: juanvallejo-teq
- **Authentication**: GitHub CLI + SSH keys
- **Remote**: origin (GitHub)

### Git Configuration

**Global Config** (preserved for other projects):
```bash
git config --global user.email "juan.vallejo@jpteq.com"
git config --global user.name "Juan Vallejo"
```

**Local Config** (this repository only):
```bash
git config user.email "juan_vallejo@uri.edu"
git config user.name "Juan Vallejo"
```

**Verify Current Config:**
```bash
# In this repo
git config user.email  # Returns: juan_vallejo@uri.edu

# Global config
git config --global user.email  # Returns: juan.vallejo@jpteq.com
```

### GitHub CLI

**Authentication Status:**
```bash
gh auth status
# Account: juanvallejo-teq
# Logged in: Yes
# Token: Stored in system keyring
```

**Common Commands:**
```bash
# View repo status
gh repo view

# List pull requests
gh pr list

# Create pull request
gh pr create --title "Title" --body "Description"

# View issues
gh issue list
```

---

## YAML Editing Workflow

### Overview

Our custom scripts provide full programmatic control over FlutterFlow project YAML files. This enables:
- Batch editing across multiple files
- Version control for FlutterFlow changes
- Automated testing and validation
- Git-based collaboration on FlutterFlow projects

### Available Scripts

All scripts located in `scripts/` directory. See `scripts/README.md` for detailed documentation.

#### 1. List YAML Files

**Script**: `scripts/list-yaml-files.sh`

```bash
./scripts/list-yaml-files.sh
```

**Output:**
- Sorted list of all 591 YAML files
- Project version info
- Schema fingerprint

#### 2. Download YAML Files

**Script**: `scripts/download-yaml.sh`

```bash
# Download all files
./scripts/download-yaml.sh

# Download specific file
./scripts/download-yaml.sh --file app-details
```

**Output Directory**: `flutterflow-yamls/` (gitignored)

#### 3. Validate YAML Changes

**Script**: `scripts/validate-yaml.sh`

```bash
./scripts/validate-yaml.sh <file-key> <yaml-file-path>

# Example
./scripts/validate-yaml.sh app-details flutterflow-yamls/app-details.yaml
```

**Always validate before updating!**

#### 4. Update FlutterFlow Project

**Script**: `scripts/update-yaml.sh`

```bash
./scripts/update-yaml.sh <file-key> <yaml-file-path>

# Example
./scripts/update-yaml.sh app-details flutterflow-yamls/app-details.yaml
```

**Safety Features:**
- Auto-validation before update
- Interactive confirmation prompt
- Detailed error reporting

### Typical Workflow Example

**Scenario**: Add a new metric tracking feature to app

```bash
# 1. Ensure on correct branch
git checkout JUAN-adding-metric

# 2. Download relevant YAML files
./scripts/download-yaml.sh --file app-state
./scripts/download-yaml.sh --file app-details

# 3. Edit files
nano flutterflow-yamls/app-state.yaml
# Add metric tracking state variables

# 4. Validate changes
./scripts/validate-yaml.sh app-state flutterflow-yamls/app-state.yaml

# 5. Apply to FlutterFlow
./scripts/update-yaml.sh app-state flutterflow-yamls/app-state.yaml

# 6. Verify in FlutterFlow UI
# Open https://app.flutterflow.io and check changes

# 7. Commit to git
git add flutterflow-yamls/app-state.yaml
git commit -m "Add metric tracking state variables"
git push origin JUAN-adding-metric
```

### YAML File Categories

The 591 YAML files are organized into:

- **Root Configuration**: `app-details`, `app-state`, `theme`, `authentication`
- **Collections**: `collections/id-*` (database collections)
- **Pages**: `page/id-*` (app screens)
- **Components**: `component/id-*` (reusable widgets)
- **Widget Trees**: `*/component-widget-tree-outline/node/*` (UI structure)
- **Actions**: `*/trigger_actions/*/action/*` (button clicks, navigation)
- **Custom Code**: `custom-code/actions/*`, `custom-code/widgets/*`
- **Platform Config**: `ad-mob`, `push-notifications`, `platforms`
- **Theme**: `theme/color-scheme`

---

## FlutterFlow API - Successful Upload Format

### Critical Discovery (November 4, 2025)

**Problem**: API was returning `success: true` but changes were NOT persisting to FlutterFlow.

**Root Cause**: Upload format is DIFFERENT from download format.

### Download vs Upload Formats

| Operation | Format | Field Name | Content Type |
|-----------|--------|------------|--------------|
| **Download** | Base64-encoded ZIP | `projectYamlBytes` OR `project_yaml_bytes` | Binary (ZIP) |
| **Validate** | Plain YAML string | `fileKey` + `fileContent` | JSON-escaped YAML |
| **Upload** | Plain YAML string | `fileKeyToContent` | JSON-escaped YAML |

### Correct Upload Workflow

```bash
# 1. Download (returns base64 ZIP)
curl "${API_BASE}/projectYamls?projectId=${PROJECT_ID}&fileName=app-state" \
  -H "Authorization: Bearer ${LEAD_TOKEN}" \
| jq -r '.value.projectYamlBytes // .value.project_yaml_bytes' \
| base64 --decode > app-state.zip

# 2. Extract YAML from ZIP
unzip -p app-state.zip app-state.yaml > app-state.yaml

# 3. Validate (plain YAML string)
YAML_STRING=$(jq -Rs . app-state.yaml)
curl -X POST "${API_BASE}/validateProjectYaml" \
  -H "Authorization: Bearer ${LEAD_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"projectId\":\"${PROJECT_ID}\",\"fileKey\":\"app-state\",\"fileContent\":${YAML_STRING}}"

# 4. Upload (plain YAML string with fileKeyToContent)
curl -X POST "${API_BASE}/updateProjectByYaml" \
  -H "Authorization: Bearer ${LEAD_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"projectId\":\"${PROJECT_ID}\",\"fileKeyToContent\":{\"app-state\":${YAML_STRING}}}"
```

### Key Learnings

1. **Download ≠ Upload Format**
   - Downloads: base64-encoded ZIP files
   - Uploads: plain YAML strings (NO ZIP, NO base64)

2. **Field Name Inconsistency**
   - Download response: `projectYamlBytes` (docs) OR `project_yaml_bytes` (actual)
   - Validate request: `fileKey` + `fileContent`
   - Upload request: `fileKeyToContent`

3. **Silent Failures**
   - Wrong payload format returns `success: true` but doesn't save
   - Always verify uploads by re-downloading

4. **Branch Limitations**
   - Project APIs do NOT support branch selection
   - All operations target main branch only

### Automated Scripts

For production use, see:
- `scripts/download-yaml.sh` - Handles download format correctly
- `scripts/add-app-state-variables.sh` - Complete automation example
- `scripts/FLUTTERFLOW_API_GUIDE.md` - Comprehensive teammate guide

**Reference**: See `docs/2025-11-04-D7-Retention-Variables-SUCCESS.md` for full discovery details.

---

## API Reference

### Base URL

```
https://api.flutterflow.io/v2/
```

### Authentication

All requests require Bearer token authentication:

```bash
curl -H "Authorization: Bearer $LEAD_TOKEN" \
  "https://api.flutterflow.io/v2/endpoint"
```

### Endpoints

#### GET /v2/listPartitionedFileNames

List all YAML files in the project.

**Parameters:**
- `projectId` (required): Project ID

**Response:**
```json
{
  "success": true,
  "value": {
    "version_info": {
      "partitioner_version": 7,
      "project_schema_fingerprint": "..."
    },
    "file_names": ["app-details", "app-state", ...]
  }
}
```

#### GET /v2/projectYamls

Download specific YAML file.

**Parameters:**
- `projectId` (required): Project ID
- `fileKey` (required): File identifier (e.g., "app-details")

**Response:**
```json
{
  "success": true,
  "project_yaml_bytes": "base64-encoded-yaml-content"
}
```

**Decode Content:**
```bash
echo "$response" | jq -r '.project_yaml_bytes' | base64 -d
```

#### POST /v2/validateProjectYaml

Validate YAML changes before applying.

**Request Body:**
```json
{
  "projectId": "c-s-c305-capstone-khj14l",
  "fileKey": "app-details",
  "projectYamlBytes": "base64-encoded-yaml"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Validation successful"
}
```

#### POST /v2/updateProjectByYaml

Apply YAML changes to project.

**Request Body:**
```json
{
  "projectId": "c-s-c305-capstone-khj14l",
  "fileKey": "app-details",
  "projectYamlBytes": "base64-encoded-yaml"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Project updated successfully"
}
```

**⚠️ Warning**: This modifies your live FlutterFlow project. Always validate first!

---

## Security & Best Practices

### Secret Management

✅ **DO:**
- Use GCP Secret Manager for all credentials
- Fetch secrets at runtime, never hardcode
- Rotate tokens regularly
- Use `.gitignore` to protect local secrets
- Clear temporary files after use

❌ **DON'T:**
- Commit API tokens to git
- Share tokens in messages/emails
- Store credentials in code
- Skip validation when updating YAML
- Push sensitive data to GitHub

### Git Security

**Current Protection:**
- `.gitignore` includes `flutterflow-yamls/` directory
- No `.env` files committed
- SSH keys properly secured (600 permissions)
- GitHub token in system keyring

**Recommended Additions:**
```bash
# Install security scanning
sudo apt install gitleaks

# Scan for secrets
gitleaks detect --source . --verbose

# Configure pre-commit hooks
# See: https://github.com/awslabs/git-secrets
```

### File Permissions

```bash
# SSH keys
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

# Known hosts
chmod 600 ~/.ssh/known_hosts

# Scripts
chmod 755 scripts/*.sh
```

### YAML Editing Safety

1. **Always validate before updating**
   ```bash
   ./scripts/validate-yaml.sh file-key path/to/file.yaml
   ```

2. **Review changes in FlutterFlow UI** after updates

3. **Commit YAML files to git** for version control

4. **Test thoroughly** after making changes

5. **Never skip validation** unless absolutely necessary

---

## Branch Strategy

### Git Branches (Local/GitHub)

- **main**: Stable production code, synced with GitHub
- **JUAN-adding-metric**: Current feature branch for metrics implementation

**Branch Commands:**
```bash
# List branches
git branch -a

# Create new branch from main
git checkout main
git pull origin main
git checkout -b JUAN-new-feature

# Switch branches
git checkout JUAN-adding-metric

# Push branch to GitHub
git push -u origin JUAN-adding-metric

# Update main from GitHub
git checkout main
git pull origin main
```

### FlutterFlow Branches

**⚠️ Important**: FlutterFlow branches can ONLY be created in the FlutterFlow UI, not via API.

**To create a FlutterFlow branch:**
1. Go to https://app.flutterflow.io
2. Open project: c-s-c305-capstone-khj14l
3. Click Branches > Create New Branch
4. Name it (e.g., "JUAN-adding-metric")

**Branch Sync Strategy:**
- Git branches: For code, scripts, documentation
- FlutterFlow branches: For UI/app changes in FlutterFlow editor
- YAML files: Bridge between git and FlutterFlow (version control for FF changes)

### Current Working Branch

```bash
# Current branch
git branch --show-current
# Output: JUAN-adding-metric

# Branch status
git status
# Shows: files staged, modified, untracked
```

---

## D7 Retention Metrics Deployment

### Overview

D7 Retention Metrics track user engagement through the "Day 7 Repeat Recipe Rate" - the percentage of users who complete 2+ recipes within 7 days of their first recipe completion.

**Deployment Status:** Backend Complete (2025-11-05)
**Documentation:** `DEPLOYMENT_STATUS.md`, `docs/MANUAL_PAGE_TRIGGER_WIRING.md`

### Deployed Components

#### Custom Dart Actions (2/3)

| Action | Status | Purpose |
|--------|--------|---------|
| `initializeUserSession` | ✓ Deployed | Track user sessions and app opens |
| `checkAndLogRecipeCompletion` | ✓ Deployed | Log recipe completions with metrics |
| `checkScrollCompletion` | ⏭️ Skipped | ScrollController parameter not supported |

**Deployment Method:** FlutterFlow API `/v2/syncCustomCodeChanges`
**Script:** `scripts/push-essential-actions-only.sh`
**Location:** `c_s_c305_capstone/lib/custom_code/actions/`

#### Firebase Cloud Functions (4/4)

All deployed to `csc-305-dev-project`:

1. **calculateD7Retention** (Scheduled, daily 2 AM UTC)
2. **calculateD7RetentionManual** (Callable)
3. **getD7RetentionMetrics** (HTTPS endpoint)
4. **getRetentionTrend** (HTTPS endpoint)

**Deployment Method:** Firebase CLI with service account
**Script:** `scripts/deploy-firebase-with-serviceaccount.sh`
**Runtime:** Node.js 20

#### Firestore Indexes (2/2)

1. **user_recipe_completions**: `(user_id, completed_at, is_first_recipe)`
2. **users**: `(cohort_date, d7_retention_eligible)`

**Deployment:** `firebase deploy --only firestore:indexes`

### Critical Finding: FlutterFlow API Limitations

**Discovery:** FlutterFlow's Growth Plan YAML API does NOT expose page-level triggers.

**Evidence:**
- 609 YAML files analyzed
- Zero page-level trigger files found (OnPageLoad, OnAuthSuccess, etc.)
- All triggers are widget-level only (ON_TAP, ON_LONG_PRESS)

**Implication:** Page-level triggers MUST be wired manually in FlutterFlow UI.

### Automation Research Findings

**Evaluated Approaches:**

| Approach | Status | Success Rate | Notes |
|----------|--------|--------------|-------|
| Playwright UI automation | ❌ Rejected | 15-30% | Shadow DOM incompatibility |
| YAML API (page triggers) | ❌ Not Available | N/A | Not exposed by FlutterFlow |
| YAML API (widget triggers) | ✅ Viable | 70-80% | For buttons, future Phase 2 |
| Manual UI wiring | ✅ Accepted | 100% | 2 hours one-time |

**Approved Strategy:** Hybrid approach
- Manual wiring for page-level triggers (unavoidable)
- YAML automation for widget-level actions (future phases)

### Next Steps

1. **Manual UI Wiring** (2 hours) - Follow `docs/MANUAL_PAGE_TRIGGER_WIRING.md`
   - HomePage OnPageLoad → initializeUserSession
   - GoldenPath OnPageLoad → initializeUserSession
   - Login OnAuthSuccess → initializeUserSession
   - RecipeViewPage Button → checkAndLogRecipeCompletion

2. **Phase 2** (Future) - Reverse-engineer YAML schema for widget automation
3. **Phase 3** (Future) - Create button automation scripts

---

## Firebase Backend

### Project Configuration

**Firebase Project:** csc-305-dev-project
**Firestore Database:** (default)
**Region:** us-central1
**Authentication:** Service account (firebase-adminsdk-fbsvc@csc-305-dev-project.iam.gserviceaccount.com)

### Deployed Functions

```bash
# List deployed functions
firebase functions:list --project=csc-305-dev-project

# View function logs
firebase functions:log --project=csc-305-dev-project
```

**Function URLs:**
- getD7RetentionMetrics: https://us-central1-csc-305-dev-project.cloudfunctions.net/getD7RetentionMetrics
- getRetentionTrend: https://us-central1-csc-305-dev-project.cloudfunctions.net/getRetentionTrend

### Deployment Scripts

**Deploy Functions:**
```bash
# Automated deployment with service account
./scripts/deploy-firebase-with-serviceaccount.sh

# Manual deployment (requires firebase login)
firebase deploy --only functions --project=csc-305-dev-project
```

**Deploy Indexes:**
```bash
firebase deploy --only firestore:indexes --project=csc-305-dev-project
```

### IAM Permissions

The following roles were granted for service account deployment:

**Service Account:** `firebase-adminsdk-fbsvc@csc-305-dev-project.iam.gserviceaccount.com`
- `roles/firebase.admin` - Firebase administration
- `roles/cloudfunctions.developer` - Deploy Cloud Functions
- `roles/cloudscheduler.admin` - Manage Cloud Scheduler
- `roles/serviceusage.serviceUsageConsumer` - Enable GCP APIs
- `roles/iam.serviceAccountUser` (on csc-305-dev-project@appspot.gserviceaccount.com)
- `roles/iam.serviceAccountUser` (on 54503053415-compute@developer.gserviceaccount.com)

**Grant Commands:**
```bash
# Grant Cloud Scheduler admin
gcloud projects add-iam-policy-binding csc-305-dev-project \
  --member="serviceAccount:firebase-adminsdk-fbsvc@csc-305-dev-project.iam.gserviceaccount.com" \
  --role="roles/cloudscheduler.admin"

# Grant service account user roles
gcloud iam service-accounts add-iam-policy-binding csc-305-dev-project@appspot.gserviceaccount.com \
  --member="serviceAccount:firebase-adminsdk-fbsvc@csc-305-dev-project.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"
```

### Firestore Collections

**Collections Created by D7 Retention:**
- `users` - User profiles with cohort tracking
- `user_sessions` - Session tracking data
- `user_recipe_completions` - Recipe completion events
- `retention_metrics` - Calculated D7 retention rates

**Indexes:**
- Defined in `firestore.indexes.json`
- Deployed via Firebase CLI

### Monitoring

```bash
# Check function logs
firebase functions:log --project=csc-305-dev-project --limit=50

# View Firestore data
# Navigate to: https://console.firebase.google.com/project/csc-305-dev-project/firestore

# Check Cloud Scheduler jobs
gcloud scheduler jobs list --project=csc-305-dev-project --location=us-central1
```

---

## FlutterFlow Action Wiring

### Overview

FlutterFlow custom actions must be wired to UI triggers to execute. This section documents the wiring workflow and limitations.

### Key Limitations Discovered

**Page-Level Triggers NOT Available via API:**
- OnPageLoad
- OnAuthSuccess
- OnPageExit
- OnAppResume

**Widget-Level Triggers Available via API:**
- ON_TAP (buttons, containers)
- ON_LONG_PRESS
- ON_DOUBLE_TAP
- Other widget events

### Manual Wiring Process

**Required for:** Page-level triggers (OnPageLoad, OnAuthSuccess)
**Time Required:** 20-30 minutes per page
**Documentation:** `docs/MANUAL_PAGE_TRIGGER_WIRING.md`

**Workflow:**
1. Open FlutterFlow UI: https://app.flutterflow.io/project/c-s-c305-capstone-khj14l
2. Navigate to target page
3. Select Scaffold (root widget) → Actions & Logic tab
4. Add trigger (e.g., "On Page Load")
5. Select Custom Action from dropdown
6. Configure parameters (if any)
7. Save

**Example: HomePage OnPageLoad**
```
FlutterFlow UI:
Pages → HomePage → Scaffold → Actions & Logic
→ On Page Load → + Add Action
→ Custom Action → initializeUserSession
→ Confirm
```

### Widget-Level Automation (Future)

**Planned for Phase 2-3:**

1. Manually wire one button to discover YAML schema
2. Download updated YAML files
3. Reverse-engineer custom action reference format
4. Create automation script: `scripts/wire-custom-action-to-button.sh`
5. Automate additional button additions via YAML API

**YAML Structure (Button Trigger):**
```
Location: page/id-Scaffold_<pageId>/page-widget-tree-outline/node/id-Button_<buttonId>/trigger_actions/id-ON_TAP/action/id-<actionId>.yaml
```

**Sample discovered structure:**
```yaml
navigate:
  isNavigateBack: true
  navigateToRootPageOnFailure: true
key: <actionId>
```

Custom action format TBD after manual wiring in Phase 2.

### Verification

**After Wiring:**
1. Check FlutterFlow UI - Action Flow diagram shows connections
2. Test in preview mode - Console logs show action execution
3. Verify Firestore - Collections receive expected data
4. Monitor Firebase Analytics - Events appear (24-hour delay)

**Verification Script (Future):**
```bash
# To be created
./scripts/verify-action-wiring.sh
```

---

## Troubleshooting

### API Issues

**Problem**: "Unauthorized" error

**Solutions:**
```bash
# 1. Verify token access
gcloud secrets versions access latest --secret="FLUTTERFLOW_LEAD_API_TOKEN"

# 2. Check GCP authentication
gcloud auth list

# 3. Re-authenticate if needed
gcloud auth login
```

**Problem**: "Validation failed"

**Solutions:**
```bash
# 1. Check YAML syntax
yamllint flutterflow-yamls/your-file.yaml

# 2. Compare with original
./scripts/download-yaml.sh --file your-file
diff flutterflow-yamls/your-file.yaml flutterflow-yamls/your-file.yaml.backup

# 3. Review API error details (shown in script output)
```

### Git Issues

**Problem**: "Failed to push" / merge conflicts

**Solutions:**
```bash
# 1. Update local main
git checkout main
git pull origin main

# 2. Rebase feature branch
git checkout JUAN-adding-metric
git rebase main

# 3. Resolve conflicts
# Edit conflicted files, then:
git add .
git rebase --continue
```

**Problem**: Wrong git email in commits

**Solutions:**
```bash
# Verify local config
git config user.email  # Should be juan_vallejo@uri.edu

# Fix if wrong
git config user.email "juan_vallejo@uri.edu"

# Amend last commit if needed
git commit --amend --reset-author
```

### Flutter Issues

**Problem**: "Flutter command not found"

**Solutions:**
```bash
# 1. Check PATH
echo $PATH | grep flutter

# 2. Reload bashrc
source ~/.bashrc

# 3. Verify installation
ls $HOME/flutter/bin/flutter

# 4. Add to PATH manually if needed
export PATH="$HOME/flutter/bin:$PATH"
```

**Problem**: "Android SDK not found"

**Solutions:**
```bash
# 1. Check ANDROID_HOME
echo $ANDROID_HOME

# 2. Verify SDK location
ls $HOME/Android/Sdk

# 3. Set environment variables
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH
```

### Script Issues

**Problem**: "jq: command not found"

**Solution:**
```bash
sudo apt update
sudo apt install jq -y
```

**Problem**: "Permission denied" when running scripts

**Solution:**
```bash
chmod +x scripts/*.sh
```

**Problem**: Downloaded YAML files appear empty or corrupted

**Solution:**
```bash
# Check if base64 decoding worked
file flutterflow-yamls/app-details.yaml
# Should output: ASCII text or UTF-8 Unicode text

# Re-download if needed
./scripts/download-yaml.sh --file app-details
```

---

## Quick Reference Commands

### Daily Workflow

```bash
# 1. Start of day - Update repo
git checkout main
git pull origin main
git checkout JUAN-adding-metric
git merge main

# 2. View FlutterFlow files
./scripts/list-yaml-files.sh | grep app-

# 3. Download for editing
./scripts/download-yaml.sh --file app-state

# 4. After editing
./scripts/validate-yaml.sh app-state flutterflow-yamls/app-state.yaml
./scripts/update-yaml.sh app-state flutterflow-yamls/app-state.yaml

# 5. End of day - Commit work
git add .
git commit -m "Add metric tracking feature"
git push origin JUAN-adding-metric
```

### Secret Access

```bash
# Get LEAD token
gcloud secrets versions access latest --secret="FLUTTERFLOW_LEAD_API_TOKEN"

# Get Firebase project ID
gcloud secrets versions access latest --secret="FIREBASE_PROJECT_ID"

# Get Gemini API key
gcloud secrets versions access latest --secret="GEMINI_API_KEY"
```

### GitHub Operations

```bash
# View repo
gh repo view

# Create PR
gh pr create --title "Add metrics tracking" --body "Implements user engagement metrics"

# Check PR status
gh pr list

# View PR
gh pr view 123
```

### Flutter Operations

```bash
# Check Flutter status
flutter doctor

# Run app (if Flutter project added)
flutter run

# Build Android APK
flutter build apk

# Build for web
flutter build web
```

---

## Contact & Resources

### Team

- **Lead Developer**: Juan Vallejo
- **Email**: juan_vallejo@uri.edu (school), juan.vallejo@jpteq.com (personal)
- **GitHub**: juanvallejo-teq

### Resources

- **FlutterFlow Project**: https://app.flutterflow.io/project/c-s-c305-capstone-khj14l
- **FlutterFlow API Docs**: https://api.flutterflow.io
- **GitHub Repository**: [Your GitHub URL]
- **GCP Console**: https://console.cloud.google.com
- **Flutter Docs**: https://docs.flutter.dev

### Support

- **FlutterFlow Support**: support@flutterflow.io
- **Course Instructor**: [Instructor email]
- **Team Communication**: [Slack/Discord/etc.]

---

## Version History

| Date | Version | Changes |
|------|---------|---------|
| 2025-11-05 | 2.0 | Added D7 Retention Metrics deployment, Firebase Backend section, FlutterFlow Action Wiring limitations, automation research findings |
| 2025-11-04 | 1.2 | Added Communication Style & Standards with templates and compliance checklist |
| 2025-11-04 | 1.1 | Added FlutterFlow API upload format discovery (correct payload format) |
| 2025-11-04 | 1.0 | Initial documentation created with full YAML workflow |

---

## Recent Updates (2025-11-05)

### D7 Retention Metrics Backend Deployment

**Completed:**
- ✅ 2 Custom Dart actions deployed via FlutterFlow API
- ✅ 4 Firebase Cloud Functions deployed (scheduled, callable, HTTPS endpoints)
- ✅ 2 Firestore composite indexes deployed
- ✅ 12 app state variables configured
- ✅ IAM permissions configured for service account deployment
- ✅ Comprehensive documentation created

**Key Findings:**
- FlutterFlow YAML API does NOT expose page-level triggers (OnPageLoad, OnAuthSuccess)
- Page triggers require manual UI wiring (2 hours one-time)
- Widget-level triggers CAN be automated via YAML API (future phases)
- Playwright UI automation rejected due to Shadow DOM incompatibility

**New Documentation:**
- `DEPLOYMENT_STATUS.md` - Complete deployment status
- `docs/MANUAL_PAGE_TRIGGER_WIRING.md` - Step-by-step UI wiring guide
- `scripts/deploy-firebase-with-serviceaccount.sh` - Automated Firebase deployment

**Next Steps:**
1. Execute manual UI wiring (2 hours) following `docs/MANUAL_PAGE_TRIGGER_WIRING.md`
2. Test in FlutterFlow preview mode
3. Monitor Firebase Analytics and Firestore collections
4. Wait 7 days for first D7 cohort data

---

**End of CLAUDE.md**

*This document should be updated whenever significant changes are made to the project configuration, workflow, or tooling.*
