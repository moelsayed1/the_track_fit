import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import 'package:the_track_fit/core/utils/responsive_helper.dart';
import 'package:the_track_fit/features/workout/domain/models/workout_type.dart';
import 'package:the_track_fit/features/workout/data/cubit/exercise_cubit.dart';
import 'package:the_track_fit/features/workout/presentation/widgets/shimmer_loader.dart';
import '../../../../core/widgets/localized_text.dart';
import '../../../../core/extensions/localization_extensions.dart';
import '../../../../generated/l10n/app_localizations.dart';

class SelectTypeScreen extends StatefulWidget {
  final String? selectedType;
  final Function(String, String) onTypeSelected;

  const SelectTypeScreen({
    super.key,
    this.selectedType,
    required this.onTypeSelected,
  });

  @override
  State<SelectTypeScreen> createState() => _SelectTypeScreenState();
}

class _SelectTypeScreenState extends State<SelectTypeScreen> {
  late List<WorkoutType> workoutTypes;
  String? selectedTypeId;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    selectedTypeId = widget.selectedType;
    _loadWorkoutTypes();
  }

  Future<void> _loadWorkoutTypes() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final categories = await context
          .read<ExerciseCubit>()
          .getExerciseCategories();

      setState(() {
        workoutTypes = categories.map((category) {
          return category.copyWith(isSelected: selectedTypeId == category.id);
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      log('Error loading workout types: $e'); // Debug logging
      setState(() {
        // Provide user-friendly error message instead of technical exception
        error = 'Connection error';
        isLoading = false;
        // Fallback to mock data
        _initializeMockWorkoutTypes();
      });
    }
  }

  void _initializeMockWorkoutTypes() {
    workoutTypes = [
      WorkoutType(
        id: 'cardio',
        enName: 'Cardio',
        arName: 'كارديو',
        iconPath: 'assets/images/cardio.png',
        isSelected: selectedTypeId == 'cardio',
      ),
      WorkoutType(
        id: 'dumbbell',
        enName: 'Dumbbell',
        arName: 'دمبل',
        iconPath: 'assets/images/gym_icon.png',
        isSelected: selectedTypeId == 'dumbbell',
      ),
      WorkoutType(
        id: 'stretching',
        enName: 'Stretching',
        arName: 'تمارين الإطالة',
        iconPath: 'assets/images/streching.png',
        isSelected: selectedTypeId == 'stretching',
      ),
    ];
  }

  void _onTypeSelected(String typeId) {
    setState(() {
      selectedTypeId = typeId;
      workoutTypes = workoutTypes.map((type) {
        return type.copyWith(isSelected: type.id == typeId);
      }).toList();
    });

    // Find the selected type to get its name
    final selectedType = workoutTypes.firstWhere(
      (type) => type.id == typeId,
      orElse: () => workoutTypes.first,
    );

    // Add a small delay to show the selection change
    Future.delayed(const Duration(milliseconds: 300), () {
      widget.onTypeSelected(typeId, selectedType.name);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsiveHelper = ResponsiveHelper(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(color: AppColors.background),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header with back button and title
              Builder(
                builder: (context) {
                  final isArabic =
                      Localizations.localeOf(context).languageCode == 'ar';
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: responsiveHelper.w(16),
                      vertical: responsiveHelper.h(8),
                    ),
                    decoration: const BoxDecoration(color: Color(0x26848484)),
                    child: Row(
                      mainAxisAlignment: isArabic
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (!isArabic) ...[
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: SvgPicture.asset(
                              'assets/logos/arrow_left.svg',
                              width: responsiveHelper.w(24),
                              height: responsiveHelper.h(24),
                              colorFilter: const ColorFilter.mode(
                                AppColors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          SizedBox(width: responsiveHelper.w(8)),
                          LocalizedText(
                            AppLocalizations.of(context)!.selectType,
                            fontSize: responsiveHelper.sp(18),
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                            height: 0.89,
                          ),
                        ],
                        if (isArabic) ...[
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(3.1415926535897932),
                              child: SvgPicture.asset(
                                'assets/logos/arrow_left.svg',
                                width: responsiveHelper.w(24),
                                height: responsiveHelper.h(24),
                                colorFilter: const ColorFilter.mode(
                                  AppColors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: responsiveHelper.w(8)),
                          LocalizedText(
                            AppLocalizations.of(context)!.selectType,
                            fontSize: responsiveHelper.sp(18),
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                            height: 0.89,
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),

              SizedBox(height: responsiveHelper.h(16)),

              // Type options list
              Expanded(child: _buildContent(responsiveHelper)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ResponsiveHelper responsiveHelper) {
    if (isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: responsiveHelper.w(4)),
        child: Column(
          children: [
            // Show shimmer loaders for each category item
            for (int i = 0; i < 3; i++) ...[
              _buildShimmerItem(responsiveHelper),
              if (i < 2) _buildShimmerDivider(responsiveHelper),
            ],
          ],
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsiveHelper.w(32)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error icon with better styling
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 40,
                  color: Colors.red[400],
                ),
              ),
              SizedBox(height: responsiveHelper.h(24)),

              // Main error title
              LocalizedText(
                AppLocalizations.of(context)!.somethingWentWrong,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.red[700]!,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: responsiveHelper.h(8)),

              // User-friendly error message
              LocalizedText(
                AppLocalizations.of(context)!.unableToLoadWorkoutTypes,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600]!,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: responsiveHelper.h(4)),

              // Additional helpful message
              LocalizedText(
                AppLocalizations.of(context)!.pleaseCheckYourConnection,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey[500]!,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: responsiveHelper.h(32)),

              // Enhanced retry button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loadWorkoutTypes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF28A228),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shadowColor: const Color(0xFF28A228).withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: LocalizedText(
                    AppLocalizations.of(context)!.retry,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsiveHelper.w(4)),
      child: Column(
        children: [
          ...workoutTypes.map((type) => _buildTypeItem(type, responsiveHelper)),
        ],
      ),
    );
  }

  Widget _buildTypeItem(WorkoutType type, ResponsiveHelper responsiveHelper) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _onTypeSelected(type.id),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(responsiveHelper.w(16)),
            decoration: BoxDecoration(
              color: type.isSelected
                  ? const Color(
                      0xFFD8F1D8,
                    ) // Light green background when selected
                  : AppColors
                        .surface, // Dark surface background when not selected
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildCategoryIcon(type, responsiveHelper),
                SizedBox(width: responsiveHelper.w(8)),
                Expanded(
                  child: LocalizedText(
                    type.getLocalizedName(context.isArabic ? 'ar' : 'en'),
                    fontSize: responsiveHelper.sp(16),
                    fontWeight: FontWeight.w500,
                    color: type.isSelected
                        ? const Color(0xFF4CAF50) // Green text when selected
                        : const Color(
                            0xFF1E1E1E,
                          ), // Black text when not selected
                    height: 1.0,
                  ),
                ),
                // Checkmark icon when selected
                if (type.isSelected)
                  Icon(
                    Icons.check_circle,
                    color: const Color(0xFF4CAF50), // Green checkmark
                    size: responsiveHelper.sp(24),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Divider(
            color: const Color(0x26848484),
            height: responsiveHelper.h(1),
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryIcon(
    WorkoutType type,
    ResponsiveHelper responsiveHelper,
  ) {
    if (type.iconPath.startsWith('http')) {
      // Network image with shimmer loading
      return SizedBox(
        width: responsiveHelper.w(32),
        height: responsiveHelper.h(32),
        child: Image.network(
          type.iconPath,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              // Image loaded successfully
              return ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: ColorFiltered(
                  colorFilter: type.isSelected
                      ? const ColorFilter.mode(
                          Color(0xFF4CAF50), // Green color when selected
                          BlendMode.srcIn,
                        )
                      : const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.multiply,
                        ),
                  child: child,
                ),
              );
            }
            // Show shimmer while loading
            return ShimmerLoader(
              width: responsiveHelper.w(32),
              height: responsiveHelper.h(32),
              borderRadius: 8.0,
            );
          },
          errorBuilder: (context, error, stackTrace) {
            // Fallback to default icon if network image fails
            return Container(
              width: responsiveHelper.w(32),
              height: responsiveHelper.h(32),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(
                Icons.fitness_center,
                size: responsiveHelper.sp(20),
                color: const Color(0xFF28A228),
              ),
            );
          },
        ),
      );
    } else {
      // Asset image
      return Container(
        width: responsiveHelper.w(32),
        height: responsiveHelper.h(32),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(type.iconPath),
            fit: BoxFit.cover,
            colorFilter: type.isSelected
                ? const ColorFilter.mode(
                    Color(0xFF4CAF50), // Green color when selected
                    BlendMode.srcIn,
                  )
                : null, // No color filter when not selected
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
      );
    }
  }

  Widget _buildShimmerItem(ResponsiveHelper responsiveHelper) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(responsiveHelper.w(16)),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          // Icon shimmer
          ShimmerLoader(
            width: responsiveHelper.w(32),
            height: responsiveHelper.h(32),
            borderRadius: 8.0,
          ),
          SizedBox(width: responsiveHelper.w(8)),
          // Text shimmer
          Expanded(
            child: ShimmerLoader(
              width: double.infinity,
              height: responsiveHelper.h(16),
              borderRadius: 4.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerDivider(ResponsiveHelper responsiveHelper) {
    return SizedBox(
      width: double.infinity,
      child: Divider(
        color: const Color(0x26848484),
        height: responsiveHelper.h(1),
        thickness: 1,
        indent: 0,
        endIndent: 0,
      ),
    );
  }
}
