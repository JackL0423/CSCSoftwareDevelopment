# CLAUDE.md - AI Quick Start Context

> **Purpose**: Essential context for AI assistants. For detailed documentation, see [docs/README.md](docs/README.md)

**Last Updated**: November 17, 2025
**Current Branch**: repo-organization-2025-11
**Status**: Repository reorganization complete (96% size reduction)

---

## Quick Start

GlobalFlavors is a FlutterFlow mobile app for international cuisine discovery (URI CSC305 Capstone).

**Get started in 3 commands:**
```bash
# 1. Load secrets
source scripts/utilities/load-secrets.sh

# 2. Download FlutterFlow YAML
scripts/flutterflow/download-yaml.sh --file app-state

# 3. See available workflows
ls scripts/flutterflow/
```

**Emergency contacts**: See [CONTRIBUTING.md](CONTRIBUTING.md#team)

---

## Project Essentials

### FlutterFlow
- **Project ID**: [FLUTTERFLOW_PROJECT_ID]
- **Plan**: Growth Plan (full YAML API access)
- **Files**: 591 editable YAML files
- **Detailed config**: See [FlutterFlow Configuration](#flutterflow-configuration) below

### GCP Secrets (3 required)
```bash
source scripts/utilities/load-secrets.sh
# Loads: FLUTTERFLOW_API_TOKEN, FIREBASE_PROJECT_ID, GEMINI_API_KEY
```
**All secrets**: See [docs/architecture/GCP_SECRETS.md](docs/architecture/GCP_SECRETS.md)

### Git Configuration
- **Multi-account**: [REDACTED]@example.edu (this project), [REDACTED]@example.com (personal)
- **Branch strategy**: Feature branches from main, see [Branch Strategy](#branch-strategy)

---

## Common Workflows

### Edit FlutterFlow YAML
```bash
# 1. Download
scripts/flutterflow/download-yaml.sh --file app-state

# 2. Edit
nano flutterflow-yamls/app-state.yaml

# 3. Validate & Upload
scripts/flutterflow/validate-yaml.sh app-state flutterflow-yamls/app-state.yaml
scripts/flutterflow/update-yaml.sh app-state flutterflow-yamls/app-state.yaml
```
**Detailed guide**: [docs/guides/YAML_EDITING_GUIDE.md](docs/guides/YAML_EDITING_GUIDE.md)

### Deploy Firebase Functions
```bash
scripts/firebase/deploy-firebase-with-serviceaccount.sh
```
**Detailed guide**: [docs/architecture/D7_RETENTION_DEPLOYMENT.md](docs/architecture/D7_RETENTION_DEPLOYMENT.md)

### Run Tests
```bash
scripts/testing/test-retention-function.sh
scripts/testing/verify-metrics-flow.sh
```

---

## Tool & File Reference

### Scripts (by category)
- `scripts/flutterflow/` - YAML API operations (8 scripts)
- `scripts/firebase/` - Backend deployment (2 scripts)
- `scripts/testing/` - Test & verification (7 scripts)
- `scripts/utilities/` - Shared utilities (3 scripts)

**Full index**: [scripts/README.md](scripts/README.md)

### Documentation (by category)
- `docs/project/` - Business docs
- `docs/architecture/` - Technical architecture
- `docs/guides/` - How-to guides
- `docs/implementation/` - Implementation notes

**Full index**: [docs/README.md](docs/README.md)

### Key Files
- [CHANGELOG.md](CHANGELOG.md) - Version history
- [CONTRIBUTING.md](CONTRIBUTING.md) - Communication standards, team processes
- [SECURITY.md](SECURITY.md) - Security policy
- [FLUTTERFLOW_API_OPTIMIZATION_SUMMARY.md](FLUTTERFLOW_API_OPTIMIZATION_SUMMARY.md) - Performance benchmarks

---

## Current State

**Branch**: repo-organization-2025-11
**Last major changes**: Repository reorganization (Nov 17, 2025)
- 96% size reduction (8.2GB → 323MB)
- Scripts/docs into subdirectories
- Pre-commit hooks + Git LFS enabled

**Next priorities**:
1. Root file audit (20 → <15 files)
2. Pre-commit hook testing
3. Documentation updates

**Known issues**: None blocking

---

## Navigation & Deep Dives

**For detailed documentation, see:**

| Topic | Document |
|-------|----------|
| Communication standards | [CONTRIBUTING.md](CONTRIBUTING.md) |
| Templates (commits, PRs, etc.) | [docs/guides/TEMPLATES.md](docs/guides/TEMPLATES.md) |
| YAML editing workflows | [docs/guides/YAML_EDITING_GUIDE.md](docs/guides/YAML_EDITING_GUIDE.md) |
| FlutterFlow API reference | [scripts/FLUTTERFLOW_API_GUIDE.md](scripts/FLUTTERFLOW_API_GUIDE.md) |
| Performance benchmarks | [FLUTTERFLOW_API_OPTIMIZATION_SUMMARY.md](FLUTTERFLOW_API_OPTIMIZATION_SUMMARY.md) |
| GCP secrets management | [docs/architecture/GCP_SECRETS.md](docs/architecture/GCP_SECRETS.md) |
| Architecture decisions | [docs/architecture/](docs/architecture/) |
| Historical changes | [CHANGELOG.md](CHANGELOG.md) |
| Team processes | [CONTRIBUTING.md](CONTRIBUTING.md) |
| Security policy | [SECURITY.md](SECURITY.md) |

---

## Detailed Sections (Preserved for Context)

The sections below provide essential context that doesn't fit in external docs.

### Project Overview

**Project Name**: GlobalFlavors
**Course**: CSC305 Software Development Capstone
**Institution**: University of Rhode Island
**Team Lead**: Jack Light ([REDACTED]@example.edu)

**Description**: Mobile application built with FlutterFlow for discovering international cuisines with recipe browsing, user authentication, and personalized recommendations.

**Key Documents**: See [docs/README.md](docs/README.md#project-documentation)

---

### FlutterFlow Configuration

**Project Details:**
- **Project ID**: [FLUTTERFLOW_PROJECT_ID]
- **Plan**: Growth Plan (activated November 4, 2025)
- **API Base URL**: https://api.flutterflow.io/v2/
- **Total YAML Files**: 591 editable files
- **Partitioner Version**: 7

**Growth Plan Capabilities:**
✅ YAML file listing, download, validation, updates
✅ Full project editing via API
❌ FlutterFlow branches must be created in UI (not API)

**Authentication**: Bearer Token via GCP Secret Manager (`FLUTTERFLOW_LEAD_API_TOKEN`)

---

### FlutterFlow Automation Skills

**Status**: Phase 2 In Progress (Schema Learning)
**Documentation**: [docs/FLUTTERFLOW_SKILL_IMPLEMENTATION.md](docs/FLUTTERFLOW_SKILL_IMPLEMENTATION.md)

**Key Components:**
1. **SQLite State Database** (`~/.flutterflow-skill/state.db`) - 8 tables for file tracking
2. **Incremental Sync** - 5-10 min → ≤60s for <3% changed files
3. **Pattern Learning** - JSON Schema extraction from YAML examples
4. **Button Wiring Automation** - 30 min manual → 2 commands

**Performance**: See [FLUTTERFLOW_API_OPTIMIZATION_SUMMARY.md](FLUTTERFLOW_API_OPTIMIZATION_SUMMARY.md)

---

### GCP & Secret Management

**Multi-Project Architecture:**
1. **Secrets Project** ([GCP_SECRETS_PROJECT_ID]) - Secret Manager (ENABLED)
2. **Firebase Project** ([FIREBASE_PROJECT_ID]) - Backend services

**⚠️ IMPORTANT**: All `gcloud secrets` commands must specify `--project=[GCP_SECRETS_PROJECT_ID]`

**10 Secrets Available** (3 auto-loaded):
- `FLUTTERFLOW_LEAD_API_TOKEN` ✅
- `FIREBASE_PROJECT_ID` ✅
- `GEMINI_API_KEY` ✅
- 7 others (see [docs/architecture/GCP_SECRETS.md](docs/architecture/GCP_SECRETS.md))

**Load Secrets:**
```bash
source scripts/utilities/load-secrets.sh  # 300ms parallel loading
```

**Full reference**: [docs/architecture/GCP_SECRETS.md](docs/architecture/GCP_SECRETS.md)

---

### Development Environment

**Installed Tools:**
- Flutter SDK: 3.24.5 (stable)
- Dart SDK: 3.5.4
- Android SDK: API 34
- GitHub CLI: 2.65.0
- gcloud CLI, jq, git

**System**: Linux 6.14.0-35-generic, Ubuntu 24.04.3 LTS

---

### GitHub Configuration

**Repository**: CSCSoftwareDevelopment
**GitHub User**: juanvallejo-teq
**Authentication**: GitHub CLI + SSH (ed25519)

**Git Config**:
- **Global**: [REDACTED]@example.com (personal)
- **Local** (this repo): [REDACTED]@example.edu (school)

---

### Branch Strategy

**Main Branch**: `main` (or default branch if different)
**Feature Branches**: `feature/*`, `bugfix/*`, `docs/*`, `chore/*`

**Current Branch**: repo-organization-2025-11

**FlutterFlow Branches**: Must be created in FlutterFlow UI (API doesn't support branch creation)

**Workflow:**
```bash
# Create feature branch
git checkout main
git pull origin main
git checkout -b feature/my-feature

# Work and commit
git add .
git commit -m "feat: add feature"
git push origin feature/my-feature

# Create PR via GitHub CLI
gh pr create --title "Add feature" --body "Description"
```

---

### D7 Retention Metrics Deployment

**Status**: Backend Complete (2025-11-05)
**Documentation**: [docs/architecture/D7_RETENTION_DEPLOYMENT.md](docs/architecture/D7_RETENTION_DEPLOYMENT.md)

**Deployed Components:**
- 2 Custom Dart actions (via FlutterFlow API)
- 4 Firebase Cloud Functions (scheduled, callable, HTTPS endpoints)
- 2 Firestore indexes

**Key Finding**: Page-level triggers (OnPageLoad, OnAuthSuccess) not exposed via API - must wire manually in UI.

**Next Steps**: See [docs/architecture/MANUAL_PAGE_TRIGGER_WIRING.md](docs/architecture/MANUAL_PAGE_TRIGGER_WIRING.md)

---

### Firebase Backend

**Firebase Project**: [FIREBASE_PROJECT_ID]
**Region**: us-central1

**Deployed Functions:**
- calculateD7Retention (scheduled, daily 2 AM UTC)
- calculateD7RetentionManual (callable)
- getD7RetentionMetrics (HTTPS)
- getRetentionTrend (HTTPS)

**Deployment**:
```bash
scripts/firebase/deploy-firebase-with-serviceaccount.sh
```

---

### FlutterFlow Action Wiring

**Manual Required** (page-level triggers):
- OnPageLoad, OnAuthSuccess, OnPageExit

**API Available** (widget-level triggers):
- ON_TAP, ON_LONG_PRESS, ON_DOUBLE_TAP

**Process**: See [docs/architecture/MANUAL_PAGE_TRIGGER_WIRING.md](docs/architecture/MANUAL_PAGE_TRIGGER_WIRING.md)

---

### Security & Best Practices

**Secret Management:**
✅ GCP Secret Manager for all credentials
✅ No secrets in code
✅ `.gitignore` protects 397+ patterns
❌ Never commit API tokens
❌ Never share secrets via messages

**Git Security:**
- Pre-commit hooks (gitleaks, shellcheck)
- GPG signing (optional)
- SSH keys (ed25519, 600 permissions)

**Full policy**: [SECURITY.md](SECURITY.md)

---

### Repository Governance

**Pre-Commit Hooks** (`.pre-commit-config.yaml`):
- gitleaks (secret scanning)
- shellcheck (shell script validation)
- check-added-large-files (max 5MB)

**Git LFS** (`.gitattributes`):
- Binary assets: *.png, *.jpg, *.mp4, *.har
- Large data: *.zip, *.db, *.sqlite

**Documentation**:
- [LICENSE](LICENSE) - MIT License
- [SECURITY.md](SECURITY.md) - Security policy
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) - Community standards
- [CHANGELOG.md](CHANGELOG.md) - Version history

---

### Troubleshooting

**Common Issues:**

1. **"Permission denied" (secrets)**
   ```bash
   gcloud auth list  # Check active account
   gcloud auth login [REDACTED]@example.edu
   ```

2. **"Validation failed" (YAML)**
   ```bash
   yamllint file.yaml
   diff original.yaml modified.yaml
   ```

3. **"Rate limiting" (API)**
   - Use ZIP method for bulk uploads (scripts/bulk-update-zip.sh)
   - See [docs/guides/YAML_EDITING_GUIDE.md](docs/guides/YAML_EDITING_GUIDE.md#troubleshooting)

4. **"jq: command not found"**
   ```bash
   sudo apt install jq -y
   ```

**Full troubleshooting**: See respective guides in [docs/guides/](docs/guides/)

---

## Quick Reference Commands

### Daily Workflow
```bash
# 1. Update repo
git checkout main && git pull origin main
git checkout <your-branch> && git merge main

# 2. Load secrets
source scripts/utilities/load-secrets.sh

# 3. Work on FlutterFlow YAML
scripts/flutterflow/download-yaml.sh --file app-state
nano flutterflow-yamls/app-state.yaml
scripts/flutterflow/update-yaml.sh app-state flutterflow-yamls/app-state.yaml

# 4. Commit
git add . && git commit -m "feat: description"
git push origin <your-branch>
```

### Secret Access
```bash
# Get API token
gcloud secrets versions access latest --secret="FLUTTERFLOW_LEAD_API_TOKEN" --project=[GCP_SECRETS_PROJECT_ID]
```

### GitHub Operations
```bash
gh repo view
gh pr create --title "Title" --body "Description"
gh pr list
```

---

## Contact & Resources

**Team Lead**: Jack Light
**Email**: [REDACTED]@example.edu (school), [REDACTED]@example.com (personal)
**GitHub**: juanvallejo-teq

**Resources**:
- FlutterFlow Project: https://app.flutterflow.io/project/[FLUTTERFLOW_PROJECT_ID]
- GCP Console: https://console.cloud.google.com
- Firebase Console: https://console.firebase.google.com/project/[FIREBASE_PROJECT_ID]

**Support**: See [CONTRIBUTING.md](CONTRIBUTING.md)

---

## Version History

See [CHANGELOG.md](CHANGELOG.md) for complete history.

**Recent versions**:
- v3.0 (2025-11-17): Repository reorganization, optimization
- v2.2 (2025-11-06): ZIP upload method
- v2.1 (2025-11-06): Bulk upload discovery
- v2.0 (2025-11-05): D7 Retention metrics

---

**End of Quick Start Context** - For comprehensive documentation, explore [docs/](docs/) and [scripts/](scripts/)
