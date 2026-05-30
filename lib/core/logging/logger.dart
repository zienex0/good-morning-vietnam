import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'debug_logger.dart';
part 'logger.g.dart';

/// Abstract logger consumed by repositories, controllers, and services.
///
/// Features never call print or dart:developer directly. Override this provider
/// at startup to install a release logger such as Sentry or Crashlytics.
abstract class Logger {
  void debug(String message, {Object? error, StackTrace? stackTrace});
  void info(String message, {Object? error, StackTrace? stackTrace});
  void warn(String message, {Object? error, StackTrace? stackTrace});
  void error(String message, {Object? error, StackTrace? stackTrace});
}

@Riverpod(keepAlive: true)
Logger logger(LoggerRef ref) => const DebugLogger();
