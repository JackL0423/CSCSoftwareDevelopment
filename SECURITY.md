# Security

**Note**: This is an academic capstone project for CSC305 at the University of Rhode Island.

## Reporting a Security Issue

If you discover a security vulnerability in this project:

1. Please do not open a public issue
2. Contact the project maintainers directly via email or GitHub
3. Provide the following information:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested remediation (if available)

We aim to respond within a few days. Please note this is a student project developed as part of our coursework.

## What We're Doing for Security

We tried to follow good practices for this project:

- ✅ Using GCP Secret Manager (no passwords in the code)
- ✅ Cleaned up git history before making this public
- ✅ Setup pre-commit hooks to catch secrets before they're committed
- ✅ Added `.gitignore` for sensitive files
- ✅ Ran security scans with gitleaks

## Things to Know

- This is a **school project**, not production software
- If you fork this, you'll need your own FlutterFlow and Firebase accounts
- Don't commit API keys, tokens, or passwords (the hooks will try to stop you!)
- We sanitized the repo before public release, but still be careful

## Tools We Used

- **Gitleaks** - scans for accidentally committed secrets
- **Git LFS** - handles large binary files
- **Pre-commit hooks** - automated checks before commits
- **GCP Secret Manager** - stores our API tokens safely

## Acknowledgments

Thank you for helping keep this project secure. Responsible disclosure is appreciated.

---

**Project Team**
Juan Vallejo, Jack Light, Maria, Alex, Sofia
*CSC305 Software Development Capstone*
*University of Rhode Island, Fall 2025*
