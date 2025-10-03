import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/widgets/auth_header.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/social_login_button.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/widgets/localized_text.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/cubit/auth_cubit.dart';
import '../../data/cubit/auth_states.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _selectedGender;
  bool _showGenderValidation = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Simplified validation - the cubit handles detailed validation
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.email +
          ' ' +
          AppLocalizations.of(context)!.required;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.password +
          ' ' +
          AppLocalizations.of(context)!.required;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.confirmPassword +
          ' ' +
          AppLocalizations.of(context)!.required;
    }
    return null;
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName ' + AppLocalizations.of(context)!.required;
    }
    return null;
  }

  void _handleSignup() {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate gender selection
    if (_selectedGender == null) {
      setState(() {
        _showGenderValidation = true;
      });
      return;
    }

    // Call the register method from AuthCubit
    // The cubit will handle validation internally
    context.read<AuthCubit>().register(
      name: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      passwordConfirmation: _confirmPasswordController.text,
      gender: _selectedGender!,
    );
  }

  void _handleGoogleSignup() {
    // Call the Google sign-in method from AuthCubit
    context.read<AuthCubit>().signInWithGoogle();
  }

  void _navigateToLogin() {
    context.push('/login');
  }

  void _showValidationErrors(Map<String, String> errors) {
    // Show the first validation error
    final firstError = errors.values.first;
    CustomSnackbar.show(
      context,
      title: AppLocalizations.of(context)!.error,
      message: firstError,
      type: SnackbarType.warning,
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccess ||
            state is AuthRegisterSuccessWithProfile) {
          // Show success message with Custom Snackbar
          CustomSnackbar.show(
            context,
            title: AppLocalizations.of(context)!.success,
            message: state is AuthRegisterSuccess
                ? state.response.message
                : AppLocalizations.of(context)!.welcome,
            type: SnackbarType.success,
          );

          // Check if user is first time or returning user
          _navigateBasedOnUserType(context);
        } else if (state is AuthGoogleSignInSuccess) {
          // Show success message for Google sign-in
          CustomSnackbar.show(
            context,
            title: AppLocalizations.of(context)!.success,
            message: '${AppLocalizations.of(context)!.welcome} ${state.name}!',
            type: SnackbarType.success,
          );

          // Navigate based on user type
          _navigateBasedOnUserType(context);
        } else if (state is AuthGoogleSignInError) {
          // Show error message for Google sign-in
          CustomSnackbar.show(
            context,
            title: AppLocalizations.of(context)!.error,
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
            title: AppLocalizations.of(context)!.error,
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
                  SizedBox(height: responsive.hp(1)),

                  // Header with illustration
                  AuthHeader(
                    title: AppLocalizations.of(context)!.letsGetYouStarted,
                    subtitle: AppLocalizations.of(context)!.loginInstructions,
                    illustration: SvgPicture.asset(
                      AppLogos.signUp,
                      width: responsive.wp(66.7),
                      height: responsive.wp(50),
                    ),
                  ),

                  SizedBox(height: responsive.hp(4)),

                  // Form fields
                  Column(
                    children: [
                      CustomTextField(
                        hintText: AppLocalizations.of(context)!.email,
                        prefixIconAsset: AppIcons.email,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      SizedBox(height: responsive.hp(2)),

                      CustomTextField(
                        hintText: AppLocalizations.of(context)!.nameRequired,
                        prefixIconAsset: AppIcons.username,
                        controller: _usernameController,
                        validator: (value) => _validateRequired(
                          value,
                          AppLocalizations.of(context)!.nameRequired,
                        ),
                      ),
                      SizedBox(height: responsive.hp(2)),

                      CustomTextField(
                        hintText: AppLocalizations.of(context)!.phoneRequired,
                        prefixIconAsset: AppIcons.phone,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) => _validateRequired(
                          value,
                          AppLocalizations.of(context)!.phoneRequired,
                        ),
                      ),
                      SizedBox(height: responsive.hp(2)),

                      // Gender Selection with Custom Toggle
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              top: 12,
                              bottom: 8,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.genderRequired,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.grayMedium,
                                fontFamily:
                                    Localizations.localeOf(
                                          context,
                                        ).languageCode ==
                                        'ar'
                                    ? 'Cairo'
                                    : 'Poppins',
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Row(
                            children: [
                              // Male Option
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedGender = 'male';
                                      _showGenderValidation = false;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: _selectedGender == 'male'
                                          ? AppColors.primaryGreen
                                          : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _selectedGender == 'male'
                                            ? AppColors.primaryGreen
                                            : Colors.grey.shade300,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _selectedGender == 'male'
                                                ? Colors.white
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: _selectedGender == 'male'
                                                  ? Colors.white
                                                  : Colors.grey.shade500,
                                              width: 2,
                                            ),
                                          ),
                                          child: _selectedGender == 'male'
                                              ? Center(
                                                  child: Container(
                                                    width: 8,
                                                    height: 8,
                                                    decoration:
                                                        const BoxDecoration(
                                                          color: AppColors
                                                              .primaryGreen,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                  ),
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.male,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      _selectedGender == 'male'
                                                      ? Colors.white
                                                      : Colors.grey.shade700,
                                                  fontFamily: 'Cairo',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Female Option
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedGender = 'female';
                                      _showGenderValidation = false;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: _selectedGender == 'female'
                                          ? AppColors.primaryGreen
                                          : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _selectedGender == 'female'
                                            ? AppColors.primaryGreen
                                            : Colors.grey.shade300,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _selectedGender == 'female'
                                                ? Colors.white
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: _selectedGender == 'female'
                                                  ? Colors.white
                                                  : Colors.grey.shade500,
                                              width: 2,
                                            ),
                                          ),
                                          child: _selectedGender == 'female'
                                              ? Center(
                                                  child: Container(
                                                    width: 8,
                                                    height: 8,
                                                    decoration:
                                                        const BoxDecoration(
                                                          color: AppColors
                                                              .primaryGreen,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                  ),
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.female,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      _selectedGender ==
                                                          'female'
                                                      ? Colors.white
                                                      : Colors.grey.shade700,
                                                  fontFamily: 'Cairo',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_showGenderValidation && _selectedGender == null)
                            Padding(
                              padding: const EdgeInsets.only(left: 16, top: 8),
                              child: Text(
                                AppLocalizations.of(context)!.genderRequired,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red,
                                  fontFamily:
                                      Localizations.localeOf(
                                            context,
                                          ).languageCode ==
                                          'ar'
                                      ? 'Cairo'
                                      : 'Poppins',
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: responsive.hp(2)),

                      CustomTextField(
                        hintText: AppLocalizations.of(context)!.password,
                        prefixIconAsset: AppIcons.lock,
                        isPassword: true,
                        controller: _passwordController,
                        validator: _validatePassword,
                      ),
                      SizedBox(height: responsive.hp(2)),

                      CustomTextField(
                        hintText: AppLocalizations.of(context)!.confirmPassword,
                        prefixIconAsset: AppIcons.lock,
                        isPassword: true,
                        controller: _confirmPasswordController,
                        validator: _validateConfirmPassword,
                      ),
                    ],
                  ),

                  SizedBox(height: responsive.hp(4)),

                  // Create Account button
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return PrimaryButton(
                        text: AppLocalizations.of(context)!.createAccount,
                        onPressed: _handleSignup,
                        height: responsive.hp(7),
                        isLoading:
                            state is AuthLoading &&
                            state is! AuthGoogleSignInSuccess &&
                            state is! AuthGoogleSignInError &&
                            state is! AuthGoogleSignInCancelled,
                      );
                    },
                  ),

                  SizedBox(height: responsive.hp(1)),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.alreadyHaveAccount + ' ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grayMedium,
                          fontFamily:
                              Localizations.localeOf(context).languageCode ==
                                  'ar'
                              ? 'Cairo'
                              : 'Poppins',
                        ),
                      ),
                      GestureDetector(
                        onTap: _navigateToLogin,
                        child: Text(
                          AppLocalizations.of(context)!.login,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primaryGreen,
                            fontFamily:
                                Localizations.localeOf(context).languageCode ==
                                    'ar'
                                ? 'Cairo'
                                : 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: responsive.hp(4)),

                  // Google signup button
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return SocialLoginButton(
                        text: AppLocalizations.of(context)!.signInWithGoogle,
                        iconPath: AppIcons.google,
                        onPressed: _handleGoogleSignup,
                        isLoading:
                            state is AuthLoading &&
                            (state is! AuthRegisterSuccess &&
                                state is! AuthRegisterSuccessWithProfile &&
                                state is! AuthValidationError &&
                                state is! AuthError),
                      );
                    },
                  ),
                  SizedBox(height: responsive.hp(4)),
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
        // First time user - go to age question (onboarding flow)
        context.push(AppRouter.ageQuestion);
      } else {
        // Returning user - go to home_feature (main app)
        context.push(AppRouter.homeFeature);
      }
    } catch (e) {
      // Fallback to age question if error
      context.push(AppRouter.ageQuestion);
    }
  }
}
