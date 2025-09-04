import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_track_fit/features/auth/data/models/register_request.dart';
import 'package:the_track_fit/features/auth/repositories/auth_repository.dart';
import 'auth_states.dart';

// Cubit
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  String? _verifiedOtp; // Store the verified OTP

  AuthCubit(this._authRepository) : super(const AuthInitial());

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
      emit(const AuthLogoutSuccess('Logged out successfully'));
    } catch (e) {
      log('AuthCubit Logout Error: $e');
      final errorMessage = _extractErrorMessage(e);
      emit(AuthError(errorMessage));
    }
  }

  /// Reset state to initial
  void reset() {
    emit(const AuthInitial());
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
}
