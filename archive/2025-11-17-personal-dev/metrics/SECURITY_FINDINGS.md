# Security Scan Findings - Repository Reorganization

**Date**: 2025-11-06
**Scan Tool**: Gitleaks v8.18.2
**Total Findings**: 24 exposed secrets in git history

## Summary

Gitleaks detected API keys and tokens exposed in git commit history. These need review and potential rotation.

## Findings Breakdown

### FlutterFlow API Tokens (22 instances)
Same token repeated across documentation and script files:
- Token: `[REDACTED - See git history or GCP Secret Manager]`
- Files: scripts/*.sh, docs/*.md, archive files

**Files Affected**:
- PUSH_CUSTOM_ACTIONS_GUIDE.md
- PROJECT_STATUS.md
- scripts/README.md
- scripts/add-app-state-variables.sh
- scripts/create-custom-actions-api.sh
- scripts/deploy-d7-retention-complete.sh
- scripts/download-custom-files.sh
- scripts/explore-custom-code-api.sh
- scripts/identify-pages.sh
- scripts/inspect-custom-code.sh
- scripts/list-all-pages.sh
- scripts/test-single-upload.sh
- scripts/upload-app-state.sh
- scripts/upload-custom-actions.sh
- scripts/validate-app-state.sh
- docs/SECRET_SETUP_INSTRUCTIONS.md
- docs/VSCODE_EXTENSION_DEPLOYMENT_GUIDE.md
- docs/archive/2025-11-04-flutterflow-api-work/*.sh

### GCP API Keys (2 instances)
- lib/backend/gemini/gemini.dart (Gemini API key)
- lib/backend/firebase/firebase_config.dart (Firebase API key)
- android/app/google-services.json (Firebase Android config)

## Recommendations

### Immediate Actions
1. ✅ Document findings (this file)
2. ⏭️ Complete repository reorganization
3. ⏭️ After reorganization: Review and rotate FlutterFlow API token if active
4. ⏭️ Verify GCP keys in lib/ files are managed via GCP Secret Manager

### Prevention (Phase 3 of reorganization)
- ✅ Add pre-commit hooks to block future secret commits
- ✅ Update .gitignore patterns for credential files
- ⏭️ Educate team on using GCP Secret Manager

## Context (School Project)

This is a CSC305 school project. Based on CLAUDE.md:
- All production secrets should be in GCP Secret Manager
- The FlutterFlow token appears to be a test/demo token used in documentation
- GCP keys in lib/ files may be FlutterFlow-generated code (standard for mobile apps)
- google-services.json is standard Firebase Android config (public project IDs, not sensitive)

## Next Steps

1. Complete repository reorganization (in progress)
2. After reorganization, audit which tokens are still active
3. Rotate any active production tokens
4. Update documentation to reference GCP Secret Manager instead of hardcoded tokens
5. Add .gitleaksignore for known false positives if needed

## Full Report

See `metrics/gitleaks-after-rewrite.json` for complete technical details.
