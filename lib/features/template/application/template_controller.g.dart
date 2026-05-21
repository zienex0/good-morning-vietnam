// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$templateConfirmedCountHash() =>
    r'9bcd664781b34d919560c64ce4170c7c0210db19';

/// Streams the running count of confirmed receipts for this session.
/// Backed by [WatchConfirmedCountUseCase]; updates automatically after each
/// [TemplateController.confirmReceipt] call without any local state tracking.
///
/// Copied from [templateConfirmedCount].
@ProviderFor(templateConfirmedCount)
final templateConfirmedCountProvider = AutoDisposeStreamProvider<int>.internal(
  templateConfirmedCount,
  name: r'templateConfirmedCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$templateConfirmedCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TemplateConfirmedCountRef = AutoDisposeStreamProviderRef<int>;
String _$templateControllerHash() =>
    r'adfc0e7689c811a733a9c8edca3db8c0e2c8ecef';

/// See also [TemplateController].
@ProviderFor(TemplateController)
final templateControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      TemplateController,
      TemplateState
    >.internal(
      TemplateController.new,
      name: r'templateControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$templateControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TemplateController = AutoDisposeAsyncNotifier<TemplateState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
