import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/date_selector.dart';
import '../../../../core/widgets/meal_card.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  State<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  int _selectedDateIndex = 3; // Monday 7 is selected by default

  final List<Map<String, String>> _dates = [
    {'day': 'Fri', 'date': '5'},
    {'day': 'Sat', 'date': '6'},
    {'day': 'Sun', 'date': '11'},
    {'day': 'Mon', 'date': '7'},
    {'day': 'Tue', 'date': '8'},
    {'day': 'Wed', 'date': '9'},
    {'day': 'Thu', 'date': '10'},
  ];

  void _onDateSelected(int index) {
    setState(() {
      _selectedDateIndex = index;
    });
  }

  void _onScanMeal() {
    context.push(AppRouter.scanYourMeal);
  }

  void _onMealSwap(String mealType) {
    // TODO: Implement meal swapping functionality
    log('Swap $mealType tapped');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: Column(
        children: [
          // Header
          _buildHeader(),
          
          // Scan Your Meal Section
          _buildScanSection(),
          SizedBox(height: 12.h),
          
          // Your Meals Section
          _buildMealsSection(),
          
          // Meals List
          Expanded(
            child: _buildMealsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Text(
        'Meals',
        style: AppTextStyles.heading1.copyWith(
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildScanSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0x2628A228),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Scan Your Meal',
            style: TextStyle(
              color: const Color(0xFF28A228),
              fontSize: 16.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: _onScanMeal,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/scan_meal.svg',
                    width: 32.w,
                    height: 32.h,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Tap to Scan your food',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
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

  Widget _buildMealsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Text(
            'Your Meals',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 16.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        DateSelector(
          dates: _dates,
          initialSelectedIndex: _selectedDateIndex,
          onDateSelected: _onDateSelected,
        ),
      ],
    );
  }

  Widget _buildMealsList() {
    return Container(
      margin: EdgeInsets.only(top: 0.h, left: 16.w, right: 16.w),
      child: ListView(
        children: [
          MealCard(
            mealType: 'Breakfast',
            description: 'Oats, Banana, Peanut Butter',
            calories: 420,
            imagePath: 'assets/images/breakfast.jpg',
            onSwap: () => _onMealSwap('Breakfast'),
          ),
          MealCard(
            mealType: 'Lunch',
            description: 'Oats, Banana, Peanut Butter',
            calories: 420,
            imagePath: 'assets/images/lunch.png',
            onSwap: () => _onMealSwap('Lunch'),
          ),
          MealCard(
            mealType: 'Dinner',
            description: 'Oats, Banana, Peanut Butter',
            calories: 420,
            imagePath: 'assets/images/dinner.jpg',
            onSwap: () => _onMealSwap('Dinner'),
          ),
        ],
      ),
    );
  }
}