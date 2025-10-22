import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  static const String _themeKey = 'app_theme';
  static const String _languageKey = 'app_language';

  /// الحصول على وضع المظهر المحفوظ
  Future<ThemeMode> getSavedThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final theme = prefs.getString(_themeKey) ?? 'النظام';
      
      switch (theme) {
        case 'فاتح':
          return ThemeMode.light;
        case 'داكن':
          return ThemeMode.dark;
        case 'النظام':
        default:
          return ThemeMode.system;
      }
    } catch (e) {
      return ThemeMode.system;
    }
  }

  /// حفظ وضع المظهر
  Future<void> saveThemeMode(String theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, theme);
    } catch (e) {
      print('Error saving theme: $e');
    }
  }

  /// الحصول على اللغة المحفوظة
  Future<Locale> getSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final language = prefs.getString(_languageKey) ?? 'العربية';
      
      switch (language) {
        case 'العربية':
          return const Locale('ar', 'SA');
        case 'English':
          return const Locale('en', 'US');
        default:
          return const Locale('ar', 'SA');
      }
    } catch (e) {
      return const Locale('ar', 'SA');
    }
  }

  /// حفظ اللغة
  Future<void> saveLanguage(String language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, language);
    } catch (e) {
      print('Error saving language: $e');
    }
  }

  /// تحويل ThemeMode إلى نص عربي
  String themeModeToArabic(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'فاتح';
      case ThemeMode.dark:
        return 'داكن';
      case ThemeMode.system:
      default:
        return 'النظام';
    }
  }

  /// تحويل Locale إلى نص عربي
  String localeToArabic(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      default:
        return 'العربية';
    }
  }
}
