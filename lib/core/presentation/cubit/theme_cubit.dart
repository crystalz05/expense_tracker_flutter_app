// lib/core/presentation/cubit/theme_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeState { light, dark, system }

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences prefs;
  static const String _themeKey = 'theme_mode';

  ThemeCubit(this.prefs) : super(ThemeState.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final themeString = prefs.getString(_themeKey);
    if (themeString != null) {
      emit(
        ThemeState.values.firstWhere(
          (e) => e.toString() == themeString,
          orElse: () => ThemeState.system,
        ),
      );
    }
  }

  Future<void> setTheme(ThemeState theme) async {
    await prefs.setString(_themeKey, theme.toString());
    emit(theme);
  }

  ThemeMode get themeMode {
    switch (state) {
      case ThemeState.light:
        return ThemeMode.light;
      case ThemeState.dark:
        return ThemeMode.dark;
      case ThemeState.system:
        return ThemeMode.system;
    }
  }
}
