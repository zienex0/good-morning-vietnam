import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';

enum AppBannerVariant { info, success, warning, error }

/// A persistent inline message strip. Use this for status that should stay on
/// screen; use `AppSnackBars` for transient toasts.
class AppBanner extends StatelessWidget {
  const AppBanner({
    required this.message,
    this.variant = AppBannerVariant.info,
    this.onClose,
    super.key,
  });

  final String message;
  final AppBannerVariant variant;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final color = switch (variant) {
      AppBannerVariant.info => context.colors.info,
      AppBannerVariant.success => context.colors.success,
      AppBannerVariant.warning => context.colors.warning,
      AppBannerVariant.error => context.colors.error,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.all(AppRadii.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(_icon, color: color, size: AppSizes.iconMd),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(message, style: context.text.bodyMedium)),
            if (onClose != null) ...[
              const SizedBox(width: AppSpacing.sm),
              GestureDetector(
                onTap: onClose,
                child: Icon(
                  Icons.close_rounded,
                  color: context.colors.textMuted,
                  size: AppSizes.iconSm,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData get _icon => switch (variant) {
    AppBannerVariant.info => Icons.info_outline_rounded,
    AppBannerVariant.success => Icons.check_circle_outline_rounded,
    AppBannerVariant.warning => Icons.warning_amber_rounded,
    AppBannerVariant.error => Icons.error_outline_rounded,
  };
}
