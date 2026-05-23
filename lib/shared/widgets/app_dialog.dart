import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_button.dart';

/// Themed alert/confirm dialogs. Use these instead of calling [showDialog]
/// directly so every dialog shares the same shape, spacing, and buttons.
abstract final class AppDialog {
  /// Shows a confirm dialog and resolves to `true` only if the user confirms.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    String? message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool destructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _AppDialogBody(
        title: title,
        message: message,
        actions: [
          AppButton.text(
            label: cancelLabel,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          if (destructive)
            AppButton.danger(
              label: confirmLabel,
              onPressed: () => Navigator.of(context).pop(true),
            )
          else
            AppButton.primary(
              label: confirmLabel,
              onPressed: () => Navigator.of(context).pop(true),
            ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Shows a single-button informational dialog.
  static Future<void> alert(
    BuildContext context, {
    required String title,
    String? message,
    String dismissLabel = 'OK',
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => _AppDialogBody(
        title: title,
        message: message,
        actions: [
          AppButton.primary(
            label: dismissLabel,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _AppDialogBody extends StatelessWidget {
  const _AppDialogBody({
    required this.title,
    required this.message,
    required this.actions,
  });

  final String title;
  final String? message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(AppSpacing.xl),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: context.titleStrong),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(message!, style: context.secondaryText.bodyMedium),
            ],
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (final (index, action) in actions.indexed) ...[
                  if (index != 0) const SizedBox(width: AppSpacing.sm),
                  action,
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
