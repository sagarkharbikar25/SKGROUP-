---
milestone: shopsphere-v1
version: 1.0.0
updated: 2026-11-14T21:37:00+05:30
---

# Roadmap: ShopSphere Product Catalog (3-Branch Workflow)

> **Workflow:** `main` (Bootstrap) ➔ `feature/frontend` ➔ `feature/backend` (with `postman.json`) ➔ `feature/test` (Integration & QA)
> **Status:** planning
> **Methodology:** GSD + Ponytail (Strict branch separation, no over-engineering)

## Must-Haves (from SPEC)

- [ ] Project bootstrap & contracts on `main` (Android `INTERNET` permission included)
- [ ] `feature/frontend`: Complete responsive M3 UI (Splash, Login, Signup, Home, Catalog, Details, Favorites, Profile) on sample data
- [ ] `feature/backend`: Dio network client, `SecureStore`, repositories, Riverpod notifiers, offline fallback
- [ ] `feature/backend`: Complete `docs/postman.json` collection for backend verification
- [ ] `feature/test`: Merged integration of frontend + backend, tests passing, zero lint warnings
- [ ] Release APK compiled and verified on device
- [ ] README with architecture, test credentials, and demo walkthrough script

---

## Phases & Branch Mapping

### Phase 0: Project Bootstrap & Contracts (`main`)
**Branch:** `main`
**Objective:** Initialize Flutter app, add dependencies, create folder structure, write models and abstract contracts, set Android INTERNET permission, and commit base before branching.

**Plans:**
- [ ] Plan 0.1: Flutter project scaffold, dependencies (`pubspec.yaml`), and `AndroidManifest.xml`
- [ ] Plan 0.2: Core models (`Product`, `AppUser`, `Category`), `AppFailure`, and sample JSON fixtures

---

### Phase 1: Frontend Development (`feature/frontend`)
**Branch:** `feature/frontend` (branch from `main`)
**Objective:** Build complete responsive presentation layer, Material 3 theme (Light/Dark), GoRouter with bottom navigation shell, and all screens rendered using sample models.

**Plans:**
- [ ] Plan 1.1: Material 3 Theme (Light/Dark) & reusable UI widgets (`AppButton`, `AppTextField`, `ProductCard`, state views)
- [ ] Plan 1.2: GoRouter navigation shell with bottom bar (Home, Products, Favorites, Profile)
- [ ] Plan 1.3: Auth presentation: Splash, Login (with form validation), and Signup screens
- [ ] Plan 1.4: Catalog & Details UI: Search bar, category chips, sort sheet, responsive grid (phone/tablet), image carousel

---

### Phase 2: Backend Development & Postman Suite (`feature/backend`)
**Branch:** `feature/backend` (branch from `main`)
**Objective:** Build data layer with Dio HTTP client, secure token storage, repositories, Riverpod notifiers, offline cache fallback, and author `docs/postman.json`.

**Plans:**
- [ ] Plan 2.1: Dio client with `AuthInterceptor`, `ErrorInterceptor`, and `SecureStore` (token management)
- [ ] Plan 2.2: Repositories (`AuthRepository`, `ProductRepository` with asset fallback, `FavoritesRepository`)
- [ ] Plan 2.3: Riverpod notifiers (`AuthController`, `ProductListNotifier` with 400ms debounced search, `FavoritesNotifier`, `ThemeController`)
- [ ] Plan 2.4: Backend test collection: `docs/postman.json` covering all auth and product endpoints with sample responses

---

### Phase 3: Integration, Testing & Submission Pack (`feature/test`)
**Branch:** `feature/test` (branch from `main`, merge `feature/frontend` and `feature/backend`)
**Objective:** Integrate frontend presentation with live backend providers, verify end-to-end flows, execute unit and widget test suites, compile release APK, and finalize documentation.

**Plans:**
- [ ] Plan 3.1: Integration: wire presentation layer to live Riverpod providers; verify loading, error, empty, and offline banner
- [ ] Plan 3.2: Automated test suite: unit tests (validators, models, error mapping) & widget tests (login, catalog)
- [ ] Plan 3.3: Static analysis cleanup (`flutter analyze` with 0 warnings)
- [ ] Plan 3.4: Release APK compilation (`flutter build apk --release`)
- [ ] Plan 3.5: Final README, screenshot set, and demo script; merge to `main` and tag `v1.0.0`

---

## Progress Summary

| Phase / Branch | Branch | Status | Plans | Complete |
|---|---|---|---|---|
| Phase 0: Bootstrap | `main` | ⬜ | 0/2 | 0% |
| Phase 1: Frontend | `feature/frontend` | ⬜ | 0/4 | 0% |
| Phase 2: Backend + Postman | `feature/backend` | ⬜ | 0/4 | 0% |
| Phase 3: Integration & Test | `feature/test` | ⬜ | 0/5 | 0% |

---

## Timeline (48-Hour Plan)

| Timeline | Branch Activity | Checkpoint |
|---|---|---|
| **H0–H4** | Phase 0 on `main` | Bootstrap committed, branches created |
| **H4–H16** | Phase 1 on `feature/frontend` | Complete UI verified on mock data |
| **H16–H28** | Phase 2 on `feature/backend` | Backend live + `postman.json` verified |
| **H28–H40** | Phase 3 on `feature/test` | Full integration, tests green, release APK |
| **H40–H44** | Final Polish on `main` | Merge, README, screenshots, tag `v1.0.0` |
| **H44–H48** | Final Review Buffer | Reviewer submission |
