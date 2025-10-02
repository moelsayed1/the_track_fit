import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:the_track_fit/features/workout/domain/models/exercise.dart';
import 'package:the_track_fit/core/utils/responsive_helper.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import 'package:the_track_fit/core/constants/app_assets.dart';
import 'package:the_track_fit/core/widgets/localized_text.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';
import 'package:the_track_fit/features/workout/presentation/screens/scan_exercise_screen.dart';

class ExerciseDetail extends StatelessWidget {
  final Exercise exercise;
  
  const ExerciseDetail({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final responsiveHelper = ResponsiveHelper(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    LocalizedText(
                      AppLocalizations.of(context)!.exerciseDetail,
                      fontSize: responsiveHelper.sp(18),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1E1E1E),
                      height: 0.89,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: responsiveHelper.h(28)),
            
            // Exercise Illustration Section
            Container(
              width: double.infinity,
              height: responsiveHelper.h(350),
              color: const Color(0xFFF6FFF6),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: exercise.imagePath.startsWith('http')
                      ? Image.network(
                          exercise.imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback to asset image if network image fails
                            return Image.asset(
                              AppAssets.exerciseGif,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            );
                          },
                        )
                      : Image.asset(
                          exercise.imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                ),
              ),
            ),

            SizedBox(height: responsiveHelper.h(12)),
            
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
                  LocalizedText(
                    exercise.title,
                    fontSize: responsiveHelper.sp(20),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E1E1E),
                  ),
                  
                  SizedBox(height: responsiveHelper.h(12)),
                  
                  // Exercise Description
                  LocalizedText(
                    exercise.description?.isNotEmpty == true 
                        ? exercise.description! 
                        : AppLocalizations.of(context)!.noDescriptionAvailable,
                    fontSize: responsiveHelper.sp(14),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF1E1E1E),
                    height: 1.5,
                  ),
                  
                  SizedBox(height: responsiveHelper.h(170)),
                  
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
                          child: LocalizedText(
                            AppLocalizations.of(context)!.startYourExercise,
                            fontSize: responsiveHelper.sp(16),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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
      ),
      ],
      ),
    );
  }
}