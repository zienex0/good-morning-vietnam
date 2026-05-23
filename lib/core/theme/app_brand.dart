import 'package:flutter/material.dart';

/// Product-facing brand tokens that are expected to change between apps.
///
/// Keep these values separate from the theme so a new app can rebrand the
/// foundation without digging through every component override.
abstract final class AppBrand {
  static const String appName = 'Flutter Foundation Kit';
  static const String fontFamily = 'GoogleSans';
}

/// The semantic color set, attached to [ThemeData] as a [ThemeExtension] so it
/// flips with the active brightness. Read it in widgets via `context.colors`.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.brightness,
    required this.canvas,
    required this.surface,
    required this.surfaceRaised,
    required this.surfaceStrong,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accent,
    required this.onAccent,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.success,
    required this.info,
    required this.warning,
    required this.error,
    required this.divider,
    required this.sheet,
    required this.chartPalette,
  });

  final Brightness brightness;
  final Color canvas;
  final Color surface;
  final Color surfaceRaised;
  final Color surfaceStrong;
  final Color border;
  final Color borderStrong;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accent;
  final Color onAccent;

  /// A high-contrast surface for inverse elements (snackbars, tooltips).
  final Color inverseSurface;
  final Color onInverseSurface;

  final Color success;
  final Color info;
  final Color warning;
  final Color error;
  final Color divider;
  final Color sheet;

  /// Categorical colors charts cycle through when a datum has no explicit color.
  final List<Color> chartPalette;

  static const List<Color> _chartPalette = [
    Color(0xFFFF385C),
    Color(0xFF3B82F6),
    Color(0xFF22C55E),
    Color(0xFF8B5CF6),
    Color(0xFFF59E0B),
    Color(0xFF14B8A6),
  ];

  static const AppPalette light = AppPalette(
    brightness: Brightness.light,
    canvas: Color(0xFFFAFAFA),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFF4F4F5),
    surfaceStrong: Color(0xFFE4E4E7),
    border: Color(0xFFECECEE),
    borderStrong: Color(0xFFD4D4D8),
    textPrimary: Color(0xFF18181B),
    textSecondary: Color(0xFF3F3F46),
    textMuted: Color(0xFF71717A),
    accent: Color(0xFF007AFF),
    onAccent: Color(0xFFFFFFFF),
    inverseSurface: Color(0xFF18181B),
    onInverseSurface: Color(0xFFFAFAFA),
    success: Color(0xFF22C55E),
    info: Color(0xFF3B82F6),
    warning: Color(0xFFF59E0B),
    error: Color(0xFFEF4444),
    divider: Color(0xFFECECEE),
    sheet: Color(0xFFFFFFFF),
    chartPalette: _chartPalette,
  );

  static const AppPalette dark = AppPalette(
    brightness: Brightness.dark,
    canvas: Color(0xFF0B0B0C),
    surface: Color(0xFF161618),
    surfaceRaised: Color(0xFF1F1F22),
    surfaceStrong: Color(0xFF2A2A2E),
    border: Color(0xFF2A2A2E),
    borderStrong: Color(0xFF3A3A3F),
    textPrimary: Color(0xFFFAFAFA),
    textSecondary: Color(0xFFC4C4C8),
    textMuted: Color(0xFF8A8A90),
    accent: Color(0xFF007AFF),
    onAccent: Color(0xFFFFFFFF),
    inverseSurface: Color(0xFFFAFAFA),
    onInverseSurface: Color(0xFF18181B),
    success: Color(0xFF22C55E),
    info: Color(0xFF3B82F6),
    warning: Color(0xFFF59E0B),
    error: Color(0xFFEF4444),
    divider: Color(0xFF2A2A2E),
    sheet: Color(0xFF161618),
    chartPalette: _chartPalette,
  );

  @override
  AppPalette copyWith({
    Brightness? brightness,
    Color? canvas,
    Color? surface,
    Color? surfaceRaised,
    Color? surfaceStrong,
    Color? border,
    Color? borderStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? accent,
    Color? onAccent,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? success,
    Color? info,
    Color? warning,
    Color? error,
    Color? divider,
    Color? sheet,
    List<Color>? chartPalette,
  }) {
    return AppPalette(
      brightness: brightness ?? this.brightness,
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceStrong: surfaceStrong ?? this.surfaceStrong,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      inverseSurface: inverseSurface ?? this.inverseSurface,
      onInverseSurface: onInverseSurface ?? this.onInverseSurface,
      success: success ?? this.success,
      info: info ?? this.info,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      divider: divider ?? this.divider,
      sheet: sheet ?? this.sheet,
      chartPalette: chartPalette ?? this.chartPalette,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) {
      return this;
    }
    return AppPalette(
      brightness: t < 0.5 ? brightness : other.brightness,
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      surfaceStrong: Color.lerp(surfaceStrong, other.surfaceStrong, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      inverseSurface: Color.lerp(inverseSurface, other.inverseSurface, t)!,
      onInverseSurface: Color.lerp(
        onInverseSurface,
        other.onInverseSurface,
        t,
      )!,
      success: Color.lerp(success, other.success, t)!,
      info: Color.lerp(info, other.info, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      sheet: Color.lerp(sheet, other.sheet, t)!,
      chartPalette: t < 0.5 ? chartPalette : other.chartPalette,
    );
  }
}
