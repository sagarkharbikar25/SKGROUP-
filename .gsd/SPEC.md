# SPEC.md — ShopSphere Product Catalog Specification

> **Status**: `FINALIZED`
> 
> ⚠️ **Planning Lock**: Requirements locked. Branch-based 3-stage delivery model enabled.

## Vision
ShopSphere is a robust, responsive Flutter product catalog application for the Sankar Group Internship evaluation. The project is delivered across a structured 3-branch workflow:
1. `feature/frontend`: Complete responsive UI, theming, navigation, and presentation layer backed by local sample models.
2. `feature/backend`: Complete data layer (Dio client, secure storage, repositories, Riverpod notifiers, offline fallback) and `docs/postman.json` for backend API verification.
3. `feature/test`: Full integration of frontend and backend, comprehensive test suites (unit, widget, integration), release APK build, and submission pack.

## Core Architectural Rules & Branch Workflow
1. **Branch Sequence**:
   - `main`: Project bootstrap, contracts (models, abstract repos), dependencies, Android manifest.
   - `feature/frontend`: Branch from `main`. Implements all screens, themes, layouts, and user interactions with local sample data.
   - `feature/backend`: Branch from `main`. Implements Dio networking, token security, repositories, caching, Riverpod state management, and `docs/postman.json`.
   - `feature/test`: Branch from `main` or merge point. Integrates frontend + backend, tests end-to-end functionality, verifies offline resilience, compiles release APK, and produces demo artifacts.
2. **Backend Verification**: `docs/postman.json` authored during the backend phase covering all DummyJSON endpoints with sample queries and response fixtures.
3. **Lean Storage**: `flutter_secure_storage` for auth tokens; `shared_preferences` for theme, queries, and JSON cache fallback.
4. **Declarative State & Navigation**: `flutter_riverpod` (AsyncNotifier / FutureProvider, no codegen) + `go_router` with auth guard.
5. **Rock-solid Android Manifest**: Add `INTERNET` permission to `android/app/src/main/AndroidManifest.xml` during Phase 0 so release APK works anywhere.

## Evaluation Criteria Mapping (100% Total)
- **UI Design & Responsiveness (20%)**: Material 3, custom theme, adaptive layout (phone/tablet), dark mode (`feature/frontend`).
- **Flutter/Dart Code Quality (20%)**: Clean architecture (Presentation / Application / Data), linted, zero warnings (`feature/frontend` & `feature/backend`).
- **Functionality & Navigation (20%)**: Guarded `go_router`, input validation, debounced search, filter/sort (`feature/frontend` & `feature/test`).
- **API & Data Integration (20%)**: Dio interceptors, unified `AppFailure`, caching with offline fallback, `postman.json` (`feature/backend`).
- **Code Organization & Demo (20%)**: 3-branch git history, test suite, README with demo script, release APK (`feature/test`).
