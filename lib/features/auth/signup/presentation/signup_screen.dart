import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/widgets/auth_header.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/social_login_button.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement signup logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
      context.push('/home');
    }
  }

  void _handleGoogleSignup() {
    // TODO: Implement Google signup
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google signup not implemented yet')),
    );
  }

  void _navigateToLogin() {
    context.push('/login');
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Scaffold(
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
                  title: "Let's Get You Started",
                  subtitle: "Enter your email and password for login",
                  illustration: SvgPicture.asset(
                    AppLogos.signUp,
                    width: responsive.wp(66.7),
                    height: responsive.wp(64.5),
                  ),
                ),
      
                SizedBox(height: responsive.hp(4)),
      
                // Form fields
                Column(
                  children: [
                    CustomTextField(
                      hintText: 'E-mail',
                      prefixIconAsset: AppIcons.email,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                    ),
                    SizedBox(height: responsive.hp(2)),
      
                    CustomTextField(
                      hintText: 'Username',
                      prefixIconAsset: AppIcons.username,
                      controller: _usernameController,
                      validator: (value) => _validateRequired(value, 'Username'),
                    ),
                    SizedBox(height: responsive.hp(2)),
      
                    CustomTextField(
                      hintText: 'Phone',
                      prefixIconAsset: AppIcons.phone,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) => _validateRequired(value, 'Phone'),
                    ),
                    SizedBox(height: responsive.hp(2)),
      
                    CustomTextField(
                      hintText: 'Password',
                      prefixIconAsset: AppIcons.lock,
                      isPassword: true,
                      controller: _passwordController,
                      validator: _validatePassword,
                    ),
                    SizedBox(height: responsive.hp(2)),
      
                    CustomTextField(
                      hintText: 'Confirm Password',
                      prefixIconAsset: AppIcons.lock,
                      isPassword: true,
                      controller: _confirmPasswordController,
                      validator: _validateConfirmPassword,
                    ),
                  ],
                ),
      
                SizedBox(height: responsive.hp(4)),
      
                // Create Account button
                PrimaryButton(
                  text: 'Create Account',
                  onPressed: _handleSignup,
                  height: responsive.hp(7),
                ),
      
                SizedBox(height: responsive.hp(1)),
      
                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You already have an account? ',
                      style: TextStyle(
                        color: AppColors.grayMedium,
                        fontSize: responsive.sp(14),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: _navigateToLogin,
                      child: Text(
                        'Login',
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
      
                SizedBox(height: responsive.hp(4)),
      
                // Google signup button
                SocialLoginButton(
                  text: 'Continue with Google',
                  iconPath: AppIcons.google,
                  onPressed: _handleGoogleSignup,
                ),
                SizedBox(height: responsive.hp(4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
