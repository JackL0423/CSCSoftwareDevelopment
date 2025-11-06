# Push Custom Actions to FlutterFlow - Quick Start Guide

**Last Updated**: 2025-11-05
**Status**: Ready to push 3 custom actions

---

## Current Status

✅ **Completed:**
- FlutterFlow VS Code Extension installed
- VS Code configured with Project ID and API token
- FlutterFlow project downloaded to: `c_s_c305_capstone/`
- 3 custom action files copied to: `c_s_c305_capstone/lib/custom_code/actions/`

🔄 **Next Step:**
- Push custom actions to FlutterFlow cloud using VS Code Extension

---

## Custom Actions Ready to Push

| File | Size | Purpose |
|------|------|---------|
| `initialize_user_session.dart` | 3,501 bytes | Session tracking initialization |
| `check_and_log_recipe_completion.dart` | 6,698 bytes | Recipe completion tracking |
| `check_scroll_completion.dart` | 2,240 bytes | Scroll-based completion detection |

---

## Step-by-Step Instructions

### Option A: Using VS Code Command Palette (Recommended)

1. **Ensure VS Code is open** with the FlutterFlow project
   - Path: `c_s_c305_capstone/`
   - Should see `lib/custom_code/actions/` in explorer

2. **Open Command Palette**
   - Press: `Ctrl+Shift+P` (Linux/Windows) or `Cmd+Shift+P` (Mac)

3. **Search for FlutterFlow commands**
   - Type: `FlutterFlow`
   - Look for: `FlutterFlow: Push Custom Code` or `FlutterFlow: Sync`

4. **Execute Push Command**
   - Select the push/sync command
   - Extension will upload all custom actions to FlutterFlow cloud
   - Watch for success notification

5. **Verify in FlutterFlow UI**
   - Open: https://app.flutterflow.io/project/[FLUTTERFLOW_PROJECT_ID]
   - Navigate to: **Custom Code → Actions** (left sidebar)
   - Confirm 3 actions appear with 0 compile errors:
     - `initializeUserSession`
     - `checkAndLogRecipeCompletion`
     - `checkScrollCompletion`

### Option B: Using VS Code FlutterFlow Panel

1. **Open FlutterFlow Panel**
   - Look for FlutterFlow icon in left sidebar (Activity Bar)
   - Click to open FlutterFlow panel

2. **Find Custom Actions Section**
   - Panel should show custom code status
   - Look for "Push" or "Upload" button

3. **Click Push/Upload**
   - Select custom actions
   - Confirm upload

4. **Verify Success**
   - Check for success message in VS Code
   - Verify in FlutterFlow UI (see Option A, step 5)

### Option C: Manual File Save (Alternative)

If the extension supports auto-sync on save:

1. **Open any custom action file**
   - Example: `lib/custom_code/actions/initialize_user_session.dart`

2. **Make trivial change and save**
   - Add a comment, then remove it
   - Press `Ctrl+S` to save

3. **Extension may auto-push**
   - Check for sync notification
   - Verify in FlutterFlow UI

---

## Troubleshooting

### Error: "Not authenticated" or "Invalid token"

**Solution:**
```bash
# Verify token in VS Code settings
cat ~/.config/Code/User/settings.json | grep flutterflow.userApiToken

# Should see: "flutterflow.userApiToken": "9dc3d62e-6d19-4831-9386-02760f9fb7c0"
```

If missing, restart VS Code to pick up the updated settings.

### Error: "No custom actions found"

**Verify files exist:**
```bash
ls -lah c_s_c305_capstone/lib/custom_code/actions/
```

Should show 4 files:
- `check_and_log_recipe_completion.dart`
- `check_scroll_completion.dart`
- `initialize_user_session.dart`
- `index.dart`

### Error: "Project not found"

**Verify project ID:**
```bash
cat ~/.config/Code/User/settings.json | grep flutterflow.projectId
```

Should see: `"flutterflow.projectId": "[FLUTTERFLOW_PROJECT_ID]"`

### Extension not responding

1. **Restart VS Code**
   - Close all VS Code windows
   - Reopen: `/snap/bin/code c_s_c305_capstone/`

2. **Check extension is enabled**
   - Press `Ctrl+Shift+X` to open Extensions
   - Search: `FlutterFlow`
   - Ensure `FlutterFlow: Custom Code Editor` is enabled

3. **Check extension logs**
   - Open Output panel: `Ctrl+Shift+U`
   - Select: `FlutterFlow` from dropdown
   - Look for error messages

---

## Verification Checklist

After pushing, verify the following:

- [ ] **VS Code showed success notification**
- [ ] **FlutterFlow UI shows 3 custom actions**
  - Open: https://app.flutterflow.io/project/[FLUTTERFLOW_PROJECT_ID]
  - Navigate: Custom Code → Actions
- [ ] **Each action shows 0 compile errors**
- [ ] **Action signatures match:**
  - `initializeUserSession(BuildContext context)` → `Future<void>`
  - `checkAndLogRecipeCompletion(...)` → `Future<bool>`
  - `checkScrollCompletion(...)` → `Future<bool>`

---

## Next Steps After Push Success

Once custom actions are verified in FlutterFlow UI:

1. **Deploy Firebase Backend**
   ```bash
   ./scripts/deploy.sh firebase
   ```

2. **Wire Actions to UI Pages** (in FlutterFlow UI)
   - HomePage: Add `initializeUserSession` to OnPageLoad
   - Login page: Add `initializeUserSession` after auth success
   - GoldenPath: Add `initializeUserSession` to OnPageLoad
   - RecipeViewPage: Add recipe tracking and completion button

3. **Test End-to-End**
   - Test session initialization
   - Test recipe completion
   - Verify Firestore writes

---

## Alternative: Using FlutterFlow API (If Extension Fails)

If the VS Code Extension doesn't work, custom actions can be created directly in FlutterFlow UI:

1. Open FlutterFlow UI
2. Navigate to: Custom Code → Actions
3. Click: "Add Custom Action"
4. Copy/paste Dart code from:
   - `vscode-extension-ready/lib/custom_code/actions/initialize_user_session.dart`
   - `vscode-extension-ready/lib/custom_code/actions/check_and_log_recipe_completion.dart`
   - `vscode-extension-ready/lib/custom_code/actions/check_scroll_completion.dart`

**Note**: This is manual and time-consuming. Extension method is preferred.

---

## Support

**Issues?**
- Check VS Code Output panel for FlutterFlow extension logs
- Verify API token is correct in settings
- Ensure project ID matches: `[FLUTTERFLOW_PROJECT_ID]`
- Restart VS Code if extension not responding

**Contact:**
- [REDACTED]@example.edu

---

**Generated**: 2025-11-05
**Branch**: JUAN-adding-metric
