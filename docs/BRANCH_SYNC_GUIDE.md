# Branch Synchronization Guide

**Project:** GlobalFlavors
**Date:** 2025-10-20
**Current Branch:** JUAN-SIDE-BRANCH

---

## Overview

This guide explains how to maintain synchronization between your Git branches and FlutterFlow branches, given that FlutterFlow does not expose branch management via its API.

---

## The Challenge

### Git (Local Repository)
- ✅ Full API access via `git` commands
- ✅ Branches created programmatically
- ✅ Easy to script and automate
- ✅ Current branch: `JUAN-SIDE-BRANCH`

### FlutterFlow (Web Platform)
- ❌ **NO API for branch operations**
- ❌ Must use UI to create/switch branches
- ⚠️ Branches are FlutterFlow-internal only
- ⚠️ Does NOT sync with GitHub automatically

**Key Finding:** "Creating a branch here doesn't create one on GitHub. Branches stay and are managed solely within FlutterFlow."
— Source: [FlutterFlow Branching Documentation](https://docs.flutterflow.io/collaboration/branching/)

---

## Current State

### Git Repository
```bash
$ git branch
* JUAN-SIDE-BRANCH
  main
```

### FlutterFlow Project
- **Project ID:** `c-s-c305-capstone-khj14l`
- **Project Name:** CSC305Capstone
- **Current Branch:** Unknown (must check in FlutterFlow UI)
- **Branch Creation:** Manual only via FlutterFlow toolbar

---

## Synchronization Strategy

Since FlutterFlow branches cannot be managed via API, we need a **manual synchronization workflow**.

### ✅ Recommended Workflow

#### 1. Create Branch in Git (Already Done)
```bash
git checkout -b JUAN-SIDE-BRANCH
git push -u origin JUAN-SIDE-BRANCH
```

Status: ✅ **COMPLETE** (branch exists locally)

---

#### 2. Create Matching Branch in FlutterFlow (MANUAL)

**Steps:**
1. Open FlutterFlow: https://app.flutterflow.io/project/c-s-c305-capstone-khj14l
2. Click **"Branching Options"** button in toolbar (top-right)
3. Click **"+ Create New Branch"**
4. Enter branch name: `JUAN-SIDE-BRANCH`
5. Add description: "Juan's development branch for authentication flow"
6. Select base branch: `main`
7. Click **"Create Branch"**

**Result:** FlutterFlow creates internal branch isolated from `main`

---

#### 3. Work in Synchronized Branches

| Tool | Branch Name | Purpose |
|------|-------------|---------|
| **Git** | `JUAN-SIDE-BRANCH` | Code, scripts, documentation |
| **FlutterFlow** | `JUAN-SIDE-BRANCH` | UI design, page layouts, widgets |
| **Figma** | `JUAN-SIDE-BRANCH` (optional) | Design mockups, assets |

**Rule:** Always ensure you're working in the matching branch across all tools.

---

#### 4. Verify FlutterFlow Branch Before Changes

**Before making FlutterFlow changes:**
1. Check current branch in FlutterFlow UI (top toolbar shows branch name)
2. If on wrong branch, click branch name → Switch Branch → `JUAN-SIDE-BRANCH`
3. Make changes
4. Commit in FlutterFlow: Toolbar → **"Commit Changes"**
5. Add commit message matching git conventions

**Example Commit Message:**
```
feat(auth): Add login page with social auth buttons

- Email/password input fields
- Google and Apple login buttons
- Password visibility toggle
- Forgot password link
```

---

#### 5. Export FlutterFlow Code to Git

**When ready to sync code from FlutterFlow to Git:**

1. In FlutterFlow: Toolbar → **"Developer Menu"** → **"Download Code"**
2. Extract downloaded ZIP
3. Copy Flutter code to your git repository:
   ```bash
   # From Downloads folder
   unzip CSC305Capstone-JUAN-SIDE-BRANCH.zip -d /tmp/ff-export

   # Copy to git repo (adjust paths as needed)
   cp -r /tmp/ff-export/lib/* /home/j-p-v/school/CSC305PROJECT/CSCSoftwareDevelopment/flutter/lib/
   cp -r /tmp/ff-export/assets/* /home/j-p-v/school/CSC305PROJECT/CSCSoftwareDevelopment/flutter/assets/
   ```

4. Commit to git:
   ```bash
   git add .
   git commit -m "feat(flutter): Sync FlutterFlow changes from JUAN-SIDE-BRANCH"
   git push origin JUAN-SIDE-BRANCH
   ```

---

#### 6. Merge Workflow

**When feature is complete:**

**Git:**
```bash
git checkout main
git merge JUAN-SIDE-BRANCH
git push origin main
```

**FlutterFlow (Manual):**
1. Toolbar → **"Branching Options"**
2. Click **"Merge Branch"**
3. Select source: `JUAN-SIDE-BRANCH`
4. Select target: `main`
5. Review changes in merge dialog
6. Resolve any conflicts (FlutterFlow shows visual diff)
7. Click **"Merge"**
8. Verify merge successful

**Result:** Both Git and FlutterFlow `main` branches have merged changes

---

## Branch Naming Convention

### Standardized Format
```
<owner>-<purpose>-BRANCH
```

**Examples:**
- `JUAN-SIDE-BRANCH` ✅ (current)
- `MARIA-AUTH-BRANCH` (for Maria's auth work)
- `ALEX-DISCOVERY-BRANCH` (for Alex's discovery feature)
- `SOPHIA-COOK-MODE-BRANCH` (for Sophia's cook mode feature)

**Why this format?**
- Clear ownership
- Descriptive purpose
- Easy to identify across Git and FlutterFlow
- Consistent with team naming

---

## Common Issues & Solutions

### Issue 1: FlutterFlow Branch Doesn't Exist

**Symptom:** You're in `JUAN-SIDE-BRANCH` in Git, but FlutterFlow only shows `main`

**Solution:**
```
Manual Action Required:
1. Open FlutterFlow project
2. Create branch "JUAN-SIDE-BRANCH" via UI (steps above)
3. Verify branch appears in branch selector
```

---

### Issue 2: Changes Made in Wrong FlutterFlow Branch

**Symptom:** Accidentally edited `main` instead of `JUAN-SIDE-BRANCH`

**Solution:**
```
Option A (Small changes):
1. In FlutterFlow, switch to JUAN-SIDE-BRANCH
2. Manually redo changes in correct branch

Option B (Large changes):
1. Use FlutterFlow's "Version History" feature
2. Find commit before your changes
3. Create new branch from that commit
4. Reapply changes in correct branch
```

---

### Issue 3: Git and FlutterFlow Out of Sync

**Symptom:** Git has commits that FlutterFlow doesn't, or vice versa

**Solution:**
```
1. Document current state of both:
   - Git: `git log --oneline -10`
   - FlutterFlow: Check commit history in UI

2. Decide source of truth:
   - For code/scripts: Git is source of truth
   - For UI/pages: FlutterFlow is source of truth

3. Sync:
   - Export FlutterFlow code (if UI is ahead)
   - Update Git with exported code
   - Commit with message: "sync: FlutterFlow changes from [branch]"
```

---

## Automation (Future Enhancement)

### Current Limitations
- FlutterFlow API does NOT support:
  - Creating branches
  - Switching branches
  - Merging branches
  - Listing branches

### Potential Workarounds

#### Option 1: FlutterFlow CLI (If Available)
Check if FlutterFlow team provides CLI tools:
```bash
# Hypothetical (not currently available)
ff branch create JUAN-SIDE-BRANCH
ff branch switch JUAN-SIDE-BRANCH
ff export --branch JUAN-SIDE-BRANCH
```

**Action:** Contact FlutterFlow support to request CLI or API for branching

---

#### Option 2: GitHub Integration
FlutterFlow supports GitHub integration for code export:
1. FlutterFlow: Settings → **GitHub**
2. Connect repository: `YOUR_ORG/CSCSoftwareDevelopment`
3. Enable auto-export on commit
4. FlutterFlow commits → automatically push to GitHub

**Limitation:** This only syncs code, not branch creation

---

#### Option 3: Monitoring Script
Create a script to remind developers to check branch sync:

```bash
#!/bin/bash
# check-branch-sync.sh

echo "🔍 Checking branch synchronization..."

# Get current git branch
GIT_BRANCH=$(git branch --show-current)
echo "Git branch: $GIT_BRANCH"

# Prompt user to verify FlutterFlow branch
echo ""
echo "⚠️  ACTION REQUIRED:"
echo "1. Open FlutterFlow: https://app.flutterflow.io/project/c-s-c305-capstone-khj14l"
echo "2. Check that FlutterFlow branch matches: $GIT_BRANCH"
echo "3. If not, switch to $GIT_BRANCH in FlutterFlow"
echo ""
read -p "Press ENTER once you've verified FlutterFlow branch matches..."

echo "✅ Proceeding with work on branch: $GIT_BRANCH"
```

Usage:
```bash
# Before starting work
./scripts/check-branch-sync.sh

# Make changes in Git and FlutterFlow

# Commit
git commit -m "feat: Add changes"
```

---

## Team Communication Protocol

To avoid branch confusion, use this protocol:

### 1. Before Starting Work
**Post in team channel (Slack/Discord):**
```
🚀 Starting work on JUAN-SIDE-BRANCH
- Git: Checked out JUAN-SIDE-BRANCH
- FlutterFlow: Switched to JUAN-SIDE-BRANCH
- Working on: Authentication flow (Login page)
```

### 2. When Committing
**Use consistent commit messages:**
```
[JUAN-SIDE-BRANCH] feat(auth): Add login page

- Added email/password inputs
- Added Google/Apple login buttons
- Styled with Material 3 theme

FlutterFlow commit: c3a2b1d
```

### 3. Before Merging
**Post merge request:**
```
🔀 Ready to merge JUAN-SIDE-BRANCH → main

Git changes:
- 12 commits
- Files changed: 15
- Review: https://github.com/YOUR_ORG/repo/pull/123

FlutterFlow changes:
- 8 commits
- Pages added: Login, Sign Up
- Review in FlutterFlow UI required

Requesting reviews from: @maria @alex
```

---

## Verification Checklist

### Before Making Changes
- [ ] Git branch: `git branch --show-current` shows correct branch
- [ ] FlutterFlow branch: Top toolbar shows correct branch name
- [ ] Figma branch (optional): Check file branch in Figma UI

### Before Committing
- [ ] Git: Changes staged and ready (`git status`)
- [ ] FlutterFlow: Changes saved (auto-saves, but verify)
- [ ] Commit messages consistent across tools

### Before Merging
- [ ] All changes committed in both Git and FlutterFlow
- [ ] Code exported from FlutterFlow and committed to Git
- [ ] Tests passing (if applicable)
- [ ] Team review completed
- [ ] Merge conflicts resolved

---

## Quick Reference

### Git Commands
```bash
# Check current branch
git branch --show-current

# Create and switch to new branch
git checkout -b NEW-BRANCH-NAME

# Switch to existing branch
git checkout BRANCH-NAME

# List all branches
git branch -a

# Merge branch into main
git checkout main
git merge BRANCH-NAME
git push origin main

# Delete branch (after merge)
git branch -d BRANCH-NAME
git push origin --delete BRANCH-NAME
```

### FlutterFlow Manual Steps

| Action | Location | Steps |
|--------|----------|-------|
| **Create Branch** | Toolbar → Branching Options | + Create New Branch → Enter name → Create |
| **Switch Branch** | Toolbar (click branch name) | Select branch from dropdown |
| **Commit Changes** | Toolbar → Commit Changes | Enter message → Commit |
| **Merge Branch** | Toolbar → Branching Options | Merge Branch → Select source/target → Merge |
| **View History** | Toolbar → Version History | See all commits on current branch |

---

## Single Source of Truth

All project constants are centralized in:
```
/home/j-p-v/school/CSC305PROJECT/CSCSoftwareDevelopment/config/project-config.json
```

**Includes:**
- Branch names (main, development, current)
- All project IDs (GCP, Firebase, FlutterFlow, Figma)
- Team information
- Environment configurations
- Secret references

**Always reference this file** instead of hardcoding values.

---

## Next Steps

### Immediate Actions Required

1. **[ ] Create JUAN-SIDE-BRANCH in FlutterFlow** (MANUAL)
   - Open: https://app.flutterflow.io/project/c-s-c305-capstone-khj14l
   - Create branch matching git branch name
   - Document completion

2. **[ ] Verify branch synchronization**
   - Git: `git branch --show-current`
   - FlutterFlow: Check toolbar
   - Confirm both show `JUAN-SIDE-BRANCH`

3. **[ ] Create branch sync script**
   - Script: `scripts/check-branch-sync.sh`
   - Add to workflow: Run before each work session

4. **[ ] Document FlutterFlow branch creation**
   - Update SETUP_COMPLETE.md with confirmation
   - Note date/time branch was created
   - Share with team

---

## Resources

- **FlutterFlow Branching Docs:** https://docs.flutterflow.io/collaboration/branching/
- **FlutterFlow Commits Docs:** https://docs.flutterflow.io/collaboration/saving-versioning/
- **Project Config:** `/config/project-config.json`
- **Team Communication:** uricsc305@gmail.com

---

**Remember:** FlutterFlow branches are **FlutterFlow-internal only**. Always manually sync with Git!

**Last Updated:** 2025-10-20
**Status:** Git branch exists ✅ | FlutterFlow branch pending ⏳
