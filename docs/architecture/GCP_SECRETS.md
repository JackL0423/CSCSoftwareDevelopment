# GCP Secret Management

> **Complete reference for Google Cloud Platform secrets and authentication**

**Last Updated**: November 17, 2025
**Project**: GlobalFlavors CSC305 Capstone
**GCP Projects**: 2 (Secrets + Firebase)

---

## Table of Contents

1. [Overview](#overview)
2. [Multi-Project Architecture](#multi-project-architecture)
3. [Multi-Account Configuration](#multi-account-configuration)
4. [Secret Manager](#secret-manager)
5. [Security Configuration](#security-configuration)
6. [Common Operations](#common-operations)
7. [Troubleshooting](#troubleshooting)

---

## Overview

This project uses Google Cloud Platform (GCP) for secure credential storage via Secret Manager. All API tokens, credentials, and sensitive configuration are stored in GCP secrets and loaded at runtime.

**Key Features**:
- 10 secrets available in Secret Manager
- 3 secrets loaded automatically by scripts
- Multi-project architecture (secrets + Firebase)
- Multi-account support (personal, school, project)

---

## Multi-Project Architecture

This project uses **two separate GCP projects** with distinct purposes:

### 1. Secrets Project

**Project ID**: `[GCP_SECRETS_PROJECT_ID]`

- **Purpose**: Secure credential storage via Secret Manager
- **Owner**: [REDACTED]@example.edu
- **Organization**: uri.edu (698125975939)
- **Secret Manager**: **ENABLED**
- **Used by**: All scripts requiring API tokens/credentials

### 2. Firebase Project

**Project ID**: `[FIREBASE_PROJECT_ID]`

- **Purpose**: Backend services (Cloud Functions, Firestore, Firebase)
- **Admin**: [REDACTED]@example.edu + team
- **Organization**: Standalone (no org parent)
- **Secret Manager**: **DISABLED** (not needed)
- **Used by**: Firebase CLI, deployment scripts

### ⚠️ IMPORTANT

All `gcloud secrets` commands **MUST** specify `--project=[GCP_SECRETS_PROJECT_ID]` because the default project (`[FIREBASE_PROJECT_ID]`) does not have Secret Manager enabled.

**Example**:
```bash
# ❌ WRONG (uses default project which doesn't have Secret Manager)
gcloud secrets list

# ✅ CORRECT (explicitly specifies secrets project)
gcloud secrets list --project=[GCP_SECRETS_PROJECT_ID]
```

---

## Multi-Account Configuration

Three Google accounts are configured with different access levels:

### 1. Personal Account

**Email**: [REDACTED]@example.com

- Primary development account
- Git commits for non-school projects
- Not used for this project

### 2. School Account

**Email**: [REDACTED]@example.edu

- Used for this CSC305 project
- Git commits configured locally for this repo only
- GitHub authentication
- GCP Secret Manager access

### 3. Project Account

- FlutterFlow project access
- API token generation
- Specific to GlobalFlavors

---

## Secret Manager

### Available Secrets

**10 Secrets in GCP Secret Manager**:

| Secret Name | Purpose | Loaded by Scripts |
|-------------|---------|-------------------|
| `FLUTTERFLOW_LEAD_API_TOKEN` | FlutterFlow API authentication | ✅ Yes (as `FLUTTERFLOW_API_TOKEN`, `LEAD_TOKEN`) |
| `FIREBASE_PROJECT_ID` | Firebase integration | ✅ Yes |
| `GEMINI_API_KEY` | AI features (recipe recommendations) | ✅ Yes |
| `FLUTTERFLOW_MY_API_TOKEN` | Alternative API token | ❌ No (not currently used) |
| `FLUTTERFLOW_PROJECT_ID` | FlutterFlow project ID | ❌ No (alias created from `FIREBASE_PROJECT_ID`) |
| `FIREBASE_WEB_API_KEY` | Firebase web SDK | ❌ No (not needed - injected by FlutterFlow) |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | Service account credentials | ❌ No (used by deployment scripts only) |
| `TEST_ID_API` | Test project ID | ❌ No (testing only) |
| `FIGMA_API_KEY` | Figma integration | ❌ No (design assets) |
| `FIGMA_FILE_ID` | Figma file reference | ❌ No (design assets) |

---

### Loading Secrets (Automated)

The `scripts/utilities/load-secrets.sh` script loads the 3 required secrets with parallel loading and retry logic.

**Usage**:
```bash
# Source the optimized secrets loader
source scripts/utilities/load-secrets.sh

# This exports these environment variables:
# - $FLUTTERFLOW_API_TOKEN (or $LEAD_TOKEN)
# - $FIREBASE_PROJECT_ID
# - $GEMINI_API_KEY
```

**Performance**: Loads 3 secrets in parallel (~300ms vs ~900ms sequential)

**Features**:
- Parallel loading for speed
- Automatic retry on transient failures
- Environment variable validation
- Clear error messages

---

### Manual Access

For manual secret access or debugging:

#### List All Secrets
```bash
gcloud secrets list --project=[GCP_SECRETS_PROJECT_ID]
```

#### Get Specific Secret
```bash
gcloud secrets versions access latest \
  --secret="SECRET_NAME" \
  --project=[GCP_SECRETS_PROJECT_ID]
```

**Example**:
```bash
# Get FlutterFlow API token
gcloud secrets versions access latest \
  --secret="FLUTTERFLOW_LEAD_API_TOKEN" \
  --project=[GCP_SECRETS_PROJECT_ID]
```

#### Verify Active Account
```bash
gcloud auth list
```

#### Verify Current Project
```bash
gcloud config get-value project
```

---

### Important Notes

**Firebase web SDK secrets** (FIREBASE_API_KEY, FIREBASE_AUTH_DOMAIN, etc.) are **NOT** stored in Secret Manager because they are injected by FlutterFlow at build time.

**Service account JSON**: Stored in Secret Manager as `FIREBASE_SERVICE_ACCOUNT_JSON`, used only by deployment scripts (`scripts/firebase/deploy-firebase-with-serviceaccount.sh`).

---

## Security Configuration

### SSH Keys
- **Algorithm**: ed25519 (secure, modern)
- **Private key permissions**: 600
- **Public key permissions**: 644
- **Location**: `~/.ssh/`

### GitHub Token
- **Storage**: System keyring (not in files)
- **Access**: GitHub CLI (`gh`) only
- **Never committed** to git

### Git Ignore
- **Lines**: 397+ entries
- **Protects**: `.env`, secrets, credentials, API keys
- **Prevents**: Accidental secret commits

### Secret Management Best Practices
- ✅ All credentials via GCP Secret Manager
- ✅ No secrets in code or configuration files
- ✅ Environment variables loaded at runtime
- ✅ Secrets rotated regularly (every 90 days recommended)
- ❌ Never commit `.env` files
- ❌ Never hardcode API tokens
- ❌ Never share secrets via email/Slack

---

## Common Operations

### Add New Secret
```bash
# Create new secret
echo -n "your-secret-value" | \
  gcloud secrets create SECRET_NAME \
  --data-file=- \
  --project=[GCP_SECRETS_PROJECT_ID]
```

### Update Secret
```bash
# Add new version
echo -n "new-secret-value" | \
  gcloud secrets versions add SECRET_NAME \
  --data-file=- \
  --project=[GCP_SECRETS_PROJECT_ID]
```

### Delete Secret
```bash
gcloud secrets delete SECRET_NAME \
  --project=[GCP_SECRETS_PROJECT_ID]
```

### Grant Access to Secret
```bash
gcloud secrets add-iam-policy-binding SECRET_NAME \
  --member="user:[EMAIL]" \
  --role="roles/secretmanager.secretAccessor" \
  --project=[GCP_SECRETS_PROJECT_ID]
```

---

## Troubleshooting

### Problem: "Permission denied" when accessing secrets

**Solution**:
```bash
# 1. Verify authenticated account
gcloud auth list

# 2. Ensure using school account
gcloud auth login [REDACTED]@example.edu

# 3. Verify IAM permissions
gcloud projects get-iam-policy [GCP_SECRETS_PROJECT_ID] \
  --flatten="bindings[].members" \
  --filter="bindings.members:[REDACTED]@example.edu"
```

---

### Problem: "Secret not found"

**Solution**:
```bash
# 1. List all secrets to verify name
gcloud secrets list --project=[GCP_SECRETS_PROJECT_ID]

# 2. Check correct project is specified
gcloud config get-value project

# 3. Explicitly set project if needed
gcloud config set project [GCP_SECRETS_PROJECT_ID]
```

---

### Problem: Scripts can't load secrets

**Solution**:
```bash
# 1. Verify load-secrets.sh exists
ls -la scripts/utilities/load-secrets.sh

# 2. Source the script (don't execute)
source scripts/utilities/load-secrets.sh

# 3. Verify environment variables set
echo $FLUTTERFLOW_API_TOKEN
echo $FIREBASE_PROJECT_ID
echo $GEMINI_API_KEY
```

---

### Problem: "Wrong project" errors

**Solution**:
```bash
# Always specify --project flag for secret operations
gcloud secrets list --project=[GCP_SECRETS_PROJECT_ID]

# Or temporarily set default project
gcloud config set project [GCP_SECRETS_PROJECT_ID]

# Check current default project
gcloud config get-value project
```

---

## Additional Resources

- **GCP Secret Manager Docs**: https://cloud.google.com/secret-manager/docs
- **Firebase Project Console**: https://console.firebase.google.com/project/[FIREBASE_PROJECT_ID]
- **GCP IAM Docs**: https://cloud.google.com/iam/docs
- **Security Policy**: [SECURITY.md](../../SECURITY.md)
- **Main Context**: [CLAUDE.md](../../CLAUDE.md)

---

**Last Updated**: November 17, 2025
**Maintainer**: GlobalFlavors Team
**Questions?**: See [CONTRIBUTING.md](../../CONTRIBUTING.md)
