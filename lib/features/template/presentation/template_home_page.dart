import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/l10n/app_localizations.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/template/application/template_controller.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_receipt.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_track.dart';
import 'package:flutter_foundation_kit/features/template/presentation/template_formatters.dart';
import 'package:flutter_foundation_kit/features/template/presentation/template_mappers.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Template home page — copy its shape when creating a new feature.
///
/// Demonstrates the [LocalCrudNotifier] pattern end-to-end:
/// - Form state (track, seats) lives in the widget as local [StatefulWidget]
///   state, because it is transient UI — not business state.
/// - The controller state is the confirmed-receipt list, driven by the
///   repository's watch stream.
/// - Tapping "Confirm" calls [TemplateController.create], which runs
///   [TemplateController.beforeCreate] (validation + stamping) and then
///   persists via the repository. The [Result] drives the snackbar.
class TemplateHomePage extends ConsumerStatefulWidget {
  const TemplateHomePage({super.key});

  @override
  ConsumerState<TemplateHomePage> createState() => _TemplateHomePageState();
}

class _TemplateHomePageState extends ConsumerState<TemplateHomePage> {
  ProjectTrack? _track = ProjectTrack.engineering;
  int _seats = 3;

  ProjectReceipt get _draftReceipt =>
      ProjectReceipt(track: _track, seats: _seats);

  @override
  Widget build(BuildContext context) {
    final asyncReceipts = ref.watch(templateControllerProvider);
    final controller = ref.read(templateControllerProvider.notifier);

    return AppAsyncValueView(
      value: asyncReceipts,
      onRetry: () => ref.invalidate(templateControllerProvider),
      data: (confirmedReceipts) {
        final receipt = _draftReceipt;

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
                  onPressed: () async {
                    final confirmed = await AppDialog.confirm(
                      context,
                      title: 'Confirm receipt?',
                      message:
                          'This confirms the sample receipt for '
                          '${formatTemplateMoney(receipt.total)}.',
                    );
                    if (!confirmed || !context.mounted) return;
                    final result = await controller.create(receipt);
                    if (!context.mounted) return;
                    switch (result) {
                      case Ok():
                        AppSnackBars.success(
                          context,
                          'Receipt confirmed for '
                          '${formatTemplateMoney(receipt.total)}.',
                        );
                      case Err(failure: ValidationFailure(:final message)):
                        AppSnackBars.error(context, message);
                      case Err():
                        AppSnackBars.error(
                          context,
                          'Something went wrong. Please try again.',
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
                    body:
                        'Track and seat count are local form state — they live '
                        'in the widget, not the controller. The controller only '
                        'sees a receipt after "Confirm" is tapped.',
                  ),
                  const SizedBox(height: AppSpacing.pageWithinSectionGap),
                  AppDropdown<ProjectTrack>(
                    value: _track,
                    placeholder: const Text('Choose track'),
                    showNoneOption: false,
                    onChanged: (track) => setState(() => _track = track),
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
                    value: _seats,
                    onDecrement: _seats > TemplateController.minSeats
                        ? () => setState(() => _seats--)
                        : null,
                    onIncrement: _seats < TemplateController.maxSeats
                        ? () => setState(() => _seats++)
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.pageWithinSectionGap),
                  AppCard(
                    child: Column(
                      children: [
                        AppKeyValueRow(
                          label: 'Plan',
                          value: formatProjectTrackLabel(_track),
                        ),
                        AppKeyValueRow(
                          label: 'Team seats',
                          value: _seats.toString(),
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
                    title: 'Reactive list from the repository',
                    body:
                        'The confirmed-receipt count comes directly from the '
                        'controller\'s live list — no stream provider or use '
                        'case needed. Confirm a receipt above to see it '
                        'increment.',
                  ),
                  const SizedBox(height: AppSpacing.pageWithinSectionGap),
                  AppListSection(
                    children: [
                      AppTile(
                        leading: const Icon(Icons.task_alt_rounded),
                        title: 'Confirmed receipts',
                        subtitle: confirmedReceipts.length.toString(),
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
