// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(templateRepository)
const templateRepositoryProvider = TemplateRepositoryProvider._();

final class TemplateRepositoryProvider
    extends
        $FunctionalProvider<
          TemplateRepository,
          TemplateRepository,
          TemplateRepository
        >
    with $Provider<TemplateRepository> {
  const TemplateRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'templateRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$templateRepositoryHash();

  @$internal
  @override
  $ProviderElement<TemplateRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TemplateRepository create(Ref ref) {
    return templateRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TemplateRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TemplateRepository>(value),
    );
  }
}

String _$templateRepositoryHash() =>
    r'1e1b33c83604c50a36098f0bcca7e9bb0f30dcbe';

/// Streams the running count of confirmed receipts for this session, straight
/// from the repository. Updates automatically after each [confirmReceipt] call
/// without any local state tracking.

@ProviderFor(templateConfirmedCount)
const templateConfirmedCountProvider = TemplateConfirmedCountProvider._();

/// Streams the running count of confirmed receipts for this session, straight
/// from the repository. Updates automatically after each [confirmReceipt] call
/// without any local state tracking.

final class TemplateConfirmedCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Streams the running count of confirmed receipts for this session, straight
  /// from the repository. Updates automatically after each [confirmReceipt] call
  /// without any local state tracking.
  const TemplateConfirmedCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'templateConfirmedCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$templateConfirmedCountHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return templateConfirmedCount(ref);
  }
}

String _$templateConfirmedCountHash() =>
    r'11e3fd9349fbc3a0b32ddcc965bcc84510438bba';

@ProviderFor(TemplateController)
const templateControllerProvider = TemplateControllerProvider._();

final class TemplateControllerProvider
    extends $AsyncNotifierProvider<TemplateController, TemplateState> {
  const TemplateControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'templateControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$templateControllerHash();

  @$internal
  @override
  TemplateController create() => TemplateController();
}

String _$templateControllerHash() =>
    r'af05cb9e3bd5fe72eabbeb5684a786a6f89c446c';

abstract class _$TemplateController extends $AsyncNotifier<TemplateState> {
  FutureOr<TemplateState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<TemplateState>, TemplateState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TemplateState>, TemplateState>,
              AsyncValue<TemplateState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
