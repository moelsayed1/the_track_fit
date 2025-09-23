import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? const Color(0xFFE0E0E0),
      highlightColor: highlightColor ?? const Color(0xFFF5F5F5),
      period: const Duration(milliseconds: 1200),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class CategoryShimmerLoader extends StatelessWidget {
  final double iconSize;
  final double textWidth;
  final double textHeight;

  const CategoryShimmerLoader({
    super.key,
    this.iconSize = 32.0,
    this.textWidth = 100.0,
    this.textHeight = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      period: const Duration(milliseconds: 1200),
      child: Row(
        children: [
          // Icon shimmer
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          const SizedBox(width: 8),
          // Text shimmer
          Container(
            width: textWidth,
            height: textHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
        ],
      ),
    );
  }
}
