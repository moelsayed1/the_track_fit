import 'dart:developer';

import 'package:the_track_fit/core/constants/app_constants.dart';
import 'package:the_track_fit/core/services/api_service.dart';
import '../../domain/models/packages_response.dart';
import '../../domain/repositories/packages_repository.dart';

class PackagesRepositoryImpl implements PackagesRepository {
  final ApiService _apiService;

  PackagesRepositoryImpl({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<PackagesResponse> getActivePackages({int perPage = 10, int page = 1}) async {
    try {
      log('PackagesRepository: Getting active packages - perPage: $perPage, page: $page');
      
      final response = await _apiService.get(
        '${AppConstants.getActivePackagesEndpoint}?per_page=$perPage&page=$page',
      );

      log('PackagesRepository: Response status: ${response.statusCode}');
      log('PackagesRepository: Response data: ${response.data}');

      if (response.statusCode == 200) {
        return PackagesResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load packages: ${response.statusCode}');
      }
    } catch (e) {
      log('PackagesRepository: Error getting packages: $e');
      rethrow;
    }
  }
}
