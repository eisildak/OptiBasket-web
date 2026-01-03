# 🔌 Backend API Entegrasyon Kılavuzu

Bu belge, OptiBasket Flutter uygulamasını backend API ile entegre etmek için adım adım talimatlar içerir.

## 📋 İçindekiler

1. [Backend Gereksinimleri](#backend-gereksinimleri)
2. [API Yapılandırması](#api-yapılandırması)
3. [Riverpod Provider'ları Oluşturma](#riverpod-providerları-oluşturma)
4. [Test ve Debug](#test-ve-debug)
5. [Production Hazırlık](#production-hazırlık)

---

## 1️⃣ Backend Gereksinimleri

### Gerekli Endpoint'ler

Backend ekibinizin aşağıdaki endpoint'leri implement etmesi gerekiyor:

#### 🔐 Authentication
```
POST   /api/v1/auth/register      - Yeni kullanıcı kaydı
POST   /api/v1/auth/login         - Kullanıcı girişi
POST   /api/v1/auth/refresh       - Token yenileme
POST   /api/v1/auth/logout        - Çıkış
GET    /api/v1/user/profile       - Kullanıcı profili
PUT    /api/v1/user/profile       - Profil güncelleme
```

#### 📦 Products
```
GET    /api/v1/products                      - Ürün listesi (pagination)
GET    /api/v1/products/{id}                 - Tek ürün detayı
GET    /api/v1/products/search?q={query}     - Ürün arama
GET    /api/v1/products/categories           - Kategori listesi
GET    /api/v1/products/{id}/price-history   - Fiyat geçmişi
```

#### 🛒 Cart
```
GET    /api/v1/cart                  - Sepeti görüntüle
POST   /api/v1/cart/add              - Sepete ürün ekle
PUT    /api/v1/cart/update/{itemId}  - Sepet öğesini güncelle
DELETE /api/v1/cart/remove/{itemId}  - Sepetten çıkar
DELETE /api/v1/cart/clear            - Sepeti temizle
```

#### 📊 Comparison
```
POST   /api/v1/comparison/compare    - Fiyat karşılaştırması yap
GET    /api/v1/comparison/history    - Geçmiş karşılaştırmalar
GET    /api/v1/comparison/savings    - Tasarruf raporu
```

#### 👨‍💼 Admin
```
GET    /api/v1/admin/users/pending           - Onay bekleyen kullanıcılar
POST   /api/v1/admin/users/approve/{userId}  - Kullanıcı onayla
POST   /api/v1/admin/users/reject/{userId}   - Kullanıcı reddet
GET    /api/v1/admin/products                - Tüm ürünler (admin)
POST   /api/v1/admin/products                - Yeni ürün ekle
PUT    /api/v1/admin/products/{id}           - Ürün güncelle
PUT    /api/v1/admin/products/{id}/price     - Fiyat güncelle
DELETE /api/v1/admin/products/{id}           - Ürün sil
```

### Beklenen Response Formatları

#### Success Response
```json
{
  "success": true,
  "data": { ... },
  "message": "Operation successful"
}
```

#### Error Response
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input",
    "details": [...]
  }
}
```

#### Login Response Example
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "user_123",
      "email": "john@company.com",
      "firstName": "John",
      "lastName": "Doe",
      "companyName": "ABC GmbH",
      "vatNumber": "DE123456789",
      "role": "customer",
      "status": "approved",
      "createdAt": "2026-01-01T00:00:00Z"
    },
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "expiresIn": 3600
    }
  }
}
```

#### Products List Response Example
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "prod_123",
        "code": "PRD001",
        "name": "Tomaten Bio 1kg",
        "category": "Gemüse",
        "price": 3.99,
        "unit": "kg",
        "description": "Frische Bio-Tomaten",
        "stock": 150,
        "imageUrl": "https://cdn.example.com/tomaten.jpg",
        "createdAt": "2026-01-01T00:00:00Z",
        "updatedAt": "2026-01-02T00:00:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 150,
      "totalPages": 8,
      "hasNext": true,
      "hasPrev": false
    }
  }
}
```

---

## 2️⃣ API Yapılandırması

### Adım 1: Base URL Güncelleme

`lib/core/constants/app_constants.dart` dosyasını açın ve backend URL'inizi girin:

```dart
class AppConstants {
  // PRODUCTION
  static const String baseUrl = 'https://api.optibasket.com/v1';
  
