import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';

class AppPlaceholderPanel extends StatelessWidget {
  const AppPlaceholderPanel({
    required this.icon,
    this.height,
    this.title,
    this.trailing,
    this.borderRadius = const BorderRadius.all(AppRadii.xl),
    this.padding = const EdgeInsets.all(AppSpacing.none),
    super.key,
  });

  final IconData icon;
  final double? height;
  final String? title;
  final Widget? trailing;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: borderRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: padding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: AppSizes.avatarMd,
                    color: AppColors.textMuted,
                  ),
                  if (title != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(title!, style: context.text.titleSmall),
                  ],
                ],
              ),
            ),
          ),
          if (trailing != null)
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: trailing!,
            ),
        ],
      ),
    );
  }
}
