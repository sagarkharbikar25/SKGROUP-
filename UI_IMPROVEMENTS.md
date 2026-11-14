# UI_IMPROVEMENTS.md: Identity, Icon, Splash, Pull-to-Refresh, Fast Navigation

Companion to `plan.md`. This file is the spec for the **frontend branch** (plus small hooks in backend and test). UI design and responsiveness is 20% of the grade, and "looks like every Flutter tutorial" is the most common reason it scores 12/20 instead of 18/20.

**Budget:** ~5 hrs total, done inside Sprint 1 and Sprint 2 of `plan.md` (see section 9). Design tokens come **before** screens, so nothing gets restyled twice.

---

## 1. Design direction: "Warm Editorial Marketplace"

### Why the default look reads as generic
`ColorScheme.fromSeed(Colors.deepPurple)`, Roboto, elevated white cards, a centered login card, a stock `Icons.shopping_cart`. Evaluators have seen all of it. The fix is not more features, it is **a few deliberate, consistent choices**.

### The choices (commit to them; don't mix in extras)

| Element | Decision | Rationale |
|---|---|---|
| Palette | Warm paper background, near-black ink, **one** vermilion accent, moss green as the only secondary | One accent makes CTAs unmistakable and the app feel branded. Warm neutrals avoid the cold white-and-blue default |
| Display font | **Fraunces** (serif), for headings, prices, hero text | Editorial character; instantly non-default |
| Body font | **Manrope** | Clean geometric sans, readable at 14 px |
| Surfaces | Tonal fills + 1 px hairline borders, **no drop shadows** | Flat, crisp, cheaper to render than elevation shadows |
| Shape | Radius scale 10 / 16 / 24, pill for chips and nav | Consistent rhythm |
| Icons | Custom SVG set, 1.75 px stroke, round caps | Matches the logo, avoids the stock Material look |
| Motion | 160 ms / 240 ms, `easeOutCubic`, subtle (fade + 3% slide) | Feels fast, never decorative |

If Sankar Group has brand colors, swap `accent` and `moss` for those and keep everything else. If you do, re-check contrast (below).

### Tokens: `core/theme/app_tokens.dart`

```dart
import 'package:flutter/material.dart';

abstract final class AppColors {
  // Light
  static const paper = Color(0xFFF5F0E8);
  static const surface = Color(0xFFFFFCF7);
  static const ink = Color(0xFF16130F);
  static const inkMuted = Color(0xFF6B645A);
  static const line = Color(0xFFE3DACB);
  static const accent = Color(0xFFC2410C);       // fills with white text (~5:1)
  static const accentBright = Color(0xFFFF6A3D); // highlights, dark mode primary
  static const moss = Color(0xFF1F4B43);
  static const danger = Color(0xFFB3261E);
  // Dark
  static const nightPaper = Color(0xFF12100D);
  static const nightSurface = Color(0xFF1C1915);
  static const nightInk = Color(0xFFF3EDE2);
  static const nightMuted = Color(0xFFA39A8C);
  static const nightLine = Color(0xFF2E2A23);
}

abstract final class AppRadius {
  static const s = 10.0, m = 16.0, l = 24.0, pill = 999.0;
}

abstract final class AppSpace {
  static const x1 = 4.0, x2 = 8.0, x3 = 12.0, x4 = 16.0, x5 = 24.0, x6 = 32.0, x7 = 48.0;
}

abstract final class AppMotion {
  static const fast = Duration(milliseconds: 160);
  static const base = Duration(milliseconds: 240);
  static const curve = Curves.easeOutCubic;
}
```

### Theme: `core/theme/app_theme.dart`

Build the `ColorScheme` explicitly. Do **not** use `fromSeed`, it generates the generic tonal palette.

