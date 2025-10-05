import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static const String _notificationPermissionKey =
      'notification_permission_requested';

  /// Request notification permission with proper handling for release builds
  static Future<bool> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+)
      if (await Permission.notification.isDenied) {
        final status = await Permission.notification.request();
        return status.isGranted;
      }
      return await Permission.notification.isGranted;
    } else if (Platform.isIOS) {
      // For iOS
      final status = await Permission.notification.request();
      return status.isGranted;
    }
    return false;
  }

  /// Request camera permission
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Request storage permission (handles both legacy and scoped storage)
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+)
      if (await Permission.photos.isDenied) {
        final status = await Permission.photos.request();
        return status.isGranted;
      }
      return await Permission.photos.isGranted;
    } else if (Platform.isIOS) {
      final status = await Permission.photos.request();
      return status.isGranted;
    }
    return false;
  }

  /// Check if notification permission is granted
  static Future<bool> isNotificationPermissionGranted() async {
    if (Platform.isAndroid) {
      return await Permission.notification.isGranted;
    } else if (Platform.isIOS) {
      return await Permission.notification.isGranted;
    }
    return false;
  }

  /// Show permission dialog with explanation
  static Future<bool> showPermissionDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String permissionType,
  }) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Settings'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  /// Open app settings for manual permission grant
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }

  /// Request all necessary permissions for the app
  static Future<Map<String, bool>> requestAllPermissions() async {
    final results = <String, bool>{};

    // Request notification permission
    results['notification'] = await requestNotificationPermission();

    // Request camera permission
    results['camera'] = await requestCameraPermission();

    // Request storage permission
    results['storage'] = await requestStoragePermission();

    return results;
  }
}
