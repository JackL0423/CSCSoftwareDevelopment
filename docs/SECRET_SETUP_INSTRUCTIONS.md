# GlobalFlavors - Secret Manager Setup Instructions

**Project:** CSC305PROJECT
**Project ID:** `csc305project-475802`
**Project Number:** `815086348049`

---

## 🚀 Quick Start: Store Your Secrets (5 Minutes)

### Step 1: Set Active GCP Project

```bash
# Set your active project
gcloud config set project csc305project-475802

# Verify
gcloud config get-value project
# Should output: csc305project-475802
```

### Step 2: Enable Secret Manager API

```bash
# Enable the API (one-time setup)
gcloud services enable secretmanager.googleapis.com --project=csc305project-475802

# Verify it's enabled
gcloud services list --enabled | grep secretmanager
```

### Step 3: Store Your Secrets

**Option A: Using the Store Script (Recommended)**

```bash
# Navigate to project directory
cd /home/j-p-v/school/CSC305PROJECT/CSCSoftwareDevelopment

# Run the store script
./scripts/store-secrets.sh dev

# Follow the prompts and verify success
```

**Option B: Manual Storage (Most Secure)**

```bash
# Create secrets one by one (interactive - no terminal history!)

# FlutterFlow API Token
gcloud secrets create FLUTTERFLOW_API_TOKEN \
  --replication-policy="automatic" \
  --project=csc305project-475802
# Paste: 9dc3d62e-6d19-4831-9386-02760f9fb7c0
# Press Ctrl+D

# Figma API Key
gcloud secrets create FIGMA_API_KEY \
  --replication-policy="automatic" \
  --project=csc305project-475802
# Paste your Figma API key here
# Press Ctrl+D

# FlutterFlow Project ID (non-sensitive but centralized)
echo -n "c-s-c305-capstone-khj14l" | gcloud secrets create FLUTTERFLOW_PROJECT_ID \
  --data-file=- \
  --replication-policy="automatic" \
  --project=csc305project-475802
```

### Step 4: Verify Secrets Were Created

```bash
# List all secrets
gcloud secrets list --project=csc305project-475802

# Should see:
# - FLUTTERFLOW_API_TOKEN
# - FIGMA_API_KEY
# - FLUTTERFLOW_PROJECT_ID (if stored)

# View secret metadata (NOT the actual value)
gcloud secrets describe FLUTTERFLOW_API_TOKEN --project=csc305project-475802
gcloud secrets describe FIGMA_API_KEY --project=csc305project-475802
```

### Step 5: Test Loading Secrets

```bash
# Source the load-secrets script
source scripts/load-secrets.sh

# Verify secrets are loaded as environment variables
echo "FlutterFlow Token: ${FLUTTERFLOW_API_TOKEN:0:10}..." # Shows first 10 chars
echo "Figma Key: ${FIGMA_API_KEY:0:10}..."                # Shows first 10 chars
```

### Step 6: Cleanup (IMPORTANT!)

```bash
# Securely delete temporary file with actual secrets
shred -u .env.tmp

# Clear shell history (removes exposed keys from history)
history -c && history -w

# Verify .env.tmp is gone
ls -la .env.tmp
# Should say: No such file or directory
```

---

## 🔐 Post-Setup: Rotate Exposed Keys

Since the keys were shared in this conversation, you should rotate them:

### Rotate Figma API Key

1. Go to Figma → Settings → Personal Access Tokens
2. Find the exposed token (see config/project-config.json security section)
3. Click "Revoke"
4. Create new token
5. Update in Secret Manager:

```bash
# Add new version of the secret
gcloud secrets versions add FIGMA_API_KEY --project=csc305project-475802
# Paste new token and Ctrl+D

# Verify new version exists
gcloud secrets versions list FIGMA_API_KEY --project=csc305project-475802
```

### Rotate FlutterFlow API Token

1. Go to FlutterFlow → Account Settings → API Tokens
2. Revoke old token: `9dc3d62e-6d19-4831-9386-02760f9fb7c0`
3. Generate new token
4. Update in Secret Manager:

```bash
# Add new version
gcloud secrets versions add FLUTTERFLOW_API_TOKEN --project=csc305project-475802
# Paste new token and Ctrl+D
```

---

## 🔧 Daily Development Workflow

### Starting Development

```bash
# 1. Navigate to project
cd /home/j-p-v/school/CSC305PROJECT/CSCSoftwareDevelopment

# 2. Load secrets from Google Secret Manager
source scripts/load-secrets.sh

# 3. Start development
npm start
# OR
npm run dev
```

### Testing

```bash
# Load testing environment secrets
export NODE_ENV=testing
source scripts/load-secrets.sh

# Run tests
npm test
```

### Production Deployment

```bash
# Load production secrets
export NODE_ENV=production
source scripts/load-secrets.sh

# Deploy
npm run build
npm run deploy
```

---

## 📋 Secret Manager Cheat Sheet

### List All Secrets
```bash
gcloud secrets list --project=csc305project-475802
```

### View Secret Metadata
```bash
gcloud secrets describe SECRET_NAME --project=csc305project-475802
```

### Read Secret Value (Testing Only!)
```bash
gcloud secrets versions access latest --secret="SECRET_NAME" --project=csc305project-475802
```

### Add New Version (Rotate)
```bash
gcloud secrets versions add SECRET_NAME --project=csc305project-475802
# Interactive: paste new value and Ctrl+D
```

### Delete Old Version
```bash
# List versions
gcloud secrets versions list SECRET_NAME --project=csc305project-475802

# Disable old version
gcloud secrets versions disable VERSION_NUMBER --secret="SECRET_NAME" --project=csc305project-475802

# Destroy old version (permanent!)
gcloud secrets versions destroy VERSION_NUMBER --secret="SECRET_NAME" --project=csc305project-475802
```

### Grant Access to Service Account
```bash
gcloud secrets add-iam-policy-binding SECRET_NAME \
  --member="serviceAccount:YOUR_SERVICE_ACCOUNT@csc305project-475802.iam.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor" \
  --project=csc305project-475802
```

---

## ✅ Security Checklist

After setup, verify:

- [ ] Secrets stored in Google Secret Manager
- [ ] `.env.tmp` securely deleted (`shred -u .env.tmp`)
- [ ] Shell history cleared (`history -c && history -w`)
- [ ] `.gitignore` includes `.env*` files
- [ ] Figma API key rotated (new one generated)
- [ ] FlutterFlow API token rotated (new one generated)
- [ ] `load-secrets.sh` works (test with `source scripts/load-secrets.sh`)
- [ ] No secrets committed to git (`git log --all -S "9dc3d62e"` returns empty)

---

## 🆘 Troubleshooting

### "Permission Denied" Error

```bash
# You may need to authenticate
gcloud auth login

# Or activate service account
gcloud auth activate-service-account --key-file=path/to/key.json
```

### "Secret Not Found"

```bash
# Verify secret exists
gcloud secrets list --project=csc305project-475802

# Check spelling and project ID
```

### "API Not Enabled"

```bash
# Enable Secret Manager API
gcloud services enable secretmanager.googleapis.com --project=csc305project-475802
```

### Load Script Fails

```bash
# Check GCP_PROJECT_ID in .env file
cat .env | grep GCP_PROJECT_ID

# Should be: GCP_PROJECT_ID=csc305project-475802
```

---

**Created:** 2025-10-20
**Last Updated:** 2025-10-20
**Project:** GlobalFlavors CSC305
**GCP Project:** csc305project-475802
