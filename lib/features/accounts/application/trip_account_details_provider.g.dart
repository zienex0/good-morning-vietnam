// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_account_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tripAccountDetails)
const tripAccountDetailsProvider = TripAccountDetailsFamily._();

final class TripAccountDetailsProvider
    extends
        $FunctionalProvider<
          AsyncValue<AccountDetail?>,
          AccountDetail?,
          FutureOr<AccountDetail?>
        >
    with $FutureModifier<AccountDetail?>, $FutureProvider<AccountDetail?> {
  const TripAccountDetailsProvider._({
    required TripAccountDetailsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'tripAccountDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tripAccountDetailsHash();

  @override
  String toString() {
    return r'tripAccountDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<AccountDetail?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AccountDetail?> create(Ref ref) {
    final argument = this.argument as String;
    return tripAccountDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TripAccountDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tripAccountDetailsHash() =>
    r'edf3663ecc25c53a900aa773108c8bbdcf283f38';

final class TripAccountDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<AccountDetail?>, String> {
  const TripAccountDetailsFamily._()
    : super(
        retry: null,
        name: r'tripAccountDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TripAccountDetailsProvider call(String accountId) =>
      TripAccountDetailsProvider._(argument: accountId, from: this);

  @override
  String toString() => r'tripAccountDetailsProvider';
}
