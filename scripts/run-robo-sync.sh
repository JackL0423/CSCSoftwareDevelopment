#!/usr/bin/env bash
# Script Name: run-robo-sync.sh
# Purpose: Submit a synchronous Firebase Test Lab Android Robo test and summarize results
# Usage: ./scripts/run-robo-sync.sh <path_to_apk> gs://<bucket>/<results_dir>
# Author: Juan Vallejo
# Date: 2025-11-05
# Project: CSC305 GlobalFlavors D7 Retention Metrics
set -euo pipefail
trap 'echo "Error on line $LINENO" >&2' ERR

# Run a Firebase Test Lab Android Robo test synchronously and print outcome.
# Usage: ./scripts/run-robo-sync.sh c_s_c305_capstone/build/app/outputs/flutter-apk/app-debug.apk gs://test-lab-<bucket-id>/csc305capstone-latest

APP_APK=${1:-}
RESULTS_GCS=${2:-}

if [[ -z "$APP_APK" || -z "$RESULTS_GCS" ]]; then
  echo "Usage: $0 <path_to_apk> gs://<bucket>/<results_dir>" >&2
  exit 2
fi

if ! command -v gcloud >/dev/null; then
  echo "gcloud is required" >&2
  exit 2
fi

echo "Submitting Robo test synchronously..."

# Parse GCS into bucket and dir: gs://bucket/dir[/optional/...]
if [[ "$RESULTS_GCS" != gs://*/* ]]; then
  echo "Invalid results GCS path: $RESULTS_GCS" >&2
  exit 2
fi
GCS_PATH_NO_SCHEME=${RESULTS_GCS#gs://}
BUCKET=${GCS_PATH_NO_SCHEME%%/*}
DIR=${GCS_PATH_NO_SCHEME#*/}

gcloud firebase test android run \
  --type=robo \
  --app="$APP_APK" \
  --device=model=MediumPhone.arm,version=33,locale=en,orientation=portrait \
  --results-bucket="$BUCKET" \
  --results-dir="$DIR" \
  --format=json

echo "Robo test completed. Summarizing results from: $RESULTS_GCS"
"$(dirname "$0")"/collect-testlab-results.sh "$RESULTS_GCS" || true
