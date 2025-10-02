import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import 'package:the_track_fit/core/services/api_service.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/date_selector.dart';
import '../../../../core/widgets/meal_card.dart';
import '../../../../core/widgets/localized_text.dart';
import '../../data/repositories/meals_repository_impl.dart';
import '../../domain/models/meals_response.dart';
import '../../../../core/extensions/localization_extensions.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  State<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  late int _selectedDateIndex;
  bool _isLoading = false;
  String? _error;
  MealsResponse? _mealsResponse;
  
  // Track which meal is currently selected for each category
  final Map<String, int> _selectedMealIndices = {};

  // Day names mapping: day_id 1 = Sat, 2 = Sun, 3 = Mon, 4 = Tue, 5 = Wed, 6 = Thu, 7 = Fri
  List<String> _dayNames = [
    'Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'
  ];

  final MealsRepositoryImpl _mealsRepository = MealsRepositoryImpl(apiService: ApiService());

  @override
  void initState() {
    super.initState();
    _initializeSelectedDate();
    _loadMealsForDay();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update day names when dependencies change (language change)
    _updateDayNames();
  }

  void _updateDayNames() {
    // Update day names when language changes
    setState(() {
      _dayNames = [
        AppLocalizations.of(context)!.sat,
        AppLocalizations.of(context)!.sun,
        AppLocalizations.of(context)!.mon,
        AppLocalizations.of(context)!.tue,
        AppLocalizations.of(context)!.wed,
        AppLocalizations.of(context)!.thu,
        AppLocalizations.of(context)!.fri,
      ];
    });
  }

  void _initializeSelectedDate() {
    // Get current day of week (0 = Sunday, 1 = Monday, ..., 6 = Saturday)
    final now = DateTime.now();
    final currentDayOfWeek = now.weekday; // 1 = Monday, 2 = Tuesday, ..., 7 = Sunday
    
    // Convert to our day names array index
    // Our array: ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri']
    // DateTime.weekday: 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat, 7=Sun
    int dayIndex;
    switch (currentDayOfWeek) {
      case 1: // Monday
        dayIndex = 2;
        break;
      case 2: // Tuesday
        dayIndex = 3;
        break;
      case 3: // Wednesday
        dayIndex = 4;
        break;
      case 4: // Thursday
        dayIndex = 5;
        break;
      case 5: // Friday
        dayIndex = 6;
        break;
      case 6: // Saturday
        dayIndex = 0;
        break;
      case 7: // Sunday
        dayIndex = 1;
        break;
      default:
        dayIndex = 2; // Default to Monday if something goes wrong
    }
    
    _selectedDateIndex = dayIndex;
    log('Current day: ${now.weekday}, Selected index: $dayIndex, Day name: ${_dayNames[dayIndex]}');
  }

  int _getDayId(int dayIndex) {
    return dayIndex + 1; // 0->1, 1->2, 2->3, 3->4, 4->5, 5->6, 6->7
  }

  void _onDateSelected(int index) {
    setState(() {
      _selectedDateIndex = index;
    });
    _loadMealsForDay();
  }

  Future<void> _loadMealsForDay() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final dayId = _getDayId(_selectedDateIndex);
      log('Loading meals for day index: $_selectedDateIndex, day_id: $dayId');
      
      final response = await _mealsRepository.getMealsByDay(dayId);
      
      setState(() {
        _mealsResponse = response;
        _isLoading = false;
        // Reset selected meal indices for new data
        _selectedMealIndices.clear();
      });
    } catch (e) {
      log('Error loading meals: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onScanMeal() {
    context.push(AppRouter.scanYourMeal);
  }

  void _onMealSwap(String mealType) {
    if (_mealsResponse == null) return;
    
    // Find the category that matches the mealType
    final category = _mealsResponse!.data.firstWhere(
      (cat) => cat.enName == mealType,
      orElse: () => _mealsResponse!.data.first,
    );
    
    // Get current selected index for this category (default to 0)
    final currentIndex = _selectedMealIndices[mealType] ?? 0;
    
    // Calculate next index (cycle back to 0 if at the end)
    final nextIndex = (currentIndex + 1) % category.meals.length;
    
    setState(() {
      _selectedMealIndices[mealType] = nextIndex;
    });
    
    log('Swapped $mealType from index $currentIndex to $nextIndex');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: Column(
        children: [
          // Header
          _buildHeader(),
          SizedBox(height: 12.h),
          // Scan Your Meal Section
          _buildScanSection(),
          SizedBox(height: 12.h),
          
          // Your Meals Section
          _buildMealsSection(),
          SizedBox(height: 12.h),
          
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
      child: LocalizedText(
        AppLocalizations.of(context)!.meals,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
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
          LocalizedText(
            AppLocalizations.of(context)!.scanYourMeal,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF28A228),
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
                  LocalizedText(
                    AppLocalizations.of(context)!.tapToScanYourFood,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
          child: LocalizedText(
            AppLocalizations.of(context)!.yourMeals,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 12.h),
        DateSelector(
          dayNames: _dayNames,
          initialSelectedIndex: _selectedDateIndex,
          onDateSelected: _onDateSelected,
        ),
      ],
    );
  }

  Widget _buildMealsList() {
    return RefreshIndicator(
      onRefresh: _loadMealsForDay,
      color: const Color(0xFF28A228),
      backgroundColor: Colors.white,
      child: _buildMealsContent(),
    );
  }

  Widget _buildMealsContent() {
    if (_isLoading) {
      return Container(
        margin: EdgeInsets.only(top: 0.h, left: 16.w, right: 16.w),
        child: ListView.builder(
          itemCount: 3, // Show 3 shimmer cards
          itemBuilder: (context, index) {
            return _buildShimmerMealCard();
          },
        ),
      );
    }

    if (_error != null) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.fastfood_rounded,
                      color: const Color(0xFF28A228),
                      size: 60.w,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                LocalizedText(
                  AppLocalizations.of(context)!.noMealCategoriesFound,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: LocalizedText(
                    AppLocalizations.of(context)!.thereAreNoMealCategoriesAvailableForThisDayPleaseTryAnotherDay,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6C757D),
                    textAlign: TextAlign.center,
                  ),
                ),
               ],
            ),
          ),
        ),
      );
    }

    if (_mealsResponse?.data.isEmpty ?? true) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Center(
            child: LocalizedText(
              AppLocalizations.of(context)!.noMealsAvailableForThisDay,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6C757D),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: 0.h, left: 16.w, right: 16.w),
      child: ListView.builder(
        itemCount: _mealsResponse!.data.length,
        itemBuilder: (context, categoryIndex) {
          final category = _mealsResponse!.data[categoryIndex];
          
          // Get the currently selected meal index for this category
          final selectedIndex = _selectedMealIndices[category.enName] ?? 0;
          
          // Ensure the selected index is within bounds
          final safeIndex = selectedIndex < category.meals.length ? selectedIndex : 0;
          final selectedMeal = category.meals[safeIndex];
          
          return MealCard(
            mealType: category.getLocalizedName(context.isArabic ? 'ar' : 'en'),
            description: selectedMeal.getLocalizedDescription(context.isArabic ? 'ar' : 'en'),
            calories: selectedMeal.calories,
            imagePath: category.fullImageUrl,
            onSwap: () => _onMealSwap(category.enName),
          );
        },
      ),
    );
  }

  Widget _buildShimmerMealCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            // Meal image shimmer
            Container(
              width: 94.w,
              height: 108.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.r),
                  bottomLeft: Radius.circular(15.r),
                ),
              ),
            ),
            
            SizedBox(width: 16.w),
            
            // Meal details shimmer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meal type shimmer
                  Container(
                    width: 120.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Description shimmer
                  Container(
                    width: 200.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Calories shimmer
                  Row(
        children: [
                      Container(
                        width: 18.w,
                        height: 18.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        width: 60.w,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Swap icon shimmer
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}