import 'package:flutter/widgets.dart';

extension AppLocalizationsContext on BuildContext {
  AppStrings get l10n => const AppStrings();
}

class AppStrings {
  const AppStrings();

  String get appName => 'Flutter Foundation Kit';
  String get home => 'Home';
  String get gallery => 'Gallery';
  String get templateTitle => 'Foundation ready';
  String get templateSubtitle => 'Theme, routing, Riverpod, and UI primitives';
  String get templateDescription =>
      'Start from this source baseline, add your product features, then generate only the platform folders your app needs.';
  String get themeSystem => 'Theme system';
  String get routingSetup => 'Routing setup';
  String get reusableWidgets => 'Reusable widgets';
  String get stateReady => 'State ready';
  String get clear => 'Clear';
  String get none => 'None';
  String get save => 'Save';
  String get settings => 'Settings';
  String get support => 'Support';
  String get loading => 'Loading';
  String get retry => 'Try again';
  String get details => 'Details';
  String get total => 'Total';
}
