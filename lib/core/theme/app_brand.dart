import 'package:flutter/material.dart';

/// Product-facing brand tokens that are expected to change between apps.
///
/// Keep these values separate from [buildAppTheme] so a new app can rebrand
/// the foundation without digging through every component override.
abstract final class AppBrand {
  static const String appName = 'Flutter Foundation Kit';
  static const String fontFamily = 'GoogleSans';
}

abstract final class AppColors {
  static const Color canvas = Color(0xFFF8F5F0);
  static const Color surface = Color(0xFFFFFCF7);
  static const Color surfaceRaised = Color(0xFFF1EDE6);
  static const Color surfaceStrong = Color(0xFFE8E1D8);
  static const Color border = Color(0xFFDCD3C8);
  static const Color borderStrong = Color(0xFFB0B0B0);
  static const Color textPrimary = Color(0xFF222222);
  static const Color textSecondary = Color(0xFF484848);
  static const Color textMuted = Color(0xFF717171);
  static const Color accent = Color(0xFFFF385C);
  static const Color onAccent = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF22C55E);
  static const Color info = Color(0xFF3B82F6);
  static const Color error = Color(0xFFC13515);
  static const Color divider = Color(0xFFE8E1D8);
  static const Color sheet = surface;
}
