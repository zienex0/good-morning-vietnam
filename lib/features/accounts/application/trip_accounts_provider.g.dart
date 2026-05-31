// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_accounts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Accounts belonging to the active trip (the controller owns all trips').

@ProviderFor(accounts)
const accountsProvider = AccountsProvider._();

/// Accounts belonging to the active trip (the controller owns all trips').

final class AccountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Account>>,
          List<Account>,
          FutureOr<List<Account>>
        >
    with $FutureModifier<List<Account>>, $FutureProvider<List<Account>> {
  /// Accounts belonging to the active trip (the controller owns all trips').
  const AccountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountsHash();

  @$internal
  @override
  $FutureProviderElement<List<Account>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Account>> create(Ref ref) {
    return accounts(ref);
  }
}

String _$accountsHash() => r'142335d46acc7b26a5d8467515ff46ec79424e5a';

/// Accounts for the active trip with their balances, sorted by home balance.

@ProviderFor(tripAccounts)
const tripAccountsProvider = TripAccountsProvider._();

/// Accounts for the active trip with their balances, sorted by home balance.

final class TripAccountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AccountBalance>>,
          List<AccountBalance>,
          FutureOr<List<AccountBalance>>
        >
    with
        $FutureModifier<List<AccountBalance>>,
        $FutureProvider<List<AccountBalance>> {
  /// Accounts for the active trip with their balances, sorted by home balance.
  const TripAccountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tripAccountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tripAccountsHash();

  @$internal
  @override
  $FutureProviderElement<List<AccountBalance>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AccountBalance>> create(Ref ref) {
    return tripAccounts(ref);
  }
}

String _$tripAccountsHash() => r'bbc72a22698c9cef1c23704afc6d88661c3ad56e';
