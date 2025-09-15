import 'package:the_track_fit/core/services/api_service.dart';
import 'package:the_track_fit/core/constants/app_constants.dart';
import '../../domain/models/product_response.dart';

abstract class ProductRemoteDataSource {
  Future<ProductResponse> getNewProducts({int perPage = 8, int page = 1});
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService _apiService;

  ProductRemoteDataSourceImpl({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<ProductResponse> getNewProducts({int perPage = 10, int page = 1}) async {
    try {
      final response = await _apiService.get(
        AppConstants.getNewProductsUrl(perPage: perPage, page: page),
      );

      if (response.statusCode == 200) {
        return ProductResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
