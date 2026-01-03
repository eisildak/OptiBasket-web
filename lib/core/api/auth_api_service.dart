import 'package:dio/dio.dart';
import '../../shared/models/user_model.dart';
import 'api_client.dart';

class AuthApiService {
  final ApiClient _apiClient;

  AuthApiService(this._apiClient);

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String companyName,
    required String vatNumber,
    required String phone,
  }) async {
    try {
      final response = await _apiClient.dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'companyName': companyName,
        'vatNumber': vatNumber,
        'phone': phone,
      });
      return response.data;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<User> getProfile() async {
    try {
      final response = await _apiClient.dio.get('/auth/profile');
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Get profile failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.dio.post('/auth/logout');
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}
