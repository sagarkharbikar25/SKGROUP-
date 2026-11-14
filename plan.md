# plan.md — Flutter Internship Assignment (Sankar Group, 48 hrs)

> Working title: **ShopSphere** (rename to a Sankar Group brand if you pick one). A product catalog app: auth, dashboard, searchable/filterable listing, details, favorites, profile.
> Constraint: **no deployment possible** → the app must work for a reviewer who only has the repo/APK. Everything below is designed around that.

---

## 1. Key decisions (with trade-offs)

| Decision | Choice | Why | Trade-off accepted |
|---|---|---|---|
| Data source | **DummyJSON public API** as primary | Hosted, has auth + products + search + categories + pagination, so the APK works anywhere with zero hosting | Signup is simulated (`/users/add` does not persist). Documented in README |
| "Own backend" | **Stretch only**: small local FastAPI/Node mock, switchable via `--dart-define=BASE_URL` | Reviewer can't reach a local server, so it can't be the default | Skipped unless ahead of schedule |
| Offline / API-down fallback | Local JSON assets + Hive cache | Satisfies "use structured local sample data if backend isn't possible" and keeps the demo alive if the API is slow | Slightly more code in the repository layer |
| State management | **Riverpod** (`flutter_riverpod`, no codegen) | `AsyncValue` gives loading/error/data for free, easy to override in tests, no BuildContext coupling | Steeper than Provider; no `riverpod_generator` to avoid `build_runner` risk |
| Navigation | `go_router` with auth redirect | Declarative guard: logged out → `/login` | One more package |
| HTTP | `dio` + interceptor | Timeouts, auth header injection, uniform error mapping | Heavier than `http`, worth it for the error handling |
| Storage | `flutter_secure_storage` (token), `shared_preferences` (theme, last search), `hive_flutter` (favorites, product cache, stored as JSON maps) | Right tool per data type; token never in plain prefs | Hive stored as raw maps, **no TypeAdapters** → no codegen |
| Structure | Feature-first, `data / application / presentation` per feature | Maps cleanly to the 3 branches with minimal file overlap | Slightly more folders than a tiny app needs, but scores on "code organization" |

---

## 2. Architecture

```
Presentation (widgets, screens)         ← frontend branch
      │ watches / reads
Application (Riverpod notifiers)        ← backend branch
      │ calls
Data (repositories → remote + local)    ← backend branch
      │
DummyJSON API (dio)  |  Hive cache  |  secure storage  |  assets/sample JSON
```

**Rules**
- UI never touches `dio` or Hive. It only watches providers.
- Repositories are **abstract classes** with a `Remote`, a `Local/Fake` implementation. Providers choose which at startup.
- Errors are mapped once (in the dio interceptor/repository) into a sealed `AppFailure` (`Network`, `Timeout`, `Unauthorized`, `Server`, `Unknown`). UI renders failures; it never parses exceptions.
- Product list flow: `ProductListState { items, query, category, sort, page, hasMore, status }` → debounced search (400 ms) → repository → on success write cache → on network failure fall back to cache, then to asset JSON.

**API endpoints (verify all in Postman in Phase 0)**

| Purpose | Request |
|---|---|
| Login | `POST https://dummyjson.com/auth/login` `{username, password}` (test user `emilys` / `emilyspass`) |
| Current user | `GET /auth/me` (Bearer token) |
| Signup (simulated) | `POST /users/add` |
| Products (paged) | `GET /products?limit=20&skip=0` |
| Search | `GET /products/search?q=phone` |
| Category list | `GET /products/categories` |
| By category | `GET /products/category/{slug}` |
| Sort | `GET /products?sortBy=price&order=asc` |
| Details | `GET /products/{id}` |

---

## 3. Folder structure

```
lib/
├── main.dart
├── app.dart                      # MaterialApp.router, theme, ProviderScope
├── core/
│   ├── constants/                # api_constants.dart, app_strings.dart
│   ├── theme/                    # app_theme.dart, colors, text styles   [FE]
│   ├── router/                   # app_router.dart (go_router + guard)   [FE]
│   ├── network/                  # dio_client.dart, interceptors         [BE]
│   ├── storage/                  # secure_store.dart, prefs_store.dart, hive_boxes.dart [BE]
│   ├── errors/                   # app_failure.dart                      [BE]
│   ├── utils/                    # validators.dart, debouncer.dart, formatters.dart
│   └── widgets/                  # AppButton, AppTextField, StateViews   [FE]
├── features/
│   ├── auth/        { data/, application/, presentation/ }
│   ├── home/        { application/, presentation/ }
│   ├── products/    { data/, application/, presentation/ }   # listing + details
│   ├── favorites/   { data/, application/, presentation/ }
│   └── profile/     { application/, presentation/ }
assets/
├── sample/products.json          # fallback data
└── images/
test/                             # unit + widget                         [TEST]
integration_test/                 # login → list → details               [TEST]
docs/                             # screenshots, postman collection       [TEST]
.github/workflows/ci.yml          # analyze + test                        [TEST]
```

