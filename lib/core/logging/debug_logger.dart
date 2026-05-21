part of 'logger.dart';

/// Debug-build Logger implementation. Writes to dart:developer.log, which
/// surfaces in IDE consoles and flutter logs.
class DebugLogger implements Logger {
  const DebugLogger();

  @override
  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(message, name: 'DEBUG', error: error, stackTrace: stackTrace);
  }

  @override
  void info(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(message, name: 'INFO', error: error, stackTrace: stackTrace);
  }

  @override
  void warn(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(message, name: 'WARN', error: error, stackTrace: stackTrace);
  }

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(message, name: 'ERROR', error: error, stackTrace: stackTrace);
  }
}
