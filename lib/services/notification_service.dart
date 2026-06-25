import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final FirebaseMessaging messaging =
      FirebaseMessaging.instance;

  static Future<void> initialize() async {
    try {
      print("========== NOTIFICATION INIT ==========");

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
        (RemoteMessage message) {
          print("");
          print("========== PUSH RECEIVED ==========");
          print("TITLE : ${message.notification?.title}");
          print("BODY  : ${message.notification?.body}");
          print("DATA  : ${message.data}");
          print("==================================");
        },
      );

      FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) {
          print(
            "Notification Opened",
          );

          print(message.data);
        },
      );

      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      print("==================================");

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

  print("========== BACKGROUND ==========");
  print(message.notification?.title);
  print(message.notification?.body);
  print(message.data);
}