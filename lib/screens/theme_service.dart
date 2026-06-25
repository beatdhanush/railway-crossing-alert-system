import 'package:cloud_firestore/cloud_firestore.dart';

class ThemeService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static Future<bool> getDarkMode() async {
    final doc = await _firestore
        .collection('settings')
        .doc('app_theme')
        .get();

    if (!doc.exists) {
      return false;
    }

    return doc.data()?['darkMode'] ?? false;
  }

  static Future<void> updateDarkMode(
      bool value) async {
    await _firestore
        .collection('settings')
        .doc('app_theme')
        .set({
      'darkMode': value,
    });
  }
}