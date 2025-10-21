# Figma API Integration Guide

**Project:** GlobalFlavors
**Date:** 2025-10-20
**Branch:** JUAN-SIDE-BRANCH

---

## Overview

This guide explains what you can accomplish with the Figma API and how to integrate Figma designs into your FlutterFlow project.

## Figma API Capabilities

### ✅ Available with Personal Access Token (What You Have)

#### 1. **Get File Metadata**
```bash
curl -H "Authorization: Bearer $FIGMA_API_KEY" \
  "https://api.figma.com/v1/files/$FIGMA_FILE_ID"
```

**Returns:**
- File name, version, last modified date
- Document structure (pages, frames, components)
- Thumbnail URLs
- All design elements and their properties

**Use Case:** Understand file structure before exporting specific components

---

#### 2. **Get Specific Nodes/Components**
```bash
curl -H "Authorization: Bearer $FIGMA_API_KEY" \
  "https://api.figma.com/v1/files/$FIGMA_FILE_ID/nodes?ids=1:2,1:3"
```

**Returns:**
- Properties of specific frames/components
- Layout information (constraints, auto-layout)
- Fill colors, stroke styles, effects
- Text styles and font information

**Use Case:** Extract specific UI components for FlutterFlow implementation

---

#### 3. **Export Images (PNG, JPG, SVG, PDF)**
```bash
curl -H "Authorization: Bearer $FIGMA_API_KEY" \
  "https://api.figma.com/v1/images/$FIGMA_FILE_ID?ids=1:2&format=svg&scale=2"
```

**Parameters:**
- `format`: png, jpg, svg, pdf
- `scale`: 0.01 to 4 (for raster images)
- `svg_include_id`: true/false
- `svg_simplify_stroke`: true/false

**Use Case:** Export icons, illustrations, and assets for FlutterFlow

---

#### 4. **Get Component Sets**
```bash
curl -H "Authorization: Bearer $FIGMA_API_KEY" \
  "https://api.figma.com/v1/files/$FIGMA_FILE_ID/components"
```

**Returns:**
- All components in the file
- Component metadata (name, description, key)
- Component sets (variants)

**Use Case:** Identify reusable UI components from Material 3 Design Kit

---

#### 5. **Get Styles**
```bash
curl -H "Authorization: Bearer $FIGMA_API_KEY" \
  "https://api.figma.com/v1/files/$FIGMA_FILE_ID/styles"
```

**Returns:**
- Color styles
- Text styles (typography)
- Effect styles (shadows, blurs)
- Grid styles

**Use Case:** Extract design tokens for consistent FlutterFlow theming

---

#### 6. **Comments API**
```bash
# Get comments
curl -H "Authorization: Bearer $FIGMA_API_KEY" \
  "https://api.figma.com/v1/files/$FIGMA_FILE_ID/comments"

# Post comment
curl -X POST -H "Authorization: Bearer $FIGMA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"message":"Approved for development","client_meta":{"x":100,"y":200}}' \
  "https://api.figma.com/v1/files/$FIGMA_FILE_ID/comments"
```

**Use Case:** Team collaboration and design review workflow

---

### ❌ Requires Figma Enterprise Plan (Not Available)

- **Variables API** (Design Tokens): Get/modify Figma variables
- **Dev Mode API**: Access dev-specific annotations
- **Library Publishing**: Programmatically publish shared libraries
- **Branch Management**: Create/manage Figma branches via API

---

## Figma → FlutterFlow Workflow

### Option 1: Manual Import (Recommended for V1)

**Best for:** Getting started quickly, learning FlutterFlow

1. **Design in Figma** using Material 3 Design Kit
2. **Export assets** manually:
   - Icons: SVG format
   - Images: PNG format (2x or 3x scale)
   - Illustrations: SVG or PNG
3. **Upload to FlutterFlow**:
   - Assets → Upload Files
   - Reference in widgets
4. **Manually recreate layouts** in FlutterFlow:
   - Use Figma as visual reference
   - Build widgets matching design
   - Apply Material 3 theme colors

**Pros:**
- Full control over implementation
- Learn FlutterFlow widget system
- No API complexity

**Cons:**
- Time-intensive
- Manual synchronization required
- Prone to design drift

---

### Option 2: API-Assisted Workflow (For Phase 2)

**Best for:** Automation, scaling to multiple pages

#### Step 1: Extract Design Tokens
```javascript
// Script to extract colors from Figma styles
const fetch = require('node-fetch');

async function extractColors() {
  const response = await fetch(
    `https://api.figma.com/v1/files/${FIGMA_FILE_ID}/styles`,
    { headers: { 'X-Figma-Token': FIGMA_API_KEY } }
  );

  const data = await response.json();

  // Extract color styles
  const colors = data.meta.styles
    .filter(style => style.style_type === 'FILL')
    .map(style => ({
      name: style.name,
      key: style.key,
      // Fetch actual color values from nodes
    }));

  return colors;
}
```

#### Step 2: Export Component Assets
```bash
# Get all button components
curl -H "Authorization: Bearer $FIGMA_API_KEY" \
  "https://api.figma.com/v1/files/$FIGMA_FILE_ID/components" \
  | jq '.meta.components[] | select(.name | contains("Button"))'

