import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A custom scaffold that provides consistent top spacing across all screens
class AppScaffold extends StatelessWidget {
  final Widget body;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final bool extendBody;
  final double topSpacing;

  const AppScaffold({
    super.key,
    required this.body,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.extendBody = false,
    this.topSpacing = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      drawer: drawer,
      endDrawer: endDrawer,
      extendBody: extendBody,
      body: SafeArea(
        child: Column(
          children: [
            // Consistent top spacing
            SizedBox(height: topSpacing.h),
            // Main content
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

/// A custom scaffold for screens that need custom SafeArea behavior
class AppScaffoldWithCustomSafeArea extends StatelessWidget {
  final Widget body;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final bool extendBody;
  final double topSpacing;
  final bool top;
  final bool left;
  final bool right;
  final bool bottom;

  const AppScaffoldWithCustomSafeArea({
    super.key,
    required this.body,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.extendBody = false,
    this.topSpacing = 0.0,
    this.top = true,
    this.left = true,
    this.right = true,
    this.bottom = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      drawer: drawer,
      endDrawer: endDrawer,
      extendBody: extendBody,
      body: SafeArea(
        top: top,
        left: left,
        right: right,
        bottom: bottom,
        child: Column(
          children: [
            // Consistent top spacing
            SizedBox(height: topSpacing.h),
            // Main content
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
