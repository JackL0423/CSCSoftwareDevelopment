# Contributing to GlobalFlavors

Thank you for your interest in our project!

## About This Project

GlobalFlavors is our CSC305 capstone project at the University of Rhode Island. We're building a mobile application with FlutterFlow to help users discover and explore international cuisines. This project has been an excellent learning experience in software development, API integration, and team collaboration.

## Want to Fork or Contribute?

### What You'll Need

- Flutter SDK (3.24.5 or newer)
- Git
- Node.js 20+ (for the Firebase stuff)
- Python 3.8+ (for some helper scripts)
- Google Cloud SDK (if you want to use the secret management)

### Getting Set Up

1. Clone it:
   ```bash
   git clone https://github.com/JackL0423/CSCSoftwareDevelopment.git
   cd CSCSoftwareDevelopment
   ```

2. Install stuff:
   ```bash
   # Flutter dependencies
   flutter pub get

   # Firebase Functions
   cd functions && npm install && cd ..
   ```

3. Set up your environment:
   ```bash
   # Copy the template and add your own keys
   cp .env.template .env

   # Edit .env with your credentials
   # (Never commit this file!)
   ```

## How We Work

### Branches

- `main` - The stable stuff
- `repo-organization-2025-11` - Repository organization and cleanup
- Feature branches - For new features (use descriptive names)

### Making Changes

1. Create a branch for your work:
   ```bash
   git checkout -b your-feature-name
   ```

2. Make your changes:
   - Write clear, descriptive commit messages
   - Follow the existing code style and conventions
   - Add tests for new functionality when possible
   - Update documentation as needed

3. Before committing, run validation checks:
   ```bash
   # Run tests (if any)
   flutter test

   # Check scripts (if you modified them)
   shellcheck scripts/**/*.sh

   # Make sure no secrets snuck in
   gitleaks detect --source .
   ```

4. Commit and push:
   ```bash
   git add .
   git commit -m "feat: describe what you added"
   git push origin your-feature-name
   ```

5. Open a pull request on GitHub

## FlutterFlow Integration & GitHub Sync

### Overview

Our app is built with FlutterFlow, which provides a visual interface for building Flutter apps. We use the FlutterFlow API to sync code changes between FlutterFlow's UI and our GitHub repository.

### Initial Setup (Required Once)

#### 1. Generate GitHub Personal Access Token

