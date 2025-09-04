import 'package:the_track_fit/features/auth/data/models/register_response.dart';

/// Base class for all authentication states
abstract class AuthState {
  const AuthState();
}

/// Initial state when the app starts
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state for any auth operation
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Success state for registration
class AuthRegisterSuccess extends AuthState {
  final RegisterResponse response;
  
  const AuthRegisterSuccess(this.response);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthRegisterSuccess && other.response == response;
  }
  
  @override
  int get hashCode => response.hashCode;
}

/// Success state for login
class AuthLoginSuccess extends AuthState {
  final RegisterResponse response;
  
  const AuthLoginSuccess(this.response);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthLoginSuccess && other.response == response;
  }
  
  @override
  int get hashCode => response.hashCode;
}

/// Success state for OTP sending
class AuthOtpSentSuccess extends AuthState {
  final String message;
  
  const AuthOtpSentSuccess(this.message);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthOtpSentSuccess && other.message == message;
  }
  
  @override
  int get hashCode => message.hashCode;
}

/// Success state for forget password OTP sending
class AuthForgetPasswordOtpSentSuccess extends AuthState {
  final String message;
  
  const AuthForgetPasswordOtpSentSuccess(this.message);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthForgetPasswordOtpSentSuccess && other.message == message;
  }
  
  @override
  int get hashCode => message.hashCode;
}

/// Success state for OTP verification
class AuthOtpVerifiedSuccess extends AuthState {
  final String message;
  
  const AuthOtpVerifiedSuccess(this.message);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthOtpVerifiedSuccess && other.message == message;
  }
  
  @override
  int get hashCode => message.hashCode;
}

/// Success state for password reset
class AuthPasswordResetSuccess extends AuthState {
  final String message;
  
  const AuthPasswordResetSuccess(this.message);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthPasswordResetSuccess && other.message == message;
  }
  
  @override
  int get hashCode => message.hashCode;
}

/// Success state for logout
class AuthLogoutSuccess extends AuthState {
  final String message;
  
  const AuthLogoutSuccess(this.message);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthLogoutSuccess && other.message == message;
  }
  
  @override
  int get hashCode => message.hashCode;
}

/// Error state for any auth operation
class AuthError extends AuthState {
  final String message;
  final String? errorCode;
  
  const AuthError(this.message, {this.errorCode});
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthError && 
           other.message == message && 
           other.errorCode == errorCode;
  }
  @override
  int get hashCode => message.hashCode ^ errorCode.hashCode;
}

/// Error state for forget password flow
class AuthForgetPasswordError extends AuthState {
  final String message;
  
  const AuthForgetPasswordError(this.message);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthForgetPasswordError && other.message == message;
  }
  
  @override
  int get hashCode => message.hashCode;
}

/// Error state for OTP verification flow
class AuthOtpVerificationError extends AuthState {
  final String message;
  
  const AuthOtpVerificationError(this.message);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthOtpVerificationError && other.message == message;
  }
  
  @override
  int get hashCode => message.hashCode;
}

/// Validation error state for form validation
class AuthValidationError extends AuthState {
  final Map<String, String> fieldErrors;
  
  const AuthValidationError(this.fieldErrors);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthValidationError && 
           other.fieldErrors.toString() == fieldErrors.toString();
  }
  
  @override
  int get hashCode => fieldErrors.hashCode;
}

/// Password reset error state
class AuthPasswordResetError extends AuthState {
  final String message;
  
  const AuthPasswordResetError(this.message);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthPasswordResetError && other.message == message;
  }
  
  @override
  int get hashCode => message.hashCode;
}
