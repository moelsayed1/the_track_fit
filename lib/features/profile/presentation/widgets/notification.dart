import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/core/services/notification_service.dart';
import 'package:the_track_fit/core/widgets/shimmer_loading.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';

class NotificationProfile extends StatefulWidget {
  const NotificationProfile({super.key});

  @override
  State<NotificationProfile> createState() => _NotificationProfileState();
}

class _NotificationProfileState extends State<NotificationProfile> {
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      // Add a test notification for debugging/demo purposes
   //   await _addTestNotification();
      final notifications = await NotificationService.getNotifications();
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    await NotificationService.markAsRead(notificationId);
    _loadNotifications(); // Reload to update UI
  }

  Future<void> _markAllAsRead() async {
    await NotificationService.markAllAsRead();
    _loadNotifications(); // Reload to update UI
  }

  Future<void>  _addTestNotification() async {
    final testNotification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title:
          AppLocalizations.of(context)?.testNotificationTitle ??
          'Test Notification',
      body:
          AppLocalizations.of(context)?.testNotificationBody ??
          'This is a test notification from TrackFit! 🎉',
      type: 'workout_reminder',
      data: {
        'type': 'workout_reminder',
        'screen': 'workout',
        'action': 'start_workout',
      },
      timestamp: DateTime.now(),
      isRead: false,
    );

    await NotificationService.addNotification(testNotification);
    _loadNotifications(); // Reload to update UI
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    final locale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context);

    if (difference.inDays > 0) {
      return locale == 'ar'
          ? '${difference.inDays}${l10n?.daysShort ?? "ي"}'
          : '${difference.inDays}${l10n?.daysShort ?? "d"}';
    } else if (difference.inHours > 0) {
      return locale == 'ar'
          ? '${difference.inHours}${l10n?.hoursShort ?? "س"}'
          : '${difference.inHours}${l10n?.hoursShort ?? "h"}';
    } else if (difference.inMinutes > 0) {
      return locale == 'ar'
          ? '${difference.inMinutes}${l10n?.minutesShort ?? "د"}'
          : '${difference.inMinutes}${l10n?.minutesShort ?? "m"}';
    } else {
      return l10n?.now ?? 'now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale == 'ar';

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
              child: Directionality(
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n?.notificationsTitle ?? 'Notifications',
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
                            : 0, // Rotate 180 degrees for Arabic
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

            // Notifications List
            Expanded(
              child: _isLoading
                  ? Center(
                      child: ShimmerLoading(
                        child: Container(
                          width: 320.w,
                          height: 80.h,
                          margin: EdgeInsets.symmetric(
                            vertical: 8.h,
                            horizontal: 16.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadNotifications,
                      displacement: 32.h,
                      edgeOffset: 0,
                      child: _notifications.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(height: 250.h),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.notifications_none,
                                        size: 64.sp,
                                        color: const Color(0xFF848484),
                                      ),
                                      SizedBox(height: 16.h),
                                      Text(
                                        l10n?.noNotificationsYet ??
                                            'No notifications yet',
                                        style: TextStyle(
                                          color: const Color(0xFF848484),
                                          fontSize: 16.sp,
                                          fontFamily: isArabic
                                              ? 'Cairo'
                                              : 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        l10n?.noNotificationsDesc ??
                                            "You'll see your notifications here",
                                        style: TextStyle(
                                          color: const Color(0xFF848484),
                                          fontSize: 14.sp,
                                          fontFamily: isArabic
                                              ? 'Cairo'
                                              : 'Poppins',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 24.h),
                                      // Test notification button
                                      // ElevatedButton(
                                      //   onPressed: _addTestNotification,
                                      //   style: ElevatedButton.styleFrom(
                                      //     backgroundColor: const Color(0xFF28A228),
                                      //     foregroundColor: Colors.white,
                                      //     padding: EdgeInsets.symmetric(
                                      //       horizontal: 24.w,
                                      //       vertical: 12.h,
                                      //     ),
                                      //     shape: RoundedRectangleBorder(
                                      //       borderRadius: BorderRadius.circular(8.r),
                                      //     ),
                                      //   ),
                                      //   child: Text(
                                      //     l10n?.addTestNotification ?? 'Add Test Notification',
                                      //     style: TextStyle(
                                      //       fontSize: 14.sp,
                                      //       fontFamily: isArabic ? 'Cairo' : 'Poppins',
                                      //       fontWeight: FontWeight.w500,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(height: 4.h),
                                // Mark all as read button
                                if (_notifications.any((n) => !n.isRead))
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: _markAllAsRead,
                                        child: Text(
                                          l10n?.markAllAsRead ??
                                              'Mark all as read',
                                          style: TextStyle(
                                            color: const Color(0xFF28A228),
                                            fontSize: 14.sp,
                                            fontFamily: isArabic
                                                ? 'Cairo'
                                                : 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                // Notification items with dividers
                                for (
                                  int i = 0;
                                  i < _notifications.length;
                                  i++
                                ) ...[
                                  _buildNotificationItem(
                                    notification: _notifications[i],
                                    hasRedDot: !_notifications[i].isRead,
                                    hasBackground: !_notifications[i].isRead,
                                    isArabic: isArabic,
                                  ),
                                  if (i < _notifications.length - 1)
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
            // Padding(
            //   padding: EdgeInsets.all(16.w),
            //   child: GestureDetector(
            //     onTap: () {
            //       // Handle show all notifications
            //     },
            //     child: Text(
            //       l10n?.showAllNotifications ?? 'Show all Notifications',
            //       style: TextStyle(
            //         color: const Color(0xFF1E1E1E),
            //         fontSize: 14.sp,
            //         fontFamily: isArabic ? 'Cairo' : 'Poppins',
            //         fontWeight: FontWeight.w400,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required NotificationModel notification,
    required bool hasRedDot,
    required bool hasBackground,
    bool isArabic = false,
  }) {
    return GestureDetector(
      onTap: () => _markAsRead(notification.id),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: hasBackground ? const Color(0x26848484) : Colors.transparent,
        ),
        child: Row(
          children: [
            // Notification icon container
            Container(
              width: 35.w,
              height: 35.h,
              padding: EdgeInsets.all(5.w),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0x3F848484)),
                  borderRadius: BorderRadius.circular(21.r),
                ),
              ),
              child: Center(
                child: _getNotificationIconWidget(notification.type),
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
                    notification.title,
                    style: TextStyle(
                      color: const Color(0xFF1E1E1E),
                      fontSize: 14.sp,
                      fontFamily: isArabic ? 'Cairo' : 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.body,
                    style: TextStyle(
                      color: const Color(0xFF848484),
                      fontSize: 10.sp,
                      fontFamily: isArabic ? 'Cairo' : 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // Timestamp
            Text(
              _formatTimeAgo(notification.timestamp),
              style: TextStyle(
                color: const Color(0xFF848484),
                fontSize: 10.sp,
                fontFamily: isArabic ? 'Cairo' : 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getNotificationIconWidget(String type) {
    switch (type) {
      case 'workout_reminder':
        return Image.asset(
          'assets/images/dumbbell.png',
          width: 24.w,
          height: 24.h,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.fitness_center,
            size: 24.sp,
            color: const Color(0xFF28A228),
          ),
        );
      case 'meal_reminder':
        return SvgPicture.asset(
          'assets/logos/food_icon.svg',
          width: 24.w,
          height: 24.h,
          placeholderBuilder: (context) => Icon(
            Icons.restaurant,
            size: 24.sp,
            color: const Color(0xFF28A228),
          ),
        );
      case 'achievement':
        return Image.asset(
          'assets/images/trophy.gif',
          width: 24.w,
          height: 24.h,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.emoji_events,
            size: 24.sp,
            color: const Color(0xFF28A228),
          ),
        );
      case 'subscription':
        return Image.asset(
          'assets/images/card_payment.png',
          width: 24.w,
          height: 24.h,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.payment, size: 24.sp, color: const Color(0xFF28A228)),
        );
      default:
        return SvgPicture.asset(
          'assets/images/timer.svg',
          width: 24.w,
          height: 24.h,
          placeholderBuilder: (context) => Icon(
            Icons.access_time,
            size: 24.sp,
            color: const Color(0xFF28A228),
          ),
        );
    }
  }
}
