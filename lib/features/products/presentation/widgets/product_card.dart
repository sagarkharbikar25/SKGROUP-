import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/product_model.dart';
import '../../../../core/theme/app_tokens.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.m),
        border: Border.all(color: cs.outline, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.15,
                  child: Hero(
                    tag: 'product_image_${product.id}',
                    child: CachedNetworkImage(
                      imageUrl: product.thumbnail,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: cs.surface,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cs.primary,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: cs.surface,
                        child: Icon(Icons.image_outlined, color: cs.onSurfaceVariant),
                      ),
                    ),
                  ),
                ),

                // Editorial Corner Price Pill (Overlapping)
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(color: cs.outline, width: 1),
                    ),
                    child: Text(
                      '\$${product.discountedPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                ),

                // Favorite Icon
                Positioned(
                  top: 6,
                  right: 6,
                  child: Material(
                    color: cs.surface.withOpacity(0.9),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onFavoriteToggle,
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Icon(
                          isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                          size: 18,
                          color: isFavorite ? Colors.red : cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Card Text Info
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: cs.secondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Rating row
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                      const SizedBox(width: 3),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),
                      if (product.discountPercentage > 0) ...[
                        const Spacer(),
                        Text(
                          '-${product.discountPercentage.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: cs.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
