// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_spend_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Total expense spend for the active trip, in home currency.

@ProviderFor(totalSpend)
const totalSpendProvider = TotalSpendProvider._();

/// Total expense spend for the active trip, in home currency.

final class TotalSpendProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Total expense spend for the active trip, in home currency.
  const TotalSpendProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'totalSpendProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$totalSpendHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return totalSpend(ref);
  }
}

String _$totalSpendHash() => r'4d752e521a3d4be26b31895cb8af3d754120587a';

/// Average per-day spend for the active trip so far, in home currency.

@ProviderFor(averageDailySpend)
const averageDailySpendProvider = AverageDailySpendProvider._();

/// Average per-day spend for the active trip so far, in home currency.

final class AverageDailySpendProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Average per-day spend for the active trip so far, in home currency.
  const AverageDailySpendProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'averageDailySpendProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$averageDailySpendHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return averageDailySpend(ref);
  }
}

String _$averageDailySpendHash() => r'907386a146cc21422d0e6f10d4d07da2852c6c08';

/// Per-day spend points for the active trip's chart, in home currency.

@ProviderFor(dailySpend)
const dailySpendProvider = DailySpendProvider._();

/// Per-day spend points for the active trip's chart, in home currency.

final class DailySpendProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DailySpendPoint>>,
          List<DailySpendPoint>,
          FutureOr<List<DailySpendPoint>>
        >
    with
        $FutureModifier<List<DailySpendPoint>>,
        $FutureProvider<List<DailySpendPoint>> {
  /// Per-day spend points for the active trip's chart, in home currency.
  const DailySpendProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailySpendProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailySpendHash();

  @$internal
  @override
  $FutureProviderElement<List<DailySpendPoint>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DailySpendPoint>> create(Ref ref) {
    return dailySpend(ref);
  }
}

String _$dailySpendHash() => r'd61c7810db175fec592bb5dbf98688401c0a59d6';

/// Spend grouped by category for the active trip, in home currency.

@ProviderFor(categoryBreakdown)
const categoryBreakdownProvider = CategoryBreakdownProvider._();

/// Spend grouped by category for the active trip, in home currency.

final class CategoryBreakdownProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CategorySpend>>,
          List<CategorySpend>,
          FutureOr<List<CategorySpend>>
        >
    with
        $FutureModifier<List<CategorySpend>>,
        $FutureProvider<List<CategorySpend>> {
  /// Spend grouped by category for the active trip, in home currency.
  const CategoryBreakdownProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryBreakdownProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryBreakdownHash();

  @$internal
  @override
  $FutureProviderElement<List<CategorySpend>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CategorySpend>> create(Ref ref) {
    return categoryBreakdown(ref);
  }
}

String _$categoryBreakdownHash() => r'531eb96f08b545218fac19c8e94b94880a1a845e';
