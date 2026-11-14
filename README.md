# ShopSphere — Flutter Product Catalog Application

> **Sankar Group Internship Assignment (48-Hour Delivery)**
> 
> A modern, responsive Flutter product catalog application engineered with **Riverpod**, **GoRouter**, **Dio**, **FlutterSecureStorage**, and an **offline fallback cache**, delivered across an audited **3-branch workflow** (`feature/frontend`, `feature/backend`, and `feature/test`).

---

## 📸 Screenshots & Highlights
- **Material 3 Design**: Custom typography, primary indigo seed, adaptive light/dark theme.
- **Responsive Layout**: Adapts between phone (2 columns) and tablet/desktop (3–4 columns) using `LayoutBuilder`.
- **Authentication**: JWT token storage in encrypted `FlutterSecureStorage`, session auto-restore on launch.
- **Product Catalog**: 400ms debounced search, category filtering chips, price/rating sort bottom sheet, infinite scrolling pagination.
- **Product Details**: Multi-image carousel with indicators, Hero transition, stock alerts, and favorite toggle.
- **Offline Resilience**: Automatic fallback to local cache and bundled sample assets (`assets/sample/products.json`) with an offline indicator banner.
- **Submission Pack**: Includes Postman collection (`docs/postman.json`), automated tests, and `INTERNET` permissions configured in the main manifest.

---

## 🚀 Quick Start Guide

### Prerequisites
- Flutter SDK (≥ 3.0.0)
- Dart SDK (≥ 3.0.0)
- Android Studio / VS Code / Android device or emulator

### 1. Clone & Install Dependencies
```bash
git clone <repo-url>
cd SKGROUP-
flutter pub get
```

### 2. Verify Static Analysis & Tests
```bash
# Check zero linter warnings
flutter analyze

# Run unit and widget test suite
flutter test
```

### 3. Run the App
```bash
flutter run
```
To run against an alternate backend endpoint:
```bash
flutter run --dart-define=BASE_URL=https://dummyjson.com
```

### 4. Build Release APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔑 Test Credentials (DummyJSON)

| Role | Username | Password | Notes |
|---|---|---|---|
| **Demo User** | `emilys` | `emilyspass` | Active account with full profile (`/auth/me`) |
| **Quick Fill** | *Tap "Auto-fill"* | *Tap "Auto-fill"* | Single tap on the Login Screen automatically inputs test credentials |

*Note on Signup: DummyJSON simulates user registration via `POST /users/add`. Newly created users are assigned an ID in the response but are not persisted permanently on DummyJSON's servers.*

---

## 🏗️ Architecture

Clean Architecture structured by feature:

```
lib/
├── app.dart                          # MaterialApp.router, AppTheme, ThemeController
├── main.dart                         # Entry point, SharedPreferences override
├── core/
│   ├── constants/api_constants.dart  # Endpoints, timeouts, default base URL
│   ├── errors/app_failure.dart       # Sealed AppFailure hierarchy (Network, Timeout, 401, Server)
│   ├── network/                      # Dio client, AuthInterceptor, ErrorInterceptor
│   ├── router/app_router.dart        # GoRouter, auth guards, shell navigation
│   ├── storage/                      # SecureStore (token), PrefsStore (cache & theme)
│   ├── theme/                        # AppTheme (Light & Dark M3), ThemeController
│   ├── utils/debouncer.dart          # 400ms search debouncer
│   └── widgets/                      # AppButton, AppTextField, ProductCard, StateViews
└── features/
    ├── auth/                         # Data, Application, Presentation (Splash, Login, Signup)
    ├── home/                         # Featured banner, quick navigation
    ├── products/                     # Catalog, debounced search, category filter, details
    ├── favorites/                    # Local persistence, saved items screen
    └── profile/                      # User profile, theme mode switcher, logout
```

---

## 🌿 Git 3-Branch Workflow

The project was constructed across three dedicated feature branches:

1. **`feature/frontend`**:
   - Material 3 theme & reusable UI primitives.
   - Declarative `GoRouter` shell route with bottom navigation (Home, Products, Favorites, Profile).
   - Form-validated Splash, Login, and Signup screens.
   - Responsive Catalog grid, sort sheet, and Product Details screen with Hero carousel.
2. **`feature/backend`**:
   - Dio client with 10s timeouts, Bearer token injection, and typed `AppFailure` interceptor.
   - Encrypted token persistence (`FlutterSecureStorage`).
   - Repositories with automatic offline fallback to `assets/sample/products.json`.
   - Riverpod state notifiers (`AuthController`, `ProductListNotifier`, `FavoritesNotifier`, `ThemeController`).
   - **`docs/postman.json`**: Complete Postman collection covering all endpoints.
3. **`feature/test`**:
   - Integrated frontend presentation with live Riverpod providers.
   - Automated unit tests (`validators_test.dart`, `models_test.dart`, `auth_controller_test.dart`).
   - Verified Android manifest `INTERNET` permission.
   - Clean static analysis and release APK compilation.

---

## 📬 Postman Backend Collection

A ready-to-import Postman v2.1 collection is located at:
```
docs/postman.json
```
Endpoints covered:
- `POST /auth/login` (Includes automated test script verifying 200 and saving JWT token)
- `GET /auth/me` (Authenticated user profile)
- `POST /users/add` (Simulated user creation)
- `GET /products?limit=20&skip=0` (Paginated catalog)
- `GET /products/search?q=phone` (Debounced search endpoint)
- `GET /products/categories` (Category list)
- `GET /products/category/smartphones` (Category filtering)
- `GET /products?sortBy=price&order=asc` (Sorting)
- `GET /products/1` (Single product details)

---

## 💡 Key Architectural Decisions & Trade-offs

| Decision | Selection | Justification |
|---|---|---|
| **State Management** | **Riverpod** (`flutter_riverpod`, no codegen) | Compile-time safety, easy overriding in tests, zero `build_runner` failures. |
| **Networking** | **Dio + Interceptors** | Automatic Bearer injection, uniform timeout and error mapping into `AppFailure`. |
| **Offline Cache** | **SharedPreferences + Asset Fallback** | Instant local persistence for favorites, theme, and catalog cache without binary database overhead. |
| **Security** | **FlutterSecureStorage** | Auth tokens are encrypted in hardware-backed storage (Android Keystore). |
