import 'dart:developer';

import 'package:the_track_fit/core/services/api_service.dart';
import '../../data/repositories/packages_repository_impl.dart';
import '../../domain/models/packages_response.dart';
import '../../domain/models/package.dart';

class PackagesService {
  static PackagesService? _instance;
  static PackagesRepositoryImpl? _repository;
  
  PackagesService._();
  
  static PackagesService get instance {
    _instance ??= PackagesService._();
    return _instance!;
  }
  
  PackagesRepositoryImpl get _packagesRepository {
    _repository ??= PackagesRepositoryImpl(apiService: ApiService());
    return _repository!;
  }
  
  // Cache for packages data
  PackagesResponse? _cachedPackages;
  DateTime? _lastFetchTime;
  static const Duration _cacheExpiry = Duration(minutes: 30);
  
  /// Get active packages with caching
  Future<PackagesResponse> getActivePackages({bool forceRefresh = false, int perPage = 10, int page = 1}) async {
    try {
      // Check if we have valid cached data
      if (!forceRefresh && 
          _cachedPackages != null && 
          _lastFetchTime != null &&
          DateTime.now().difference(_lastFetchTime!) < _cacheExpiry) {
        log('PackagesService: Returning cached packages');
        return _cachedPackages!;
      }
      
      log('PackagesService: Fetching fresh packages data');
      final packages = await _packagesRepository.getActivePackages(perPage: perPage, page: page);
      
      // Update cache
      _cachedPackages = packages;
      _lastFetchTime = DateTime.now();
      
      return packages;
    } catch (e) {
      log('PackagesService: Error getting packages: $e');
      
      // Return cached data if available, even if expired
      if (_cachedPackages != null) {
        log('PackagesService: Returning expired cached data due to error');
        return _cachedPackages!;
      }
      
      rethrow;
    }
  }
  
  /// Get a specific package by ID
  Future<Package?> getPackageById(int id, {bool forceRefresh = false}) async {
    try {
      final packagesResponse = await getActivePackages(forceRefresh: forceRefresh);
      return packagesResponse.data.packages.firstWhere(
        (package) => package.id == id,
        orElse: () => throw Exception('Package with ID $id not found'),
      );
    } catch (e) {
      log('PackagesService: Error getting package by ID: $e');
      return null;
    }
  }
  
  /// Get most popular package
  Future<Package?> getMostPopularPackage({bool forceRefresh = false}) async {
    try {
      final packagesResponse = await getActivePackages(forceRefresh: forceRefresh);
      if (packagesResponse.data.packages.isEmpty) return null;
      
      try {
        return packagesResponse.data.packages.firstWhere(
          (package) => package.mostPopular,
        );
      } catch (e) {
        // If no most popular package found, return the first one
        return packagesResponse.data.packages.first;
      }
    } catch (e) {
      log('PackagesService: Error getting most popular package: $e');
      return null;
    }
  }
  
  /// Clear cache (useful for testing or when data needs to be refreshed)
  void clearCache() {
    _cachedPackages = null;
    _lastFetchTime = null;
    log('PackagesService: Cache cleared');
  }
}