```dart
import 'package:flutter/material.dart';
import 'app_tokens.dart';

ThemeData buildTheme(Brightness b) {
  final dark = b == Brightness.dark;
  final bg = dark ? AppColors.nightPaper : AppColors.paper;
  final surface = dark ? AppColors.nightSurface : AppColors.surface;
  final ink = dark ? AppColors.nightInk : AppColors.ink;
  final muted = dark ? AppColors.nightMuted : AppColors.inkMuted;
  final line = dark ? AppColors.nightLine : AppColors.line;
  final primary = dark ? AppColors.accentBright : AppColors.accent;

  final scheme = ColorScheme(
    brightness: b,
    primary: primary,
    onPrimary: dark ? AppColors.nightPaper : Colors.white,
    secondary: dark ? const Color(0xFF7FB5A6) : AppColors.moss,
    onSecondary: dark ? AppColors.nightPaper : Colors.white,
    error: dark ? const Color(0xFFFFB4AB) : AppColors.danger,
    onError: dark ? AppColors.nightPaper : Colors.white,
    surface: surface,
    onSurface: ink,
    onSurfaceVariant: muted,
    outline: line,
  );

  TextStyle display(double s, {FontWeight w = FontWeight.w600}) => TextStyle(
      fontFamily: 'Fraunces', fontSize: s, fontWeight: w, height: 1.08,
      letterSpacing: -0.4, color: ink);
  TextStyle body(double s, {FontWeight w = FontWeight.w500, Color? c}) =>
      TextStyle(fontFamily: 'Manrope', fontSize: s, fontWeight: w, height: 1.4, color: c ?? ink);

  final text = TextTheme(
    displayLarge: display(44),
    headlineMedium: display(30),
    titleLarge: display(22),
    titleMedium: body(16, w: FontWeight.w700),
    bodyLarge: body(16),
    bodyMedium: body(14, c: muted),
    labelLarge: body(14, w: FontWeight.w700),
  );

  OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.m), borderSide: BorderSide(color: c, width: w));

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: bg,
    textTheme: text,
    dividerColor: line,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0,
      titleTextStyle: display(22), iconTheme: IconThemeData(color: ink)),
    inputDecorationTheme: InputDecorationTheme(
      filled: true, fillColor: surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      enabledBorder: border(line), focusedBorder: border(primary, 1.6),
      errorBorder: border(scheme.error), focusedErrorBorder: border(scheme.error, 1.6),
      labelStyle: body(14, c: muted), hintStyle: body(14, c: muted)),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.m)),
        textStyle: body(15, w: FontWeight.w700))),
    chipTheme: ChipThemeData(
      shape: const StadiumBorder(), side: BorderSide(color: line),
      backgroundColor: surface, selectedColor: primary, labelStyle: body(13)),
  );
}
```

Wire it in `app.dart`: `theme: buildTheme(Brightness.light)`, `darkTheme: buildTheme(Brightness.dark)`, `themeMode` from `PrefsStore`.

### Fonts: bundle them, don't use `google_fonts`
`google_fonts` downloads fonts at runtime, which means a flash of the wrong font on first launch and a broken look offline. For a demo that must work anywhere, bundle:

```yaml
flutter:
  fonts:
    - family: Fraunces
      fonts:
        - asset: assets/fonts/Fraunces-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Fraunces-Bold.ttf
          weight: 700
    - family: Manrope
      fonts:
        - asset: assets/fonts/Manrope-Medium.ttf
          weight: 500
        - asset: assets/fonts/Manrope-Bold.ttf
          weight: 700
```
Download from Google Fonts (both are OFL-licensed); use the static instances from the zip's `static/` folder.

