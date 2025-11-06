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
Juan Vallejo, Jack Light, Maria, Alex, Sofia
*CSC305 Software Development Capstone*
*University of Rhode Island, Fall 2025*
