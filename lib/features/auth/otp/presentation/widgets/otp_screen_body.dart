import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/otp_input_field.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_snackbar.dart';
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
    _resendCountdown = 30; // 30 seconds countdown
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendCountdown--;
        });
        return _resendCountdown > 0;
      }
      return false;
    });
  }

  @override
  void dispose() {
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
      listener: (context, state) {
        if (state is AuthOtpSentSuccess) {
          CustomSnackbar.show(
            context,
            title: 'OTP Sent!',
            message: state.message,
            type: SnackbarType.success,
          );
          _startResendCountdown();
        } else if (state is AuthOtpVerifiedSuccess) {
          CustomSnackbar.show(
            context,
            title: 'OTP Verified!',
            message: state.message,
            type: SnackbarType.success,
          );
          // Navigate to New Password screen
          context.push(AppRouter.newPassword);
        } else if (state is AuthError) {
          CustomSnackbar.show(
            context,
            title: 'Error',
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
          'OTP',
          style: AppTextStyles.heading2.copyWith(
            fontSize: responsive.sp(20),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF111827),
          ),
        ),
        
        SizedBox(height: responsive.h(16)),
        
        // Email instruction text
        Text(
          'Code has been sent to ${widget.email}',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: responsive.sp(10),
            color: AppColors.gray,
          ),
        ),
        
        SizedBox(height: responsive.h(16)),
        
        // OTP Input Fields
        _buildOtpInputFields(responsive),
      ],
    );
  }

  Widget _buildOtpInputFields(ResponsiveHelper responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.w(8)),
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
    );
  }

  Widget _buildVerifyButton(ResponsiveHelper responsive) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return PrimaryButton(
          text: 'Verify',
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
              ? 'Resend OTP in ${_resendCountdown}s'
              : 'Resend OTP',
            style: TextStyle(
              color: canResend ? AppColors.primaryGreen : AppColors.gray,
              fontSize: responsive.sp(14),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
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
    if (_otpCode.length != 6) {
      CustomSnackbar.show(
        context,
        title: 'Validation Error',
        message: 'Please enter the complete 6-digit OTP',
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
    
    setState(() {
      _isResending = false;
    });
  }
}