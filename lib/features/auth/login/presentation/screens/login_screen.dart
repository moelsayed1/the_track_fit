import 'package:flutter/material.dart';
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // Basic phone validation - you can make this more sophisticated
    if (value.length < 10) {
      return 'Please enter a valid phone number';
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

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Simulate login process
        await Future.delayed(const Duration(seconds: 2));

        // TODO: Implement actual login logic
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: AppColors.primaryGreen,
            ),
          );

          // Always navigate to gender question after successful login
          context.push(AppRouter.genderQuestion);
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
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

    return Scaffold(
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
                      hintText: 'Phone',
                      prefixIconAsset: AppIcons.phone,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: _validatePhone,
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
                PrimaryButton(
                  text: 'Login',
                  onPressed: _isLoading ? null : _handleLogin,
                  height: responsive.hp(7),
                  isLoading: _isLoading,
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
    );
  }
}
