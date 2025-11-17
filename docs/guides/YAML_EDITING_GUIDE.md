# FlutterFlow YAML Editing Guide

> **Complete reference for editing FlutterFlow project YAML files via API**

**Last Updated**: November 17, 2025
**Project**: GlobalFlavors CSC305 Capstone
**FlutterFlow Plan**: Growth Plan (full YAML API access)

---

## Table of Contents

1. [Overview](#overview)
2. [Available Scripts](#available-scripts)
3. [Performance Comparison](#performance-comparison)
4. [Typical Workflows](#typical-workflows)
5. [YAML File Categories](#yaml-file-categories)
6. [Troubleshooting](#troubleshooting)

---

## Overview

Our custom scripts provide full programmatic control over FlutterFlow project YAML files. This enables:
- Batch editing across multiple files
- Version control for FlutterFlow changes
- Automated testing and validation
- Git-based collaboration on FlutterFlow projects

**Key Benefits**:
- 591 editable YAML files
- API-first workflows
- Bulk operations (10-20x faster than manual)
- Automatic validation and verification

---

## Available Scripts

All scripts located in `scripts/` directory. See [`scripts/README.md`](../../scripts/README.md) for detailed documentation.

### 1. List YAML Files

**Script**: `scripts/flutterflow/list-yaml-files.sh`

```bash
./scripts/flutterflow/list-yaml-files.sh
```

**Output:**
- Sorted list of all 591 YAML files
- Project version info
- Schema fingerprint

---

### 2. Download YAML Files

**Script**: `scripts/flutterflow/download-yaml.sh`

```bash
# Download all files
./scripts/flutterflow/download-yaml.sh

# Download specific file
./scripts/flutterflow/download-yaml.sh --file app-details
```

**Output Directory**: `flutterflow-yamls/` (gitignored)

---

### 3. Validate YAML Changes

**Script**: `scripts/flutterflow/validate-yaml.sh`

```bash
./scripts/flutterflow/validate-yaml.sh <file-key> <yaml-file-path>

# Example
./scripts/flutterflow/validate-yaml.sh app-details flutterflow-yamls/app-details.yaml
```

**Always validate before updating!**

---

### 4. Update FlutterFlow Project

**Script**: `scripts/flutterflow/update-yaml.sh`

```bash
./scripts/flutterflow/update-yaml.sh <file-key> <yaml-file-path>

# Example
./scripts/flutterflow/update-yaml.sh app-details flutterflow-yamls/app-details.yaml
```

**Safety Features:**
- Auto-validation before update
- Interactive confirmation prompt (skip with `--no-confirm`)
- Detailed error reporting

**New in 2025-11-06:** Added `--no-confirm` flag for automation

---

### 5. Parallel Validation

**Script**: `scripts/parallel-validate.sh`

**Purpose**: Validate multiple YAML files in parallel for faster batch operations

```bash
# Validate 10 files in parallel (default concurrency: 5)
scripts/parallel-validate.sh app-state api app-details theme ...

# Custom concurrency
CONCURRENCY=3 scripts/parallel-validate.sh app-state api ...
```

**Performance:** ~5x faster than serial validation (10 files: 10s vs 50s)

---

### 6. Parallel Upload

**Script**: `scripts/parallel-upload.sh`

**Purpose**: Upload multiple files in parallel with automatic retry and verification

```bash
# Upload 10 files in parallel (default concurrency: 3)
scripts/parallel-upload.sh app-state api app-details ...

# Custom settings
CONCURRENCY=2 MAX_RETRIES=5 scripts/parallel-upload.sh app-state api ...
```

**Features:**
- Jittered exponential backoff (1s, 2s, 4s, 8s, 16s, 32s max)
- Automatic redownload and diff verification
- Dynamic concurrency reduction on rate limiting
- Exits non-zero if any verification fails

**Performance:** ~3x faster than serial upload (10 files: 27s vs 80s)

---

### 7. Bulk Upload (JSON Method)

**Script**: `scripts/bulk-update.sh`

**Purpose**: Upload multiple files in a single API call (fast method)

```bash
# Upload files in batches of 10
scripts/bulk-update.sh app-state api app-details ... (up to 100+ files)

# Custom batch size
BATCH_SIZE=20 scripts/bulk-update.sh file1 file2 ... file50
```

**Features:**
- Single API call per batch (default: 10 files)
- Automatic retry with jittered backoff
- Mandatory verification (redownload + diff)
- Exits non-zero if ANY diff is non-empty
- Proven stable up to 10 files per batch (likely supports 50+)

**Performance:** ~10-20x faster than serial (10 files: 1-2s upload + 3s verify vs 80s serial)

**API Format:**
```json
{
  "projectId": "your-project-id",
  "fileKeyToContent": {
    "app-state": "yaml content...",
    "api": "yaml content...",
    "app-details": "yaml content..."
  }
}
```

**Discovery**: Confirmed 2025-11-06 that FlutterFlow API `/v2/updateProjectByYaml` accepts `fileKeyToContent` with multiple files.

---

### 8. Bulk Upload (ZIP Method) - RECOMMENDED

**Script**: `scripts/bulk-update-zip.sh`

**Purpose**: Upload multiple files using ZIP compression (26-53% more efficient than JSON bulk upload)

```bash
# Upload files in batches of 24 (default)
scripts/bulk-update-zip.sh app-state api app-details ... (3+ files)

# Custom batch size
BATCH_SIZE=50 scripts/bulk-update-zip.sh file1 file2 ... file100
```

**Features:**
- **ZIP compression** reduces payload by 26-53% vs JSON
- **Less prone to rate limiting** (smaller payloads = faster transfer)
- Proven stable with 2, 10, 24-file batches
- Sequential verification to avoid download rate limits
- Automatic retry with jittered backoff
- Exits non-zero if ANY verification fails

**Performance vs JSON Bulk:**
- 10 files: 5.1 KB (ZIP) vs 6.9 KB (JSON) - **26% smaller**
- 24 files: 12.6 KB (ZIP) vs 27.0 KB (JSON) - **53% smaller**
- JSON hit rate limit (HTTP 429) at 24 files, ZIP succeeded

**API Format:**
```json
{
  "projectId": "your-project-id",
  "projectYamlBytes": "<base64-encoded-zip-file>"
}
```

**When to use ZIP:**
- ✅ Batches >10 files (significant compression advantage)
- ✅ Network-constrained environments
- ✅ Avoiding rate limits
- ⚠️ Not yet tested beyond 24 files (ceiling TBD)

**When to use JSON:**
- ✅ Small batches (2-10 files, minimal difference)
- ✅ Easier debugging (explicit file mapping)

---

## Performance Comparison

**Benchmarks**: 2025-11-06 testing
**Evidence**: See [`FLUTTERFLOW_API_OPTIMIZATION_SUMMARY.md`](../../FLUTTERFLOW_API_OPTIMIZATION_SUMMARY.md)

| Operation | Serial | Parallel | Bulk JSON | Bulk ZIP | Best Method |
|-----------|--------|----------|-----------|----------|-------------|
| Validate 10 files | ~50s | ~10s (5 workers) | N/A | N/A | Parallel |
| Upload 10 files | ~80s | ~27s (3 workers) | ~4s (6.9 KB) | ~3s (5.1 KB) | **ZIP** (26% smaller) |
| Upload 24 files | ~3min | ~1min | ❌ Rate Limited | ~5s (12.6 KB) | **ZIP only** |
| Upload 50 files | ~6.5min | ~2.2min | ~20s (est.) | ~10s (est.) | **ZIP** (53% smaller) |
| Upload 100 files | ~13min | ~4.5min | ~40s (est.) | ~20s (est.) | **ZIP** (53% smaller) |

### Recommendations

- **First choice:** `bulk-update-zip.sh` for all batches >10 files (most efficient, less rate limiting)
- **Second choice:** `bulk-update.sh` (JSON) for batches 3-10 files (easier debugging)
- **Fallback:** `parallel-upload.sh` for troubleshooting or edge cases

---

## Typical Workflows

### Workflow 1: Single File Edit

**Scenario**: Update app state variables

```bash
# 1. Ensure on correct branch
git checkout <your-branch>

# 2. Download YAML file
./scripts/flutterflow/download-yaml.sh --file app-state

# 3. Edit file
nano flutterflow-yamls/app-state.yaml
# Make your changes

# 4. Validate changes
./scripts/flutterflow/validate-yaml.sh app-state flutterflow-yamls/app-state.yaml

# 5. Apply to FlutterFlow
./scripts/flutterflow/update-yaml.sh app-state flutterflow-yamls/app-state.yaml

# 6. Verify in FlutterFlow UI
# Open https://app.flutterflow.io and check changes

# 7. Commit to git
git add flutterflow-yamls/app-state.yaml
git commit -m "Update app state variables"
git push origin <your-branch>
```

---

### Workflow 2: Batch Edit Multiple Files

**Scenario**: Update multiple pages/components

```bash
# 1. Download all files (bulk)
./scripts/flutterflow/download-yaml.sh

# 2. Edit files as needed
nano flutterflow-yamls/app-state.yaml
nano flutterflow-yamls/app-details.yaml
nano flutterflow-yamls/theme.yaml
# ... make changes ...

# 3. Validate all edited files
scripts/parallel-validate.sh app-state app-details theme

# 4. Upload all changes (ZIP method recommended)
scripts/bulk-update-zip.sh app-state app-details theme

# 5. Verify in FlutterFlow UI

# 6. Commit to git
git add flutterflow-yamls/
git commit -m "Update app configuration and theme"
git push origin <your-branch>
```

---

### Workflow 3: Add Metric Tracking Feature

**Scenario**: Add new metric tracking across multiple files

```bash
# 1. Ensure on correct branch
git checkout JUAN-adding-metric

# 2. Download relevant YAML files
./scripts/flutterflow/download-yaml.sh --file app-state
./scripts/flutterflow/download-yaml.sh --file app-details

# 3. Edit files
nano flutterflow-yamls/app-state.yaml
# Add metric tracking state variables

# 4. Validate changes
./scripts/flutterflow/validate-yaml.sh app-state flutterflow-yamls/app-state.yaml

# 5. Apply to FlutterFlow
./scripts/flutterflow/update-yaml.sh app-state flutterflow-yamls/app-state.yaml

# 6. Verify in FlutterFlow UI
# Open https://app.flutterflow.io and check changes

# 7. Commit to git
git add flutterflow-yamls/app-state.yaml
git commit -m "Add metric tracking state variables"
git push origin JUAN-adding-metric
```

---

## YAML File Categories

The 591 YAML files are organized into these categories:

### Root Configuration
- `app-details` - App name, description, icon, splash screen
- `app-state` - Global state variables
- `theme` - Colors, typography, spacing
- `authentication` - Auth settings and providers
- `platforms` - Platform-specific configs (iOS, Android, Web)

### Collections (Database)
- `collections/id-*` - Firestore collection schemas
- Example: `collections/id-users`, `collections/id-recipes`

### Pages (Screens)
- `page/id-*` - App screens and their configurations
- Example: `page/id-HomePage`, `page/id-LoginPage`

### Components (Reusable Widgets)
- `component/id-*` - Custom reusable components
- Example: `component/id-RecipeCard`, `component/id-NavBar`

### Widget Trees (UI Structure)
- `*/component-widget-tree-outline/node/*` - Detailed UI hierarchy
- Contains all widgets, layouts, and styling

### Actions (User Interactions)
- `*/trigger_actions/*/action/*` - Button clicks, navigation, etc.
- Widget-level triggers only (page triggers not exposed)

### Custom Code
- `custom-code/actions/*` - Custom Dart functions
- `custom-code/widgets/*` - Custom Dart widgets

### Platform-Specific
- `ad-mob` - AdMob configuration
- `push-notifications` - FCM setup
- `theme/color-scheme` - Theme variants

---

## Troubleshooting

### Problem: "Validation failed"

**Solutions:**
1. Check YAML syntax: `yamllint file.yaml`
2. Compare with original: `diff original.yaml modified.yaml`
3. Look for missing required fields
4. Try skipping validation if YAML looks correct: `--skip-validation`

---

### Problem: Changes don't persist

**Symptoms**: Upload returns success, but changes don't appear in FlutterFlow UI

**Solutions:**
1. Re-download file to verify: `./scripts/flutterflow/download-yaml.sh --file app-state`
2. Compare downloaded vs. local: `diff file.yaml flutterflow-yamls/file.yaml`
3. Check upload format (should be plain YAML, not ZIP)
4. Try uploading again

---

### Problem: Rate limiting

**Symptoms**: Requests start failing after many rapid calls

**Solutions:**
1. Use ZIP method instead of JSON for bulk uploads
2. Add delays between requests: `sleep 2`
3. Use retry logic with exponential backoff (built into scripts)
4. Reduce batch size

---

### Problem: Script fails with "jq: command not found"

**Solution:**
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install jq -y

# macOS
brew install jq

# Verify
jq --version
```

---

## Additional Resources

- **API Reference**: [`scripts/FLUTTERFLOW_API_GUIDE.md`](../../scripts/FLUTTERFLOW_API_GUIDE.md)
- **Performance Benchmarks**: [`FLUTTERFLOW_API_OPTIMIZATION_SUMMARY.md`](../../FLUTTERFLOW_API_OPTIMIZATION_SUMMARY.md)
- **Script Index**: [`scripts/README.md`](../../scripts/README.md)
- **Main Context**: [`CLAUDE.md`](../../CLAUDE.md)

---

**Last Updated**: November 17, 2025
**Maintainer**: GlobalFlavors Team
**Questions?**: See [`CONTRIBUTING.md`](../../CONTRIBUTING.md)
