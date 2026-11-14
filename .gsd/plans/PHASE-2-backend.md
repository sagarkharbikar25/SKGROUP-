---
phase: 2
branch: feature/backend
wave: 2
gap_closure: false
---

# Phase 2: Backend Development & Postman Suite (`feature/backend`)

## Objective
On `feature/backend`, construct the complete data and application layers: Dio client with auth & error interceptors, secure token storage (`SecureStore`), repositories with automatic offline asset fallback, Riverpod notifiers (`AuthController`, `ProductListNotifier` with 400ms debouncer, `FavoritesNotifier`, `ThemeController`), and the comprehensive `docs/postman.json` collection testing all DummyJSON endpoints.

## Context
Load these files for context:
- .gsd/SPEC.md
- lib/features/products/data/models/product_model.dart
- assets/sample/products.json

## Tasks

<task type="auto">
  <name>Implement Dio Client, Interceptors, and Secure Storage</name>
  <files>
    lib/core/network/dio_client.dart
    lib/core/network/auth_interceptor.dart
    lib/core/network/error_interceptor.dart
    lib/core/storage/secure_store.dart
    lib/core/storage/prefs_store.dart
  </files>
  <action>
    1. Implement `DioClient` with 10s connect/receive timeouts, base URL `https://dummyjson.com` (overridable via `--dart-define=BASE_URL`).
    2. Implement `AuthInterceptor`: automatically injects Bearer token from `SecureStore`.
    3. Implement `ErrorInterceptor`: transforms `DioException` (connection error, timeout, 401, 500) into typed `AppFailure`.
    4. Implement `SecureStore` (wrapping `FlutterSecureStorage` for tokens).
    5. Implement `PrefsStore` (wrapping `SharedPreferences` for theme mode and offline cache).
  </action>
  <verify>flutter analyze lib/core/network lib/core/storage</verify>
  <done>Network and storage primitives configured cleanly.</done>
</task>

<task type="auto">
  <name>Implement Repositories with Offline Fallback</name>
  <files>
    lib/features/auth/data/repositories/auth_repository.dart
    lib/features/products/data/repositories/product_repository.dart
    lib/features/favorites/data/repositories/favorites_repository.dart
  </files>
  <action>
    1. Implement `AuthRepository`:
       - `login(username, password)` ➔ `POST /auth/login` (stores token in `SecureStore`).
       - `getCurrentUser()` ➔ `GET /auth/me`.
       - `logout()` ➔ clears `SecureStore`.
    2. Implement `ProductRepository`:
       - `getProducts({skip, limit, category, search, sortBy, order})`.
       - Write-through cache to `PrefsStore`.
       - Fallback flow: on network/timeout error, read cache; if cache is empty, read `assets/sample/products.json` and set `isStale: true`.
       - `getCategories()` and `getProductById(id)`.
    3. Implement `FavoritesRepository`:
       - `loadFavorites()` / `saveFavorites(list)` via `PrefsStore` JSON string serialization.
  </action>
  <verify>flutter test test/features/products/product_repository_test.dart</verify>
  <done>Repositories return live data and fall back to local assets when offline.</done>
</task>

<task type="auto">
  <name>Implement Riverpod Notifiers with Search Debouncing</name>
  <files>
    lib/features/auth/application/auth_controller.dart
    lib/features/products/application/product_list_notifier.dart
    lib/features/favorites/application/favorites_notifier.dart
    lib/core/theme/theme_controller.dart
    lib/core/utils/debouncer.dart
  </files>
  <action>
    1. Implement `Debouncer` (400ms duration).
    2. Implement `AuthController` (`AsyncNotifier<AuthState>`): handles login, cold-start session restore, logout, and simulated signup.
    3. Implement `ProductListNotifier` (`AsyncNotifier<ProductCatalogState>`):
       - Manages pagination (`skip`, `limit`, `hasMore`).
       - `search(query)` debounced with cancelation of stale queries.
       - `filterByCategory(category)` and `setSort(sortBy, order)`.
       - Pull-to-refresh and infinite scroll `loadMore()`.
       - Exposes `isStale` flag for UI offline banner.
    4. Implement `FavoritesNotifier` (`Notifier<List<Product>>`) with toggle and lookup.
    5. Implement `ThemeController` (`Notifier<ThemeMode>`) with persistent storage.
  </action>
  <verify>flutter analyze lib/features</verify>
  <done>Riverpod application state controllers compile cleanly.</done>
</task>

<task type="auto">
  <name>Create Backend Postman Collection (postman.json)</name>
  <files>
    docs/postman.json
  </files>
  <action>
    1. Create standard Postman Collection v2.1 in `docs/postman.json` testing:
       - `POST /auth/login` (body: `emilys` / `emilyspass`, test script asserting 200 and token presence)
       - `GET /auth/me` (header: `Authorization: Bearer {{token}}`, test script asserting user id and email)
       - `POST /users/add` (simulated signup test)
       - `GET /products?limit=20&skip=0` (asserting `products` array and `total` count)
       - `GET /products/search?q=phone` (asserting search results)
       - `GET /products/categories` (asserting category list)
       - `GET /products/category/smartphones` (asserting category items)
       - `GET /products?sortBy=price&order=asc` (asserting sorting)
       - `GET /products/1` (asserting single product details)
    2. Include collection environment variables (`baseUrl: https://dummyjson.com`, `token`).
  </action>
  <verify>Validate docs/postman.json syntax</verify>
  <done>Postman collection ready for backend API verification.</done>
</task>

## Must-Haves
- [ ] Token stored securely in `FlutterSecureStorage`
- [ ] Repositories support live network + offline fallback
- [ ] Search debouncing (400ms) with pagination
- [ ] `docs/postman.json` created and verified
- [ ] Commit all work to `feature/backend`