  // DEVELOPMENT
  // static const String baseUrl = 'http://localhost:3000/api/v1';
  
  // STAGING
  // static const String baseUrl = 'https://staging-api.optibasket.com/v1';
}
```

### Adım 2: Environment Dosyası (.env)

Proje root'unda `.env` dosyası oluşturun:

```env
# API Configuration
API_BASE_URL=https://api.optibasket.com/v1
API_TIMEOUT=30000

# Environment
ENVIRONMENT=development

# Optional: API Keys
API_KEY=your_api_key_here
```

### Adım 3: Code Generation

API servislerini generate edin:

```bash
# Tüm bağımlılıkları yükle
flutter pub get

# Code generation (tek seferlik)
flutter pub run build_runner build --delete-conflicting-outputs

# Veya watch mode (otomatik regenerate)
flutter pub run build_runner watch --delete-conflicting-outputs
```

Bu komut şu dosyaları oluşturacak:
- `auth_api_service.g.dart`
- `product_api_service.g.dart`
- `user_model.g.dart`, `user_model.freezed.dart`
- `product_model.g.dart`, `product_model.freezed.dart`
- `cart_model.g.dart`, `cart_model.freezed.dart`
- `comparison_model.g.dart`, `comparison_model.freezed.dart`

---

## 3️⃣ Riverpod Provider'ları Oluşturma

### Authentication Provider

`lib/features/auth/providers/auth_provider.dart` oluşturun:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:optibasket/core/network/dio_client.dart';
import 'package:optibasket/shared/models/user_model.dart';
import 'package:optibasket/shared/services/api/auth_api_service.dart';

// Dio Client Provider
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

// Auth API Service Provider
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return AuthApiService(dio);
});

// Auth State Provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authApiServiceProvider);
  final dioClient = ref.watch(dioClientProvider);
  return AuthNotifier(authService, dioClient);
});

// Auth State
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthApiService _authService;
  final DioClient _dioClient;

  AuthNotifier(this._authService, this._dioClient) : super(AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // TODO: Check if user is logged in (token exists)
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _authService.login(request);

      if (response.response.statusCode == 200) {
        final data = response.data;
        final user = User.fromJson(data['user']);
        final tokens = AuthTokens.fromJson(data['tokens']);

        await _dioClient.setAuthToken(
          tokens.accessToken,
          tokens.refreshToken,
        );

        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      rethrow;
    }
  }

  Future<void> register(RegisterRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _authService.register(request);

      if (response.response.statusCode == 201) {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } finally {
      await _dioClient.clearAuthToken();
      state = AuthState();
    }
  }
}
```

### Products Provider

`lib/features/products/providers/products_provider.dart` oluşturun:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:optibasket/core/network/dio_client.dart';
import 'package:optibasket/shared/models/product_model.dart';
import 'package:optibasket/shared/services/api/product_api_service.dart';

// Product API Service Provider
final productApiServiceProvider = Provider<ProductApiService>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return ProductApiService(dio);
});

// Products List Provider
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final service = ref.watch(productApiServiceProvider);
  final response = await service.getProducts();
  return response.data;
});

// Product Search Provider
final productSearchProvider = FutureProvider.family<List<Product>, String>(
  (ref, query) async {
    if (query.isEmpty) return [];
    final service = ref.watch(productApiServiceProvider);
    final response = await service.searchProducts(query);
    return response.data;
  },
);

