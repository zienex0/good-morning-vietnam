import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';

class TripNameStepPage extends StatelessWidget {
  const TripNameStepPage({required this.nameController, super.key});

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.pageWithinSectionGap,
        AppSpacing.page,
        AppSpacing.pageBetweenSectionGap,
      ),
      sliver: SliverList.list(
        children: [
          const AppSectionHeader(title: 'Trip name'),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: nameController,
            textCapitalization: TextCapitalization.words,
            style: context.text.displaySmall,
            decoration: const InputDecoration(
              hintText: 'Where are you going?',
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
