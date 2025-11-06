#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <Scaffold_ID>" >&2
  echo "Example: $0 Scaffold_cc3wywo1" >&2
  exit 2
fi
SID="$1"
./scripts/list-yaml-files.sh >/tmp/ff_list_full.txt
grep -F "page/id-${SID}/page-widget-tree-outline/node/id-${SID}/trigger_actions/id-ON_INIT_STATE/action/id-" /tmp/ff_list_full.txt || true
