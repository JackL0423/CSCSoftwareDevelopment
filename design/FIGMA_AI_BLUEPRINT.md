# GlobalFlavors - Figma AI Design Blueprint
## Phase 1: Authentication Flow

**Version:** 1.0.0
**Date:** 2025-10-20
**Status:** Production-Ready Specification
**Designer:** AI-Assisted Design Generation
**Target Platform:** Mobile (iOS & Android)

---

## 📋 Table of Contents

1. [Project Context](#project-context)
2. [Brand Identity & Design System](#brand-identity--design-system)
3. [Page Specifications](#page-specifications)
4. [Figma AI Prompts](#figma-ai-prompts-ready-to-use)
5. [Export Specifications](#export-specifications)
6. [Quality Checklist](#quality-checklist)

---

## Project Context

### App Overview

**Name:** GlobalFlavors
**Tagline:** Discover authentic regional dishes you can cook tonight
**Value Proposition:** Culture-first browsing + local-ingredient substitutions + one-tap grocery checkout

### Target Users

**Primary:** Adults 20-40 in 1-2 person households seeking authentic, weeknight-friendly meals
**Secondary:** New immigrants and travelers recreating dishes from abroad
**Early Adopters:** Foodies already using Instacart or Walmart Online Grocery

### User Personas (5 Key Personas)

1. **App Administrator** - Manages content and user moderation
2. **Young College Student** - Budget-conscious, adventurous eater
3. **Highly Experienced Cook / Executive Chef** - Seeks authenticity and quality
4. **Young Person Abroad** - Recreating home dishes in new country
5. **Moderate Income Parent** - Quick, affordable, family-friendly meals

**Persona Details:** [View Full Personas](https://docs.google.com/presentation/d/1p-2E9KyCJyyXrYYOkEXYjQy3kDwluuwXIvFoiH2w5ZA)

### Design Goals for Authentication Flow

1. **Build Trust** - Professional, polished first impression
2. **Reduce Friction** - Minimal steps to get cooking
3. **Social Login Priority** - Google/Apple for fastest onboarding
4. **Cultural Sensitivity** - Inclusive, welcoming design language
5. **Mobile-First** - 360x800 base frame, responsive design

---

## Brand Identity & Design System

### Design Foundation

**Framework:** Material Design 3 (Material You)
**Platform:** Mobile-first (iOS & Android compatibility)
**Base Frame:** 360x800 (Mobile Portrait)
**Grid:** 8dp baseline grid
**Auto Layout:** All components must use Auto Layout

### Color Palette

#### Primary Colors
```
Primary: #FF4081 (Pink 400 - Vibrant, appetizing)
  - Light: #FF79B0
  - Dark: #C60055
  - Container: #FFD9E8

Secondary: #424242 (Grey 800 - Professional contrast)
  - Light: #6D6D6D
  - Dark: #1B1B1B
  - Container: #E0E0E0

Tertiary: #FF6F00 (Deep Orange 500 - Accent for CTAs)
  - Light: #FFA040
  - Dark: #C43E00
```

#### Semantic Colors
```
Success: #4CAF50 (Green 500)
Warning: #FFC107 (Amber 500)
Error: #F44336 (Red 500)
Info: #2196F3 (Blue 500)
```

#### Neutral Palette
```
Surface: #FFFFFF (Default background)
On-Surface: #1C1B1F (Text on light backgrounds)
Surface-Variant: #F5F5F5 (Subtle backgrounds)
Outline: #79747E (Borders, dividers)
Outline-Variant: #CAC4D0 (Secondary borders)
```

### Typography

**Typeface:** Roboto (Material Design standard)

```
Display Large: 57sp / Light / -0.25sp
Display Medium: 45sp / Regular / 0sp
Display Small: 36sp / Regular / 0sp

Headline Large: 32sp / Regular / 0sp
Headline Medium: 28sp / Regular / 0sp
Headline Small: 24sp / Regular / 0sp

Title Large: 22sp / Medium / 0sp
Title Medium: 16sp / Medium / +0.15sp
Title Small: 14sp / Medium / +0.1sp

Body Large: 16sp / Regular / +0.5sp
Body Medium: 14sp / Regular / +0.25sp
Body Small: 12sp / Regular / +0.4sp

Label Large: 14sp / Medium / +0.1sp
Label Medium: 12sp / Medium / +0.5sp
Label Small: 11sp / Medium / +0.5sp
```

### Spacing System (8dp Grid)

```
XS: 4dp   (Tight spacing, icon padding)
S:  8dp   (Component internal spacing)
M:  16dp  (Default spacing between elements)
L:  24dp  (Section spacing)
XL: 32dp  (Major section breaks)
2XL: 48dp (Page-level spacing)
```

### Corner Radius

```
Small: 4dp   (Chips, small buttons)
Medium: 8dp  (Cards, input fields)
Large: 12dp  (Primary buttons, modals)
Extra Large: 16dp (Hero cards)
Full: 999dp  (Pill buttons, avatars)
```

### Elevation (Material 3)

```
Level 0: 0dp shadow (flat surface)
Level 1: 1dp shadow (raised cards)
Level 2: 3dp shadow (floating buttons)
Level 3: 6dp shadow (dropdowns)
Level 4: 8dp shadow (dialogs)
Level 5: 12dp shadow (navigation drawer)
```

---

## Page Specifications

### Page 1: Splash Screen

**Purpose:** Brand introduction with smooth transition to login
**Duration:** 2 seconds display, 0.3s fade-out
**Frame:** 360x800

#### Layout Structure

```
┌─────────────────────────┐
│                         │
│      (Empty Space)      │  ← 120dp from top
│                         │
│    ┌─────────────┐      │
│    │   App Logo  │      │  ← 120x120 logo
│    │  (Centered) │      │
│    └─────────────┘      │
│                         │
│    GlobalFlavors        │  ← Headline Large (32sp)
│                         │
│  Discover authentic     │  ← Body Medium (14sp)
│  regional dishes you    │     Outline color
│  can cook tonight       │     Center aligned
│                         │
│      (Empty Space)      │
│                         │
│    ··· Loading          │  ← 24dp from bottom
│    (Animated dots)      │     Label Medium (12sp)
│                         │
└─────────────────────────┘
```

#### Component Details

**Logo:**
- Size: 120x120dp
- Style: Colorful illustration (fork + spoon crossed with regional food icons)
- Format: SVG for crisp rendering
- Colors: Primary (#FF4081) + Tertiary (#FF6F00) + neutrals

**App Name Typography:**
- "GlobalFlavors" - Headline Large, On-Surface color
- Letter spacing: 0sp
- Font weight: Medium (500)

**Tagline:**
- Body Medium (14sp)
- Color: Outline (#79747E)
- Max width: 280dp
- Center-aligned

**Loading Indicator:**
- Animated 3 dots (···) that pulse
- Color: Primary (#FF4081)
- Animation: 1.5s loop, ease-in-out

#### Animation Specification

```
0.0s: Fade in from 0% to 100% opacity (0.5s duration)
0.5s: Display static
2.0s: Fade out to 0% opacity (0.3s duration)
2.3s: Navigate to Login Page
```

---

### Page 2: Login Page

**Purpose:** Primary entry point for returning users
**Frame:** 360x800
**Priority:** Social login > Email login

#### Layout Structure

```
┌─────────────────────────┐
│  ← [Back]          [?]  │  ← Top bar: 56dp height
├─────────────────────────┤
│                         │
│    Welcome back!        │  ← Headline Medium (28sp)
│                         │     40dp from top bar
│    Log in to continue   │  ← Body Large (16sp)
│    exploring dishes     │     Outline color
│                         │
│  ┌───────────────────┐  │
│  │  [G] Continue     │  │  ← Google sign-in button
│  │  with Google      │  │     48dp height
│  └───────────────────┘  │
│                         │
│  ┌───────────────────┐  │
│  │  [A] Continue     │  │  ← Apple sign-in button
│  │  with Apple       │  │     48dp height
│  └───────────────────┘  │
│                         │
│  ───── or sign in ───── │  ← Divider with text
│     with email          │     Label Small (11sp)
│                         │
│  ┌───────────────────┐  │
│  │ Email             │  │  ← Email input
│  │ name@example.com  │  │     56dp height
│  └───────────────────┘  │
│                         │
│  ┌───────────────────┐  │
│  │ Password  [👁]    │  │  ← Password input
│  │ ••••••••••        │  │     56dp height
│  └───────────────────┘  │     Toggle visibility icon
│                         │
│      Forgot password?   │  ← Text button
│                         │     Label Large (14sp)
│                         │
│  ┌───────────────────┐  │
│  │     Log In        │  │  ← Primary button
│  └───────────────────┘  │     48dp height
│                         │
│   Don't have account?   │  ← 16dp from bottom
│   Sign up →             │     Label with link
│                         │
└─────────────────────────┘
```

#### Component Details

**Top Bar:**
- Height: 56dp
- Left: Back icon button (40x40 touch target)
- Right: Help icon button (40x40 touch target)
- Surface elevation: Level 0

**Welcome Text:**
- "Welcome back!" - Headline Medium, On-Surface
- Subtitle: Body Large, Outline color
- Left-aligned, 24dp horizontal padding

**Social Sign-In Buttons:**
- Container: Surface-Variant background, Outline border (1dp)
- Height: 48dp
- Corner radius: Large (12dp)
- Horizontal padding: 16dp
- Icon: 24x24dp (Google "G" logo, Apple logo)
- Label: Title Medium (16sp), On-Surface color
- Touch state: Outline-Variant on hover/press
- Spacing between buttons: 12dp

**Divider with Text:**
- Line: Outline color, 1dp thickness
- Text: "or sign in with email" - Label Small, Outline color
- Padding: 24dp vertical

**Email Input Field:**
- Container: Surface-Variant background, Outline border
- Height: 56dp
- Corner radius: Medium (8dp)
- Padding: 16dp horizontal, 16dp vertical
- Label: "Email" - Label Medium, positioned top-left
- Placeholder: "name@example.com" - Body Large, Outline color
- Focus state: Primary color border (2dp)
- Error state: Error color border, error message below

**Password Input Field:**
- Same as Email input
- Right icon: Visibility toggle (eye icon, 24x24dp)
- Type: Password (masked characters)
- Toggle shows/hides password text

**Forgot Password Link:**
- Style: Text button
- Label: "Forgot password?" - Label Large, Primary color
- Touch target: 48dp height minimum
- No background, no border

**Primary Login Button:**
- Container: Primary background (#FF4081)
- Label: "Log In" - Title Medium, White (#FFFFFF)
- Height: 48dp
- Corner radius: Large (12dp)
- Elevation: Level 1
- Disabled state: 38% opacity, no elevation
- Press state: Slightly darker, elevation Level 2

**Sign Up Link:**
- "Don't have an account? Sign up →"
- Body Medium, On-Surface + Primary color for "Sign up"
- Center-aligned, 24dp from bottom

#### States & Validation

**Email Input States:**
1. Default: Outline border, placeholder visible
2. Focus: Primary border (2dp), label moves up
3. Filled: Outline border, label stays up
4. Error: Error border, "Invalid email format" message (Caption, Error color)
5. Disabled: 38% opacity, no interaction

**Password Input States:**
1. Default: Outline border, masked
2. Focus: Primary border (2dp)
3. Filled: Outline border
4. Visible: Unmasked text (eye icon crossed out)
5. Error: "Password required" message

**Login Button States:**
1. Default: Primary background, enabled
2. Loading: Spinner animation, disabled
3. Disabled: Grayed out (38% opacity)
4. Success: Brief checkmark, navigate to home

#### Accessibility

- Minimum touch target: 48x48dp
- Color contrast ratio: ≥ 4.5:1 (WCAG AA)
- Labels for screen readers on all inputs
- Error messages announced immediately
- Tab order: Email → Password → Login → Sign Up

---

### Page 3: Sign Up Page

**Purpose:** New user registration with password strength indication
**Frame:** 360x800

#### Layout Structure

```
┌─────────────────────────┐
│  ← [Back]               │  ← Top bar
├─────────────────────────┤
│                         │
│    Create account       │  ← Headline Medium (28sp)
│                         │
│    Start your culinary  │  ← Body Large (16sp)
│    adventure            │
│                         │
│  ┌───────────────────┐  │
│  │  [G] Continue     │  │  ← Google sign-up
│  │  with Google      │  │
│  └───────────────────┘  │
│                         │
│  ┌───────────────────┐  │
│  │  [A] Continue     │  │  ← Apple sign-up
│  │  with Apple       │  │
│  └───────────────────┘  │
│                         │
│  ───── or sign up ───── │  ← Divider
│     with email          │
│                         │
│  ┌───────────────────┐  │
│  │ Full Name         │  │  ← Name input
│  │ John Doe          │  │
│  └───────────────────┘  │
│                         │
│  ┌───────────────────┐  │
│  │ Email             │  │  ← Email input
│  │ name@example.com  │  │
│  └───────────────────┘  │
│                         │
│  ┌───────────────────┐  │
│  │ Password  [👁]    │  │  ← Password input
│  │ ••••••••••        │  │
│  └───────────────────┘  │
│                         │
│  Password strength:     │  ← Password strength
│  [████████░░] Strong    │     Progress bar
│                         │
│  □ I agree to Terms    │  ← Checkbox + links
│    of Service and      │
│    Privacy Policy       │
│                         │
│  ┌───────────────────┐  │
│  │   Create Account  │  │  ← Primary button
│  └───────────────────┘  │     (disabled until valid)
│                         │
│   Already have account? │  ← Sign in link
│   Log in →              │
│                         │
└─────────────────────────┘
```

#### Component Details

**Page Header:**
- "Create account" - Headline Medium
- Subtitle: "Start your culinary adventure" - Body Large, Outline color

**Social Sign-Up Buttons:**
- Identical to Login page
- Label: "Continue with Google/Apple"

**Full Name Input:**
- Label: "Full Name"
- Placeholder: "John Doe"
- Validation: Minimum 2 characters
- Error: "Please enter your full name"

**Email Input:**
- Identical to Login page
- Additional validation: Check if email already exists
- Error: "This email is already registered. Log in?"

**Password Input with Strength Indicator:**
- Password field identical to Login page
- Strength bar appears on focus:
  - Weak: 0-3 criteria met, Error color
  - Fair: 4 criteria met, Warning color
  - Strong: 5+ criteria met, Success color

**Password Criteria:**
1. Minimum 8 characters
2. At least one uppercase letter
3. At least one lowercase letter
4. At least one number
5. At least one special character (@$!%*?&)

**Strength Progress Bar:**
- Width: Full input width
- Height: 4dp
- Corner radius: Full (pill)
- Background: Outline-Variant
- Fill: Dynamic based on strength (Error/Warning/Success)
- Label: "Weak" / "Fair" / "Strong" - Caption, respective color

**Terms Checkbox:**
- Checkbox: 24x24dp, Outline color border
- Checked: Primary color fill, white checkmark
- Label: Body Small
- Links: "Terms of Service" and "Privacy Policy" - Primary color, underlined
- Touch target: Full row (48dp height)
- Required: Cannot submit without checking

**Create Account Button:**
- Identical to Login button
- Label: "Create Account"
- Disabled until all validation passes:
  - Name not empty
  - Valid email format
  - Password meets criteria
  - Terms checkbox checked

#### Validation Flow

1. **Real-time validation** as user types
2. **Show error** only after user leaves field (on blur)
3. **Inline success indicators** (green checkmark icon)
4. **Button enables** only when all criteria met
5. **Email verification** sent after successful signup

---

### Page 4: Forgot Password

**Purpose:** Password reset flow with email verification
**Frame:** 360x800

#### Layout Structure

```
┌─────────────────────────┐
│  ← [Back]               │
├─────────────────────────┤
│                         │
│      [Envelope Icon]    │  ← 80x80 illustration
│                         │     Primary color
│   Forgot Password?      │  ← Headline Medium
│                         │
│   No worries! Enter     │  ← Body Large
│   your email and we'll  │     Outline color
│   send a reset link     │     Center-aligned
│                         │
│  ┌───────────────────┐  │
│  │ Email             │  │  ← Email input
│  │ name@example.com  │  │
│  └───────────────────┘  │
│                         │
│  ┌───────────────────┐  │
│  │  Send Reset Link  │  │  ← Primary button
│  └───────────────────┘  │
│                         │
│   ← Back to Login       │  ← Text button
│                         │
└─────────────────────────┘
```

#### Success State (After Submission)

```
┌─────────────────────────┐
│  ← [Back]               │
├─────────────────────────┤
│                         │
│    [Checkmark Icon]     │  ← 80x80 success icon
│                         │     Success color
│    Check your email!    │  ← Headline Medium
│                         │
│   We sent a password    │  ← Body Large
│   reset link to:        │     Outline color
│                         │
│   name@example.com      │  ← Body Large
│                         │     On-Surface (bold)
│                         │
│   Didn't receive it?    │  ← Body Medium
│   Check spam or         │
│   [Resend Link]         │  ← Primary text button
│                         │
│  ┌───────────────────┐  │
│  │  Open Email App   │  │  ← Secondary button
│  └───────────────────┘  │
│                         │
│   ← Back to Login       │
│                         │
└─────────────────────────┘
```

#### Component Details

**Envelope Illustration:**
- Size: 80x80dp
- Style: Simple line illustration
- Color: Primary (#FF4081)
- Centered, 80dp from top

**Page Content:**
- "Forgot Password?" - Headline Medium, On-Surface
- Instructions: Body Large, Outline color, center-aligned
- Max width: 280dp for readability

**Email Input:**
- Identical to Login page
- Auto-focus on page load
- Validation: Email format check

**Send Reset Link Button:**
- Primary button style
- Label: "Send Reset Link"
- Disabled if email invalid
- Loading state: Spinner + "Sending..."
- Success: Navigate to success state

**Back to Login Link:**
- Text button, Primary color
- Left arrow icon + "Back to Login"

**Success State Icons:**
- Checkmark: 80x80dp, Success color
- Animated check drawing (0.3s)

**Resend Link:**
- Text button, Primary color
- Disabled for 60 seconds after send
- Shows countdown: "Resend (45s)"

**Open Email App Button:**
- Secondary button (Outline style)
- Outline border, no fill
- Label: "Open Email App"
- On tap: Deep link to default email app

---

### Page 5: Email Verification

**Purpose:** Verify email after signup with countdown and resend option
**Frame:** 360x800

#### Layout Structure

```
┌─────────────────────────┐
│  ✕ [Close]              │  ← Close to skip (optional)
├─────────────────────────┤
│                         │
│    [Email Icon]         │  ← 80x80 illustration
│                         │     Primary color
│   Verify your email     │  ← Headline Medium
│                         │
│   We sent a verification│  ← Body Large
│   link to:              │     Outline color
│                         │
│   name@example.com      │  ← Body Large (bold)
│                         │     On-Surface
│   Click the link to     │  ← Body Medium
│   activate your account │     Outline color
│                         │
│   ┌─────────────────┐   │
│   │  ✓ Automatic    │   │  ← Status card
│   │  verification   │   │     Surface-Variant bg
│   │  checking...    │   │
│   │  (Spinner)      │   │  ← Animated spinner
│   └─────────────────┘   │
│                         │
│   Didn't receive it?    │  ← Body Medium
│                         │
│  ┌───────────────────┐  │
│  │  Resend Email     │  │  ← Secondary button
│  │  (available in 45s)│  │     Shows countdown
│  └───────────────────┘  │
│                         │
│   ← Skip for now        │  ← Text link
│   (You can verify later)│     Caption
│                         │
└─────────────────────────┘
```

#### Verified State

```
┌─────────────────────────┐
│  ✓ [Done]               │
├─────────────────────────┤
│                         │
│   [Checkmark Icon]      │  ← 80x80 success icon
│                         │     Success color
│   Email verified!       │  ← Headline Medium
│                         │
│   Your account is now   │  ← Body Large
│   active. Let's start   │     Outline color
│   cooking!              │
│                         │
│  ┌───────────────────┐  │
│  │  Get Started      │  │  ← Primary button
│  └───────────────────┘  │
│                         │
└─────────────────────────┘
```

#### Component Details

**Email Illustration:**
- Size: 80x80dp
- Style: Outlined envelope with checkmark badge
- Colors: Primary + Success

**Page Content:**
- "Verify your email" - Headline Medium
- Sent to: Body Large (bold), user's email
- Instructions: Body Medium, Outline color

**Automatic Verification Check:**
- Background polling every 5 seconds
- Checks if email link was clicked
- Shows spinner during check
- Auto-navigates on success

**Status Card:**
- Container: Surface-Variant background
- Border: Outline-Variant (1dp)
- Corner radius: Medium (8dp)
- Padding: 16dp
- Content:
  - Checkmark icon or Spinner (24x24dp)
  - Status text: Label Large
  - States: "Checking..." / "Verified!" / "Not verified yet"

**Resend Email Button:**
- Secondary button (Outline style)
- Disabled with countdown: "Resend Email (45s)"
- Enabled after countdown: "Resend Email"
- On tap: Send new verification email, restart countdown
- Success feedback: "Email sent!" snackbar

**Countdown Timer:**
- Initial: 60 seconds
- Format: "Resend Email (45s)"
- Updates every second
- At 0: Enable button, remove countdown

**Skip Link:**
- Text button, Outline color
- "Skip for now" + Caption below
- "(You can verify later from Settings)"
- On tap: Navigate to Home with banner reminder

**Success Animation:**
- Checkmark draws in (0.3s)
- Confetti animation (optional)
- Haptic feedback (light impact)
- Auto-navigate after 1.5s

---

## Figma AI Prompts (Ready to Use)

### Setup Instructions

1. **Create New Figma File:** "GlobalFlavors - Phase 1: Auth Flow"
2. **Enable Figma AI / Make:** Design → Make (or use Figma AI plugins)
3. **Copy-Paste Prompts Below:** Use each prompt in sequence
4. **Iterate:** Refine details with follow-up prompts

---

### Prompt 1: Splash Screen

```
You are a senior mobile UX designer creating a splash screen for "GlobalFlavors,"
a mobile app that helps users discover authentic regional dishes.

Create a mobile splash screen (360x800 frame) with these exact specifications:

BRAND IDENTITY:
- App name: "GlobalFlavors"
- Tagline: "Discover authentic regional dishes you can cook tonight"
- Primary brand color: #FF4081 (vibrant pink)
- Secondary color: #FF6F00 (deep orange)

LAYOUT (top to bottom, all center-aligned):
1. App logo illustration (120x120):
   - Colorful, friendly illustration style
   - Crossed fork and spoon with small regional food icons around them
   - Use brand colors #FF4081 and #FF6F00
   - Modern, appetizing design

2. App name "GlobalFlavors" (120dp below logo):
   - Roboto Medium, 32sp
   - Color: #1C1B1F (dark gray)
   - Letter spacing: 0

3. Tagline (16dp below app name):
   - Roboto Regular, 14sp
   - Color: #79747E (medium gray)
   - Center-aligned, max 280dp width
   - Text: "Discover authentic regional dishes you can cook tonight"

4. Loading indicator (24dp from bottom):
   - Three animated dots (···)
   - Color: #FF4081
   - Pulsing animation effect
   - Roboto Medium, 12sp

DESIGN REQUIREMENTS:
- Use Material Design 3 principles
- Clean, spacious layout with plenty of white space
- Background: pure white (#FFFFFF)
- All elements center-aligned vertically and horizontally
- Auto Layout: vertical, centered, spacing as specified above
- Export-ready for mobile (360x800)

Create a professional, welcoming splash screen that builds trust and excitement
for discovering global cuisines.
```

**Follow-up Refinement Prompts:**
```
- "Make the logo more playful and food-focused"
- "Adjust spacing to feel more balanced"
- "Change loading dots to a circular progress indicator"
```

---

### Prompt 2: Login Page

```
You are a senior mobile UX designer creating a login page for "GlobalFlavors,"
a culture-first recipe discovery app using Material Design 3.

Create a mobile login page (360x800 frame) following these exact specifications:

TOP BAR (56dp height):
- Left: Back arrow icon button (24x24 icon, 40x40 touch target)
- Right: Help icon (question mark, same sizing)
- Background: white, no elevation

HEADER CONTENT (40dp below top bar, 24dp horizontal padding):
- Title: "Welcome back!" (Roboto Medium, 28sp, #1C1B1F)
- Subtitle: "Log in to continue exploring dishes" (Roboto Regular, 16sp, #79747E)
- Left-aligned

SOCIAL LOGIN BUTTONS (24dp below header):
- Google button:
  - Height: 48dp, full width minus 48dp padding
  - Background: #F5F5F5, border: 1dp #79747E
  - Corner radius: 12dp
  - Icon: Google "G" logo (24x24), left-aligned with 16dp padding
  - Label: "Continue with Google" (Roboto Medium, 16sp, #1C1B1F)
  - Centered vertically

- Apple button (12dp below Google):
  - Same styling as Google
  - Icon: Apple logo
  - Label: "Continue with Apple"

DIVIDER (24dp below Apple button):
- Horizontal line: 1dp, #79747E
- Centered text: "or sign in with email" (Roboto Regular, 11sp, #79747E)
- Line breaks around text

EMAIL INPUT (16dp below divider):
- Container: 56dp height, #F5F5F5 background, 1dp #79747E border
- Corner radius: 8dp
- Label: "Email" (Roboto Medium, 12sp) top-left inside
- Placeholder: "name@example.com" (Roboto Regular, 16sp, #79747E)
- Padding: 16dp all sides

PASSWORD INPUT (12dp below email):
- Same styling as email input
- Label: "Password"
- Placeholder: dots (••••••••)
- Right icon: Eye icon for visibility toggle (24x24)

FORGOT PASSWORD LINK (8dp below password):
- Text: "Forgot password?" (Roboto Medium, 14sp, #FF4081)
- Right-aligned
- No background, text button only

PRIMARY LOGIN BUTTON (24dp below forgot password):
- Height: 48dp, full width minus 48dp padding
- Background: #FF4081 (primary brand color)
- Label: "Log In" (Roboto Medium, 16sp, white #FFFFFF)
- Corner radius: 12dp
- Slight elevation (2dp shadow)

SIGN UP LINK (fixed 24dp from bottom):
- Text: "Don't have an account? Sign up →"
- First part: Roboto Regular, 14sp, #1C1B1F
- "Sign up": Roboto Medium, 14sp, #FF4081
- Center-aligned

DESIGN REQUIREMENTS:
- Material Design 3 principles
- Auto Layout: vertical stacking, proper spacing
- All touch targets minimum 48dp
- 24dp horizontal padding throughout
- White background (#FFFFFF)
- Focus states: #FF4081 border (2dp) on inputs
- Mobile-optimized (360x800)

Create a clean, trustworthy login page that prioritizes social login
while providing email option. Make it feel welcoming and professional.
```

**Follow-up Refinement Prompts:**
```
- "Add subtle shadows to social login buttons"
- "Make the primary button more prominent"
- "Show error state on email input with red border"
- "Add focus state with pink border on password field"
```

---

### Prompt 3: Sign Up Page

```
You are a senior mobile UX designer creating a sign-up page for "GlobalFlavors"
with Material Design 3, including a password strength indicator.

Create a mobile sign-up page (360x800 frame) with these specifications:

TOP BAR:
- Same as login page (56dp, back button left)

HEADER (40dp below top bar):
- Title: "Create account" (Roboto Medium, 28sp, #1C1B1F)
- Subtitle: "Start your culinary adventure" (Roboto Regular, 16sp, #79747E)

SOCIAL SIGN-UP BUTTONS:
- Identical to login page
- Labels: "Continue with Google" / "Continue with Apple"
- 24dp below header, 12dp spacing between

DIVIDER:
- Same as login page
- Text: "or sign up with email"

FORM INPUTS (16dp spacing between each):
1. Full Name Input:
   - Label: "Full Name"
   - Placeholder: "John Doe"
   - Same styling as login page inputs

2. Email Input:
   - Label: "Email"
   - Placeholder: "name@example.com"
   - Same styling

3. Password Input:
   - Label: "Password"
   - Placeholder: dots
   - Eye icon for toggle
   - Same styling

PASSWORD STRENGTH INDICATOR (8dp below password):
- Progress bar:
  - Width: full input width
  - Height: 4dp
  - Background: #CAC4D0
  - Fill color: dynamic
    * Weak (0-40%): #F44336 (red)
    * Fair (40-70%): #FFC107 (amber)
    * Strong (70-100%): #4CAF50 (green)
  - Corner radius: full (pill shape)

- Label (8dp below bar):
  - "Weak" / "Fair" / "Strong"
  - Roboto Regular, 12sp
  - Color matches progress bar fill

TERMS CHECKBOX (16dp below strength indicator):
- Checkbox: 24x24, #79747E border, #FF4081 when checked
- Label: "I agree to Terms of Service and Privacy Policy"
  - "Terms of Service" and "Privacy Policy": #FF4081, underlined
  - Rest of text: Roboto Regular, 12sp, #1C1B1F
- Full row touch target (48dp height)

CREATE ACCOUNT BUTTON (16dp below checkbox):
- Same styling as login button
- Label: "Create Account"
- Disabled state (38% opacity) until all validation passes

SIGN IN LINK (24dp from bottom):
- "Already have an account? Log in →"
- Same styling as login page signup link

DESIGN REQUIREMENTS:
- Material Design 3
- Auto Layout with proper spacing
- Password strength updates in real-time as user types
- Checkbox must be checked to enable button
- All inputs use same component from login page
- 24dp horizontal padding
- White background
- Scroll enabled if content exceeds 800dp

Create a clear, confidence-building sign-up flow with visual feedback
on password strength to guide users toward creating secure accounts.
```

**Follow-up Refinement Prompts:**
```
- "Show the password strength bar in filled state at 80% (strong)"
- "Add small checkmarks next to password criteria as they're met"
- "Make the checkbox larger and easier to tap"
- "Show the create account button in disabled state (grayed out)"
```

---

### Prompt 4: Forgot Password

```
You are a senior mobile UX designer creating a password reset flow for
"GlobalFlavors" using Material Design 3, with both input and success states.

Create TWO frames (360x800 each):

FRAME 1: FORGOT PASSWORD INPUT

TOP BAR:
- Back button (left), 56dp height

ILLUSTRATION (80dp below top bar):
- Envelope icon illustration: 80x80
- Simple line style, #FF4081 color
- Center-aligned

HEADER (24dp below illustration):
- Title: "Forgot Password?" (Roboto Medium, 28sp, #1C1B1F)
- Center-aligned

DESCRIPTION (16dp below title):
- "No worries! Enter your email and we'll send a reset link"
- Roboto Regular, 16sp, #79747E
- Center-aligned, max 280dp width

EMAIL INPUT (32dp below description):
- Same styling as login page
- Label: "Email"
- Placeholder: "name@example.com"
- Auto-focused (shown with #FF4081 border)

SEND BUTTON (24dp below input):
- Same styling as primary login button
- Label: "Send Reset Link"

BACK TO LOGIN LINK (fixed 24dp from bottom):
- "← Back to Login" (Roboto Medium, 14sp, #FF4081)
- Text button, center-aligned

---

FRAME 2: SUCCESS STATE

TOP BAR:
- Same as Frame 1

SUCCESS ICON (80dp below top bar):
- Checkmark in circle: 80x80
- #4CAF50 (green) color
- Animated check drawing effect
- Center-aligned

HEADER (24dp below icon):
- Title: "Check your email!" (Roboto Medium, 28sp, #1C1B1F)
- Center-aligned

CONFIRMATION TEXT (16dp below title):
- "We sent a password reset link to:"
- Roboto Regular, 16sp, #79747E
- Center-aligned

EMAIL DISPLAY (8dp below):
- "name@example.com" (Roboto Medium, 16sp, #1C1B1F)
- Center-aligned

RESEND SECTION (24dp below email):
- "Didn't receive it? Check spam or"
- Roboto Regular, 14sp, #79747E
- "Resend Link" on next line (Roboto Medium, 14sp, #FF4081)
- Center-aligned

OPEN EMAIL BUTTON (24dp below resend):
- Height: 48dp, full width minus 48dp padding
- Background: transparent, border: 2dp #FF4081
- Label: "Open Email App" (Roboto Medium, 16sp, #FF4081)
- Corner radius: 12dp
- Secondary button style

BACK TO LOGIN LINK:
- Same as Frame 1

DESIGN REQUIREMENTS:
- Material Design 3
- Clear visual hierarchy
- Success state feels rewarding
- Icons are simple and clear
- Illustrations are friendly, not corporate
- Center-aligned content for focus
- White background
- All text easily scannable

Create a reassuring, helpful password reset flow that reduces user anxiety
and clearly communicates next steps.
```

**Follow-up Refinement Prompts:**
```
- "Make the envelope illustration more friendly and welcoming"
- "Add a subtle animation to the success checkmark"
- "Show the resend link in disabled state with countdown (45s)"
```

---

### Prompt 5: Email Verification

```
You are a senior mobile UX designer creating an email verification page for
"GlobalFlavors" with automatic checking, countdown timer, and success state.

Create TWO frames (360x800 each):

FRAME 1: VERIFICATION WAITING

TOP BAR (56dp):
- Right: Close X button (24x24 icon, 40x40 touch target)
- Background: white

EMAIL ILLUSTRATION (64dp below top bar):
- Email icon with small badge: 80x80
- Main icon: #FF4081 outline style
- Badge: checkmark circle, #4CAF50
- Center-aligned

HEADER (24dp below illustration):
- Title: "Verify your email" (Roboto Medium, 28sp, #1C1B1F)
- Center-aligned

DESCRIPTION (16dp below title):
- "We sent a verification link to:"
- Roboto Regular, 16sp, #79747E
- Center-aligned

EMAIL ADDRESS (8dp below):
- "name@example.com" (Roboto Medium, 16sp, #1C1B1F)
- Center-aligned

INSTRUCTION (8dp below):
- "Click the link to activate your account"
- Roboto Regular, 14sp, #79747E
- Center-aligned

STATUS CARD (24dp below):
- Container:
  - Background: #F5F5F5
  - Border: 1dp #CAC4D0
  - Corner radius: 8dp
  - Padding: 16dp
  - Width: full minus 48dp horizontal padding
- Content:
  - Spinner icon: 24x24, #FF4081, animated rotation
  - Text: "Automatic verification checking..." (Roboto Regular, 14sp, #79747E)
  - Vertically centered, icon left of text

RESEND SECTION (24dp below card):
- "Didn't receive it?" (Roboto Regular, 14sp, #79747E)
- Center-aligned

RESEND BUTTON (12dp below):
- Secondary button (outlined):
  - Background: transparent
  - Border: 1dp #CAC4D0
  - Label: "Resend Email (available in 45s)"
  - Roboto Medium, 14sp, #79747E
  - Height: 48dp, corner radius: 12dp
  - Disabled state shown

SKIP LINK (fixed 32dp from bottom):
- "← Skip for now" (Roboto Medium, 14sp, #79747E)
- Caption below: "(You can verify later)" (Roboto Regular, 11sp, #79747E)
- Center-aligned, text button

---

FRAME 2: VERIFIED SUCCESS

TOP BAR (56dp):
- Right: Checkmark button (indicating done)
- Background: white

SUCCESS ICON (80dp below top bar):
- Large checkmark in circle: 80x80
- #4CAF50 color
- Filled style
- Animated drawing effect
- Center-aligned

HEADER (24dp below icon):
- Title: "Email verified!" (Roboto Medium, 28sp, #1C1B1F)
- Center-aligned

CONFIRMATION (16dp below title):
- "Your account is now active. Let's start cooking!"
- Roboto Regular, 16sp, #79747E
- Center-aligned, max 280dp width

GET STARTED BUTTON (40dp below):
- Primary button:
  - Background: #FF4081
  - Label: "Get Started" (Roboto Medium, 16sp, white)
  - Height: 48dp, corner radius: 12dp
  - Elevation: 2dp shadow
  - Full width minus 48dp padding

DESIGN REQUIREMENTS:
- Material Design 3
- Automatic checking every 5 seconds (show in status card)
- Countdown timer updates every second
- Success state feels celebratory
- Clear next action on success
- Helpful guidance for users who don't see email
- Skip option available but not emphasized
- White background
- Center-aligned for focus

Create a patient, helpful verification flow that automatically detects
completion while giving users options if they need help.
```

**Follow-up Refinement Prompts:**
```
- "Show the countdown timer at 30 seconds remaining"
- "Add a subtle success animation (confetti or sparkles) on verified state"
- "Make the status card more prominent with slight elevation"
- "Show the resend button in enabled state (after countdown)"
```

---

## Export Specifications

### Component Exports

After creating designs, export these components for FlutterFlow:

#### Assets to Export

**Icons (SVG, 24x24dp):**
- Back arrow
- Close (X)
- Help (question mark)
- Eye (visibility toggle)
- Eye-off (hide password)
- Google logo
- Apple logo
- Checkmark
- Envelope

**Illustrations (PNG, @2x and @3x):**
- App logo (120x120 → export @240x240 and @360x360)
- Envelope illustration
- Success checkmark illustration
- Email badge illustration

**Export Settings (Figma):**
```
Format: SVG for icons, PNG for illustrations
Scale: 2x and 3x for raster images
Color space: sRGB
Compression: Optimize for web
Naming: kebab-case (e.g., icon-eye-open.svg)
```

### Design Tokens Export

Export as JSON for development:

```json
{
  "colors": {
    "primary": "#FF4081",
    "secondary": "#424242",
    "tertiary": "#FF6F00",
    "success": "#4CAF50",
    "warning": "#FFC107",
    "error": "#F44336"
  },
  "spacing": {
    "xs": "4dp",
    "s": "8dp",
    "m": "16dp",
    "l": "24dp",
    "xl": "32dp",
    "2xl": "48dp"
  },
  "typography": {
    "headline-large": {
      "font": "Roboto",
      "size": "32sp",
      "weight": "Regular"
    }
  }
}
```

---

## Quality Checklist

Before finalizing designs:

### ✅ Visual Design
- [ ] All frames are 360x800 (mobile portrait)
- [ ] Consistent use of Material 3 color palette
- [ ] Typography follows Material 3 type scale
- [ ] 8dp grid alignment throughout
- [ ] Proper visual hierarchy (size, weight, color)
- [ ] Consistent spacing between elements

### ✅ Components
- [ ] All components use Auto Layout
- [ ] Touch targets minimum 48x48dp
- [ ] Buttons have hover/press states defined
- [ ] Input fields show focus/error/disabled states
- [ ] Icons are consistent size (24x24)

### ✅ Accessibility
- [ ] Color contrast ≥ 4.5:1 for text (WCAG AA)
- [ ] Touch targets ≥ 48dp
- [ ] Clear labels for all interactive elements
- [ ] Error messages are descriptive
- [ ] Logical tab order for keyboard navigation

### ✅ Interaction Design
- [ ] Loading states defined for async actions
- [ ] Error states show helpful messages
- [ ] Success feedback is clear and rewarding
- [ ] Navigation flow is logical
- [ ] Back buttons work as expected

### ✅ Content
- [ ] Microcopy is friendly and helpful
- [ ] Error messages guide users to solutions
- [ ] Placeholders are realistic examples
- [ ] Labels are clear and concise
- [ ] CTAs are action-oriented

### ✅ Export Readiness
- [ ] All assets properly named
- [ ] Icons exported as SVG
- [ ] Illustrations exported at 2x and 3x
- [ ] Components organized in Figma
- [ ] Design tokens documented

---

## Next Steps

### After Completing Designs

1. **Review with Team**
   - Share Figma link with all stakeholders
   - Gather feedback using Figma comments
   - Iterate based on user persona alignment

2. **Export Assets**
   - Use export specifications above
   - Organize in `/assets` directory
   - Upload to FlutterFlow project

3. **Implement in FlutterFlow**
   - Create matching pages in FlutterFlow
   - Apply design tokens to theme
   - Build components with proper states

4. **Test on Devices**
   - Preview on actual mobile devices
   - Test touch targets and interactions
   - Verify colors and contrast
   - Check animations and transitions

5. **Iterate Based on Testing**
   - Collect user feedback
   - Refine based on usability issues
   - Update Figma designs as source of truth

---

## Support & Resources

**Project Documentation:**
- Business Plan: [Google Slides](https://docs.google.com/presentation/d/1AdgIL1-TdeeoC_RMIq0idQqPlhmNeccVTQsqzTekolU)
- User Personas: [Google Slides](https://docs.google.com/presentation/d/1p-2E9KyCJyyXrYYOkEXYjQy3kDwluuwXIvFoiH2w5ZA)

**Design Resources:**
- Material 3 Design Kit: [Figma Community](https://www.figma.com/community/file/1035203688168086460)
- Material 3 Guidelines: [m3.material.io](https://m3.material.io/)
- Figma Best Practices: [Figma Learn](https://help.figma.com/hc/en-us)

**Team Contact:**
- Email: uricsc305@gmail.com

---

**Document Status:** Production-Ready
**Last Updated:** 2025-10-20
**Next Review:** After Phase 1 implementation
**Maintained By:** GlobalFlavors Design Team
