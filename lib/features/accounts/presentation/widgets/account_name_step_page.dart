import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';

class AccountNameStepPage extends StatelessWidget {
  const AccountNameStepPage({
    required this.nameController,
    required this.autofocus,
    super.key,
  });

  final TextEditingController nameController;
  final bool autofocus;

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
          const AppSectionHeader(title: 'Account name'),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: nameController,
            autofocus: autofocus,
            textCapitalization: TextCapitalization.words,
            style: context.text.displaySmall,
            decoration: const InputDecoration(
              hintText: 'Cash, card, bank...',
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
