import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class MainGoalProfile extends StatefulWidget {
  const MainGoalProfile({super.key});

  @override
  State<MainGoalProfile> createState() => _MainGoalProfileState();
}

class _MainGoalProfileState extends State<MainGoalProfile> {
  int selectedGoalIndex = 1; // "Increase Muscle" is selected by default

  void _selectGoal(int index) {
    setState(() {
      selectedGoalIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
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
                    'Main Goal',
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

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    
                    // Goal Options
                    _buildGoalOption(
                      index: 0,
                      title: 'Weight Loss',
                      isSelected: selectedGoalIndex == 0,
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    _buildGoalOption(
                      index: 1,
                      title: 'Increase Muscle',
                      isSelected: selectedGoalIndex == 1,
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    _buildGoalOption(
                      index: 2,
                      title: 'General Fitness',
                      isSelected: selectedGoalIndex == 2,
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

  Widget _buildGoalOption({
    required int index,
    required String title,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _selectGoal(index),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: ShapeDecoration(
          color: isSelected 
              ? const Color(0x3328A228) // Light green background when selected
              : const Color(0x26848484), // Light gray background when not selected
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: isSelected 
                  ? const Color(0xFF28A228) // Green border when selected
                  : Colors.transparent, // Gray border when not selected
            ),
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        child: Row(
          children: [
            // Radio button container
            Container(
              width: 22.w,
              height: 22.h,
              padding: EdgeInsets.all(4.w),
              decoration: ShapeDecoration(
                color: isSelected 
                    ? const Color(0xFF28A228) // Green background when selected
                    : Colors.transparent, // Transparent when not selected
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color: isSelected 
                        ? const Color(0xFF28A228) // Green border when selected
                        : const Color(0xFF848484), // Gray border when not selected
                  ),
                  borderRadius: BorderRadius.circular(11.r),
                ),
              ),
              child: Center(
                child: Container(
                  width: isSelected ? 9.w : 14.w,
                  height: isSelected ? 9.h : 14.h,
                  decoration: ShapeDecoration(
                    color: isSelected 
                        ? Colors.white // White dot when selected
                        : Colors.transparent, // No dot when not selected
                    shape: const OvalBorder(),
                  ),
                ),
              ),
            ),
            
            SizedBox(width: 16.w),
            
            // Goal title
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}