import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';

enum AppSnackBarVariant { info, success, error }

abstract final class AppSnackBars {
  static void info(BuildContext context, String message) {
    show(context, message: message);
  }

  static void success(BuildContext context, String message) {
    show(context, message: message, variant: AppSnackBarVariant.success);
  }

  static void error(BuildContext context, String message) {
    show(context, message: message, variant: AppSnackBarVariant.error);
  }

  static void show(
    BuildContext context, {
    required String message,
    AppSnackBarVariant variant = AppSnackBarVariant.info,
    Duration duration = AppDurations.snackBarDisplay,
    bool autoDismiss = true,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: autoDismiss ? duration : const Duration(days: 1),
          backgroundColor: context.colors.inverseSurface,
          showCloseIcon: true,
          content: Row(
            children: [
              Icon(_icon(variant), color: _accentColor(context, variant)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(message)),
            ],
          ),
        ),
        snackBarAnimationStyle: const AnimationStyle(
          curve: Curves.easeOutBack,
          duration: AppDurations.snackBarEntrance,
          reverseCurve: Curves.easeInCubic,
          reverseDuration: AppDurations.snackBarExit,
        ),
      );
  }

  static Color _accentColor(BuildContext context, AppSnackBarVariant variant) =>
      switch (variant) {
        AppSnackBarVariant.info => context.colors.info,
        AppSnackBarVariant.success => context.colors.success,
        AppSnackBarVariant.error => context.colors.error,
      };

  static IconData _icon(AppSnackBarVariant variant) => switch (variant) {
    AppSnackBarVariant.info => Icons.info_outline_rounded,
    AppSnackBarVariant.success => Icons.check_circle_outline_rounded,
    AppSnackBarVariant.error => Icons.error_outline_rounded,
  };
}
