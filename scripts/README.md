# scripts/ - Deployment and Automation Tools

**Last Updated**: 2025-11-05

This directory contains production-ready scripts for deploying the D7 Retention System and managing FlutterFlow project configuration via API.

---

## Quick Start

### Deploy D7 Retention System

```bash
# Complete end-to-end deployment (recommended)
./scripts/deploy.sh full

# VS Code extension setup only (for Custom Actions)
./scripts/deploy.sh vscode

# Firebase backend only (Cloud Functions + Firestore indexes)
./scripts/deploy.sh firebase
```

### FlutterFlow API Operations

```bash
# Set API token (required)
export LEAD_TOKEN=$(gcloud secrets versions access latest --secret=FLUTTERFLOW_LEAD_API_TOKEN)

# List all available YAML files
./scripts/flutterflow.sh list

# Download specific YAML file
./scripts/flutterflow.sh download app-state

# Validate YAML changes before upload
./scripts/flutterflow.sh validate app-state flutterflow-yamls/app-state.yaml

# Upload YAML to FlutterFlow
./scripts/flutterflow.sh upload app-state flutterflow-yamls/app-state.yaml
```

---

## Script Index

### Wrapper Scripts (User-Facing)

| Script | Purpose | Usage |
|--------|---------|-------|
| **deploy.sh** | Master deployment wrapper | `./scripts/deploy.sh [vscode\|firebase\|full]` |
| **flutterflow.sh** | FlutterFlow API wrapper | `./scripts/flutterflow.sh [download\|validate\|upload\|list] <file-key>` |

### Core Deployment Scripts

| Script | Purpose | Time | Usage |
|--------|---------|------|-------|
| **setup-vscode-deployment.sh** | Interactive VS Code extension setup wizard | 45-60 min | `./scripts/setup-vscode-deployment.sh` |
| **deploy-d7-retention-complete.sh** | Complete D7 retention deployment (Firebase + guides) | 2.5-3 hrs | `./scripts/deploy-d7-retention-complete.sh` |
| **test-retention-function.sh** | Deploy and test Firebase Cloud Functions | 15 min | `./scripts/test-retention-function.sh` |

### FlutterFlow API Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| **list-yaml-files.sh** | List all 591 YAML files in FlutterFlow project | `./scripts/list-yaml-files.sh` |
| **download-yaml.sh** | Download specific YAML file (base64 ZIP → extracted YAML) | `./scripts/download-yaml.sh --file <file-key>` |
| **validate-yaml.sh** | Validate YAML changes before upload | `./scripts/validate-yaml.sh <file-key> <yaml-path>` |
| **update-yaml.sh** | Upload YAML changes to FlutterFlow | `./scripts/update-yaml.sh <file-key> <yaml-path>` |

---

## Common Workflows

### 1. Deploy Custom Actions to FlutterFlow

**Method A: VS Code Extension (Recommended)**

```bash
./scripts/deploy.sh vscode
```

Guides you through:
1. Installing FlutterFlow VS Code Extension
2. Generating API key
3. Downloading project structure
4. Copying Dart action files
5. Pushing to FlutterFlow

**Time**: 45-60 minutes

### 2. Update FlutterFlow App State Variables

```bash
# 1. Set API token
export LEAD_TOKEN=$(gcloud secrets versions access latest --secret=FLUTTERFLOW_LEAD_API_TOKEN)

# 2. Download current app-state.yaml
./scripts/flutterflow.sh download app-state

# 3. Edit the YAML file
nano flutterflow-yamls/app-state.yaml

# 4. Validate changes
./scripts/flutterflow.sh validate app-state

# 5. Upload to FlutterFlow
./scripts/flutterflow.sh upload app-state

# 6. Verify in FlutterFlow UI
# Open: https://app.flutterflow.io/project/c-s-c305-capstone-khj14l
```

**Time**: 10-15 minutes per update

### 3. Deploy Firebase Backend

```bash
./scripts/deploy.sh firebase
```

Deploys:
- 4 Cloud Functions (D7 calculation, manual trigger, metrics API, trends)
- 2 Firestore composite indexes
- Firebase Functions configuration

**Time**: 15 minutes

### 4. Test Firebase Cloud Functions

