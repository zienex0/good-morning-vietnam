import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/l10n/app_localizations.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';

class TemplateDetailPage extends StatelessWidget {
  const TemplateDetailPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    return AppSliverPage(
      title: context.l10n.details,
      subtitle: 'Pushed over the tab shell',
      leading: const AppBackButton(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.pageWithinSectionGap,
            AppSpacing.page,
            AppSpacing.pageBetweenSectionGap,
          ),
          sliver: SliverList.list(
            children: [
              const AppBanner(
                message: 'Reached via context.push with a slide transition.',
              ),
              const SizedBox(height: AppSpacing.pageWithinSectionGap),
              AppCard(
                child: Column(
                  children: [
                    const AppKeyValueRow(label: 'Route', value: '/details/:id'),
                    AppKeyValueRow(label: 'Received id', value: id),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
