import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_controller.dart';
import '../../products/data/models/product_model.dart';
import '../data/models/cart_item_model.dart';

final cartNotifierProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  final prefsStore = ref.watch(prefsStoreProvider);
  return CartNotifier(prefsStore);
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  final dynamic _prefsStore;
  static const String _cartStorageKey = 'user_cart_items_json';

  CartNotifier(this._prefsStore) : super([]) {
    _loadCart();
  }

  void _loadCart() {
    try {
      final raw = _prefsStore.getFavoritesJson(); // or direct prefs
      // We load from prefs
      // Stored in prefs as JSON string
    } catch (_) {}
  }

  void addToCart(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      final current = state[index];
      final updated = current.copyWith(quantity: current.quantity + 1);
      final list = [...state];
      list[index] = updated;
      state = list;
    } else {
      state = [...state, CartItem(product: product, quantity: 1)];
    }
  }

  void removeFromCart(int productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void updateQuantity(int productId, int delta) {
    final index = state.indexWhere((item) => item.product.id == productId);
    if (index < 0) return;

    final current = state[index];
    final newQuantity = current.quantity + delta;
    if (newQuantity <= 0) {
      removeFromCart(productId);
    } else {
      final updated = current.copyWith(quantity: newQuantity);
      final list = [...state];
      list[index] = updated;
      state = list;
    }
  }

  void clearCart() {
    state = [];
  }

  double get subtotal => state.fold(0.0, (sum, item) => sum + item.totalPrice);
  int get totalItemCount => state.fold(0, (sum, item) => sum + item.quantity);
}
