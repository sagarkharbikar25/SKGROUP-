import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../application/product_list_notifier.dart';
import '../../favorites/application/favorites_notifier.dart';
import 'widgets/product_card.dart';
import 'widgets/search_filter_bar.dart';
import 'widgets/sort_bottom_sheet.dart';
import '../../../core/widgets/state_views.dart';
import '../../../core/widgets/app_refresh.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(productListNotifierProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _openSortSheet() {
    final catalogState = ref.read(productListNotifierProvider);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SortBottomSheet(
        currentSortBy: catalogState.sortBy,
        currentOrder: catalogState.order,
        onSelect: (option) {
          ref.read(productListNotifierProvider.notifier).setSort(option.sortBy, option.order);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalogState = ref.watch(productListNotifierProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final favoritesNotifier = ref.watch(favoritesNotifierProvider.notifier);
    final favoriteProducts = ref.watch(favoritesNotifierProvider);

    final categories = categoriesAsync.maybeWhen(
      data: (cats) => cats.map((c) => c.slug).toList(),
      orElse: () => <String>[],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog'),
      ),
      body: Column(
        children: [
          // Stale / Offline Banner
          if (catalogState.isStale)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.amber.shade100,
              child: Row(
                children: [
                  Icon(Icons.cloud_off_rounded, size: 18, color: Colors.amber.shade900),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Offline Mode — Showing saved catalog data',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Search & Filter Bar
          SearchFilterBar(
            searchController: _searchController,
            onSearchChanged: (val) {
              ref.read(productListNotifierProvider.notifier).search(val);
            },
            categories: categories,
            selectedCategory: catalogState.category,
            onCategorySelected: (cat) {
              ref.read(productListNotifierProvider.notifier).filterCategory(cat);
            },
            onSortTap: _openSortSheet,
          ),

          // Catalog Content with AppRefresh pull-to-refresh
          Expanded(
            child: AppRefresh(
              onRefresh: () => ref.read(productListNotifierProvider.notifier).loadInitial(),
              child: catalogState.isLoading
                  ? const LoadingView(message: 'Loading products...')
                  : catalogState.errorMessage != null && catalogState.products.isEmpty
                      ? ErrorView(
                          message: catalogState.errorMessage!,
                          onRetry: () =>
                              ref.read(productListNotifierProvider.notifier).loadInitial(),
                        )
                      : catalogState.products.isEmpty
                          ? const CustomScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              slivers: [
                                SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: EmptyView(
                                    title: 'No products found',
                                    message:
                                        'Try adjusting your search query or category filters.',
                                  ),
                                ),
                              ],
                            )
                          : LayoutBuilder(
                              builder: (context, constraints) {
                                final int crossAxisCount = constraints.maxWidth < 600
                                    ? 2
                                    : (constraints.maxWidth < 900 ? 3 : 4);

                                return CustomScrollView(
                                  controller: _scrollController,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  slivers: [
                                    SliverPadding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16.0, 8.0, 16.0, 100.0),
                                      sliver: SliverGrid(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: crossAxisCount,
                                          childAspectRatio: 0.65,
                                          crossAxisSpacing: 14,
                                          mainAxisSpacing: 14,
                                        ),
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            final product = catalogState.products[index];
                                            final isFav = favoriteProducts
                                                .any((p) => p.id == product.id);

                                            return ProductCard(
                                              product: product,
                                              isFavorite: isFav,
                                              onFavoriteToggle: () {
                                                favoritesNotifier.toggleFavorite(product);
                                              },
                                              onTap: () => context.push(
                                                '/products/${product.id}',
                                                extra: product,
                                              ),
                                            );
                                          },
                                          childCount: catalogState.products.length,
                                        ),
                                      ),
                                    ),
                                    if (catalogState.isLoadingMore)
                                      const SliverToBoxAdapter(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 24.0),
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
            ),
          ),
        ],
      ),
    );
  }
}
