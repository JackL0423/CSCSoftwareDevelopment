#!/usr/bin/env bash
# Script Name: collect-testlab-results.sh
# Purpose: Summarize Firebase Test Lab results from a GCS results directory (artifacts, pass/fail)
# Usage: ./scripts/collect-testlab-results.sh gs://<bucket>/<results_dir>
# Author: Juan Vallejo
# Date: 2025-11-05
# Project: CSC305 GlobalFlavors D7 Retention Metrics
set -euo pipefail
trap 'echo "Error on line $LINENO" >&2' ERR

# Summarize Firebase Test Lab results directly from a GCS results directory.
# Usage: ./scripts/collect-testlab-results.sh gs://<bucket>/<results_dir>

RESULTS_DIR=${1:-}
if [[ -z "$RESULTS_DIR" ]]; then
  echo "Usage: $0 gs://<bucket>/<results_dir>" >&2
  exit 2
fi

if ! command -v gsutil >/dev/null; then
  echo "gsutil is required" >&2
  exit 2
fi

echo "Collecting Test Lab results from: $RESULTS_DIR"

# List device subdirectories (end with /)
mapfile -t DEV_DIRS < <(gsutil ls "$RESULTS_DIR/" | grep '/$' || true)

if [[ ${#DEV_DIRS[@]} -eq 0 ]]; then
  echo "No device subdirectories found under $RESULTS_DIR" >&2
  exit 1
fi

overall_status="UNKNOWN"
any_fail=0

for dev in "${DEV_DIRS[@]}"; do
  echo
  echo "== Device Result: $dev =="

  # Try to fetch test_result_1.xml (JUnit format)
  JUNIT_FILE="${dev}test_result_1.xml"
  if gsutil -q stat "$JUNIT_FILE"; then
    tmpfile=$(mktemp)
    gsutil cp "$JUNIT_FILE" "$tmpfile" >/dev/null 2>&1 || true
    # Extract attributes if present
    tests=$(grep -o 'tests="[^"]*"' "$tmpfile" | head -n1 | cut -d'"' -f2 || echo "?")
    failures=$(grep -o 'failures="[^"]*"' "$tmpfile" | head -n1 | cut -d'"' -f2 || echo "0")
    errors=$(grep -o 'errors="[^"]*"' "$tmpfile" | head -n1 | cut -d'"' -f2 || echo "0")
    skipped=$(grep -o 'skipped="[^"]*"' "$tmpfile" | head -n1 | cut -d'"' -f2 || echo "0")
    echo "JUnit: tests=$tests failures=$failures errors=$errors skipped=$skipped"
    rm -f "$tmpfile"
    if [[ "$failures" != "0" || "$errors" != "0" ]]; then
      any_fail=1
    fi
  else
    echo "JUnit: test_result_1.xml not found"
  fi

  # Print links to video and logs if present
  if gsutil -q stat "${dev}video.mp4"; then
    echo "Video: ${dev}video.mp4"
  fi
  if gsutil -q stat "${dev}logcat"; then
    echo "Logcat: ${dev}logcat"
  fi
  if gsutil -q stat "${dev}artifacts/robo_script.json"; then
    echo "Robo script: ${dev}artifacts/robo_script.json"
  fi
done

echo
if [[ $any_fail -eq 1 ]]; then
  overall_status="FAIL"
else
  overall_status="PASS"
fi
echo "Overall: $overall_status"
