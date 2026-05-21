import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_mock_data.dart';

class BudgetingTripDrawer extends StatelessWidget {
  const BudgetingTripDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.sheet,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.page),
          children: [
            const DrawerSectionTitle('YOUR TRIPS'),
            const SizedBox(height: AppSpacing.md),
            for (final trip in mockDrawerTrips) DrawerTripTile(trip: trip),
            const SizedBox(height: AppSpacing.md),
            const DrawerActionTile(icon: Icons.add, label: 'start new trip'),
            const Divider(),
            const DrawerActionTile(
              icon: Icons.tune_outlined,
              label: 'app preferences',
            ),
            const DrawerActionTile(icon: Icons.help_outline, label: 'about'),
          ],
        ),
      ),
    );
  }
}

class DrawerSectionTitle extends StatelessWidget {
  const DrawerSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: context.labelStrong);
  }
}

class DrawerTripTile extends StatelessWidget {
  const DrawerTripTile({required this.trip, super.key});

  final MockDrawerTrip trip;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        trip.selected ? Icons.check_circle : Icons.circle_outlined,
        color: trip.selected ? AppColors.accent : AppColors.textMuted,
      ),
      title: Text(trip.name, style: context.text.bodyLarge),
      trailing: Text(trip.status, style: context.mutedText.bodyMedium),
      onTap: () => Navigator.pop(context),
    );
  }
}

class DrawerActionTile extends StatelessWidget {
  const DrawerActionTile({required this.icon, required this.label, super.key});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label, style: context.text.bodyLarge),
      onTap: () => Navigator.pop(context),
    );
  }
}
