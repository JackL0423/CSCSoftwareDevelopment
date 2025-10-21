# GlobalFlavors - Project Status & Next Actions

**Date:** 2025-10-20
**Branch:** JUAN-SIDE-BRANCH (Git) | Pending creation in FlutterFlow
**Updated By:** Claude Code Assistant

---

## ✅ Completed Setup

### 1. **Single Source of Truth** ✅

Created centralized configuration in `/config/project-config.json`:

```json
{
  "project": {
    "name": "GlobalFlavors",
    "tagline": "Discover authentic regional dishes you can cook tonight"
  },
  "platforms": {
    "gcp": { "project_id": "csc305project-475802" },
    "firebase": { "project_id": "csc-305-dev-project" },
    "flutterflow": { "project_id": "c-s-c305-capstone-khj14l" },
    "figma": { "file_id": "TO_BE_CONFIGURED" }
  },
  "branches": {
    "main": "main",
    "development": "JUAN-SIDE-BRANCH",
    "current": "JUAN-SIDE-BRANCH"
  }
}
```

**Purpose:** All project constants in one place. No more hardcoded values scattered across files.

---

### 2. **Secret Management** ✅

All secrets secured in Google Secret Manager:

| Secret Name | Status | Environment |
|-------------|--------|-------------|
| `FIREBASE_SERVICE_ACCOUNT_JSON` | ✅ Stored | All |
| `FIREBASE_PROJECT_ID` | ✅ Stored | All |
| `FLUTTERFLOW_PROJECT_ID` | ✅ Stored | All |
| `FIGMA_API_KEY` | ⚠️ Needs rotation | All |
| `FIGMA_FILE_ID` | ⏳ Pending | All |
| `FLUTTERFLOW_API_TOKEN` | ⚠️ Needs rotation | All |

**Load secrets:**
```bash
source scripts/load-secrets.sh
```

**Test:**
```bash
/home/j-p-v/google-cloud-sdk/bin/gcloud secrets versions access latest \
  --secret="FIREBASE_PROJECT_ID" --project=csc305project-475802
# Output: csc-305-dev-project ✅
```

---

### 3. **Comprehensive Documentation** ✅

| Document | Purpose | Status |
|----------|---------|--------|
| `SETUP_COMPLETE.md` | Initial setup summary | ✅ Complete |
| `config/project-config.json` | Single source of truth | ✅ Complete |
| `docs/FIGMA_API_GUIDE.md` | Figma capabilities & workflow | ✅ Complete |
| `docs/BRANCH_SYNC_GUIDE.md` | Git ↔ FlutterFlow sync strategy | ✅ Complete |
| `docs/SECRET_SETUP_INSTRUCTIONS.md` | Secret Manager guide | ✅ Complete |
| `PROJECT_STATUS.md` | This file | ✅ Complete |

---

## 🎯 Your Questions Answered

### Q1: "Ensure one source of truth"

**Answer:** ✅ **DONE**

Created `/config/project-config.json` with:
- All project IDs (GCP, Firebase, FlutterFlow, Figma)
- Branch names (main, development, current)
- Team information
- Environment configurations
- API endpoints
- Development phases

**How to use:**
```javascript
// In your code, reference the config file
const config = require('./config/project-config.json');

console.log(config.platforms.flutterflow.project_id);
// Output: c-s-c305-capstone-khj14l

console.log(config.branches.current);
// Output: JUAN-SIDE-BRANCH
```

---

### Q2: "Ensure this branch we are checking out is the same branch being checkout of flutterflow"

**Answer:** ⚠️ **MANUAL ACTION REQUIRED**

