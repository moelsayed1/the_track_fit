import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import 'package:the_track_fit/core/widgets/localized_text.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';

class SubscribtionDone extends StatelessWidget {
  const SubscribtionDone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content - centered
            Positioned(
              left: 60.w,
              top: 180.h,
              child: SizedBox(
                width: 255.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Trophy GIF
                    SizedBox(
                      width: 200.w,
                      height: 200.h,
                      child: Image.asset(
                        'assets/images/trophy.gif',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Text content
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 255.w,
                            child: LocalizedText(
                              AppLocalizations.of(context)!.congratulations,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF28A228),
                              textAlign: TextAlign.center,
                              letterSpacing: 0.50,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          SizedBox(
                            width: 255.w,
                            child: LocalizedText(
                              AppLocalizations.of(context)!.youveUpgradedToPremium,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF848484),
                              textAlign: TextAlign.center,
                              letterSpacing: 0.50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom buttons container
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: 375.w,
                height: 148.h,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x1E000000),
                      blurRadius: 4,
                      offset: const Offset(4, 0),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Explore My Plan button
                    GestureDetector(
                      onTap: () {
                        context.push(AppRouter.subscription);
                      },
                      child: Container(
                        width: double.infinity,
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
                          shadows: [
                            BoxShadow(
                              color: const Color(0x2628A228),
                              blurRadius: 4,
                              offset: const Offset(4, 0),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            LocalizedText(
                              AppLocalizations.of(context)!.exploreMyPlan,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              textAlign: TextAlign.center,
                              height: 1.50,
                              letterSpacing: 0.50,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Go To Home button
                    GestureDetector(
                      onTap: () {
                        context.push(AppRouter.homeFeature);
                      },
                      child: SizedBox(
                        width: 343.w,
                        height: 52.h,
                        child: Container(
                          width: 343.w,
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 1.50,
                                strokeAlign: BorderSide.strokeAlignOutside,
                                color: Color(0xFF28A228),
                              ),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 311.w,
                                child: LocalizedText(
                                  AppLocalizations.of(context)!.goToHome,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF28A228),
                                  textAlign: TextAlign.center,
                                  height: 1.50,
                                  letterSpacing: 0.50,
                                ),
                              ),
                            ],
                          ),
                        ),
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
}