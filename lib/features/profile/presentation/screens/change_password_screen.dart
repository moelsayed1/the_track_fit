import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/widgets/custom_snackbar.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Initialize CSRF token
      await _apiService.initializeCsrfToken();

      // Prepare form data
      final formData = {
        'current_password': _currentPasswordController.text,
        'password': _newPasswordController.text,
        'password_confirmation': _confirmPasswordController.text,
      };

      // Make API call
      final response = await _apiService.postForm(
        AppConstants.updateProfileEndpoint,
        data: formData,
      );

      if (response.statusCode == 200) {
        // Success
        if (mounted) {
          CustomSnackbar.show(
            context,
            title: 'Success!',
            message: 'Password changed successfully',
            type: SnackbarType.success,
          );
          
          // Clear form
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
          
          // Navigate back
          context.pop();
        }
      } else {
        // Handle error response
        final errorMessage = response.data['message'] ?? 'Failed to change password';
        if (mounted) {
          CustomSnackbar.show(
            context,
            title: 'Error',
            message: errorMessage,
            type: SnackbarType.error,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.show(
          context,
          title: 'Error',
          message: 'Failed to change password. Please try again.',
          type: SnackbarType.error,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/logos/arrow_left.svg',
            width: 24.w,
            height: 24.h,
            colorFilter: const ColorFilter.mode(
              Color(0xFF1E1E1E),
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Change Password',
          style: TextStyle(
            color: const Color(0xFF1E1E1E),
            fontSize: 18.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              
              // Current Password Field
              _buildPasswordField(
                controller: _currentPasswordController,
                label: 'Current Password',
                isVisible: _isCurrentPasswordVisible,
                onToggleVisibility: () {
                  setState(() {
                    _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 24.h),
              
              // New Password Field
              _buildPasswordField(
                controller: _newPasswordController,
                label: 'New Password',
                isVisible: _isNewPasswordVisible,
                onToggleVisibility: () {
                  setState(() {
                    _isNewPasswordVisible = !_isNewPasswordVisible;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 24.h),
              
              // Confirm Password Field
              _buildPasswordField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                isVisible: _isConfirmPasswordVisible,
                onToggleVisibility: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 40.h),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF28A228),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF1E1E1E),
            fontSize: 14.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          validator: validator,
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: 'Poppins',
            color: const Color(0xFF1E1E1E),
          ),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(
              color: const Color(0xFF848484),
              fontSize: 16.sp,
              fontFamily: 'Poppins',
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.all(12.w),
              child: SvgPicture.asset(
                'assets/images/lock_icon.svg',
                width: 20.w,
                height: 20.h,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF28A228),
                  BlendMode.srcIn,
                ),
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF848484),
                size: 20.w,
              ),
              onPressed: onToggleVisibility,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: const BorderSide(color: Color(0x26848484)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: const BorderSide(color: Color(0x26848484)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: const BorderSide(color: Color(0xFF28A228), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: const BorderSide(color: Color(0xFFFF4444)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: const BorderSide(color: Color(0xFFFF4444), width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
        ),
      ],
    );
  }
}
