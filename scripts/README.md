# Production Scripts

Last Updated: 2025-11-17

## Overview

This directory contains production automation scripts for the GlobalFlavors project.

## Directory Structure

### scripts/flutterflow/
Core FlutterFlow YAML operations:
- download-yaml.sh - Download individual or all YAML files
- download-all-yamls-bulk.sh - Bulk download all YAML files (2-10 seconds)
- update-yaml.sh - Upload YAML changes to FlutterFlow
- update-yaml-v2.sh - Alternative upload method (experimental)
- validate-yaml.sh - Validate YAML before uploading
- list-yaml-files.sh - List all YAML files in project
- setup-vscode-deployment.sh - Setup VS Code extension for FlutterFlow
- push-custom-actions-api.sh - Push custom Dart actions via API
- push-essential-actions-only.sh - Push only essential custom actions
- bulk-update-zip.sh - Bulk upload multiple YAML files (recommended for batch operations)
- zip-update-yaml.sh - Alternative ZIP upload method

FlutterFlow automation and utilities:
- apply-all-triggers.sh - Apply multiple triggers from manifest
- apply-trigger-via-api.sh - Apply single trigger via FlutterFlow API
- update-trigger-correct.sh - Update and correct trigger configurations
- find-action-keys.sh - Find action keys in YAML files
- fetch-profile-onpageload.sh - Fetch profile page OnPageLoad configuration
- flutterflow.sh - Main FlutterFlow CLI wrapper
- launch-vscode-flutterflow.sh - Launch VS Code with FlutterFlow extension

Debug and development:
- debug-get-file.sh - Debug tool for downloading and inspecting files

### scripts/firebase/
Firebase deployment and configuration:
- deploy-firebase-with-serviceaccount.sh - Deploy Firebase functions with service account (recommended)
- deploy-d7-retention-complete.sh - Deploy D7 retention metrics system
- deploy-firebase-complete.sh - Complete Firebase deployment (all functions)
- deploy.sh - Basic Firebase deployment
- setup-firebase-permissions.sh - Configure Firebase IAM permissions

### scripts/testing/
Test and verification scripts:
- test-retention-function.sh - Test D7 retention Firebase function
- verify-metrics-flow.sh - Verify complete metrics flow
- verify-yaml-update.sh - Verify YAML updates persisted
- create-test-users.sh - Create test users in Firestore
- seed-test-data.sh - Seed test data for development
- simulate-analytics-events.sh - Simulate analytics events
- tail-analytics.sh - Monitor analytics events
- enable-analytics-debug.sh - Enable debug mode for analytics
- run-apk-local.sh - Run APK locally for testing
- collect-testlab-results.sh - Collect Firebase Test Lab results
- run-robo-sync.sh - Run Robo tests synchronously

### scripts/utilities/
Shared utility functions:
- load-secrets.sh - Load secrets from GCP Secret Manager (300ms parallel loading)
- common-functions.sh - Common bash functions used across scripts
- redact-har.sh - Redact sensitive data from HAR files
- analyze-har.sh - Analyze HAR files for performance
- setup-flutter-sdk.sh - Setup and configure Flutter SDK

## Archived Scripts

Experimental scripts moved to:
`../archive/2025-11-17-personal-dev/experimental-scripts/`

Includes:
- parallel-upload.sh, parallel-validate.sh - Parallel processing experiments
- ceiling-discovery.sh - Performance testing
- learn-pattern.py, wire-action.py - Automation research
- sync-incremental.sh - Optimization experiment
- optimize-claude-md.sh - Personal documentation tool

## Usage

Most scripts require environment variables from GCP Secret Manager:
```bash
source scripts/utilities/load-secrets.sh
```

See individual script headers for detailed usage and requirements.

## Maintenance

When adding new scripts:
1. Place in appropriate subdirectory
2. Add usage header comments
3. Update this README
4. Test with clean environment

## Additional Resources

### FlutterFlow API Guide
See [FLUTTERFLOW_API_GUIDE.md](../docs/guides/FLUTTERFLOW_API_GUIDE.md) for comprehensive FlutterFlow API documentation including:
- API endpoints and authentication
- YAML workflow best practices
- Format requirements (ZIP vs plain YAML)
- Silent failure troubleshooting
- Performance optimization techniques

### Script Usage Notes
For duplicate script clarification:
- **update-yaml.sh** (recommended) - Production upload script with validation
- **update-yaml-v2.sh** - Experimental alternative (use update-yaml.sh instead)
- **bulk-update-zip.sh** (recommended) - Batch upload using ZIP compression
- **zip-update-yaml.sh** - Alternative ZIP upload (use bulk-update-zip.sh instead)
- **deploy-firebase-with-serviceaccount.sh** (recommended) - Deploy with service account auth
- **deploy-firebase-complete.sh** - Alternative complete deployment
- **deploy.sh** - Basic deployment (use deploy-firebase-with-serviceaccount.sh instead)