`[FE]`, `[BE]`, `[TEST]` = the branch that owns those paths. Touching another branch's paths is the main source of merge conflicts, so don't.

---

## 4. Git workflow: 3 branches

### Branches
| Branch | Owns | Output |
|---|---|---|
| `main` | Always runnable. Only receives merges after checkpoints | Final submission |
| `feature/frontend` | UI, theme, router, reusable widgets, all `presentation/` | Screens that work on fakes first, then on real data |
| `feature/backend` | dio, storage, models, repositories, Riverpod notifiers, error handling, caching | Real data layer behind stable provider interfaces |
| `feature/test` | tests, CI, Postman collection, APK build, screenshots, README | Proof that it works |

### Phase 0 (on `main`, before branching): the contract
Prevents the two build branches from blocking each other. Do this first, ~2 hrs:
1. `flutter create --org com.yourname --platforms android shopsphere` and push.
2. Add dependencies (section 6).
3. Create the folder skeleton from section 3.
4. Write **models** (`Product`, `AppUser`, `Category`, `AppFailure`) with `fromJson/toJson`.
5. Write **abstract repositories** (`AuthRepository`, `ProductRepository`, `FavoritesRepository`).
6. Write **provider declarations** (`authControllerProvider`, `productListProvider`, `productDetailProvider(id)`, `favoritesProvider`, `categoriesProvider`) backed by **Fake implementations** that read `assets/sample/products.json`.
7. Add `INTERNET` permission to `android/app/src/main/AndroidManifest.xml` (see risks).
8. Commit, then branch:

```bash
git checkout -b feature/frontend && git push -u origin feature/frontend
git checkout main && git checkout -b feature/backend && git push -u origin feature/backend
git checkout main && git checkout -b feature/test && git push -u origin feature/test
```

Optional but recommended: work on all three at once with worktrees, no stashing:
```bash
git worktree add ../shopsphere-be feature/backend
git worktree add ../shopsphere-test feature/test
```

### Rules
- Commit format: `feat(products): add debounced search`, `fix(auth): handle 401`, `test(products): repo error mapping`, `chore: ...`.
- Rebase onto `main` at every checkpoint: `git fetch && git rebase origin/main`.
- Merge into `main` via PR with a **merge commit** (not squash) so history shows the three-track workflow.
- A branch may not change the contract (models, abstract repos, provider names) without a commit on `main` first, then both branches rebase.
- PR checklist: `flutter analyze` clean, `flutter test` green, no commented-out code, no secrets.

### Merge order
1. `feature/backend` → `main` (**Checkpoint 1**, ~H14)
2. `feature/frontend` rebased, swap fakes → real, → `main` (**Checkpoint 2**, ~H28)
3. `feature/test` → `main` (**Checkpoint 3**, ~H40), then tag `v1.0.0`

---

## 5. Branch task lists

### 5.1 `feature/frontend`

**Sprint 1 (H2–14)**
- [ ] `app_theme.dart`: Material 3, one seed color, light + dark, consistent text scale
- [ ] Reusable widgets: `AppButton`, `AppTextField`, `ProductCard`, `CategoryChip`, `LoadingView`, `ErrorView(retry)`, `EmptyView`
- [ ] Splash screen (logo animation, 1.5 s, decides route from auth state)
- [ ] Login + Signup screens, `Form` + `GlobalKey<FormState>`, show/hide password, inline errors, disabled button while submitting
- [ ] Router with redirect guard and bottom navigation shell (Home / Products / Favorites / Profile)
- [ ] Home: greeting, search entry, category chips, featured carousel, quick stats

**Sprint 2 (H14–28)**
- [ ] Listing: search bar (debounced via provider), category filter, sort sheet, infinite scroll / "load more", pull-to-refresh
- [ ] All three states on every data screen: **loading (shimmer or skeleton), error with retry, empty with message**
- [ ] Details: image carousel, price, rating, stock, description, favorite toggle, Hero transition from card
- [ ] Favorites screen, Profile screen (user info, theme toggle, logout)
- [ ] Responsiveness: `LayoutBuilder` → grid columns `2 / 3 / 4` by width, `SafeArea`, no hard-coded pixel widths, test on small phone + tablet emulator
- [ ] Accessibility basics: tap targets ≥ 48 dp, `Semantics` on icon buttons

