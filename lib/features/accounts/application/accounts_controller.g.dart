// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns every account (across all trips) plus account writes.
///
/// The UI watches trip-scoped read providers built on top of this list, so the
/// controller stays a plain CRUD store: validation in [beforeCreate] /
/// [beforeUpdate]; the delete-account cascade (its transactions) in
/// [afterDelete]. No use cases.

@ProviderFor(AccountsController)
const accountsControllerProvider = AccountsControllerProvider._();

/// Owns every account (across all trips) plus account writes.
///
/// The UI watches trip-scoped read providers built on top of this list, so the
/// controller stays a plain CRUD store: validation in [beforeCreate] /
/// [beforeUpdate]; the delete-account cascade (its transactions) in
/// [afterDelete]. No use cases.
final class AccountsControllerProvider
    extends $StreamNotifierProvider<AccountsController, List<Account>> {
  /// Owns every account (across all trips) plus account writes.
  ///
  /// The UI watches trip-scoped read providers built on top of this list, so the
  /// controller stays a plain CRUD store: validation in [beforeCreate] /
  /// [beforeUpdate]; the delete-account cascade (its transactions) in
  /// [afterDelete]. No use cases.
  const AccountsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountsControllerHash();

  @$internal
  @override
  AccountsController create() => AccountsController();
}

String _$accountsControllerHash() =>
    r'e44fb360365d29d5ca016fc849f5b6d7a8ba76fe';

/// Owns every account (across all trips) plus account writes.
///
/// The UI watches trip-scoped read providers built on top of this list, so the
/// controller stays a plain CRUD store: validation in [beforeCreate] /
/// [beforeUpdate]; the delete-account cascade (its transactions) in
/// [afterDelete]. No use cases.

abstract class _$AccountsController extends $StreamNotifier<List<Account>> {
  Stream<List<Account>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Account>>, List<Account>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Account>>, List<Account>>,
              AsyncValue<List<Account>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
