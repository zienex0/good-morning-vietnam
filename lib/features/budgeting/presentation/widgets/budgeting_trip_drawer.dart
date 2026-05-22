import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/result/failure_messages.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/budgeting_trip_form_controller.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_mappers.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_snack_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BudgetingTripDrawer extends ConsumerWidget {
  const BudgetingTripDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(tripsListProvider);
    final activeId = ref.watch(activeTripIdProvider);
    final trips = tripsAsync.valueOrNull ?? const <Trip>[];

    return Drawer(
      backgroundColor: AppColors.sheet,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.page),
          children: [
            const DrawerSectionTitle('YOUR TRIPS'),
            const SizedBox(height: AppSpacing.md),
            if (trips.isEmpty)
              Text(
                'No trips yet.',
                style: context.mutedText.bodyMedium,
              )
            else
              for (final trip in trips)
                DrawerTripTile(trip: trip, isActive: trip.id == activeId),
            const SizedBox(height: AppSpacing.md),
            DrawerActionTile(
              icon: Icons.add,
              label: 'start new trip',
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.newTrip);
              },
            ),
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

class DrawerTripTile extends ConsumerWidget {
  const DrawerTripTile({
    required this.trip,
    required this.isActive,
    super.key,
  });

  final Trip trip;
  final bool isActive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isActive ? Icons.check_circle : Icons.circle_outlined,
        color: isActive ? AppColors.accent : AppColors.textMuted,
      ),
      title: Text(trip.name, style: context.text.bodyLarge),
      trailing: Text(
        budgetingTripStatusLabel(trip.status),
        style: context.mutedText.bodyMedium,
      ),
      onTap: isActive
          ? () => Navigator.pop(context)
          : () => _activate(context, ref, trip),
    );
  }

  Future<void> _activate(
    BuildContext context,
    WidgetRef ref,
    Trip trip,
  ) async {
    Navigator.pop(context);
    final controller = ref.read(budgetingTripFormControllerProvider.notifier);
    final ok = await controller.activateTrip(trip.id);
    if (!context.mounted || ok) return;
    final error = ref.read(budgetingTripFormControllerProvider).error;
    if (error is Failure) {
      AppSnackBars.error(context, failureMessage(error));
    }
  }
}

class DrawerActionTile extends StatelessWidget {
  const DrawerActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label, style: context.text.bodyLarge),
      onTap: onTap,
    );
  }
}
