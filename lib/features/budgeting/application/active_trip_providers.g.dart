// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_trip_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeTripIdHash() => r'9ee14be4042ff26908223cf55bdc0ba1aca4a18d';

/// In-memory mirror of the persisted active trip id.
///
/// `build()` reads the current value from the repository on each
/// invalidation. Mutations go through `SetActiveTripUseCase` and then
/// invalidate this provider — see `BudgetingTripFormController` and the
/// drawer / onboarding handlers.
///
/// Copied from [activeTripId].
@ProviderFor(activeTripId)
final activeTripIdProvider = Provider<String?>.internal(
  activeTripId,
  name: r'activeTripIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeTripIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveTripIdRef = ProviderRef<String?>;
String _$tripsListHash() => r'd18fde0248ff2255b993bf856116af20dd76c4e6';

/// See also [tripsList].
@ProviderFor(tripsList)
final tripsListProvider = FutureProvider<List<Trip>>.internal(
  tripsList,
  name: r'tripsListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tripsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TripsListRef = FutureProviderRef<List<Trip>>;
String _$activeTripHash() => r'7c786ea8a2b1f7be6ecc77d44895e968155322aa';

/// See also [activeTrip].
@ProviderFor(activeTrip)
final activeTripProvider = FutureProvider<Trip?>.internal(
  activeTrip,
  name: r'activeTripProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeTripHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveTripRef = FutureProviderRef<Trip?>;
String _$accountsForActiveTripHash() =>
    r'91660927fee1d2fc7913e02ccd4daea8d49e3c31';

/// See also [accountsForActiveTrip].
@ProviderFor(accountsForActiveTrip)
final accountsForActiveTripProvider = FutureProvider<List<Account>>.internal(
  accountsForActiveTrip,
  name: r'accountsForActiveTripProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountsForActiveTripHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AccountsForActiveTripRef = FutureProviderRef<List<Account>>;
String _$transactionsForActiveTripHash() =>
    r'1af28c2a12279758693a2e6b5ea9dc4d718dc33c';

/// See also [transactionsForActiveTrip].
@ProviderFor(transactionsForActiveTrip)
final transactionsForActiveTripProvider =
    FutureProvider<List<Transaction>>.internal(
      transactionsForActiveTrip,
      name: r'transactionsForActiveTripProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transactionsForActiveTripHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionsForActiveTripRef = FutureProviderRef<List<Transaction>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
