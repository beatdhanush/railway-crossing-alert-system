import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  ThemeService._();

  static final ThemeService instance =
      ThemeService._();

  final ValueNotifier<ThemeMode>
      themeNotifier =
      ValueNotifier(
    ThemeMode.light,
  );

  Future<void> initialize() async {
    final prefs =
        await SharedPreferences.getInstance();

    final isDark =
        prefs.getBool('dark_mode') ??
            false;

    themeNotifier.value =
        isDark
            ? ThemeMode.dark
            : ThemeMode.light;
  }

  Future<void> toggleTheme(
      bool isDark) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      'dark_mode',
      isDark,
    );

    themeNotifier.value =
        isDark
            ? ThemeMode.dark
            : ThemeMode.light;
  }

  bool get isDarkMode =>
      themeNotifier.value ==
      ThemeMode.dark;
}