# Export button states as images
curl -H "Authorization: Bearer $FIGMA_API_KEY" \
  "https://api.figma.com/v1/images/$FIGMA_FILE_ID?ids=NODE_ID_1,NODE_ID_2&format=png&scale=3"
```

#### Step 3: Generate FlutterFlow-Compatible JSON
```javascript
// Convert Figma design to FlutterFlow widget structure
{
  "widgetType": "Container",
  "properties": {
    "width": 360,
    "height": 48,
    "backgroundColor": "#FF4081",
    "borderRadius": 8,
    "child": {
      "widgetType": "Text",
      "properties": {
        "text": "Login",
        "fontSize": 16,
        "fontWeight": "bold",
        "color": "#FFFFFF"
      }
    }
  }
}
```

---

### Option 3: Figma-to-Code Plugins (Third-Party)

**Available Tools:**

1. **DhiWise** (Figma → Flutter)
   - Converts Figma designs to Flutter code
   - Generates responsive layouts
   - Free tier available
   - Can export code for FlutterFlow import

2. **Bravo Studio** (Figma → App)
   - No-code Figma to mobile app
   - Limited compared to FlutterFlow

3. **Anima** (Figma → Code)
   - Exports to React, Vue, HTML
   - Not Flutter-specific

---

## Recommended Workflow for GlobalFlavors

### Phase 1: Authentication Flow (Current)

**Week 1: Figma Design**
1. Create 5 authentication pages in Figma using Material 3 Kit:
   - Splash Screen
   - Login
   - Sign Up
   - Forgot Password
   - Email Verification

2. Use consistent spacing system:
   - Padding: 16px, 24px, 32px
   - Gaps: 8px, 12px, 16px
   - Corner radius: 8px, 12px, 16px

3. Export assets via API:
```bash
# Export app logo
curl -H "Authorization: Bearer $FIGMA_API_KEY" \
  "https://api.figma.com/v1/images/$FIGMA_FILE_ID?ids=LOGO_NODE_ID&format=png&scale=3" \
  -o assets/logo@3x.png

# Export social login icons (Google, Apple)
curl -H "Authorization: Bearer $FIGMA_API_KEY" \
  "https://api.figma.com/v1/images/$FIGMA_FILE_ID?ids=GOOGLE_ICON,APPLE_ICON&format=svg" \
  -o assets/icons.json
```

**Week 2: FlutterFlow Implementation**
1. Create pages in FlutterFlow matching Figma designs
2. Upload exported assets
3. Apply Material 3 theme:
   - Primary color: #FF4081
   - Text styles from Figma
   - Consistent spacing

---

### Phase 2: Discovery & Recipe Pages

**Use API-Assisted Workflow:**
1. Design 10+ pages in Figma
2. Use script to batch-export all assets
3. Generate design token JSON
4. Import into FlutterFlow theme

**Example Script:**
```bash
#!/bin/bash
# extract-figma-assets.sh

FIGMA_FILE_ID="YOUR_FILE_ID"
FIGMA_API_KEY="$(gcloud secrets versions access latest --secret=FIGMA_API_KEY)"

# Get all frames on "Mobile Screens" page
FRAMES=$(curl -s -H "Authorization: Bearer $FIGMA_API_KEY" \
  "https://api.figma.com/v1/files/$FIGMA_FILE_ID" \
  | jq -r '.document.children[] | select(.name=="Mobile Screens") | .children[] | .id')

# Export each frame as PNG
for FRAME_ID in $FRAMES; do
  echo "Exporting frame: $FRAME_ID"
  curl -H "Authorization: Bearer $FIGMA_API_KEY" \
    "https://api.figma.com/v1/images/$FIGMA_FILE_ID?ids=$FRAME_ID&format=png&scale=2" \
    -o "exports/$FRAME_ID.png"
done
```

---

## Integration with FlutterFlow

### Current State
- **FlutterFlow Project ID:** `c-s-c305-capstone-khj14l`
- **Branch:** Must manually create "JUAN-SIDE-BRANCH" in FlutterFlow UI
- **Figma File:** Not yet configured (need File ID)

### Setup Steps

#### 1. Get Your Figma File ID
```bash
# List your recent files
curl -H "Authorization: Bearer $FIGMA_API_KEY" \
  "https://api.figma.com/v1/me/files/recent"
```

The File ID is in the Figma URL:
```
https://www.figma.com/file/ABC123DEF456/GlobalFlavors-Design
                              ^^^^^^^^^^^^
                              This is your File ID
```

#### 2. Store Figma File ID in Secret Manager
```bash
echo -n "YOUR_FIGMA_FILE_ID" | \
  /home/j-p-v/google-cloud-sdk/bin/gcloud secrets create FIGMA_FILE_ID \
  --data-file=- \
  --replication-policy="automatic" \
  --project=csc305project-475802
