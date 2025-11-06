#!/usr/bin/env bash
# Master deployment wrapper for D7 Retention System
set -euo pipefail

usage() {
  cat <<USAGE
Usage: $0 [vscode|firebase|full]

  vscode   Configure and push Custom Actions via VS Code extension workflow
  firebase Deploy Firebase backend only (functions, indexes, config)
  full     End-to-end guided deployment (frontend + backend)

Examples:
  $0 vscode    # Interactive VS Code extension setup
  $0 firebase  # Deploy Cloud Functions and Firestore indexes
  $0 full      # Complete deployment with all steps
USAGE
}

case "${1:-}" in
  vscode)
    exec ./scripts/setup-vscode-deployment.sh
    ;;
  firebase)
    exec ./scripts/deploy-d7-retention-complete.sh --firebase-only
    ;;
  full)
    exec ./scripts/deploy-d7-retention-complete.sh
    ;;
  *)
    usage
    exit 2
    ;;
esac
