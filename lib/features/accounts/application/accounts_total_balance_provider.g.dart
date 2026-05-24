// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_total_balance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Total of every account balance for the active trip, in home currency.

@ProviderFor(accountsTotalBalance)
const accountsTotalBalanceProvider = AccountsTotalBalanceProvider._();

/// Total of every account balance for the active trip, in home currency.

final class AccountsTotalBalanceProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Total of every account balance for the active trip, in home currency.
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
    r'fb1b91538741682ef6d95df55b7240095ebc97af';
