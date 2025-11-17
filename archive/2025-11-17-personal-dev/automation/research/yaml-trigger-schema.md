# FlutterFlow Project YAML: Trigger Actions Schema

This document captures the practical schema and constraints we observed while wiring Custom Actions to page triggers via the official v2 API.

## File locations (partitioned keys)

- Per-page On Page Load (Init State):
  - `page/id-Scaffold_<PAGE_ID>/page-widget-tree-outline/node/id-Scaffold_<PAGE_ID>/trigger_actions/id-ON_INIT_STATE/action/id-<ACTION_FILE_KEY>`
  - Trigger index file at: `.../trigger_actions/id-ON_INIT_STATE.yaml`
- Other triggers (examples):
  - On Auth Success: `trigger_actions/id-ON_AUTH_SUCCESS/action/id-<ACTION_FILE_KEY>`
  - Button tap: within the widget subtree, e.g. `page/.../node/id-Button_<WIDGET_ID>/trigger_actions/id-ON_TAP/action/id-<ACTION_FILE_KEY>`

Notes:
- The file keys are opaque and must be seeded by the UI at least once (creating the partitioned path) before API updates are accepted.
- Listing via `listPartitionedFileNames` shows keys from the Main branch. Updates may target a branch, but reads still reflect Main.

## Action YAML template fields

Minimal viable structure for a Custom Action call on a trigger action file:

- `type`: Must be `CALL_CUSTOM_ACTION`.
- `action_key`: Internal key for the Custom Action (e.g., `vpyil`).
- `action_name`: Display name (e.g., `initializeUserSession`).
- `inputs`: Object containing parameters; shape must match the Custom Action signature.
- `is_blocking`: Whether the action blocks subsequent actions on the trigger.

Example fields used in templates:
- On Page Load: `automation/templates/on_page_load_template.yaml`
- On Auth Success: `automation/templates/on_auth_success_template.yaml`
- Button OnTap: `automation/templates/button_ontap_template.yaml`

## API endpoints and behavior

- listPartitionedFileNames: Enumerates available file keys (Main branch visibility).
- projectYamls: Fetches zip of YAML files by file key; observed that newly updated keys may return empty bytes for some time.
- validateProjectYaml: Intermittently unstable; skip for routine flows and rely on update success + UI verification.
- updateProjectByYaml: Accepts JSON or ZIP; ZIP path is more reliable and supports specifying a `branchName`.

## Constraints and gotchas

- Seed requirement: UI must create the file key once for a widget/trigger before updates take effect.
- Read-after-write: Newly pushed files can be invisible to `projectYamls` on Main until merged or after a delay.
- Rate limiting: Add retries and backoff for update calls.
- Action schema: Ensure parameter names and types match the Custom Action; mismatches are silently dropped in UI.

## Checklist for adding a new trigger wiring

1. Seed the file key in the UI by adding a placeholder action and saving.
2. Capture the `file_key` via API listing or through the UI’s structure.
3. Choose a template and render with `action_key`, `action_name`, and params.
4. Push via the ZIP API path with retries.
5. Verify in the UI and/or run-time logs.
6. Optionally snapshot YAML with `scripts/snapshot-from-manifest.sh` for audit.
