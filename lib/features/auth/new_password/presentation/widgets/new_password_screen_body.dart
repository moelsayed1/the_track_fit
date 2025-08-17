import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/custom_button.dart';

class NewPasswordScreenBody extends StatefulWidget {
  const NewPasswordScreenBody({super.key});

  @override
  State<NewPasswordScreenBody> createState() => _NewPasswordScreenBodyState();
}

class _NewPasswordScreenBodyState extends State<NewPasswordScreenBody> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

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
          _buildNewPasswordContent(responsive),
          
          SizedBox(height: responsive.hp(4)), // 16px equivalent
        ],
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

  Widget _buildNewPasswordContent(ResponsiveHelper responsive) {
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
                  'New Password',
                  style: AppTextStyles.heading2.copyWith(
                    fontSize: responsive.sp(20),
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF111827),
                  ),
                ),
                
                SizedBox(height: responsive.h(8)),
                
                Text(
                  'Create your new password',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: responsive.sp(12),
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: responsive.h(16)),
          
          // Password Form
          _buildPasswordForm(responsive),
        ],
      ),
    );
  }

  Widget _buildPasswordForm(ResponsiveHelper responsive) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Password Field
          CustomTextField(
            controller: _passwordController,
            hintText: 'Password',
            prefixIconAsset: AppIcons.lock,
            isPassword: true,
            validator: _validatePassword,
          ),
          
          SizedBox(height: responsive.h(16)),
          
          // Confirm Password Field
          CustomTextField(
            controller: _confirmPasswordController,
            hintText: 'Confirm Password',
            prefixIconAsset: AppIcons.lock,
            isPassword: true,
            validator: _validateConfirmPassword,
          ),
          
          SizedBox(height: responsive.h(16)),
          
          // Confirm Button
          _buildConfirmButton(responsive),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(ResponsiveHelper responsive) {
    return PrimaryButton(
      text: 'Confirm',
      onPressed: _isLoading ? null : _handleConfirm,
      isLoading: _isLoading,
      height: responsive.h(56),
    );
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
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _handleConfirm() async {
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
              content: Text('Password updated successfully!'),
              backgroundColor: AppColors.primaryGreen,
            ),
          );
          // TODO: Navigate to login screen
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
}