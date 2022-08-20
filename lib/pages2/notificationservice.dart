import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleDailyTenAMNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Pro Version Alert',
        'Your pro version will end on within a few days.',
        nextInstanceOfTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'main_channel',
              'Main Channel',
              importance: Importance.max,
              priority: Priority.max,
              icon: '@mipmap/ic_launcher'
          ),
          iOS: IOSNotificationDetails(
            sound: 'default.wav',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  Future<void> scheduleDailyTenNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Pro Version Alert',
        'Your pro version will end on within a few days.',
        nextInstanceOfTen(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'main_channel',
              'Main Channel',
              importance: Importance.max,
              priority: Priority.max,
              icon: '@mipmap/ic_launcher'
          ),
          iOS: IOSNotificationDetails(
            sound: 'default.wav',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  tz.TZDateTime nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, 20, 00).add(Duration(minutes: DateTime.now().timeZoneOffset.inMinutes));
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    print('scheduled ' + scheduledDate.toString() + ' '+ tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour, now.minute).toString());
    return scheduledDate;
  }

  tz.TZDateTime nextInstanceOfTen() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour, now.minute, now.second).add(Duration(minutes: 1));
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    //print('scheduled ' + scheduledDate.toString() + ' '+ tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour, now.minute).toString());
    return scheduledDate;
  }

  // Future<void> showNotification(int id, String title, String body, int seconds) async {
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     id,
  //     title,
  //     body,
  //     tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
  //     const NotificationDetails(
  //       android: AndroidNotificationDetails(
  //           'main_channel',
  //           'Main Channel',
  //           importance: Importance.max,
  //           priority: Priority.max,
  //           icon: '@mipmap/ic_launcher'
  //       ),
  //       iOS: IOSNotificationDetails(
  //         sound: 'default.wav',
  //         presentAlert: true,
  //         presentBadge: true,
  //         presentSound: true,
  //       ),
  //     ),
  //     uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  //     androidAllowWhileIdle: true,
  //   );
  // }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}