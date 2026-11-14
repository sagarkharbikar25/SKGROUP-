class ProductCategory {
  final String slug;
  final String name;
  final String url;

  const ProductCategory({
    required this.slug,
    required this.name,
    required this.url,
  });

  factory ProductCategory.fromJson(dynamic json) {
    if (json is String) {
      return ProductCategory(
        slug: json,
        name: json[0].toUpperCase() + json.substring(1),
        url: '',
      );
    }
    if (json is Map<String, dynamic>) {
      return ProductCategory(
        slug: json['slug'] as String? ?? '',
        name: json['name'] as String? ?? '',
        url: json['url'] as String? ?? '',
      );
    }
    return const ProductCategory(slug: '', name: '', url: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'url': url,
    };
  }
}
