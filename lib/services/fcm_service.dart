import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FCMService {
  static Future<void> saveToken() async {
    print('====================');
    print('FCM SERVICE STARTED');
    print('====================');

    try {
      final user = FirebaseAuth.instance.currentUser;

      print('CURRENT USER => ${user?.uid}');

      if (user == null) {
        print('USER IS NULL');
        return;
      }

      String? token;

      print('GETTING FCM TOKEN');

      if (kIsWeb) {
        token = await FirebaseMessaging.instance.getToken(
          vapidKey:
              'BHkRd_q42Y4Se2lIagL8ujS9SCkSKRAIAYIO7Nh_hpzUpAeGby6rNW3PY7MF48G5S11_xVbnFsPEPJNX84Rzpro',
        );
      } else {
        token = await FirebaseMessaging.instance.getToken();
      }

      print('TOKEN RESULT => $token');

      if (token == null) {
        print('FCM TOKEN IS NULL');
        return;
      }

      final employeeQuery =
          await FirebaseFirestore.instance
              .collection('employees')
              .where(
                'uid',
                isEqualTo: user.uid,
              )
              .limit(1)
              .get();

      print(
        'EMPLOYEE DOC COUNT => ${employeeQuery.docs.length}',
      );

      if (employeeQuery.docs.isEmpty) {
        print('EMPLOYEE DOCUMENT NOT FOUND');
        return;
      }

      final employeeDoc =
          employeeQuery.docs.first.reference;

      await employeeDoc.update({
        'fcmToken': token,
        'tokenUpdatedAt':
            FieldValue.serverTimestamp(),
      });

      print('FCM TOKEN SAVED SUCCESSFULLY');
    } catch (e) {
      print('TOKEN SAVE ERROR => $e');
    }

    print('====================');
    print('FCM SERVICE FINISHED');
    print('====================');
  }
}