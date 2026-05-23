import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/l10n/app_localizations.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/template/application/template_providers.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_receipt.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_track.dart';
import 'package:flutter_foundation_kit/features/template/presentation/template_formatters.dart';
import 'package:flutter_foundation_kit/features/template/presentation/template_mappers.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TemplateHomePage extends ConsumerWidget {
  const TemplateHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(templateControllerProvider);
    final controller = ref.read(templateControllerProvider.notifier);
    final isBusy = asyncState.isLoading;

    return AppAsyncValueView(
      value: asyncState,
      onRetry: () => ref.invalidate(templateControllerProvider),
      data: (state) {
        final receipt = state.receipt;
        final confirmedCount =
            ref.watch(templateConfirmedCountProvider).value ?? 0;

        return AppSliverPage(
          title: context.l10n.appName,
          subtitle: context.l10n.templateSubtitle,
          bottomNavigationBar: AppBottomActionBar(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total due', style: context.mutedText.labelLarge),
                      Text(
                        formatTemplateMoney(receipt.total),
                        style: context.titleStrong,
                      ),
                    ],
                  ),
                ),
                AppButton.primary(
                  label: 'Confirm',
                  loading: isBusy,
                  onPressed: () async {
                    final confirmed = await AppDialog.confirm(
                      context,
                      title: 'Confirm receipt?',
                      message:
                          'This confirms the sample receipt for '
                          '${formatTemplateMoney(receipt.total)}.',
                    );
                    if (!confirmed) {
                      return;
                    }
                    unawaited(controller.confirmReceipt());
                    if (context.mounted) {
                      AppSnackBars.success(
                        context,
                        'Sample receipt confirmed for '
                        '${formatTemplateMoney(receipt.total)}.',
                      );
                    }
                  },
                ),
              ],
            ),
          ),
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
                    message:
                        'This is the template feature — copy its shape for '
                        'new ones.',
                  ),
                  const SizedBox(height: AppSpacing.pageWithinSectionGap),
                  AppSectionHeader(
                    eyebrow: 'Reusable baseline',
                    title: context.l10n.templateTitle,
                    body: context.l10n.templateDescription,
                    trailing: IconButton(
                      tooltip: 'More',
                      onPressed: () {
                        unawaited(
                          AppActionSheet.show(
                            context,
                            title: 'Demo actions',
                            actions: [
                              AppAction(
                                label: 'Show info snackbar',
                                icon: Icons.info_outline_rounded,
                                onPressed: () => AppSnackBars.info(
                                  context,
                                  'Shared snack bars are wired in.',
                                ),
                              ),
                              AppAction(
                                label: 'Show success snackbar',
                                icon: Icons.check_circle_outline_rounded,
                                onPressed: () => AppSnackBars.success(
                                  context,
                                  'Action sheets are wired in too.',
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.more_horiz_rounded),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageWithinSectionGap),
                  const AppListSection(
                    children: [
                      AppTile(
                        leading: Icon(Icons.foundation_rounded),
                        title: 'Core setup',
                        subtitle: 'Reusable building blocks, ready to copy',
                        showChevron: false,
                      ),
                      AppTile(
                        leading: Icon(Icons.auto_awesome_rounded),
                        title: 'Theme-driven styling',
                        subtitle: 'Tweak tokens once, every widget follows',
                        showChevron: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.pageBetweenSectionGap),
                  const AppSectionHeader(
                    eyebrow: 'Setup',
                    title: 'Project plan',
                  ),
                  const SizedBox(height: AppSpacing.pageWithinSectionGap),
                  AppDropdown<ProjectTrack>(
                    value: state.track,
                    placeholder: const Text('Choose track'),
                    showNoneOption: false,
                    onChanged: (track) => unawaited(controller.setTrack(track)),
                    options: [
                      for (final track in ProjectTrack.values)
                        AppDropdownOption(
                          value: track,
                          child: Row(
                            children: [
                              Icon(
                                projectTrackIcon(track),
                                size: AppSizes.iconMd,
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Text(formatProjectTrackLabel(track)),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.pageWithinSectionGap),
                  AppCounterStepper(
                    label: 'Seats',
                    value: state.seats,
                    onDecrement:
                        !isBusy && state.seats > TemplateController.minSeats
                        ? () => unawaited(controller.decrementSeats())
                        : null,
                    onIncrement:
                        !isBusy && state.seats < TemplateController.maxSeats
                        ? () => unawaited(controller.incrementSeats())
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.pageWithinSectionGap),
                  AppCard(
                    child: Column(
                      children: [
                        AppKeyValueRow(
                          label: 'Plan',
                          value: formatProjectTrackLabel(state.track),
                        ),
                        AppKeyValueRow(
                          label: 'Team seats',
                          value: state.seats.toString(),
                        ),
                        AppKeyValueRow(
                          label: 'Seat rate',
                          value: formatTemplateMoney(ProjectReceipt.seatPrice),
                        ),
                        AppKeyValueRow(
                          label: 'Seat subtotal',
                          value: formatTemplateMoney(receipt.seatSubtotal),
                        ),
                        AppKeyValueRow(
                          label: 'Template toolkit',
                          value: formatTemplateMoney(
                            ProjectReceipt.platformFee,
                          ),
                        ),
                        AppKeyValueRow(
                          label: 'Track add-on',
                          value: formatTemplateMoney(receipt.trackAddOn),
                        ),
                        AppKeyValueRow(
                          label: 'Priority support',
                          value: formatTemplateMoney(
                            ProjectReceipt.prioritySupport,
                          ),
                        ),
                        AppKeyValueRow(
                          label: 'Template credit',
                          value:
                              '-${formatTemplateMoney(ProjectReceipt.templateCredit)}',
                        ),
                        const Divider(),
                        AppKeyValueRow(
                          label: 'Total due',
                          value: formatTemplateMoney(receipt.total),
                          emphasized: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageBetweenSectionGap),
                  const AppSectionHeader(
                    eyebrow: 'State',
                    title: 'Reactive streams alongside controller state',
                    body:
                        'The confirmed count arrives via a stream provider '
                        'backed by a use case. The controller never tracks it '
                        'locally — the stream delivers it reactively to any '
                        'widget that watches.',
                  ),
                  const SizedBox(height: AppSpacing.pageWithinSectionGap),
                  AppListSection(
                    children: [
                      AppTile(
                        leading: const Icon(Icons.task_alt_rounded),
                        title: 'Confirmed receipts',
                        subtitle: confirmedCount.toString(),
                        showChevron: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.pageBetweenSectionGap),
                  const AppSectionHeader(
                    eyebrow: 'Navigation',
                    title: 'Push a detail screen',
                    body:
                        'Tap below to push a route with a slide transition and '
                        'a back button.',
                  ),
                  const SizedBox(height: AppSpacing.pageWithinSectionGap),
                  AppListSection(
                    children: [
                      AppTile(
                        leading: const Icon(Icons.open_in_new_rounded),
                        title: 'View details',
                        subtitle: 'Opens /details/template',
                        onTap: () => unawaited(
                          context.push(AppRoutes.detailsFor('template')),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
