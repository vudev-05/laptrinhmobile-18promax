import 'package:flutter/services.dart';

class NotificationService {
  static const MethodChannel _methodChannel = MethodChannel('vn.autobank.mobile/permissions');
  static const EventChannel _eventChannel = EventChannel('vn.autobank.mobile/notifications');

  /// Check if the Notification Listener permission is granted
  static Future<bool> isListenerEnabled() async {
    try {
      final bool isEnabled = await _methodChannel.invokeMethod('isNotificationListenerEnabled');
      return isEnabled;
    } on PlatformException catch (e) {
      print("Failed to check permission: '${e.message}'.");
      return false;
    }
  }

  /// Open Android settings to grant Notification Listener permission
  static Future<void> openSettings() async {
    try {
      await _methodChannel.invokeMethod('openNotificationListenerSettings');
    } on PlatformException catch (e) {
      print("Failed to open settings: '${e.message}'.");
    }
  }

  /// Listen to incoming notifications from the Android Service
  static Stream<Map<String, dynamic>> get notificationStream {
    return _eventChannel.receiveBroadcastStream().map((dynamic event) {
      // The event is a map from Kotlin: {title, text, package}
      return Map<String, dynamic>.from(event);
    });
  }
}
