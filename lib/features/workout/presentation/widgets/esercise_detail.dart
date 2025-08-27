import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:the_track_fit/features/workout/domain/models/exercise.dart';
import 'package:the_track_fit/core/utils/responsive_helper.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import 'package:the_track_fit/core/constants/app_assets.dart';
import 'package:the_track_fit/features/workout/presentation/screens/scan_exercise_screen.dart';

class ExerciseDetail extends StatelessWidget {
  final Exercise exercise;
  
  const ExerciseDetail({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final responsiveHelper = ResponsiveHelper(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50.h),
            // Custom Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: responsiveHelper.w(16),
                vertical: responsiveHelper.h(8),
              ),
              decoration: const BoxDecoration(
                color: Color(0x26848484),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      'assets/logos/arrow_left.svg',
                      width: responsiveHelper.w(24),
                      height: responsiveHelper.h(24),
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF1E1E1E),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(width: responsiveHelper.w(8)),
                  Text(
                    'Exercise Detail',
                    style: TextStyle(
                      color: const Color(0xFF1E1E1E),
                      fontSize: responsiveHelper.sp(18),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 0.89,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: responsiveHelper.h(28)),
            
            // Exercise Illustration Section
            Container(
              width: double.infinity,
              height: responsiveHelper.h(300),
              color: const Color(0xFFF6FFF6),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    AppAssets.exerciseGif,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            SizedBox(height: responsiveHelper.h(30)),
            
            // Divider Line
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveHelper.w(16)),
              child: Container(
                width: double.infinity,
                height: responsiveHelper.h(1.5),
                color: const Color(0x3F848484),
              ),
            ),
          
            // Exercise Information Section
            Padding(
              padding: EdgeInsets.all(responsiveHelper.w(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exercise Title
                  Text(
                    exercise.title,
                    style: TextStyle(
                      color: const Color(0xFF1E1E1E),
                      fontSize: responsiveHelper.sp(20),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  SizedBox(height: responsiveHelper.h(12)),
                  
                  // Exercise Description
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
                    style: TextStyle(
                      color: const Color(0xFF1E1E1E),
                      fontSize: responsiveHelper.sp(14),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                  
                  SizedBox(height: responsiveHelper.h(50)),
                  
                  // Start Exercise Button
                  SizedBox(
                    width: double.infinity,
                    height: responsiveHelper.h(50),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScanExerciseScreen(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,  
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            'Start Your Exercise',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: responsiveHelper.sp(16),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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