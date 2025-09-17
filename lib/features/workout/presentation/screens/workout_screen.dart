import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import 'package:the_track_fit/core/utils/responsive_helper.dart';
import 'package:the_track_fit/core/constants/app_assets.dart';
import 'package:the_track_fit/core/widgets/shimmer_loading.dart';
import 'package:the_track_fit/features/workout/presentation/screens/select_type_screen.dart';
import 'package:the_track_fit/features/workout/presentation/screens/select_location_screen.dart';
import 'package:the_track_fit/features/workout/presentation/screens/select_equipment_screen.dart';
import 'package:the_track_fit/features/workout/data/cubit/exercise_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  void initState() {
    super.initState();
    // Load exercises from API
    context.read<ExerciseCubit>().loadAllExercises();

    // Add listener to focus node to trigger rebuild when focus changes
    _searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      selectedFilter = filter;
    });
    
    if (filter.isNotEmpty) {
      context.read<ExerciseCubit>().filterByType(filter);
    } else {
      context.read<ExerciseCubit>().loadAllExercises();
    }
  }

  void _onLocationChanged(String location) {
    setState(() {
      selectedLocation = location;
    });
    
    if (location.isNotEmpty) {
      context.read<ExerciseCubit>().filterByLocation(location);
    } else {
      context.read<ExerciseCubit>().loadAllExercises();
    }
  }

  void _onEquipmentChanged(String equipment) {
    setState(() {
      selectedEquipment = equipment;
    });
    
    if (equipment.isNotEmpty) {
      context.read<ExerciseCubit>().filterByEquipment(equipment);
    } else {
      context.read<ExerciseCubit>().loadAllExercises();
    }
  }

  void _onTypeSelected(String typeId, String typeName) {
    if (selectedFilter == typeId) {
      // If tapping the same type, clear the filter
      _onFilterChanged('');
    } else {
      // Otherwise, apply the new filter
      _onFilterChanged(typeId);
      // Filter exercises by category
      context.read<ExerciseCubit>().filterByCategory(typeId, typeName);
    }
  }

  Future<void> _toggleFavorite(String exerciseId) async {
    final exerciseCubit = context.read<ExerciseCubit>();
    final exercise = exerciseCubit.allExercises.firstWhere(
      (e) => e.id == exerciseId,
      orElse: () => throw Exception('Exercise not found'),
    );
    await exerciseCubit.toggleFavourite(exercise);
  }

  @override
  Widget build(BuildContext context) {
    final responsiveHelper = ResponsiveHelper(context);

    return Scaffold(
      
      backgroundColor: const Color(0xFFF6FFF6),
      body: BlocBuilder<ExerciseCubit, ExerciseState>(
        builder: (context, state) {
          if (state.isLoading) {
            return _buildShimmerLoading();
          }

          if (state.error != null) {
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
                    'Error loading exercises',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ExerciseCubit>().loadAllExercises(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              Container(
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
              height: responsiveHelper.h(12), // Add explicit height
              child: Stack(
                children: [
                  Positioned(
                    left: responsiveHelper.w(16),
                    top: responsiveHelper.h(10),
                    child: Container(
                      width: responsiveHelper.w(54),
                      height: responsiveHelper.h(10),
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
      
            SizedBox(height: responsiveHelper.h(8)),
      
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsiveHelper.w(16),
              ),
              child: Container(
                width: responsiveHelper.w(343),
                padding: EdgeInsets.symmetric(
                  horizontal: responsiveHelper.w(16),
                  vertical: responsiveHelper.h(10),
                ),
                decoration: ShapeDecoration(
                  color: _searchFocusNode.hasFocus
                      ? const Color(0xFFE8F5E8) // Light green when focused
                      : const Color(
                          0x26848484,
                        ), // Semi-transparent gray when not focused
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: _searchFocusNode.hasFocus
                        ? const BorderSide(
                            color: Color(0xFF4CAF50),
                            width: 1,
                          ) // Green border when focused
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
                            : const Color(
                                0xBF848484,
                              ), // Gray when not focused
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
              padding: EdgeInsets.symmetric(
                horizontal: responsiveHelper.w(16),
              ),
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
                                    ? const Color(
                                        0xFFD8F1D8,
                                      ) // أخضر فاتح لما يتحدد
                                    : const Color(
                                        0x26848484,
                                      ), // رمادي شفاف لما مش متحدد
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: selectedFilter != null
                                      ? const BorderSide(
                                          color: Color(
                                            0xFF4CAF50,
                                          ), // أخضر غامق للبوردر
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
                                      state.selectedCategoryName ?? 'Type',
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
                                    // Clear local state first
                                    setState(() {
                                      selectedFilter = null;
                                    });
                                    // Clear cubit state
                                    context.read<ExerciseCubit>().clearCategoryFilter();
                                    context.read<ExerciseCubit>().loadAllExercises();
                                    // Focus on search field
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      _searchFocusNode.requestFocus();
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
                                    ? const Color(
                                        0xFFD8F1D8,
                                      ) // Light green when selected
                                    : const Color(
                                        0x26848484,
                                      ), // Semi-transparent gray when not selected
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: selectedLocation != null
                                      ? const BorderSide(
                                          color: Color(
                                            0xFF4CAF50,
                                          ), // Green border when selected
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
                                      selectedLocation == 'gym'
                                          ? 'At Gym'
                                          : selectedLocation == 'home'
                                          ? 'At Home'
                                          : 'Gym',
                                      style: TextStyle(
                                        color: const Color(
                                          0xFF1E1E1E,
                                        ), // black
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
                                    });
                                    context.read<ExerciseCubit>().loadAllExercises();
                                    // Focus on search field when clearing filter
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      _searchFocusNode.requestFocus();
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
                                    ? const Color(
                                        0xFFD8F1D8,
                                      ) // Light green when selected
                                    : const Color(
                                        0x26848484,
                                      ), // Semi-transparent gray when not selected
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: selectedEquipment != null
                                      ? const BorderSide(
                                          color: Color(
                                            0xFF4CAF50,
                                          ), // Green border when selected
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
                                      selectedEquipment == 'no_equipment'
                                          ? 'No Equipment'
                                          : selectedEquipment == 'mat_only'
                                          ? 'Mat Only'
                                          : selectedEquipment == 'machines'
                                          ? 'Machines'
                                          : 'Equipment',
                                      style: TextStyle(
                                        color: const Color(
                                          0xFF1E1E1E,
                                        ), // black
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
                                    });
                                    context.read<ExerciseCubit>().loadAllExercises();
                                    // Focus on search field when clearing filter
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      _searchFocusNode.requestFocus();
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
              padding: EdgeInsets.symmetric(
                horizontal: responsiveHelper.w(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: responsiveHelper.w(20),
                    height: responsiveHelper.h(20),
                    child: SvgPicture.asset(
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
              child: RefreshIndicator(
                onRefresh: () async {
                  // Reload all exercises when user pulls to refresh
                  context.read<ExerciseCubit>().loadAllExercises();
                },
                color: const Color(0xFF28A228), // App green color
                backgroundColor: const Color(0xFFE0E0E0), // Light gray background
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsiveHelper.w(16),
                  ),
                  child: SizedBox(
                    width: responsiveHelper.w(343),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        if (state.allExercises.isEmpty)
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
                          ...state.allExercises.asMap().entries.map((entry) {
                            final index = entry.key;
                            final exercise = entry.value;
                            return GestureDetector(
                              onTap: () {
                                context.push(
                                  AppRouter.exerciseDetail,
                                  extra: exercise,
                                );
                              },
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(
                                                responsiveHelper.w(8),
                                              ),
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    width: 1,
                                                    color: const Color(
                                                      0x26848484,
                                                    ),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        15,
                                                      ),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: responsiveHelper.w(
                                                      48,
                                                    ),
                                                    height: responsiveHelper
                                                        .h(48),
                                                    decoration: ShapeDecoration(
                                                      image: DecorationImage(
                                                        image: exercise.imagePath.startsWith('http')
                                                            ? NetworkImage(exercise.imagePath)
                                                            : AssetImage(exercise.imagePath) as ImageProvider,
                                                        fit: BoxFit.cover,
                                                        onError: (exception, stackTrace) {
                                                          // Fallback to default image if network image fails
                                                        },
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: responsiveHelper.w(16),
                                            ),
                                            SizedBox(
                                              width: responsiveHelper.w(115),
                                              child: Column(
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: responsiveHelper.w(
                                                      115,
                                                    ),
                                                    child: Text(
                                                      exercise.title,
                                                      style: TextStyle(
                                                        color: const Color(
                                                          0xFF1E1E1E,
                                                        ), // black
                                                        fontSize:
                                                            responsiveHelper
                                                                .sp(16),
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: responsiveHelper
                                                        .h(4),
                                                  ),
                                                  SizedBox(
                                                    width: responsiveHelper.w(
                                                      115,
                                                    ),
                                                    child: Text(
                                                      '4 Sets x 8 reps', // Static subtitle for workout screen
                                                      style: TextStyle(
                                                        color: const Color(
                                                          0xFF848484,
                                                        ), // gray
                                                        fontSize:
                                                            responsiveHelper
                                                                .sp(14),
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w400,
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
                                              onTap: () =>
                                                  _toggleFavorite(exercise.id),
                                              child: Icon(
                                                context.read<ExerciseCubit>().isFavourite(exercise.id)
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: context.read<ExerciseCubit>().isFavourite(exercise.id)
                                                    ? AppColors.primaryGreen
                                                    : const Color(0xFF848484),
                                                size: responsiveHelper.sp(24),
                                              ),
                                            ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: responsiveHelper.h(16)),
                                  if (index < state.allExercises.length - 1)
                                    Container(
                                      width: double.infinity,
                                      height: responsiveHelper.h(1),
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 1,
                                            strokeAlign:
                                                BorderSide.strokeAlignCenter,
                                            color: const Color(0x26848484),
                                          ),
                                        ),
                                      ),
                                    ),
                                  SizedBox(height: responsiveHelper.h(16)),
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ),
                ),
              ),
            ),
          ],
        ),
      ),
              // Linear Progress Indicator for refresh
              if (state.isLoading)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    backgroundColor: const Color(0xFFE0E0E0), // Light gray track
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF28A228), // App green color
                    ),
                    minHeight: 4.h,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showTypeSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectTypeScreen(
          selectedType: selectedFilter,
          onTypeSelected: (typeId, typeName) => _onTypeSelected(typeId, typeName),
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
    context.read<ExerciseCubit>().searchExercises(query);
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
    });
    context.read<ExerciseCubit>().loadAllExercises();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          // Header shimmer
          ShimmerCard(
            height: 80.h,
            padding: EdgeInsets.all(16.w),
          ),
          SizedBox(height: 16.h),
          
          // Search bar shimmer
          ShimmerCard(
            height: 50.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
          SizedBox(height: 16.h),
          
          // Filter chips shimmer
          Row(
            children: [
              ShimmerCard(
                width: 80.w,
                height: 32.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              ),
              SizedBox(width: 8.w),
              ShimmerCard(
                width: 100.w,
                height: 32.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              ),
              SizedBox(width: 8.w),
              ShimmerCard(
                width: 90.w,
                height: 32.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          
          // Exercise cards shimmer
          ShimmerList(
            itemCount: 6,
            itemHeight: 120.h,
            spacing: 16.h,
            itemBuilder: (index) => _buildExerciseCardShimmer(),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCardShimmer() {
    return ShimmerLoading(
      child: Container(
        width: double.infinity,
        height: 120.h,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          children: [
            // Exercise image shimmer
            Container(
              width: 88.w,
              height: 88.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(width: 16.w),
            // Exercise content shimmer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShimmerText(width: 150.w, height: 16.h),
                  SizedBox(height: 8.h),
                  ShimmerText(width: 100.w, height: 14.h), // "4 Sets x 8 reps" width
                  SizedBox(height: 8.h),
                  ShimmerText(width: 80.w, height: 12.h),
                ],
              ),
            ),
            // Favorite button shimmer
            ShimmerCircle(size: 24.w),
          ],
        ),
      ),
    );
  }
}
