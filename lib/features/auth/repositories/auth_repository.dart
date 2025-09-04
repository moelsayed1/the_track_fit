import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:the_track_fit/core/services/api_service.dart';
import 'package:the_track_fit/core/constants/app_constants.dart';
import '../data/models/register_request.dart';
import '../data/models/register_response.dart';
import '../data/models/api_error_response.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  /// Register a new user
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      // Initialize CSRF token before registration
      await _apiService.initializeCsrfToken();
      
      log('Sending register request: ${request.toJson()}');
      final response = await _apiService.postForm(
        AppConstants.registerEndpoint,
        data: request.toJson(),
      );

      log('Received response with status: ${response.statusCode}');
      log('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final registerResponse = RegisterResponse.fromJson(response.data);
        // Store the Bearer token for future authenticated requests
        if (registerResponse.data?.token != null) {
          _apiService.setBearerToken(registerResponse.data!.token);
        }
        return registerResponse;
      } else if (response.statusCode == 422) {
        // Handle validation errors
        log('422 Error Response: ${response.data}');
        final errorResponse = ApiErrorResponse.fromJson(response.data);
        log('Parsed Error Response: $errorResponse');
        final errorMessage = errorResponse.getFirstValidationError();
        log('Error Message: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception('Registration failed with status: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception caught in register: $e');
      if (e is DioException) {
        log('DioException caught: ${e.type}');
        log('DioException response: ${e.response?.data}');
        // Handle Dio errors
        if (e.response?.data != null) {
          final errorResponse = ApiErrorResponse.fromJson(e.response!.data);
          throw Exception(errorResponse.getFirstValidationError());
        }
        throw Exception(e.message ?? 'Registration failed');
      }
      throw Exception(e.toString());
    }
  }

  /// Login user
  Future<RegisterResponse> login(String email, String password) async {
    try {
      // Initialize CSRF token before login
      await _apiService.initializeCsrfToken();
      
      final response = await _apiService.postForm(
        AppConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final registerResponse = RegisterResponse.fromJson(response.data);
        // Store the Bearer token for future authenticated requests
        if (registerResponse.data?.token != null) {
          _apiService.setBearerToken(registerResponse.data!.token);
        }
        return registerResponse;
      } else if (response.statusCode == 422) {
        // Handle validation errors
        log('422 Error Response: ${response.data}');
        final errorResponse = ApiErrorResponse.fromJson(response.data);
        log('Parsed Error Response: $errorResponse');
        final errorMessage = errorResponse.getFirstValidationError();
        log('Error Message: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception('Login failed with status: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.data != null) {
          final errorResponse = ApiErrorResponse.fromJson(e.response!.data);
          throw Exception(errorResponse.getFirstValidationError());
        }
        throw Exception(e.message ?? 'Login failed');
      }
      throw Exception(e.toString());
    }
  }

  /// Send OTP for password reset
  Future<String?> sendOtp(String email) async {
    try {
      log('AuthRepository: sendOtp called with email: $email');
      log('AuthRepository: sendOtp endpoint: ${AppConstants.sendOtpEndpoint}');
      // Initialize CSRF token before sending OTP
      await _apiService.initializeCsrfToken();
      
      log('AuthRepository: About to send POST request to sendOtp');
      final response = await _apiService.postForm(
        AppConstants.sendOtpEndpoint,
        data: {'email': email},
      );

      log('AuthRepository: sendOtp response status: ${response.statusCode}');
      log('AuthRepository: sendOtp response data: ${response.data}');
      log('AuthRepository: sendOtp response headers: ${response.headers}');
      
      if (response.statusCode == 200) {
        log('AuthRepository: OTP sent successfully via API');
        // Try to extract OTP from response if available
        if (response.data != null && response.data is Map) {
          final data = response.data as Map<String, dynamic>;
          log('AuthRepository: Response data keys: ${data.keys.toList()}');
          if (data.containsKey('otp')) {
            log('AuthRepository: Found OTP in response: ${data['otp']}');
            return data['otp'].toString();
          }
        }
        // If no OTP in response, return success indicator
        log('AuthRepository: No OTP in response, returning API_SUCCESS');
        return "API_SUCCESS";
      } else {
        log('AuthRepository: sendOtp failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('AuthRepository: sendOtp error: $e');
      if (e is DioException) {
        log('AuthRepository: sendOtp DioException details: ${e.response?.data}');
        if (e.response?.data != null) {
          final errorResponse = ApiErrorResponse.fromJson(e.response!.data);
          throw Exception(errorResponse.getFirstValidationError());
        }
        throw Exception(e.message ?? 'Failed to send OTP');
      }
      throw Exception(e.toString());
    }
  }


  /// Reset password
  Future<bool> resetPassword(String email, String otp, String newPassword) async {
    try {
      log('AuthRepository: resetPassword called with email: $email, otp: $otp');
      // Initialize CSRF token before resetting password
      await _apiService.initializeCsrfToken();
      
      final response = await _apiService.postForm(
        AppConstants.resetPasswordEndpoint,
        data: {
          'email': email,
          'otp': otp,
          'password': newPassword,
          'password_confirmation': newPassword, // Add password confirmation as required by API
        },
      );

      log('AuthRepository: resetPassword response status: ${response.statusCode}');
      log('AuthRepository: resetPassword response data: ${response.data}');
      
      return response.statusCode == 200;
    } catch (e) {
      log('AuthRepository: resetPassword error: $e');
      if (e is DioException) {
        if (e.response?.data != null) {
          final errorResponse = ApiErrorResponse.fromJson(e.response!.data);
          throw Exception(errorResponse.getFirstValidationError());
        }
        throw Exception(e.message ?? 'Failed to reset password');
      }
      throw Exception(e.toString());
    }
  }

  /// Logout user
  Future<bool> logout() async {
    try {
      // Initialize CSRF token before logout
      await _apiService.initializeCsrfToken();
      
      final response = await _apiService.postForm(AppConstants.logoutEndpoint);
      
      if (response.statusCode == 200) {
        // Clear the Bearer token after successful logout
        _apiService.clearBearerToken();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.message ?? 'Logout failed');
      }
      throw Exception(e.toString());
    }
  }
}
