import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../extensions/localization_extensions.dart';

class DateSelector extends StatefulWidget {
  final Function(int) onDateSelected;
  final int initialSelectedIndex;
  final List<String> dayNames;

  const DateSelector({
    super.key,
    required this.onDateSelected,
    this.initialSelectedIndex = 0,
    required this.dayNames,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late int _selectedDateIndex;

  @override
  void initState() {
    super.initState();
    _selectedDateIndex = widget.initialSelectedIndex;
  }

  void _onDateSelected(int index) {
    setState(() {
      _selectedDateIndex = index;
    });
    widget.onDateSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF28A228),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widget.dayNames.asMap().entries.map((entry) {
          return _buildDateItem(entry.value, entry.key);
        }).toList(),
      ),
    );
  }

  Widget _buildDateItem(String dayName, int index) {
    bool isSelected = _selectedDateIndex == index;
    return GestureDetector(
      onTap: () => _onDateSelected(index),
      child: Container(
        width: 35.w,
        height: 60.h,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: TextStyle(
                color: isSelected ? const Color(0xFF28A228) : Colors.white,
                fontSize: 11.sp,
                fontFamily: context.fontFamily,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            // Text(
            //   dayName,
            //   style: TextStyle(
            //     color: isSelected ? const Color(0xFF28A228) : Colors.white,
            //     fontSize: 11.sp,
            //     fontFamily: 'Poppins',
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
