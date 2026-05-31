// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trips_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the live list of trips plus every trip write.
///
/// Validation lives in [beforeCreate] / [beforeUpdate]; the new trip is made
/// active in [afterCreate]; the delete-trip cascade (accounts + transactions +
/// clearing the active trip) lives in [afterDelete]. No use cases needed.

@ProviderFor(TripsController)
const tripsControllerProvider = TripsControllerProvider._();

/// Owns the live list of trips plus every trip write.
///
/// Validation lives in [beforeCreate] / [beforeUpdate]; the new trip is made
/// active in [afterCreate]; the delete-trip cascade (accounts + transactions +
/// clearing the active trip) lives in [afterDelete]. No use cases needed.
final class TripsControllerProvider
    extends $StreamNotifierProvider<TripsController, List<Trip>> {
  /// Owns the live list of trips plus every trip write.
  ///
  /// Validation lives in [beforeCreate] / [beforeUpdate]; the new trip is made
  /// active in [afterCreate]; the delete-trip cascade (accounts + transactions +
  /// clearing the active trip) lives in [afterDelete]. No use cases needed.
  const TripsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tripsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tripsControllerHash();

  @$internal
  @override
  TripsController create() => TripsController();
}

String _$tripsControllerHash() => r'5dc37e42d9ce8da3d981c28e0dff514c87a3b361';

/// Owns the live list of trips plus every trip write.
///
/// Validation lives in [beforeCreate] / [beforeUpdate]; the new trip is made
/// active in [afterCreate]; the delete-trip cascade (accounts + transactions +
/// clearing the active trip) lives in [afterDelete]. No use cases needed.

abstract class _$TripsController extends $StreamNotifier<List<Trip>> {
  Stream<List<Trip>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Trip>>, List<Trip>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Trip>>, List<Trip>>,
              AsyncValue<List<Trip>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
