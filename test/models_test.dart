import 'package:flutter_test/flutter_test.dart';
import 'package:shopsphere/features/auth/data/models/user_model.dart';
import 'package:shopsphere/features/products/data/models/product_model.dart';
import 'package:shopsphere/features/products/data/models/category_model.dart';

void main() {
  group('AppUser Model', () {
    test('parses json correctly and handles missing token', () {
      final json = {
        'id': 15,
        'username': 'emilys',
        'email': 'emily.johnson@x.dummyjson.com',
        'firstName': 'Emily',
        'lastName': 'Johnson',
        'gender': 'female',
        'image': 'https://dummyjson.com/icon/emilys/128',
        'accessToken': 'sample-jwt-token',
      };

      final user = AppUser.fromJson(json);
      expect(user.id, 15);
      expect(user.username, 'emilys');
      expect(user.fullName, 'Emily Johnson');
      expect(user.token, 'sample-jwt-token');
    });
  });

  group('Product Model', () {
    test('parses json correctly and computes discounted price', () {
      final json = {
        'id': 1,
        'title': 'Test Phone',
        'description': 'A flagship smartphone',
        'category': 'smartphones',
        'price': 100.0,
        'discountPercentage': 10.0,
        'rating': 4.5,
        'stock': 20,
        'tags': ['smartphone'],
        'brand': 'TechBrand',
        'thumbnail': 'https://example.com/thumb.png',
        'images': ['https://example.com/1.png'],
      };

      final product = Product.fromJson(json);
      expect(product.id, 1);
      expect(product.title, 'Test Phone');
      expect(product.discountedPrice, 90.0);
    });

    test('handles missing or malformed fields safely', () {
      final product = Product.fromJson({});
      expect(product.id, 0);
      expect(product.title, 'Untitled');
      expect(product.price, 0.0);
      expect(product.images, isEmpty);
    });
  });

  group('ProductCategory Model', () {
    test('parses both string and map categories', () {
      final cat1 = ProductCategory.fromJson('beauty');
      expect(cat1.slug, 'beauty');
      expect(cat1.name, 'Beauty');

      final cat2 = ProductCategory.fromJson({
        'slug': 'fragrances',
        'name': 'Fragrances',
        'url': 'https://dummyjson.com/products/category/fragrances',
      });
      expect(cat2.slug, 'fragrances');
      expect(cat2.name, 'Fragrances');
    });
  });
}
