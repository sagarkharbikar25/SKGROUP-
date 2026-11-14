import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/models/product_model.dart';
import 'widgets/product_card.dart';
import 'widgets/search_filter_bar.dart';
import 'widgets/sort_bottom_sheet.dart';
import '../../../core/widgets/state_views.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  String _sortBy = 'id';
  String _order = 'asc';

  // Sample static catalog for Phase 1 frontend review (Phase 3 wires to Riverpod)
  final List<Product> _allProducts = const [
    Product(
      id: 1,
      title: 'Essence Mascara Lash Princess',
      description: 'The Essence Mascara Lash Princess is a popular mascara known for its volumizing and lengthening effects.',
      category: 'beauty',
      price: 9.99,
      discountPercentage: 7.17,
      rating: 4.94,
      stock: 5,
      tags: ['beauty', 'mascara'],
      brand: 'Essence',
      thumbnail: 'https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/thumbnail.png',
      images: ['https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/1.png'],
    ),
    Product(
      id: 2,
      title: 'Eyeshadow Palette with Mirror',
      description: 'The Eyeshadow Palette with Mirror offers a versatile range of eyeshadow shades.',
      category: 'beauty',
      price: 19.99,
      discountPercentage: 5.5,
      rating: 3.28,
      stock: 44,
      tags: ['beauty', 'eyeshadow'],
      brand: 'Glamour Beauty',
      thumbnail: 'https://cdn.dummyjson.com/products/images/beauty/Eyeshadow%20Palette%20with%20Mirror/thumbnail.png',
      images: ['https://cdn.dummyjson.com/products/images/beauty/Eyeshadow%20Palette%20with%20Mirror/1.png'],
    ),
    Product(
      id: 3,
      title: 'Powder Canister',
      description: 'The Powder Canister is a finely milled setting powder designed to set makeup.',
      category: 'beauty',
      price: 14.99,
      discountPercentage: 18.14,
      rating: 3.82,
      stock: 59,
      tags: ['beauty', 'powder'],
      brand: 'Velvet Touch',
      thumbnail: 'https://cdn.dummyjson.com/products/images/beauty/Powder%20Canister/thumbnail.png',
      images: ['https://cdn.dummyjson.com/products/images/beauty/Powder%20Canister/1.png'],
    ),
    Product(
      id: 4,
      title: 'Red Lipstick',
      description: 'The Red Lipstick is a classic and bold choice for adding a pop of color to your lips.',
      category: 'beauty',
      price: 12.99,
      discountPercentage: 19.03,
      rating: 2.51,
      stock: 68,
      tags: ['beauty', 'lipstick'],
      brand: 'Chic Cosmetics',
      thumbnail: 'https://cdn.dummyjson.com/products/images/beauty/Red%20Lipstick/thumbnail.png',
      images: ['https://cdn.dummyjson.com/products/images/beauty/Red%20Lipstick/1.png'],
    ),
  ];

  final List<String> _categories = const ['beauty', 'fragrances', 'furniture', 'groceries'];
  final Set<int> _favoriteIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SortBottomSheet(
        currentSortBy: _sortBy,
        currentOrder: _order,
        onSelect: (option) {
          setState(() {
            _sortBy = option.sortBy;
            _order = option.order;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filtered list
    final filtered = _allProducts.where((p) {
      final matchesSearch = _searchQuery.isEmpty ||
          p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.brand.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCat = _selectedCategory == null || p.category == _selectedCategory;
      return matchesSearch && matchesCat;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          SearchFilterBar(
            searchController: _searchController,
            onSearchChanged: (val) => setState(() => _searchQuery = val),
            categories: _categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
            onSortTap: _openSortSheet,
          ),
          Expanded(
            child: filtered.isEmpty
                ? const EmptyView(
                    title: 'No products found',
                    message: 'No items match your search or filter criteria.',
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      // Responsive column count based on width:
                      // <600dp: 2 columns, 600-900dp: 3 columns, >900dp: 4 columns
                      final int crossAxisCount = constraints.maxWidth < 600
                          ? 2
                          : (constraints.maxWidth < 900 ? 3 : 4);

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final product = filtered[index];
                          final isFav = _favoriteIds.contains(product.id);

                          return ProductCard(
                            product: product,
                            isFavorite: isFav,
                            onFavoriteToggle: () {
                              setState(() {
                                if (isFav) {
                                  _favoriteIds.remove(product.id);
                                } else {
                                  _favoriteIds.add(product.id);
                                }
                              });
                            },
                            onTap: () => context.push('/products/${product.id}', extra: product),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
