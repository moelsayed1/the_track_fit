import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';
import '../../../../../core/extensions/localization_extensions.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_snackbar.dart';
import '../../../../../core/widgets/localized_text.dart';
import '../../../../../core/router/app_router.dart';
import '../../../data/cubit/auth_cubit.dart';
import '../../../data/cubit/auth_states.dart';

class NewPasswordScreenBody extends StatefulWidget {
  final String email;
  final String otp;
  
  const NewPasswordScreenBody({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<NewPasswordScreenBody> createState() => _NewPasswordScreenBodyState();
}

class _NewPasswordScreenBodyState extends State<NewPasswordScreenBody> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        // Only listen to states relevant to password reset
        return current is AuthPasswordResetSuccess || 
               current is AuthValidationError || 
               current is AuthPasswordResetError;
      },
      listener: (context, state) {
        if (state is AuthPasswordResetSuccess) {
          CustomSnackbar.show(
            context,
            title: AppLocalizations.of(context)!.success,
            message: AppLocalizations.of(context)!.passwordResetSuccessfully,
            type: SnackbarType.success,
          );
          // Show success dialog
          _showResetPasswordDoneDialog(context);
        } else if (state is AuthValidationError) {
          final firstError = state.fieldErrors.values.first;
          CustomSnackbar.show(
            context,
            title: AppLocalizations.of(context)!.validationError,
            message: firstError,
            type: SnackbarType.error,
          );
        } else if (state is AuthPasswordResetError) {
          CustomSnackbar.show(
            context,
            title: AppLocalizations.of(context)!.error,
            message: state.message,
            type: SnackbarType.error,
          );
          // If it's an OTP error, navigate back to OTP screen
          if (state.message.toLowerCase().contains('otp')) {
            Future.delayed(const Duration(seconds: 2), () {
              context.push('${AppRouter.otp}?email=${widget.email}');
            });
          }
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(4.3), // 16px equivalent
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: responsive.hp(0)), // 44px equivalent
                
                // New Password Logo/Illustration
                _buildNewPasswordLogo(responsive),
                
                SizedBox(height: responsive.hp(4)), // 32px equivalent
                
                // New Password Content Section
                _buildNewPasswordContent(responsive, isLoading),
                
                SizedBox(height: responsive.hp(4)), // 16px equivalent
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewPasswordLogo(ResponsiveHelper responsive) {
    return SizedBox(
      width: responsive.w(250),
      height: responsive.h(250),
      child: SvgPicture.asset(
        AppLogos.newPassword,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildNewPasswordContent(ResponsiveHelper responsive, bool isLoading) {
    return SizedBox(
      width: responsive.w(343),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title and Subtitle
          SizedBox(
            width: responsive.w(258),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.newPassword,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF111827),
                    fontFamily: context.fontFamily,
                  ),
                  textAlign: TextAlign.start,
                ),
                
                SizedBox(height: responsive.h(8)),
                
                Text(
                  AppLocalizations.of(context)!.createYourNewPassword,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.gray,
                    fontFamily: context.fontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          SizedBox(height: responsive.h(16)),
          
          // Password Form
          _buildPasswordForm(responsive, isLoading),
        ],
      ),
    );
  }

  Widget _buildPasswordForm(ResponsiveHelper responsive, bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Password Field
          CustomTextField(
            controller: _passwordController,
            hintText: AppLocalizations.of(context)!.password,
            prefixIconAsset: AppIcons.lock,
            isPassword: true,
            validator: _validatePassword,
          ),
          
          SizedBox(height: responsive.h(16)),
          
          // Confirm Password Field
          CustomTextField(
            controller: _confirmPasswordController,
            hintText: AppLocalizations.of(context)!.confirmPassword,
            prefixIconAsset: AppIcons.lock,
            isPassword: true,
            validator: _validateConfirmPassword,
          ),
          
          SizedBox(height: responsive.h(16)),
          
          // Confirm Button
          _buildConfirmButton(responsive, isLoading),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(ResponsiveHelper responsive, bool isLoading) {
    return PrimaryButton(
      text: AppLocalizations.of(context)!.confirm,
      onPressed: isLoading ? null : _handleConfirm,
      isLoading: isLoading,
      height: responsive.h(56),
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.passwordRequired;
    }
    if (value.length < 6) {
      return AppLocalizations.of(context)!.passwordMustBeAtLeast6Characters;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.pleaseConfirmYourPassword;
    }
    if (value != _passwordController.text) {
      return AppLocalizations.of(context)!.passwordsDoNotMatch;
    }
    return null;
  }

  void _handleConfirm() {
    if (_formKey.currentState!.validate()) {
      // Use the email and OTP passed from the OTP screen
      context.read<AuthCubit>().resetPassword(
        email: widget.email,
        otp: widget.otp,
        newPassword: _passwordController.text,
      );
    }
  }

  void _showResetPasswordDoneDialog(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: responsive.w(300),
            height: responsive.h(280),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success GIF Animation
                SizedBox(
                  width: responsive.w(120),
                  height: responsive.h(120),
                  child: Image.asset(
                    AppAnimations.doneGif,
                    fit: BoxFit.contain,
                  ),
                ),
                
                SizedBox(height: responsive.h(16)),
                
                // Congratulations Title
                Text(
                  AppLocalizations.of(context)!.congratulations,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryGreen,
                    fontFamily: context.fontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: responsive.h(8)),
                
                // Subtitle
                Text(
                  AppLocalizations.of(context)!.yourAccountIsReadyToUse,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.gray,
                    fontFamily: context.fontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: responsive.h(24)),
                
                // Go To Login Page Button
                SizedBox(
                  width: responsive.w(250),
                  height: responsive.h(48),
                  child: PrimaryButton(
                    text: AppLocalizations.of(context)!.goToLoginPage,
                    style: TextStyle(
                      fontSize: responsive.sp(16),
                      color: Colors.white,
                      fontFamily: context.fontFamily,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      context.pushReplacement(AppRouter.login); // Navigate to login
                    },
                    height: responsive.h(48),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}