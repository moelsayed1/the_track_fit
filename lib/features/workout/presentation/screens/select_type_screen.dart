import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import 'package:the_track_fit/core/constants/app_text_styles.dart';
import 'package:the_track_fit/core/utils/responsive_helper.dart';
import 'package:the_track_fit/core/constants/app_assets.dart';
import 'package:the_track_fit/features/workout/domain/models/workout_type.dart';

class SelectTypeScreen extends StatefulWidget {
  final String? selectedType;
  final Function(String) onTypeSelected;

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

  @override
  void initState() {
    super.initState();
    selectedTypeId = widget.selectedType;
    _initializeWorkoutTypes();
  }

  void _initializeWorkoutTypes() {
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
    
    widget.onTypeSelected(typeId);
    Navigator.pop(context);
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsiveHelper.w(4)),
                  child: Column(
                    children: [
                      ...workoutTypes.map((type) => _buildTypeItem(type, responsiveHelper)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: responsiveHelper.w(32),
                  height: responsiveHelper.h(32),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(type.iconPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: responsiveHelper.w(8)),
                Text(
                  type.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: responsiveHelper.sp(20),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0.80,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          child: Divider(
            color: const Color(0x26848484),
            height: responsiveHelper.h(16),
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
        ),
      ],
    );
  }
}
