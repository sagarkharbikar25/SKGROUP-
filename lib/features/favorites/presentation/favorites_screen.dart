import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../products/data/models/product_model.dart';
import '../../products/presentation/widgets/product_card.dart';
import '../../../core/widgets/state_views.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<Product> _favoriteProducts = [
    const Product(
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Collection'),
      ),
      body: _favoriteProducts.isEmpty
          ? EmptyView(
              icon: Icons.favorite_border_rounded,
              title: 'No saved items yet',
              message: 'Explore the catalog and tap the heart icon to save products here.',
              action: FilledButton(
                onPressed: () => context.go('/products'),
                child: const Text('Explore Catalog'),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final int crossAxisCount = constraints.maxWidth < 600
                    ? 2
                    : (constraints.maxWidth < 900 ? 3 : 4);

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 100.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: _favoriteProducts.length,
                  itemBuilder: (context, index) {
                    final product = _favoriteProducts[index];
                    return ProductCard(
                      product: product,
                      isFavorite: true,
                      onFavoriteToggle: () {
                        setState(() {
                          _favoriteProducts.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Removed from favorites'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      onTap: () => context.push('/products/${product.id}', extra: product),
                    );
                  },
                );
              },
            ),
    );
  }
}
