# 2.5-Minute Demo Walkthrough Script

Use this script for live evaluation or video recording:

| Time | Screen / Action | What to Demonstrate & Explain |
|---|---|---|
| **0:00 - 0:15** | **Splash Screen** | App launches with animated branding and automatically routes to `/login`. |
| **0:15 - 0:40** | **Authentication & Validation** | 1. Tap **Sign In** with empty fields: show inline validation errors.<br>2. Tap **Auto-fill** chip: populates `emilys` / `emilyspass`.<br>3. Tap **Sign In**: show loading state on button, successful authentication, token saved to `FlutterSecureStorage`, navigation to `/home`. |
| **0:40 - 1:10** | **Product Discovery & Debounce** | 1. From Home banner, tap **Shop Now** to navigate to `/products`.<br>2. Type in search bar (e.g., `phone`): observe 400ms debouncing (no lag or duplicate requests).<br>3. Tap category chips (`beauty`, `fragrances`): updates catalog items instantly.<br>4. Tap Sort icon: select **Price: Low to High** to re-order. |
| **1:10 - 1:35** | **Product Details & Hero Transition** | 1. Tap on any product card: smooth Hero image transition.<br>2. Swipe horizontal image carousel with page indicators.<br>3. Inspect specifications, rating, stock status, discount calculations.<br>4. Tap the **Heart** icon in the AppBar: adds to favorites with feedback snackbar. |
| **1:35 - 1:55** | **Favorites & Persistence** | 1. Switch to the **Favorites** tab in bottom navigation.<br>2. Observe favorited product listed.<br>3. Kill and restart the app: session remains authenticated and favorites persist from local storage. |
| **1:55 - 2:15** | **Offline Fallback** | 1. Turn on Airplane mode (or disable Wi-Fi/data).<br>2. Refresh the product list: app seamlessly displays cached products with amber banner: *"Offline Mode — Showing saved catalog data"*. |
| **2:15 - 2:30** | **Profile, Theme Switcher & Logout** | 1. Switch to **Profile** tab: view authenticated user info from DummyJSON.<br>2. Toggle **Dark Mode**: app theme transitions smoothly to dark Material 3.<br>3. Tap **Log Out**: confirms in dialog, purges tokens, returns user to `/login`. |
