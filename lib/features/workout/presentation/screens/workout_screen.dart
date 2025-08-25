import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import 'package:the_track_fit/core/utils/responsive_helper.dart';
import 'package:the_track_fit/core/constants/app_assets.dart';
import 'package:the_track_fit/features/workout/domain/models/exercise.dart';
import 'package:the_track_fit/features/workout/presentation/screens/select_type_screen.dart';
import 'package:the_track_fit/features/workout/presentation/screens/select_location_screen.dart';
import 'package:the_track_fit/features/workout/presentation/screens/select_equipment_screen.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String? selectedFilter; // Type filter
  String? selectedLocation; // Gym filter
  String? selectedEquipment; // Equipment filter
  List<Exercise> exercises = [];
  List<Exercise> filteredExercises = [];

  @override
  void initState() {
    super.initState();
    _initializeExercises();
    
    // Add listener to focus node to trigger rebuild when focus changes
    _searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  void _initializeExercises() {
    exercises = [
      const Exercise(
        id: '1',
        title: 'Push-ups',
        subtitle: '4 Sets x 12 reps',
        imagePath: AppAssets.exerciseImage,
        type: 'cardio',
      ),
      const Exercise(
        id: '2',
        title: 'Bench Press',
        subtitle: '4 Sets x 8 reps',
        imagePath: AppAssets.exerciseImage,
        type: 'gym',
        isFavorite: true,
      ),
      const Exercise(
        id: '3',
        title: 'Squats',
        subtitle: '3 Sets x 15 reps',
        imagePath: AppAssets.exerciseImage,
        type: 'equipment',
      ),
      const Exercise(
        id: '4',
        title: 'Running',
        subtitle: '30 minutes cardio',
        imagePath: AppAssets.exerciseImage,
        type: 'cardio',
        isFavorite: true,
      ),
      const Exercise(
        id: '5',
        title: 'Deadlift',
        subtitle: '4 Sets x 6 reps',
        imagePath: AppAssets.exerciseImage,
        type: 'gym',
      ),
      const Exercise(
        id: '6',
        title: 'Jumping Jacks',
        subtitle: '3 Sets x 20 reps',
        imagePath: AppAssets.exerciseImage,
        type: 'cardio',
      ),
      const Exercise(
        id: '7',
        title: 'Yoga Stretches',
        subtitle: '15 minutes flexibility',
        imagePath: AppAssets.exerciseImage,
        type: 'stretching',
      ),
      const Exercise(
        id: '8',
        title: 'Pull-ups',
        subtitle: '3 Sets x 10 reps',
        imagePath: AppAssets.exerciseImage,
        type: 'gym',
      ),
      const Exercise(
        id: '9',
        title: 'Plank',
        subtitle: '3 Sets x 1 minute',
        imagePath: AppAssets.exerciseImage,
        type: 'cardio',
      ),
      const Exercise(
        id: '10',
        title: 'Lunges',
        subtitle: '3 Sets x 12 reps each leg',
        imagePath: AppAssets.exerciseImage,
        type: 'equipment',
      ),
    ];
    filteredExercises = exercises;
  }

  void _onFilterChanged(String filter) {
    setState(() {
      selectedFilter = filter;
      _applyFilters();
    });
  }

  void _onLocationChanged(String location) {
    setState(() {
      selectedLocation = location;
      _applyFilters();
    });
  }

  void _onEquipmentChanged(String equipment) {
    setState(() {
      selectedEquipment = equipment;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Exercise> filtered = exercises;
    
    // Apply type filter
    if (selectedFilter != null && selectedFilter!.isNotEmpty) {
      filtered = filtered.where((exercise) => exercise.type == selectedFilter).toList();
    }
    
    // Apply location filter (gym/home)
    if (selectedLocation != null && selectedLocation!.isNotEmpty) {
      // For now, we'll filter by a location property if it exists
      // You can modify this logic based on your exercise model
      if (selectedLocation == 'gym') {
        // Filter exercises that require gym equipment
        filtered = filtered.where((exercise) => exercise.type == 'gym').toList();
      } else if (selectedLocation == 'home') {
        // Filter exercises that can be done at home
        filtered = filtered.where((exercise) => exercise.type != 'gym').toList();
      }
    }
    
    // Apply equipment filter
    if (selectedEquipment != null && selectedEquipment!.isNotEmpty) {
      if (selectedEquipment == 'no_equipment') {
        // Filter exercises that don't require equipment
        filtered = filtered.where((exercise) => exercise.type == 'cardio' || exercise.type == 'stretching').toList();
      } else if (selectedEquipment == 'mat_only') {
        // Filter exercises that only need a mat
        filtered = filtered.where((exercise) => exercise.type == 'stretching').toList();
      } else if (selectedEquipment == 'machines') {
        // Filter exercises that require gym machines
        filtered = filtered.where((exercise) => exercise.type == 'gym').toList();
      }
    }
    
    // Apply search filter if there's a search query
    if (_searchController.text.isNotEmpty) {
      final searchLower = _searchController.text.toLowerCase();
      filtered = filtered.where((exercise) {
        return exercise.title.toLowerCase().contains(searchLower) ||
               exercise.subtitle.toLowerCase().contains(searchLower) ||
               exercise.type.toLowerCase().contains(searchLower);
      }).toList();
    }
    
    setState(() {
      filteredExercises = filtered;
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
        _applyFilters(); // Reapply all filters
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
                    color: _searchFocusNode.hasFocus 
                        ? const Color(0xFFE8F5E8) // Light green when focused
                        : const Color(0x26848484), // Semi-transparent gray when not focused
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: _searchFocusNode.hasFocus
                          ? const BorderSide(color: Color(0xFF4CAF50), width: 1) // Green border when focused
                          : BorderSide.none,
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
                          color: _searchFocusNode.hasFocus 
                              ? const Color(0xFF4CAF50) // Green when focused
                              : const Color(0xBF848484), // Gray when not focused
                          size: responsiveHelper.sp(20),
                        ),
                      ),
                      SizedBox(width: responsiveHelper.w(4)),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          onChanged: _onSearchChanged,
                          onSubmitted: (value) {
                            // Handle search submission (e.g., hide keyboard)
                            _searchFocusNode.unfocus();
                          },
                          style: TextStyle(
                            color: const Color(0xFF1E1E1E),
                            fontSize: responsiveHelper.sp(12),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search exercises',
                            hintStyle: TextStyle(
                              color: const Color(0xBF848484),
                              fontSize: responsiveHelper.sp(12),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 1.33,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      // Clear search button
                      if (_searchController.text.isNotEmpty)
                        GestureDetector(
                          onTap: _clearSearch,
                          child: Icon(
                            Icons.close,
                            color: const Color(0xBF848484),
                            size: responsiveHelper.sp(16),
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
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsiveHelper.w(16),
            vertical: responsiveHelper.h(10),
          ),
          decoration: ShapeDecoration(
            color: selectedFilter != null
                ? const Color(0xFFD8F1D8) // أخضر فاتح لما يتحدد
                : const Color(0x26848484), // رمادي شفاف لما مش متحدد
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: selectedFilter != null
                  ? const BorderSide(
                      color: Color(0xFF4CAF50), // أخضر غامق للبوردر
                      width: 1,
                    )
                  : BorderSide.none,
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selectedFilter == null) ...[
                SvgPicture.asset(
                  AppIcons.typeIcon,
                  width: responsiveHelper.w(16),
                  height: responsiveHelper.h(16),
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF1E1E1E),
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: responsiveHelper.w(6)),
              ],
              Flexible(
                child: Text(
                  selectedFilter ?? 'Type',
                  style: TextStyle(
                    color: const Color(0xFF1E1E1E),
                    fontSize: responsiveHelper.sp(12),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // الـ X icon تبقى برا الزرار
        if (selectedFilter != null)
          Positioned(
            right: -6,
            top: -6,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedFilter = null;
                  _applyFilters();
                });
              },
              child: Container(
                width: responsiveHelper.w(20),
                height: responsiveHelper.h(20),
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
      ],
    ),
  ),
),

                      SizedBox(width: responsiveHelper.w(8)),
                      Expanded(
                        child: GestureDetector(
                          onTap: _showLocationSelection,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: responsiveHelper.w(16),
                                  vertical: responsiveHelper.h(10),
                                ),
                                decoration: ShapeDecoration(
                                  color: selectedLocation != null
                                      ? const Color(0xFFD8F1D8) // Light green when selected
                                      : const Color(0x26848484), // Semi-transparent gray when not selected
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: selectedLocation != null
                                        ? const BorderSide(
                                            color: Color(0xFF4CAF50), // Green border when selected
                                            width: 1,
                                          )
                                        : BorderSide.none,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
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
                                    Flexible(
                                      child: Text(
                                        selectedLocation == 'gym' ? 'At Gym' : selectedLocation == 'home' ? 'At Home' : 'Gym',
                                        style: TextStyle(
                                          color: const Color(0xFF1E1E1E), // black
                                          fontSize: responsiveHelper.sp(12),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          height: 1.60,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Clear button for location filter
                              if (selectedLocation != null)
                                Positioned(
                                  right: -6,
                                  top: -6,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedLocation = null;
                                        _applyFilters();
                                      });
                                    },
                                    child: Container(
                                      width: responsiveHelper.w(20),
                                      height: responsiveHelper.h(20),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primaryGreen,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: responsiveHelper.w(8)),
                      Expanded(
                        child: GestureDetector(
                          onTap: _showEquipmentSelection,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: responsiveHelper.w(16),
                                  vertical: responsiveHelper.h(10),
                                ),
                                decoration: ShapeDecoration(
                                  color: selectedEquipment != null
                                      ? const Color(0xFFD8F1D8) // Light green when selected
                                      : const Color(0x26848484), // Semi-transparent gray when not selected
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: selectedEquipment != null
                                        ? const BorderSide(
                                            color: Color(0xFF4CAF50), // Green border when selected
                                            width: 1,
                                          )
                                        : BorderSide.none,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: responsiveHelper.w(20),
                                      height: responsiveHelper.h(20),
                                      child: SvgPicture.asset(
                                        AppIcons.equipmentIcon,
                                        width: responsiveHelper.w(20),
                                        height: responsiveHelper.w(20),
                                        colorFilter: const ColorFilter.mode(
                                          Color(0xFF1E1E1E),
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: responsiveHelper.w(8)),
                                    Flexible(
                                      child: Text(
                                        selectedEquipment == 'no_equipment' ? 'No Equipment' : 
                                        selectedEquipment == 'mat_only' ? 'Mat Only' : 
                                        selectedEquipment == 'machines' ? 'Machines' : 'Equipment',
                                        style: TextStyle(
                                          color: const Color(0xFF1E1E1E), // black
                                          fontSize: responsiveHelper.sp(12),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          height: 1.60,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Clear button for equipment filter
                              if (selectedEquipment != null)
                                Positioned(
                                  right: -6,
                                  top: -6,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedEquipment = null;
                                        _applyFilters();
                                      });
                                    },
                                    child: Container(
                                      width: responsiveHelper.w(20),
                                      height: responsiveHelper.h(20),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primaryGreen,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
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
                          if (filteredExercises.isEmpty)
                            // No results found message
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: responsiveHelper.h(40),
                                horizontal: responsiveHelper.w(20),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: responsiveHelper.sp(48),
                                    color: const Color(0xBF848484),
                                  ),
                                  SizedBox(height: responsiveHelper.h(16)),
                                  Text(
                                    'No exercises found',
                                    style: TextStyle(
                                      color: const Color(0xFF1E1E1E),
                                      fontSize: responsiveHelper.sp(16),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: responsiveHelper.h(8)),
                                  Text(
                                    'Try adjusting your search or filters',
                                    style: TextStyle(
                                      color: const Color(0xBF848484),
                                      fontSize: responsiveHelper.sp(12),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          else
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

  void _showLocationSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectLocationScreen(
          selectedLocation: selectedLocation,
          onLocationSelected: _onLocationChanged,
        ),
      ),
    );
  }

  void _showEquipmentSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectEquipmentScreen(
          selectedEquipment: selectedEquipment,
          onEquipmentSelected: _onEquipmentChanged,
        ),
      ),
    );
  }

  void _onSearchChanged(String query) {
    // Always use _applyFilters to maintain consistency with other filters
    _applyFilters();
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _applyFilters(); // Reset to show all exercises with current filters
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}