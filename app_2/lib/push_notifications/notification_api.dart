import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future _notificationDetailes() async => const NotificationDetails(
        android: AndroidNotificationDetails("channel id", "channel name",
            channelDescription: "channel description",
            importance: Importance.max,
            icon: "app_icon",
            playSound: true),
      );

  static Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();
    _notifications.show(id, title, body, await _notificationDetailes(),
        payload: payload);
  }
}
