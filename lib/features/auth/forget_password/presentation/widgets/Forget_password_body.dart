import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/auth_header.dart';
import '../../../../../core/router/app_router.dart';

class ForgetPasswordBody extends StatefulWidget {
  const ForgetPasswordBody({super.key});

  @override
  State<ForgetPasswordBody> createState() => _ForgetPasswordBodyState();
}

class _ForgetPasswordBodyState extends State<ForgetPasswordBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.wp(4),
        ),
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
    return PrimaryButton(
      text: 'Send',
      onPressed: _isLoading ? null : _handleSendResetLink,
      isLoading: _isLoading,
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

  void _handleSendResetLink() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // TODO: Implement password reset logic
        await Future.delayed(const Duration(seconds: 2)); // Simulate API call
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reset link sent to your email!'),
              backgroundColor: AppColors.primaryGreen,
            ),
          );
          
          // Navigate to OTP screen
          context.push('${AppRouter.otp}?email=${_emailController.text}');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _handleResendCode() {
    if (_emailController.text.isNotEmpty && _validateEmail(_emailController.text) == null) {
      _handleSendResetLink();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email first'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}