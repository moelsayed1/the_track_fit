import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_track_fit/core/utils/responsive_helper.dart';
import 'package:the_track_fit/features/workout/domain/models/workout_type.dart';
import 'package:the_track_fit/features/workout/data/cubit/exercise_cubit.dart';
import 'package:the_track_fit/features/workout/presentation/widgets/shimmer_loader.dart';

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
      
      final categories = await context.read<ExerciseCubit>().getExerciseCategories();
      
      setState(() {
        workoutTypes = categories.map((category) {
          return category.copyWith(isSelected: selectedTypeId == category.id);
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
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
        name: 'Cardio',
        iconPath: 'assets/images/cardio.png',
        isSelected: selectedTypeId == 'cardio',
      ),
      WorkoutType(
        id: 'dumbbell',
        name: 'dumbbell',
        iconPath: 'assets/images/gym_icon.png',
        isSelected: selectedTypeId == 'dumbbell',
      ),
      WorkoutType(
        id: 'stretching',
        name: 'Stretching',
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
      backgroundColor: const Color(0xFFF6FFF6),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFF6FFF6),
          ),
          child: Column(
            children: [
              // Header with back button and title
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: responsiveHelper.w(16),
                  vertical: responsiveHelper.h(8),
                ),
                decoration: const BoxDecoration(
                  color: Color(0x26848484),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset(
                        'assets/logos/arrow_left.svg',
                        width: responsiveHelper.w(24),
                        height: responsiveHelper.h(24),
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF1E1E1E),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    SizedBox(width: responsiveHelper.w(8)),
                    Text(
                      'Select Type',
                      style: TextStyle(
                        color: const Color(0xFF1E1E1E),
                        fontSize: responsiveHelper.sp(18),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0.89,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: responsiveHelper.h(16)),
              
              // Type options list
              Expanded(
                child: _buildContent(responsiveHelper),
              ),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadWorkoutTypes,
              child: const Text('Retry'),
            ),
          ],
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
                  ? const Color(0xFFD8F1D8) // Light green background when selected
                  : Colors.white, // White background when not selected
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildCategoryIcon(type, responsiveHelper),
                SizedBox(width: responsiveHelper.w(8)),
                Expanded(
                  child: Text(
                    type.name,
                    style: TextStyle(
                      color: type.isSelected 
                          ? const Color(0xFF4CAF50) // Green text when selected
                          : const Color(0xFF1E1E1E), // Black text when not selected
                      fontSize: responsiveHelper.sp(16),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                    ),
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

  Widget _buildCategoryIcon(WorkoutType type, ResponsiveHelper responsiveHelper) {
    if (type.iconPath.startsWith('http')) {
      // Network image with shimmer loading
      return Container(
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
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
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
