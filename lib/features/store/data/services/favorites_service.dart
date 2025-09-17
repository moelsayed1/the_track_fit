import 'dart:developer';
import 'package:the_track_fit/core/constants/app_constants.dart';
import 'package:the_track_fit/core/services/api_service.dart';

class FavoritesService {
  final ApiService _apiService;

  FavoritesService({required ApiService apiService}) : _apiService = apiService;

  /// Toggle favorite status for a product or exercise
  /// Returns true if added to favorites, false if removed
  Future<bool> toggleFavorite({
    required String type, // 'product' or 'exercise'
    required int id,
  }) async {
    try {
      log('FavoritesService: Toggling favorite for $type with id: $id');
      
      final response = await _apiService.postForm(
        AppConstants.favoritesToggleEndpoint,
        data: {
          'type': type,
          'id': id.toString(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        final message = responseData['message'] as String? ?? '';
        
        log('FavoritesService: API Response - $message');
        
        // Check if item was added or removed based on message
        final wasAdded = message.toLowerCase().contains('added');
        log('FavoritesService: Item was ${wasAdded ? 'added to' : 'removed from'} favorites');
        
        return wasAdded;
      } else {
        log('FavoritesService: API Error - Status: ${response.statusCode}');
        throw Exception('Failed to toggle favorite: ${response.statusCode}');
      }
    } catch (e) {
      log('FavoritesService: Error toggling favorite: $e');
      rethrow;
    }
  }

  /// Toggle favorite for a product
  Future<bool> toggleProductFavorite(int productId) async {
    return await toggleFavorite(type: 'product', id: productId);
  }

  /// Toggle favorite for an exercise
  Future<bool> toggleExerciseFavorite(int exerciseId) async {
    return await toggleFavorite(type: 'exercise', id: exerciseId);
  }

  /// Get all favorite products
  Future<List<Map<String, dynamic>>> getFavoriteProducts() async {
    try {
      log('FavoritesService: Fetching favorite products...');
      
      final response = await _apiService.get(AppConstants.favoritesProductsEndpoint);

      if (response.statusCode == 200) {
        final responseData = response.data;
        final products = responseData['data'] as List<dynamic>? ?? [];
        
        log('FavoritesService: Retrieved ${products.length} favorite products');
        return products.cast<Map<String, dynamic>>();
      } else {
        log('FavoritesService: API Error - Status: ${response.statusCode}');
        throw Exception('Failed to fetch favorite products: ${response.statusCode}');
      }
    } catch (e) {
      log('FavoritesService: Error fetching favorite products: $e');
      rethrow;
    }
  }
}
