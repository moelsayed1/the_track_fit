import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:the_track_fit/core/services/api_service.dart';
import 'package:the_track_fit/core/services/google_signin_service.dart';
import 'package:the_track_fit/core/services/storage_service.dart';
import 'package:the_track_fit/core/constants/app_constants.dart';
import '../data/models/register_request.dart';
import '../data/models/register_response.dart';
import '../data/models/api_error_response.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  final GoogleSignInService _googleSignInService = GoogleSignInService();
  late final StorageService _storageService;

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

  /// Update profile (including password change)
  Future<String> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? passwordConfirmation,
    String? gender,
    dynamic image, // Can be File or String
  }) async {
    try {
      log('AuthRepository: updateProfile called');
      
      // Initialize CSRF token before update
      await _apiService.initializeCsrfToken();
      
      // Build data map with only non-null values
      final Map<String, dynamic> data = {};
      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;
      if (phone != null) data['phone'] = phone;
      if (password != null) data['password'] = password;
      if (passwordConfirmation != null) data['password_confirmation'] = passwordConfirmation;
      if (gender != null) data['gender'] = gender;
      if (image != null) {
        if (image is File) {
          data['image'] = image;
        } else if (image is String) {
          data['image'] = File(image);
        } else {
          data['image'] = File(image.toString());
        }
      }
      
      log('AuthRepository: updateProfile data map: $data');
      log('AuthRepository: image type: ${image.runtimeType}');
      if (image is File) {
        log('AuthRepository: image file path: ${image.path}');
        log('AuthRepository: image file exists: ${image.existsSync()}');
      }
      
      // Use multipart if there's an image, otherwise use regular form data
      final response = image != null 
          ? await _apiService.postMultipart(
              AppConstants.updateProfileEndpoint,
              data: data,
            )
          : await _apiService.postForm(
              AppConstants.updateProfileEndpoint,
              data: data,
            );

      if (response.statusCode == 200) {
        log('Profile update successful');
        return 'Profile updated successfully';
      } else if (response.statusCode == 422) {
        // Handle validation errors
        log('422 Error Response: ${response.data}');
        final errorResponse = ApiErrorResponse.fromJson(response.data);
        log('Parsed Error Response: $errorResponse');
        final errorMessage = errorResponse.getFirstValidationError();
        log('Error Message: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception('Profile update failed with status: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception caught in updateProfile: $e');
      if (e is DioException) {
        log('DioException caught: ${e.type}');
        log('DioException response: ${e.response?.data}');
        // Handle Dio errors
        if (e.response?.data != null) {
          final errorResponse = ApiErrorResponse.fromJson(e.response!.data);
          throw Exception(errorResponse.getFirstValidationError());
        }
        throw Exception(e.message ?? 'Profile update failed');
      }
      throw Exception(e.toString());
    }
  }

  /// Sign in with Google using Firebase Auth
  Future<GoogleSignInResult> signInWithGoogle() async {
    try {
      log('AuthRepository: Starting Google sign in with Firebase...');
      
      // Use Google Sign-In service which handles Firebase Auth internally
      final result = await _googleSignInService.signInWithGoogle();
      
      if (result.isSuccess) {
        log('AuthRepository: Google sign in successful with Firebase, email: ${result.email}');
        
        // For Google Sign-In, we'll use Firebase authentication only
        // The backend will need to be modified to accept Firebase ID tokens
        // For now, we'll skip backend registration and use Firebase auth
        log('AuthRepository: Using Firebase authentication for Google user');
        
        // Store Firebase user data locally
        await _storeGoogleUserLocally(result);
        
        log('AuthRepository: Firebase authentication completed successfully');
      }
      
      return result;
    } catch (e) {
      log('AuthRepository: Google sign in error: $e');
      return GoogleSignInResult.error(e.toString());
    }
  }

  /// Store Google user data locally and set up Firebase authentication
  Future<void> _storeGoogleUserLocally(GoogleSignInResult result) async {
    try {
      log('AuthRepository: Storing Google user data locally...');
      
      // Initialize StorageService
      _storageService = await StorageService.getInstance();
      
      // Store Firebase ID token as Bearer token for API calls
      if (result.idToken != null) {
        _apiService.setBearerToken(result.idToken!);
        log('AuthRepository: Firebase ID token set as Bearer token');
      }
      
      // Store user data in local storage
      await _storageService.saveToken(result.idToken ?? '');
      
      // Create user data object
      // Use phone from Google account if available, otherwise use placeholder
      final userData = UserData(
        id: 0, // Google users don't have backend ID yet
        name: result.name ?? '',
        email: result.email ?? '',
        phone: result.phone ?? '00000000000', // Use Google phone or placeholder
        gender: 'male', // Default gender
        image: result.profileImageUrl,
        type: 'customer',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
      await _storageService.saveUserData(userData);
      
      log('AuthRepository: Google user data stored locally');
    } catch (e) {
      log('AuthRepository: Error storing Google user data locally: $e');
    }
  }


  /// Sign out from Google
  Future<void> signOutFromGoogle() async {
    try {
      log('AuthRepository: Signing out from Google...');
      await _googleSignInService.signOut();
      log('AuthRepository: Google sign out successful');
    } catch (e) {
      log('AuthRepository: Google sign out error: $e');
      throw Exception(e.toString());
    }
  }
}