### Contrast check (do it once)
Text on `paper`: ink is ~16:1, muted ~5:1, fine. White on `accent` (#C2410C) is ~5:1, which passes. **Don't** use `accentBright` as a fill under white text (≈3:1, large text only). Verify with any contrast checker or DevTools' accessibility inspector.

### Screen-level instructions

| Screen | Instead of the default | Do this |
|---|---|---|
| **Login/Signup** | Centered white card with a logo on top | Top ~40% is a brand panel: accent background, large Fraunces headline ("Find what fits."), the logo mark cropped large and partly off-canvas. Form sits below on `paper`. Signup is the same layout with the panel collapsing as the keyboard opens |
| **Home** | Grid of identical tiles | Editorial header (greeting in Fraunces, small muted date line). Horizontal category pills with custom SVG icons. One large "featured" card with full-bleed image and a pill price tag. Section titles in serif with a small "See all" |
| **Listing** | Uniform ListTile rows | 2-column grid, image-first cards, **no shadow, 1 px line border, radius 16**, price as an overlapping corner pill in Fraunces, rating as small dots. Sticky search + filter row. Optionally `flutter_staggered_grid_view` for a masonry feel (extra package, only if ahead) |
| **Details** | Plain scroll with an AppBar | `SliverAppBar` with image carousel (Hero), serif title and price, spec chips, sticky bottom bar with price + primary CTA and a heart button |
| **Navigation bar** | Default `NavigationBar` | Floating pill bar (margin 16, radius pill, line border), custom SVG icons, active item shows a filled accent capsule with label. Cheap to build with `Row` + `AnimatedContainer` |
| **Empty/error** | Grey icon + text | Small brand illustration drawn from the same SVG language (a bag with a dotted outline for empty, a broken link for error), one line of copy, one button |
| **Profile** | List of tiles | Avatar initials in a serif monogram, stat row, grouped settings in bordered containers |

### Responsiveness rules
- Grid columns from width: `<600 → 2`, `600–900 → 3`, `>900 → 4`. Use `SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 220)` and it handles this for you.
- Cap content width at ~640 on tablets (`ConstrainedBox` + `Center`) for forms and details.
- Use `MediaQuery.textScalerOf` testing: set system font to the largest and make sure nothing overflows.
- No fixed pixel heights on text containers.

---

## 2. SVG icon: how to create it

### 2.1 App icon (launcher)

**Concept:** a bag silhouette whose handle reads as a sphere ("Shop" + "Sphere"). Geometric, two shapes, recognisable at 48 px. Replace it with your own monogram if you prefer. The method is what matters.

**Canvas rules (Android adaptive icons)**
- Artboard **1024 × 1024**. Android renders **108 dp** layers and shows only the central ~72 dp after masking (circle, squircle, teardrop, varies per launcher).
- Keep all artwork inside the centered **~66%** of the canvas, i.e. x/y from **174 to 850**. Anything outside gets clipped.
- You need **three** files:
  1. `icon_bg`: solid accent color (no file needed, a hex is enough)
  2. `icon_fg.svg`: artwork on a **transparent** background
  3. `icon_mono.svg`: same artwork, single flat color (Android 13+ themed icons)

**Starter `assets/icon/icon_fg.svg`** (copy, then adjust to taste):

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024" width="1024" height="1024">
  <!-- All shapes sit inside the 174..850 safe zone -->
  <g fill="none" stroke="#FFF8EE" stroke-width="56" stroke-linecap="round" stroke-linejoin="round">
    <path d="M300 420 H724 L760 760 Q762 800 722 800 H302 Q262 800 264 760 Z"/>
    <path d="M400 420 V380 a112 112 0 0 1 224 0 V420"/>
  </g>
  <circle cx="512" cy="600" r="56" fill="#FFF8EE"/>
</svg>
```
For `icon_mono.svg`, use the same file with every `#FFF8EE` changed to `#000000`.

**Workflow in a vector editor** (Figma, free; or Inkscape, free)
1. New 1024 × 1024 frame. Add a guide rectangle 676 × 676 centered (the safe zone) and a 108-dp-ratio circle for preview.
2. Draw with **basic shapes only** (rectangles, circles, strokes), no more than 2–3 shapes. Complexity dies at small sizes.
3. Use stroke width ≥ 48 px at this scale so it stays readable at 48 px.
4. **Outline strokes** (Figma: *Outline stroke*; Inkscape: *Stroke to Path*) before exporting, so renderers agree.
5. Convert any text to outlines. Don't use gradients, blur, masks, or filters in the launcher icon.
6. Export `icon_fg.svg` and `icon_mono.svg`. Export a PNG of each at 1024 px (see below).

**Convert SVG to PNG** (the launcher tool needs PNG):
```bash
# Inkscape CLI
inkscape assets/icon/icon_fg.svg -o assets/icon/icon_fg.png -w 1024 -h 1024
inkscape assets/icon/icon_mono.svg -o assets/icon/icon_mono.png -w 1024 -h 1024
# or rsvg-convert (librsvg)
rsvg-convert -w 1024 -h 1024 assets/icon/icon_fg.svg > assets/icon/icon_fg.png
```
Also produce `icon_full.png` (accent background + foreground flattened, 1024²) as the legacy fallback.

**Generate Android assets:**
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.0

flutter_launcher_icons:
  android: true
  ios: false
  image_path: "assets/icon/icon_full.png"
  adaptive_icon_background: "#C2410C"
  adaptive_icon_foreground: "assets/icon/icon_fg.png"
  adaptive_icon_monochrome: "assets/icon/icon_mono.png"
  min_sdk_android: 21
```
```bash
dart run flutter_launcher_icons
```
Check: long-press the icon on an Android 13+ device with themed icons on, and view it under circle, squircle and square masks (Android Studio's *Image Asset* preview shows them).

### 2.2 In-app SVG icon set (nav, categories, empty states)

**Spec:** 24 × 24 viewBox, `fill="none"`, `stroke-width="1.75"`, round caps and joins, 2 px padding inside the box. Same stroke weight as the logo.

**Minimum set:** `home`, `grid`, `heart`, `heart_filled`, `user`, `search`, `filter`, `sort`, `star`, `bag`, `arrow_left`, `eye`, `eye_off`, `mail`, `lock`, `wifi_off`, `refresh`.

Example `assets/icons/heart.svg`:
```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="#000" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round">
  <path d="M12 20.5s-7.5-4.6-9.2-9.3C1.6 8 3.6 5 6.8 5c2 0 3.5 1.1 5.2 3 1.7-1.9 3.2-3 5.2-3 3.2 0 5.2 3 4 6.2-1.7 4.7-9.2 9.3-9.2 9.3z"/>
</svg>
```
Draw the rest in the same editor, or take open-licensed sets (Lucide, Phosphor) and **normalize them to your stroke width**. Don't mix sets.

**Use it:**
```yaml
dependencies:
  flutter_svg: ^2.0.10
flutter:
  assets:
    - assets/icons/
    - assets/icon/
```
```dart
class AppIcon extends StatelessWidget {
  const AppIcon(this.name, {super.key, this.size = 24, this.color});
  final String name;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? IconTheme.of(context).color ?? Theme.of(context).colorScheme.onSurface;
    return SvgPicture.asset(
      'assets/icons/$name.svg',
      width: size, height: size,
      colorFilter: ColorFilter.mode(c, BlendMode.srcIn),
    );
  }
}
```

**`flutter_svg` limits:** no CSS-heavy `<style>` blocks, no complex filters. Flatten everything to paths in the editor before exporting. Keep each file under ~2 KB.

---

## 3. Splash screen: instant, branded, seamless

### Two layers (why)
1. **Native splash**: shown by Android before Flutter's engine is ready. Zero Dart code, appears instantly, kills the white flash.
2. **In-app splash route** (`/splash`): short branded animation while the app bootstraps. This is the "splash screen" the assignment asks for and what the evaluator sees in your recording.

Trade-off: two layers means two things to keep visually identical. The payoff is no white flash and no fake waiting.

### 3.1 Native splash

```yaml
dev_dependencies:
  flutter_native_splash: ^2.4.0

