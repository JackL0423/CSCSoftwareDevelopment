# GlobalFlavors - CSC305 Software Development Capstone

**Institution**: University of Rhode Island
**Course**: CSC305 Software Development
**Team Lead**: Jack Light ([REDACTED]@example.edu)

## Project Overview

GlobalFlavors is a mobile application built with FlutterFlow for discovering and exploring international cuisines. Features include recipe browsing, user authentication, personalized recommendations, and comprehensive retention tracking.

**Tech Stack**: FlutterFlow (frontend), Firebase (backend), Cloud Functions (Node.js 20)

---

## Quick Start

### 1. Setup Environment

```bash
# Load secrets from GCP Secret Manager
source scripts/utilities/load-secrets.sh
```

### 2. FlutterFlow YAML Operations

```bash
# List all YAML files
scripts/flutterflow/list-yaml-files.sh

# Download specific file
scripts/flutterflow/download-yaml.sh --file app-state

# Upload changes
scripts/flutterflow/update-yaml.sh app-state flutterflow-yamls/app-state.yaml
```

### 3. Deploy Firebase Functions

```bash
# Deploy backend
scripts/firebase/deploy-firebase-with-serviceaccount.sh

# Test D7 retention
scripts/testing/test-retention-function.sh
```

---

## Project Structure

```
CSCSoftwareDevelopment/
├── functions/          # Firebase Cloud Functions (Node.js 20)
├── lib/custom_code/    # Custom Dart actions for FlutterFlow
├── flutterflow-yamls/  # FlutterFlow project YAML files
├── scripts/            # Automation scripts
│   ├── flutterflow/    # YAML operations (8 scripts)
│   ├── firebase/       # Backend deployment (2 scripts)
│   ├── testing/        # Test & verification (9 scripts)
│   └── utilities/      # Shared utilities (4 scripts)
├── docs/               # Documentation
│   ├── project/        # Business docs (BUSINESSPLAN, PERSONAS, etc.)
│   ├── architecture/   # Technical specs (D7_RETENTION, GCP_SECRETS)
│   ├── guides/         # How-to guides (YAML_EDITING, TEMPLATES)
│   └── implementation/ # Implementation notes
└── archive/            # Historical/experimental work
```

---

## Documentation

### Essential Docs
- [Detailed Setup Guide](docs/guides/DETAILED_SETUP.md) - Complete setup instructions
- [CLAUDE.md](docs/CLAUDE.md) - AI assistant context and standards
- [CONTRIBUTING.md](CONTRIBUTING.md) - Team communication standards
- [CHANGELOG.md](docs/CHANGELOG.md) - Version history and changes
- [docs/README.md](docs/README.md) - Complete documentation index

### Key Guides
- [YAML Editing](docs/guides/YAML_EDITING_GUIDE.md) - FlutterFlow YAML workflows
- [Templates](docs/guides/TEMPLATES.md) - Commit, PR, and meeting templates
- [D7 Retention Deployment](docs/architecture/D7_RETENTION_DEPLOYMENT.md) - Metrics system
- [GCP Secrets](docs/architecture/GCP_SECRETS.md) - Secret management

---

## Key Features

### Implemented
- ✅ User Authentication (Firebase Auth)
- ✅ Recipe Database (Firestore)
- ✅ Search & Browse
- ✅ Personalized Recommendations
- ✅ D7 Retention Metrics (complete cohort tracking)

### In Development
- 🚧 Enhanced personalization algorithms
- 🚧 Social sharing features
- 🚧 Recipe ratings and reviews

---

## Team Communication

See [CONTRIBUTING.md](CONTRIBUTING.md) for:
- Communication standards
- Commit message format
- Pull request process
- Team workflows

---

## Resources

- **FlutterFlow**: https://app.flutterflow.io/project/[FLUTTERFLOW_PROJECT_ID]
- **Firebase Console**: https://console.firebase.google.com/project/[FIREBASE_PROJECT_ID]
- **GCP Console**: https://console.cloud.google.com
- **Repository**: https://github.com/[ORG]/CSCSoftwareDevelopment

---

## License

MIT License - See [LICENSE](LICENSE) for details

---

**For detailed setup instructions, see [docs/guides/DETAILED_SETUP.md](docs/guides/DETAILED_SETUP.md)**
