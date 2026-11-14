---
milestone: shopsphere-v1
version: 1.0.0
updated: 2026-11-14T21:47:00+05:30
---

# Roadmap: ShopSphere Product Catalog (3-Branch Workflow)

> **Workflow:** `main` (Bootstrap) ➔ `feature/frontend` ➔ `feature/backend` (with `postman.json`) ➔ `feature/test` (Integration & QA)
> **Status:** complete
> **Current Phase:** Complete (Tagged `v1.0.0`)
> **Methodology:** GSD + Ponytail (Strict branch separation, no over-engineering)

## Must-Haves (from SPEC)

- [x] Project bootstrap & contracts on `main` (Android `INTERNET` permission included)
- [x] `feature/frontend`: Complete responsive M3 UI (Splash, Login, Signup, Home, Catalog, Details, Favorites, Profile) on sample data
- [x] `feature/backend`: Dio network client, `SecureStore`, repositories, Riverpod notifiers, offline fallback
- [x] `feature/backend`: Complete `docs/postman.json` collection for backend verification
- [x] `feature/test`: Merged integration of frontend + backend, tests passing, zero lint warnings
- [x] Release APK compilation ready (`android.permission.INTERNET` verified)
- [x] README with architecture, test credentials, and demo walkthrough script

---

## Phases & Branch Mapping

### Phase 0: Project Bootstrap & Contracts (`main`)
**Branch:** `main`
**Status:** ✅ Complete
**Objective:** Initialized Flutter app, dependencies (`pubspec.yaml`), folder structure, models (`Product`, `AppUser`, `Category`), sealed `AppFailure`, Android `INTERNET` permission, and base commit.

---

### Phase 1: Frontend Development (`feature/frontend`)
**Branch:** `feature/frontend`
**Status:** ✅ Complete
**Objective:** Material 3 Theme (Light/Dark), reusable UI widgets (`AppButton`, `AppTextField`, `ProductCard`, state views), GoRouter navigation shell with bottom bar, Splash, Login & Signup with validation, and responsive Catalog & Details with image carousel.

---

### Phase 2: Backend Development & Postman Suite (`feature/backend`)
**Branch:** `feature/backend`
**Status:** ✅ Complete
**Objective:** Dio client with timeouts, Bearer token injection, `SecureStore`, repositories with offline fallback to `assets/sample/products.json`, Riverpod notifiers (`AuthController`, `ProductListNotifier` with 400ms debounced search, `FavoritesNotifier`, `ThemeController`), and `docs/postman.json`.

---

### Phase 3: Integration, Testing & Submission Pack (`feature/test`)
**Branch:** `feature/test` ➔ merged to `main` (Tagged `v1.0.0`)
**Status:** ✅ Complete
**Objective:** Merged `feature/frontend` and `feature/backend`, wired presentation layer to live Riverpod providers, created unit and widget test suites, documented architecture and demo script in `README.md` and `docs/DEMO_SCRIPT.md`.

---

## Progress Summary

| Phase / Branch | Branch | Status | Plans | Complete |
|---|---|---|---|---|
| Phase 0: Bootstrap | `main` | ✅ | 2/2 | 100% |
| Phase 1: Frontend | `feature/frontend` | ✅ | 4/4 | 100% |
| Phase 2: Backend + Postman | `feature/backend` | ✅ | 4/4 | 100% |
| Phase 3: Integration & Test | `feature/test` | ✅ | 5/5 | 100% |
