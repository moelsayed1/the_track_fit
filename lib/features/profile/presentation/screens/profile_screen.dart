import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import 'package:the_track_fit/core/widgets/custom_snackbar.dart';
import '../../../auth/data/cubit/auth_cubit.dart';
import '../../../auth/data/cubit/auth_states.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? selectedSection;
  String currentLanguage = 'Arabic'; // Default language

  void _selectSection(String section) {
    setState(() {
      selectedSection = section;
    });
  }

  void _toggleLanguage() {
    setState(() {
      currentLanguage = currentLanguage == 'Arabic' ? 'English' : 'Arabic';
      selectedSection = 'Language';
    });
  }

  void _handleLogout() {
    // Show confirmation dialog
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Close",
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 250.w,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Logout',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Are you sure you want to logout?',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: const Color(0xFFFF4444),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.read<AuthCubit>().logout();
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim, secondaryAnim, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(anim);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
                if (state is AuthLogoutSuccess) {
          // Show success message with Custom Snackbar
          CustomSnackbar.show(
            context,
            title: 'Logout Successful!',
            message: state.message,
            type: SnackbarType.success,
          );
 
          // Navigate to login screen
          context.go('/login');
        } else if (state is AuthError) {
          // Show error message with Custom Snackbar
          CustomSnackbar.show(
            context,
            title: 'Logout Failed',
            message: state.message,
            type: SnackbarType.error,
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6FFF6),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              // Green background container (Top Wave)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: TopWaveClipper(), // استخدام الـ Clipper المحدث
                  child: Container(
                    height: 220.h, // يمكنك ضبط الارتفاع حسب الحاجة
                    color: const Color(0x4028A228), // اللون الجديد: #28A22840
                  ),
                ),
              ),

              SafeArea(
                child: Column(
                  children: [
                    // Profile Header
                    _buildProfileHeader(),

                    // Profile Content
                    _buildProfileContent(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          // Back Button
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: SizedBox(
                width: 24.w,
                height: 24.h,
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
            ),
          ),

          SizedBox(height: 20.h),

          // Profile Image and Name
          Center(
            child: Column(
              children: [
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      image: AssetImage('assets/images/profile_image.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Disha', // تم تغيير الاسم ليتناسب مع الصورة
                  style: TextStyle(
                    color: const Color(0xFF1E1E1E),
                    fontSize: 16.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          SizedBox(height: 16.h),

          // Products Section
          _buildProductsSection(),

          SizedBox(height: 24.h),

          // Profile Management Section
          _buildProfileManagementSection(),

          SizedBox(height: 16.h),

          // Settings Section
          _buildSettingsSection(),

          SizedBox(height: 16.h),

          // Notifications Section
          _buildNotificationsSection(),

          SizedBox(height: 16.h),

          // Main Goal Section
          _buildMainGoalSection(),

          SizedBox(height: 16.h),

          // Favourite Exercise Section
          _buildFavouriteExerciseSection(),

          SizedBox(height: 16.h),

          // Logout Section
          _buildLogoutSection(),
        ],
      ),
    );
  }

  Widget _buildProductsSection() {
    bool isSelected = selectedSection == "Products";
    return GestureDetector(
      onTap: () {
        _selectSection("Products");
        context.push(AppRouter.store);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x2628A228) : Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF28A228)
                : const Color(0x26848484),
            width: 1.w,
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/images/product_profile.svg',
              width: 24.w,
              height: 24.h,
              colorFilter: const ColorFilter.mode(
                Color(0xFF28A228),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'Products',
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF28A228)
                    : const Color(0xFF1E1E1E),
                fontSize: 16.sp,
                fontFamily: 'Poppins',
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileManagementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Management',
          style: TextStyle(
            color: const Color(0xFF1E1E1E),
            fontSize: 14.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: const Color(0x26848484), width: 1.w),
            boxShadow: [
              BoxShadow(
                color: const Color(0x19000000),
                blurRadius: 4.r,
                offset: Offset(0, 0),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildProfileItem(
                icon: 'assets/images/edit_profile.svg',
                title: 'Edit Profile',
                showDivider: true,
              ),
              _buildProfileItem(
                icon: 'assets/images/premium_profile.png',
                title: 'Subscription',
                showDivider: false,
              ),
              // _buildProfileItem(
              //   icon: 'assets/images/card_payment.png',
              //   title: 'Payment Info',
              //   showDivider: false,
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Setting',
          style: TextStyle(
            color: const Color(0xFF1E1E1E),
            fontSize: 14.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: const Color(0x26848484), width: 1.w),
            boxShadow: [
              BoxShadow(
                color: const Color(0x19000000),
                blurRadius: 4.r,
                offset: Offset(0, 0),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildProfileItem(
                icon: 'assets/images/lock_icon.svg',
                title: 'Change Password',
                showDivider: true,
              ),
              _buildLanguageItem(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    bool isSelected = selectedSection == "Notifications";
    return GestureDetector(
      onTap: () {
        _selectSection("Notifications");
        context.push('/notification');
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x2628A228) : Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF28A228)
                : const Color(0x26848484),
            width: 1.w,
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/images/notification.svg',
              width: 24.w,
              height: 24.h,
              colorFilter: const ColorFilter.mode(
                Color(0xFF28A228),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'Notifications',
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF28A228)
                    : const Color(0xFF1E1E1E),
                fontSize: 16.sp,
                fontFamily: 'Poppins',
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainGoalSection() {
    bool isSelected = selectedSection == "Main Goal";
    return GestureDetector(
      onTap: () {
        _selectSection("Main Goal");
        context.push('/main-goal');
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x2628A228) : Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF28A228)
                : const Color(0x26848484),
            width: 1.w,
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/images/goal.svg',
              width: 24.w,
              height: 24.h,
              colorFilter: const ColorFilter.mode(
                Color(0xFF28A228),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'Main Goal',
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF28A228)
                    : const Color(0xFF1E1E1E),
                fontSize: 16.sp,
                fontFamily: 'Poppins',
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavouriteExerciseSection() {
    bool isSelected = selectedSection == "Favourite Exercise";
    return GestureDetector(
      onTap: () {
        _selectSection("Favourite Exercise");
        context.push(AppRouter.favouriteExercise);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x2628A228) : Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF28A228)
                : const Color(0x26848484),
            width: 1.w,
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/images/favourite.svg',
              width: 24.w,
              height: 24.h,
              colorFilter: const ColorFilter.mode(
                Color(0xFF28A228),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'Favourite Exercise',
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF28A228)
                    : const Color(0xFF1E1E1E),
                fontSize: 16.sp,
                fontFamily: 'Poppins',
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutSection() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: _handleLogout,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: const Color(0x26FF4444), // Light red border
                width: 1.w,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.logout,
                  color: const Color(0xFFFF4444), // Red color for logout
                  size: 24.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  state is AuthLoading ? 'Logging out...' : 'Logout',
                  style: TextStyle(
                    color: const Color(0xFFFF4444), // Red color for logout
                    fontSize: 16.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (state is AuthLoading) ...[
                  SizedBox(width: 8.w),
                  SizedBox(
                    width: 16.w,
                    height: 16.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFFFF4444),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileItem({
    required String icon,
    required String title,
    required bool showDivider,
  }) {
    bool isSelected = selectedSection == title;

    return GestureDetector(
      onTap: () {
        if (title == 'Edit Profile') {
          context.push('/edit-profile');
        } else if (title == 'Subscription') {
          context.push('/subscription');
        } else if (title == 'Payment Info') {
          context.push('/payment-info');
        } else if (title == 'Change Password') {
          context.push('/change-password');
        } else {
          _selectSection(title);
        }
      },
      child: Column(
        children: [
          Row(
            children: [
              icon.endsWith('.svg')
                  ? SvgPicture.asset(
                      icon,
                      width: 24.w,
                      height: 24.h,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF28A228),
                        BlendMode.srcIn,
                      ),
                    )
                  : Image.asset(
                      icon,
                      width: 24.w,
                      height: 24.h,
                      color: const Color(0xFF28A228),
                    ),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFF28A228)
                      : const Color(0xFF1E1E1E),
                  fontSize: 16.sp,
                  fontFamily: 'Poppins',
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                ),
              ),
            ],
          ),
          if (showDivider) ...[
            SizedBox(height: 16.h),
            Container(
              width: 311.w,
              height: 1.h,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0x26848484),
                    width: 1.w,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ],
      ),
    );
  }

  Widget _buildLanguageItem() {
    bool isSelected = selectedSection == "Language";
    return GestureDetector(
      onTap: () => _toggleLanguage(),
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/language.svg',
                  width: 24.w,
                  height: 24.h,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF28A228),
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Language',
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF28A228)
                        : const Color(0xFF1E1E1E),
                    fontSize: 16.sp,
                    fontFamily: 'Poppins',
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                  ),
                ),
              ],
            ),
            Text(
              currentLanguage,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF28A228)
                    : const Color(0xFF1E1E1E),
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Clipper to create the wave shape precisely as in the image
class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(
      0,
      size.height * 0.7,
    ); // تبدأ من حوالي 70% من الارتفاع على اليسار

    // نقطة تحكم واحدة ومنحنى سلس
    var controlPoint = Offset(
      size.width * 0.5,
      size.height * 0.9,
    ); // نقطة تحكم وسطى وأسفل
    var endPoint = Offset(
      size.width,
      size.height * 0.65,
    ); // تنتهي في منتصف الارتفاع على اليمين

    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    path.lineTo(size.width, 0); // تكمل الخط إلى أعلى اليمين
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
