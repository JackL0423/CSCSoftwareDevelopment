# GlobalFlavors - CSC305 Software Development Capstone

**Institution**: University of Rhode Island
**Course**: CSC305 Software Development
**Team Lead**: Juan Vallejo (juan_vallejo@uri.edu)
**Project**: FlutterFlow Mobile Application for International Cuisine Discovery

---

## Project Overview

GlobalFlavors is a mobile application built with FlutterFlow that helps users discover and explore international cuisines. The app features recipe browsing, user authentication, personalized recommendations, and comprehensive retention tracking.

**FlutterFlow Project**: `c-s-c305-capstone-khj14l`
**Plan**: Growth Plan (API-enabled)
**Current Branch**: `JUAN-adding-metric`

---

## Key Features

### Implemented
- **User Authentication**: Firebase Auth integration
- **Recipe Database**: Firestore-backed recipe collection
- **Search & Browse**: Cuisine-based recipe discovery
- **Personalized Recommendations**: User preference tracking
- **D7 Retention Metrics**: Complete cohort-based retention tracking system

### In Development
- Enhanced personalization algorithms
- Social sharing features
- Recipe ratings and reviews

---

## Project Structure

```
CSCSoftwareDevelopment/
├── docs/                          # Project documentation
│   ├── BUSINESSPLAN.md            # Business plan and strategy
│   ├── PERSONAS.md                # User personas
│   ├── METRICS.md                 # Success metrics definition
│   ├── ABTEST.md                  # A/B testing strategies
│   ├── UserResarch.md             # User research findings
│   ├── CONDUCT.md                 # Team code of conduct
│   ├── D7_RETENTION_DEPLOYMENT.md # D7 retention deployment guide
│   ├── D7_RETENTION_TECHNICAL.md  # D7 retention technical reference
│   └── archive/                   # Historical documentation
├── scripts/                       # Automation scripts
│   ├── setup-vscode-deployment.sh # Interactive deployment wizard
│   ├── deploy-d7-retention-complete.sh # Master deployment script
│   ├── test-retention-function.sh # Firebase function testing
│   ├── download-yaml.sh           # FlutterFlow YAML download
│   ├── upload-yaml.sh             # FlutterFlow YAML upload
│   └── validate-yaml.sh           # YAML validation
├── functions/                     # Firebase Cloud Functions
│   ├── index.js                   # D7 retention calculation functions
│   └── package.json               # Node.js dependencies
├── vscode-extension-ready/        # FlutterFlow custom actions
│   └── lib/custom_code/actions/   # Dart action files (3 actions)
├── private-dev-docs/              # Development guides and investigations
├── firestore.indexes.json         # Firestore composite indexes
├── firebase.json                  # Firebase configuration
├── CHANGELOG.md                   # Project change history
├── CLAUDE.md                      # AI assistant context and standards
├── README_D7_RETENTION.md         # D7 retention feature overview
└── README.md                      # This file

```

---

## Documentation

### Core Project Documents
- **Business Plan**: [docs/BUSINESSPLAN.md](docs/BUSINESSPLAN.md)
- **User Research**: [docs/UserResarch.md](docs/UserResarch.md)
- **User Personas**: [docs/PERSONAS.md](docs/PERSONAS.md)
- **Success Metrics**: [docs/METRICS.md](docs/METRICS.md)
- **A/B Testing Strategy**: [docs/ABTEST.md](docs/ABTEST.md)
- **Team Code of Conduct**: [docs/CONDUCT.md](docs/CONDUCT.md)

### Technical Documentation
- **D7 Retention Feature**: [README_D7_RETENTION.md](README_D7_RETENTION.md)
- **Deployment Guide**: [docs/D7_RETENTION_DEPLOYMENT.md](docs/D7_RETENTION_DEPLOYMENT.md)
- **Technical Reference**: [docs/D7_RETENTION_TECHNICAL.md](docs/D7_RETENTION_TECHNICAL.md)
- **FlutterFlow API Guide**: [private-dev-docs/FLUTTERFLOW_API_GUIDE.md](private-dev-docs/FLUTTERFLOW_API_GUIDE.md)

### Process Documentation
- **Changelog**: [CHANGELOG.md](CHANGELOG.md) - Complete project history
- **CLAUDE.md**: [CLAUDE.md](CLAUDE.md) - AI assistant context and communication standards

---

## Quick Start - D7 Retention Deployment

Deploy the complete D7 retention tracking system in 2.5-3 hours:

```bash
# Interactive setup (recommended) - uses wrapper script
./scripts/deploy.sh vscode

# Or complete end-to-end deployment
./scripts/deploy.sh full

# Or follow manual guide
cat README_D7_RETENTION.md
```

**All scripts documented**: See [scripts/README.md](scripts/README.md) for complete usage guide

**What gets deployed**:
- 3 custom Dart actions (session tracking, completion logging, scroll detection)
- 4 Firebase Cloud Functions (D7 calculation, metrics API, trends)
- 2 Firestore composite indexes
- Complete UI wiring in FlutterFlow

**First D7 metric**: Available 7 days after first user completes a recipe

See [README_D7_RETENTION.md](README_D7_RETENTION.md) for details.

---

## Development Setup

### Prerequisites
- Flutter SDK 3.32.4+
- Dart SDK 3.8.1+
- Android SDK (API 34)
- VS Code with FlutterFlow extension
- Firebase CLI
- GitHub CLI (optional)
- FlutterFlow Growth Plan account

### Environment Setup

```bash
# Clone repository
git clone <repository-url>
cd CSCSoftwareDevelopment

# Ensure you're on correct branch
git checkout JUAN-adding-metric

# Make scripts executable
chmod +x scripts/*.sh

# Configure GCP access (for FlutterFlow API)
gcloud auth login

# Install Flutter dependencies (if Flutter project added)
flutter pub get
```

