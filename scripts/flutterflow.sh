#!/usr/bin/env bash
# FlutterFlow API wrapper for download/validate/upload operations
set -euo pipefail

: "${API_BASE:=https://api.flutterflow.io/v2}"
: "${PROJECT_ID:=c-s-c305-capstone-khj14l}"
: "${LEAD_TOKEN:?Set LEAD_TOKEN env var or use: gcloud secrets versions access latest --secret=FLUTTERFLOW_LEAD_API_TOKEN}"

cmd="${1:-}"
file="${2:-}"

case "$cmd" in
  download)
    [ -n "$file" ] || { echo "Error: Missing file key"; echo "Usage: $0 download <file-key>"; exit 2; }
    exec ./scripts/download-yaml.sh --file "$file"
    ;;
  validate)
    [ -n "$file" ] || { echo "Error: Missing file key"; echo "Usage: $0 validate <file-key> <yaml-path>"; exit 2; }
    yaml_path="${3:-flutterflow-yamls/${file}.yaml}"
    exec ./scripts/validate-yaml.sh "$file" "$yaml_path"
    ;;
  upload)
    [ -n "$file" ] || { echo "Error: Missing file key"; echo "Usage: $0 upload <file-key> <yaml-path>"; exit 2; }
    yaml_path="${3:-flutterflow-yamls/${file}.yaml}"
    exec ./scripts/update-yaml.sh "$file" "$yaml_path"
    ;;
  list)
    exec ./scripts/list-yaml-files.sh
    ;;
  *)
    cat <<USAGE
Usage: $0 {download|validate|upload|list} <file-key> [yaml-path]

FlutterFlow API operations wrapper. Requires LEAD_TOKEN environment variable.

Commands:
  download <file-key>              Download YAML file from FlutterFlow
  validate <file-key> [yaml-path]  Validate YAML before upload
  upload <file-key> [yaml-path]    Upload YAML to FlutterFlow
  list                             List all available YAML files

Examples:
  export LEAD_TOKEN=\$(gcloud secrets versions access latest --secret=FLUTTERFLOW_LEAD_API_TOKEN)
  $0 list
  $0 download app-state
  $0 validate app-state flutterflow-yamls/app-state.yaml
  $0 upload app-state flutterflow-yamls/app-state.yaml

See: CLAUDE.md for complete FlutterFlow API documentation
USAGE
    exit 2
    ;;
esac
