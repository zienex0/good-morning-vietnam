import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_icon_text_tile.dart';
import 'package:flutter_foundation_kit/shared/widgets/section_header.dart';

class TemplateStateSection extends StatelessWidget {
  const TemplateStateSection({required this.confirmedCount, super.key});

  final int confirmedCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(
          eyebrow: 'State',
          title: 'Reactive streams alongside controller state',
          body:
              'The confirmed count arrives via a stream provider backed by a '
              'use case. The controller never tracks it locally — the stream '
              'delivers it reactively to any widget that watches.',
        ),
        const SizedBox(height: AppSpacing.pageWithinSectionGap),
        AppIconTextTile(
          leading: const Icon(Icons.task_alt_rounded),
          title: 'Confirmed receipts',
          subtitle: confirmedCount.toString(),
        ),
      ],
    );
  }
}
