// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_accounts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(accountsBox)
const accountsBoxProvider = AccountsBoxProvider._();

final class AccountsBoxProvider
    extends $FunctionalProvider<Box<String>, Box<String>, Box<String>>
    with $Provider<Box<String>> {
  const AccountsBoxProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountsBoxProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountsBoxHash();

  @$internal
  @override
  $ProviderElement<Box<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Box<String> create(Ref ref) {
    return accountsBox(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Box<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Box<String>>(value),
    );
  }
}

String _$accountsBoxHash() => r'c20508949d364ad91ac72e2ca5dd40ca8db122b3';

@ProviderFor(accountRepository)
const accountRepositoryProvider = AccountRepositoryProvider._();

final class AccountRepositoryProvider
    extends
        $FunctionalProvider<
          AccountRepository,
          AccountRepository,
          AccountRepository
        >
    with $Provider<AccountRepository> {
  const AccountRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountRepositoryHash();

  @$internal
  @override
  $ProviderElement<AccountRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccountRepository create(Ref ref) {
    return accountRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountRepository>(value),
    );
  }
}

String _$accountRepositoryHash() => r'28b4802616392199036b35e786bd712ff2466065';

@ProviderFor(accountIdGenerator)
const accountIdGeneratorProvider = AccountIdGeneratorProvider._();

final class AccountIdGeneratorProvider
    extends
        $FunctionalProvider<
          AccountIdGenerator,
          AccountIdGenerator,
          AccountIdGenerator
        >
    with $Provider<AccountIdGenerator> {
  const AccountIdGeneratorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountIdGeneratorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountIdGeneratorHash();

  @$internal
  @override
  $ProviderElement<AccountIdGenerator> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccountIdGenerator create(Ref ref) {
    return accountIdGenerator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountIdGenerator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountIdGenerator>(value),
    );
  }
}

String _$accountIdGeneratorHash() =>
    r'73354d760c2aec2b508e1af6a61859ec2d7b90db';

/// Raw accounts for the active trip.

@ProviderFor(accounts)
const accountsProvider = AccountsProvider._();

/// Raw accounts for the active trip.

final class AccountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Account>>,
          List<Account>,
          Stream<List<Account>>
        >
    with $FutureModifier<List<Account>>, $StreamProvider<List<Account>> {
  /// Raw accounts for the active trip.
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
  $StreamProviderElement<List<Account>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Account>> create(Ref ref) {
    return accounts(ref);
  }
}

String _$accountsHash() => r'967f9c05dd7401a64521c019f4352b0ff6119e4b';

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

String _$tripAccountsHash() => r'8783468d555a42a483a9a9a1d6ac0dbf090f1165';
