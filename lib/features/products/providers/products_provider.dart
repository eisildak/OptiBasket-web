import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:optibasket/features/auth/providers/auth_provider.dart';
import 'package:optibasket/shared/models/product_model.dart';
import 'package:optibasket/shared/services/api/product_api_service.dart';

// Product API Service Provider
final productApiServiceProvider = Provider<ProductApiService>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return ProductApiService(dio);
});

// Products State
class ProductsState {
  final List<Product> products;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasMore;

  ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
  });

  ProductsState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

// Products Notifier
class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductApiService _productService;

  ProductsNotifier(this._productService) : super(ProductsState());

  Future<void> fetchProducts({bool refresh = false}) async {
    if (refresh) {
      state = ProductsState(isLoading: true);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final page = refresh ? 1 : state.currentPage;
      final response = await _productService.getProducts(page: page);

      if (response.response.statusCode == 200) {
        final newProducts = response.data;
        final allProducts = refresh 
            ? newProducts 
            : [...state.products, ...newProducts];

        state = state.copyWith(
          products: allProducts,
          isLoading: false,
          currentPage: page,
          hasMore: newProducts.isNotEmpty,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load products: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    await fetchProducts();
  }

  Future<void> refresh() async {
    await fetchProducts(refresh: true);
  }

  Future<List<Product>> searchProducts(String query) async {
    if (query.isEmpty) return [];
    
    try {
      final response = await _productService.searchProducts(query);
      if (response.response.statusCode == 200) {
        return response.data;
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

// Products Provider
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final service = ref.watch(productApiServiceProvider);
  return ProductsNotifier(service);
});

// Product by ID Provider
final productByIdProvider = FutureProvider.family<Product, String>((ref, id) async {
  final service = ref.watch(productApiServiceProvider);
  final response = await service.getProductById(id);
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

// Price History Provider
final priceHistoryProvider = FutureProvider.family<List<PriceHistory>, String>(
  (ref, productId) async {
    final service = ref.watch(productApiServiceProvider);
    final response = await service.getPriceHistory(productId);
    return response.data;
  },
);
