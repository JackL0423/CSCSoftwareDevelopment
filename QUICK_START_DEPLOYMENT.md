# D7 Retention - Quick Start Deployment

**Status**: ✅ Ready to Deploy
**Time**: 2.5-3 hours
**Method**: FlutterFlow VS Code Extension (Official)

---

## 🚀 Fast Track (For Immediate Deployment)

### Prerequisites
- VS Code installed
- FlutterFlow account with Growth Plan
- Project: `c-s-c305-capstone-khj14l`

### Option A: Interactive Setup (Recommended)

```bash
cd ~/Documents/School/school/CSC305PROJECT/CSCSoftwareDevelopment
chmod +x scripts/setup-vscode-deployment.sh
./scripts/setup-vscode-deployment.sh
```

This script will guide you through:
1. Extension installation
2. API key generation
3. Project download
4. Custom action deployment
5. Verification

**Total Time**: 45 minutes (guided)

### Option B: Manual Steps

#### Phase 1: Setup (15 min)

1. **Install Extension**
   - VS Code → Extensions → Search "FlutterFlow: Custom Code Editor" → Install

2. **Generate API Key**
   - https://app.flutterflow.io → Account → API → Generate
   - Copy the key

3. **Configure Extension**
   - VS Code → Command Palette (Ctrl/Cmd+Shift+P)
   - Run: `FlutterFlow: Configure`
   - API Key: [paste]
   - Project ID: `c-s-c305-capstone-khj14l`
   - Branch: `main`

4. **Download Project**
   - Command Palette → `FlutterFlow: Download Code`
   - Select workspace folder
   - Wait for download

#### Phase 2: Deploy Custom Actions (30 min)

5. **Copy Action Files**
   ```bash
   # From project root
   cd ~/Documents/School/school/CSC305PROJECT/CSCSoftwareDevelopment

   # Copy to your FlutterFlow workspace
   cp vscode-extension-ready/lib/custom_code/actions/*.dart \
      ~/flutterflow-globalflavors/lib/custom_code/actions/
   ```

6. **Start Editing Session**
   - Open workspace in VS Code
   - Command Palette → `FlutterFlow: Start Code Editing Session`

7. **Push to FlutterFlow**
   - Command Palette → `FlutterFlow: Push to FlutterFlow`
   - Wait ≤2 minutes
   - Watch for success message

8. **Verify**
   - Open: https://app.flutterflow.io/project/c-s-c305-capstone-khj14l
   - Navigate to: Custom Code → Actions
   - Verify: 3 actions, 0 errors

#### Phase 3: Wire Actions (90 min)

9. **Session Initialization**
   - HomePage → OnPageLoad → initializeUserSession
   - login page → After Auth Success → initializeUserSession
   - GoldenPath → OnPageLoad → initializeUserSession

10. **Recipe Tracking**
    - RecipeViewPage → OnPageLoad → Update App State:
      - currentRecipeId
      - currentRecipeName
      - currentRecipeCuisine
      - currentRecipePrepTime
      - recipeStartTime = Now

11. **Completion Button**
    - RecipeViewPage → Add Button "Mark as Complete"
    - OnTap → checkAndLogRecipeCompletion
    - Parameters: Use App State values

#### Phase 4: Firebase Backend (15 min)

12. **Deploy Firebase**
    ```bash
    cd ~/Documents/School/school/CSC305PROJECT/CSCSoftwareDevelopment
    ./scripts/deploy-d7-retention-complete.sh
    ```

#### Phase 5: Test (30 min)

13. **Test in FlutterFlow**
    - Test Mode → Check session initialization
    - Navigate to recipe → Check tracking
    - Click completion button → Check Firestore writes

14. **Verify Firebase**
    ```bash
    firebase functions:list  # Should show 4 functions
    ./scripts/test-retention-function.sh  # Test manually
    ```

---

## 📁 File Locations

**Custom Actions** (Ready for VS Code):
```
vscode-extension-ready/lib/custom_code/actions/
├── initialize_user_session.dart
├── check_and_log_recipe_completion.dart
├── check_scroll_completion.dart
└── index.dart
```

**Scripts**:
```
scripts/
├── setup-vscode-deployment.sh  (Interactive setup)
├── deploy-d7-retention-complete.sh  (Firebase deployment)
└── test-retention-function.sh  (Testing)
```

**Documentation**:
```
docs/
├── VSCODE_EXTENSION_DEPLOYMENT_GUIDE.md  (Complete guide)
└── RETENTION_IMPLEMENTATION_GUIDE.md  (Reference)
```

---

## ✅ Verification Checklist

After deployment, verify:

- [ ] **Custom Actions**: 3 actions visible in FlutterFlow, 0 errors
- [ ] **Session Init**: App State shows sessionId, sessionStartTime
- [ ] **Recipe Tracking**: App State shows current recipe data
- [ ] **Completion**: Button works, shows snackbar
- [ ] **Firestore**: user_recipe_completions has documents
- [ ] **Firebase Functions**: 4 functions deployed
- [ ] **Cloud Function**: Manual test creates retention_metrics doc

---

## 🔧 Troubleshooting

**Extension won't connect?**
- Verify API key is correct
- Check Project ID: `c-s-c305-capstone-khj14l`
- Ensure internet connection

**Push fails?**
- Check all files saved
- Verify index.dart exports all 3 actions
- Try restarting Code Editing Session

**Actions don't appear in FlutterFlow?**
- Refresh FlutterFlow page
- Check Custom Code → Actions for compile errors
- Verify push completed successfully

**Compile errors?**
- Click error to see details
- Common: missing imports, wrong parameter types
- Fix in VS Code, re-push

---

## 📊 Expected Timeline

| Phase | Task | Time |
|-------|------|------|
| 1 | Setup Extension | 15 min |
| 2 | Deploy Actions | 30 min |
| 3 | Wire to Pages | 90 min |
| 4 | Deploy Firebase | 15 min |
| 5 | Testing | 30 min |
| **Total** | **End-to-End** | **2.5-3 hours** |

---

## 🎯 Success Criteria

**Deployment Complete When**:
- ✅ 3 custom actions in FlutterFlow (0 errors)
- ✅ Actions wired to HomePage, login, GoldenPath, RecipeViewPage
- ✅ 4 Firebase functions deployed
- ✅ 2 Firestore indexes created
- ✅ End-to-end test successful

**First D7 Metric**: 7 days after first user completes a recipe

---

## 📚 Additional Resources

**Detailed Guides**:
- Complete deployment: `docs/VSCODE_EXTENSION_DEPLOYMENT_GUIDE.md`
- Alternative methods: `docs/RETENTION_IMPLEMENTATION_GUIDE.md`
- Technical details: `docs/RETENTION_LOGIC_COMPLETION_SUMMARY.md`

**Analysis**:
- GPT-5 findings: `GPT5_ANALYSIS_AND_SOLUTION.md`
- Deployment options: `DEPLOYMENT_STATUS.md`

**Project Overview**:
- Main README: `README_D7_RETENTION.md`

---

## 🆘 Need Help?

**Quick Reference**: `README_D7_RETENTION.md`
**Full Guide**: `docs/VSCODE_EXTENSION_DEPLOYMENT_GUIDE.md`
**Contact**: Juan Vallejo (juan_vallejo@uri.edu)

---

**Ready? Run the setup script:**

```bash
./scripts/setup-vscode-deployment.sh
```

**Let's deploy! 🚀**
