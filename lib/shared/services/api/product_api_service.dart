import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:optibasket/core/constants/app_constants.dart';
import 'package:optibasket/shared/models/product_model.dart';

part 'product_api_service.g.dart';

@RestApi()
abstract class ProductApiService {
  factory ProductApiService(Dio dio, {String baseUrl}) = _ProductApiService;

  @GET(ApiEndpoints.products)
  Future<HttpResponse<List<Product>>> getProducts({
    @Query('page') int page = 1,
    @Query('limit') int limit = AppConstants.defaultPageSize,
    @Query('category') String? category,
    @Query('search') String? search,
  });

  @GET(ApiEndpoints.productById)
  Future<HttpResponse<Product>> getProductById(@Path('id') String id);

  @GET(ApiEndpoints.productSearch)
  Future<HttpResponse<List<Product>>> searchProducts(
    @Query('q') String query,
  );

  @GET(ApiEndpoints.productCategories)
  Future<HttpResponse<List<ProductCategory>>> getCategories();

  @GET('${ApiEndpoints.products}/{id}/price-history')
  Future<HttpResponse<List<PriceHistory>>> getPriceHistory(
    @Path('id') String productId,
    @Query('from') String? fromDate,
    @Query('to') String? toDate,
  );
}
