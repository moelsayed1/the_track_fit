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
      log('Sending register request: ${request.toJson()}');
      final response = await _apiService.post(
        AppConstants.registerEndpoint,
        data: request.toJson(),
      );

      log('Received response with status: ${response.statusCode}');
      log('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResponse.fromJson(response.data);
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
      final response = await _apiService.post(
        AppConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return RegisterResponse.fromJson(response.data);
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
  Future<bool> sendOtp(String email) async {
    try {
      final response = await _apiService.post(
        AppConstants.sendOtpEndpoint,
        data: {'email': email},
      );

      return response.statusCode == 200;
    } catch (e) {
      if (e is DioException) {
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
      final response = await _apiService.post(
        AppConstants.resetPasswordEndpoint,
        data: {
          'email': email,
          'otp': otp,
          'password': newPassword,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
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
      final response = await _apiService.post(AppConstants.logoutEndpoint);
      return response.statusCode == 200;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.message ?? 'Logout failed');
      }
      throw Exception(e.toString());
    }
  }
}