**The Issue:**
- FlutterFlow does NOT provide API access for branch operations
- Branches must be created/switched manually in FlutterFlow UI
- FlutterFlow branches are FlutterFlow-internal (don't sync with GitHub)

**Current State:**
- **Git:** ✅ `JUAN-SIDE-BRANCH` exists and is checked out
- **FlutterFlow:** ⏳ Branch does NOT exist yet (must be created manually)

**Required Action:**

1. Open FlutterFlow project:
   ```
   https://app.flutterflow.io/project/c-s-c305-capstone-khj14l
   ```

2. Create branch:
   - Click **"Branching Options"** (toolbar, top-right)
   - Click **"+ Create New Branch"**
   - Branch name: `JUAN-SIDE-BRANCH`
   - Description: "Juan's development branch for authentication flow"
   - Base branch: `main`
   - Click **"Create Branch"**

3. Verify:
   - Check toolbar shows: `JUAN-SIDE-BRANCH`
   - Make test edit to confirm you're on correct branch

**Documentation:** See `/docs/BRANCH_SYNC_GUIDE.md` for complete workflow

**Why this matters:**
- Prevents accidentally editing `main` branch
- Keeps your work isolated until ready to merge
- Matches Git workflow for consistency

---

### Q3: "What can you do with the FIGMA API"

**Answer:** ✅ **DOCUMENTED**

See complete guide: `/docs/FIGMA_API_GUIDE.md`

**Summary of Capabilities:**

#### ✅ Available with Personal Access Token (What You Have)

1. **Get File Metadata**
   - File structure, pages, frames
   - Last modified, version info
   - Thumbnail URLs

2. **Get Nodes/Components**
   - Extract specific UI components
   - Layout properties (constraints, auto-layout)
   - Colors, styles, effects

3. **Export Assets** (★ Most Useful)
   - PNG: Raster images (icons, screenshots)
   - SVG: Vector graphics (icons, illustrations)
   - JPG: Photos
   - PDF: Print-ready designs
   - Scale: 0.01x to 4x

4. **Get Styles**
   - Color palette
   - Typography (text styles)
   - Effects (shadows, blurs)
   - Grids

5. **Get Components**
   - All reusable components
   - Component variants
   - Material 3 Design Kit components

6. **Comments API**
   - Read comments
   - Post comments
   - Team collaboration

#### ❌ Requires Figma Enterprise (Not Available)

- Design Tokens (Variables API)
- Programmatic library publishing
- Branch management via API
- Dev Mode API

#### 📋 Recommended Workflow

**Phase 1: Manual with API Export**
1. Design in Figma (Material 3 Design Kit)
2. Use API to export assets:
   ```bash
   # Export logo
   curl -H "Authorization: Bearer $FIGMA_API_KEY" \
     "https://api.figma.com/v1/images/$FIGMA_FILE_ID?ids=LOGO_ID&format=png&scale=3"

   # Export all icons as SVG
   curl -H "Authorization: Bearer $FIGMA_API_KEY" \
     "https://api.figma.com/v1/images/$FIGMA_FILE_ID?ids=ICON_1,ICON_2&format=svg"
   ```
3. Upload to FlutterFlow Assets
4. Manually recreate layouts in FlutterFlow

**Phase 2: API-Assisted (Future)**
- Script to batch-export all assets
- Generate design token JSON
- Automate asset upload workflow

---

## ⏳ Pending Actions

### 1. **Create FlutterFlow Branch** (HIGH PRIORITY)

**Status:** ⏳ Pending
**Who:** You (must be done manually in FlutterFlow UI)
**When:** Before making any FlutterFlow changes

**Steps:**
1. Open: https://app.flutterflow.io/project/c-s-c305-capstone-khj14l
2. Toolbar → Branching Options → Create New Branch
3. Name: `JUAN-SIDE-BRANCH`
4. Create from: `main`
5. Verify branch created (toolbar shows branch name)

**Documentation:** `/docs/BRANCH_SYNC_GUIDE.md`

---

### 2. **Get Figma File ID** (HIGH PRIORITY)

**Status:** ⏳ Pending
**Who:** You
**When:** Before using Figma API

**Steps:**
1. Open your Figma file for GlobalFlavors
2. Copy File ID from URL:
   ```
   https://www.figma.com/file/ABC123DEF456/GlobalFlavors
                                ^^^^^^^^^^^^
                                File ID
   ```
3. Store in Secret Manager:
   ```bash
   echo -n "YOUR_FILE_ID" | \
     /home/j-p-v/google-cloud-sdk/bin/gcloud secrets create FIGMA_FILE_ID \
     --data-file=- \
     --replication-policy="automatic" \
     --project=csc305project-475802
   ```
4. Update `/config/project-config.json`:
   ```json
   "figma": {
     "file_id": "YOUR_FILE_ID"
   }
   ```

---

### 3. **Rotate Exposed API Keys** (HIGH PRIORITY)

**Status:** ⚠️ Security Risk
**Who:** You
**When:** ASAP (keys were exposed in conversation history)

#### FlutterFlow API Token
```
Exposed: 9dc3d62e-6d19-4831-9386-02760f9fb7c0
```

**Steps to Rotate:**
1. FlutterFlow → Account Settings → API
2. Revoke old token: `9dc3d62e-6d19-4831-9386-02760f9fb7c0`
3. Generate new token
4. Update Secret Manager:
   ```bash
   echo -n "NEW_TOKEN" | \
     /home/j-p-v/google-cloud-sdk/bin/gcloud secrets versions add FLUTTERFLOW_API_TOKEN \
     --data-file=- --project=csc305project-475802
   ```

#### Figma API Key
```
Exposed: [REDACTED - See config/project-config.json security section]
```

**Steps to Rotate:**
1. Figma → Settings → Personal Access Tokens
2. Revoke old token (see security section in config/project-config.json)
3. Generate new token
4. Update Secret Manager:
   ```bash
   echo -n "NEW_TOKEN" | \
     /home/j-p-v/google-cloud-sdk/bin/gcloud secrets versions add FIGMA_API_KEY \
     --data-file=- --project=csc305project-475802
   ```

---

### 4. **Begin Figma UI Design** (NEXT PHASE)

**Status:** ⏳ Ready to start
**Who:** You + design team
**When:** After FlutterFlow branch created

**Phase 1: Authentication Flow**

Create these pages in Figma:
1. Splash Screen (2s delay, fade to login)
2. Login Page (email/password + Google/Apple)
3. Sign Up Page (with password strength meter)
4. Forgot Password (reset flow)
5. Email Verification (countdown + resend)

**Design System:**
- Material 3 Design Kit
- Primary color: #FF4081 (pink accent)
- Frame size: 360x800 (mobile)
- Spacing: 8px, 12px, 16px, 24px, 32px
- Border radius: 8px, 12px, 16px

**Export when ready:**
```bash
# Load Figma API key
source scripts/load-secrets.sh

# Export login page as reference
curl -H "Authorization: Bearer $FIGMA_API_KEY" \
  "https://api.figma.com/v1/images/$FIGMA_FILE_ID?ids=LOGIN_PAGE_NODE&format=png&scale=2" \
  -o exports/login-page@2x.png
```

---

## 📊 Project Structure

```
CSCSoftwareDevelopment/
├── config/
│   ├── project-config.json          # ★ SINGLE SOURCE OF TRUTH
│   └── firebase/
│       └── service-account.json     # 🔒 Firebase credentials (gitignored)
│
├── docs/
│   ├── BUSINESSPLAN.md              # Business strategy & lean canvas
│   ├── PERSONAS.md                  # User personas
│   ├── FIGMA_API_GUIDE.md           # ★ Figma capabilities & workflow
│   ├── BRANCH_SYNC_GUIDE.md         # ★ Git ↔ FlutterFlow sync strategy
│   ├── SECRET_SETUP_INSTRUCTIONS.md # Secret Manager guide
│   └── SECRET_MANAGER_SETUP.md      # Initial setup guide
│
├── scripts/
│   ├── load-secrets.sh              # Load secrets from Google Secret Manager
│   └── store-secrets.sh             # Store secrets in Google Secret Manager
│
├── .env                             # References Secret Manager (gitignored)
├── .env.testing                     # Testing environment
├── .env.production                  # Production environment
├── .env.example                     # Template (safe to commit)
├── .gitignore                       # ✅ Protects all secrets
├── SETUP_COMPLETE.md                # Initial setup summary
└── PROJECT_STATUS.md                # ★ This file

★ = New files created today
```

---

## 🔧 Quick Commands Reference

### Git
```bash
# Verify current branch
git branch --show-current

# Push changes
git add .
git commit -m "feat(auth): Add login page design"
git push origin JUAN-SIDE-BRANCH
```

### Secret Manager
```bash
# Load all secrets
source scripts/load-secrets.sh

# View secret value
/home/j-p-v/google-cloud-sdk/bin/gcloud secrets versions access latest \
  --secret="SECRET_NAME" --project=csc305project-475802

# List all secrets
/home/j-p-v/google-cloud-sdk/bin/gcloud secrets list --project=csc305project-475802
```

### FlutterFlow API
```bash
# Test API connection
source scripts/load-secrets.sh
curl -X POST 'https://api.flutterflow.io/v2/l/listProjects' \
  -H "Authorization: Bearer $FLUTTERFLOW_API_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{"project_type": "ALL", "deserialize_response": true}'
```

### Figma API
```bash
# Get file metadata (once you have FILE_ID)
source scripts/load-secrets.sh
curl -H "Authorization: Bearer $FIGMA_API_KEY" \
  "https://api.figma.com/v1/files/$FIGMA_FILE_ID"

# Export asset
curl -H "Authorization: Bearer $FIGMA_API_KEY" \
  "https://api.figma.com/v1/images/$FIGMA_FILE_ID?ids=NODE_ID&format=svg"
```

---

## 🎯 Next Steps (Prioritized)

### This Week

**Day 1-2: Setup Completion**
- [ ] Create `JUAN-SIDE-BRANCH` in FlutterFlow (MANUAL)
- [ ] Get Figma File ID and store in Secret Manager
- [ ] Rotate exposed API keys (FlutterFlow + Figma)
- [ ] Test Figma API connection
- [ ] Update team with new branch

**Day 3-5: Figma Design**
- [ ] Design 5 authentication pages in Figma
- [ ] Use Material 3 Design Kit
- [ ] Apply GlobalFlavors branding (#FF4081 accent)
- [ ] Create Figma branch: `JUAN-SIDE-BRANCH` (optional)
- [ ] Export assets via API

**Day 6-7: FlutterFlow Implementation**
- [ ] Create authentication pages in FlutterFlow
- [ ] Upload exported assets
- [ ] Configure Firebase Auth
- [ ] Test auth flow
- [ ] Commit FlutterFlow changes

### Next Week

**Week 2: Discovery Phase**
- [ ] Design discovery/home pages in Figma
- [ ] Implement in FlutterFlow
- [ ] Connect to Firebase Firestore
- [ ] Test region → dish flow

**Week 3-4: Cook Mode**
- [ ] Design cook mode in Figma
- [ ] Implement guided steps
- [ ] Add timers and confirmations
- [ ] Test end-to-end flow

---

## 🛡️ Security Checklist

- [x] All secrets in Google Secret Manager
- [x] `.env` files in `.gitignore`
- [x] Firebase service account secured (permissions 600)
- [x] Temporary files shredded
- [x] Shell history cleared
- [ ] Exposed API keys rotated (PENDING - HIGH PRIORITY)
- [ ] Team trained on secret handling
- [ ] No secrets in git history

---

## 👥 Team Resources

**Team Email:** uricsc305@gmail.com

**Team Members:**
- john.light@uri.edu
- mariamillington@uri.edu
- alexander.hang@uri.edu
- sophia.dellaselva@uri.edu
- Juan_vallejo@uri.edu

**Key Links:**
- Business Plan: https://docs.google.com/presentation/d/1AdgIL1-TdeeoC_RMIq0idQqPlhmNeccVTQsqzTekolU
- User Personas: https://docs.google.com/presentation/d/1p-2E9KyCJyyXrYYOkEXYjQy3kDwluuwXIvFoiH2w5ZA
- FlutterFlow Project: https://app.flutterflow.io/project/c-s-c305-capstone-khj14l

---

## 📞 Support

**Questions?**
- FlutterFlow: https://docs.flutterflow.io
- Figma API: https://www.figma.com/developers/api
- Google Secret Manager: https://cloud.google.com/secret-manager/docs
- Team: uricsc305@gmail.com

---

**Last Updated:** 2025-10-20
**Current Status:** ✅ Setup complete | ⏳ Awaiting FlutterFlow branch creation
**Next Milestone:** Complete Phase 1 authentication flow (2 weeks)
