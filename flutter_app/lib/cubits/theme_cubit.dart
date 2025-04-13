import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark }

class ThemeCubit extends Cubit<ThemeMode> {
  static const _themeKey = 'app_theme_mode';

  ThemeCubit() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final modeString = prefs.getString(_themeKey);
    switch (modeString) {
      case 'dark':
        emit(ThemeMode.dark);
        break;
      case 'light':
        emit(ThemeMode.light);
        break;
      default:
        emit(ThemeMode.light); // default fallback
    }
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = state == ThemeMode.dark;
    final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
    await prefs.setString(_themeKey, isDark ? 'light' : 'dark');
    emit(newMode);
  }
}