import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';

class AppIconTextTile extends StatelessWidget {
  const AppIconTextTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget tile = Row(
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: AppSpacing.md),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.bodyLarge,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.mutedText.bodyMedium,
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: AppSpacing.md),
          trailing!,
        ],
      ],
    );

    if (onTap != null) {
      tile = InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(AppRadii.md),
        child: tile,
      );
    }

    return tile;
  }
}
