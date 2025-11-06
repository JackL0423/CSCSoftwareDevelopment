# Tools Directory

This directory contains utility scripts for project automation and maintenance.

## Structure

```
tools/
├── python/          # Python automation scripts
└── javascript/      # JavaScript utilities
```

## Python Tools (`python/`)

### sanitize_pii.py
Automated PII (Personally Identifiable Information) sanitization script.

**Purpose**: Systematically remove or redact personal information from documentation files.

**Usage**:
```bash
python3 tools/python/sanitize_pii.py
```

**Features**:
- Processes 174+ files across the repository
- Replaces email addresses with redacted placeholders
- Sanitizes project IDs with generic placeholders
- Comprehensive logging of all modifications

**Replacements**:
- Email addresses → `[REDACTED]@example.edu` / `[REDACTED]@example.com`
- FlutterFlow Project ID → `[FLUTTERFLOW_PROJECT_ID]`
- GCP Secrets Project → `[GCP_SECRETS_PROJECT_ID]`
- Firebase Project → `[FIREBASE_PROJECT_ID]`

### add-app-state-vars.py
Add app state variables to FlutterFlow project via API.

**Purpose**: Automate the addition of state variables to FlutterFlow app-state.yaml.

### find-broken-actions.py
Scan FlutterFlow YAML files for broken custom action references.

**Purpose**: Identify custom actions that are referenced but not properly wired.

### fix-yaml-and-add-state.py
Combined utility for YAML fixes and state variable additions.

**Purpose**: Repair YAML structure issues and add missing state variables.

## JavaScript Tools (`javascript/`)

### create-user-preferences-collection.js
Create Firestore collection for user preferences.

**Purpose**: Initialize user preferences collection schema in Firebase.

**Usage**:
```bash
node tools/javascript/create-user-preferences-collection.js
```

## When to Use These Tools

**During Repository Cleanup**:
- Use `sanitize_pii.py` to remove personal information before making repository public or sharing with team members

**During FlutterFlow Development**:
- Use Python scripts for YAML manipulation and state variable management
- Use JavaScript tools for Firebase/Firestore initialization

**During Security Audits**:
- Run `sanitize_pii.py` to ensure no credentials or personal data are committed
- Verify with gitleaks after sanitization

## Requirements

**Python Scripts**:
- Python 3.8+
- PyYAML (install: `pip install pyyaml`)
- Requests (install: `pip install requests`)

**JavaScript Scripts**:
- Node.js 20+
- Firebase Admin SDK (install: `npm install firebase-admin`)

## Related Documentation

- Repository organization: See `metrics/README.md` for Phase 2 PII Sanitization details
- FlutterFlow API: See `scripts/FLUTTERFLOW_API_GUIDE.md` for API usage
- Security: See `SECURITY.md` for security practices

---

**Project Team**
Juan Vallejo, Jack Light, Maria, Alex, Sofia
*CSC305 Software Development Capstone*
*University of Rhode Island, Fall 2025*
