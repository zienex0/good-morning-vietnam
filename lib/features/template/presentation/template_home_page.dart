import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/l10n/app_localizations.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/template/application/template_controller.dart';
import 'package:flutter_foundation_kit/features/template/presentation/template_formatters.dart';
import 'package:flutter_foundation_kit/features/template/presentation/widgets/template_overview_panel.dart';
import 'package:flutter_foundation_kit/features/template/presentation/widgets/template_project_setup_section.dart';
import 'package:flutter_foundation_kit/features/template/presentation/widgets/template_receipt_action_bar.dart';
import 'package:flutter_foundation_kit/features/template/presentation/widgets/template_state_section.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_bottom_action_bar.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_sliver_page.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_snack_bar.dart';
import 'package:flutter_foundation_kit/shared/widgets/async_value_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TemplateHomePage extends ConsumerWidget {
  const TemplateHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(templateControllerProvider);
    final controller = ref.read(templateControllerProvider.notifier);
    final isBusy = asyncState.isLoading;

    return AsyncValueView(
      value: asyncState,
      onRetry: () => ref.invalidate(templateControllerProvider),
      data: (state) {
        final receipt = state.receipt;

        return AppSliverPage(
          title: context.l10n.appName,
          subtitle: context.l10n.templateSubtitle,
          bottomNavigationBar: AppBottomActionBar(
            child: TemplateReceiptActionBar(
              total: receipt.total,
              isBusy: isBusy,
              onConfirm: () {
                unawaited(controller.confirmReceipt());
                AppSnackBars.success(
                  context,
                  'Sample receipt confirmed for '
                  '${formatTemplateMoney(receipt.total)}.',
                );
              },
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
                  const TemplateOverviewPanel(),
                  const SizedBox(height: AppSpacing.pageBetweenSectionGap),
                  TemplateProjectSetupSection(
                    receipt: receipt,
                    selectedTrack: state.track,
                    seats: state.seats,
                    canDecrementSeats:
                        !isBusy && state.seats > TemplateController.minSeats,
                    canIncrementSeats:
                        !isBusy && state.seats < TemplateController.maxSeats,
                    onTrackChanged: (track) {
                      unawaited(controller.setTrack(track));
                    },
                    onDecrementSeats: () {
                      unawaited(controller.decrementSeats());
                    },
                    onIncrementSeats: () {
                      unawaited(controller.incrementSeats());
                    },
                  ),
                  const SizedBox(height: AppSpacing.pageBetweenSectionGap),
                  TemplateStateSection(
                    confirmedCount:
                        ref.watch(templateConfirmedCountProvider).valueOrNull ??
                        0,
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
