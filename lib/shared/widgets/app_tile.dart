import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';

/// A single list row: optional leading, title/subtitle, and a trailing widget
/// (defaults to a chevron when tappable). Designed to sit inside
/// [AppListSection], which supplies the grouped surface and dividers.
class AppTile extends StatelessWidget {
  const AppTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.showChevron = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final effectiveTrailing =
        trailing ??
        (onTap != null && showChevron
            ? Icon(Icons.chevron_right_rounded, color: context.colors.textMuted)
            : null);

    final row = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
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
          if (effectiveTrailing != null) ...[
            const SizedBox(width: AppSpacing.md),
            effectiveTrailing,
          ],
        ],
      ),
    );

    if (onTap == null) {
      return row;
    }
    return InkWell(onTap: onTap, child: row);
  }
}