### Flutter SDK Setup

This project requires a project-level Flutter SDK for the FlutterFlow VS Code Extension to function properly.

**Why Three Flutter SDKs?**

1. **System Flutter** (`/home/jpv/flutter`) - For general Flutter development
2. **Project Flutter SDK** (`flutter-sdk/`) - **REQUIRED** for VS Code Extension (IntelliSense, validation)
3. **FlutterFlow Bundled** (`c_s_c305_capstone/ff_flutter_sdk/`) - Managed by FlutterFlow (v3.32.4)

**Setup Project Flutter SDK:**

```bash
# Clone Flutter SDK to project directory (run once)
git clone https://github.com/flutter/flutter.git flutter-sdk
cd flutter-sdk
git checkout stable
./bin/flutter --version

# Verify VS Code settings point to project SDK
# Should see: flutter-sdk/ in .vscode/settings.json
```

**Note**: The `flutter-sdk/` directory is gitignored (tooling dependency, not source code).

### FlutterFlow API Access

The project uses FlutterFlow Growth Plan API for programmatic YAML editing:

```bash
# Fetch API token from GCP Secret Manager
gcloud secrets versions access latest --secret="FLUTTERFLOW_LEAD_API_TOKEN"

# List available YAML files
./scripts/list-yaml-files.sh

# Download specific file
./scripts/download-yaml.sh --file app-state

# Validate changes
./scripts/validate-yaml.sh app-state flutterflow-yamls/app-state.yaml

# Upload changes
./scripts/update-yaml.sh app-state flutterflow-yamls/app-state.yaml
```

See [CLAUDE.md](CLAUDE.md) for complete API documentation.

---

## Git Workflow

### Branch Strategy
- **main**: Stable production code, synced with GitHub
- **JUAN-adding-metric**: Current feature branch for D7 retention implementation

### Commit Standards

All commits follow Communication Standards from [CLAUDE.md](CLAUDE.md):

```
<type>(<scope>): <imperative summary>

Why:
- Problem/goal with baseline metric

What:
- Key code/config changes
- Files modified

Impact:
- Metrics, risk assessment, user-facing effects

Refs: #<issue> SHA:<short>
```

**Types**: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

See [CHANGELOG.md](CHANGELOG.md) for complete commit history.

---

## Testing

### FlutterFlow Testing
1. Open FlutterFlow project: https://app.flutterflow.io/project/c-s-c305-capstone-khj14l
2. Enter Test Mode
3. Test user flows (authentication, recipe browsing, completion tracking)
4. Verify Firestore writes in Firebase Console

### Firebase Function Testing
```bash
# Test D7 retention calculation manually
./scripts/test-retention-function.sh

# View function logs
firebase functions:log

# Test specific function
firebase functions:shell
```

### End-to-End Testing
Complete testing checklist in [docs/D7_RETENTION_DEPLOYMENT.md](docs/D7_RETENTION_DEPLOYMENT.md#testing--verification)

---

## Deployment

### D7 Retention System
Follow [README_D7_RETENTION.md](README_D7_RETENTION.md) for complete deployment instructions.

**Quick Deploy**:
```bash
./scripts/setup-vscode-deployment.sh  # Interactive wizard
```

### Firebase Backend
```bash
# Deploy functions and indexes
./scripts/deploy-d7-retention-complete.sh

# Verify deployment
firebase functions:list
```

---

## Team Communication Standards

All project communication follows standards defined in [CLAUDE.md](CLAUDE.md):

**Core Principles**:
- Professional but approachable tone
- Execution-focused with measurable outcomes
- Evidence-based claims with data/metrics
- Technically precise without unnecessary jargon

**Required Elements**:
- Summary (1-2 sentences)
- Outcome (measurable results)
- Implementation (technical details)
- Evidence (commit SHAs, metrics, verification)
- Impact (business/technical effects)

See [CLAUDE.md](CLAUDE.md#communication-style--standards) for complete standards and templates.

---

## Contributing

### For Team Members

1. **Read Communication Standards**: [CLAUDE.md](CLAUDE.md)
2. **Create Feature Branch**: `git checkout -b YOUR-feature-name`
3. **Follow Commit Format**: See Git Workflow section above
4. **Update CHANGELOG.md**: Document all changes
5. **Test Thoroughly**: Follow testing guidelines
6. **Create Pull Request**: Use PR template from CLAUDE.md

### For External Contributors

This is an academic project for CSC305. External contributions are not currently accepted.

---

## Resources

### FlutterFlow
- **Project URL**: https://app.flutterflow.io/project/c-s-c305-capstone-khj14l
- **API Documentation**: https://api.flutterflow.io/v2/
- **VS Code Extension**: Search "FlutterFlow: Custom Code Editor" in VS Code Extensions

### Firebase
- **Console**: https://console.firebase.google.com
- **Project**: globalflavors-capstone
- **Documentation**: https://firebase.google.com/docs

### Development Tools
- **Flutter**: https://docs.flutter.dev
- **Dart**: https://dart.dev
- **GitHub Repository**: [Your GitHub URL]

---

## Support

**Team Lead**: Juan Vallejo
**Email**: juan_vallejo@uri.edu (school), juan.vallejo@jpteq.com (personal)
**Office Hours**: By appointment

**Issues**: Use GitHub Issues for bug reports and feature requests

---

## License

This project is part of academic coursework at the University of Rhode Island. All rights reserved.

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for complete project history.

**Last Updated**: 2025-11-05
**Version**: In Development (JUAN-adding-metric branch)
