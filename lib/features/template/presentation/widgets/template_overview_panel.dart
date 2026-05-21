import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/l10n/app_localizations.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_placeholder_panel.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_snack_bar.dart';
import 'package:flutter_foundation_kit/shared/widgets/section_header.dart';

class TemplateOverviewPanel extends StatelessWidget {
  const TemplateOverviewPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          eyebrow: 'Reusable baseline',
          title: context.l10n.templateTitle,
          body: context.l10n.templateDescription,
          trailing: IconButton(
            tooltip: 'Show snackbar',
            onPressed: () {
              AppSnackBars.info(context, 'Shared snack bars are wired in.');
            },
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ),
        const SizedBox(height: AppSpacing.pageWithinSectionGap),
        const AppPlaceholderPanel(
          icon: Icons.foundation_rounded,
          title: 'Core setup',
          height: AppSizes.chartTrendHeight,
          trailing: Icon(Icons.auto_awesome_rounded),
        ),
      ],
    );
  }
}
