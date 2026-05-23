import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';

/// A clean rounded surface with soft elevation. The default container for
/// grouped content — use it instead of hand-rolling a `Container` decoration.
class AppCard extends StatelessWidget {
  const AppCard({required this.child, this.onTap, super.key});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: child,
    );

    if (onTap != null) {
      content = Material(
        type: MaterialType.transparency,
        child: InkWell(onTap: onTap, child: content),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.all(AppRadii.lg),
        boxShadow: AppShadows.soft,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(AppRadii.lg),
        child: content,
      ),
    );
  }
}
