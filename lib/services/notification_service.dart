import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../firebase_options.dart';
import 'local_notification_service.dart';

class NotificationService {
  static final FirebaseMessaging messaging =
      FirebaseMessaging.instance;

  static Future<void> initialize() async {
    try {
      print("========== NOTIFICATION INIT ==========");

      // Initialize Local Notification Plugin
      if (!kIsWeb) {
        await LocalNotificationService.initialize();
      }

      NotificationSettings settings =
          await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      print(
        "PERMISSION => ${settings.authorizationStatus}",
      );

      String? token;

      if (kIsWeb) {
        token = await messaging.getToken(
          vapidKey:
              "BHkRd_q42Y4Se2lIagL8ujS9SCkSKRAIAYIO7Nh_hpzUpAeGby6rNW3PY7MF48G5S11_xVbnFsPEPJNX84Rzpro",
        );

        print("WEB TOKEN => $token");
      } else {
        token = await messaging.getToken();

        print("ANDROID TOKEN => $token");
      }

      FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) async {
          print("");
          print("========== PUSH RECEIVED ==========");
          print(
            "TITLE : ${message.notification?.title}",
          );
          print(
            "BODY  : ${message.notification?.body}",
          );
          print("DATA  : ${message.data}");
          print("==================================");

          // Show Android Popup Notification
          if (!kIsWeb &&
              message.notification != null) {
            await LocalNotificationService
                .showNotification(
              title:
                  message.notification!.title ??
                      "Railway Alert",

              body:
                  message.notification!.body ??
                      "",
            );
          }
        },
      );

      FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) {
          print("Notification Opened");
          print(message.data);
        },
      );

      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      print(
        "==================================",
      );
    } catch (e) {
      print(
        "NOTIFICATION ERROR => $e",
      );
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {

  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform,
  );

  print("========== BACKGROUND ==========");
  print(message.notification?.title);
  print(message.notification?.body);
  print(message.data);

  if (!kIsWeb &&
      message.notification != null) {
    await LocalNotificationService
        .showNotification(
      title:
          message.notification!.title ??
              "Railway Alert",

      body:
          message.notification!.body ??
              "",
    );
  }
}