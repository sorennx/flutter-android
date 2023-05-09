// import 'package:flutter_local_notifications/flutter_local_notifications.dart';



// class NotificationApi {
//   static final FlutterLocalNotificationsPlugin _notifications =
//       FlutterLocalNotificationsPlugin();

//   static Future _notificationDetails(int maxProgress, int progress) async => NotificationDetails(
//         android: AndroidNotificationDetails(
//           "channel id",
//           "channel name",
//           channelDescription: "channel description",
//           importance: Importance.max,
//           icon: "app_icon",
//           maxProgress: maxProgress,
//           progress: progress,
//           showProgress: true,
//           playSound: false,
//         ),
//       );

//   static Future showNotification(
//       {int id = 0, required int maxProgress, int progress = 0, String? title, String? body, String? payload,  }) async {
//     _notifications
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()!
//         .requestPermission();
//     _notifications.show(id, title, body, await _notificationDetails(maxProgress, progress),
//         payload: payload);
//   }
// }
