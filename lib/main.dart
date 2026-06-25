import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'services/theme_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('MAIN STARTED');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await ThemeService.instance.initialize();

  await NotificationService.initialize();

  runApp(
    const RailwayCrossingApp(),
  );
}

class RailwayCrossingApp extends StatelessWidget {
  const RailwayCrossingApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable:
          ThemeService.instance.themeNotifier,

      builder: (
        context,
        themeMode,
        child,
      ) {
        return MaterialApp(
          title:
              'Railway Crossing Alert System',

          debugShowCheckedModeBanner:
              false,

          themeMode: themeMode,

          theme: ThemeData(
            useMaterial3: true,
            brightness:
                Brightness.light,

            colorSchemeSeed:
                const Color(
              0xFF003B8E,
            ),

            bottomNavigationBarTheme:
                const BottomNavigationBarThemeData(
              backgroundColor:
                  Colors.white,

              selectedItemColor:
                  Colors.blue,

              unselectedItemColor:
                  Colors.black54,
            ),
          ),

          darkTheme: ThemeData(
            useMaterial3: true,

            brightness:
                Brightness.dark,

            colorSchemeSeed:
                const Color(
              0xFF003B8E,
            ),

            bottomNavigationBarTheme:
                const BottomNavigationBarThemeData(
              backgroundColor:
                  Color(0xFF121212),

              selectedItemColor:
                  Colors.cyan,

              unselectedItemColor:
                  Colors.white70,
            ),
          ),

          home:
              const SplashScreen(),
        );
      },
    );
  }
}