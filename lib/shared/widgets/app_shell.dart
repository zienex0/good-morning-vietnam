import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:go_router/go_router.dart';

const double _bottomNavHeight = 88;
const double _bottomNavIconSize = 28;

class AppShell extends StatelessWidget {
  const AppShell({
    required this.navigationShell,
    required this.destinations,
    this.includeNavigationBar = true,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final List<AppShellDestination> destinations;
  final bool includeNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: includeNavigationBar
          ? _AppNavigationBar(
              navigationShell: navigationShell,
              destinations: destinations,
            )
          : null,
    );
  }
}

class AppShellDestination {
  const AppShellDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class _AppNavigationBar extends StatelessWidget {
  const _AppNavigationBar({
    required this.navigationShell,
    required this.destinations,
  });

  final StatefulNavigationShell navigationShell;
  final List<AppShellDestination> destinations;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.sheet,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: AppSpacing.xl,
            offset: const Offset(AppSpacing.none, -AppSpacing.xs),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: _bottomNavHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: destinations
                .asMap()
                .entries
                .map((entry) {
                  final index = entry.key;
                  final destination = entry.value;
                  final selected = navigationShell.currentIndex == index;
                  return Tooltip(
                    message: destination.label,
                    child: IconButton(
                      onPressed: () {
                        navigationShell.goBranch(
                          index,
                          initialLocation: selected,
                        );
                      },
                      icon: Icon(
                        selected ? destination.selectedIcon : destination.icon,
                      ),
                      color: selected ? AppColors.accent : AppColors.textMuted,
                      iconSize: _bottomNavIconSize,
                    ),
                  );
                })
                .toList(growable: false),
          ),
        ),
      ),
    );
  }
}
