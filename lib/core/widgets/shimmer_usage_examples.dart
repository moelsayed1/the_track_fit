// This file contains usage examples for the shimmer loading components
// You can reference this when implementing shimmer loaders in your app

import 'package:flutter/material.dart';
import 'package:the_track_fit/core/widgets/shimmer_loading.dart';

class ShimmerUsageExamples {
  
  /// Example 1: Simple loading screen with message
  static Widget loadingScreen() {
    return const ShimmerLoadingScreen(
      message: 'Loading products...',
    );
  }
  
  /// Example 2: Product detail loading
  static Widget productDetailLoading() {
    return const ShimmerProductDetail();
  }
  
  /// Example 3: Custom shimmer with your app's colors
  static Widget customShimmer() {
    return ShimmerLoading(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
  
  /// Example 4: List of shimmer cards
  static Widget shimmerList() {
    return Column(
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ShimmerCard(
            height: 80,
            padding: const EdgeInsets.all(16),
          ),
        );
      }),
    );
  }
  
  /// Example 5: Text content shimmer
  static Widget textShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerText(width: 200, height: 20),
        const SizedBox(height: 8),
        const ShimmerText(width: 150, height: 16),
        const SizedBox(height: 8),
        const ShimmerText(width: 100, height: 16),
      ],
    );
  }
  
  /// Example 6: Profile shimmer
  static Widget profileShimmer() {
    return Row(
      children: [
        const ShimmerCircle(size: 50),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerText(width: 120, height: 18),
              const SizedBox(height: 4),
              const ShimmerText(width: 80, height: 14),
            ],
          ),
        ),
      ],
    );
  }
}

/// Usage in your widgets:
/// 
/// 1. For loading screens:
///    child: _isLoading ? ShimmerUsageExamples.loadingScreen() : _buildContent()
/// 
/// 2. For product detail:
///    child: _isLoading ? ShimmerUsageExamples.productDetailLoading() : ProductDetailScreen()
/// 
/// 3. For custom shimmer:
///    child: _isLoading ? ShimmerUsageExamples.customShimmer() : _buildWidget()
/// 
/// 4. For lists:
///    child: _isLoading ? ShimmerUsageExamples.shimmerList() : ListView.builder(...)