```bash
./scripts/test-retention-function.sh
```

Provides multiple testing methods:
- Manual callable function test
- HTTP endpoint test
- Scheduled function simulation

**Time**: 5-10 minutes

---

## Environment Variables

### Required

| Variable | Source | Usage |
|----------|--------|-------|
| `LEAD_TOKEN` | GCP Secret Manager | FlutterFlow API authentication |

```bash
export LEAD_TOKEN=$(gcloud secrets versions access latest --secret=FLUTTERFLOW_LEAD_API_TOKEN)
```

### Optional

| Variable | Default | Purpose |
|----------|---------|---------|
| `API_BASE` | `https://api.flutterflow.io/v2` | FlutterFlow API base URL |
| `PROJECT_ID` | `c-s-c305-capstone-khj14l` | FlutterFlow project ID |

---

## Prerequisites

### All Scripts
- Bash ≥ 4.0
- `jq` (JSON processor)
- `curl` (HTTP client)
- `unzip` (ZIP extraction)

Install missing tools:
```bash
sudo apt-get update
sudo apt-get install -y jq curl unzip
```

### FlutterFlow Scripts
- GCP authentication: `gcloud auth login`
- FlutterFlow API token (from Secret Manager)

### Firebase Scripts
- Firebase CLI: `npm install -g firebase-tools`
- Firebase authentication: `firebase login`
- Node.js ≥ 18 (for Cloud Functions)

### VS Code Extension Scripts
- VS Code installed
- FlutterFlow Growth Plan account
- FlutterFlow VS Code Extension: "FlutterFlow: Custom Code Editor"

---

## Troubleshooting

### "LEAD_TOKEN: unbound variable"

```bash
# Fetch token from Secret Manager
export LEAD_TOKEN=$(gcloud secrets versions access latest --secret=FLUTTERFLOW_LEAD_API_TOKEN)

# Or use the hardcoded token (from CLAUDE.md)
export LEAD_TOKEN="9dc3d62e-6d19-4831-9386-02760f9fb7c0"
```

### "jq: command not found"

```bash
sudo apt-get install jq
```

### FlutterFlow API returns "Invalid file key"

**Cause**: Attempting to create new YAML files via API (not supported)

**Solution**: FlutterFlow Project API is update-only. Use VS Code Extension for creating new custom actions.

See: `docs/archive/GPT5_ANALYSIS_AND_SOLUTION.md` for full investigation.

### Firebase deployment fails

```bash
# Check authentication
firebase login --reauth

# Verify project
firebase use

# Check Node.js version (requires ≥18)
node --version
```

---

## File Permissions

All `*.sh` files must be executable:

```bash
# Fix permissions
find scripts -type f -name '*.sh' -exec chmod 0755 {} \;

# Verify
ls -l scripts/*.sh
```

---

## Investigation & Archive Scripts

Development/investigation scripts have been moved to `private-dev-docs/`:

**Investigations** (`private-dev-docs/investigations/`):
- API pattern testing (7 scripts)
- Used during FlutterFlow API reverse-engineering (Nov 2025)
- Preserved for reference but not needed for production

**Archive** (`private-dev-docs/archive/`):
- One-off scripts already executed (5 scripts)
- Experimental approaches that didn't work
- Superseded by newer implementations

---

## Additional Resources

- **Complete API Guide**: `private-dev-docs/FLUTTERFLOW_API_GUIDE.md`
- **Deployment Guide**: `docs/D7_RETENTION_DEPLOYMENT.md`
- **Technical Reference**: `docs/D7_RETENTION_TECHNICAL.md`
- **Project Context**: `CLAUDE.md`
- **Change History**: `CHANGELOG.md`

---

## Conventions

1. **All scripts require Bash ≥ 4** and POSIX-compliant tools
2. **All `*.sh` files are executable** (chmod 0755)
3. **Set -e/-u/-o pipefail** for early failure detection
4. **Environment variables** documented in script headers
5. **Color output** for readability (GREEN=success, YELLOW=warning, RED=error)
6. **Idempotent operations** where possible (safe to re-run)

---

**Maintained by**: Juan Vallejo (juan_vallejo@uri.edu)
**Last Updated**: 2025-11-05
**Branch**: JUAN-adding-metric
