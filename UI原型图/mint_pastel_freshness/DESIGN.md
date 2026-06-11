---
name: Mint & Pastel Freshness
colors:
  surface: '#f4fafd'
  surface-dim: '#d4dbdd'
  surface-bright: '#f4fafd'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eef5f7'
  surface-container: '#e8eff1'
  surface-container-high: '#e2e9ec'
  surface-container-highest: '#dde4e6'
  on-surface: '#161d1f'
  on-surface-variant: '#3b4a46'
  inverse-surface: '#2b3234'
  inverse-on-surface: '#ebf2f4'
  outline: '#6b7a76'
  outline-variant: '#bacac5'
  surface-tint: '#006b5c'
  primary: '#006b5c'
  on-primary: '#ffffff'
  primary-container: '#49eace'
  on-primary-container: '#006658'
  inverse-primary: '#36dec2'
  secondary: '#596247'
  on-secondary: '#ffffff'
  secondary-container: '#dde7c5'
  on-secondary-container: '#5f684d'
  tertiary: '#655b67'
  on-tertiary: '#ffffff'
  tertiary-container: '#dbcedd'
  on-tertiary-container: '#605763'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#5efade'
  primary-fixed-dim: '#36dec2'
  on-primary-fixed: '#00201b'
  on-primary-fixed-variant: '#005045'
  secondary-fixed: '#dde7c5'
  secondary-fixed-dim: '#c1cbaa'
  on-secondary-fixed: '#161e09'
  on-secondary-fixed-variant: '#414a31'
  tertiary-fixed: '#ecdeed'
  tertiary-fixed-dim: '#cfc2d1'
  on-tertiary-fixed: '#201923'
  on-tertiary-fixed-variant: '#4d444f'
  background: '#f4fafd'
  on-background: '#161d1f'
  surface-variant: '#dde4e6'
typography:
  headline-xl:
    fontFamily: Manrope
    fontSize: 48px
    fontWeight: '800'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Manrope
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Manrope
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
  headline-md:
    fontFamily: Manrope
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Manrope
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.05em
  label-sm:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 24px
  lg: 48px
  xl: 80px
  gutter: 24px
  margin-mobile: 16px
  margin-desktop: 64px
---

## Brand & Style
This design system captures a fresh, optimistic, and revitalizing atmosphere. Drawing inspiration from a soft, luminous palette of mint, pale yellow, and light pink, the aesthetic is airy and modern. It targets a health-conscious and youthful audience, evoking feelings of renewal and calm.

The visual style is **Modern Minimalism** mixed with subtle **Glassmorphism**. It prioritizes high-quality negative space and soft transitions to create a breathable interface. The goal is to feel like a digital breath of fresh air—clean, inviting, and effortlessly professional.

## Colors
The palette is centered around a vibrant Mint Green primary, supported by Pale Yellow and Light Pink accents. 

- **Primary (Mint):** Used for key actions, progress indicators, and brand-defining moments.
- **Secondary (Yellow):** Used for subtle highlights and warning-state background washes.
- **Tertiary (Pink):** Used for expressive accents and soft secondary call-to-actions.
- **Neutral:** A deep charcoal is used for text to ensure legibility against the pastel backgrounds, while the background itself is a near-white mint tint to maintain the "fresh" feeling.
- **Surface Gradients:** Utilize the primary-to-tertiary gradient for large decorative areas or hero sections to create depth without visual clutter.

## Typography
The system uses **Manrope** exclusively to maintain a balanced, modern, and highly legible appearance. 

The scale relies on tight letter-spacing for headlines to create a compact, premium feel. Body text is given ample line height to ensure reading comfort. Labels use a semi-bold weight and slight tracking to distinguish them from body content, providing clear architectural signposts throughout the UI.

## Layout & Spacing
The design system utilizes a **Fluid Grid** with a 12-column structure for desktop and a 4-column structure for mobile. 

A strict 8px spatial rhythm is applied to all components. Negative space is used as a functional tool to group related elements, emphasizing a "less is more" philosophy. 
- **Desktop:** 64px side margins with 24px gutters.
- **Tablet:** 32px side margins with 20px gutters.
- **Mobile:** 16px side margins with 16px gutters.
Internal container padding should lean towards the 'Large' (48px) scale to maintain the airy aesthetic.

## Elevation & Depth
Hierarchy is established through **Tonal Layering** and **Soft Ambient Shadows**. Instead of traditional grey shadows, this system uses "tinted shadows"—extremely soft drops with a hint of the primary mint or secondary pink hue.

- **Level 0 (Base):** The mint-tinted background.
- **Level 1 (Cards):** White surfaces with a very subtle, 1px low-opacity border (#49EACE at 10% opacity).
- **Level 2 (Floating):** Used for menus and overlays, featuring a backdrop blur (12px) and a soft, diffused tinted shadow.
- **Interactive:** Elements should feel "lifted" when hovered, achieved by increasing shadow diffusion rather than darkness.

## Shapes
The shape language is defined by **Round Eight** logic, corresponding to the `Rounded` setting (0.5rem base). 

This approach softens the interface, making it feel approachable and organic. 
- **Standard Components:** 8px (0.5rem) corner radius.
- **Large Cards/Containers:** 16px (1rem) corner radius.
- **Outer Wrappers/Hero Sections:** 24px (1.5rem) corner radius.
- **Buttons:** While following the 8px rule, small utility chips may move toward pill-shapes for distinctiveness.

## Components
- **Buttons:** Primary buttons use a solid Mint (#49EACE) fill with white text. Secondary buttons use a Ghost style with a Mint border. All buttons use the 8px corner radius.
- **Chips:** Small, highly rounded (pill) indicators using the tertiary pink or secondary yellow backgrounds with dark neutral text for categorization.
- **Input Fields:** Minimalist design with a 1px border that glows Mint on focus. Backgrounds should be pure white to contrast against the tinted page surface.
- **Cards:** Use "Level 1" elevation. Content inside cards should follow the 24px internal padding rule (md spacing).
- **Progress Bars:** Use a gradient fill from Mint to Yellow to represent movement and growth.
- **Lists:** Separated by light, mint-tinted horizontal rules (1px) with ample vertical padding (16px) between items.