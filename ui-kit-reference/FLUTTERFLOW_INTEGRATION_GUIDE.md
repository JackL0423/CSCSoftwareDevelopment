# GlobalFlavors UI Kit → FlutterFlow Integration Guide

**Version:** 1.0.0
**Date:** 2025-10-21
**Purpose:** Use React UI Kit as design reference for FlutterFlow development

---

## Overview

This directory contains a **React-based UI kit** generated from Figma AI, implementing the GlobalFlavors design system with Material 3 principles. While FlutterFlow cannot directly import React code, this kit serves as your **single source of truth** for:

1. **Visual Reference** - See exact implementations of each page
2. **Design System** - Material 3 color tokens, spacing, typography
3. **Component Specifications** - Detailed styling for Flutter widgets
4. **Interaction Patterns** - User flows and state management

---

## What's Included

### 📄 Documentation (`/docs`)
- **`MATERIAL3_INTEGRATION.md`** - Complete Material 3 design system guide
  - Color palette with exact hex codes
  - Typography scale
  - Border radius specifications
  - Elevation system (tonal surfaces vs shadows)
  - Component styling guidelines
  - Dark mode support

- **`Guidelines.md`** - Design system guidelines and best practices

- **`Attributions.md`** - Credits for shadcn/ui and Unsplash photos

### 🎨 Components (`/components`)
Complete page implementations in React (use as visual reference):

| Page | File | Purpose |
|------|------|---------|
| **Landing** | `LandingPage.tsx` | Hero, features, CTA sections |
| **Login** | `LoginPage.tsx` | Email/password + social auth |
| **Signup** | `SignupPage.tsx` | Registration with validation |
| **Onboarding** | `OnboardingPage.tsx` | Multi-step preference selection |
| **Dashboard** | `DashboardPage.tsx` | Recipe feed with filters |

### 🎭 Styles (`/styles`)
- **`globals.css`** - CSS custom properties with Material 3 tokens
  - All color values as CSS variables
  - Direct mapping to design tokens
  - Dark mode theme included

---

## How to Use with FlutterFlow

### Step 1: Import Design System to FlutterFlow

#### Connect Figma (Colors & Typography Only)

1. **In FlutterFlow:**
   ```
   Theme Settings → Design System → Connect To Figma
   ```

2. **Authenticate with Figma** and paste your Figma file URL

3. **Map Colors:**
   FlutterFlow will import all Figma colors. Map them using this reference:

   | Figma Color Name | FlutterFlow Theme Color | Hex Value | Usage |
   |------------------|-------------------------|-----------|-------|
   | Primary | Primary | `#D81B60` | Main buttons, links |
   | On Primary | Text on Primary | `#FFFFFF` | Text on pink backgrounds |
   | Primary Container | Primary Light | `#FFD7E5` | Light pink containers |
   | Secondary | Secondary | `#7B5264` | Supporting elements |
   | Tertiary | Tertiary | `#815343` | Accent elements |
   | Error | Error | `#BA1A1A` | Error states |
   | Surface Container Low | Card Background | `#FFF4F9` | Card backgrounds |
   | Outline | Border Color | `#857377` | Borders, dividers |

4. **Import Typography:**
   - Roboto font (already in Material 3)
   - Map text styles to FlutterFlow's type scale

#### Manually Configure Design Tokens

Since FlutterFlow only imports colors/typography, configure these manually:

**Border Radius** (Theme Settings → Widgets):
```
Extra Small: 4
Small: 8
Medium: 12
Large: 16
Extra Large: 28
Full: 9999
```

**Spacing** (use 8dp grid):
```
XS: 4
S: 8
M: 16
L: 24
XL: 32
2XL: 48
```

---

### Step 2: Recreate Pages in FlutterFlow

For each page, use the React component file as a **visual and structural reference**.

#### Example: Login Page Migration

**Reference File:** `components/LoginPage.tsx`

**FlutterFlow Implementation:**

1. **Create New Page:** "LoginPage"

