import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';

enum _AppButtonVariant { primary, secondary, text, danger }

/// The app's button. Pick a variant by constructor; pass [loading] to show a
/// spinner and disable, [expanded] to fill the available width. All styling
/// comes from the theme — there are no color or shape knobs.
class AppButton extends StatelessWidget {
  const AppButton.primary({
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expanded = false,
    super.key,
  }) : _variant = _AppButtonVariant.primary;

  const AppButton.secondary({
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expanded = false,
    super.key,
  }) : _variant = _AppButtonVariant.secondary;

  const AppButton.text({
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expanded = false,
    super.key,
  }) : _variant = _AppButtonVariant.text;

  /// A filled button for destructive actions (delete, remove, etc.).
  const AppButton.danger({
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expanded = false,
    super.key,
  }) : _variant = _AppButtonVariant.danger;

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final bool expanded;
  final _AppButtonVariant _variant;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = loading ? null : onPressed;
    final Widget child = loading
        ? SizedBox.square(
            dimension: AppSizes.iconSm,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: context.colors.accent,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppSizes.iconSm),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(label),
            ],
          );

    final button = switch (_variant) {
      _AppButtonVariant.primary => FilledButton(
        onPressed: effectiveOnPressed,
        child: child,
      ),
      _AppButtonVariant.secondary => OutlinedButton(
        onPressed: effectiveOnPressed,
        child: child,
      ),
      _AppButtonVariant.text => TextButton(
        onPressed: effectiveOnPressed,
        child: child,
      ),
      _AppButtonVariant.danger => FilledButton(
        onPressed: effectiveOnPressed,
        style: FilledButton.styleFrom(
          backgroundColor: context.colors.error,
          foregroundColor: context.colors.onAccent,
          disabledBackgroundColor: context.colors.surfaceStrong,
          disabledForegroundColor: context.colors.textMuted,
        ),
        child: child,
      ),
    };

    if (!expanded) {
      return button;
    }
    return SizedBox(width: double.infinity, child: button);
  }
}
