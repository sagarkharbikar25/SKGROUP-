import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../storage/prefs_store.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize in main with override');
});

final prefsStoreProvider = Provider<PrefsStore>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PrefsStore(prefs);
});

class ThemeController extends StateNotifier<ThemeMode> {
  final PrefsStore _prefsStore;

  ThemeController(this._prefsStore) : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final saved = _prefsStore.getThemeMode();
    switch (saved) {
      case 'light':
        state = ThemeMode.light;
        break;
      case 'dark':
        state = ThemeMode.dark;
        break;
      default:
        state = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _prefsStore.setThemeMode(mode.name);
  }
}

final themeControllerProvider = StateNotifierProvider<ThemeController, ThemeMode>((ref) {
  final prefsStore = ref.watch(prefsStoreProvider);
  return ThemeController(prefsStore);
});
