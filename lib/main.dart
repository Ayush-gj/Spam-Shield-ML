import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const SpamShieldApp());
}

class SpamShieldApp extends StatefulWidget {
  const SpamShieldApp({super.key});

  @override
  State<SpamShieldApp> createState() => _SpamShieldAppState();
}

class _SpamShieldAppState extends State<SpamShieldApp> {
  bool _isDark = true;

  void _toggleTheme(bool value) {
    setState(() {
      _isDark = value;
    });
  }

  bool _getIsDark() => _isDark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spam Shield',
      theme: AppTheme.build(Brightness.light),
      darkTheme: AppTheme.build(Brightness.dark),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(
        getIsDark: _getIsDark,
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}