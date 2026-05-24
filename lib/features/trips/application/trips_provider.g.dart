// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trips_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tripsBox)
const tripsBoxProvider = TripsBoxProvider._();

final class TripsBoxProvider
    extends $FunctionalProvider<Box<String>, Box<String>, Box<String>>
    with $Provider<Box<String>> {
  const TripsBoxProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tripsBoxProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tripsBoxHash();

  @$internal
  @override
  $ProviderElement<Box<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Box<String> create(Ref ref) {
    return tripsBox(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Box<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Box<String>>(value),
    );
  }
}

String _$tripsBoxHash() => r'6b8df524c385c34ff512a8ad1343b0fb9bcb81ce';

@ProviderFor(settingsBox)
const settingsBoxProvider = SettingsBoxProvider._();

final class SettingsBoxProvider
    extends $FunctionalProvider<Box<String>, Box<String>, Box<String>>
    with $Provider<Box<String>> {
  const SettingsBoxProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsBoxProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsBoxHash();

  @$internal
  @override
  $ProviderElement<Box<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Box<String> create(Ref ref) {
    return settingsBox(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Box<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Box<String>>(value),
    );
  }
}

String _$settingsBoxHash() => r'a04cb62487f14b9b66896668c7d4c51c775b3a85';

@ProviderFor(tripRepository)
const tripRepositoryProvider = TripRepositoryProvider._();

final class TripRepositoryProvider
    extends $FunctionalProvider<TripRepository, TripRepository, TripRepository>
    with $Provider<TripRepository> {
  const TripRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tripRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tripRepositoryHash();

  @$internal
  @override
  $ProviderElement<TripRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TripRepository create(Ref ref) {
    return tripRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TripRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TripRepository>(value),
    );
  }
}

String _$tripRepositoryHash() => r'2d8988a0a6c4bdb08ca65b706c076dfdd33cc425';

@ProviderFor(tripIdGenerator)
const tripIdGeneratorProvider = TripIdGeneratorProvider._();

final class TripIdGeneratorProvider
    extends
        $FunctionalProvider<TripIdGenerator, TripIdGenerator, TripIdGenerator>
    with $Provider<TripIdGenerator> {
  const TripIdGeneratorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tripIdGeneratorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tripIdGeneratorHash();

  @$internal
  @override
  $ProviderElement<TripIdGenerator> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TripIdGenerator create(Ref ref) {
    return tripIdGenerator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TripIdGenerator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TripIdGenerator>(value),
    );
  }
}

String _$tripIdGeneratorHash() => r'828b764414361bb5e12a32da11b1b9e90df52095';

/// Live list of all trips.

@ProviderFor(trips)
const tripsProvider = TripsProvider._();

/// Live list of all trips.

final class TripsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Trip>>,
          List<Trip>,
          Stream<List<Trip>>
        >
    with $FutureModifier<List<Trip>>, $StreamProvider<List<Trip>> {
  /// Live list of all trips.
  const TripsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tripsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tripsHash();

  @$internal
  @override
  $StreamProviderElement<List<Trip>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Trip>> create(Ref ref) {
    return trips(ref);
  }
}

String _$tripsHash() => r'fb8b97e11ec18af2d73b1cda22c59c257404ee78';
