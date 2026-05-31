import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/l10n/app_localizations.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/core/theme/theme_mode_controller.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GalleryPage extends ConsumerStatefulWidget {
  const GalleryPage({super.key});

  @override
  ConsumerState<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends ConsumerState<GalleryPage> {
  static const _chartData = <AppChartDatum>[
    AppChartDatum(label: 'Design', value: 35),
    AppChartDatum(label: 'Engineering', value: 50),
    AppChartDatum(label: 'Growth', value: 15),
  ];

  String? _selectedOption;
  int _count = 1;
  bool _showOverlay = false;

  void _flashOverlay() {
    setState(() => _showOverlay = true);
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showOverlay = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final trendPoints = <AppTrendPoint>[
      AppTrendPoint(date: DateTime(2026), value: 12),
      AppTrendPoint(date: DateTime(2026, 2), value: 18),
      AppTrendPoint(date: DateTime(2026, 3), value: 9),
      AppTrendPoint(date: DateTime(2026, 4), value: 24),
      AppTrendPoint(date: DateTime(2026, 5), value: 20),
    ];

    return AppSliverPage(
      title: context.l10n.gallery,
      subtitle: 'Every shared widget, live',
      actions: [
        IconButton(
          tooltip: 'Toggle theme',
          onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
          icon: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          ),
        ),
      ],
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
              const AppSectionHeader(eyebrow: 'Actions', title: 'Buttons'),
              const SizedBox(height: AppSpacing.pageWithinSectionGap),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  AppButton.primary(label: 'Primary', onPressed: () {}),
                  AppButton.secondary(label: 'Secondary', onPressed: () {}),
                  AppButton.text(label: 'Text', onPressed: () {}),
                  AppButton.danger(label: 'Danger', onPressed: () {}),
                  AppButton.primary(
                    label: 'Icon',
                    icon: Icons.add_rounded,
                    onPressed: () {},
                  ),
                  AppButton.primary(
                    label: 'Loading',
                    loading: true,
                    onPressed: () {},
                  ),
                  const AppButton.primary(label: 'Disabled', onPressed: null),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton.primary(
                label: 'Full width',
                expanded: true,
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.pageBetweenSectionGap),
              const AppSectionHeader(
                eyebrow: 'Inputs',
                title: 'Selection & steppers',
              ),
              const SizedBox(height: AppSpacing.pageWithinSectionGap),
              AppDropdown<String>(
                value: _selectedOption,
                placeholder: const Text('Choose an option'),
                onChanged: (value) => setState(() => _selectedOption = value),
                options: const [
                  AppDropdownOption(value: 'one', child: Text('Option one')),
                  AppDropdownOption(value: 'two', child: Text('Option two')),
                  AppDropdownOption(
                    value: 'three',
                    child: Text('Option three'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageWithinSectionGap),
              AppCounterStepper(
                label: 'Quantity',
                value: _count,
                onDecrement: _count > 0
                    ? () => setState(() => _count -= 1)
                    : null,
                onIncrement: () => setState(() => _count += 1),
              ),
              const SizedBox(height: AppSpacing.pageWithinSectionGap),
              AppCard(
                child: Column(
                  children: [
                    AppKeyValueRow(
                      label: 'Selected',
                      value: _selectedOption ?? 'None',
                    ),
                    AppKeyValueRow(
                      label: 'Quantity',
                      value: '$_count',
                      emphasized: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.pageBetweenSectionGap),
              const AppSectionHeader(
                eyebrow: 'Feedback',
                title: 'Banners & overlays',
              ),
              const SizedBox(height: AppSpacing.pageWithinSectionGap),
              const AppBanner(message: 'Informational message'),
              const SizedBox(height: AppSpacing.sm),
              const AppBanner(
                message: 'Saved successfully',
                variant: AppBannerVariant.success,
              ),
              const SizedBox(height: AppSpacing.sm),
              const AppBanner(
                message: 'Heads up — double-check this',
                variant: AppBannerVariant.warning,
              ),
              const SizedBox(height: AppSpacing.sm),
              const AppBanner(
                message: 'Something went wrong',
                variant: AppBannerVariant.error,
              ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  AppButton.secondary(
                    label: 'Snackbar',
                    onPressed: () =>
                        AppSnackBars.success(context, 'Hello from a snackbar'),
                  ),
                  AppButton.secondary(
                    label: 'Dialog',
                    onPressed: () {
                      unawaited(
                        AppDialog.confirm(
                          context,
                          title: 'Delete item?',
                          message: 'This cannot be undone.',
                          confirmLabel: 'Delete',
                          destructive: true,
                        ),
                      );
                    },
                  ),
                  AppButton.secondary(
                    label: 'Action sheet',
                    onPressed: () {
                      unawaited(
                        AppActionSheet.show(
                          context,
                          title: 'Choose an action',
                          actions: [
                            AppAction(
                              label: 'Share',
                              icon: Icons.ios_share_rounded,
                              onPressed: () {},
                            ),
                            AppAction(
                              label: 'Delete',
                              icon: Icons.delete_outline_rounded,
                              destructive: true,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  AppButton.secondary(
                    label: 'Bottom sheet',
                    onPressed: () {
                      unawaited(
                        AppBottomSheet.show(
                          context,
                          child: const Padding(
                            padding: EdgeInsets.all(AppSpacing.lg),
                            child: Text('Custom bottom sheet content'),
                          ),
                        ),
                      );
                    },
                  ),
                  AppButton.secondary(
                    label: 'Loading overlay',
                    onPressed: _flashOverlay,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              ClipRRect(
                borderRadius: const BorderRadius.all(AppRadii.lg),
                child: SizedBox(
                  height: AppSizes.chartTrendHeight,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ColoredBox(
                          color: context.colors.surfaceRaised,
                          child: const Center(child: Text('Content area')),
                        ),
                      ),
                      if (_showOverlay)
                        const Positioned.fill(
                          child: AppLoadingOverlay(message: 'Working…'),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.pageBetweenSectionGap),
              const AppSectionHeader(eyebrow: 'Data', title: 'Charts & lists'),
              const SizedBox(height: AppSpacing.pageWithinSectionGap),
              AppCard(child: AppTrendChart(points: trendPoints)),
              const SizedBox(height: AppSpacing.md),
              const AppCard(child: AppRoundedBarChart(values: _chartData)),
              const SizedBox(height: AppSpacing.md),
              const AppCard(child: AppDonutChart(values: _chartData)),
              const SizedBox(height: AppSpacing.lg),
              AppListSection(
                header: 'List section',
                children: [
                  AppTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: 'Settings',
                    subtitle: 'Tappable row with a chevron',
                    onTap: () {},
                  ),
                  const AppTile(
                    leading: Icon(Icons.info_outline_rounded),
                    title: 'About',
                    showChevron: false,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                child: SizedBox(
                  height: 320,
                  child: AppEmptyState(
                    icon: Icons.inbox_outlined,
                    title: 'Nothing here yet',
                    description:
                        'Empty-state placeholder for zero-data screens.',
                    action: AppButton.primary(
                      label: 'Add item',
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSkeleton(width: 160),
                    SizedBox(height: AppSpacing.sm),
                    AppSkeleton(),
                    SizedBox(height: AppSpacing.sm),
                    AppSkeleton(width: 220),
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
