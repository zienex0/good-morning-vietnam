import 'package:flutter_foundation_kit/core/result/result.dart';

/// Temporary non-UI failure copy for controller tests and debug logs.
///
/// Screens should map these same failures through localization before display.
String failureMessage(Failure failure) => switch (failure) {
  NetworkFailure() => 'Check your connection and try again.',
  NotFoundFailure() => 'We could not find that item.',
  ConflictFailure() => 'That item already exists.',
  UnauthorizedFailure() => 'Please sign in and try again.',
  ValidationFailure(:final message) => message,
  UnknownFailure() => 'Something went wrong. Please try again.',
};
