// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_total_balance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Total of every account balance for the active trip, in home currency.
///
/// [tripAccountsProvider] already converts each account into home currency, so
/// the total is just their sum.

@ProviderFor(accountsTotalBalance)
const accountsTotalBalanceProvider = AccountsTotalBalanceProvider._();

/// Total of every account balance for the active trip, in home currency.
///
/// [tripAccountsProvider] already converts each account into home currency, so
/// the total is just their sum.

final class AccountsTotalBalanceProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Total of every account balance for the active trip, in home currency.
  ///
  /// [tripAccountsProvider] already converts each account into home currency, so
  /// the total is just their sum.
  const AccountsTotalBalanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountsTotalBalanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountsTotalBalanceHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return accountsTotalBalance(ref);
  }
}

String _$accountsTotalBalanceHash() =>
    r'887ed887574b0869861e54257cc6c2f4282cadfb';
