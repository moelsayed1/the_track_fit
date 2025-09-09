import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/widgets/shimmer_loading.dart';
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

  @override
  void initState() {
    super.initState();
    _loadMainGoalOptions();
  }

  Future<void> _loadMainGoalOptions() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await _apiService.get(AppConstants.mainGoalOptionEndpoint);
      
      if (response.statusCode == 200) {
        final mainGoalResponse = MainGoalResponse.fromJson(response.data);
        setState(() {
          _goalOptions = mainGoalResponse.data;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load main goal options: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load main goal options: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _selectGoal(int index) {
    setState(() {
      selectedGoalIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
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
                  SizedBox(width: 8.w),
                  Text(
                    'Main Goal',
                    style: TextStyle(
                      color: const Color(0xFF1E1E1E),
                      fontSize: 18.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 0.89,
                    ),
                  ),
                ],
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
    return GestureDetector(
      onTap: () => _selectGoal(index),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: ShapeDecoration(
          color: isSelected 
              ? const Color(0x3328A228) // Light green background when selected
              : const Color(0x26848484), // Light gray background when not selected
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
        child: Row(
          children: [
            // Radio button container
            Container(
              width: 22.w,
              height: 22.h,
              padding: EdgeInsets.all(4.w),
              decoration: ShapeDecoration(
                color: isSelected 
                    ? const Color(0xFF28A228) // Green background when selected
                    : Colors.transparent, // Transparent when not selected
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color: isSelected 
                        ? const Color(0xFF28A228) // Green border when selected
                        : const Color(0xFF848484), // Gray border when not selected
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
                        ? Colors.white // White dot when selected
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
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}