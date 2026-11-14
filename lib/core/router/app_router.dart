import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/scaffold_with_nav_bar.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/products/presentation/products_screen.dart';
import '../../features/products/presentation/product_details_screen.dart';
import '../../features/products/data/models/product_model.dart';
import '../../features/favorites/presentation/favorites_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final GlobalKey<NavigatorState> _shellNavigatorProductsKey = GlobalKey<NavigatorState>(debugLabel: 'products');
final GlobalKey<NavigatorState> _shellNavigatorFavoritesKey = GlobalKey<NavigatorState>(debugLabel: 'favorites');
final GlobalKey<NavigatorState> _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    // Bottom navigation shell
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorProductsKey,
          routes: [
            GoRoute(
              path: '/products',
              builder: (context, state) => const ProductsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorFavoritesKey,
          routes: [
            GoRoute(
              path: '/favorites',
              builder: (context, state) => const FavoritesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorProfileKey,
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/products/:id',
      builder: (context, state) {
        final product = state.extra as Product?;
        if (product != null) {
          return ProductDetailsScreen(product: product);
        }
        return const Scaffold(
          body: Center(child: Text('Product details not available')),
        );
      },
    ),
  ],
);
