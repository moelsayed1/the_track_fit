import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/auth_header.dart';
import '../../../../../core/widgets/custom_snackbar.dart';
import '../../../../../core/router/app_router.dart';
import '../../../data/cubit/auth_cubit.dart';
import '../../../data/cubit/auth_states.dart';

class ForgetPasswordBody extends StatefulWidget {
  const ForgetPasswordBody({super.key});

  @override
  State<ForgetPasswordBody> createState() => _ForgetPasswordBodyState();
}

class _ForgetPasswordBodyState extends State<ForgetPasswordBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) {
          // Only listen to states relevant to forget password flow (sending OTP)
          return current is AuthLoading || 
                 current is AuthForgetPasswordOtpSentSuccess || 
                 current is AuthValidationError || 
                 current is AuthForgetPasswordError;
        },
        listener: (context, state) {
          log('ForgetPassword: State received: ${state.runtimeType}');
          if (state is AuthLoading) {
            log('ForgetPassword: Loading state received');
            // Loading state is handled by the button
          } else if (state is AuthForgetPasswordOtpSentSuccess) {
            log('ForgetPassword: Success state received, showing snackbar and navigating');
            CustomSnackbar.show(
              context,
              title: 'Success',
              message: state.message,
              type: SnackbarType.success,
            );
            // Navigate to OTP screen
            context.push('${AppRouter.otp}?email=${_emailController.text}');
          } else if (state is AuthValidationError) {
            log('ForgetPassword: Validation error state received');
            // Show validation errors
            final firstError = state.fieldErrors.values.first;
            CustomSnackbar.show(
              context,
              title: 'Validation Error',
              message: firstError,
              type: SnackbarType.error,
            );
          } else if (state is AuthForgetPasswordError) {
            log('ForgetPassword: Error state received: ${state.message}');
            CustomSnackbar.show(
              context,
              title: 'Error',
              message: state.message,
              type: SnackbarType.error,
            );
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            log('ForgetPassword: BlocBuilder received state: ${state.runtimeType}');
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: responsive.hp(0)),
                    
                    // Auth Header with logo, title, and subtitle
                    AuthHeader(
                      title: 'Forget Password',
                      subtitle: 'We\'ll send a reset link to your email.',
                      illustration: SvgPicture.asset(
                        AppLogos.forgetPassword,
                        fit: BoxFit.contain,
                      ),
                    ),
                    
                    SizedBox(height: responsive.hp(1)),
                    
                    // Resend Code Link
                    _buildResendCodeLink(responsive),
                    
                    SizedBox(height: responsive.hp(1)),
                    
                    // Email Form
                    _buildEmailForm(responsive),
                    
                    SizedBox(height: responsive.hp(4)),
                    
                    // Send Button
                    _buildSendButton(responsive),
                    
                    SizedBox(height: responsive.hp(4)),
                  ],
                ),
              ),
            );
          },
        ),
    );
  }

  Widget _buildEmailForm(ResponsiveHelper responsive) {
    return Form(
      key: _formKey,
      child: CustomTextField(
        controller: _emailController,
        hintText: 'E-mail',
        prefixIconAsset: AppIcons.email,
        keyboardType: TextInputType.emailAddress,
        validator: _validateEmail,
      ),
    );
  }

  Widget _buildSendButton(ResponsiveHelper responsive) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        //context.read<AuthCubit>().forgetPassword(_emailController.text);
        final isLoading = state is AuthLoading;
        return PrimaryButton(
          text: 'Send',
          onPressed: isLoading ? null : _handleSendResetLink,
          isLoading: isLoading,
        );
      },
    );
  }

  Widget _buildResendCodeLink(ResponsiveHelper responsive) {
    return TextButton(
      onPressed: _handleResendCode,
      child: Text(
        'Resend Code?',
        style: AppTextStyles.bodyMedium.copyWith(
          fontSize: responsive.sp(12),
          color: AppColors.primaryGreen,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    // Email regex pattern
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  void _handleSendResetLink() {
    log('ForgetPassword: Send button pressed');
    if (_formKey.currentState!.validate()) {
      log('ForgetPassword: Form is valid, calling forgetPassword');
      context.read<AuthCubit>().forgetPassword(_emailController.text);
    } else {
      log('ForgetPassword: Form validation failed');
    }
  }

  void _handleResendCode() {
    if (_emailController.text.isNotEmpty &&
        _validateEmail(_emailController.text) == null) {
      _handleSendResetLink();
    } else {
      CustomSnackbar.show(
        context,
        title: 'Warning',
        message: 'Please enter a valid email first',
        type: SnackbarType.warning,
      );
    }
  }
}
