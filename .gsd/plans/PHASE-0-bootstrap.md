---
phase: 0
branch: main
wave: 1
gap_closure: false
---

# Phase 0: Project Bootstrap & Base Contracts

## Objective
Initialize the Flutter project on `main`, configure core dependencies (`pubspec.yaml`), add the critical `android.permission.INTERNET` permission to `AndroidManifest.xml`, establish models (`Product`, `AppUser`, `Category`, `AppFailure`), and bundle `assets/sample/products.json`. Once committed, branch `feature/frontend`, `feature/backend`, and `feature/test`.

## Context
Load these files for context:
- .gsd/SPEC.md
- .gsd/ROADMAP.md
- plan.md

## Tasks

<task type="auto">
  <name>Scaffold Flutter app and install core dependencies</name>
  <files>
    pubspec.yaml
    android/app/src/main/AndroidManifest.xml
    assets/sample/products.json
  </files>
  <action>
    1. Initialize Flutter project with package name `com.sankar.shopsphere`.
    2. Add dependencies to `pubspec.yaml`:
       - `flutter_riverpod: ^2.5.1`
       - `go_router: ^14.2.0`
       - `dio: ^5.4.3+1`
       - `flutter_secure_storage: ^9.2.2`
       - `shared_preferences: ^2.2.3`
       - `cached_network_image: ^3.3.1`
       - `intl: ^0.19.0`
       - dev: `flutter_lints: ^4.0.0`, `mocktail: ^1.0.4`
    3. Add `<uses-permission android:name="android.permission.INTERNET"/>` to `android/app/src/main/AndroidManifest.xml`.
    4. Register assets in `pubspec.yaml` and seed `assets/sample/products.json`.
  </action>
  <verify>flutter pub get</verify>
  <done>Dependencies resolve cleanly and manifest includes INTERNET permission.</done>
</task>

<task type="auto">
  <name>Define Core Models and Error Type Contracts</name>
  <files>
    lib/core/errors/app_failure.dart
    lib/features/auth/data/models/user_model.dart
    lib/features/products/data/models/product_model.dart
    lib/features/products/data/models/category_model.dart
  </files>
  <action>
    1. Implement sealed `AppFailure` (`NetworkFailure`, `TimeoutFailure`, `UnauthorizedFailure`, `ServerFailure`, `UnknownFailure`).
    2. Implement `AppUser` model with `fromJson` and `toJson`.
    3. Implement `Product` and `Category` models with safe null parsing.
  </action>
  <verify>flutter test test/models_test.dart</verify>
  <done>Models deserialize JSON without null exceptions.</done>
</task>

<task type="auto">
  <name>Commit baseline and create feature branches</name>
  <files>
    .git
  </files>
  <action>
    1. Commit bootstrap to `main`: `chore: bootstrap project and data contracts`.
    2. Create branches:
       - `git checkout -b feature/frontend`
       - `git checkout main && git checkout -b feature/backend`
       - `git checkout main && git checkout -b feature/test`
    3. Switch to `feature/frontend` to start Phase 1.
  </action>
  <verify>git branch -a</verify>
  <done>All three feature branches created cleanly from main contract.</done>
</task>

## Must-Haves
- [ ] `android.permission.INTERNET` configured in main manifest
- [ ] Models and error contracts defined
- [ ] Branches `feature/frontend`, `feature/backend`, `feature/test` ready

