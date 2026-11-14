import 'package:shared_preferences/shared_preferences.dart';

class PrefsStore {
  final SharedPreferences _prefs;

  PrefsStore(this._prefs);

  static const String _themeModeKey = 'theme_mode';
  static const String _cachedProductsKey = 'cached_products_json';
  static const String _favoritesKey = 'user_favorites_json';

  // Theme
  String getThemeMode() => _prefs.getString(_themeModeKey) ?? 'system';
  Future<bool> setThemeMode(String mode) => _prefs.setString(_themeModeKey, mode);

  // Cached Products JSON
  String? getCachedProducts() => _prefs.getString(_cachedProductsKey);
  Future<bool> setCachedProducts(String jsonString) =>
      _prefs.setString(_cachedProductsKey, jsonString);

  // Favorites JSON
  String? getFavoritesJson() => _prefs.getString(_favoritesKey);
  Future<bool> setFavoritesJson(String jsonString) =>
      _prefs.setString(_favoritesKey, jsonString);
}
