import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../application/favorites_notifier.dart';
import '../../products/presentation/widgets/product_card.dart';
import '../../../core/widgets/state_views.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesNotifierProvider);
    final favoritesNotifier = ref.watch(favoritesNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Favorites', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: favorites.isEmpty
          ? EmptyView(
              icon: Icons.favorite_border_rounded,
              title: 'No favorites yet',
              message: 'Explore the catalog and tap the heart icon to save products here.',
              action: FilledButton(
                onPressed: () => context.go('/products'),
                child: const Text('Browse Products'),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final int crossAxisCount = constraints.maxWidth < 600
                    ? 2
                    : (constraints.maxWidth < 900 ? 3 : 4);

                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final product = favorites[index];
                    return ProductCard(
                      product: product,
                      isFavorite: true,
                      onFavoriteToggle: () {
                        favoritesNotifier.toggleFavorite(product);
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
