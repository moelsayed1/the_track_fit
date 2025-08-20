import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/core/router/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // 0: Home, 1: Workout, 2: Scan, 3: Report, 4: Plan

  void _onTabTapped(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        context.push(AppRouter.home);
        break;
      case 1:
        // TODO: Add workout route when available
        break;
      case 2:
        // TODO: Add scan route when available
        break;
      case 3:
        // TODO: Add report route when available
        break;
      case 4:
        // Already on plan screen
        break;
    }
  }

  Color _getTabColor(int index) =>
      _currentIndex == index ? const Color(0xFF28A228) : const Color(0xFF848484);

  String _getScreenTitle(int index) {
    const titles = ['Home', 'Workout', 'Scan', 'Report', 'Plan'];
    return (index >= 0 && index < titles.length) ? titles[index] : 'Plan';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TopStatusBar(),
                    _Header(
                      title: _getScreenTitle(_currentIndex),
                    ),
                    _GreetingSection(),
                    SizedBox(height: 32.h),
                    _HomePlanIllustration(),
                    SizedBox(height: 50.h),
                    _MainCTASection(),
                  ],
                ),
              ),
            ),
            _BottomNavBar(
              currentIndex: _currentIndex,
              onTabTapped: _onTabTapped,
              getTabColor: _getTabColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopStatusBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      height: 0.h,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  const _Header({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h),
      child: SizedBox(
        width: 343.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _PointsContainer(),
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF1E1E1E),
                fontSize: 24.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            _ProfileContainer(),
          ],
        ),
      ),
    );
  }
}

class _PointsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 32.h,
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 6.h),
      decoration: ShapeDecoration(
        color: const Color(0x3328A228),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Color(0xFF28A228),
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/logos/star_icon.svg',
            width: 14.w,
            height: 14.h,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 2.w),
          Text(
            '0',
            style: TextStyle(
              color: const Color(0xFF28A228),
              fontSize: 11.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 32.h,
      padding: EdgeInsets.all(5.w),
      decoration: ShapeDecoration(
        color: const Color(0x3328A228),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFF28A228),
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/logos/person_icon.svg',
          width: 18.w,
          height: 18.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, top: 30.h),
      child: SizedBox(
        width: 300.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Hi Disha!',
                  style: TextStyle(
                    color: const Color(0xFF1E1E1E),
                    fontSize: 16.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 8.w),
                SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: const Text(
                    '👋',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: 300.w,
              child: Text(
                'Ready to start your journey?',
                style: TextStyle(
                  color: const Color(0xBF848484),
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomePlanIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        width: 343.w,
        child: Center(
          child: SvgPicture.asset(
            'assets/logos/home_plan.svg',
            width: 200.w,
            height: 180.h,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _MainCTASection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: SizedBox(
        width: 343.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: ShapeDecoration(
                gradient: const LinearGradient(
                  begin: Alignment(0.00, 0.50),
                  end: Alignment(1.00, 0.50),
                  colors: [Color(0xFF28A228), Color(0xD85CD65C)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 311.w,
                          child: Text(
                            'You\'re One Step Away from a Healthier You',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        SizedBox(
                          width: 311.w,
                          child: Text(
                            'Start your personalized workout and meal plan now to transform your body and mind.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: 238.w,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () => context.push(AppRouter.homeFeature),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF28A228),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        shadowColor: const Color(0x1928A228),
                        textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                          letterSpacing: 0.50,
                        ),
                      ).copyWith(
                        elevation: WidgetStateProperty.all(0),
                        shadowColor: WidgetStateProperty.all(const Color(0x1928A228)),
                      ),
                      child: Text(
                        'Start Workout',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF28A228),
                          fontSize: 16.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTabTapped;
  final Color Function(int) getTabColor;

  const _BottomNavBar({
    required this.currentIndex,
    required this.onTabTapped,
    required this.getTabColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 8.h, left: 12.w, right: 12.w),
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x2628A228),
                  blurRadius: 4,
                  offset: Offset(4, 0),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _NavBarItem(
                  icon: SvgPicture.asset(
                    'assets/logos/home_icon.svg',
                    width: 24.w,
                    height: 24.h,
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
                      getTabColor(0),
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Home',
                  selected: currentIndex == 0,
                  onTap: () => onTabTapped(0),
                  color: getTabColor(0),
                ),
                _NavBarItem(
                  icon: SvgPicture.asset(
                    'assets/logos/gym_icon.svg',
                    width: 24.w,
                    height: 24.h,
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
                      getTabColor(1),
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Workout',
                  selected: currentIndex == 1,
                  onTap: () => onTabTapped(1),
                  color: getTabColor(1),
                ),
                _NavBarCentralButton(
                  onTap: () => onTabTapped(2),
                ),
                _NavBarItem(
                  icon: SvgPicture.asset(
                    'assets/logos/progressive_icon.svg',
                    width: 24.w,
                    height: 24.h,
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
                      getTabColor(3),
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Report',
                  selected: currentIndex == 3,
                  onTap: () => onTabTapped(3),
                  color: getTabColor(3),
                ),
                _NavBarItem(
                  icon: Image.asset(
                    'assets/logos/premium_icon.png',
                    width: 24.w,
                    height: 24.h,
                    fit: BoxFit.contain,
                    color: getTabColor(4),
                  ),
                  label: 'Plan',
                  selected: currentIndex == 4,
                  onTap: () => onTabTapped(4),
                  color: getTabColor(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            SizedBox(height: 6.h),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.33,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarCentralButton extends StatelessWidget {
  final VoidCallback onTap;

  const _NavBarCentralButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: ShapeDecoration(
                color: const Color(0xFF28A228),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 4,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              child: SizedBox(
                width: 30.w,
                height: 30.h,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/logos/scan_icon.svg',
                    width: 28.w,
                    height: 28.h,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}