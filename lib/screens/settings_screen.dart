import 'package:flutter/material.dart';
import '../services/theme_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {

  bool darkMode = false;

  @override
  void initState() {
    super.initState();

    darkMode =
        ThemeService.instance.isDarkMode;
  }

  Future<void> updateTheme(
      bool value) async {

    await ThemeService.instance
        .toggleTheme(value);

    setState(() {
      darkMode = value;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          value
              ? 'Dark Mode Enabled'
              : 'Light Mode Enabled',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),

        backgroundColor:
            const Color(0xFF003B8E),

        foregroundColor:
            Colors.white,
      ),

      body: ListView(
        children: [

          const SizedBox(
            height: 10,
          ),

          SwitchListTile(
            secondary: const Icon(
              Icons.dark_mode,
            ),

            title: const Text(
              'Dark Mode',
            ),

            subtitle: const Text(
              'Enable dark theme',
            ),

            value: darkMode,

            onChanged: updateTheme,
          ),

          const Divider(),

          const ListTile(
            leading: Icon(
              Icons.info_outline,
            ),

            title: Text(
              'Version',
            ),

            subtitle: Text(
              '1.0.0',
            ),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(
              Icons.refresh,
            ),

            title: const Text(
              'Refresh Theme',
            ),

            onTap: () {
              setState(() {
                darkMode =
                    ThemeService
                        .instance
                        .isDarkMode;
              });
            },
          ),
        ],
      ),
    );
  }
}