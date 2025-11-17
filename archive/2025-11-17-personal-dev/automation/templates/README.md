# Trigger Templates

This folder contains reusable YAML action templates that can be pushed via FlutterFlow's v2 Project YAML API.

Important notes:
- The API cannot create new file keys. Seed the trigger in FlutterFlow UI once, which creates the file key(s). Then these templates can update content reliably.
- We push action YAML at the action file key path (e.g., `.../trigger_actions/id-ON_INIT_STATE/action/id-<key>`). The trigger index file typically references the action id created by the UI seed.

Templates:
- `on_page_load_template.yaml`
  - Placeholders: `${ACTION_NAME}`, `${CUSTOM_ACTION_KEY}`, `${NON_BLOCKING}`
- `on_auth_success_template.yaml`
  - Same placeholders as above.
- `button_ontap_template.yaml`
  - Placeholders: `${ACTION_NAME}`, `${CUSTOM_ACTION_KEY}`, `${NON_BLOCKING}`, `${PARAMS_JSON}` (JSON object for `argumentValues`).

Usage is handled by `scripts/apply-trigger-via-api.sh` which renders the template and updates the file via the API.
