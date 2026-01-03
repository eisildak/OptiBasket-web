import 'package:dio/dio.dart';
import '../../shared/models/product_model.dart';
import 'api_client.dart';

class ProductApiService {
  final ApiClient _apiClient;

  ProductApiService(this._apiClient);

  Future<List<Product>> getProducts({
    String? search,
    String? category,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.dio.get('/products', queryParameters: {
        if (search != null) 'search': search,
        if (category != null) 'category': category,
        'page': page,
        'limit': limit,
      });

      final List<dynamic> data = response.data is List 
          ? response.data 
          : (response.data['data'] ?? []);
      
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Get products failed: $e');
    }
  }

  Future<Product> getProductById(String id) async {
    try {
      final response = await _apiClient.dio.get('/products/$id');
      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Get product failed: $e');
    }
  }

  Future<List<PriceHistory>> getPriceHistory(String productId) async {
    try {
      final response = await _apiClient.dio.get('/products/$productId/price-history');
      final List<dynamic> data = response.data is List 
          ? response.data 
          : (response.data['data'] ?? []);
      
      return data.map((json) => PriceHistory.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Get price history failed: $e');
    }
  }
}
