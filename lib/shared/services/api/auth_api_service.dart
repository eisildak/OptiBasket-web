import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:optibasket/core/constants/app_constants.dart';
import 'package:optibasket/shared/models/user_model.dart';

part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  @POST(ApiEndpoints.login)
  Future<HttpResponse<Map<String, dynamic>>> login(
    @Body() LoginRequest request,
  );

  @POST(ApiEndpoints.register)
  Future<HttpResponse<Map<String, dynamic>>> register(
    @Body() RegisterRequest request,
  );

  @POST(ApiEndpoints.refreshToken)
  Future<HttpResponse<Map<String, dynamic>>> refreshToken(
    @Body() Map<String, String> refreshToken,
  );

  @POST(ApiEndpoints.logout)
  Future<HttpResponse<void>> logout();

  @GET(ApiEndpoints.userProfile)
  Future<HttpResponse<User>> getUserProfile();
}