flutter_native_splash:
  color: "#F5F0E8"
  image: assets/icon/splash_logo.png
  color_dark: "#12100D"
  image_dark: assets/icon/splash_logo.png
  android_12:
    color: "#F5F0E8"
    image: assets/icon/splash_logo.png
```
```bash
dart run flutter_native_splash:create
```
- `splash_logo.png`: your logo mark on transparent, ~960 px. **Android 12+ masks the splash icon into a circle**, so keep the artwork inside the central two-thirds of the canvas.
- Use the **same background color** as the in-app splash.

### 3.2 Hand-off with no flash

```dart
// main.dart
Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding); // hold native splash
  runApp(const ProviderScope(child: App()));             // do NOT await network or storage here
}
```
The in-app splash removes the native one **after its first frame**, so the logo is already on screen underneath:

```dart
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 700));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove(); // first Flutter frame is up
      _c.forward();
    });
    _boot();
  }

  Future<void> _boot() async {
    // Bootstrap and minimum animation time run in PARALLEL, so total = max(a, b), not a + b.
    await Future.wait([
      ref.read(bootstrapProvider.future),                 // Hive init, token read, prefs (local only)
      Future<void>.delayed(const Duration(milliseconds: 700)),
    ]);
    if (!mounted) return;
    final authed = ref.read(authControllerProvider).isAuthenticated; // adapt to your contract
    context.go(authed ? '/home' : '/login');
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fade = CurvedAnimation(parent: _c, curve: const Interval(0.25, 1, curve: Curves.easeOutCubic));
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Logo is static, identical in size/position to the native splash.
          SvgPicture.asset('assets/icon/logo_mark.svg', width: 112, height: 112),
          const SizedBox(height: 20),
          FadeTransition(
            opacity: fade,
            child: SlideTransition(
              position: Tween(begin: const Offset(0, .25), end: Offset.zero).animate(fade),
              child: Text('ShopSphere', style: Theme.of(context).textTheme.headlineMedium),
            ),
          ),
        ]),
      ),
    );
  }
}
```

### 3.3 Rules that keep it fast
- **Never block `runApp` on network.** `bootstrapProvider` does local work only: open Hive boxes, read the secure token, read prefs. Target **< 300 ms** on a mid-range phone in release mode.
- **Session restore is optimistic.** If a token exists, go to Home immediately, then validate with `/auth/me` in the background. On 401, refresh once or send to login with a snackbar.
- Total splash time = `max(bootstrap, 700 ms)`. Don't add artificial delay beyond the animation. If you want it snappier, drop the minimum to 500 ms.
- Router guard: while `/splash` is active, the redirect function must **leave it alone**; only `_boot()` navigates away.
- Animate only the wordmark. Animating the logo's size or position would cause a visible jump against the native splash.

---

## 4. Pull-to-refresh ("swipe down") done properly

Common mistakes: it doesn't work on empty/error screens, the spinner flashes for 50 ms, the list blanks out while refreshing, it fires inside nested scrollables, and errors vanish silently.

### 4.1 Reusable wrapper (`core/widgets/app_refresh.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppRefresh extends StatelessWidget {
  const AppRefresh({super.key, required this.onRefresh, required this.child});
  final Future<void> Function() onRefresh;
  final Widget child; // must be a scrollable using AlwaysScrollableScrollPhysics

  Future<void> _run() async {
    HapticFeedback.lightImpact();
    // Floor of 450 ms so a cache hit doesn't make the spinner flash.
    await Future.wait([onRefresh(), Future<void>.delayed(const Duration(milliseconds: 450))]);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return RefreshIndicator(
      onRefresh: _run,
      color: cs.primary,
      backgroundColor: cs.surface,
      strokeWidth: 2.5,
      displacement: 56,
      notificationPredicate: (n) => n.depth == 0, // ignore inner horizontal lists
      child: child,
    );
  }
}
```

### 4.2 Use it on every data screen (Home, Listing, Favorites)

```dart
AppRefresh(
  onRefresh: () => ref.read(productListProvider.notifier).refresh(),
  child: CustomScrollView(
    physics: const AlwaysScrollableScrollPhysics(), // REQUIRED, else short/empty lists can't be pulled
    slivers: [
      const SliverAppBar(floating: true /* ... */),
      if (state.items.isEmpty && !state.isLoading)
        SliverFillRemaining(hasScrollBody: false, child: EmptyView(/* ... */)) // empty is still pullable
      else
        SliverGrid.builder(/* cards */),
      SliverToBoxAdapter(child: LoadMoreFooter(state: state)),
    ],
  ),
)
```
The error view must also be inside a `SliverFillRemaining` within the same scroll view, so "pull to retry" works alongside the Retry button.

### 4.3 Notifier behavior (backend branch)

Refresh must **keep the old data on screen** and only swap when new data arrives:

```dart
Future<void> refresh() async {
  final previous = state.valueOrNull;
  state = const AsyncLoading<ProductListState>().copyWithPrevious(state); // keeps items visible
  final next = await AsyncValue.guard(() => _fetchFirstPage(reset: true));
  if (next.hasError && previous != null) {
    // Keep showing old data and surface a transient message instead of blanking the list.
    state = AsyncData(previous.copyWith(refreshError: next.error as AppFailure?));
  } else {
    state = next;
  }
}
```
- `refresh()` **never throws**. Errors go into state, the UI shows a snackbar ("Couldn't refresh. Showing saved data.") and the stale banner from `plan.md` if a cache was used.
- Refresh resets pagination to page 1 and replaces the cache.
- De-duplicate: if a refresh is already in flight, return the same Future.

### 4.4 Polish
- Haptic tick on trigger (included).
- Add `edgeOffset` if you use a pinned `SliverAppBar`, so the spinner appears below it.
- Optional branded indicator: use the logo mark rotating inside a custom indicator (`custom_refresh_indicator` package). Skip unless ahead, since the themed `RefreshIndicator` already looks intentional with your accent color.

---

## 5. Fast navigation loading (no spinner walls)

**Principle:** navigation is instant, loading is local. Never push a full-screen "Loading…" page between screens. Show the destination immediately with whatever data you already have, and fill the rest in.

### 5.1 Technique stack (use all)

1. **Pass the seed object.** The listing already has the `Product`. Pass it as `extra` so Details renders at once, then refresh silently.
2. **Skeletons, not spinners.** Layout-matching shimmer blocks for first loads.
3. **Delayed loader.** Show a skeleton only if loading exceeds ~150 ms, otherwise nothing flashes.
4. **Prefetch.** Warm the details cache and image on `onTapDown` and next page at 70% scroll.
5. **Fast transitions.** 220 ms fade + 3% slide, Hero for the product image.
6. **Inline progress for actions.** Login/signup/favorite show progress on the button, not a new page.

### 5.2 Fast page transition (`core/router/fast_page.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<T> fastPage<T>({required LocalKey key, required Widget child}) =>
    CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 180),
      transitionsBuilder: (context, animation, secondary, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween(begin: const Offset(0, .03), end: Offset.zero).animate(curved),
            child: child,
          ),
        );
      },
    );
