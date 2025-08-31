import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordProfile extends StatefulWidget {
  const ChangePasswordProfile({super.key});

  @override
  State<ChangePasswordProfile> createState() => _ChangePasswordProfileState();
}

class _ChangePasswordProfileState extends State<ChangePasswordProfile> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isCurrentPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility(String field) {
    setState(() {
      switch (field) {
        case 'current':
          isCurrentPasswordVisible = !isCurrentPasswordVisible;
          break;
        case 'new':
          isNewPasswordVisible = !isNewPasswordVisible;
          break;
        case 'confirm':
          isConfirmPasswordVisible = !isConfirmPasswordVisible;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 65.h),

                  // Password Input Fields Container
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: SizedBox(
                      width: 347.w,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Current Password Field
                          _buildPasswordField(
                            controller: currentPasswordController,
                            hintText: 'Current Password',
                            isPasswordVisible: isCurrentPasswordVisible,
                            onToggleVisibility: () => _togglePasswordVisibility('current'),
                          ),

                          SizedBox(height: 16.h),

                          // New Password Field
                          _buildPasswordField(
                            controller: newPasswordController,
                            hintText: 'New Password',
                            isPasswordVisible: isNewPasswordVisible,
                            onToggleVisibility: () => _togglePasswordVisibility('new'),
                          ),

                          SizedBox(height: 16.h),

                          // Confirm Password Field
                          _buildPasswordField(
                            controller: confirmPasswordController,
                            hintText: 'Confirm Password',
                            isPasswordVisible: isConfirmPasswordVisible,
                            onToggleVisibility: () => _togglePasswordVisibility('confirm'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 100.h), // Bottom spacing
                ],
              ),
            ),

            // Custom Header at the top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(color: const Color(0x26848484)),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: SvgPicture.asset(
                        'assets/logos/arrow_left.svg',
                        width: 24.w,
                        height: 24.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF1E1E1E),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Change Password',
                      style: TextStyle(
                        color: const Color(0xFF1E1E1E),
                        fontSize: 18.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0.89,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isPasswordVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Color(0x26848484),
          ),
          borderRadius: BorderRadius.circular(30.r),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 8.w),
              SvgPicture.asset(
                'assets/images/lock_icon.svg',
                width: 20.w,
                height: 20.h,
              ),
              SizedBox(width: 8.w),
              Text(
                hintText,
                style: TextStyle(
                  color: const Color(0xB2848484),
                  fontSize: 12.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onToggleVisibility,
            child: SvgPicture.asset(
              'assets/images/eye-slash.svg',
              width: 20.w,
              height: 20.h,
            ),
          ),
        ],
      ),
    );
  }
}