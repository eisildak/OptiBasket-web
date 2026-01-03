import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:optibasket/core/api/auth_api_service.dart';
import 'package:optibasket/core/providers/api_provider.dart';
import 'package:optibasket/shared/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main()');
});

final authApiServiceProvider = Provider((ref) {
  return AuthApiService(ref.watch(apiClientProvider));
});

final currentUserProvider = StateProvider<User?>((ref) => null);

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final Ref _ref;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthNotifier(this._ref) : super(const AsyncValue.loading()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token != null) {
        final authService = _ref.read(authApiServiceProvider);
        final user = await authService.getProfile();
        _ref.read(currentUserProvider.notifier).state = user;
        state = AsyncValue.data(user);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e) {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final authService = _ref.read(authApiServiceProvider);
      final response = await authService.login(email: email, password: password);
      
      final token = response['token'] ?? response['access_token'];
      await _storage.write(key: 'auth_token', value: token);
      
      final user = User.fromJson(response['user'] ?? response);
      _ref.read(currentUserProvider.notifier).state = user;
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String companyName,
    required String vatNumber,
    required String phone,
  }) async {
    state = const AsyncValue.loading();
    try {
      final authService = _ref.read(authApiServiceProvider);
      final response = await authService.register(
        email: email,
        password: password,
        companyName: companyName,
        vatNumber: vatNumber,
        phone: phone,
      );
      
      final token = response['token'] ?? response['access_token'];
      if (token != null) {
        await _storage.write(key: 'auth_token', value: token);
      }
      
      final user = User.fromJson(response['user'] ?? response);
      _ref.read(currentUserProvider.notifier).state = user;
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> logout() async {
    try {
      final authService = _ref.read(authApiServiceProvider);
      await authService.logout();
    } catch (e) {
      // Ignore errors during logout
    } finally {
      await _storage.delete(key: 'auth_token');
      _ref.read(currentUserProvider.notifier).state = null;
      state = const AsyncValue.data(null);
    }
  }
}
