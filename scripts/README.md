# Production Scripts

Last Updated: 2025-11-17

## Overview

This directory contains production automation scripts for the GlobalFlavors project.

## Directory Structure

### scripts/flutterflow/
Core FlutterFlow YAML operations:
- download-yaml.sh - Download individual or all YAML files
- download-all-yamls-bulk.sh - Bulk download all YAML files (2-10 seconds)
- upload-yaml.sh - Upload YAML changes to FlutterFlow
- validate-yaml.sh - Validate YAML before uploading
- list-yaml-files.sh - List all YAML files in project
- setup-vscode-deployment.sh - Setup VS Code extension for FlutterFlow
- push-custom-actions-api.sh - Push custom Dart actions via API
- bulk-update-zip.sh - Bulk upload multiple YAML files

### scripts/firebase/
Firebase deployment and configuration:
- deploy-firebase-with-serviceaccount.sh - Deploy Firebase functions with service account
- deploy-d7-retention-complete.sh - Deploy D7 retention metrics system

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

### scripts/utilities/
Shared utility functions:
- load-secrets.sh - Load secrets from GCP Secret Manager (300ms parallel loading)
- common-functions.sh - Common bash functions used across scripts
- redact-har.sh - Redact sensitive data from HAR files
- analyze-har.sh - Analyze HAR files for performance

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
