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
  static const Color canvas = Color(0xFF09090B);
  static const Color surface = Color(0xFF18181B);
  static const Color surfaceRaised = Color(0xFF27272A);
  static const Color surfaceStrong = Color(0xFF3F3F46);
  static const Color border = Color(0xFF27272A);
  static const Color borderStrong = Color(0xFF52525B);
  static const Color textPrimary = Color(0xFFFAFAFA);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textMuted = Color(0xFF71717A);
  static const Color accent = Color(0xFF3B82F6);
  static const Color onAccent = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF4ADE80);
  static const Color info = Color(0xFF60A5FA);
  static const Color error = Color(0xFFF87171);
  static const Color divider = Color(0xFF27272A);
  static const Color sheet = surface;
}
