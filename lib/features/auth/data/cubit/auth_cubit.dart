import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_track_fit/features/auth/data/models/register_request.dart';
import 'package:the_track_fit/features/auth/data/models/register_response.dart';
import 'package:the_track_fit/features/auth/repositories/auth_repository.dart';
import 'package:the_track_fit/core/services/storage_service.dart';
import 'package:the_track_fit/core/services/api_service.dart';
import 'auth_states.dart';

// Cubit
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final StorageService _storageService;
  String? _verifiedOtp; // Store the verified OTP
  
  // User profile data - will be populated from login/registration
  String _userName = '';
  String _userEmail = '';
  String? _userImagePath;
  String? _userPhone;
  String? _userGender;
  
  // Ensure _userImagePath is always a String or null
  String? get _safeUserImagePath {
    log('_safeUserImagePath: _userImagePath = $_userImagePath, type: ${_userImagePath.runtimeType}');
    if (_userImagePath == null) {
      log('_safeUserImagePath: _userImagePath is null, returning null');
      return null;
    }
    try {
      final result = _userImagePath.toString();
      log('_safeUserImagePath: Successfully converted to string: $result');
      return result;
    } catch (e) {
      log('_safeUserImagePath: Error converting _userImagePath to string: $e');
      return null;
    }
  }

  AuthCubit(this._authRepository, this._storageService) : super(const AuthInitial());

  /// Check if user is already logged in from storage
  Future<void> checkExistingLogin() async {
    try {
      log('AuthCubit: Checking for existing login...');
      
      if (_storageService.hasValidSession()) {
        final authData = _storageService.getAuthData();
        if (authData != null) {
          log('AuthCubit: Found existing login data');
          
          // Set the bearer token in ApiService for authenticated requests
          ApiService().setBearerToken(authData.token);
          log('AuthCubit: Bearer token set in ApiService');
          
          // Update local profile data
          _userName = authData.user.name;
          _userEmail = authData.user.email;
          _userPhone = authData.user.phone;
          _userGender = authData.user.gender;
          _userImagePath = authData.user.image;
          
          // Load saved profile image from SharedPreferences
          final savedImagePath = _storageService.getProfileImage();
          if (savedImagePath != null) {
            _userImagePath = savedImagePath;
            log('AuthCubit: Loaded saved profile image from SharedPreferences');
          }
          
          // Emit already logged in state
          emit(AuthUserAlreadyLoggedIn(
            token: authData.token,
            name: _userName,
            email: _userEmail,
            imagePath: _userImagePath,
            phone: _userPhone,
            gender: _userGender,
          ));
          
          log('AuthCubit: User already logged in - ${_userName}');
        } else {
          log('AuthCubit: No valid auth data found');
          emit(const AuthInitial());
        }
      } else {
        log('AuthCubit: No valid session found');
        emit(const AuthInitial());
      }
    } catch (e) {
      log('AuthCubit: Error checking existing login: $e');
      emit(const AuthInitial());
    }
  }

  /// Save authentication data to storage
  Future<void> _saveAuthData(AuthData authData) async {
    try {
      await _storageService.saveAuthData(authData);
      log('AuthCubit: Auth data saved to storage');
    } catch (e) {
      log('AuthCubit: Error saving auth data: $e');
    }
  }

  /// Clear all authentication data from storage
  Future<void> _clearAuthData() async {
    try {
      await _storageService.clearAllAuthData();
      log('AuthCubit: Auth data cleared from storage');
    } catch (e) {
      log('AuthCubit: Error clearing auth data: $e');
    }
  }

  /// Register a new user
  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String gender,
  }) async {
    emit(const AuthLoading());
    
    try {
      // Validate input
      final validationErrors = _validateRegisterInput(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      
      if (validationErrors.isNotEmpty) {
        emit(AuthValidationError(validationErrors));
        return;
      }

      final request = RegisterRequest(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
        gender: gender,
      );

      final response = await _authRepository.register(request);
      
      // Store user data from registration response
      if (response.data != null) {
        final authData = response.data!;
        final user = authData.user;
        
        _userName = user.name;
        _userEmail = user.email;
        _userPhone = user.phone;
        _userGender = user.gender;
        _userImagePath = user.image is String ? user.image : user.image?.toString();
        
        // Save auth data to storage
        await _saveAuthData(authData);
        
        // Set user as first-time user for new registration
        await _storageService.setFirstTimeUser(true);
        
        // Emit user profile data so listeners can get the updated data
        emit(AuthUserProfileLoaded(
          name: _userName,
          email: _userEmail,
          imagePath: _userImagePath,
          phone: _userPhone,
          gender: _userGender,
        ));
      }
      
      emit(AuthRegisterSuccess(response));
    } catch (e) {
      log('AuthCubit Register Error: $e');
      final errorMessage = _extractErrorMessage(e);
      emit(AuthError(errorMessage));
    }
  }

  /// Login user
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    
    try {
      // Validate input
      final validationErrors = _validateLoginInput(email: email, password: password);
      
      if (validationErrors.isNotEmpty) {
        emit(AuthValidationError(validationErrors));
        return;
      }

      final response = await _authRepository.login(email, password);
      
      // Store user data from login response
      if (response.data != null) {
        final authData = response.data!;
        final user = authData.user;
        
        _userName = user.name;
        _userEmail = user.email;
        _userPhone = user.phone;
        _userGender = user.gender;
        _userImagePath = user.image is String ? user.image : user.image?.toString();
        
        // Save auth data to storage
        await _saveAuthData(authData);
        
        // Set user as returning user for login
        await _storageService.setFirstTimeUser(false);
        
        // Emit user profile data so listeners can get the updated data
        emit(AuthUserProfileLoaded(
          name: _userName,
          email: _userEmail,
          imagePath: _userImagePath,
          phone: _userPhone,
          gender: _userGender,
        ));
      }
      
      emit(AuthLoginSuccess(response));
    } catch (e) {
      log('AuthCubit Login Error: $e');
      final errorMessage = _extractErrorMessage(e);
      emit(AuthError(errorMessage));
    }
  }

  /// Send OTP for password reset
  Future<void> sendOtp(String email) async {
    emit(const AuthLoading());
    
    try {
      // Validate email
      final validationErrors = _validateEmailInput(email);
      
      if (validationErrors.isNotEmpty) {
        emit(AuthValidationError(validationErrors));
        return;
      }

      await _authRepository.sendOtp(email);
      emit(const AuthOtpSentSuccess('OTP sent successfully'));
    } catch (e) {
      log('AuthCubit SendOtp Error: $e');
      final errorMessage = _extractErrorMessage(e);
      emit(AuthError(errorMessage));
    }
  }

  /// Verify OTP (client-side validation only)
  /// The actual OTP verification will happen during password reset
  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    emit(const AuthLoading());
    
    try {
      // Validate input
      final validationErrors = _validateOtpInput(
        email: email,
        otp: otp,
      );
      
      if (validationErrors.isNotEmpty) {
        emit(AuthValidationError(validationErrors));
        return;
      }

      // Store the OTP for later use in password reset
      log('AuthCubit: Storing OTP for password reset: $otp');
      _verifiedOtp = otp; // Store the OTP for password reset
      emit(const AuthOtpVerifiedSuccess('OTP verified successfully'));
    } catch (e) {
      log('AuthCubit VerifyOtp Error: $e');
      final errorMessage = _extractErrorMessage(e);
      emit(AuthOtpVerificationError(errorMessage));
    }
  }

  /// Reset password
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    emit(const AuthLoading());
    
    try {
      // Use the verified OTP if available, otherwise use the provided OTP
      final otpToUse = _verifiedOtp ?? otp;
      log('AuthCubit: Using OTP: $otpToUse (verified: $_verifiedOtp, provided: $otp)');
      log('AuthCubit: Email: $email, NewPassword: $newPassword');
      
      // Validate input
      final validationErrors = _validateResetPasswordInput(
        email: email,
        otp: otpToUse,
        newPassword: newPassword,
      );
      
      if (validationErrors.isNotEmpty) {
        emit(AuthValidationError(validationErrors));
        return;
      }

      await _authRepository.resetPassword(email, otpToUse, newPassword);
      _verifiedOtp = null; // Clear the verified OTP after successful reset
      emit(const AuthPasswordResetSuccess('Password reset successfully'));
    } catch (e) {
      log('AuthCubit ResetPassword Error: $e');
      final errorMessage = _extractErrorMessage(e);
      // Check if it's an OTP-related error
      if (errorMessage.toLowerCase().contains('invalid') || 
          errorMessage.toLowerCase().contains('expired') ||
          errorMessage.toLowerCase().contains('code')) {
        // This is an OTP error, redirect back to OTP screen
        emit(AuthPasswordResetError('Invalid or expired OTP. Please verify your code again.'));
      } else {
        emit(AuthPasswordResetError(errorMessage));
      }
    }
  }

  /// Logout user
  Future<void> logout() async {
    emit(const AuthLoading());
    
    try {
      await _authRepository.logout();
      
      // Clear all auth data from storage
      await _clearAuthData();
      
      // Clear profile image from SharedPreferences
      await _storageService.clearProfileImage();
      log('AuthCubit: Profile image cleared from SharedPreferences');
      
      // Clear bearer token from ApiService
      ApiService().clearBearerToken();
      log('AuthCubit: Bearer token cleared from ApiService');
      
      // Reset local profile data
      _userName = '';
      _userEmail = '';
      _userPhone = null;
      _userGender = null;
      _userImagePath = null;
      
      emit(const AuthLogoutSuccess('Logged out successfully'));
    } catch (e) {
      log('AuthCubit Logout Error: $e');
      final errorMessage = _extractErrorMessage(e);
      emit(AuthError(errorMessage));
    }
  }

  /// Change password using update profile endpoint
  Future<void> changePassword({
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    emit(const AuthLoading());
    
    try {
      // Validate input
      final validationErrors = _validateChangePasswordInput(
        currentPassword: '', // Not needed for this endpoint
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );
      
      if (validationErrors.isNotEmpty) {
        emit(AuthValidationError(validationErrors));
        return;
      }

      final response = await _authRepository.updateProfile(
        password: newPassword,
        passwordConfirmation: newPasswordConfirmation,
      );
      emit(AuthChangePasswordSuccess(response));
    } catch (e) {
      log('AuthCubit ChangePassword Error: $e');
      final errorMessage = _extractErrorMessage(e);
      emit(AuthChangePasswordError(errorMessage));
    }
  }

  /// Update profile with all fields
  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? passwordConfirmation,
    String? gender,
    dynamic image, // Can be File or String
  }) async {
    log('updateProfile: Method called with image: $image, type: ${image.runtimeType}');
    emit(const AuthLoading());
    
    try {
      // Validate input if password is provided
      if (password != null && password.isNotEmpty) {
        final validationErrors = _validateChangePasswordInput(
          currentPassword: '',
          newPassword: password,
          newPasswordConfirmation: passwordConfirmation ?? '',
        );
        
        if (validationErrors.isNotEmpty) {
          emit(AuthValidationError(validationErrors));
          return;
        }
      }

      log('updateProfile: Calling _authRepository.updateProfile with image: $image');
      final response = await _authRepository.updateProfile(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
        gender: gender,
        image: image,
      );
      log('updateProfile: _authRepository.updateProfile completed successfully');
      
      // Update local profile data only for non-null values
      String? imagePathValue;
      log('updateProfile: image parameter = $image, type: ${image.runtimeType}');
      
      try {
        if (image != null) {
          if (image is File) {
            // Convert File to base64 for persistent storage
            try {
              final bytes = await image.readAsBytes();
              imagePathValue = base64Encode(bytes);
              log('updateProfile: image is File, converted to base64 successfully');
            } catch (e) {
              log('updateProfile: Error converting File to base64: $e');
              imagePathValue = image.path; // Fallback to path
            }
          } else if (image is String) {
            // Check if it's already base64 or a file path
            if (image.startsWith('data:image/') || image.startsWith('/data/')) {
              // It's a file path, try to read and convert to base64
              try {
                final file = File(image);
                if (file.existsSync()) {
                  final bytes = await file.readAsBytes();
                  imagePathValue = base64Encode(bytes);
                  log('updateProfile: image is file path, converted to base64 successfully');
                } else {
                  log('updateProfile: image file does not exist, using as-is');
                  imagePathValue = image;
                }
              } catch (e) {
                log('updateProfile: Error reading file path: $e');
                imagePathValue = image;
              }
            } else {
              // Assume it's already base64 or some other string
              imagePathValue = image;
              log('updateProfile: image is String, using as-is');
            }
          } else {
            imagePathValue = image.toString();
            log('updateProfile: image is other type, converted to string = $imagePathValue');
          }
        } else {
          log('updateProfile: image is null');
        }
        
        // Ensure imagePathValue is always a String or null
        if (imagePathValue != null) {
          imagePathValue = imagePathValue.toString();
        }
        
        log('updateProfile: Final imagePathValue = $imagePathValue, type: ${imagePathValue.runtimeType}');
        log('updateProfile: imagePathValue length = ${imagePathValue?.length ?? 0}');
        log('updateProfile: imagePathValue starts with data:image/ = ${imagePathValue?.startsWith('data:image/') ?? false}');
        log('updateProfile: imagePathValue is long string = ${(imagePathValue?.length ?? 0) > 100}');
      } catch (e) {
        log('updateProfile: Error processing image parameter: $e');
        imagePathValue = null;
      }
      
      // Only update fields that are not null
      log('updateProfile: Checking condition - name: $name, email: $email, phone: $phone, gender: $gender, imagePathValue: $imagePathValue');
      if (name != null || email != null || phone != null || gender != null || imagePathValue != null) {
        log('updateProfile: Calling updateUserProfileData with imagePath: $imagePathValue');
        try {
          updateUserProfileData(
            name: name,
            email: email,
            phone: phone,
            gender: gender,
            imagePath: imagePathValue,
          );
          log('updateProfile: updateUserProfileData completed successfully');
        } catch (e) {
          log('updateProfile: Error in updateUserProfileData: $e');
          // Continue execution even if updateUserProfileData fails
        }
      } else {
        log('updateProfile: Not calling updateUserProfileData - all fields are null');
      }
      
      // For image uploads, ensure we always update the local image path
      // even if the API doesn't return the updated path
      if (imagePathValue != null) {
        log('updateProfile: Image upload detected, ensuring local image path is updated');
        try {
          updateUserProfileData(imagePath: imagePathValue);
          log('updateProfile: Local image path updated successfully');
        } catch (e) {
          log('updateProfile: Error updating local image path: $e');
        }
      }
      
      log('updateProfile: About to emit AuthChangePasswordSuccess');
      emit(AuthChangePasswordSuccess(response));
      log('updateProfile: AuthChangePasswordSuccess emitted successfully');
    } catch (e) {
      log('AuthCubit UpdateProfile Error: $e');
      log('AuthCubit UpdateProfile Error Type: ${e.runtimeType}');
      if (e is Exception) {
        log('AuthCubit UpdateProfile Exception: ${e.toString()}');
      }
      final errorMessage = _extractErrorMessage(e);
      log('AuthCubit UpdateProfile Error Message: $errorMessage');
      emit(AuthChangePasswordError(errorMessage));
    }
  }

  /// Reset state to initial
  void reset() {
    emit(const AuthInitial());
  }

  /// Test method to verify base64 conversion
  Future<void> testBase64Conversion(File imageFile) async {
    try {
      log('testBase64Conversion: Testing with file: ${imageFile.path}');
      log('testBase64Conversion: File exists: ${imageFile.existsSync()}');
      
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);
      
      log('testBase64Conversion: Base64 string length: ${base64String.length}');
      log('testBase64Conversion: Base64 string starts with: ${base64String.substring(0, 20)}...');
      
      // Test if we can decode it back
      final decodedBytes = base64Decode(base64String);
      log('testBase64Conversion: Decoded bytes length: ${decodedBytes.length}');
      log('testBase64Conversion: Original bytes length: ${bytes.length}');
      log('testBase64Conversion: Conversion successful: ${bytes.length == decodedBytes.length}');
      
      // Update the profile with this base64 string
      updateUserProfileData(imagePath: base64String);
      
    } catch (e) {
      log('testBase64Conversion: Error: $e');
    }
  }

  /// Update only the profile image
  Future<void> updateProfileImage(File imageFile) async {
    log('updateProfileImage: Method called with imageFile: ${imageFile.path}');
    emit(const AuthLoading());
    
    try {
      // Convert image to base64 for local storage
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);
      
      log('updateProfileImage: Image converted to base64, length: ${base64String.length}');
      
      // Update local profile data with the new image
      updateUserProfileData(imagePath: base64String);
      
      // Emit success state
      emit(AuthChangePasswordSuccess('Image updated successfully'));
      
    } catch (e) {
      log('updateProfileImage Error: $e');
      final errorMessage = _extractErrorMessage(e);
      emit(AuthChangePasswordError(errorMessage));
    }
  }

  // Private validation methods
  Map<String, String> _validateRegisterInput({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) {
    final errors = <String, String>{};
    
    if (name.trim().isEmpty) {
      errors['name'] = 'Name is required';
    }
    
    if (email.trim().isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      errors['email'] = 'Enter a valid email';
    }
    
    if (phone.trim().isEmpty) {
      errors['phone'] = 'Phone is required';
    }
    
    if (password.isEmpty) {
      errors['password'] = 'Password is required';
    } else if (password.length < 6) {
      errors['password'] = 'Password must be at least 6 characters';
    }
    
    if (passwordConfirmation.isEmpty) {
      errors['passwordConfirmation'] = 'Confirm password is required';
    } else if (password != passwordConfirmation) {
      errors['passwordConfirmation'] = 'Passwords do not match';
    }
    
    return errors;
  }

  Map<String, String> _validateLoginInput({
    required String email,
    required String password,
  }) {
    final errors = <String, String>{};
    
    if (email.trim().isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      errors['email'] = 'Enter a valid email';
    }
    
    if (password.isEmpty) {
      errors['password'] = 'Password is required';
    }
    
    return errors;
  }

  Map<String, String> _validateEmailInput(String email) {
    final errors = <String, String>{};
    
    if (email.trim().isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      errors['email'] = 'Enter a valid email';
    }
    
    return errors;
  }

  /// Validate OTP input
  Map<String, String> _validateOtpInput({
    required String email,
    required String otp,
  }) {
    final errors = <String, String>{};
    
    if (email.trim().isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim())) {
      errors['email'] = 'Please enter a valid email address';
    }
    
    if (otp.trim().isEmpty) {
      errors['otp'] = 'OTP is required';
    } else if (otp.trim().length != 6) {
      errors['otp'] = 'OTP must be 6 digits';
    }
    
    return errors;
  }

  Map<String, String> _validateResetPasswordInput({
    required String email,
    required String otp,
    required String newPassword,
  }) {
    final errors = <String, String>{};
    
    if (email.trim().isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      errors['email'] = 'Enter a valid email';
    }
    
    if (otp.trim().isEmpty) {
      errors['otp'] = 'OTP is required';
    } else if (otp.trim().length != 6) {
      errors['otp'] = 'OTP must be 6 digits';
    }
    
    if (newPassword.isEmpty) {
      errors['newPassword'] = 'New password is required';
    } else if (newPassword.length < 6) {
      errors['newPassword'] = 'Password must be at least 6 characters';
    }
    
    return errors;
  }

  Map<String, String> _validateChangePasswordInput({
    required String currentPassword, // Not used but kept for compatibility
    required String newPassword,
    required String newPasswordConfirmation,
  }) {
    final errors = <String, String>{};
    
    if (newPassword.isEmpty) {
      errors['newPassword'] = 'New password is required';
    } else if (newPassword.length < 6) {
      errors['newPassword'] = 'Password must be at least 6 characters';
    }
    
    if (newPasswordConfirmation.isEmpty) {
      errors['newPasswordConfirmation'] = 'Password confirmation is required';
    } else if (newPassword != newPasswordConfirmation) {
      errors['newPasswordConfirmation'] = 'Passwords do not match';
    }
    
    return errors;
  }

  /// Send OTP for password reset (forget password)
  Future<void> forgetPassword(String email) async {
    log('AuthCubit: forgetPassword called with email: $email');
    emit(const AuthLoading());
    log('AuthCubit: AuthLoading state emitted');
    
    try {
      // Validate email input
      final validationErrors = _validateEmailInput(email);
      
      if (validationErrors.isNotEmpty) {
        log('AuthCubit: Validation errors found: $validationErrors');
        emit(AuthValidationError(validationErrors));
        return;
      }

      log('AuthCubit: Calling sendOtp with email: $email');
      final otpCode = await _authRepository.sendOtp(email);
      log('AuthCubit: sendOtp returned: $otpCode');
      
      if (otpCode != null) {
        log('AuthCubit: OTP sent successfully via API');
        emit(const AuthForgetPasswordOtpSentSuccess('OTP sent successfully! Check your email for the verification code.'));
      } else {
        log('AuthCubit: Emitting AuthForgetPasswordError - Failed to send OTP');
        emit(const AuthForgetPasswordError('Failed to send OTP'));
      }
    } catch (e) {
      log('AuthCubit Forget Password Error: $e');
      final errorMessage = _extractErrorMessage(e);
      emit(AuthForgetPasswordError(errorMessage));
    }
  }

  String _extractErrorMessage(dynamic error) {
    String errorMessage = error.toString();
    
    // Remove "Exception: " prefix if it exists
    if (errorMessage.startsWith('Exception: ')) {
      errorMessage = errorMessage.substring(11);
    }
    
    // Handle ApiErrorResponse if it's wrapped in an exception
    if (error is Exception && error.toString().contains('ApiErrorResponse')) {
      // Try to extract the actual error message from the exception
      final match = RegExp(r'ApiErrorResponse\([^)]*message: ([^,)]+)\)').firstMatch(errorMessage);
      if (match != null) {
        errorMessage = match.group(1) ?? errorMessage;
      }
    }
    
    return errorMessage;
  }

  /// Get current user profile data
  void loadUserProfile() {
    log('loadUserProfile: _userImagePath type: ${_userImagePath.runtimeType}, value: $_userImagePath');
    log('loadUserProfile: _safeUserImagePath type: ${_safeUserImagePath.runtimeType}, value: $_safeUserImagePath');
    
    try {
      final imagePathToEmit = _safeUserImagePath;
      log('loadUserProfile: About to emit AuthUserProfileLoaded with imagePath: $imagePathToEmit');
      
      emit(AuthUserProfileLoaded(
        name: _userName,
        email: _userEmail,
        imagePath: imagePathToEmit,
        phone: _userPhone,
        gender: _userGender,
      ));
      log('loadUserProfile: Successfully emitted AuthUserProfileLoaded with imagePath: $imagePathToEmit');
    } catch (e) {
      log('loadUserProfile: Error emitting AuthUserProfileLoaded: $e');
      // Fallback: emit with null imagePath
      emit(AuthUserProfileLoaded(
        name: _userName,
        email: _userEmail,
        imagePath: null,
        phone: _userPhone,
        gender: _userGender,
      ));
      log('loadUserProfile: Emitted fallback AuthUserProfileLoaded with null imagePath');
    }
  }

  /// Update user profile data locally
  void updateUserProfileData({
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? imagePath,
  }) {
    log('updateUserProfileData: Called with imagePath: $imagePath, type: ${imagePath.runtimeType}');
    
    if (name != null) {
      _userName = name;
      log('updateUserProfileData: Updated _userName to: $name');
    }
    if (email != null) {
      _userEmail = email;
      log('updateUserProfileData: Updated _userEmail to: $email');
    }
    if (phone != null) {
      _userPhone = phone;
      log('updateUserProfileData: Updated _userPhone to: $phone');
    }
    if (gender != null) {
      _userGender = gender;
      log('updateUserProfileData: Updated _userGender to: $gender');
    }
    if (imagePath != null) {
      log('updateUserProfileData: Processing imagePath: $imagePath, type: ${imagePath.runtimeType}');
      try {
        // Ensure we always assign a string, not a File object
        _userImagePath = imagePath.toString();
        log('updateUserProfileData: Successfully assigned imagePath to _userImagePath');
        log('updateUserProfileData: _userImagePath is now: $_userImagePath, type: ${_userImagePath.runtimeType}');
        log('updateUserProfileData: _userImagePath length: ${_userImagePath?.length ?? 0}');
        log('updateUserProfileData: _userImagePath starts with data:image/: ${_userImagePath?.startsWith('data:image/') ?? false}');
        log('updateUserProfileData: _userImagePath is long string: ${(_userImagePath?.length ?? 0) > 100}');
        
        // Save profile image to SharedPreferences for persistence
        _saveProfileImageToStorage(imagePath);
      } catch (e) {
        log('updateUserProfileData: Error assigning imagePath: $e');
        _userImagePath = null;
      }
    } else {
      log('updateUserProfileData: imagePath is null, not updating _userImagePath');
    }
    
    log('updateUserProfileData: Final state - _userName: $_userName, _userEmail: $_userEmail, _userImagePath: $_userImagePath');
    
    // Emit updated profile data
    loadUserProfile();
  }

  /// Save profile image to SharedPreferences
  Future<void> _saveProfileImageToStorage(String imagePath) async {
    try {
      await _storageService.saveProfileImage(imagePath);
      log('updateUserProfileData: Profile image saved to SharedPreferences');
    } catch (e) {
      log('updateUserProfileData: Error saving profile image to SharedPreferences: $e');
    }
  }
}
