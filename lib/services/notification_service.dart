import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _inited = false;

  Future<void> init() async {
    if (_inited) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _plugin.initialize(settings: settings);
    _inited = true;
  }

  /// Always request permission before showing — handles Android 13+ runtime permission.
  Future<bool> _ensurePermission() async {
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      // On Android 13+ this shows the system dialog (once).
      // Returns null on older APIs where the permission is auto-granted.
      final granted = await androidImpl.requestNotificationsPermission();
      if (granted == false) {
        debugPrint('NotificationService: POST_NOTIFICATIONS denied by user');
        return false;
      }
    }
    return true;
  }

  Future<bool> showTest() async {
    try {
      await init();

      final permitted = await _ensurePermission();
      if (!permitted) return false;

      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          'nexora_test_channel',
          'Nexora Test',
          channelDescription: 'Test push notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      );
      await _plugin.show(
        id: 0,
        title: 'Nexora',
        body: 'Тестовое push-уведомление работает!',
        notificationDetails: details,
      );
      return true;
    } catch (e) {
      debugPrint('NotificationService error: $e');
      return false;
    }
  }
}