**Done when:** every screen is navigable on fakes, then on real providers after Checkpoint 1, with no overflow warnings.

### 5.2 `feature/backend` (data layer)

**Sprint 1 (H2–14)**
- [ ] `DioClient`: base URL from `String.fromEnvironment('BASE_URL', defaultValue: dummyjson)`, 10 s timeouts, logging in debug only
- [ ] Interceptors: attach `Authorization`, map `DioException` → `AppFailure`, on 401 try `/auth/refresh` once then force logout
- [ ] `SecureStore` (token + refresh), `PrefsStore` (theme, last query), Hive boxes (`favorites`, `product_cache`)
- [ ] `RemoteAuthRepository`: login, signup (simulated), `me`, logout, session restore on app start
- [ ] `RemoteProductRepository`: paged list, search, by-category, sort, details, categories

**Sprint 2 (H14–28)**
- [ ] `ProductListNotifier` (`AsyncNotifier`): query, category, sort, pagination, de-duplicate in-flight requests, cancel stale searches
- [ ] Caching: write-through to Hive; on failure return cached page and flag `isStale` so UI can show "Showing saved data"
- [ ] Third fallback: `assets/sample/products.json` if cache is empty
- [ ] `FavoritesRepository` on Hive (add/remove/list), survives app restart
- [ ] `AuthController`: states `unknown / authenticated / unauthenticated`, drives router guard
- [ ] Never log tokens; token only in secure storage

**Done when:** swapping the provider override from Fake to Remote requires **zero UI changes**.

### 5.3 `feature/test`

**Sprint 1 (H2–14)**
- [ ] Add dev deps: `flutter_test`, `mocktail`, `integration_test`, `http_mock_adapter` (or mock Dio with mocktail)
- [ ] Test helpers: `pumpApp(widget, overrides)`, fake repositories, JSON fixtures
- [ ] Unit tests: `validators.dart` (email, password rules, required, phone if used), `Product.fromJson` incl. missing fields
- [ ] `.github/workflows/ci.yml`: `flutter pub get` → `flutter analyze` → `flutter test` on push and PR
- [ ] Postman collection (`docs/postman_collection.json`) covering all endpoints in section 2, with saved example responses

**Sprint 2 (H14–28)**
- [ ] Repository tests with mocked Dio: success, 401, timeout, 500, malformed JSON, empty list
- [ ] Notifier tests with `ProviderContainer(overrides: [...])`: search debounce, filter change resets pagination, cache fallback sets `isStale`
- [ ] Widget tests: login form validation messages, listing shows loading → data → empty → error+retry, favorite toggle
- [ ] One `integration_test`: launch → login → search → open detail → favorite → logout

**Sprint 3 (H28–44)**
- [ ] Manual QA matrix: small phone, large phone, tablet, dark mode, airplane mode, slow network, kill-and-relaunch (persistence)
- [ ] `flutter build apk --release` (+ `--split-per-abi` smaller variants), install on a real device, **test the release build, not just debug**
- [ ] Screenshots (8+) and 2–3 min screen recording into `docs/`
- [ ] `README.md` (see section 8)

---

## 6. Packages

```yaml
dependencies:
  flutter_riverpod: ^2.x
  go_router: ^14.x
  dio: ^5.x
  flutter_secure_storage: ^9.x
  shared_preferences: ^2.x
  hive_flutter: ^1.x
  cached_network_image: ^3.x
  shimmer: ^3.x            # optional, loading skeletons
  intl: ^0.19.x            # price/date formatting

dev_dependencies:
  flutter_test:
  integration_test:
  mocktail: ^1.x
  flutter_lints: ^4.x
```
Run `flutter pub add <pkg>` so versions resolve for your Flutter SDK instead of copying these constraints blindly.

---

## 7. Timeline (48 hrs, target submit at H44, H44–48 is buffer)

