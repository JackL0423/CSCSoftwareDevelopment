#!/usr/bin/env python3
"""
Sanitize PII from repository for public release.
Replaces emails, team lead references, and sensitive IDs.
"""

import re
import sys
from pathlib import Path

# Replacement mappings
REPLACEMENTS = {
    # Email addresses
    r'juan_vallejo@uri\.edu': '[REDACTED]@example.edu',
    r'juan\.vallejo@jpteq\.com': '[REDACTED]@example.com',

    # Team lead references (keep Jack Light as specified)
    r'(\*\*Team Lead\*\*:?\s*)Juan Vallejo': r'\1Jack Light',
    r'(\*\*Project Lead\*\*:?\s*)Juan Vallejo': r'\1Jack Light',
    r'(\*\*Scrum Master\*\*:?\s*)Juan Vallejo': r'\1Jack Light',
    r'(Team Lead:?\s*)Juan Vallejo': r'\1Jack Light',
    r'(Project Lead:?\s*)Juan Vallejo': r'\1Jack Light',

    # Git author references in documentation (keep for attribution with date)
    # r'Author:\s*Juan Vallejo': 'Author: [Developer]',

    # Contact/Email sections with names
    r'(\*\*Lead Developer\*\*:?\s*)Juan Vallejo': r'\1Jack Light',

    # Project IDs (from earlier analysis)
    r'c-s-c305-capstone-khj14l': '[FLUTTERFLOW_PROJECT_ID]',
    r'csc305project-475802': '[GCP_SECRETS_PROJECT_ID]',
    r'csc-305-dev-project': '[FIREBASE_PROJECT_ID]',
}

def sanitize_file(filepath):
    """Sanitize a single file."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        original_content = content

        # Apply all replacements
        for pattern, replacement in REPLACEMENTS.items():
            content = re.sub(pattern, replacement, content)

        if content != original_content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            return True
        return False

    except Exception as e:
        print(f"Error processing {filepath}: {e}", file=sys.stderr)
        return False

def main():
    """Main sanitization function."""
    # File patterns to process
    patterns = ['**/*.md', '**/*.txt', '**/*.yaml', '**/*.yml', '**/*.json']

    # Directories to exclude
    exclude_dirs = {'.git', 'node_modules', 'functions/node_modules', '.vscode'}

    files_changed = 0
    files_processed = 0

    for pattern in patterns:
        for filepath in Path('.').rglob(pattern):
            # Skip excluded directories
            if any(ex in filepath.parts for ex in exclude_dirs):
                continue

            files_processed += 1
            if sanitize_file(filepath):
                files_changed += 1
                print(f"✓ Sanitized: {filepath}")

    print(f"\nProcessed {files_processed} files, modified {files_changed} files")
    return 0

if __name__ == '__main__':
    sys.exit(main())
