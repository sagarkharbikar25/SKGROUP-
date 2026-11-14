import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_controller.dart';
import '../data/repositories/favorites_repository.dart';
import '../../products/data/models/product_model.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  final prefsStore = ref.watch(prefsStoreProvider);
  return LocalFavoritesRepository(prefsStore);
});

class FavoritesNotifier extends StateNotifier<List<Product>> {
  final FavoritesRepository _repository;

  FavoritesNotifier(this._repository) : super([]) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final list = await _repository.getFavorites();
    state = list;
  }

  bool isFavorite(int id) => state.any((p) => p.id == id);

  Future<void> toggleFavorite(Product product) async {
    if (isFavorite(product.id)) {
      state = state.where((p) => p.id != product.id).toList();
    } else {
      state = [...state, product];
    }
    await _repository.saveFavorites(state);
  }
}

final favoritesNotifierProvider =
    StateNotifierProvider<FavoritesNotifier, List<Product>>((ref) {
  final repo = ref.watch(favoritesRepositoryProvider);
  return FavoritesNotifier(repo);
});
