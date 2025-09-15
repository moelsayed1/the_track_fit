import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? period;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.period,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey[300]!,
      highlightColor: highlightColor ?? Colors.grey[100]!,
      period: period ?? const Duration(milliseconds: 1500),
      child: child,
    );
  }
}

// Pre-built shimmer components for common use cases
class ShimmerCard extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsets? padding;

  const ShimmerCard({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 60.h,
        padding: padding ?? EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? 15.r),
        ),
      ),
    );
  }
}

class ShimmerText extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;

  const ShimmerText({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 16.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
        ),
      ),
    );
  }
}

class ShimmerCircle extends StatelessWidget {
  final double? size;

  const ShimmerCircle({
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: size ?? 22.w,
        height: size ?? 22.h,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class ShimmerList extends StatelessWidget {
  final int itemCount;
  final double? itemHeight;
  final double? spacing;
  final Widget Function(int index)? itemBuilder;

  const ShimmerList({
    super.key,
    this.itemCount = 5,
    this.itemHeight,
    this.spacing,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount, (index) {
        return Column(
          children: [
            itemBuilder?.call(index) ?? ShimmerCard(height: itemHeight),
            if (index < itemCount - 1) SizedBox(height: spacing ?? 16.h),
          ],
        );
      }),
    );
  }
}

// Specific shimmer components for your app's common patterns
class ShimmerGoalOption extends StatelessWidget {
  const ShimmerGoalOption({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          children: [
            // Radio button skeleton
            ShimmerCircle(size: 22.w),
            SizedBox(width: 16.w),
            // Text skeleton
            Expanded(
              child: ShimmerText(height: 16.h),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerProductCard extends StatelessWidget {
  const ShimmerProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          children: [
            // Image skeleton
            Container(
              width: 54.w,
              height: 64.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(width: 16.w),
            // Content skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerText(width: 120.w, height: 16.h),
                  SizedBox(height: 8.h),
                  ShimmerText(width: 80.w, height: 14.h),
                  SizedBox(height: 8.h),
                  ShimmerText(width: 60.w, height: 14.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerProfileItem extends StatelessWidget {
  final bool showIcon;
  final bool showArrow;

  const ShimmerProfileItem({
    super.key,
    this.showIcon = true,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          children: [
            if (showIcon) ...[
              ShimmerCircle(size: 20.w),
              SizedBox(width: 12.w),
            ],
            Expanded(
              child: ShimmerText(height: 14.h),
            ),
            if (showArrow) ...[
              SizedBox(width: 12.w),
              ShimmerCircle(size: 20.w),
            ],
          ],
        ),
      ),
    );
  }
}

// Shimmer loader for product detail screen
class ShimmerProductDetail extends StatelessWidget {
  const ShimmerProductDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image shimmer
            ShimmerLoading(
              child: Container(
                width: double.infinity,
                height: 300.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            
            // Product name shimmer
            ShimmerText(width: 200.w, height: 24.h),
            SizedBox(height: 8.h),
            
            // Product price shimmer
            ShimmerText(width: 100.w, height: 20.h),
            SizedBox(height: 16.h),
            
            // Product description shimmer
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerText(width: double.infinity, height: 16.h),
                SizedBox(height: 8.h),
                ShimmerText(width: double.infinity, height: 16.h),
                SizedBox(height: 8.h),
                ShimmerText(width: 150.w, height: 16.h),
              ],
            ),
            SizedBox(height: 24.h),
            
            // Add to cart button shimmer
            ShimmerLoading(
              child: Container(
                width: double.infinity,
                height: 56.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            
            // Additional info shimmer
            ShimmerCard(
              height: 80.h,
              padding: EdgeInsets.all(16.w),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple loading shimmer for general use
class ShimmerLoadingScreen extends StatelessWidget {
  final String? message;
  
  const ShimmerLoadingScreen({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Loading animation
            ShimmerLoading(
              child: Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            if (message != null) ...[
              SizedBox(height: 24.h),
              Text(
                message!,
                style: TextStyle(
                  color: const Color(0xFF848484),
                  fontSize: 16.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}