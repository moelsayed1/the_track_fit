
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/auth_header.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/social_login_button.dart';
import '../../../../../core/widgets/custom_snackbar.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/services/storage_service.dart';
import '../../../data/cubit/auth_cubit.dart';
import '../../../data/cubit/auth_states.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Simplified validation - the cubit handles detailed validation
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.email + ' ' + AppLocalizations.of(context)!.required;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.password + ' ' + AppLocalizations.of(context)!.required;
    }
    return null;
  }

  void _handleLogin() {
    // Call the login method from AuthCubit
    // The cubit will handle validation internally
    context.read<AuthCubit>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  void _showValidationErrors(Map<String, String> errors) {
    // Show the first validation error
    final firstError = errors.values.first;
    CustomSnackbar.show(
      context,
      title: 'Validation Error',
      message: firstError,
      type: SnackbarType.warning,
    );
  }



  void _handleGoogleLogin() {
    // Call the Google sign-in method from AuthCubit
    context.read<AuthCubit>().signInWithGoogle();
  }

  void _handleForgotPassword() {
    context.push(AppRouter.forgetPassword);
  }

  void _navigateToSignup() {
    context.push(AppRouter.signup);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginSuccess || state is AuthLoginSuccessWithProfile) {
          // Show success message with Custom Snackbar
          CustomSnackbar.show(
            context,
            title: 'Login Successful!',
            message: state is AuthLoginSuccess ? state.response.message : 'Welcome back!',
            type: SnackbarType.success,
          );
          
          // Check if user is first time or returning user
          _navigateBasedOnUserType(context);
        } else if (state is AuthGoogleSignInSuccess) {
          // Show success message for Google sign-in
          CustomSnackbar.show(
            context,
            title: 'Google Sign-In Successful!',
            message: 'Welcome ${state.name}!',
            type: SnackbarType.success,
          );
          
          // Navigate based on user type
          _navigateBasedOnUserType(context);
        } else if (state is AuthGoogleSignInError) {
          // Show error message for Google sign-in
          CustomSnackbar.show(
            context,
            title: 'Google Sign-In Failed',
            message: state.message,
            type: SnackbarType.error,
          );
        } else if (state is AuthGoogleSignInCancelled) {
          // User cancelled Google sign-in, no need to show error
          log('Google sign-in cancelled by user');
        } else if (state is AuthValidationError) {
          // Show validation errors
          _showValidationErrors(state.fieldErrors);
        } else if (state is AuthError) {
          // Show error message with Custom Snackbar
          CustomSnackbar.show(
            context,
            title: 'Login Failed',
            message: state.message,
            type: SnackbarType.error,
          );
        }
      },
      child: Scaffold(
      backgroundColor: const Color(0xFFF6FFF6), // Light green background
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.wp(4.3)),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: responsive.hp(2.5)),
      
                // Header with illustration
                AuthHeader(
                  title: AppLocalizations.of(context)!.login,
                  subtitle: AppLocalizations.of(context)!.welcomeBack,
                  illustration: SvgPicture.asset(
                    AppLogos.login,
                    width: responsive.wp(66.7),
                    height: responsive.wp(64.5),
                  ),
                ),
      
                SizedBox(height: responsive.hp(4)),
      
                // Form fields
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      hintText: 'Email',
                      prefixIconAsset: AppIcons.email,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                    ),
                    SizedBox(height: responsive.hp(2)),
      
                    // Password field with Forgot Password link
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          hintText: 'Password',
                          prefixIconAsset: AppIcons.lock,
                          isPassword: true,
                          controller: _passwordController,
                          validator: _validatePassword,
                        ),
                        SizedBox(height: responsive.hp(1.25)), // 10px spacing like in your code
                        // Forgot Password link positioned under password field
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: responsive.wp(3.5)), // 10px padding matching your code
                          child: GestureDetector(
                            onTap: _handleForgotPassword,
                            child: Text(
                              'Forget Password ?',
                              style: TextStyle(
                                color: AppColors.grayMedium,
                                fontSize: responsive.sp(12),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
      
                SizedBox(height: responsive.hp(4)),
      
                // Login button
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return PrimaryButton(
                      text: 'Login',
                      onPressed: _handleLogin,
                      height: responsive.hp(7),
                      isLoading: state is AuthLoading && state is! AuthGoogleSignInSuccess && state is! AuthGoogleSignInError && state is! AuthGoogleSignInCancelled,
                    );
                  },
                ),
      
                SizedBox(height: responsive.hp(1.5)),
      
                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You don't have an account? ",
                      style: TextStyle(
                        color: AppColors.grayMedium,
                        fontSize: responsive.sp(14),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: _navigateToSignup,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontSize: responsive.sp(14),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
      
                SizedBox(height: responsive.hp(10)),
      
                // Google login button
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return SocialLoginButton(
                      text: 'Continue with Google',
                      iconPath: AppIcons.google,
                      onPressed: _handleGoogleLogin,
                      isLoading: state is AuthLoading && (state is! AuthLoginSuccess && state is! AuthValidationError && state is! AuthError),
                    );
                  },
                ),
                SizedBox(height: responsive.hp(1.5)),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }

  /// Navigate based on user type (first time vs returning user)
  Future<void> _navigateBasedOnUserType(BuildContext context) async {
    try {
      final storageService = await StorageService.getInstance();
      final isFirstTime = storageService.isFirstTimeUser();
      
      if (isFirstTime) {
        // First time user - go to home_screen (onboarding flow)
        context.push(AppRouter.home);
      } else {
        // Returning user - go to home_feature (main app)
        context.push(AppRouter.homeFeature);
      }
    } catch (e) {
      // Fallback to home_screen if error
      context.push(AppRouter.home);
    }
  }
}
