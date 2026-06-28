import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings
        androidInitializationSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const InitializationSettings
        initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    final AndroidFlutterLocalNotificationsPlugin?
        androidPlugin =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

    // Android 13+ Notification Permission
    await androidPlugin?.requestNotificationsPermission();

    // High Priority Notification Channel
    const AndroidNotificationChannel channel =
        AndroidNotificationChannel(
      'railway_alerts',
      'Railway Alerts',
      description:
          'Railway Crossing Alert Notifications',
      importance: Importance.max,
      playSound: true,
      enableLights: true,
      enableVibration: true,
      showBadge: true,
    );

    await androidPlugin?.createNotificationChannel(
      channel,
    );
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails
        androidNotificationDetails =
        AndroidNotificationDetails(
      'railway_alerts',
      'Railway Alerts',
      channelDescription:
          'Railway Crossing Alert Notifications',

      importance: Importance.max,
      priority: Priority.max,

      playSound: true,
      enableVibration: true,
      enableLights: true,

      autoCancel: true,

      ticker: 'Railway Alert',
    );

    const NotificationDetails
        notificationDetails =
        NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      DateTime.now()
          .millisecondsSinceEpoch ~/
          1000,
      title,
      body,
      notificationDetails,
    );
  }
}