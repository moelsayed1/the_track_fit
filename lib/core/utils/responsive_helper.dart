import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/constants.dart';

class ResponsiveHelper {
  final BuildContext context;
  
  ResponsiveHelper(this.context);
  
  // Screen dimensions
  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;
  
  // Width percentage
  double wp(double percentage) => (screenWidth * percentage / 100);
  
  // Height percentage  
  double hp(double percentage) => (screenHeight * percentage / 100);
  
  // Responsive font size using ScreenUtil
  double sp(double size) => size.sp;
  
  // Responsive width using ScreenUtil
  double w(double width) => width.w;
  
  // Responsive height using ScreenUtil
  double h(double height) => height.h;
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppConstants.mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppConstants.mobileBreakpoint &&
           MediaQuery.of(context).size.width < AppConstants.tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppConstants.desktopBreakpoint;
  }

  static double getResponsiveFontSize(BuildContext context, {
    double mobile = 14,
    double tablet = 16,
    double desktop = 18,
  }) {
    if (isMobile(context)) return mobile.sp;
    if (isTablet(context)) return tablet.sp;
    return desktop.sp;
  }

  static double getResponsivePadding(BuildContext context, {
    double mobile = 16,
    double tablet = 24,
    double desktop = 32,
  }) {
    if (isMobile(context)) return mobile.w;
    if (isTablet(context)) return tablet.w;
    return desktop.w;
  }

  static double getResponsiveLogoSize(BuildContext context) {
    if (isMobile(context)) return 180.w;
    if (isTablet(context)) return 140.w;
    return 180.w;
  }

  static EdgeInsets getResponsiveEdgeInsets(BuildContext context) {
    double padding = getResponsivePadding(context);
    return EdgeInsets.all(padding);
  }

  static Widget responsiveBuilder({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }
} 