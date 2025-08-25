import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:the_track_fit/core/utils/responsive_helper.dart';

class SelectLocationScreen extends StatefulWidget {
  final String? selectedLocation;
  final Function(String) onLocationSelected;

  const SelectLocationScreen({
    super.key,
    this.selectedLocation,
    required this.onLocationSelected,
  });

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  late List<LocationOption> locationOptions;
  String? selectedLocationId;

  @override
  void initState() {
    super.initState();
    selectedLocationId = widget.selectedLocation;
    _initializeLocationOptions();
  }

  void _initializeLocationOptions() {
    locationOptions = [
      LocationOption(
        id: 'home',
        name: 'At Home',
        iconPath: 'assets/images/home_icon.png',
        isSelected: selectedLocationId == 'home',
      ),
      LocationOption(
        id: 'gym',
        name: 'At Gym',
        iconPath: 'assets/images/gym_icon.png',
        isSelected: selectedLocationId == 'gym',
      ),
    ];
  }

  void _onLocationSelected(String locationId) {
    setState(() {
      selectedLocationId = locationId;
      locationOptions = locationOptions.map((option) {
        return option.copyWith(isSelected: option.id == locationId);
      }).toList();
    });
    
    // Add a small delay to show the selection change
    Future.delayed(const Duration(milliseconds: 300), () {
      widget.onLocationSelected(locationId);
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
                      'Select Location',
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
              
              // Location options list
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsiveHelper.w(4)),
                  child: Column(
                    children: [
                      ...locationOptions.map((option) => _buildLocationItem(option, responsiveHelper)),
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

  Widget _buildLocationItem(LocationOption option, ResponsiveHelper responsiveHelper) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _onLocationSelected(option.id),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(responsiveHelper.w(16)),
            decoration: BoxDecoration(
              color: option.isSelected 
                  ? const Color(0xFFD8F1D8) // Light green background when selected
                  : Colors.white, // White background when not selected
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: responsiveHelper.w(24),
                  height: responsiveHelper.h(24),
                  child: Image.asset(
                    option.iconPath,
                    width: responsiveHelper.w(24),
                    height: responsiveHelper.h(24),
                    fit: BoxFit.contain,
                    color: option.isSelected 
                        ? const Color(0xFF4CAF50) // Green color when selected
                        : null, // No color filter when not selected
                  ),
                ),
                SizedBox(width: responsiveHelper.w(8)),
                Expanded(
                  child: Text(
                    option.name,
                    style: TextStyle(
                      color: option.isSelected 
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
                if (option.isSelected)
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
}

class LocationOption {
  final String id;
  final String name;
  final String iconPath;
  final bool isSelected;

  LocationOption({
    required this.id,
    required this.name,
    required this.iconPath,
    this.isSelected = false,
  });

  LocationOption copyWith({
    String? id,
    String? name,
    String? iconPath,
    bool? isSelected,
  }) {
    return LocationOption(
      id: id ?? this.id,
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
