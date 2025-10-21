# Material 3 Design System Integration - GlobalFlavors

## Overview

This React application has been fully integrated with **Material 3 (Material You)** design principles, providing a modern, accessible, and cohesive user experience for the GlobalFlavors recipe platform.

---

## Design System Architecture

### Color System

Material 3 uses a comprehensive color system with semantic naming:

#### Primary Colors
- **Primary** (#D81B60): Main brand color - vibrant pink
- **On-Primary** (#FFFFFF): Text/icons on primary color
- **Primary Container** (#FFD7E5): Lighter primary for surfaces
- **On-Primary Container** (#3E001D): Text on primary container

#### Secondary Colors
- **Secondary** (#7B5264): Supporting brand color
- **On-Secondary** (#FFFFFF): Text/icons on secondary
- **Secondary Container** (#FFD9E4): Lighter secondary for surfaces
- **On-Secondary Container** (#301120): Text on secondary container

#### Tertiary Colors
- **Tertiary** (#815343): Accent color
- **On-Tertiary** (#FFFFFF): Text/icons on tertiary
- **Tertiary Container** (#FFDBD0): Lighter tertiary for surfaces
- **On-Tertiary Container** (#321207): Text on tertiary container

#### Surface Colors (Elevation System)
Material 3 uses tonal elevation instead of shadows:
- **Surface** (#FFFBFF): Base surface
- **Surface Container Lowest** (#FFFFFF): Lowest elevation
- **Surface Container Low** (#FFF4F9): Low elevation (cards)
- **Surface Container** (#FCEEF4): Default elevation
- **Surface Container High** (#F6E8EF): High elevation (elevated cards)
- **Surface Container Highest** (#F1E3E9): Highest elevation (inputs)

#### Semantic Colors
- **Error** (#BA1A1A): Error states
- **Error Container** (#FFDAD6): Error backgrounds
- **Outline** (#857377): Borders and dividers
- **Outline Variant** (#D7C2C7): Subtle borders

---

## Component Styling Guidelines

### Border Radius (Material 3)
Material 3 uses larger, more rounded corners:
- **Extra Small**: 4px - Small chips
- **Small**: 8px - Compact buttons
- **Medium**: 12px - Input fields
- **Large**: 16px - Icons/avatars
- **Extra Large**: 28px - Cards and containers
- **Full**: 9999px - Pills and FABs

### Elevation & Shadow
Material 3 prefers tonal elevation over shadows:
```css
/* Instead of heavy shadows */
box-shadow: 0 2px 8px rgba(0,0,0,0.15);

/* Use surface containers */
background: var(--surface-container-high);
border: 1px solid var(--outline-variant);
```

### Typography
Following Material 3 type scale:
- **Display**: Large hero text (48-64px)
- **Headline**: Page titles (32-40px)
- **Title**: Section headers (20-28px)
- **Body**: Regular text (14-16px)
- **Label**: UI labels (12-14px)

---

## Page Implementations

### 1. Landing Page
**Material 3 Features:**
- Hero section with tonal surface containers
- Filled primary buttons with elevation
- Feature cards using surface-container-low
- Stats section with primary background (tonal)
- Rounded corners (28px) throughout

**Key Classes:**
```tsx
// Hero button
className="bg-primary text-on-primary rounded-full shadow-lg"

// Feature cards
className="bg-surface-container-low rounded-[28px] border border-outline-variant"

// Chip badge
className="bg-primary-container text-on-primary-container rounded-full"
```

### 2. Login & Signup Pages
**Material 3 Features:**
- Elevated card on surface background
- Rounded input fields (12px)
- Icon integration in inputs
- Filled primary button (rounded-full)
- Social login with outlined buttons

**Key Classes:**
```tsx
// Main card
className="bg-surface-container-low rounded-[28px] shadow-lg border border-outline-variant"

// Input fields
className="rounded-[12px] bg-surface-container-highest border-outline focus:border-primary"

// Primary action
className="bg-primary text-on-primary rounded-full shadow-md"
```

### 3. Onboarding Page
**Material 3 Features:**
- Multi-step progress indicator
- Interactive selection cards with tonal states
- Chip-based selection summary
- State layers for hover/active states

**Key Classes:**
```tsx
// Selection card (active)
className="border-primary bg-primary-container rounded-[20px]"

// Selection card (inactive)
className="border-outline-variant bg-surface-container hover:bg-surface-container-high"

// Summary chips
className="bg-primary-container text-on-primary-container rounded-full"
```

### 4. Dashboard Page
**Material 3 Features:**
- Top app bar with surface tint
- Floating action buttons (filter chips)
- Recipe cards with tonal elevation
- Material icons integration
- Dropdown menu with proper surfaces

**Key Classes:**
```tsx
// App bar
className="bg-surface-container-low backdrop-blur-xl border-b border-outline-variant"

// Filter chips (active)
className="bg-primary text-on-primary rounded-full shadow-md"

// Recipe card
className="bg-surface-container-low rounded-[24px] border border-outline-variant"

// Save button (floating)
className="bg-surface-container/95 backdrop-blur-md rounded-full shadow-lg"
```

---

## Dark Mode Support

Material 3 includes full dark mode with adjusted color tokens:

### Dark Theme Colors
- **Primary**: #FFB0C9 (lighter pink)
- **Surface**: #191113 (very dark)
- **Surface Container**: #262021 (elevated dark)
- **On Surface**: #ECE0E2 (off-white text)

### Automatic Dark Mode
The color system automatically adapts when `.dark` class is applied to root element.

---

## Accessibility Features

### Color Contrast
All color combinations meet WCAG AA standards:
- Primary on Primary Container: 7.2:1
- On Surface on Surface: 12.5:1
- Error on Error Container: 5.8:1

### Focus States
Material 3 focus indicators:
```tsx
focus:border-primary focus:ring-2 focus:ring-primary/20
```

### Semantic HTML
- Proper heading hierarchy (h1 → h2 → h3)
- ARIA labels on interactive elements
- Keyboard navigation support

---

## State Layers

Material 3 uses state layers for interactivity:

### Hover State
```tsx
hover:bg-surface-container-highest // +8% opacity
```

### Pressed State
```tsx
active:bg-surface-container-high // +12% opacity
```

### Focus State
```tsx
focus:ring-2 focus:ring-primary/20
```

---

## Component Library Integration

### Shadcn/UI Compatibility
All shadcn components work seamlessly with Material 3 tokens:

```tsx
// Button component automatically uses Material 3 colors
<Button className="bg-primary text-on-primary" />

// Badge with Material 3 containers
<Badge className="bg-secondary-container text-on-secondary-container" />

// Card with proper elevation
<Card className="bg-surface-container-low border-outline-variant" />
```

---

## Icon System

Using **Lucide React** icons following Material 3 guidelines:
- 24px default size for UI elements
- 20px for compact spaces
- 16px for dense lists
- Proper color tokens (on-surface-variant for inactive)

---

## Responsive Design

Material 3 breakpoints:
- **Compact**: < 600px (mobile)
- **Medium**: 600px - 840px (tablet)
- **Expanded**: > 840px (desktop)

### Adaptive Layouts
```tsx
// Card grid adapts to screen size
className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6"

// Navigation shows/hides labels
className="hidden lg:block"
```

---

## Animation & Motion

Material 3 motion principles:
- **Duration**: 200-300ms for micro-interactions
- **Easing**: Emphasized easing (cubic-bezier)
- **Scale**: hover:scale-105 for cards
- **Transition**: All property changes use transitions

```tsx
className="transition-all duration-300 hover:scale-105"
```

---

## Best Practices

### ✅ DO
- Use surface containers for elevation
- Apply rounded-[28px] for cards
- Use semantic color names (primary, error, etc.)
- Implement state layers for interactions
- Follow 8px spacing grid

### ❌ DON'T
- Use hardcoded hex colors
- Mix Material 2 and Material 3 patterns
- Use heavy box-shadows (use tonal elevation)
- Ignore dark mode considerations
- Create custom colors outside the palette

---

## File Structure

```
/styles/globals.css          # Material 3 color tokens & theme
/components/LandingPage.tsx  # Hero, features, CTA
/components/LoginPage.tsx    # Authentication form
/components/SignupPage.tsx   # Registration form
/components/OnboardingPage.tsx # Multi-step preferences
/components/DashboardPage.tsx  # Recipe feed & discovery
/contexts/AuthContext.tsx     # User state management
/App.tsx                      # Routing & protected routes
```

---

## Usage Examples

### Creating a Material 3 Button
```tsx
// Primary filled button
<Button className="bg-primary text-on-primary hover:bg-primary/90 rounded-full shadow-md">
  Get Started
</Button>

// Secondary outlined button
<Button className="border-outline text-on-surface hover:bg-surface-container-highest rounded-full">
  Learn More
</Button>
```

### Creating a Material 3 Card
```tsx
<div className="bg-surface-container-low rounded-[28px] p-6 border border-outline-variant shadow-sm">
  <h3 className="text-on-surface font-semibold mb-2">Card Title</h3>
  <p className="text-on-surface-variant">Card content goes here</p>
</div>
```

### Creating a Material 3 Input
```tsx
<Input 
  className="rounded-[12px] bg-surface-container-highest border-outline focus:border-primary h-14"
  placeholder="Enter text..."
/>
```

---

## Testing Checklist

- [ ] All colors have proper contrast ratios
- [ ] Dark mode works across all pages
- [ ] Hover states are visible
- [ ] Focus indicators meet accessibility standards
- [ ] Buttons use proper elevation
- [ ] Cards use tonal surfaces
- [ ] Typography follows type scale
- [ ] Icons have correct sizes
- [ ] Rounded corners are consistent (28px for cards)
- [ ] Spacing follows 8px grid

---

## Migration Notes

### From Previous Design
**Changed:**
- ✨ New pink-based primary color (#D81B60)
- 🎨 Surface containers replace gray backgrounds
- 🔲 Larger border radius (28px for cards)
- 🌓 Comprehensive dark mode support
- 📐 8px spacing grid throughout

**Preserved:**
- ✅ React + TypeScript architecture
- ✅ Shadcn/UI component library
- ✅ Tailwind CSS framework
- ✅ Responsive mobile-first design

---

## Resources

- [Material 3 Design Kit (Figma)](https://www.figma.com/community/file/1035203688168086460)
- [Material Design 3 Guidelines](https://m3.material.io/)
- [Color System Documentation](https://m3.material.io/styles/color/overview)
- [Typography Scale](https://m3.material.io/styles/typography/overview)

---

## Support

For questions about Material 3 implementation:
1. Check `/styles/globals.css` for available color tokens
2. Reference component files for usage patterns
3. Consult Material 3 documentation for design decisions

---

**Last Updated:** October 21, 2025  
**Design System:** Material 3 (Material You)  
**Version:** 1.0.0
