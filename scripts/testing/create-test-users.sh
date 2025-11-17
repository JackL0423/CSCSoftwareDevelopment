#!/usr/bin/env bash
set -euo pipefail

# Create Firebase Auth test users via Admin SDK (Node.js)
# Requirements:
# - Node 18+
# - npm install in scripts/node (will be auto-run on first call)
# - GOOGLE_APPLICATION_CREDENTIALS env var pointing to a service account JSON with auth/admin perms
# - PROJECT_ID env (default: csc-305-dev-project)
#
# Usage:
#   scripts/create-test-users.sh --count 20 \
#     --email-prefix test_user_ \
#     --domain example.com \
#     --password 'TestPass123!'

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$DIR/.." && pwd)"
NODE_DIR="$ROOT/scripts/node"

COUNT=20
EMAIL_PREFIX="test_user_"
DOMAIN="example.com"
PASSWORD="TestPass123!"
PROJECT_ID="${PROJECT_ID:-csc-305-dev-project}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --count) COUNT="$2"; shift 2;;
    --email-prefix) EMAIL_PREFIX="$2"; shift 2;;
    --domain) DOMAIN="$2"; shift 2;;
    --password) PASSWORD="$2"; shift 2;;
    --project) PROJECT_ID="$2"; shift 2;;
    *) echo "Unknown arg: $1"; exit 2;;
  esac
done

if [[ -z "${GOOGLE_APPLICATION_CREDENTIALS:-}" || ! -f "$GOOGLE_APPLICATION_CREDENTIALS" ]]; then
  echo "Error: GOOGLE_APPLICATION_CREDENTIALS not set or file not found."
  echo "Export a service account JSON with Firebase Admin permissions."
  exit 1
fi

mkdir -p "$NODE_DIR"
if [[ ! -f "$NODE_DIR/package.json" ]]; then
  cat > "$NODE_DIR/package.json" <<'JSON'
{
  "name": "csc305-node-tools",
  "type": "module",
  "private": true,
  "dependencies": {
    "firebase-admin": "^12.5.0"
  }
}
JSON
fi

if [[ ! -d "$NODE_DIR/node_modules" ]]; then
  echo "Installing Node dependencies in $NODE_DIR ..."
  (cd "$NODE_DIR" && npm install --silent)
fi

cat > "$NODE_DIR/create_test_users.mjs" <<'MJS'
import fs from 'node:fs'
import path from 'node:path'
import admin from 'firebase-admin'

const {
  GOOGLE_APPLICATION_CREDENTIALS,
  PROJECT_ID = 'csc-305-dev-project',
  COUNT = '20',
  EMAIL_PREFIX = 'test_user_',
  DOMAIN = 'example.com',
  PASSWORD = 'TestPass123!'
} = process.env

if (!GOOGLE_APPLICATION_CREDENTIALS || !fs.existsSync(GOOGLE_APPLICATION_CREDENTIALS)) {
  console.error('GOOGLE_APPLICATION_CREDENTIALS not set or file missing')
  process.exit(1)
}

const creds = JSON.parse(fs.readFileSync(GOOGLE_APPLICATION_CREDENTIALS, 'utf8'))
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(creds),
    projectId: PROJECT_ID
  })
}

const auth = admin.auth()
const total = parseInt(COUNT, 10)

const users = []
for (let i = 1; i <= total; i++) {
  const num = String(i).padStart(3, '0')
  const email = `${EMAIL_PREFIX}${num}@${DOMAIN}`
  users.push({ email, password: PASSWORD, displayName: `Test User ${num}`, disabled: false })
}

const results = []
for (const u of users) {
  try {
    const existing = await auth.getUserByEmail(u.email).catch(() => null)
    if (existing && existing.uid) {
      results.push({ email: u.email, uid: existing.uid, created: false })
      continue
    }
    const userRecord = await auth.createUser(u)
    results.push({ email: u.email, uid: userRecord.uid, created: true })
    console.log(`Created: ${u.email} (${userRecord.uid})`)
  } catch (e) {
    console.error(`Error creating ${u.email}:`, e?.message || e)
  }
}

const outPath = path.join(process.cwd(), 'seeded_test_users.json')
fs.writeFileSync(outPath, JSON.stringify({ projectId: PROJECT_ID, users: results }, null, 2))
console.log(`\nWrote ${results.length} entries to ${outPath}`)
MJS

echo "Creating $COUNT users in project $PROJECT_ID ..."
PROJECT_ID="$PROJECT_ID" COUNT="$COUNT" EMAIL_PREFIX="$EMAIL_PREFIX" DOMAIN="$DOMAIN" PASSWORD="$PASSWORD" \
  node "$NODE_DIR/create_test_users.mjs"

echo "Done."