```

#### 3. Create Figma Branch (Manual)
Since Figma API doesn't support branching on non-Enterprise plans:
1. In Figma, go to File → Branches
2. Create new branch: "JUAN-SIDE-BRANCH"
3. This keeps your work isolated from main designs

---

## Example: Complete Auth Page Export

### 1. Design Login Page in Figma
- Frame: 360x800 (Mobile)
- Components: Logo, Email input, Password input, Login button, Social buttons

### 2. Get Page Node ID
```bash
curl -H "Authorization: Bearer $FIGMA_API_KEY" \
  "https://api.figma.com/v1/files/$FIGMA_FILE_ID" \
  | jq '.document.children[] | select(.name=="Auth Flow") | .children[] | select(.name=="Login Page") | .id'
```

### 3. Export Page as Reference Image
```bash
curl -H "Authorization: Bearer $FIGMA_API_KEY" \
  "https://api.figma.com/v1/images/$FIGMA_FILE_ID?ids=LOGIN_PAGE_NODE_ID&format=png&scale=2" \
  -o reference/login-page@2x.png
```

### 4. Export Individual Assets
```bash
# Logo
curl -H "Authorization: Bearer $FIGMA_API_KEY" \
  "https://api.figma.com/v1/images/$FIGMA_FILE_ID?ids=LOGO_NODE_ID&format=png&scale=3"

# Google icon (SVG for crisp rendering)
curl -H "Authorization: Bearer $FIGMA_API_KEY" \
  "https://api.figma.com/v1/images/$FIGMA_FILE_ID?ids=GOOGLE_ICON_ID&format=svg"
```

### 5. Extract Colors for FlutterFlow Theme
```bash
curl -H "Authorization: Bearer $FIGMA_API_KEY" \
  "https://api.figma.com/v1/files/$FIGMA_FILE_ID/styles" \
  | jq '.meta.styles[] | select(.style_type=="FILL")' > colors.json
```

---

## Limitations & Workarounds

### Limitation 1: No Auto-Sync
**Problem:** Figma changes don't automatically update FlutterFlow
**Workaround:**
- Use Figma API webhooks (requires Enterprise)
- OR: Manual re-export when designs change
- OR: Version your exports (e.g., `login-v1.png`, `login-v2.png`)

### Limitation 2: No Design Tokens API
**Problem:** Can't programmatically access Figma Variables
**Workaround:**
- Use Styles API (colors, text) instead
- Export styles to JSON manually
- Use Figma Community plugins like "Design Tokens"

### Limitation 3: FlutterFlow No Import API
**Problem:** Can't programmatically create FlutterFlow pages from Figma
**Workaround:**
- Manual recreation in FlutterFlow UI
- Use Figma exports as visual reference
- Consider DhiWise for Flutter code generation, then import to FlutterFlow

---

## Best Practices

### 1. Naming Conventions
Use consistent naming in Figma for easy API access:
```
Auth Flow/
├── Login Page
├── Sign Up Page
├── Forgot Password Page
└── Email Verification Page

Components/
├── Button/Primary
├── Button/Secondary
├── Input/Text
└── Input/Password

Assets/
├── Logo/Primary
├── Icon/Google
└── Icon/Apple
```

### 2. Organize Figma Files
- **Page 1:** "Mobile Screens" - All mobile layouts
- **Page 2:** "Components" - Reusable components
- **Page 3:** "Assets" - Icons, illustrations, logos
- **Page 4:** "Styles" - Color palette, typography

### 3. Version Control
- Create Figma branches for major features
- Tag versions: "v1.0-auth-flow", "v1.1-discovery"
- Mirror git branch naming: "JUAN-SIDE-BRANCH"

---

## Next Steps

### Immediate (This Week)
1. [ ] Get Figma File ID from your design file
2. [ ] Store in Google Secret Manager
3. [ ] Update `config/project-config.json` with File ID
4. [ ] Create sample script to export first page

### Short-term (Next 2 Weeks)
1. [ ] Complete Phase 1 authentication designs in Figma
2. [ ] Export all auth page assets via API
3. [ ] Implement in FlutterFlow
4. [ ] Test Figma → FlutterFlow workflow

### Long-term (After MVP)
1. [ ] Automate asset export with CI/CD
2. [ ] Build design token generator
3. [ ] Explore DhiWise for code generation
4. [ ] Consider upgrading to Figma Enterprise for Variables API

---

## Security Reminders

⚠️ **IMPORTANT:**
- Never commit Figma API keys to git
- Use Google Secret Manager for all keys
- Rotate exposed key (see config/project-config.json security section)
- Check `.gitignore` includes: `figma-exports/`, `*.fig`

---

## Resources

- **Figma API Docs:** https://www.figma.com/developers/api
- **FlutterFlow Docs:** https://docs.flutterflow.io
- **Material 3 Design Kit:** https://www.figma.com/community/file/1035203688168086460
- **Team Personas:** `/docs/PERSONAS.md`
- **Business Plan:** `/docs/BUSINESSPLAN.md`

---

**Last Updated:** 2025-10-20
**Maintained By:** GlobalFlavors Team
**Questions?** Contact: uricsc305@gmail.com
