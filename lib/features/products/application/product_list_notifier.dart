import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/theme_controller.dart';
import '../data/models/product_model.dart';
import '../data/models/category_model.dart';
import '../data/repositories/product_repository.dart';
import '../../auth/application/auth_controller.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final secureStore = ref.watch(secureStoreProvider);
  final prefsStore = ref.watch(prefsStoreProvider);
  final dio = createDioClient(secureStore);
  return RemoteProductRepository(dio, prefsStore);
});

final categoriesProvider = FutureProvider<List<ProductCategory>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getCategories();
});

class ProductCatalogState {
  final List<Product> products;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int skip;
  final int total;
  final String query;
  final String? category;
  final String sortBy;
  final String order;
  final bool isStale;
  final String? errorMessage;

  const ProductCatalogState({
    required this.products,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.skip = 0,
    this.total = 0,
    this.query = '',
    this.category,
    this.sortBy = 'id',
    this.order = 'asc',
    this.isStale = false,
    this.errorMessage,
  });

  ProductCatalogState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? skip,
    int? total,
    String? query,
    String? category,
    bool clearCategory = false,
    String? sortBy,
    String? order,
    bool? isStale,
    String? errorMessage,
  }) {
    return ProductCatalogState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      skip: skip ?? this.skip,
      total: total ?? this.total,
      query: query ?? this.query,
      category: clearCategory ? null : (category ?? this.category),
      sortBy: sortBy ?? this.sortBy,
      order: order ?? this.order,
      isStale: isStale ?? this.isStale,
      errorMessage: errorMessage,
    );
  }
}

class ProductListNotifier extends StateNotifier<ProductCatalogState> {
  final ProductRepository _repository;
  static const int _pageSize = 20;

  ProductListNotifier(this._repository)
      : super(const ProductCatalogState(products: [], isLoading: true)) {
    loadInitial();
  }

  Future<void> loadInitial() async {
    state = state.copyWith(isLoading: true, errorMessage: null, skip: 0);
    try {
      final result = await _repository.getProducts(
        skip: 0,
        limit: _pageSize,
        category: state.category,
        search: state.query,
        sortBy: state.sortBy,
        order: state.order,
      );

      state = state.copyWith(
        products: result.products,
        total: result.total,
        skip: result.products.length,
        hasMore: result.products.length < result.total,
        isLoading: false,
        isStale: result.isStale,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> search(String query) async {
    if (state.query == query) return;
    state = state.copyWith(query: query, clearCategory: true);
    await loadInitial();
  }

  Future<void> filterCategory(String? category) async {
    if (state.category == category) return;
    if (category == null) {
      state = state.copyWith(clearCategory: true, query: '');
    } else {
      state = state.copyWith(category: category, query: '');
    }
    await loadInitial();
  }

  Future<void> setSort(String sortBy, String order) async {
    state = state.copyWith(sortBy: sortBy, order: order);
    await loadInitial();
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoadingMore: true);
    try {
      final result = await _repository.getProducts(
        skip: state.skip,
        limit: _pageSize,
        category: state.category,
        search: state.query,
        sortBy: state.sortBy,
        order: state.order,
      );

      final combined = [...state.products, ...result.products];
      state = state.copyWith(
        products: combined,
        skip: combined.length,
        hasMore: combined.length < result.total,
        isLoadingMore: false,
        isStale: result.isStale,
      );
    } catch (_) {
      state = state.copyWith(isLoadingMore: false);
    }
  }
}

final productListNotifierProvider =
    StateNotifierProvider<ProductListNotifier, ProductCatalogState>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return ProductListNotifier(repo);
});
