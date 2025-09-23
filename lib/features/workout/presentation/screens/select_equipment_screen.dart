import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:the_track_fit/core/utils/responsive_helper.dart';

class SelectEquipmentScreen extends StatefulWidget {
  final String? selectedEquipment;
  final Function(String) onEquipmentSelected;

  const SelectEquipmentScreen({
    super.key,
    this.selectedEquipment,
    required this.onEquipmentSelected,
  });

  @override
  State<SelectEquipmentScreen> createState() => _SelectEquipmentScreenState();
}

class _SelectEquipmentScreenState extends State<SelectEquipmentScreen> {
  late List<EquipmentOption> equipmentOptions;
  String? selectedEquipmentId;

  @override
  void initState() {
    super.initState();
    selectedEquipmentId = widget.selectedEquipment;
    _initializeEquipmentOptions();
  }

  void _initializeEquipmentOptions() {
    equipmentOptions = [
      EquipmentOption(
        id: 'no_equipment',
        name: 'No Equipment',
        iconPath: null, // No icon for this option
        isSelected: selectedEquipmentId == 'no_equipment',
      ),
      EquipmentOption(
        id: 'mat_only',
        name: 'Mat Only',
        iconPath: 'assets/images/mat_only.png',
        isSelected: selectedEquipmentId == 'mat_only',
      ),
      EquipmentOption(
        id: 'machines',
        name: 'Machines',
        iconPath: 'assets/images/machines.png',
        isSelected: selectedEquipmentId == 'machines',
      ),
    ];
  }

  void _onEquipmentSelected(String equipmentId) {
    setState(() {
      selectedEquipmentId = equipmentId;
      equipmentOptions = equipmentOptions.map((option) {
        return option.copyWith(isSelected: option.id == equipmentId);
      }).toList();
    });
    
    // Add a small delay to show the selection change
    Future.delayed(const Duration(milliseconds: 300), () {
      widget.onEquipmentSelected(equipmentId);
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
                      'Select Equipment',
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
              
              // Equipment options list
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsiveHelper.w(4)),
                  child: Column(
                    children: [
                      ...equipmentOptions.map((option) => _buildEquipmentItem(option, responsiveHelper)),
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

  Widget _buildEquipmentItem(EquipmentOption option, ResponsiveHelper responsiveHelper) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _onEquipmentSelected(option.id),
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
                if (option.iconPath != null) ...[
                  SizedBox(
                    width: responsiveHelper.w(24),
                    height: responsiveHelper.h(24),
                    child: Image.asset(
                      option.iconPath!,
                      width: responsiveHelper.w(24),
                      height: responsiveHelper.h(24),
                      fit: BoxFit.contain,
                      color: option.isSelected 
                          ? const Color(0xFF4CAF50) // Green color when selected
                          : null, // No color filter when not selected
                    ),
                  ),
                  SizedBox(width: responsiveHelper.w(24)),
                ],
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

class EquipmentOption {
  final String id;
  final String name;
  final String? iconPath; // Can be null for "No Equipment"
  final bool isSelected;

  EquipmentOption({
    required this.id,
    required this.name,
    this.iconPath,
    this.isSelected = false,
  });

  EquipmentOption copyWith({
    String? id,
    String? name,
    String? iconPath,
    bool? isSelected,
  }) {
    return EquipmentOption(
      id: id ?? this.id,
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