2. **Page Structure (from React → Flutter):**

   ```tsx
   // REACT (Reference)
   <div className="bg-surface-container-low rounded-[28px] p-6">
     <h2 className="text-2xl font-semibold text-on-surface">Welcome back!</h2>
     ...
   </div>
   ```

   ```dart
   // FLUTTER (FlutterFlow)
   Container(
     decoration: BoxDecoration(
       color: theme.colorScheme.surfaceContainerLow, // #FFF4F9
       borderRadius: BorderRadius.circular(28),
     ),
     padding: EdgeInsets.all(24),
     child: Column(
       children: [
         Text(
           'Welcome back!',
           style: theme.textTheme.headlineMedium, // 28sp
         ),
         ...
       ],
     ),
   )
   ```

3. **Component Mapping:**

   | React Component | FlutterFlow Widget | Configuration |
   |-----------------|-------------------|---------------|
   | `<Input />` | TextFormField | Border radius: 12, Height: 56, Background: Surface Container Highest |
   | `<Button className="bg-primary">` | ElevatedButton | Background: Primary (#D81B60), Radius: Full (9999) |
   | `<Button variant="outline">` | OutlinedButton | Border: Outline (#857377), Radius: Full |
   | `<Card>` | Container | Background: Surface Container Low, Border Radius: 28 |
   | `<Badge>` | Container | Background: Primary Container, Radius: Full, Padding: 8x16 |

4. **Layout (Auto Layout):**

   From React (Flexbox):
   ```tsx
   <div className="flex flex-col gap-4">
     <Input />
     <Input />
     <Button />
   </div>
   ```

   To Flutter (Column):
   ```
   Add Column
   ├── Spacing: 16 (M)
   ├── Add TextFormField (Email)
   ├── Add TextFormField (Password)
   └── Add ElevatedButton (Login)
   ```

5. **States & Validation:**

   React code shows validation logic - implement in FlutterFlow:
   - Email validation: `RegExp` for email format
   - Password visibility toggle: State variable `passwordVisible`
   - Form validation: Required field checks
   - Loading state: Show CircularProgressIndicator

---

### Step 3: Apply Material 3 Styling

#### Color Usage Patterns

Reference `docs/MATERIAL3_INTEGRATION.md` for exact implementations:

**Primary Actions:**
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFFD81B60), // Primary
    foregroundColor: Color(0xFFFFFFFF), // On Primary
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(9999), // Full radius
    ),
    elevation: 2,
  ),
  child: Text('Get Started'),
)
```

**Cards (Tonal Elevation):**
```dart
Container(
  decoration: BoxDecoration(
    color: Color(0xFFFFF4F9), // Surface Container Low
    borderRadius: BorderRadius.circular(28), // Extra Large
    border: Border.all(
      color: Color(0xFFD7C2C7), // Outline Variant
      width: 1,
    ),
  ),
)
```

**Input Fields:**
```dart
TextFormField(
  decoration: InputDecoration(
    filled: true,
    fillColor: Color(0xFFF1E3E9), // Surface Container Highest
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12), // Medium
      borderSide: BorderSide(color: Color(0xFF857377)), // Outline
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Color(0xFFD81B60), // Primary
        width: 2,
      ),
    ),
  ),
)
```

---

### Step 4: Implement Interactions

#### State Management (from AuthContext.tsx)

React uses `AuthContext` for user state. In FlutterFlow:

1. **Create App State Variables:**
   ```
   isLoggedIn: bool (default: false)
   currentUser: JSON (user data)
   authToken: String
   ```

2. **Firebase Authentication Integration:**
   - Enable Firebase Auth in FlutterFlow
   - Use built-in Auth actions (Login, Signup, Logout)
   - Update app state variables on auth changes

#### Page Navigation

React Router paths → FlutterFlow Navigation:

| React Route | FlutterFlow Page | Transition |
|-------------|------------------|------------|
| `/` | LandingPage | Initial |
| `/login` | LoginPage | Slide from right |
| `/signup` | SignupPage | Slide from right |
| `/onboarding` | OnboardingPage | Fade |
| `/dashboard` | DashboardPage | Replace |

**Protected Routes:**
In FlutterFlow, add "onPageLoad" action:
```
If (appState.isLoggedIn == false) {
  Navigate to: LoginPage
}
```

---

### Step 5: Testing Checklist

Use this to verify FlutterFlow implementation matches React UI kit:

#### Visual Consistency
- [ ] Primary color matches: `#D81B60`
- [ ] Card border radius: `28dp`
- [ ] Button border radius: `9999dp` (pill shape)
- [ ] Input border radius: `12dp`
- [ ] Spacing follows 8dp grid (8, 16, 24, 32)
- [ ] Typography matches Roboto scale
- [ ] Surface colors use tonal elevation (not shadows)

