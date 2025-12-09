# GlobalFlavors - CSC305 Capstone Project

**Course**: CSC305 Software Development Capstone  
**Institution**: University of Rhode Island  
**Semester**: Fall 2025

---

## Project Overview

GlobalFlavors is a FlutterFlow web application that also works on mobile, designed to solve the cooking dinner problem. The app helps users discover recipes based on ingredients available in their area and items they already have on hand.

**Team Members**:
- Juan Vallejo
- Jack Light
- Maria de la Soledad Millington
- Sophia Della Selva
- Alexander Hang

---

## Key Features

- **Recipe Search by Available Ingredients**: Search for recipes using ingredients you already have
- **Location-Based Ingredient Availability**: Find recipes based on ingredients available in your local area
- **Cross-Platform**: Works as both web app and mobile application

---

## Repository Contents

This repository contains **all project deliverables and documentation** for the CSC305 capstone course:

- **Backend Infrastructure**: Firebase Cloud Functions for D7 retention tracking and user management
- **Project Documentation**: Business plan, user research, personas, test cases, and changelog
- **Configuration**: Firebase rules, environment configs, and deployment settings
- **Project Assets**: Images, diagrams, and visual materials

---

## Repository Structure

```
CSCSoftwareDevelopment/
├── functions/          # D7 Retention Tracking Cloud Functions
├── firebase/           # Firebase configuration and FlutterFlow functions
├── config/             # Environment and Firebase configurations
├── docs/               # All project documentation and deliverables
└── images/             # Project images and assets
```

---

## Quick Start

### Deploy Cloud Functions

```bash
cd functions
npm install
firebase deploy --only functions
```

### Deploy Firebase Configuration

```bash
firebase deploy --only firestore:rules,firestore:indexes,storage
```

---

## Documentation

All project documentation is in the `docs/` directory:

- **BUSINESSPLAN.md** - Business plan and strategy
- **PERSONAS.md** - User personas
- **UserResearch.md** - User research findings
- **TESTCASES.md** - Test cases
- **CHANGELOG.md** - Project version history
- **METRICS.md** - Success metrics

See `docs/README.md` for complete documentation index.

---

## Tech Stack

- **Frontend**: FlutterFlow (Flutter)
- **Backend**: Firebase Cloud Functions (Node.js 20)
- **Database**: Firestore
- **Authentication**: Firebase Auth

---

## Resources

- **Firebase Console**: https://console.firebase.google.com/project/[PROJECT_ID]
- **GCP Console**: https://console.cloud.google.com

---

**Note**: The frontend Flutter application code is maintained in a separate repository. This repository focuses on backend infrastructure, configuration, and all project deliverables.
