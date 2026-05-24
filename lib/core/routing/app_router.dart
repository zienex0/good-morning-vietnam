import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/accounts/presentation/account_detail_page.dart';
import 'package:flutter_foundation_kit/features/accounts/presentation/account_form_page.dart';
import 'package:flutter_foundation_kit/features/accounts/presentation/accounts_page.dart';
import 'package:flutter_foundation_kit/features/gallery/presentation/gallery_page.dart';
import 'package:flutter_foundation_kit/features/template/presentation/template_detail_page.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/expense_form_page.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/top_up_form_page.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/transfer_form_page.dart';
import 'package:flutter_foundation_kit/features/trips/presentation/trip_dashboard_page.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) => GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppShell(
        navigationShell: navigationShell,
        destinations: const [
          AppShellDestination(
            label: 'Home',
            icon: Icons.home_outlined,
            selectedIcon: Icons.home_rounded,
          ),
          AppShellDestination(
            label: 'Accounts',
            icon: Icons.account_balance_wallet_outlined,
            selectedIcon: Icons.account_balance_wallet,
          ),
          AppShellDestination(
            label: 'Gallery',
            icon: Icons.widgets_outlined,
            selectedIcon: Icons.widgets_rounded,
          ),
        ],
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const TripDashboardPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.accounts,
              builder: (context, state) => const AccountsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.gallery,
              builder: (context, state) => const GalleryPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.newAccount,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const AccountFormPage()),
    ),
    GoRoute(
      path: AppRoutes.newExpense,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const ExpenseFormPage()),
    ),
    GoRoute(
      path: AppRoutes.newTopUp,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const TopUpFormPage()),
    ),
    GoRoute(
      path: AppRoutes.newTransfer,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const TransferFormPage()),
    ),
    GoRoute(
      path: '${AppRoutes.accountDetails}/:id',
      pageBuilder: (context, state) => _slidePage(
        key: state.pageKey,
        child: AccountDetailPage(accountId: state.pathParameters['id'] ?? ''),
      ),
    ),
    GoRoute(
      path: '${AppRoutes.details}/:id',
      pageBuilder: (context, state) => _slidePage(
        key: state.pageKey,
        child: TemplateDetailPage(id: state.pathParameters['id'] ?? ''),
      ),
    ),
  ],
);

CustomTransitionPage<void> _slidePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final position = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: AppCurves.standard)).animate(animation);
      return SlideTransition(
        position: position,
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}
