import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_account_selection_page.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_accounts_page.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_currency_selection_page.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_expense_page.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_home_page.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_settings_page.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_stats_page.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_top_up_page.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transfer_page.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_trip_drawer.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_shell.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) => GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppShell(
        navigationShell: navigationShell,
        drawer: const BudgetingTripDrawer(),
        destinations: const [
          AppShellDestination(
            label: 'Home',
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
          ),
          AppShellDestination(
            label: 'Stats',
            icon: Icons.query_stats_outlined,
            selectedIcon: Icons.query_stats,
          ),
          AppShellDestination(
            label: 'Accounts',
            icon: Icons.account_balance_wallet_outlined,
            selectedIcon: Icons.account_balance_wallet,
          ),
          AppShellDestination(
            label: 'Settings',
            icon: Icons.settings_outlined,
            selectedIcon: Icons.settings,
          ),
        ],
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const BudgetingHomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.stats,
              builder: (context, state) => const BudgetingStatsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.accounts,
              builder: (context, state) => const BudgetingAccountsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const BudgetingSettingsPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.topUp,
      builder: (context, state) => const BudgetingTopUpPage(),
    ),
    GoRoute(
      path: AppRoutes.expense,
      builder: (context, state) => const BudgetingExpensePage(),
    ),
    GoRoute(
      path: AppRoutes.transfer,
      builder: (context, state) => const BudgetingTransferPage(),
    ),
    GoRoute(
      path: AppRoutes.selectCurrency,
      builder: (context, state) => BudgetingCurrencySelectionPage(
        selectedCurrency: state.uri.queryParameters['selected'] ?? 'USD',
        title: state.uri.queryParameters['title'] ?? 'Select currency',
      ),
    ),
    GoRoute(
      path: AppRoutes.selectAccount,
      builder: (context, state) => BudgetingAccountSelectionPage(
        title: state.uri.queryParameters['title'] ?? 'Select account',
        selectedAccountId:
            state.uri.queryParameters['selected'] ?? 'revolut-usd',
        excludedAccountId: state.uri.queryParameters['excluded'],
      ),
    ),
  ],
);
