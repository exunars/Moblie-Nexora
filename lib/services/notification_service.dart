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
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
    );
    // Android 13+ runtime permission
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      await androidImpl.requestNotificationsPermission();
    }
    _inited = true;
  }

  Future<bool> showTest() async {
    try {
      await init();
      await _plugin.show(
        id: 0,
        title: 'Nexora',
        body: 'Тестовое push-уведомление работает!',
        notificationDetails: const NotificationDetails(
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
        ),
      );
      return true;
    } catch (e) {
      debugPrint('NotificationService error: $e');
      return false;
    }
  }
}
