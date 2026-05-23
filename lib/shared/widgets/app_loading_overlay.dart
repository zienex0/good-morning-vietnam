import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_card.dart';

/// A full-bleed blocking scrim with a centered spinner. Drop it as the last
/// child of a `Stack` while a blocking operation runs:
///
/// ```dart
/// Stack(children: [content, if (isBusy) const AppLoadingOverlay()]);
/// ```
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: SizedBox.expand(
        child: ColoredBox(
          color: context.colors.canvas.withValues(alpha: 0.6),
          child: Center(
            child: AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  if (message != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(message!, style: context.text.bodyMedium),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
