---
phase: 1
branch: feature/frontend
wave: 2
gap_closure: false
---

# Phase 1: Frontend Development (`feature/frontend`)

## Objective
On `feature/frontend`, construct the full presentation layer: Material 3 theming (Light/Dark), reusable widgets, Splash, Login & Signup with form validation, declarative GoRouter with bottom navigation shell, responsive Product Catalog (with search bar, category chips, sort sheet, responsive 2/3/4 grid), Product Details with image carousel, Favorites screen, and Profile screen using local sample data.

## Context
Load these files for context:
- .gsd/SPEC.md
- lib/features/products/data/models/product_model.dart
- assets/sample/products.json

## Tasks

<task type="auto">
  <name>Build Material 3 Theme & Shared UI Components</name>
  <files>
    lib/core/theme/app_theme.dart
    lib/core/widgets/app_button.dart
    lib/core/widgets/app_text_field.dart
    lib/core/widgets/state_views.dart
    lib/features/products/presentation/widgets/product_card.dart
  </files>
  <action>
    1. Define `AppTheme` with Material 3, custom seed color, typography, light & dark themes.
    2. Build `AppButton` (min height 48dp, loading indicator, disabled states).
    3. Build `AppTextField` (prefix/suffix icon, password toggle, clear button, inline validation).
    4. Build `LoadingView` (shimmer skeletons), `ErrorView(onRetry)`, and `EmptyView(message)`.
    5. Build `ProductCard` (image, title, price, discount badge, rating, favorite icon).
  </action>
  <verify>flutter analyze lib/core/widgets</verify>
  <done>Theme and shared widgets compile cleanly with zero layout overflow.</done>
</task>

<task type="auto">
  <name>Implement GoRouter Navigation Shell</name>
  <files>
    lib/core/router/app_router.dart
    lib/core/widgets/scaffold_with_nav_bar.dart
  </files>
  <action>
    1. Build `GoRouter` shell route with bottom navigation bar:
       - Tab 0: Home / Catalog (`/home`)
       - Tab 1: Products Listing (`/products`)
       - Tab 2: Favorites (`/favorites`)
       - Tab 3: Profile (`/profile`)
    2. Add routes for `/splash`, `/login`, `/signup`, `/products/:id`.
  </action>
  <verify>flutter analyze lib/core/router</verify>
  <done>Navigation shell switches tabs and handles route transitions.</done>
</task>

<task type="auto">
  <name>Build Splash, Login, and Signup Screens</name>
  <files>
    lib/features/auth/presentation/splash_screen.dart
    lib/features/auth/presentation/login_screen.dart
    lib/features/auth/presentation/signup_screen.dart
  </files>
  <action>
    1. Build `SplashScreen`: animated branding, 1.2s delay, transitions to `/login` or `/home`.
    2. Build `LoginScreen`: Form key, email/username validation, password validation, demo credential chips (`emilys` / `emilyspass`) for one-tap auto-fill.
    3. Build `SignupScreen`: Client-side validation, calls simulated signup, navigates to login.
  </action>
  <verify>flutter analyze lib/features/auth/presentation</verify>
  <done>Auth screens render cleanly with form validation feedback.</done>
</task>

<task type="auto">
  <name>Build Responsive Product Catalog & Product Details Screens</name>
  <files>
    lib/features/products/presentation/products_screen.dart
    lib/features/products/presentation/widgets/search_filter_bar.dart
    lib/features/products/presentation/widgets/sort_bottom_sheet.dart
    lib/features/products/presentation/product_details_screen.dart
    lib/features/favorites/presentation/favorites_screen.dart
    lib/features/profile/presentation/profile_screen.dart
  </files>
  <action>
    1. Build `SearchFilterBar` (search text field, category chips).
    2. Build `SortBottomSheet` (sort by price low-high, high-low, rating).
    3. Build `ProductsScreen` with `LayoutBuilder`: 2 columns on phone, 3/4 on tablet.
    4. Build `ProductDetailsScreen`: image carousel with indicators, Hero animation from card, pricing, specs, stock tag, favorite toggle button.
    5. Build `FavoritesScreen` (empty state and saved item grid).
    6. Build `ProfileScreen` (user avatar, theme switcher toggle, logout action).
  </action>
  <verify>flutter analyze lib/features</verify>
  <done>All screens navigable with sample data, responsive on both phone and tablet viewports.</done>
</task>

## Must-Haves
- [ ] Material 3 Theme with Light and Dark modes
- [ ] Splash, Login, and Signup forms with validation
- [ ] Responsive Catalog adapting to phone and tablet
- [ ] Product Details with image carousel and Hero animation
- [ ] Commit all work to `feature/frontend`

