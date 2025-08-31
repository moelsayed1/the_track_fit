import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class NotificationProfile extends StatefulWidget {
  const NotificationProfile({super.key});

  @override
  State<NotificationProfile> createState() => _NotificationProfileState();
}

class _NotificationProfileState extends State<NotificationProfile> {
  // Track which notifications are read
  final List<bool> _readNotifications = List.generate(6, (index) => false);

  void _markAsRead(int index) {
    setState(() {
      _readNotifications[index] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
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
                    'Notifications',
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

            // Notifications List
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    
                    // Notification items with dividers
                    for (int i = 0; i < 6; i++) ...[
                      _buildNotificationItem(
                        index: i,
                        hasRedDot: !_readNotifications[i],
                        hasBackground: !_readNotifications[i],
                      ),
                      if (i < 5) // Add divider after each item except the last one
                        Container(
                          width: double.infinity,
                          height: 1.h,
                          color: const Color(0x26848484),
                        ),
                    ],
                  ],
                ),
              ),
            ),

            // Divider before footer
            Container(
              width: double.infinity,
              height: 1.h,
              color: const Color(0x26848484),
            ),

            // Show all Notifications link
            Padding(
              padding: EdgeInsets.all(16.w),
              child: GestureDetector(
                onTap: () {
                  // Handle show all notifications
                },
                child: Text(
                  'Show all Notifications',
                  style: TextStyle(
                    color: const Color(0xFF1E1E1E),
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required int index,
    required bool hasRedDot,
    required bool hasBackground,
  }) {
    return GestureDetector(
      onTap: () => _markAsRead(index),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: hasBackground ? const Color(0x26848484) : Colors.transparent,
          // Border removed
        ),
        child: Row(
          children: [
            // Timer icon container
            Container(
              width: 35.w,
              height: 35.h,
              padding: EdgeInsets.all(5.w),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0x3F848484),
                  ),
                  borderRadius: BorderRadius.circular(21.r),
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/timer.svg',
                  width: 24.w,
                  height: 24.h,
                  placeholderBuilder: (context) => Icon(
                    Icons.access_time,
                    size: 24.sp,
                    color: const Color(0xFF28A228),
                  ),
                ),
              ),
            ),

            // Red dot (only for unread items)
            if (hasRedDot) ...[
              SizedBox(width: 8.w),
              Container(
                width: 8.w,
                height: 8.h,
                decoration: const ShapeDecoration(
                  color: Color(0xFFFF5652),
                  shape: OvalBorder(),
                ),
              ),
            ],

            SizedBox(width: 8.w),

            // Notification content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your current plan will renew on August 15, 2025',
                    style: TextStyle(
                      color: const Color(0xFF1E1E1E),
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Make sure your payment method is up to date to avoid interruption.',
                    style: TextStyle(
                      color: const Color(0xFF848484),
                      fontSize: 10.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // Timestamp
            Text(
              '5h',
              style: TextStyle(
                color: const Color(0xFF848484),
                fontSize: 10.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}