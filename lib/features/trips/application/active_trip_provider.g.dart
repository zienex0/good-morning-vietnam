// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_trip_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Id of the active trip, or null when none is selected.

@ProviderFor(activeTripId)
const activeTripIdProvider = ActiveTripIdProvider._();

/// Id of the active trip, or null when none is selected.

final class ActiveTripIdProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, Stream<String?>>
    with $FutureModifier<String?>, $StreamProvider<String?> {
  /// Id of the active trip, or null when none is selected.
  const ActiveTripIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeTripIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeTripIdHash();

  @$internal
  @override
  $StreamProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<String?> create(Ref ref) {
    return activeTripId(ref);
  }
}

String _$activeTripIdHash() => r'a354021a93caa2d644419a27a93b2f3ea42351d9';

/// The active trip resolved from [tripsControllerProvider], or null when none
/// is active.

@ProviderFor(activeTrip)
const activeTripProvider = ActiveTripProvider._();

/// The active trip resolved from [tripsControllerProvider], or null when none
/// is active.

final class ActiveTripProvider
    extends $FunctionalProvider<AsyncValue<Trip?>, Trip?, FutureOr<Trip?>>
    with $FutureModifier<Trip?>, $FutureProvider<Trip?> {
  /// The active trip resolved from [tripsControllerProvider], or null when none
  /// is active.
  const ActiveTripProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeTripProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeTripHash();

  @$internal
  @override
  $FutureProviderElement<Trip?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Trip?> create(Ref ref) {
    return activeTrip(ref);
  }
}

String _$activeTripHash() => r'd204165bbad7b3f7bdc182f798fcdf1260a832c6';
