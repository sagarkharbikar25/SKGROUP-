---
phase: 3
branch: feature/test
wave: 3
gap_closure: false
---

# Phase 3: Integration, Testing & Submission Pack (`feature/test`)

## Objective
On `feature/test`, merge `feature/frontend` and `feature/backend`. Connect the presentation UI to real Riverpod providers, verify end-to-end user flows (auth, search, category filter, details, favorites, offline banner, logout), run comprehensive automated test suites (unit, widget), achieve zero `flutter analyze` warnings, compile the release APK, and produce the submission documentation.

## Context
Load these files for context:
- .gsd/SPEC.md
- docs/postman.json
- android/app/src/main/AndroidManifest.xml

## Tasks

<task type="auto">
  <name>Merge Frontend and Backend on feature/test</name>
  <files>
    lib/main.dart
    lib/app.dart
  </files>
  <action>
    1. Check out `feature/test`.
    2. Merge `feature/frontend` and `feature/backend`.
    3. Wire UI presentation widgets to real Riverpod providers:
       - Bind `LoginScreen` to `authControllerProvider`.
       - Bind `GoRouter` redirect to `authControllerProvider` auth state.
       - Bind `ProductsScreen` to `productListNotifierProvider` and `categoriesProvider`.
       - Bind `ProductCard` and `ProductDetailsScreen` to `favoritesNotifierProvider`.
       - Bind `ProfileScreen` and `App` to `themeControllerProvider`.
    4. Connect offline alert banner ("Showing saved data") when provider reports `isStale == true`.
  </action>
  <verify>flutter analyze</verify>
  <done>Frontend and backend integrated cleanly with zero compilation errors.</done>
</task>

<task type="auto">
  <name>Implement Comprehensive Unit and Widget Tests</name>
  <files>
    test/core/validators_test.dart
    test/features/products/product_model_test.dart
    test/features/products/product_repository_test.dart
    test/features/auth/login_screen_test.dart
    test/features/products/products_screen_test.dart
  </files>
  <action>
    1. Unit tests: Email, username, and password validators (`validators_test.dart`).
    2. Model tests: `Product.fromJson` handling missing fields and numeric strings safely.
    3. Repository tests: Mock Dio client simulating 200 success, 401 unauthorized, timeout, and offline fallback.
    4. Widget tests:
       - Login screen renders input fields, shows validation error on empty submit, fills test credentials.
       - Products screen displays loading shimmer, renders list on data, shows error view with retry button.
  </action>
  <verify>flutter test</verify>
  <done>All automated tests execute and pass.</done>
</task>

<task type="auto">
  <name>Perform Static Analysis and Linting Verification</name>
  <files>
    analysis_options.yaml
  </files>
  <action>
    1. Run `flutter analyze`.
    2. Resolve all linter warnings, dead imports, and enforce `const` constructors where possible.
  </action>
  <verify>flutter analyze</verify>
  <done>flutter analyze passes with "No issues found!".</done>
</task>

<task type="auto">
  <name>Compile and Verify Release APK</name>
  <files>
    android/app/src/main/AndroidManifest.xml
  </files>
  <action>
    1. Verify `android.permission.INTERNET` is in `android/app/src/main/AndroidManifest.xml`.
    2. Execute `flutter build apk --release` (or `--split-per-abi`).
    3. Confirm generated APK file in `build/app/outputs/flutter-apk/`.
  </action>
  <verify>flutter build apk --release</verify>
  <done>Release APK generated and ready for reviewer installation.</done>
</task>

<task type="auto">
  <name>Assemble README and Final Submission Pack</name>
  <files>
    README.md
    docs/DEMO_SCRIPT.md
  </files>
  <action>
    1. Complete `README.md`:
       - Architecture diagram (Presentation / Application / Data).
       - 3-branch workflow documentation (`feature/frontend`, `feature/backend`, `feature/test`).
       - Test credentials (`emilys` / `emilyspass`).
       - Setup and run steps (`flutter pub get`, `flutter run`).
       - Postman collection location (`docs/postman.json`).
       - Offline fallback and error handling explanation.
    2. Write `docs/DEMO_SCRIPT.md`: Step-by-step 2.5 min walkthrough script.
    3. Merge `feature/test` into `main` and tag `v1.0.0`.
  </action>
  <verify>git log --oneline --graph</verify>
  <done>Submission pack complete, merged to main, tagged v1.0.0.</done>
</task>

## Must-Haves
- [ ] Integrated app running seamlessly on real data and offline fallback
- [ ] Green test suite (`flutter test`) and clean linter (`flutter analyze`)
- [ ] Release APK compiled and verified
- [ ] `docs/postman.json` ready for reviewer backend check
- [ ] Final `README.md` and demo script ready

