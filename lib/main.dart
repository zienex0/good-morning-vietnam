import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/l10n/app_localizations.dart';
import 'package:flutter_foundation_kit/core/routing/app_router.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(appRouterProvider);

    return MaterialApp.router(
      title: context.l10n.appName,
      theme: buildAppTheme(),
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