```
```dart
GoRoute(
  path: '/product/:id',
  pageBuilder: (context, state) => fastPage(
    key: state.pageKey,
    child: ProductDetailScreen(
      id: int.parse(state.pathParameters['id']!),
      seed: state.extra as Product?,
    ),
  ),
),
// from the card:
context.push('/product/${p.id}', extra: p);
```

### 5.3 Details: render now, refresh quietly

```dart
final async = ref.watch(productDetailProvider(id));
final product = async.valueOrNull ?? seed;   // seed paints frame 1
if (product == null) return const DetailSkeleton();
return DetailView(product: product);          // Hero tag: 'product-${product.id}'
```
Deep link or process restart (no seed): falls back to the skeleton, then data. Failure with a seed still shows the seed.

### 5.4 Delayed loader + skeleton

```dart
class DelayedLoader extends StatefulWidget {
  const DelayedLoader({super.key, required this.child, this.delay = const Duration(milliseconds: 150)});
  final Widget child;
  final Duration delay;
  @override
  State<DelayedLoader> createState() => _DelayedLoaderState();
}

class _DelayedLoaderState extends State<DelayedLoader> {
  bool _show = false;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer(widget.delay, () { if (mounted) setState(() => _show = true); });
  }

  @override
  void dispose() { _t?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
      opacity: _show ? 1 : 0, duration: const Duration(milliseconds: 120), child: widget.child);
}
```
```dart
// Skeleton block using the `shimmer` package and theme tokens
class Skeleton extends StatelessWidget {
  const Skeleton({super.key, this.height = 16, this.width, this.radius = 12});
  final double height; final double? width; final double radius;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: cs.outline, highlightColor: cs.surface,
      child: Container(height: height, width: width,
        decoration: BoxDecoration(color: cs.outline, borderRadius: BorderRadius.circular(radius))),
    );
  }
}
```
Usage: `loading: () => const DelayedLoader(child: ProductGridSkeleton())`. Build `ProductGridSkeleton` and `DetailSkeleton` from `Skeleton` blocks so they match the real layout exactly (same paddings, same card aspect ratio), which prevents layout jump when data arrives.

### 5.5 Prefetch (backend + frontend)

```dart
// ProductCard
GestureDetector(
  onTapDown: (_) {
    ref.read(productRepositoryProvider).prefetchDetail(p.id); // fire-and-forget, writes to Hive cache
    precacheImage(CachedNetworkImageProvider(p.thumbnail), context);
  },
  onTap: () => context.push('/product/${p.id}', extra: p),
  child: /* card */,
)
```
In the listing, when the user scrolls past ~70% of loaded items, call `loadMore()` ahead of the footer so the next page is usually ready before they reach it.

### 5.6 Rendering performance checklist
- `const` constructors wherever possible; no data parsing or sorting inside `build`.
- `cached_network_image` with `memCacheWidth` set to the displayed pixel width (decoding 1000 px images into 180 px cards is the #1 scroll-jank cause); `fadeInDuration: 120 ms`.
- `RepaintBoundary` around cards in the grid; use `SliverGrid.builder`, not a `Column` of everything.
- Avoid `Opacity`/`ClipRRect`-on-large-trees and `BackdropFilter` (they trigger `saveLayer`). Use `DecoratedBox` + `borderRadius`, and `FadeTransition` for opacity animations.
- Judge speed in **profile or release**, never debug: `flutter run --profile`, open DevTools → Performance, check no frames over 16 ms during scroll and navigation.
- Cold start: `flutter run --profile --trace-startup` and read `timeToFirstFrameMicros`.

---

## 6. Branch assignment

| Branch | Work from this file |
|---|---|
| `feature/frontend` | Tokens, theme, fonts, all screen layouts (section 1), `AppIcon` and icon set, in-app splash screen, `AppRefresh`, `Skeleton`, `DelayedLoader`, `fastPage`, floating nav bar, empty/error illustrations |
| `feature/backend` | `bootstrapProvider` (local-only init), optimistic session restore, `refresh()` semantics (4.3), `prefetchDetail`, `loadMore` prefetch trigger, in-flight de-dup |
| `feature/test` | Launcher icon + native splash generation check on a real device, widget tests (below), profile-mode trace screenshots, before/after screenshots for README |

**Tests to add**
- Pull-to-refresh: pump the listing, `await tester.fling(find.byType(Scrollable).first, const Offset(0, 400), 1000)`, `pump`, expect a `RefreshProgressIndicator`, `pumpAndSettle`, expect updated items. Also assert it still works with an **empty** list.
- Refresh failure keeps previous items visible and shows the snackbar.
- `DelayedLoader`: use `tester.pump(Duration(milliseconds: 100))` → opacity 0; `pump(Duration(milliseconds: 100))` again → visible.
- Details renders `seed` on the first frame with the provider still loading (no skeleton).
- Splash: with a fake `bootstrapProvider`, navigates to `/home` when authed and `/login` otherwise, and not before 700 ms.

---

## 7. Schedule (fits `plan.md` Sprint 1 and 2)

| When | Task | Est. |
|---|---|---|
| H2–3 | Fonts bundled, tokens, `buildTheme`, light/dark toggle | 1 h |
| H3–4 | Logo mark + launcher icon + native splash generated | 1 h |
| H4–6 | `AppIcon` + 8 core icons, floating nav, `AppButton`/`AppTextField` re-skinned | 1.5 h |
| H6–10 | Login/Signup brand panel layout, in-app splash with hand-off | 1.5 h |
| H14–18 | Listing and Home layouts, `AppRefresh`, skeletons, delayed loader | 2 h |
| H18–22 | `fastPage`, seed-based Details with Hero, prefetch | 1.5 h |
| H28–34 | Empty/error illustrations, dark mode QA, profile-mode perf pass | 2 h |

---

## 8. Acceptance checklist

**Identity**
- [ ] No `fromSeed`, no default blue/purple, no Roboto anywhere
- [ ] Exactly one accent color; all CTAs use it
- [ ] No drop shadows; surfaces use fill + hairline border
- [ ] Custom SVG icons everywhere (no `Icons.*`), same stroke weight
- [ ] Launcher icon shows under circle and squircle masks; themed (monochrome) icon works on Android 13+
- [ ] Light and dark both look intentional

**Splash**
- [ ] No white flash on cold start, native → in-app hand-off is seamless
- [ ] Splash ≤ ~800 ms in release; never waits on the network

**Pull-to-refresh**
- [ ] Works on Home, Listing, Favorites, **including empty and error states**
- [ ] Old data stays visible during refresh; failure shows a message, not a blank screen
- [ ] No spinner flash on cache hits (450 ms floor)

**Navigation speed**
- [ ] Opening Details paints the product on the first frame (seed + Hero)
- [ ] No full-screen spinner between any two screens
- [ ] Skeletons match real layout; they appear only after ~150 ms
- [ ] 60 fps scroll and transitions in profile mode on a real mid-range device

**Responsive**
- [ ] No overflow at 320 dp width, large font scale, or tablet width
- [ ] Grid columns adapt; forms and details are width-capped on tablets

**Smell test (ask honestly):** if I screenshot Home and Listing, could someone guess which tutorial it came from? If yes, push the editorial typography and the card styling further.

---

## 9. Known trade-offs

| Choice | Cost | Why accepted |
|---|---|---|
| Bundled fonts | +~300 KB APK | Offline-safe, no font flash |
| Custom nav bar | ~1 h more than `NavigationBar` | Biggest single "not generic" signal |
| Two splash layers | Must match background + logo | Removes flash, and satisfies the splash-screen requirement visibly |
| 450 ms refresh floor | Slight artificial wait | Avoids the janky spinner flicker; only on user-initiated pulls |
| Seed-based Details | Brief staleness | Silent refresh corrects it; instant paint matters more |
| Skipping staggered masonry and branded refresh indicator | Less flashy | Package and time risk in a 48-hour window |
