import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF4A6FA5);
  static const Color primaryLight = Color(0xFF6B8FC4);
  static const Color primaryDark = Color(0xFF2E4F7A);

  static const Color spamRed = Color(0xFFE24B4A);
  static const Color spamRedDark = Color(0xFFF09595);
  static const Color safeGreen = Color(0xFF2E7D5E);
  static const Color safeGreenDark = Color(0xFF6FC99E);

  static ThemeData build(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    return ThemeData(
      brightness: brightness,
      colorSchemeSeed: primary,
      useMaterial3: true,
      scaffoldBackgroundColor:
      isDark ? const Color(0xFF0D1117) : const Color(0xFFF0F4F8),
      appBarTheme: AppBarTheme(
        backgroundColor:
        isDark ? const Color(0xFF161B22) : Colors.white,
        foregroundColor:
        isDark ? Colors.white : const Color(0xFF1A1D24),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : const Color(0xFF1A1D24),
          letterSpacing: 0.3,
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor:
        isDark ? const Color(0xFF161B22) : Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF1C2128) : Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDark
                ? const Color(0xFF30363D)
                : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor:
        isDark ? const Color(0xFF1C2128) : const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: isDark
                  ? const Color(0xFF30363D)
                  : const Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: isDark
                  ? const Color(0xFF30363D)
                  : const Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        hintStyle: TextStyle(
          color: isDark
              ? const Color(0xFF8B949E)
              : const Color(0xFFADB5BD),
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:
        isDark ? const Color(0xFF161B22) : Colors.white,
        selectedItemColor: primary,
        unselectedItemColor: isDark
            ? const Color(0xFF6B7280)
            : const Color(0xFF9CA3AF),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
      ),
    );
  }
}