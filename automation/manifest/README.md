# Trigger Wiring Manifest

This folder contains a manifest format and sample to apply multiple trigger wiring updates via FlutterFlow's Project YAML API.

- `triggers.sample.json`: Example manifest entries for On Page Load wiring of `initializeUserSession` on GoldenPath and Login pages.

## Manifest Schema

Each entry is a JSON object:

- page_name: Friendly label for logs only.
- file_key: Exact partitioned YAML file key in FlutterFlow (as listed by the `listPartitionedFileNames` API).
- template: Path to a template YAML file (e.g., `automation/templates/on_page_load_template.yaml`).
- action_name: Custom Action display name (default: initializeUserSession).
- action_key: Custom Action internal key (default: vpyil).
- params: JSON object with parameters injected into the template (default: {}).
- non_blocking: Optional boolean to skip failures (default: false).

## Apply all manifest entries

Use the bulk executor to render templates and push updates through the ZIP API path:

- `./scripts/apply-all-triggers.sh automation/manifest/triggers.sample.json`

Requirements:
- `jq`
- Existing `scripts/apply-trigger-via-api.sh` configured with auth environment variables.

## Snapshot YAMLs for auditing

Download YAML bytes for all `file_key`s in a manifest to a timestamped folder:

- `./scripts/snapshot-from-manifest.sh automation/manifest/triggers.sample.json`

Notes:
- For some keys the `projectYamls` API may return empty bytes immediately after wiring; re-run later or rely on UI verification.
