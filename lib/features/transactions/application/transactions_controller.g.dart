// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns every transaction (across all trips) plus the money-movement flows.
///
/// Plain deletes/reads come from [LocalCrudNotifier]; the four creation flows
/// ([createExpense] / [createTopUp] / [createTransfer] / [setAccountBalances])
/// build a fully-formed [Transaction] from form inputs — looking up the trip
/// and accounts and converting currency via [ConvertToHomeCurrencyUseCase] —
/// then persist it through [create]. The shared conversion logic stays a use
/// case because the spend read providers use it too.

@ProviderFor(TransactionsController)
const transactionsControllerProvider = TransactionsControllerProvider._();

/// Owns every transaction (across all trips) plus the money-movement flows.
///
/// Plain deletes/reads come from [LocalCrudNotifier]; the four creation flows
/// ([createExpense] / [createTopUp] / [createTransfer] / [setAccountBalances])
/// build a fully-formed [Transaction] from form inputs — looking up the trip
/// and accounts and converting currency via [ConvertToHomeCurrencyUseCase] —
/// then persist it through [create]. The shared conversion logic stays a use
/// case because the spend read providers use it too.
final class TransactionsControllerProvider
    extends $StreamNotifierProvider<TransactionsController, List<Transaction>> {
  /// Owns every transaction (across all trips) plus the money-movement flows.
  ///
  /// Plain deletes/reads come from [LocalCrudNotifier]; the four creation flows
  /// ([createExpense] / [createTopUp] / [createTransfer] / [setAccountBalances])
  /// build a fully-formed [Transaction] from form inputs — looking up the trip
  /// and accounts and converting currency via [ConvertToHomeCurrencyUseCase] —
  /// then persist it through [create]. The shared conversion logic stays a use
  /// case because the spend read providers use it too.
  const TransactionsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionsControllerHash();

  @$internal
  @override
  TransactionsController create() => TransactionsController();
}

String _$transactionsControllerHash() =>
    r'a376086dd74b31b70ae827865f60ff20ac4472e8';

/// Owns every transaction (across all trips) plus the money-movement flows.
///
/// Plain deletes/reads come from [LocalCrudNotifier]; the four creation flows
/// ([createExpense] / [createTopUp] / [createTransfer] / [setAccountBalances])
/// build a fully-formed [Transaction] from form inputs — looking up the trip
/// and accounts and converting currency via [ConvertToHomeCurrencyUseCase] —
/// then persist it through [create]. The shared conversion logic stays a use
/// case because the spend read providers use it too.

abstract class _$TransactionsController
    extends $StreamNotifier<List<Transaction>> {
  Stream<List<Transaction>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<Transaction>>, List<Transaction>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Transaction>>, List<Transaction>>,
              AsyncValue<List<Transaction>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
