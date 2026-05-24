// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_account_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AccountFormNotifier)
const accountFormProvider = AccountFormNotifierProvider._();

final class AccountFormNotifierProvider
    extends $AsyncNotifierProvider<AccountFormNotifier, void> {
  const AccountFormNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountFormNotifierHash();

  @$internal
  @override
  AccountFormNotifier create() => AccountFormNotifier();
}

String _$accountFormNotifierHash() =>
    r'7adac3abd35b03501f6c77559261d09acfb0a5a0';

abstract class _$AccountFormNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
