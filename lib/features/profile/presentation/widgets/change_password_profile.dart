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
  bool showActionButtons = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to all controllers to detect when text changes
    currentPasswordController.addListener(_checkIfShouldShowButtons);
    newPasswordController.addListener(_checkIfShouldShowButtons);
    confirmPasswordController.addListener(_checkIfShouldShowButtons);
  }

  void _checkIfShouldShowButtons() {
    bool hasText = currentPasswordController.text.isNotEmpty ||
                   newPasswordController.text.isNotEmpty ||
                   confirmPasswordController.text.isNotEmpty;
    
    if (hasText != showActionButtons) {
      setState(() {
        showActionButtons = hasText;
      });
    }
  }

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
        child: Column( // استخدام Column بدلاً من Stack لتنظيم العناصر عمودياً
          children: [
            // Custom Header at the top
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: const BoxDecoration(color: Color(0x26848484)),
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
            
            // Main Content (Input Fields)
            Expanded( // Expanded يأخذ كل المساحة المتاحة
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Column(
                    children: [
                      SizedBox(height: 24.h),
                      _buildPasswordField(
                        controller: currentPasswordController,
                        hintText: 'Current Password',
                        isPasswordVisible: isCurrentPasswordVisible,
                        onToggleVisibility: () => _togglePasswordVisibility('current'),
                      ),
                      SizedBox(height: 16.h),
                      _buildPasswordField(
                        controller: newPasswordController,
                        hintText: 'New Password',
                        isPasswordVisible: isNewPasswordVisible,
                        onToggleVisibility: () => _togglePasswordVisibility('new'),
                      ),
                      SizedBox(height: 16.h),
                      _buildPasswordField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                        isPasswordVisible: isConfirmPasswordVisible,
                        onToggleVisibility: () => _togglePasswordVisibility('confirm'),
                      ),
                      // لا نحتاج إلى SizedBox هنا
                    ],
                  ),
                ),
              ),
            ),

                          // Action Buttons at the bottom
              if (showActionButtons) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Container(
                width: 347.w,
                padding: EdgeInsets.symmetric(vertical: 20.h), // مساحة علوية وسفلية
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // توزيع الأزرار
                  children: [
                    Container(
                      width: 246.w,
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
                      decoration: ShapeDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment(0.00, 0.50),
                          end: Alignment(1.00, 0.50),
                          colors: [Color(0xFF28A228), Color(0xD85CD65C)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x2628A228),
                            blurRadius: 4,
                            offset: Offset(4, 0),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Handle save changes
                          },
                          borderRadius: BorderRadius.circular(30.r),
                          child: Center(
                            child: Text(
                              'Save Changes',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                                letterSpacing: 0.50,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        currentPasswordController.clear();
                        newPasswordController.clear();
                        confirmPasswordController.clear();
                      },
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF848484),
                          fontSize: 16.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
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
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 8.w),
                SvgPicture.asset(
                  'assets/images/lock_icon.svg',
                  width: 20.w,
                  height: 20.h,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF28A228),
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextField(
                    controller: controller,
                    obscureText: !isPasswordVisible,
                    style: TextStyle(
                      color: const Color(0xFF1E1E1E),
                      fontSize: 12.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(
                        color: const Color(0xB2848484),
                        fontSize: 12.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onToggleVisibility,
            child: SvgPicture.asset(
              isPasswordVisible ? 'assets/images/eye-slash.svg' : 'assets/images/eye.svg' ,
              width: 20.w,
              height: 20.h,
              colorFilter: const ColorFilter.mode(
                Color(0xFF848484),
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}