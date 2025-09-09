import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'shimmer_loading.dart';

/// Examples of how to use the common shimmer loading components
/// This file demonstrates various shimmer patterns for different UI elements
class ShimmerExamples {
  
  /// Example: Loading a list of goal options
  static Widget goalOptionsLoading() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          ShimmerList(
            itemCount: 5,
            itemBuilder: (index) => const ShimmerGoalOption(),
          ),
        ],
      ),
    );
  }

  /// Example: Loading product cards
  static Widget productCardsLoading() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          ShimmerList(
            itemCount: 3,
            itemBuilder: (index) => const ShimmerProductCard(),
          ),
        ],
      ),
    );
  }

  /// Example: Loading profile items
  static Widget profileItemsLoading() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          ShimmerList(
            itemCount: 6,
            itemBuilder: (index) => const ShimmerProfileItem(),
          ),
        ],
      ),
    );
  }

  /// Example: Loading a simple card
  static Widget cardLoading() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: const ShimmerCard(
        height: 100,
        borderRadius: 15,
      ),
    );
  }

  /// Example: Loading text content
  static Widget textContentLoading() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerText(width: 200, height: 20),
          SizedBox(height: 8.h),
          const ShimmerText(width: 150, height: 16),
          SizedBox(height: 8.h),
          const ShimmerText(width: 100, height: 16),
        ],
      ),
    );
  }

  /// Example: Loading with custom shimmer colors
  static Widget customColorLoading() {
    return ShimmerLoading(
      baseColor: Colors.blue[300]!,
      highlightColor: Colors.blue[100]!,
      child: Container(
        width: double.infinity,
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  /// Example: Loading a complex layout
  static Widget complexLayoutLoading() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Header with avatar and text
          Row(
            children: [
              const ShimmerCircle(size: 50),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerText(width: 120, height: 18),
                    SizedBox(height: 4.h),
                    const ShimmerText(width: 80, height: 14),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          
          // Content cards
          ShimmerList(
            itemCount: 3,
            itemBuilder: (index) => const ShimmerCard(height: 80),
          ),
        ],
      ),
    );
  }
}

/// Usage examples in your widgets:
/// 
/// 1. For goal options:
///    child: _isLoading ? ShimmerExamples.goalOptionsLoading() : _buildGoalOptions()
/// 
/// 2. For product cards:
///    child: _isLoading ? ShimmerExamples.productCardsLoading() : _buildProductCards()
/// 
/// 3. For profile items:
///    child: _isLoading ? ShimmerExamples.profileItemsLoading() : _buildProfileItems()
/// 
/// 4. For custom layouts:
///    child: _isLoading ? ShimmerExamples.complexLayoutLoading() : _buildContent()
/// 
/// 5. For individual components:
///    ShimmerCard(height: 100, borderRadius: 15)
///    ShimmerText(width: 200, height: 16)
///    ShimmerCircle(size: 40)
///    ShimmerList(itemCount: 5, itemBuilder: (index) => ShimmerCard())
