import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';

/// An iOS-style grouped list: an optional header above a rounded surface that
/// holds [AppTile]s separated by inset hairline dividers.
class AppListSection extends StatelessWidget {
  const AppListSection({required this.children, this.header, super.key});

  final String? header;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null) ...[
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.md,
              bottom: AppSpacing.sm,
            ),
            child: Text(header!.toUpperCase(), style: context.labelStrong),
          ),
        ],
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: const BorderRadius.all(AppRadii.lg),
            boxShadow: AppShadows.soft,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(AppRadii.lg),
            child: Column(
              children: [
                for (final (index, child) in children.indexed) ...[
                  child,
                  if (index != children.length - 1)
                    Divider(
                      height: AppSizes.chartHairline,
                      thickness: AppSizes.chartHairline,
                      indent: AppSpacing.lg,
                      color: context.colors.border,
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
