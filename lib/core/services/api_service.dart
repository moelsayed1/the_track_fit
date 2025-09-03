import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:the_track_fit/core/constants/app_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;

  void init() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      validateStatus: (status) {
        // Accept 200-299 and 422 (validation errors) as valid responses
        log('validateStatus called with status: $status');
        final isValid = status != null && (status < 300 || status == 422);
        log('validateStatus returning: $isValid');
        return isValid;
      },
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors for logging and error handling
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        // Handle common errors
        if (error.response?.statusCode == 401) {
          // Handle unauthorized access
          log('Unauthorized access');
        }
        handler.next(error);
      },
    ));
  }

  Dio get dio => _dio;

  // Generic GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic POST request
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.post(path, data: data, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic PUT request
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.put(path, data: data, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic DELETE request
  Future<Response> delete(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.delete(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Handle Dio errors
  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Please try again.';
      case DioExceptionType.badResponse:
        if (error.response?.data != null) {
          final data = error.response!.data;
          if (data is Map<String, dynamic>) {
            if (data.containsKey('message')) {
              return data['message'].toString();
            }
            if (data.containsKey('data')) {
              final errorData = data['data'];
              if (errorData is Map<String, dynamic>) {
                // Handle validation errors
                final errors = <String>[];
                errorData.forEach((key, value) {
                  if (value is List) {
                    errors.addAll(value.map((e) => e.toString()));
                  } else {
                    errors.add(value.toString());
                  }
                });
                return errors.join('\n');
              }
            }
          }
        }
        return 'Server error: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request was cancelled';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      case DioExceptionType.badCertificate:
        return 'Certificate error. Please try again.';
      case DioExceptionType.unknown:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
