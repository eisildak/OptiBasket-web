import 'package:flutter/foundation.dart';

class AppConstants {
  // App Info
  static const String appName = 'OptiBasket';
  static const String appVersion = '1.0.0';
  
  // API
  // MOCK SERVER (Development)
  static const String _androidBaseUrl = 'http://10.0.2.2:3000';
  static const String _localBaseUrl = 'http://localhost:3000';
  
  static String get baseUrl {
    if (kIsWeb) return _localBaseUrl;
    if (defaultTargetPlatform == TargetPlatform.android) return _androidBaseUrl;
    return _localBaseUrl;
  }
  
  // PRODUCTION
  // static const String baseUrl = 'https://api.optibasket.com/v1';
  
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String languageKey = 'language';
  static const String themeKey = 'theme';
  
  // Date & Time
  static const int priceHistoryWeeks = 4;
  static const String dateFormat = 'dd.MM.yyyy';
  static const String dateTimeFormat = 'dd.MM.yyyy HH:mm';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  
  // UI
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultElevation = 2.0;
}

class ApiEndpoints {
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String verifyEmail = '/auth/verify-email';
  
  // User
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/update';
  static const String changePassword = '/user/change-password';
  
  // Products
  static const String products = '/products';
  static const String productById = '/products/{id}';
  static const String productSearch = '/products/search';
  static const String productCategories = '/categories';
  
  // Cart
  static const String cart = '/cart';
  static const String addToCart = '/cart/add';
  static const String updateCartItem = '/cart/update/{id}';
  static const String removeFromCart = '/cart/remove/{id}';
  static const String clearCart = '/cart/clear';
  
  // Price Comparison
  static const String comparePrice = '/comparison/compare';
  static const String priceHistory = '/priceHistory';
  static const String savingsReport = '/comparisons';
  
  // Admin
  static const String pendingUsers = '/pendingUsers';
  static const String approveUser = '/admin/users/approve/{id}';
  static const String rejectUser = '/admin/users/reject/{id}';
  static const String manageProducts = '/admin/products';
  static const String updatePrice = '/admin/products/{id}/price';
}
