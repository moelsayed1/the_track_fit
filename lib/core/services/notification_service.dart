import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.data,
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? 'general',
      data: json['data'] ?? {},
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    Map<String, dynamic>? data,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationService {
  static const String _notificationsKey = 'notifications';
  static const String _unreadCountKey = 'unread_count';

  /// Save notifications to local storage
  static Future<void> saveNotifications(
    List<NotificationModel> notifications,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = notifications.map((n) => n.toJson()).toList();
      await prefs.setString(_notificationsKey, jsonEncode(notificationsJson));

      // Update unread count
      final unreadCount = notifications.where((n) => !n.isRead).length;
      await prefs.setInt(_unreadCountKey, unreadCount);

      log(
        '📱 Saved ${notifications.length} notifications, $unreadCount unread',
      );
    } catch (e) {
      log('❌ Error saving notifications: $e');
    }
  }

  /// Get notifications from local storage
  static Future<List<NotificationModel>> getNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = prefs.getString(_notificationsKey);

      if (notificationsJson != null) {
        final List<dynamic> jsonList = jsonDecode(notificationsJson);
        return jsonList
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      log('❌ Error getting notifications: $e');
      return [];
    }
  }

  /// Add a new notification
  static Future<void> addNotification(NotificationModel notification) async {
    try {
      final notifications = await getNotifications();
      notifications.insert(0, notification); // Add to beginning

      // Keep only last 50 notifications
      if (notifications.length > 50) {
        notifications.removeRange(50, notifications.length);
      }

      await saveNotifications(notifications);
      log('📱 Added new notification: ${notification.title}');
    } catch (e) {
      log('❌ Error adding notification: $e');
    }
  }

  /// Mark notification as read
  static Future<void> markAsRead(String notificationId) async {
    try {
      final notifications = await getNotifications();
      final index = notifications.indexWhere((n) => n.id == notificationId);

      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isRead: true);
        await saveNotifications(notifications);
        log('📱 Marked notification as read: $notificationId');
      }
    } catch (e) {
      log('❌ Error marking notification as read: $e');
    }
  }

  /// Mark all notifications as read
  static Future<void> markAllAsRead() async {
    try {
      final notifications = await getNotifications();
      final updatedNotifications = notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();
      await saveNotifications(updatedNotifications);
      log('📱 Marked all notifications as read');
    } catch (e) {
      log('❌ Error marking all notifications as read: $e');
    }
  }

  /// Get unread count
  static Future<int> getUnreadCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_unreadCountKey) ?? 0;
    } catch (e) {
      log('❌ Error getting unread count: $e');
      return 0;
    }
  }

  /// Clear all notifications
  static Future<void> clearAllNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_notificationsKey);
      await prefs.remove(_unreadCountKey);
      log('📱 Cleared all notifications');
    } catch (e) {
      log('❌ Error clearing notifications: $e');
    }
  }

  /// Create notification from FCM message
  static NotificationModel fromFCMData({
    required String messageId,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) {
    return NotificationModel(
      id: messageId,
      title: title,
      body: body,
      type: data['type'] ?? 'general',
      data: data,
      timestamp: DateTime.now(),
      isRead: false,
    );
  }
}
