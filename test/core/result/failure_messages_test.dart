import 'package:flutter_foundation_kit/core/result/failure_messages.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps known failures to display-safe messages', () {
    expect(
      failureMessage(const NetworkFailure()),
      'Check your connection and try again.',
    );
    expect(
      failureMessage(const NotFoundFailure()),
      'We could not find that item.',
    );
    expect(
      failureMessage(const UnauthorizedFailure()),
      'Please sign in and try again.',
    );
    expect(
      failureMessage(const ValidationFailure('Use a work email.')),
      'Use a work email.',
    );
    expect(
      failureMessage(UnknownFailure(Exception('private detail'))),
      'Something went wrong. Please try again.',
    );
  });
}
