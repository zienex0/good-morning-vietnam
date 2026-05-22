// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_trip_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeTripIdHash() =>
    r'0000000000000000000000000000000000000010';

/// In-memory mirror of the persisted active trip id.
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
String _$tripsListHash() => r'0000000000000000000000000000000000000011';

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
String _$activeTripHash() => r'0000000000000000000000000000000000000012';

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
    r'0000000000000000000000000000000000000013';

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
    r'0000000000000000000000000000000000000014';

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
