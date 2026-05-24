// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_days_left_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Days the active trip's money lasts at the current average daily spend.
/// Composes the accounts balance and the transactions spend rate.

@ProviderFor(tripDaysLeft)
const tripDaysLeftProvider = TripDaysLeftProvider._();

/// Days the active trip's money lasts at the current average daily spend.
/// Composes the accounts balance and the transactions spend rate.

final class TripDaysLeftProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  /// Days the active trip's money lasts at the current average daily spend.
  /// Composes the accounts balance and the transactions spend rate.
  const TripDaysLeftProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tripDaysLeftProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tripDaysLeftHash();

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    return tripDaysLeft(ref);
  }
}

String _$tripDaysLeftHash() => r'8a6ecab594d5f045226b112dcb49c2691ac3f8ee';
