import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';
import '../../../../../core/extensions/localization_extensions.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/otp_input_field.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_snackbar.dart';
import '../../../../../core/widgets/localized_text.dart';
import '../../../../../core/router/app_router.dart';
import '../../../data/cubit/auth_cubit.dart';
import '../../../data/cubit/auth_states.dart';

class OtpScreenBody extends StatefulWidget {
  final String email;
  
  const OtpScreenBody({
    super.key,
    required this.email,
  });

  @override
  State<OtpScreenBody> createState() => _OtpScreenBodyState();
}

class _OtpScreenBodyState extends State<OtpScreenBody> {
  final List<TextEditingController> _otpControllers = List.generate(
    6, 
    (index) => TextEditingController(),
  );
  
  final List<FocusNode> _focusNodes = List.generate(
    6, 
    (index) => FocusNode(),
  );
  
  bool _isResending = false;
  String _otpCode = '';
  int _resendCountdown = 0;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    // Add focus listeners to trigger rebuilds when focus changes
    for (var focusNode in _focusNodes) {
      focusNode.addListener(() {
        setState(() {});
      });
    }
    // Start countdown for resend
    _startResendCountdown();
  }

  void _startResendCountdown() {
    // Cancel any existing timer
    _countdownTimer?.cancel();
    
    _resendCountdown = 30; // 30 seconds countdown
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _resendCountdown--;
        });
        if (_resendCountdown <= 0) {
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        // Only listen to states relevant to OTP verification
        // Don't listen to forget password specific states
        return current is AuthOtpVerifiedSuccess || 
               current is AuthValidationError || 
               current is AuthOtpVerificationError;
      },
      listener: (context, state) {
        if (state is AuthOtpVerifiedSuccess) {
          CustomSnackbar.show(
            context,
            title: AppLocalizations.of(context)!.otpVerified,
            message: AppLocalizations.of(context)!.otpVerifiedSuccessfully,
            type: SnackbarType.success,
          );
          // Navigate to New Password screen with email and OTP
          context.push('${AppRouter.newPassword}?email=${widget.email}&otp=$_otpCode');
        } else if (state is AuthValidationError) {
          // Show validation errors
          final firstError = state.fieldErrors.values.first;
          CustomSnackbar.show(
            context,
            title: AppLocalizations.of(context)!.validationError,
            message: firstError,
            type: SnackbarType.error,
          );
        } else if (state is AuthOtpVerificationError) {
          CustomSnackbar.show(
            context,
            title: AppLocalizations.of(context)!.verificationFailed,
            message: state.message,
            type: SnackbarType.error,
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.wp(4.3), // 16px equivalent
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: responsive.hp(0)), // 44px equivalent
            
            // OTP Logo/Illustration
            _buildOtpLogo(responsive),
            
            SizedBox(height: responsive.hp(2)), // 32px equivalent
            
            // OTP Content Section
            _buildOtpContent(responsive),
            
            SizedBox(height: responsive.hp(4)), // 16px equivalent
            
            // Verify Button
            _buildVerifyButton(responsive),
            
            SizedBox(height: responsive.hp(2)), // 8px equivalent
            
            // Resend OTP Button
            _buildResendButton(responsive),
            
            SizedBox(height: responsive.hp(4)), // 16px equivalent
          ],
        ),
      ),
    );
  }

  Widget _buildOtpLogo(ResponsiveHelper responsive) {
    return SizedBox(
      width: responsive.w(250),
      height: responsive.h(250),
      child: SvgPicture.asset(
        AppLogos.otp,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildOtpContent(ResponsiveHelper responsive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // OTP Title
        Text(
          AppLocalizations.of(context)!.otp,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF111827),
            fontFamily: Localizations.localeOf(context).languageCode == 'ar' ? 'Cairo' : 'Poppins',
          ),
          textAlign: TextAlign.start,
        ),
        
        SizedBox(height: responsive.h(16)),
        
        // Email instruction text
        Text(
          AppLocalizations.of(context)!.codeHasBeenSentTo(widget.email),
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.gray,
            fontFamily: Localizations.localeOf(context).languageCode == 'ar' ? 'Cairo' : 'Poppins',
          ),
          textAlign: TextAlign.center,
        ),
        
        SizedBox(height: responsive.h(16)),
        
        // OTP Input Fields
        _buildOtpInputFields(responsive),
      ],
    );
  }

  Widget _buildOtpInputFields(ResponsiveHelper responsive) {
    final isArabic = context.isArabic;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.w(8)),
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(6, (index) {
            return Row(
              children: [
                OtpInputField(
                  controller: _otpControllers[index],
                  focusNode: _focusNodes[index],
                  index: index,
                  isActive: _focusNodes[index].hasFocus,
                  isFilled: _otpControllers[index].text.isNotEmpty,
                  onChanged: (value) => _handleOtpChange(value, index),
                  onTap: () => _handleOtpTap(index),
                  onBackspace: () => _handleBackspace(index),
                ),
                if (index < 5) SizedBox(width: responsive.w(10)),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildVerifyButton(ResponsiveHelper responsive) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return PrimaryButton(
          text: AppLocalizations.of(context)!.verify,
          onPressed: isLoading ? null : _handleVerify,
          isLoading: isLoading,
          height: responsive.h(56),
        );
      },
    );
  }

  Widget _buildResendButton(ResponsiveHelper responsive) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isResending = state is AuthLoading && _isResending;
        final canResend = _resendCountdown == 0 && !isResending;
        
        return TextButton(
          onPressed: canResend ? _handleResendOtp : null,
          child: Text(
            _resendCountdown > 0 
              ? AppLocalizations.of(context)!.resendOtpIn(_resendCountdown)
              : AppLocalizations.of(context)!.resendOtp,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: canResend ? AppColors.primaryGreen : AppColors.gray,
              fontFamily: Localizations.localeOf(context).languageCode == 'ar' ? 'Cairo' : 'Poppins',
            ),
            textAlign: TextAlign.start,
          ),
        );
      },
    );
  }

  void _handleOtpChange(String value, int index) {
    setState(() {
      _otpCode = _otpControllers.map((c) => c.text).join();
    });
    
    // Auto-focus to next field when typing
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    
    // Note: Backspace handling is now done in _handleBackspace method
    // This ensures proper cursor movement when deleting
  }

  void _handleOtpTap(int index) {
    // Focus the tapped field
    _focusNodes[index].requestFocus();
  }

  void _handleBackspace(int index) {
    // Clear the current field
    _otpControllers[index].clear();
    
    // Move focus to previous field if not the first field
    if (index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    
    // Update the OTP code
    setState(() {
      _otpCode = _otpControllers.map((c) => c.text).join();
    });
  }

  void _handleVerify() {
    // Check if OTP is empty
    if (_otpCode.isEmpty) {
      CustomSnackbar.show(
        context,
        title: AppLocalizations.of(context)!.validationError,
        message: AppLocalizations.of(context)!.pleaseEnterOtpCode,
        type: SnackbarType.warning,
      );
      return;
    }
    
    // Check if OTP is complete (6 digits)
    if (_otpCode.length != 6) {
      CustomSnackbar.show(
        context,
        title: AppLocalizations.of(context)!.validationError,
        message: AppLocalizations.of(context)!.pleaseEnterCompleteOtp,
        type: SnackbarType.warning,
      );
      return;
    }

    // Check if OTP contains only numbers
    if (!RegExp(r'^\d{6}$').hasMatch(_otpCode)) {
      CustomSnackbar.show(
        context,
        title: AppLocalizations.of(context)!.validationError,
        message: AppLocalizations.of(context)!.otpMustContainOnlyNumbers,
        type: SnackbarType.warning,
      );
      return;
    }

    // Call the verifyOtp method from AuthCubit
    context.read<AuthCubit>().verifyOtp(
      email: widget.email,
      otp: _otpCode,
    );
  }

  void _handleResendOtp() {
    setState(() {
      _isResending = true;
    });
    
    // Call the sendOtp method from AuthCubit
    context.read<AuthCubit>().sendOtp(widget.email);
    
    // Start the countdown again after resending
    _startResendCountdown();
    
    setState(() {
      _isResending = false;
    });
  }
}