#### Component Specifications
- [ ] Primary buttons: Filled, #D81B60 background, white text
- [ ] Secondary buttons: Outlined, #857377 border, transparent
- [ ] Inputs: 56dp height, #F1E3E9 background
- [ ] Cards: #FFF4F9 background, #D7C2C7 border
- [ ] Error states: #BA1A1A color

#### Interactions
- [ ] Form validation works (email format, required fields)
- [ ] Password visibility toggle functional
- [ ] Loading states show progress indicators
- [ ] Navigation flows match React routes
- [ ] Protected routes redirect to login

#### Accessibility
- [ ] All buttons have 48dp minimum touch target
- [ ] Color contrast ≥ 4.5:1 (WCAG AA)
- [ ] Focus indicators visible
- [ ] Screen reader labels present

---

## Quick Reference Tables

### Color Palette (Material 3)

```dart
// Copy these exact hex codes into FlutterFlow theme
const Color primary = Color(0xFFD81B60);
const Color onPrimary = Color(0xFFFFFFFF);
const Color primaryContainer = Color(0xFFFFD7E5);
const Color onPrimaryContainer = Color(0xFF3E001D);

const Color secondary = Color(0xFF7B5264);
const Color onSecondary = Color(0xFFFFFFFF);
const Color secondaryContainer = Color(0xFFFFD9E4);
const Color onSecondaryContainer = Color(0xFF301120);

const Color tertiary = Color(0xFF815343);
const Color onTertiary = Color(0xFFFFFFFF);
const Color tertiaryContainer = Color(0xFFFFDBD0);
const Color onTertiaryContainer = Color(0xFF321207);

const Color error = Color(0xFFBA1A1A);
const Color errorContainer = Color(0xFFFFDAD6);

const Color surface = Color(0xFFFFFBFF);
const Color surfaceContainerLowest = Color(0xFFFFFFFF);
const Color surfaceContainerLow = Color(0xFFFFF4F9);
const Color surfaceContainer = Color(0xFFFCEEF4);
const Color surfaceContainerHigh = Color(0xFFF6E8EF);
const Color surfaceContainerHighest = Color(0xFFF1E3E9);

const Color outline = Color(0xFF857377);
const Color outlineVariant = Color(0xFFD7C2C7);
```

### Typography Scale (Roboto)

| Style | Size | Weight | Line Height | Usage |
|-------|------|--------|-------------|-------|
| Display Large | 57sp | Light (300) | 64sp | Hero text |
| Display Medium | 45sp | Regular (400) | 52sp | Page heroes |
| Headline Large | 32sp | Regular (400) | 40sp | Page titles |
| Headline Medium | 28sp | Regular (400) | 36sp | Section headers |
| Title Large | 22sp | Medium (500) | 28sp | Card titles |
| Title Medium | 16sp | Medium (500) | 24sp | List titles |
| Body Large | 16sp | Regular (400) | 24sp | Primary text |
| Body Medium | 14sp | Regular (400) | 20sp | Secondary text |
| Label Large | 14sp | Medium (500) | 20sp | Button text |
| Label Medium | 12sp | Medium (500) | 16sp | Input labels |

### Spacing Grid (8dp Base)

| Token | Value | Usage |
|-------|-------|-------|
| XS | 4dp | Icon padding, tight spacing |
| S | 8dp | Component internal spacing |
| M | 16dp | Default element spacing |
| L | 24dp | Section spacing |
| XL | 32dp | Major section breaks |
| 2XL | 48dp | Page-level spacing |

