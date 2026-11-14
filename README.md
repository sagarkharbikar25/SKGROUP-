# ShopSphere • Mobile E-Commerce & Curated Catalog

> **Sankar Group Flutter Developer Internship Assignment (48-Hour Delivery)**  
> **Role:** Flutter Developer Intern  
> **Author:** Sagar Kharbikar  
> **Application:** ShopSphere (Warm Editorial Edition)

---

## 📱 Executive Summary

**ShopSphere** is a high-performance, responsive Flutter mobile application built for the **Sankar Group Flutter Developer Internship Assignment**. It delivers an editorial luxury e-commerce experience inspired by modern boutique design houses (Kinfolk, Aesop, SSENSE), featuring a complete end-to-end shopping workflow: animated splash entrance, secure user authentication, dynamic catalog discovery with real-time search and category filtering, interactive product details with multi-image gallery, persistent shopping bag with instant calculations and checkout, wishlist favorites, and an interactive account profile with dark/light mode switching.

The codebase adheres strictly to clean architecture principles, utilizing **Flutter Riverpod (Pure Dart, zero-codegen)**, **GoRouter with 5-branch StatefulShellRoute**, **Dio HTTP Client with interceptors**, **FlutterSecureStorage (Hardware-backed Android Keystore AES-256)**, and **SharedPreferences offline fallback caching**.

---

## 🏗️ Architecture & Branching Strategy

The repository follows a clean, structured multi-branch workflow:

| Branch | Purpose & Contents |
| :--- | :--- |
| **`main`** | **Production Submission Branch** — Stable, integrated release with clean history, release builds, and full documentation. |
| **`feature/test`** | **Live Emulator & Device Integration Branch** — Fully integrated testing branch with all features, cart flow, and Android launcher assets. |
| **`feature/frontend`** | **Presentation Layer Branch** — Design system tokens, custom vector widgets, themes, and screen layouts. |
| **`feature/backend`** | **Data & API Layer Branch** — Dio client, secure storage, repository implementations, Riverpod notifiers, and Postman API collection. |

---

## 🎯 Assignment Tasks Completed

### Task 1 – App Design & Setup (20%)
- [x] **Design Tokens**: Material 3 Warm Editorial palette (`#F5F0E8` paper, `#C2410C` terracotta vermilion, `#12100D` night paper, hairline borders, zero drop shadows).
- [x] **Bespoke Vector Brand Emblem**: Custom-drawn `ShopSphereEmblem` using `CustomPainter` featuring a rounded squircle base, celestial orbital ring, and serif monogram.
- [x] **Animated Splash Screen**: Staggered spring animations (`CurvedAnimation`), ambient radial backlights, sliding typography, and linear pulse indicator.
- [x] **Authentication Screens**: Responsive Login and Signup screens with real-time form validation.
- [x] **Screen Adaptability**: Tested across Android phone screen sizes using `LayoutBuilder` (adaptive 2/3/4 column grids and `SafeArea` insets).

### Task 2 – Core Screens (20%)
The application provides **7 fully functional screens** (exceeding the 4-screen minimum):
1. **Splash Screen**: Cinematic branded entrance with smooth session routing.
2. **Login / Signup Screens**: Authentication with secure password toggle, input validation, 1-tap demo auto-fill, and custom credential support.
3. **Home Dashboard**: Editorial header, curated hero spotlight card, dynamic discount math, and horizontal "Trending Now" carousel.
4. **Listing / Catalog Screen**: Real-time search query filtering, horizontal category chips with working "All" toggle, sort modal bottom sheet, pull-to-refresh, and infinite scroll pagination.
5. **Product Details Screen**: Multi-image carousel with dot indicators, Hero transition, stock counter, rating, interactive "Add to Bag", and direct bag shortcut.
6. **Shopping Bag / Cart Screen**: Dedicated cart page with item thumbnails, real-time `+` / `-` quantity adjustments, subtotal, promotional discount calculation, and checkout confirmation dialog.
7. **Saved / Wishlist Screen**: Persistent favorites collection with instant heart toggle.
8. **Account / Profile Screen**: User monogram avatar, verified buyer badge, interactive Dark Mode switch, Push Notifications toggle, Security Keystore dialog, About dialog, and working Sign Out flow.

### Task 3 – Functionality & Navigation (20%)
- [x] **Declarative Routing**: `GoRouter` with 5-branch `StatefulShellRoute` (`/home`, `/products`, `/cart`, `/favorites`, `/profile`) that preserves scroll positions and navigation state across tabs.
- [x] **Reliable Touch Targets**: Full-width `Expanded` + `InkWell` bottom navigation tabs with live Cart item badge count.
- [x] **Form Input Validation**: Required field checks, email format validation, and minimum password length constraints.
- [x] **Accurate Price Calculations**: Model-level `finalPrice` getter (`price * (1 - discount / 100)`) rounded strictly to 2 decimals, with original price struck through only when discounted.
- [x] **State Management**: Pure Riverpod (`StateNotifierProvider`) managing Auth, Theme, Catalog, Cart, and Favorites without slow build-runner codegen.

