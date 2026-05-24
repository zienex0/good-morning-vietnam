// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TripFormNotifier)
const tripFormProvider = TripFormNotifierProvider._();

final class TripFormNotifierProvider
    extends $AsyncNotifierProvider<TripFormNotifier, void> {
  const TripFormNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tripFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tripFormNotifierHash();

  @$internal
  @override
  TripFormNotifier create() => TripFormNotifier();
}

String _$tripFormNotifierHash() => r'7441132f556d18f90bd6511daba1446f3a476e0f';

abstract class _$TripFormNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