---

## Common Patterns

### Pattern 1: Material 3 Button

**React Reference:**
```tsx
<Button className="bg-primary text-on-primary hover:bg-primary/90 rounded-full shadow-md">
  Get Started
</Button>
```

**FlutterFlow Implementation:**
1. Add ElevatedButton
2. Style:
   - Background: Primary (#D81B60)
   - Text Color: White
   - Border Radius: 9999 (full)
   - Elevation: 2
   - Height: 48dp
   - Padding: 24dp horizontal

---

### Pattern 2: Material 3 Card

**React Reference:**
```tsx
<div className="bg-surface-container-low rounded-[28px] p-6 border border-outline-variant">
  <h3>Card Title</h3>
  <p>Card content</p>
</div>
```

**FlutterFlow Implementation:**
1. Add Container
2. Style:
   - Background: Surface Container Low (#FFF4F9)
   - Border Radius: 28dp
   - Border: 1dp, Outline Variant (#D7C2C7)
   - Padding: 24dp
3. Add Column inside with:
   - Title (Title Large, On Surface)
   - Body text (Body Medium, On Surface Variant)

---

### Pattern 3: Material 3 Input

**React Reference:**
```tsx
<Input
  className="rounded-[12px] bg-surface-container-highest border-outline"
  placeholder="Email"
/>
```

**FlutterFlow Implementation:**
1. Add TextFormField
2. Style:
   - Fill Color: Surface Container Highest (#F1E3E9)
   - Border Radius: 12dp
   - Border Color: Outline (#857377)
   - Focused Border: Primary (#D81B60), 2dp
   - Height: 56dp
   - Padding: 16dp

---

## Troubleshooting

### Issue: Colors Don't Match

**Solution:** Double-check hex values in FlutterFlow theme. Use color picker with exact codes from `styles/globals.css`.

### Issue: Cards Look Flat

**Solution:** Material 3 uses **tonal elevation** (surface container colors) instead of shadows. Use Surface Container Low (#FFF4F9) instead of white with shadow.

### Issue: Border Radius Too Small

**Solution:** Material 3 uses **larger radii**. Cards should be 28dp, not 12dp or 16dp.

### Issue: Spacing Feels Off

**Solution:** Stick to **8dp grid**. Use 16dp (M) for most element spacing, 24dp (L) for sections.

---

## Resources

### Internal
- **Design Tokens:** `/design/DESIGN_TOKENS.json`
- **Figma Blueprint:** `/design/FIGMA_AI_BLUEPRINT.md`
- **Project Config:** `/config/project-config.json`

### External
- [Material 3 Guidelines](https://m3.material.io/)
- [Material 3 Design Kit (Figma)](https://www.figma.com/community/file/1035203688168086460)
- [FlutterFlow Documentation](https://docs.flutterflow.io/)
- [Flutter Material 3](https://docs.flutter.dev/ui/design/material)

---

## Maintenance

### Updating Design System

If you modify the React UI kit:

1. **Update React components** in `/components`
2. **Document changes** in `docs/MATERIAL3_INTEGRATION.md`
3. **Update design tokens** in `/design/DESIGN_TOKENS.json`
4. **Rebuild in FlutterFlow** using updated references
5. **Commit changes** with descriptive message

### Syncing with Figma

If Figma designs change:

1. **Update React UI kit** from Figma AI
2. **Re-export components** to this directory
3. **Check color values** in `styles/globals.css`
4. **Update FlutterFlow theme** if colors changed
5. **Test all pages** for visual consistency

---

## Support

**Questions about:**
- Material 3 implementation → Check `docs/MATERIAL3_INTEGRATION.md`
- React component structure → Read component files in `/components`
- Design tokens → Reference `/design/DESIGN_TOKENS.json`
- FlutterFlow setup → See this guide

**Team Contact:** uricsc305@gmail.com

---

**Last Updated:** 2025-10-21
**Maintained By:** GlobalFlavors Development Team
**UI Kit Version:** 1.0.0
**Design System:** Material 3 (Material You)