| Hours | Frontend | Backend | Test |
|---|---|---|---|
| **H0–2** | **Phase 0 on `main`** (all together): project, deps, skeleton, contract, fakes, manifest, Postman endpoint check | | |
| **H2–14** | Theme, widgets, splash, auth UI, router, home, listing UI on fakes | dio, interceptors, storage, auth + product repos | Helpers, validator tests, CI, Postman collection |
| **H14 ✔ Checkpoint 1** | Rebase; switch overrides to Remote | Merge to `main` | Rebase, start repo tests |
| **H14–28** | Filters, details, favorites, profile, states, responsive | Notifiers, cache, fallback, favorites, session restore | Repo, notifier, widget tests |
| **H28 ✔ Checkpoint 2** | Merge to `main` | Bug fixes only | Run full suite on merged `main` |
| **H28–40** | Polish, dark mode, animations, UX bugs | Edge cases, performance (image cache, pagination) | Integration test, QA matrix, release APK |
| **H40 ✔ Checkpoint 3** | Freeze features | Freeze | Merge to `main`, tag `v1.0.0` |
| **H40–44** | | | README, screenshots, recording, final APK, submit |
| **H44–48** | Buffer: do **not** start new features | | |

If you're a solo dev, treat the branches as sequential focus blocks but keep the separate-branch history; the evaluator sees the workflow either way.

---

## 8. Submission pack

Map to the evaluation weights (20% each):

| Criterion | Evidence in repo |
|---|---|
| UI design & responsiveness | Theme, grid adapts by width, dark mode, screenshots on phone + tablet |
| Flutter/Dart code quality | `flutter analyze` clean, lints on, small widgets, no logic in `build`, `const` where possible |
| Functionality & navigation | go_router with guard, forms + validation, search, filter, sort, favorites |
| API & data integration | dio client, error mapping, loading/error/empty states, cache + fallback, Postman collection |
| Code organization & demo | Feature-first structure, 3-branch history, tests + CI badge, recording |

**README must contain:** overview, screenshots, architecture diagram (section 2), package list with one-line reason each, run steps (`flutter pub get` → `flutter run`), APK location, test credentials (`emilys` / `emilyspass`), how to switch to a custom backend (`--dart-define=BASE_URL=...`), known limitations (signup is simulated), and "how API integration would work for a real backend".

**Checklist**
- [ ] Repo public (or reviewer added), `main` runs from a clean clone
- [ ] Release APK attached to a GitHub Release and linked in README
- [ ] Screenshots + screen recording in `docs/`
- [ ] Tests + CI green
- [ ] No secrets or `.env` committed
- [ ] You can explain: why Riverpod, why repository pattern, how caching/fallback works, how the auth guard works, how you'd add a real backend (they will ask, since AI tools are allowed but understanding is graded)

**Demo script (≈2.5 min):** splash → signup validation errors → login → home → search with debounce → filter + sort → details (Hero) → favorite → kill the app, reopen: still logged in and favorites persist → airplane mode: cached data with "saved data" banner → logout.

---

## 9. Risks and mitigations

| Risk | Mitigation |
|---|---|
| **Release APK has no network** (Flutter only adds `INTERNET` permission in debug manifests) | Add `<uses-permission android:name="android.permission.INTERNET"/>` to the **main** manifest in Phase 0; test the release APK on a real device |
| DummyJSON slow or down during review | Hive cache + asset JSON fallback; mention in README |
| Signup not persisting is judged as fake | State it clearly, simulate via `/users/add`, keep a local session; optional FastAPI stretch for real signup |
| Merge conflicts between branches | Contract-first on `main`, strict path ownership, rebase at each checkpoint |
| Scope creep | Required: 4 screens. Plan delivers 6. Anything beyond goes to Stretch after H28 |
| `build_runner`/codegen issues | Avoided on purpose: no freezed, no riverpod_generator, no Hive adapters |
| Overflow errors on small screens | Test on a 320 dp-wide emulator at H14 and H28, not at the end |
| Running out of time | Submit at H44 with what's green; a working smaller app beats a broken bigger one |

---

## 10. Stretch (only after Checkpoint 2, in priority order)
1. Cart screen with quantity and total (persisted)
2. Local FastAPI/Node backend with real signup + JWT, reachable via `BASE_URL` (document, don't make default)
3. Localization (en/hi) via `intl`
4. Product comparison or recently viewed
5. Android `flutter_native_splash` + launcher icon polish

---

## 11. Phase 0 command cheat sheet

```bash
flutter create --org com.yourname --platforms android shopsphere
cd shopsphere
flutter pub add flutter_riverpod go_router dio flutter_secure_storage shared_preferences hive_flutter cached_network_image intl shimmer
flutter pub add --dev mocktail integration_test
git init && git add . && git commit -m "chore: bootstrap flutter project"
git branch -M main
git remote add origin <your-repo-url> && git push -u origin main
```
