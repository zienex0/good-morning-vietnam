import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';

class AppBottomActionBar extends StatelessWidget {
  const AppBottomActionBar({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.sheet,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.lg,
            AppSpacing.page,
            AppSpacing.lg,
          ),
          child: child,
        ),
      ),
    );
  }
}
