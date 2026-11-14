class ApiConstants {
  ApiConstants._();

  // Overridable with --dart-define=BASE_URL=...
  static const String defaultBaseUrl = 'https://dummyjson.com';
  static const String baseUrl = String.fromEnvironment('BASE_URL', defaultValue: defaultBaseUrl);

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  // Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String meEndpoint = '/auth/me';
  static const String signupEndpoint = '/users/add';
  static const String productsEndpoint = '/products';
  static const String searchEndpoint = '/products/search';
  static const String categoriesEndpoint = '/products/categories';
  static const String categoryProductsEndpoint = '/products/category';
}
