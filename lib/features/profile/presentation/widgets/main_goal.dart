import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../questions/main_goal/domain/models/main_goal_response.dart';

class MainGoalProfile extends StatefulWidget {
  const MainGoalProfile({super.key});

  @override
  State<MainGoalProfile> createState() => _MainGoalProfileState();
}

class _MainGoalProfileState extends State<MainGoalProfile> {
  int selectedGoalIndex = 1; // "Increase Muscle" is selected by default
  List<String> _goalOptions = [];
  bool _isLoading = true;
  final ApiService _apiService = ApiService();
  late final StorageService _storageService;

  @override
  void initState() {
    super.initState();
    _initializeStorage();
    _loadMainGoalOptions();
  }

  Future<void> _initializeStorage() async {
    _storageService = await StorageService.getInstance();
    _loadSelectedGoal();
  }

  Future<void> _loadSelectedGoal() async {
    try {
      final storedGoal = _storageService.getMainGoal();
      if (storedGoal != null && _goalOptions.isNotEmpty) {
        final goalIndex = _goalOptions.indexOf(storedGoal);
        if (goalIndex != -1) {
          setState(() {
            selectedGoalIndex = goalIndex;
          });
          log('Loaded stored goal: $storedGoal at index: $goalIndex');
        } else {
          log('Stored goal "$storedGoal" not found in available options');
        }
      } else if (storedGoal == null) {
        log('No stored goal found, using default selection');
      } else {
        log('Goal options not loaded yet, will retry after loading');
      }
    } catch (e) {
      log('Error loading selected goal: $e');
    }
  }

  Future<void> _loadMainGoalOptions() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await _apiService.get(
        AppConstants.mainGoalOptionEndpoint,
      );

      if (response.statusCode == 200) {
        final mainGoalResponse = MainGoalResponse.fromJson(response.data);
        setState(() {
          _goalOptions = mainGoalResponse.data;
          _isLoading = false;
        });

        // Load the selected goal after options are loaded
        _loadSelectedGoal();
      } else {
        throw Exception(
          'Failed to load main goal options: ${response.statusCode}',
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${l10n?.failedToLoadMainGoalOptions ?? "Failed to load main goal options"}: ${e.toString()}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _selectGoal(int index) async {
    setState(() {
      selectedGoalIndex = index;
    });

    // Send the selected goal to the server
    await _updateMainGoal(_goalOptions[index]);
  }

  Future<void> _updateMainGoal(String goal) async {
    try {
      log('Updating main goal to: $goal');

      // Use 'main_goal' parameter name and form data
      final response = await _apiService.postForm(
        AppConstants.updateMainGoalEndpoint,
        data: {'main_goal': goal},
      );

      log('API Response Status: ${response.statusCode}');
      log('API Response Data: ${response.data}');

      if (response.statusCode == 200) {
        // Save the goal to local storage
        await _storageService.saveMainGoal(goal);
        log('Goal saved to storage: $goal');

        if (mounted) {
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n?.mainGoalUpdatedSuccessfully ??
                    'Main goal updated successfully!',
              ),
              backgroundColor: const Color(0xFF28A228),
            ),
          );
        }
      } else {
        throw Exception('Failed to update main goal: ${response.statusCode}');
      }
    } catch (e) {
      log('Error updating main goal: $e');
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${l10n?.failedToUpdateMainGoal ?? "Failed to update main goal"}: ${e.toString()}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: const BoxDecoration(color: Color(0x26848484)),
              child: Directionality(
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n?.mainGoal ?? 'Main Goal',
                      style: TextStyle(
                        color: const Color(0xFF1E1E1E),
                        fontSize: 18.sp,
                        fontFamily: isArabic ? 'Cairo' : 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0.89,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Transform.rotate(
                        angle: !isArabic
                            ? 3.14159
                            : 0, // Rotate 180 degrees for LTR
                        child: SvgPicture.asset(
                          'assets/logos/arrow_left.svg',
                          width: 24.w,
                          height: 24.h,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF1E1E1E),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main Content
            Expanded(
              child: _isLoading
                  ? _buildShimmerLoading()
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16.h),

                          // Goal Options from API
                          ..._goalOptions.asMap().entries.map((entry) {
                            final index = entry.key;
                            final title = entry.value;
                            return Column(
                              children: [
                                _buildGoalOption(
                                  index: index,
                                  title: title,
                                  isSelected: selectedGoalIndex == index,
                                ),
                                if (index < _goalOptions.length - 1)
                                  SizedBox(height: 16.h),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),

          // Use the common shimmer list component
          ShimmerList(
            itemCount: 8,
            itemBuilder: (index) => const ShimmerGoalOption(),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalOption({
    required int index,
    required String title,
    required bool isSelected,
  }) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return GestureDetector(
      onTap: () => _selectGoal(index),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: ShapeDecoration(
          color: isSelected
              ? const Color(0x3328A228) // Light green background when selected
              : const Color(
                  0x26848484,
                ), // Light gray background when not selected
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: isSelected
                  ? const Color(0xFF28A228) // Green border when selected
                  : Colors.transparent, // Gray border when not selected
            ),
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        child: Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Row(
            children: [
              // Radio button container
              Container(
                width: 22.w,
                height: 22.h,
                padding: EdgeInsets.all(4.w),
                decoration: ShapeDecoration(
                  color: isSelected
                      ? const Color(
                          0xFF28A228,
                        ) // Green background when selected
                      : Colors.transparent, // Transparent when not selected
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: isSelected
                          ? const Color(
                              0xFF28A228,
                            ) // Green border when selected
                          : const Color(
                              0xFF848484,
                            ), // Gray border when not selected
                    ),
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                ),
                child: Center(
                  child: Container(
                    width: isSelected ? 9.w : 14.w,
                    height: isSelected ? 9.h : 14.h,
                    decoration: ShapeDecoration(
                      color: isSelected
                          ? Colors
                                .white // White dot when selected
                          : Colors.transparent, // No dot when not selected
                      shape: const OvalBorder(),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 16.w),

              // Goal title
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontFamily: isArabic ? 'Cairo' : 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