1. Go to [GitHub Settings → Developer Settings → Personal Access Tokens](https://github.com/settings/tokens)
2. Click "Generate new token (classic)"
3. Give it a descriptive name: "FlutterFlow CSC305 Integration"
4. Select the following scopes:
   - ✅ `repo` (Full control of private repositories)
   - ✅ `workflow` (Update GitHub Action workflows)
5. Set expiration: 90 days (recommended)
6. Click "Generate token" and **copy it immediately** (you won't see it again!)
7. Store the token securely:
   ```bash
   # Add to your local .env file (NEVER commit this!)
   echo "GITHUB_PERSONAL_ACCESS_TOKEN=ghp_your_token_here" >> .env
   ```

#### 2. Get FlutterFlow API Token

1. Log in to [FlutterFlow](https://app.flutterflow.io)
2. Go to Account Settings → API
3. Click "Generate New Token"
4. Copy the token
5. Add to your `.env` file:
   ```bash
   echo "FLUTTERFLOW_API_TOKEN=ff_api_your_token_here" >> .env
   ```

**Note**: FlutterFlow API access requires a Growth Plan subscription.

#### 3. Link GitHub Repository in FlutterFlow

1. Open your project in FlutterFlow
2. Click the **Developer Menu** (right sidebar, code icon)
3. Select **"Push to Repository"**
4. Click **"Connect GitHub Account"**
5. Authorize FlutterFlow to access your GitHub account
6. Select repository: `JackL0423/CSCSoftwareDevelopment`
7. Choose target branch:
   - **Recommended**: `flutterflow-export` (for PR workflow)
   - **Alternative**: `main` (direct push, less safe)
8. Configure export settings:
   - ✅ Auto-generate code on save
   - ✅ Include custom code
   - ✅ Export to GitHub on publish
9. Click **"Save"**

### Daily Workflow: FlutterFlow to GitHub

#### Option A: Push from FlutterFlow UI (Recommended for Small Changes)

1. Make changes in FlutterFlow visual editor
2. Test in FlutterFlow preview
3. Click **Developer Menu** → **Push to Repository**
4. Add commit message
5. Click **"Push"**
6. Verify changes in GitHub (check the `flutterflow-export` branch)

#### Option B: Programmatic YAML Editing (For Batch Changes)

When you need to make repetitive changes or bulk updates:

```bash
# 1. Download all YAML files from FlutterFlow
./scripts/flutterflow/download-all-yamls-bulk.sh

# 2. Edit YAML files locally (e.g., update app state variables)
nano flutterflow-yamls/app-state.yaml

# 3. Validate changes
./scripts/flutterflow/validate-yaml.sh app-state flutterflow-yamls/app-state.yaml

# 4. Upload changes to FlutterFlow
./scripts/flutterflow/update-yaml.sh app-state flutterflow-yamls/app-state.yaml

# 5. Verify in FlutterFlow UI (always check!)
# Open https://app.flutterflow.io and verify your changes

# 6. Push to GitHub from FlutterFlow UI
# (Use Developer Menu → Push to Repository)
```

**Important**: After YAML edits, always:
- ✅ Verify changes in FlutterFlow UI
- ✅ Test in FlutterFlow preview
- ✅ Push to GitHub after verification

### Branch Strategy for FlutterFlow

We use a dedicated branch for FlutterFlow exports to maintain code review workflow:

```
main (protected)
  ↑
  └── flutterflow-export (auto-updated by FlutterFlow)
       ↑
       └── feature branches (manual development)
```

**Workflow**:
1. FlutterFlow pushes to `flutterflow-export` branch
2. GitHub Action creates PR to `main` automatically (see `.github/workflows/flutterflow-sync.yml`)
3. Team reviews PR for:
   - UI changes match FlutterFlow preview
   - No breaking changes in dependencies
   - Custom code integrations still work
4. Merge PR to `main` after approval

### Handling FlutterFlow + Manual Code Changes

**FlutterFlow manages**:
- Widget tree (UI structure)
- Navigation routes
- State management
- Theme configuration
- API integrations

**We manage manually**:
- Custom Dart actions (in `lib/custom_code/actions/`)
- Custom widgets (in `lib/custom_code/widgets/`)
- Firebase Cloud Functions (in `functions/`)
- Scripts and tooling (in `scripts/`)

**Conflict resolution**:
- If FlutterFlow export overwrites custom code:
  1. Check the PR diff carefully
  2. Restore custom code from git history: `git checkout main -- lib/custom_code/`
  3. Re-apply FlutterFlow changes selectively
  4. Update FlutterFlow to reference custom code correctly

### Troubleshooting FlutterFlow GitHub Integration

#### "Push to Repository" Button Grayed Out
- **Cause**: GitHub not linked in FlutterFlow settings
- **Fix**: Follow "Link GitHub Repository in FlutterFlow" steps above

#### Push Succeeds But Changes Don't Appear in GitHub
- **Cause**: Silent failure due to wrong format or permissions
- **Fix**:
  1. Check GitHub token hasn't expired
  2. Verify token has `repo` and `workflow` scopes
  3. Re-link GitHub repository in FlutterFlow UI
  4. Check branch exists in GitHub

#### YAML Upload Returns Success But Changes Don't Persist
- **Cause**: Known FlutterFlow API limitation for certain fields (e.g., DocumentReference collection targets)
- **Fix**: Make these changes in FlutterFlow UI instead of via API
- **Detection**: Use `~/.claude/skills/flutterflow-debugger/ffdbg verify` to detect silent failures

#### Rate Limiting or Timeout Errors
- **Cause**: Too many rapid API calls
- **Fix**: Add delays between operations, use bulk download instead of individual files

### FlutterFlow Resources

- **API Documentation**: See `docs/CLAUDE.md` for comprehensive FlutterFlow API guide
- **FlutterFlow Scripts**: `scripts/flutterflow/` directory
- **YAML Files**: `flutterflow-yamls/` (gitignored, download as needed)
- **GitHub Workflow**: `.github/workflows/flutterflow-sync.yml`

## Code Style (Keep It Clean!)

### Commit Messages

We try to use this format (helps keep things organized):

```
<type>: <what you did>
```

**Types**: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

**Examples**:
- `feat: add email verification`
- `fix: resolve recipe image loading bug`
- `docs: update installation instructions`

Descriptive commit messages help maintain a clear project history.

### General Guidelines

- **Dart/Flutter**: Follow the official Flutter style guide
- **Shell Scripts**: Use ShellCheck for validation
- **Python**: Follow PEP 8 standards
- **JavaScript**: ESLint configuration is provided

### Documentation

- Update the README for user-facing changes
- Add comments for complex logic
- Include usage examples in scripts

### Documentation Attribution Standards

**Team Collaboration**: All documentation should reflect team collaboration, not individual authorship.

**Standard Header Format** for documentation files:
```markdown
**Team**: GlobalFlavors CSC305 Development Team
**Contributors**: Juan, Jack, Sophia, Maria, Alex
**AI-Assisted**: [Claude Code/GPT-5/None] (if applicable)
**Last Updated**: YYYY-MM-DD
```

**What to Avoid**:
- ❌ Individual "Author:" attributions (e.g., "Author: Juan Vallejo")
- ❌ Making up last names for team members
- ❌ "Generated by Claude Code" footers in active documentation

**Where AI Assistance is Appropriate**:
- ✅ Mention in header: `**AI-Assisted**: Claude Code`
- ✅ In git commit co-author: `Co-Authored-By: Claude <noreply@anthropic.com>`
- ✅ In experimental/archive docs (for context)

**Team Attribution Examples**:
```markdown
# Good Examples
**Team**: GlobalFlavors CSC305 Development Team
**Contributors**: Juan, Jack, Sophia, Maria, Alex

# Avoid
**Author**: Juan Vallejo (with AI assistance)
**Author**: Jack Light, Sophia Chen, Maria Garcia
```

**Rationale**: This is a team project. Documentation should reflect collaborative effort and avoid singling out individuals or fabricating information about team members.

## Testing

Please test new features before submitting. Testing commands:

```bash
# Flutter tests
flutter test

# Firebase Functions tests
cd functions && npm test
```

## Security - Important!

**Don't commit these**:
- API keys or tokens
- `.env` files
- Passwords or credentials
- Personal info

**Do this instead**:
- Use GCP Secret Manager (or environment variables)
- Run `gitleaks detect` before pushing
- Let the pre-commit hooks help you out

### Pre-commit Hooks

These hooks will save you from accidentally committing secrets:

```bash
pip install pre-commit
pre-commit install
```

The hooks automatically:
- Prevent commits of large files (>10MB)
- Scan for secrets using gitleaks
- Fix trailing whitespace
- Validate file formats

## Project Structure

Quick overview of where things are:

```
CSCSoftwareDevelopment/
├── docs/               # All our documentation
│   ├── architecture/   # How stuff works
│   ├── implementation/ # Implementation notes
│   ├── experiments/    # Things we tried
│   ├── guides/         # How-to guides
│   └── project/        # Project planning docs
├── scripts/            # Automation scripts
│   ├── flutterflow/    # FlutterFlow API stuff
│   ├── firebase/       # Firebase deployment
│   ├── testing/        # Testing helpers
│   └── utilities/      # Shared utilities
├── lib/                # Dart/Flutter code
├── functions/          # Firebase Cloud Functions
└── tools/              # Python/JS helper scripts
```

## Pull Requests

If you're on the team:
1. Make sure tests pass
2. Update docs if needed
3. Get someone to review it
4. Merge when approved

## Need Help?

- Check the `docs/` folder
- Look at `CLAUDE.md` for detailed project context
- Open an issue
- Ask the team!

## Code of Conduct

This project follows our code of conduct (see CODE_OF_CONDUCT.md). We ask all contributors to be respectful, collaborative, and professional.

## License

This project is licensed under the MIT License. By contributing, you agree that your contributions will be licensed under the same terms.

---

**Project Team**
Juan, Jack, Sophia, Maria, Alex
*CSC305 Software Development Capstone*
*University of Rhode Island, Fall 2025*
