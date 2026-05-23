import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_button.dart';

/// A selectable action in an [AppActionSheet].
class AppAction {
  const AppAction({
    required this.label,
    required this.onPressed,
    this.icon,
    this.destructive = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool destructive;
}

/// Themed modal bottom sheets. Use these instead of [showModalBottomSheet]
/// directly so every sheet shares the same handle, shape, and safe-area insets.
///
/// For tall or scrolling content pass `isScrollControlled: true` and a sized
/// child.
abstract final class AppBottomSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    bool isScrollControlled = false,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      builder: (context) => _SheetContainer(child: child),
    );
  }
}

/// An iOS-style action sheet: a list of [AppAction]s plus a cancel button.
abstract final class AppActionSheet {
  static Future<void> show(
    BuildContext context, {
    required List<AppAction> actions,
    String? title,
    String cancelLabel = 'Cancel',
  }) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (context) => _SheetContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.mutedText.labelMedium,
                ),
              ),
            for (final action in actions)
              _ActionRow(
                action: action,
                onTap: () {
                  Navigator.of(context).pop();
                  action.onPressed();
                },
              ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AppButton.secondary(
                label: cancelLabel,
                expanded: true,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetContainer extends StatelessWidget {
  const _SheetContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [const _SheetHandle(), child],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.controlMd,
      height: AppSpacing.xs,
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surfaceStrong,
        borderRadius: const BorderRadius.all(AppRadii.pill),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.action, required this.onTap});

  final AppAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = action.destructive
        ? context.colors.error
        : context.colors.textPrimary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            if (action.icon != null) ...[
              Icon(action.icon, color: color, size: AppSizes.iconMd),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Text(
                action.label,
                style: context.text.bodyLarge?.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
