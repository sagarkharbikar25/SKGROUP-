import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../products/data/models/product_model.dart';
import '../../products/presentation/widgets/product_card.dart';
import '../../../core/theme/app_tokens.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Product> _featuredProducts = [
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
      images: [
        'https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/1.png'
      ],
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
      images: [
        'https://cdn.dummyjson.com/products/images/beauty/Eyeshadow%20Palette%20with%20Mirror/1.png'
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Editorial Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EDITION 2026 • CATALOG',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Curated for you.',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.6,
                              color: cs.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search_rounded, color: cs.onSurface),
                      onPressed: () => context.go('/products'),
                    ),
                  ],
                ),
              ),

              // Full-Bleed Featured Card with Editorial Pill
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: InkWell(
                  onTap: () => context.push('/products/1', extra: _featuredProducts.first),
                  borderRadius: BorderRadius.circular(AppRadius.l),
                  child: Container(
                    height: 240,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(AppRadius.l),
                      border: Border.all(color: cs.outline, width: 1.2),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: 'https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/1.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                cs.onSurface.withOpacity(0.75),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: cs.primary,
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
                            child: const Text(
                              'FEATURED SPOTLIGHT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Essence Mascara Lash Princess',
                                      style: TextStyle(
                                        fontFamily: 'serif',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Top rated beauty essential',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.85),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                ),
                                child: Text(
                                  '\$9.99',
                                  style: TextStyle(
                                    fontFamily: 'serif',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: cs.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Section Title with "See all"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trending Now',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/products'),
                      child: Row(
                        children: [
                          Text('See all', style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 16, color: cs.primary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Horizontal product cards
              SizedBox(
                height: 280,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: _featuredProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final product = _featuredProducts[index];
                    return SizedBox(
                      width: 180,
                      child: ProductCard(
                        product: product,
                        onTap: () => context.push('/products/${product.id}', extra: product),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
