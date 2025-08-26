import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateSelector extends StatefulWidget {
  final Function(int) onDateSelected;
  final int initialSelectedIndex;
  final List<Map<String, String>> dates;

  const DateSelector({
    super.key,
    required this.onDateSelected,
    this.initialSelectedIndex = 0,
    required this.dates,
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
      height: 70.h,
      decoration: BoxDecoration(
        color: const Color(0xFF28A228).withValues(alpha: 0.80),
       
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.dates.asMap().entries.map((entry) {
            final index = entry.key;
            final date = entry.value;
            return _buildDateItem(date['day']!, date['date']!, index);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDateItem(String day, String date, int index) {
    bool isSelected = _selectedDateIndex == index;
    return GestureDetector(
      onTap: () => _onDateSelected(index),
      child: Container(
        width: 35.w,
        height: 80.h,

        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(
                color: isSelected ? const Color(0xFF28A228) : Colors.white,
                fontSize: 11.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              date,
              style: TextStyle(
                color: isSelected ? const Color(0xFF28A228) : Colors.white,
                fontSize: 11.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
