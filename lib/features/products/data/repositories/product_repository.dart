import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/storage/prefs_store.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

class ProductFetchResult {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;
  final bool isStale;

  const ProductFetchResult({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
    this.isStale = false,
  });
}

abstract class ProductRepository {
  Future<ProductFetchResult> getProducts({
    int skip = 0,
    int limit = 20,
    String? category,
    String? search,
    String? sortBy,
    String? order,
  });

  Future<List<ProductCategory>> getCategories();
  Future<Product> getProductById(int id);
}

class RemoteProductRepository implements ProductRepository {
  final Dio _dio;
  final PrefsStore _prefsStore;

  RemoteProductRepository(this._dio, this._prefsStore);

  @override
  Future<ProductFetchResult> getProducts({
    int skip = 0,
    int limit = 20,
    String? category,
    String? search,
    String? sortBy,
    String? order,
  }) async {
    try {
      String endpoint = ApiConstants.productsEndpoint;
      final Map<String, dynamic> queryParams = {
        'skip': skip,
        'limit': limit,
      };

      if (search != null && search.trim().isNotEmpty) {
        endpoint = ApiConstants.searchEndpoint;
        queryParams['q'] = search.trim();
      } else if (category != null && category.trim().isNotEmpty) {
        endpoint = '${ApiConstants.categoryProductsEndpoint}/${category.trim()}';
      }

      if (sortBy != null && sortBy.isNotEmpty) {
        queryParams['sortBy'] = sortBy;
        queryParams['order'] = order ?? 'asc';
      }

      final response = await _dio.get(endpoint, queryParameters: queryParams);
      final data = response.data as Map<String, dynamic>;

      // Cache primary first page
      if (skip == 0 && (search == null || search.isEmpty) && category == null) {
        await _prefsStore.setCachedProducts(jsonEncode(data));
      }

      return _parseResponse(data, isStale: false);
    } catch (_) {
      // Offline / API down fallback
      return await _loadOfflineFallback();
    }
  }

  ProductFetchResult _parseResponse(Map<String, dynamic> data, {required bool isStale}) {
    final list = (data['products'] as List<dynamic>?)
            ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return ProductFetchResult(
      products: list,
      total: data['total'] as int? ?? list.length,
      skip: data['skip'] as int? ?? 0,
      limit: data['limit'] as int? ?? list.length,
      isStale: isStale,
    );
  }

  Future<ProductFetchResult> _loadOfflineFallback() async {
    // 1. Try SharedPreferences cache
    final cached = _prefsStore.getCachedProducts();
    if (cached != null && cached.isNotEmpty) {
      try {
        final data = jsonDecode(cached) as Map<String, dynamic>;
        return _parseResponse(data, isStale: true);
      } catch (_) {}
    }

    // 2. Try bundled asset sample JSON
    try {
      final jsonString = await rootBundle.loadString('assets/sample/products.json');
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      return _parseResponse(data, isStale: true);
    } catch (_) {
      throw const NetworkFailure('Failed to connect to network and no offline data found.');
    }
  }

  @override
  Future<List<ProductCategory>> getCategories() async {
    try {
      final response = await _dio.get(ApiConstants.categoriesEndpoint);
      if (response.data is List) {
        return (response.data as List<dynamic>)
            .map((e) => ProductCategory.fromJson(e))
            .toList();
      }
      return [];
    } catch (_) {
      // Offline fallback categories
      return const [
        ProductCategory(slug: 'beauty', name: 'Beauty', url: ''),
        ProductCategory(slug: 'fragrances', name: 'Fragrances', url: ''),
        ProductCategory(slug: 'furniture', name: 'Furniture', url: ''),
        ProductCategory(slug: 'groceries', name: 'Groceries', url: ''),
      ];
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      final response = await _dio.get('${ApiConstants.productsEndpoint}/$id');
      return Product.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      // Fallback from asset
      final fallback = await _loadOfflineFallback();
      final match = fallback.products.where((p) => p.id == id).firstOrNull;
      if (match != null) return match;
      throw const NetworkFailure('Unable to load product details.');
    }
  }
}
