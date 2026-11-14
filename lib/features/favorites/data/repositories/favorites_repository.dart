import 'dart:convert';
import '../../../../core/storage/prefs_store.dart';
import '../../products/data/models/product_model.dart';

abstract class FavoritesRepository {
  Future<List<Product>> getFavorites();
  Future<void> saveFavorites(List<Product> favorites);
}

class LocalFavoritesRepository implements FavoritesRepository {
  final PrefsStore _prefsStore;

  LocalFavoritesRepository(this._prefsStore);

  @override
  Future<List<Product>> getFavorites() async {
    final rawJson = _prefsStore.getFavoritesJson();
    if (rawJson == null || rawJson.isEmpty) {
      return [];
    }
    try {
      final decoded = jsonDecode(rawJson) as List<dynamic>;
      return decoded.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveFavorites(List<Product> favorites) async {
    final rawJson = jsonEncode(favorites.map((p) => p.toJson()).toList());
    await _prefsStore.setFavoritesJson(rawJson);
  }
}
