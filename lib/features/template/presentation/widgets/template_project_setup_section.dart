import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_receipt.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_track.dart';
import 'package:flutter_foundation_kit/features/template/presentation/template_formatters.dart';
import 'package:flutter_foundation_kit/features/template/presentation/widgets/template_track_option.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_counter_stepper.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_dropdown.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_key_value_row.dart';
import 'package:flutter_foundation_kit/shared/widgets/section_header.dart';

class TemplateProjectSetupSection extends StatelessWidget {
  const TemplateProjectSetupSection({
    required this.receipt,
    required this.selectedTrack,
    required this.seats,
    required this.canDecrementSeats,
    required this.canIncrementSeats,
    required this.onTrackChanged,
    required this.onDecrementSeats,
    required this.onIncrementSeats,
    super.key,
  });

  final ProjectReceipt receipt;
  final ProjectTrack? selectedTrack;
  final int seats;
  final bool canDecrementSeats;
  final bool canIncrementSeats;
  final ValueChanged<ProjectTrack?> onTrackChanged;
  final VoidCallback onDecrementSeats;
  final VoidCallback onIncrementSeats;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(eyebrow: 'Setup', title: 'Project plan'),
        const SizedBox(height: AppSpacing.pageWithinSectionGap),
        AppDropdown<ProjectTrack>(
          value: selectedTrack,
          placeholder: const Text('Choose track'),
          showNoneOption: false,
          onChanged: onTrackChanged,
          options: const [
            AppDropdownOption(
              value: ProjectTrack.design,
              child: TemplateTrackOption(track: ProjectTrack.design),
            ),
            AppDropdownOption(
              value: ProjectTrack.engineering,
              child: TemplateTrackOption(track: ProjectTrack.engineering),
            ),
            AppDropdownOption(
              value: ProjectTrack.growth,
              child: TemplateTrackOption(track: ProjectTrack.growth),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageWithinSectionGap),
        AppCounterStepper(
          label: 'Seats',
          value: seats,
          onDecrement: canDecrementSeats ? onDecrementSeats : null,
          onIncrement: canIncrementSeats ? onIncrementSeats : null,
        ),
        const Divider(),
        AppKeyValueRow(
          label: 'Plan',
          value: formatProjectTrackLabel(selectedTrack),
        ),
        AppKeyValueRow(label: 'Team seats', value: seats.toString()),
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
          value: formatTemplateMoney(ProjectReceipt.platformFee),
        ),
        AppKeyValueRow(
          label: 'Track add-on',
          value: formatTemplateMoney(receipt.trackAddOn),
        ),
        AppKeyValueRow(
          label: 'Priority support',
          value: formatTemplateMoney(ProjectReceipt.prioritySupport),
        ),
        AppKeyValueRow(
          label: 'Template credit',
          value: '-${formatTemplateMoney(ProjectReceipt.templateCredit)}',
        ),
        const Divider(),
        AppKeyValueRow(
          label: 'Total due',
          value: formatTemplateMoney(receipt.total),
          labelStyle: context.text.titleMedium,
          valueStyle: context.titleStrong,
        ),
      ],
    );
  }
}
