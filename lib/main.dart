import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/l10n/app_localizations.dart';
import 'package:flutter_foundation_kit/core/logging/logger.dart';
import 'package:flutter_foundation_kit/core/routing/app_router.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/core/theme/theme_mode_controller.dart';
import 'package:flutter_foundation_kit/features/accounts/application/trip_accounts_provider.dart';
import 'package:flutter_foundation_kit/features/transactions/application/transactions_provider.dart';
import 'package:flutter_foundation_kit/features/trips/application/trips_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final logContainer = ProviderContainer();
  final log = logContainer.read(loggerProvider);

  FlutterError.onError = (details) {
    log.error(
      details.exceptionAsString(),
      error: details.exception,
      stackTrace: details.stack,
    );
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log.error('Uncaught platform error', error: error, stackTrace: stack);
    return true;
  };

  await Hive.initFlutter();
  final tripsBox = await Hive.openBox<String>('budgeting.trips');
  final accountsBox = await Hive.openBox<String>('budgeting.accounts');
  final transactionsBox = await Hive.openBox<String>('budgeting.transactions');
  final settingsBox = await Hive.openBox<String>('budgeting.settings');

  runApp(
    ProviderScope(
      overrides: [
        tripsBoxProvider.overrideWithValue(tripsBox),
        settingsBoxProvider.overrideWithValue(settingsBox),
        accountsBoxProvider.overrideWithValue(accountsBox),
        transactionsBoxProvider.overrideWithValue(transactionsBox),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(appRouterProvider);
    final themeMode = ref.watch(themeModeControllerProvider);

    return MaterialApp.router(
      title: context.l10n.appName,
      theme: buildAppTheme(AppPalette.light),
      darkTheme: buildAppTheme(AppPalette.dark),
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
    );
  }
}
