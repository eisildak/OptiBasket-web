import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:optibasket/features/auth/presentation/screens/login_screen.dart';
import 'package:optibasket/features/auth/presentation/screens/register_screen.dart';
import 'package:optibasket/features/auth/presentation/screens/profile_screen.dart';
import 'package:optibasket/features/products/presentation/screens/products_screen.dart';
import 'package:optibasket/features/cart/presentation/screens/cart_screen.dart';
import 'package:optibasket/features/comparison/presentation/screens/comparison_screen.dart';
import 'package:optibasket/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:optibasket/shared/presentation/screens/splash_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String products = '/products';
  static const String cart = '/cart';
  static const String comparison = '/comparison';
  static const String adminDashboard = '/admin';
  static const String profile = '/profile';
  
  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: products,
        name: 'products',
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: cart,
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: comparison,
        name: 'comparison',
        builder: (context, state) => const ComparisonScreen(),
      ),
      GoRoute(
        path: adminDashboard,
        name: 'admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.matchedLocation}'),
      ),
    ),
  );
}
