import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import '../../data/services/packages_service.dart';
import '../../domain/models/package.dart';

class PlanSubscriptionScreen extends StatefulWidget {
  const PlanSubscriptionScreen({super.key});

  @override
  State<PlanSubscriptionScreen> createState() => _PlanSubscriptionScreenState();
}

class _PlanSubscriptionScreenState extends State<PlanSubscriptionScreen> {
  int? _selectedPlanIndex;
  List<Package> _packages = [];
  bool _isLoading = true;
  String? _error;
  
  // Services
  final PackagesService _packagesService = PackagesService.instance;

  @override
  void initState() {
    super.initState();
    _loadPackages();
  }

  Future<void> _loadPackages() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final packagesResponse = await _packagesService.getActivePackages();
      
      setState(() {
        _packages = packagesResponse.data.packages;
        _isLoading = false;
      });
      
      log('Loaded ${_packages.length} packages');
    } catch (e) {
      setState(() {
        _error = 'Failed to load packages: ${e.toString()}';
        _isLoading = false;
      });
      log('Error loading packages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SafeArea(
        child: Column(
          children: [
            // Close button at the top
            Padding(
              padding: EdgeInsets.only( right: 15.w),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    context.push(AppRouter.homeFeature);
                  },
                  child: Container(
                    width: 24.w,
                    height: 24.h,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Scrollable content
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _error != null
                      ? _buildErrorState()
                      : _buildPackagesList(),
            ),
            
            // Buy Now button at the bottom
            if (_selectedPlanIndex != null)
              _buildBuyNowButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 12.h),
          _buildHeader(),
          SizedBox(height: 30.h),
          
          // Shimmer for plan cards
          ...List.generate(3, (index) => Column(
            children: [
              _buildShimmerPlanCard(),
              if (index < 2) SizedBox(height: 16.h),
            ],
          )),
          
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildShimmerPlanCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: Colors.red,
          ),
          SizedBox(height: 16.h),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontSize: 16.sp,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: _loadPackages,
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildPackagesList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 12.h),
          _buildHeader(),
          SizedBox(height: 30.h),
          ..._packages.asMap().entries.map((entry) {
            final index = entry.key;
            final package = entry.value;
            return Column(
              children: [
                _buildPlanCard(
                  index: index,
                  package: package,
                ),
                if (index < _packages.length - 1) SizedBox(height: 16.h),
              ],
            );
          }),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/images/plan.svg',
          height: 200.h,
        ),
        SizedBox(height: 20.h),
        Text(
          'Unlock Your Fit The Track',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose the plan that fits your fitness journey.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF848484),
            fontSize: 12.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard({
    required int index,
    required Package package,
  }) {
    bool isSelected = _selectedPlanIndex != null && _selectedPlanIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlanIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF28A228) : const Color(0x26848484),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x191E1E1E),
              blurRadius: 4,
              offset: Offset(0, 0),
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            package.enName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (package.mostPopular)
                          Container(
                            margin: EdgeInsets.only(left: 8.w),
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0x26FBBC05),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: Color(0xFFFBBC05), size: 10.sp),
                                const SizedBox(width: 4),
                                Text(
                                  'Most Popular',
                                  style: TextStyle(
                                    color: Color(0xFFFBBC05),
                                    fontSize: 10.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          package.formattedPrice,
                          style: TextStyle(
                            color: Color(0xFF1E1E1E),
                            fontSize: 18.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '/${package.durationInMonths}',
                          style: TextStyle(
                            color: Color(0xBF1E1E1E),
                            fontSize: 10.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ),
                _buildSelectButton(isSelected),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0x26848484), thickness: 1),
            const SizedBox(height: 16),
            // Display features from the package description
            ...package.features.map((feature) => Column(
              children: [
                _buildFeatureRow(text: feature),
                const SizedBox(height: 13),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectButton(bool isSelected) {
    if (isSelected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0.00, 0.50),
            end: Alignment(1.00, 0.50),
            colors: [Color(0xFF28A228), Color(0xD85CD65C)],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Row(
          children: [
            Icon(Icons.check, color: Colors.white, size: 14),
            SizedBox(width: 4),
            Text(
              'Selected',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF28A228), width: 1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Text(
          'Select',
          style: TextStyle(
            color: Color(0xFF28A228),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
  }

  Widget _buildFeatureRow({required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: Color(0xFF5CB85C), size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }

  Widget _buildBuyNowButton() {
    // Get the selected plan details
    final selectedPlan = _getSelectedPlan();
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1E000000),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: ElevatedButton(
        onPressed: () {
          // Pass the selected plan data to checkout
          context.push(AppRouter.checkoutPlan, extra: selectedPlan);
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Center(
            child: Text(
              'Buy Now',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getSelectedPlan() {
    if (_selectedPlanIndex != null && _selectedPlanIndex! < _packages.length) {
      final package = _packages[_selectedPlanIndex!];
      return {
        'id': package.id,
        'title': package.enName,
        'price': package.formattedPrice,
        'isMostPopular': package.mostPopular,
        'features': package.features,
        'duration': package.durationInMonths,
        'image': package.fullImageUrl,
      };
    }
    return {};
  }
}