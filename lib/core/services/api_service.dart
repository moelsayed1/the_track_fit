import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:the_track_fit/core/constants/app_constants.dart';
import 'package:the_track_fit/core/services/language_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  String? _csrfToken;
  String? _bearerToken;

  void init() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      validateStatus: (status) {
        // Accept 200-299, 404 (not found), 422 (validation errors), and 419 (CSRF token mismatch) as valid responses
        log('validateStatus called with status: $status');
        final isValid = status != null && (status < 300 || status == 404 || status == 422 || status == 419);
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
      onRequest: (options, handler) {
        // Add CSRF token to requests if available
        if (_csrfToken != null) {
          options.headers['X-CSRF-TOKEN'] = _csrfToken;
        }
        // Add Bearer token to requests if available
        if (_bearerToken != null) {
          // Use Bearer token for authentication
          options.headers['Authorization'] = 'Bearer $_bearerToken';
          log('API Service: Using Bearer token for authentication');
          log('API Service: Token (first 50 chars): ${_bearerToken!.substring(0, _bearerToken!.length > 50 ? 50 : _bearerToken!.length)}...');
        } else {
          log('API Service: No Bearer token available');
        }
        handler.next(options);
      },
      onError: (error, handler) {
        // Handle common errors
        if (error.response?.statusCode == 401) {
          // Handle unauthorized access
          log('Unauthorized access');
        } else if (error.response?.statusCode == 419) {
          // Handle CSRF token mismatch - try to get new token
          log('CSRF token mismatch, attempting to get new token');
          _getCsrfToken().then((_) {
            // Retry the original request
            final options = error.requestOptions;
            if (_csrfToken != null) {
              options.headers['X-CSRF-TOKEN'] = _csrfToken;
            }
            _dio.fetch(options).then((response) {
              handler.resolve(response);
            }).catchError((retryError) {
              handler.next(retryError);
            });
          }).catchError((_) {
            handler.next(error);
          });
          return;
        }
        handler.next(error);
      },
    ));
  }

  Dio get dio => _dio;

  // Get CSRF token from the server
  Future<void> _getCsrfToken() async {
    try {
      log('Getting CSRF token...');
      final response = await _dio.get('/sanctum/csrf-cookie');
      log('CSRF token response status: ${response.statusCode}');
      
      // Extract CSRF token from cookies
      final cookies = response.headers['set-cookie'];
      if (cookies != null) {
        for (final cookie in cookies) {
          if (cookie.contains('XSRF-TOKEN=')) {
            final tokenMatch = RegExp(r'XSRF-TOKEN=([^;]+)').firstMatch(cookie);
            if (tokenMatch != null) {
              _csrfToken = Uri.decodeComponent(tokenMatch.group(1)!);
              log('CSRF token obtained: $_csrfToken');
              break;
            }
          }
        }
      }
    } catch (e) {
      log('Failed to get CSRF token: $e');
      _csrfToken = null;
    }
  }

  // Initialize CSRF token
  Future<void> initializeCsrfToken() async {
    await _getCsrfToken();
  }

  // Set Bearer token for authenticated requests
  void setBearerToken(String token) {
    _bearerToken = token;
  }

  // Clear Bearer token
  void clearBearerToken() {
    _bearerToken = null;
  }

  // Check if Bearer token is available
  bool hasBearerToken() {
    return _bearerToken != null && _bearerToken!.isNotEmpty;
  }

  // Generic GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, bool includeLanguage = true}) async {
    try {
      Map<String, dynamic> finalQueryParams = queryParameters ?? {};
      
      // Add language parameter if requested
      if (includeLanguage) {
        finalQueryParams['lang'] = LanguageService.instance.currentLanguage;
      }
      
      final response = await _dio.get(path, queryParameters: finalQueryParams);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic POST request
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, bool includeLanguage = true}) async {
    try {
      Map<String, dynamic> finalQueryParams = queryParameters ?? {};
      
      // Add language parameter if requested
      if (includeLanguage) {
        finalQueryParams['lang'] = LanguageService.instance.currentLanguage;
      }
      
      final response = await _dio.post(path, data: data, queryParameters: finalQueryParams);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST request with form data
  Future<Response> postForm(String path, {Map<String, dynamic>? data, Map<String, dynamic>? queryParameters, bool includeLanguage = true}) async {
    try {
      Map<String, dynamic> finalQueryParams = queryParameters ?? {};
      
      // Add language parameter if requested
      if (includeLanguage) {
        finalQueryParams['lang'] = LanguageService.instance.currentLanguage;
      }
      
      final response = await _dio.post(
        path, 
        data: data,
        queryParameters: finalQueryParams,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
        ),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST request with multipart form data (for file uploads)
  Future<Response> postMultipart(String path, {Map<String, dynamic>? data, Map<String, dynamic>? queryParameters, dynamic cartData, bool includeLanguage = true}) async {
    try {
      log('ApiService: postMultipart called with path: $path');
      log('ApiService: data: $data');
      
      Map<String, dynamic> finalQueryParams = queryParameters ?? {};
      
      // Add language parameter if requested
      if (includeLanguage) {
        finalQueryParams['lang'] = LanguageService.instance.currentLanguage;
      }
      
      FormData formData = FormData();
      
      if (data != null) {
        for (var entry in data.entries) {
          if (entry.value is File) {
            // Handle file upload
            log('ApiService: Processing file field: ${entry.key} = ${entry.value.path}');
            formData.files.add(MapEntry(
              entry.key,
              await MultipartFile.fromFile(
                entry.value.path,
                filename: entry.value.path.split('/').last,
              ),
            ));
          } else if (entry.value != null) {
            // Handle regular form fields
            log('ApiService: Processing text field: ${entry.key} = ${entry.value}');
            formData.fields.add(MapEntry(entry.key, entry.value.toString()));
          }
        }
      }
      
      // Handle cart data separately to maintain array structure
      if (cartData != null) {
        if (cartData is List) {
          for (int i = 0; i < cartData.length; i++) {
            final item = cartData[i];
            if (item is Map<String, dynamic>) {
              for (var entry in item.entries) {
                formData.fields.add(MapEntry('cart[$i][${entry.key}]', entry.value.toString()));
              }
            }
          }
        }
      }
      
      log('ApiService: FormData fields: ${formData.fields}');
      log('ApiService: FormData files: ${formData.files.map((e) => '${e.key}: ${e.value.filename}').toList()}');

      final response = await _dio.post(
        path,
        data: formData,
        queryParameters: finalQueryParams,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic PUT request
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters, bool includeLanguage = true}) async {
    try {
      Map<String, dynamic> finalQueryParams = queryParameters ?? {};
      
      // Add language parameter if requested
      if (includeLanguage) {
        finalQueryParams['lang'] = LanguageService.instance.currentLanguage;
      }
      
      final response = await _dio.put(path, data: data, queryParameters: finalQueryParams);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic DELETE request
  Future<Response> delete(String path, {Map<String, dynamic>? queryParameters, bool includeLanguage = true}) async {
    try {
      Map<String, dynamic> finalQueryParams = queryParameters ?? {};
      
      // Add language parameter if requested
      if (includeLanguage) {
        finalQueryParams['lang'] = LanguageService.instance.currentLanguage;
      }
      
      final response = await _dio.delete(path, queryParameters: finalQueryParams);
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