### Task 4 – Backend / API Integration (20%)
- [x] **REST API Integration**: Live connection to DummyJSON public API (`https://dummyjson.com`) via Dio.
- [x] **API Testing with Postman**: **For backend endpoint verification, contract testing, and request debugging, a complete Postman collection is provided at `docs/postman.json` and was used to test and validate all REST endpoints.**
- [x] **Dynamic Data Handling**: Fetches dynamic products, categories, search queries, details, and auth tokens.
- [x] **State Views**: Handled via `LoadingView` (with loaders), `ErrorView` (with "Try Again" retry callbacks), and `EmptyView` (with catalog navigation).
- [x] **Offline Resilience**: Automatic fallback to local cache (`SharedPreferences`) and bundled JSON assets (`assets/sample/products.json`) with an **"Offline Mode — Showing saved catalog data"** banner.

### Task 5 – Data Management (20%)
- [x] **Hardware-Backed Encryption**: Auth tokens stored securely via `FlutterSecureStorage` using Android Keystore AES-256.
- [x] **Data Persistence**: Theme mode (Light/Dark/System), cart contents, and saved favorites persisted locally via `SharedPreferences`.
- [x] **Code Organization**: Clean feature-first modular architecture:
  ```text
  lib/
  ├── core/                 # Shared infrastructure
  │   ├── constants/        # API endpoints and route keys
  │   ├── errors/           # Typed failure mapping
  │   ├── network/          # Dio client and interceptors
  │   ├── router/           # GoRouter configuration & shell branches
  │   ├── storage/          # SecureStore and PrefsStore
  │   ├── theme/            # Design tokens and M3 AppTheme
  │   └── widgets/          # Reusable buttons, text fields, emblem, state views
  └── features/             # Modular feature slices
      ├── auth/             # Login, signup, splash, auth controller & repository
      ├── cart/             # Cart notifier, cart item model, and cart screen
      ├── favorites/        # Wishlist repository, notifier, and screen
      ├── home/             # Editorial dashboard & trending spotlight
      ├── products/         # Product catalog, details, search/filter bar, cards
      └── profile/          # Account screen, settings, security & about modals
  ```

---

## 🚀 Getting Started & Setup Guide

### Prerequisites
- **Flutter SDK**: `^3.27.0` (or `≥ 3.0.0`)
- **Dart SDK**: `^3.6.0`
- **Android Studio** / **VS Code** with Flutter & Dart extensions
- Android Emulator or physical device (Android 8.0+ / API 26+)

### 1. Clone the Repository
```bash
git clone https://github.com/sagarkharbikar25/SKGROUP-.git
cd SKGROUP-
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run Static Analysis & Tests
```bash
# Verify 0 analysis issues
flutter analyze

# Execute test suite
flutter test
```

### 4. Run the Application in Debug Mode
Launch on your connected Android emulator or device:
```bash
flutter run
```

### 5. Build Production Release APK
To compile the standalone release APK for submission:
```bash
flutter build apk --release
```
The output APK will be generated at:
```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## 🧪 Testing & Demonstration Guide

### 1. Authentication Testing
- **1-Tap Demo Auto-Fill**: On the Login screen, tap anywhere on the **Demo Account (Tap to Fill)** card to automatically populate:
  - **Username:** `emilys`
  - **Password:** `emilyspass`
  - Tap **Sign In to ShopSphere** to authenticate via the live DummyJSON API.
- **Custom Credentials**: You may also enter any custom username/email (e.g. `test@shopsphere.com` with password `123456`) — the app creates a custom session seamlessly.
- **Sign Out**: Navigate to the **Profile** tab, tap **Sign Out**, and confirm in the dialog to clear credentials and return to Login.

### 2. Catalog, Search & Filter Testing
- **Search**: Type `"phone"`, `"laptop"`, or `"bed"` in the search bar to test real-time query filtering.
- **Category Filter**: Tap **Beauty**, **Fragrances**, or **Furniture** to filter items.
- **Clear Filter**: Tap the **All** chip at any time — it immediately highlights orange with a checkmark and reloads all products.
- **Sort**: Tap the filter/sort icon next to the search bar to sort by Price (Low to High / High to Low), Rating, or Title.

### 3. Shopping Bag & Checkout Testing
- From the Catalog or Home screen, tap any product to open **Product Details**.
- Tap **"Add to Bag"**:
  - The Cart tab on the bottom navigation bar immediately increments its badge counter.
  - A floating toast appears with a **"View Bag"** shortcut that dismisses automatically in 1.8 seconds.
- In the **Shopping Bag (`Cart`)** screen:
  - Test tapping `+` and `-` to adjust quantities; watch subtotal, discount, and total recalculate in real-time.
  - Tap the trash icon in the app bar to clear the bag.
  - Tap **"Checkout"** to trigger the order placement confirmation dialog.

### 4. Offline Resilience Testing
- Disable Wi-Fi/cellular on your test device/emulator.
- The app automatically catches the connection failure, loads the cached or bundled catalog, and displays an **"Offline Mode — Showing saved catalog data"** banner at the top of the Catalog.

---

## 🛠️ Packages Used

| Package | Purpose |
| :--- | :--- |
| `flutter_riverpod` | State management (reactive StateNotifier architecture) |
| `go_router` | Declarative routing with StatefulShellRoute |
| `dio` | HTTP networking client with custom auth & error interceptors |
| `flutter_secure_storage` | Hardware-backed encrypted key-value store for JWT tokens |
| `shared_preferences` | Local preferences for theme mode, cart, favorites, and offline cache |
| `cached_network_image` | High-performance image caching with skeleton shimmer placeholders |
| `intl` | Number and currency formatting |

---

## 📄 License & Attribution
Developed by **Sagar Kharbikar** for the **Sankar Group Flutter Developer Internship Assessment**.  
All rights reserved © 2026.
