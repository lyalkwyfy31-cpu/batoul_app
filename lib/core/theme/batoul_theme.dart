import 'package:flutter/material.dart';

// دستور التصميم الثابت (Design System Constants) كما اعتمده المصمم
class BatoulTheme {
  BatoulTheme._();

  static const Color primaryIndigo = Color(0xFF4F46E5);
  static const Color primaryIndigoDark = Color(0xFF3730A3); // للحافة ثلاثية الأبعاد
  static const Color amberGold = Color(0xFFF59E0B);
  static const Color amberGoldDark = Color(0xFFD97706); // للحافة ثلاثية الأبعاد
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color mintSuccess = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF97316);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color borderLight = Color(0xFFE2E8F0);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundLight,
      primaryColor: primaryIndigo,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryIndigo,
        primary: primaryIndigo,
        secondary: amberGold,
        surface: surfaceWhite,
        error: errorRed,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textPrimary),
      ),
    );
  }
}
