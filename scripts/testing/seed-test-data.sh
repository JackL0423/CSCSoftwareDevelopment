#!/usr/bin/env bash
set -euo pipefail

# Seed Firestore with synthetic users, sessions, and recipe completions for retention testing.
# Uses Firebase Admin SDK via Node.js. Requires service account creds.
#
# Requirements:
# - GOOGLE_APPLICATION_CREDENTIALS pointing to a service account JSON (Editor + Firebase Admin perms)
# - Node 18+
# - jq installed (for reporting)
#
# Usage:
#   scripts/seed-test-data.sh \
#     --users 20 \
#     --days 7 \
#     --project csc-305-dev-project \
#     --distribution "70:20:10" # no-repeat:repeat:power

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$DIR/.." && pwd)"
NODE_DIR="$ROOT/scripts/node"

USERS=20
DAYS=7
PROJECT_ID="${PROJECT_ID:-csc-305-dev-project}"
DIST="70:20:10"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --users) USERS="$2"; shift 2;;
    --days|--cohort-days) DAYS="$2"; shift 2;;
    --project) PROJECT_ID="$2"; shift 2;;
    --distribution) DIST="$2"; shift 2;;
    *) echo "Unknown arg: $1"; exit 2;;
  esac
done

if [[ -z "${GOOGLE_APPLICATION_CREDENTIALS:-}" || ! -f "$GOOGLE_APPLICATION_CREDENTIALS" ]]; then
  echo "Error: GOOGLE_APPLICATION_CREDENTIALS not set or file not found."
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

cat > "$NODE_DIR/seed_test_data.mjs" <<'MJS'
import fs from 'node:fs'
import admin from 'firebase-admin'

const {
  GOOGLE_APPLICATION_CREDENTIALS,
  PROJECT_ID = 'csc-305-dev-project',
  USERS = '20',
  DAYS = '7',
  DIST = '70:20:10'
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

const db = admin.firestore()
const Timestamp = admin.firestore.Timestamp

const totalUsers = parseInt(USERS, 10)
const cohortDays = parseInt(DAYS, 10)
const [noRepeatPct, repeatPct, powerPct] = DIST.split(':').map(x => parseInt(x, 10))

function chance(pct) { return Math.random() * 100 < pct }

function fmtDate(d) {
  return `${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,'0')}-${String(d.getDate()).padStart(2,'0')}`
}

const now = new Date()
const created = { users: 0, completions: 0 }

for (let i = 1; i <= totalUsers; i++) {
  const uid = `test_seed_user_${String(i).padStart(3,'0')}`

  const firstDate = new Date(now)
  firstDate.setDate(firstDate.getDate() - Math.floor(Math.random() * cohortDays))
  const cohort_date = fmtDate(firstDate)

  // user doc
  await db.collection('users').doc(uid).set({
    d7_retention_eligible: true,
    cohort_date,
    timezone: 'UTC+00:00',
    total_recipes_completed: 0
  }, { merge: true })
  created.users++

  // decide scenario
  let scenario = 'none'
  const roll = Math.random() * 100
  if (roll < noRepeatPct) scenario = 'none'
  else if (roll < noRepeatPct + repeatPct) scenario = 'repeat'
  else scenario = 'power'

  // always at least one completion on D0 to set cohort
  const d0 = new Date(firstDate)
  d0.setHours(12,0,0,0)

  const baseCompletion = {
    user_id: uid,
    recipe_id: `recipe_${Math.floor(Math.random()*1000)}`,
    recipe_name: 'Seeded Recipe',
    completed_at: Timestamp.fromDate(d0),
    is_first_recipe: true,
    cuisine: 'seed',
    prep_time_bucket: '0-30min',
    prep_time_minutes: 20,
    source: 'seed',
    session_id: `seed_session_${uid}`,
    user_timezone: 'UTC+00:00',
    completion_method: 'seed',
    cohort_date
  }
  await db.collection('user_recipe_completions').add(baseCompletion)
  await db.collection('users').doc(uid).set({
    first_recipe_completed_at: Timestamp.fromDate(d0),
    total_recipes_completed: admin.firestore.FieldValue.increment(1)
  }, { merge: true })
  created.completions++

  const extraDays = scenario === 'none' ? []
    : scenario === 'repeat' ? [Math.floor(1 + Math.random()*6)]
    : [1, 3, 6]

  for (const add of extraDays) {
    const d = new Date(d0)
    d.setDate(d0.getDate() + add)
    d.setHours(18,0,0,0)
    await db.collection('user_recipe_completions').add({
      ...baseCompletion,
      recipe_id: `recipe_${Math.floor(Math.random()*1000)}`,
      is_first_recipe: false,
      completed_at: Timestamp.fromDate(d)
    })
    await db.collection('users').doc(uid).set({
      total_recipes_completed: admin.firestore.FieldValue.increment(1),
      last_recipe_completed_at: Timestamp.fromDate(d)
    }, { merge: true })
    created.completions++
  }
}

console.log(JSON.stringify({ projectId: PROJECT_ID, seeded: created }, null, 2))
MJS

echo "Seeding $USERS users over $DAYS days into $PROJECT_ID ..."
PROJECT_ID="$PROJECT_ID" USERS="$USERS" DAYS="$DAYS" DIST="$DIST" \
  node "$NODE_DIR/seed_test_data.mjs"

echo "Seed complete."
