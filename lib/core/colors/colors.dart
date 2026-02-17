import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  primary: Color(0xFF0A2E5D),
  onPrimary: Colors.white,

  secondary: Color(0xFF2563EB),
  onSecondary: Colors.white,

  surfaceContainer: Color(0xFFEEF1F4),

  surface: Colors.white,
  onSurface: Color(0xFF111827),

  error: Color(0xFFDC2626),
  onError: Colors.white,
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  primary: Color(0xFFFFFFFF),
  onPrimary: Color(0xFF1C1917),

  secondary: Color(0xFF38BDF8),
  onSecondary: Color(0xFF020617),

  surfaceContainer: Color(0xFF14203C),

  surface: Color(0xFF0F172A),
  onSurface: Color(0xFFFFFFFF),

  error: Color(0xFFEF4444),
  onError: Colors.white,
);
