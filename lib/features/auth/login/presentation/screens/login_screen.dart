import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/auth_header.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/social_login_button.dart';
import '../../../../../core/router/app_router.dart';
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
      return 'Email is required';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(firstError),
        backgroundColor: Colors.orange,
      ),
    );
  }



  void _handleGoogleLogin() {
    // TODO: Implement Google login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Google login not implemented yet'),
        backgroundColor: AppColors.grayMedium,
      ),
    );
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
        if (state is AuthLoading) {
          // Show loading indicator
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is AuthLoginSuccess) {
          // Hide loading indicator
          Navigator.of(context).pop();
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.response.message),
              backgroundColor: Colors.green,
            ),
          );
          
          // Navigate to next screen
          context.push(AppRouter.promotionalOffer);
        } else if (state is AuthValidationError) {
          // Hide loading indicator
          Navigator.of(context).pop();
          
          // Show validation errors
          _showValidationErrors(state.fieldErrors);
        } else if (state is AuthError) {
          // Hide loading indicator
          Navigator.of(context).pop();
          
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
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
                  title: "Log In",
                  subtitle: "Welcome Back",
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
                      text: state is AuthLoading ? 'Logging in...' : 'Login',
                      onPressed: state is AuthLoading ? null : _handleLogin,
                      height: responsive.hp(7),
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
                SocialLoginButton(
                  text: 'Continue with Google',
                  iconPath: AppIcons.google,
                  onPressed: _handleGoogleLogin,
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
}
