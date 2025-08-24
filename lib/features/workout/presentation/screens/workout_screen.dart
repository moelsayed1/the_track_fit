import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import 'package:the_track_fit/core/utils/responsive_helper.dart';
import 'package:the_track_fit/core/constants/app_assets.dart';
import 'package:the_track_fit/features/workout/domain/models/exercise.dart';
import 'package:the_track_fit/features/workout/presentation/screens/select_type_screen.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? selectedFilter;
  List<Exercise> exercises = [];
  List<Exercise> filteredExercises = [];

  @override
  void initState() {
    super.initState();
    _initializeExercises();
  }

  void _initializeExercises() {
    exercises = [
      const Exercise(
        id: '1',
        title: 'Exercise Title',
        subtitle: '4 Sets x 8 reps',
        imagePath: AppAssets.exerciseImage,
        type: 'cardio',
      ),
      const Exercise(
        id: '2',
        title: 'Exercise Title',
        subtitle: '4 Sets x 8 reps',
        imagePath: AppAssets.exerciseImage,
        type: 'gym',
        isFavorite: true,
      ),
      const Exercise(
        id: '3',
        title: 'Exercise Title',
        subtitle: '4 Sets x 8 reps',
        imagePath: AppAssets.exerciseImage,
        type: 'equipment',
      ),
      const Exercise(
        id: '4',
        title: 'Exercise Title',
        subtitle: '4 Sets x 8 reps',
        imagePath: AppAssets.exerciseImage,
        type: 'cardio',
        isFavorite: true,
      ),
      const Exercise(
        id: '5',
        title: 'Exercise Title',
        subtitle: '4 Sets x 8 reps',
        imagePath: AppAssets.exerciseImage,
        type: 'gym',
      ),
      const Exercise(
        id: '6',
        title: 'Exercise Title',
        subtitle: '4 Sets x 8 reps',
        imagePath: AppAssets.exerciseImage,
        type: 'cardio',
      ),
      const Exercise(
        id: '7',
        title: 'Exercise Title',
        subtitle: '4 Sets x 8 reps',
        imagePath: AppAssets.exerciseImage,
        type: 'cardio',
      ),
    ];
    filteredExercises = exercises;
  }

  void _onFilterChanged(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter.isEmpty) {
        filteredExercises = exercises;
      } else {
        filteredExercises = exercises.where((exercise) => exercise.type == filter).toList();
      }
    });
  }

  void _onTypeSelected(String typeId) {
    if (selectedFilter == typeId) {
      // If tapping the same type, clear the filter
      _onFilterChanged('');
    } else {
      // Otherwise, apply the new filter
      _onFilterChanged(typeId);
    }
  }

  void _toggleFavorite(String exerciseId) {
    setState(() {
      final exerciseIndex = exercises.indexWhere((exercise) => exercise.id == exerciseId);
      if (exerciseIndex != -1) {
        exercises[exerciseIndex] = exercises[exerciseIndex].copyWith(
          isFavorite: !exercises[exerciseIndex].isFavorite,
        );
        if (selectedFilter != null) {
          filteredExercises = exercises.where((exercise) => exercise.type == selectedFilter).toList();
        } else {
          filteredExercises = exercises;
        }
      }
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
            color: Color(0xFFF6FFF6), // Background
          ),
          child: Column(
            children: [
              // App Bar
              SizedBox(
                width: double.infinity,
                height: responsiveHelper.h(2),
                child: Stack(
                  children: [
                    Positioned(
                      left: responsiveHelper.w(16),
                      top: responsiveHelper.h(14),
                      child: Container(
                        width: responsiveHelper.w(54),
                        height: responsiveHelper.h(21),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Title
              Center(
                child: Text(
                  'Workout',
                  style: TextStyle(
                    color: const Color(0xFF1E1E1E), // black
                    fontSize: responsiveHelper.sp(24),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              SizedBox(height: responsiveHelper.h(4)),
              
              // Search Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: responsiveHelper.w(16)),
                child: Container(
                  width: responsiveHelper.w(343),
                  padding: EdgeInsets.symmetric(
                    horizontal: responsiveHelper.w(16),
                    vertical: responsiveHelper.h(10),
                  ),
                  decoration: ShapeDecoration(
                    color: const Color(0x26848484), // Semi-transparent gray as per design
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: responsiveHelper.w(24),
                        height: responsiveHelper.h(24),
                        child: Icon(
                          Icons.search,
                          color: const Color(0xBF848484),
                          size: responsiveHelper.sp(20),
                        ),
                      ),
                      SizedBox(width: responsiveHelper.w(4)),
                      Expanded(
                        child: Text(
                          'Search exercies', // As per design
                          style: TextStyle(
                            color: const Color(0xBF848484),
                            fontSize: responsiveHelper.sp(12),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: responsiveHelper.h(16)),
              
              // Filter Chips
              Padding(
                padding: EdgeInsets.symmetric(horizontal: responsiveHelper.w(16)),
                child: SizedBox(
                  width: responsiveHelper.w(343),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _showTypeSelection,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: responsiveHelper.w(12),
                              vertical: responsiveHelper.h(8),
                            ),
                            decoration: ShapeDecoration(
                              color: selectedFilter != null 
                                  ? const Color(0xFFE8F5E8) // Light green when selected
                                  : const Color(0x26848484), // Semi-transparent gray when not selected
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: selectedFilter != null 
                                    ? const BorderSide(color: Color(0xFFD8F1D8), width: 1) // Green border when selected
                                    : BorderSide.none,
                              ),
                            ),
                                                        child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: responsiveHelper.w(16),
                                  height: responsiveHelper.h(16),
                                  child: SvgPicture.asset(
                                    AppIcons.typeIcon,
                                    width: responsiveHelper.w(16),
                                    height: responsiveHelper.h(16),
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xFF1E1E1E),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                SizedBox(width: responsiveHelper.w(6)),
                                Flexible(
                                  child: Text(
                                    selectedFilter ?? 'Type',
                                    style: TextStyle(
                                      color: const Color(0xFF1E1E1E), // black
                                      fontSize: responsiveHelper.sp(10),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 1.60,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (selectedFilter != null) ...[
                                  SizedBox(width: responsiveHelper.w(6)),
                                  GestureDetector(
                                    onTap: () => _onFilterChanged(''),
                                    child: Container(
                                      width: responsiveHelper.w(14),
                                      height: responsiveHelper.h(14),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF4CAF50),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: responsiveHelper.w(8)),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsiveHelper.w(12),
                            vertical: responsiveHelper.h(8),
                          ),
                          decoration: ShapeDecoration(
                            color: const Color(0x26848484), // Semi-transparent gray as per design
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: responsiveHelper.w(20),
                                height: responsiveHelper.h(20),
                                child: Image.asset(
                                  AppIcons.gymIcon,
                                  width: responsiveHelper.w(20),
                                  height: responsiveHelper.h(20),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(width: responsiveHelper.w(8)),
                              Text(
                                'Gym',
                                style: TextStyle(
                                  color: const Color(0xFF1E1E1E), // black
                                  fontSize: responsiveHelper.sp(10),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 1.60,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: responsiveHelper.w(8)),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsiveHelper.w(12),
                            vertical: responsiveHelper.h(8),
                          ),
                          decoration: ShapeDecoration(
                            color: const Color(0x26848484), // Semi-transparent gray as per design
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: responsiveHelper.w(20),
                                height: responsiveHelper.h(20),
                                child: SvgPicture.asset(
                                  AppIcons.equipmentIcon,
                                  width: responsiveHelper.w(20),
                                  height: responsiveHelper.h(20),
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF1E1E1E),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              SizedBox(width: responsiveHelper.w(8)),
                              Text(
                                'Equipment',
                                style: TextStyle(
                                  color: const Color(0xFF1E1E1E), // black
                                  fontSize: responsiveHelper.sp(10),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 1.60,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: responsiveHelper.h(12)),
              
              // Section Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: responsiveHelper.w(16)),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: responsiveHelper.w(20),
                      height: responsiveHelper.h(20),
                      child:SvgPicture.asset(
                        AppIcons.justifyAlignLeftIcon,
                        width: responsiveHelper.w(20),
                        height: responsiveHelper.h(20),
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF1E1E1E),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    SizedBox(width: responsiveHelper.w(6)),
                    Text(
                      'All exercise',
                      style: TextStyle(
                        color: const Color(0xFF1E1E1E), // black
                        fontSize: responsiveHelper.sp(14),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 1.14,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: responsiveHelper.h(16)),
              
              // Exercise List
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsiveHelper.w(16)),
                  child: SizedBox(
                    width: responsiveHelper.w(343),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ...filteredExercises.asMap().entries.map((entry) {
                            final index = entry.key;
                            final exercise = entry.value;
                            return Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(responsiveHelper.w(8)),
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  width: 1,
                                                  color: const Color(0x26848484),
                                                ),
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: responsiveHelper.w(48),
                                                  height: responsiveHelper.h(48),
                                                  decoration: ShapeDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(exercise.imagePath),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: responsiveHelper.w(16)),
                                          SizedBox(
                                            width: responsiveHelper.w(115),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: responsiveHelper.w(115),
                                                  child: Text(
                                                    exercise.title,
                                                    style: TextStyle(
                                                      color: const Color(0xFF1E1E1E), // black
                                                      fontSize: responsiveHelper.sp(16),
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: responsiveHelper.h(4)),
                                                SizedBox(
                                                  width: responsiveHelper.w(115),
                                                  child: Text(
                                                    exercise.subtitle,
                                                    style: TextStyle(
                                                      color: const Color(0xFF848484), // gray
                                                      fontSize: responsiveHelper.sp(14),
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: responsiveHelper.w(24),
                                        height: responsiveHelper.h(24),
                                        child: GestureDetector(
                                          onTap: () => _toggleFavorite(exercise.id),
                                          child: Icon(
                                            exercise.isFavorite ? Icons.favorite : Icons.favorite_border,
                                            color: exercise.isFavorite ? AppColors.primaryGreen : const Color(0xFF848484),
                                            size: responsiveHelper.sp(24),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: responsiveHelper.h(16)),
                                if (index < filteredExercises.length - 1)
                                  Container(
                                    width: double.infinity,
                                    height: responsiveHelper.h(1),
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1,
                                          strokeAlign: BorderSide.strokeAlignCenter,
                                          color: const Color(0x26848484),
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(height: responsiveHelper.h(16)),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTypeSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectTypeScreen(
          selectedType: selectedFilter,
          onTypeSelected: _onTypeSelected,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}