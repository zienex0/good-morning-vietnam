// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the persisted list of confirmed project receipts.
///
/// This controller is the canonical example of [LocalCrudNotifier] usage:
/// - [build] wires the live repository stream into the provider state.
/// - [beforeCreate] validates and transforms a draft receipt into a confirmed
///   one (adds timestamp + id) before it reaches the repository.
/// - The page holds form state (track, seats) locally; the controller only
///   knows about what has been confirmed and stored.

@ProviderFor(TemplateController)
const templateControllerProvider = TemplateControllerProvider._();

/// Manages the persisted list of confirmed project receipts.
///
/// This controller is the canonical example of [LocalCrudNotifier] usage:
/// - [build] wires the live repository stream into the provider state.
/// - [beforeCreate] validates and transforms a draft receipt into a confirmed
///   one (adds timestamp + id) before it reaches the repository.
/// - The page holds form state (track, seats) locally; the controller only
///   knows about what has been confirmed and stored.
final class TemplateControllerProvider
    extends $StreamNotifierProvider<TemplateController, List<ProjectReceipt>> {
  /// Manages the persisted list of confirmed project receipts.
  ///
  /// This controller is the canonical example of [LocalCrudNotifier] usage:
  /// - [build] wires the live repository stream into the provider state.
  /// - [beforeCreate] validates and transforms a draft receipt into a confirmed
  ///   one (adds timestamp + id) before it reaches the repository.
  /// - The page holds form state (track, seats) locally; the controller only
  ///   knows about what has been confirmed and stored.
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
    r'99541625e1ee7f30c7501b139df9330290b30b11';

/// Manages the persisted list of confirmed project receipts.
///
/// This controller is the canonical example of [LocalCrudNotifier] usage:
/// - [build] wires the live repository stream into the provider state.
/// - [beforeCreate] validates and transforms a draft receipt into a confirmed
///   one (adds timestamp + id) before it reaches the repository.
/// - The page holds form state (track, seats) locally; the controller only
///   knows about what has been confirmed and stored.

abstract class _$TemplateController
    extends $StreamNotifier<List<ProjectReceipt>> {
  Stream<List<ProjectReceipt>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<ProjectReceipt>>, List<ProjectReceipt>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ProjectReceipt>>,
                List<ProjectReceipt>
              >,
              AsyncValue<List<ProjectReceipt>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