// Categories Provider
final categoriesProvider = FutureProvider<List<ProductCategory>>((ref) async {
  final service = ref.watch(productApiServiceProvider);
  final response = await service.getCategories();
  return response.data;
});
```

---

## 4️⃣ UI ile Entegrasyon

### Login Screen Güncelleme

`lib/features/auth/presentation/screens/login_screen.dart` dosyasında:

```dart
Future<void> _handleLogin() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    // Riverpod provider kullanarak login
    await ref.read(authStateProvider.notifier).login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    
    if (mounted) {
      context.go('/products');
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
```

### Products Screen Güncelleme

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final productsAsync = ref.watch(productsProvider);

  return Scaffold(
    appBar: AppBar(title: const Text('Products')),
    body: productsAsync.when(
      data: (products) => ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(product: product);
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    ),
  );
}
```

---

## 5️⃣ Test ve Debug

### Local Test (Mock Server)

**Option 1: JSON Server**

```bash
# Install
npm install -g json-server

# Create db.json
touch db.json
```

`db.json` içeriği:
```json
{
  "products": [
    {
      "id": "1",
      "code": "PRD001",
      "name": "Test Product 1",
      "category": "Test",
      "price": 29.99,
      "unit": "piece",
      "stock": 100
    }
  ]
}
```

```bash
# Run server
json-server --watch db.json --port 3000
```

**Option 2: Postman Mock Server**

1. Postman'de Collection oluşturun
2. Her endpoint için Example Response ekleyin
3. Mock Server açın
4. Mock URL'i uygulamada kullanın

### API Test Komutları

```bash
# Login test
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"12345678"}'

# Products test
curl http://localhost:3000/api/v1/products

# With auth token
curl http://localhost:3000/api/v1/cart \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Debug Logging

DioClient zaten logging içeriyor. Console'da görmek için:

```dart
// lib/core/network/dio_client.dart
final Logger _logger = Logger();

// Her request/response loglanır
_logger.d('Request: ${options.method} ${options.path}');
_logger.d('Response: ${response.statusCode}');
_logger.e('Error: ${error.response?.statusCode}');
```

---

## 6️⃣ Production Hazırlık

### Environment Separation

```dart
enum Environment { development, staging, production }

class AppConfig {
  static Environment get environment {
    const env = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
    return Environment.values.firstWhere(
      (e) => e.name == env,
      orElse: () => Environment.development,
    );
  }

  static String get baseUrl {
    switch (environment) {
      case Environment.development:
        return 'http://localhost:3000/api/v1';
      case Environment.staging:
        return 'https://staging-api.optibasket.com/v1';
      case Environment.production:
        return 'https://api.optibasket.com/v1';
    }
  }
}
```

### Build Commands

```bash
# Development
flutter run --dart-define=ENVIRONMENT=development

# Staging
flutter build apk --dart-define=ENVIRONMENT=staging

# Production
flutter build apk --release --dart-define=ENVIRONMENT=production
```

### Security Checklist

- [ ] API keys .gitignore'a eklendi
- [ ] HTTPS kullanılıyor
- [ ] Token güvenli storage'da (FlutterSecureStorage)
- [ ] API timeout ayarlandı
- [ ] Error messages kullanıcıya güvenli gösteriliyor
- [ ] Rate limiting kontrolü var
- [ ] Certificate pinning (opsiyonel)

---

## 7️⃣ Sık Karşılaşılan Sorunlar

### Problem: "Code generation failed"

**Çözüm:**
```bash
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Problem: "Network error"

**Çözüm:**
- Base URL'i kontrol edin
- Backend'in çalıştığından emin olun
- CORS ayarlarını kontrol edin (web için)
- Android için `android/app/src/main/AndroidManifest.xml` içinde:
  ```xml
  <uses-permission android:name="android.permission.INTERNET"/>
  ```

### Problem: "401 Unauthorized"

**Çözüm:**
- Token'ın doğru kaydedildiğini kontrol edin
- Token expiry süresini kontrol edin
- Refresh token mekanizmasını test edin

---

## 📚 Ek Kaynaklar

- [Dio Documentation](https://pub.dev/packages/dio)
- [Retrofit Documentation](https://pub.dev/packages/retrofit)
- [Riverpod Documentation](https://riverpod.dev)
- [JSON Serialization Guide](https://docs.flutter.dev/data-and-backend/json)

---

## ✅ Checklist

Backend ekibinizle paylaşmak için:

- [ ] Tüm endpoint'ler implement edildi
- [ ] Response formatları standartlaştırıldı
- [ ] JWT token authentication çalışıyor
- [ ] CORS ayarları yapıldı
- [ ] Rate limiting ayarlandı
- [ ] Error handling standartlaştırıldı
- [ ] Pagination çalışıyor
- [ ] File upload (ürün resimleri için)
- [ ] Swagger/OpenAPI documentation hazır
- [ ] Staging environment hazır

---

**Son Güncelleme:** 2 Ocak 2026
