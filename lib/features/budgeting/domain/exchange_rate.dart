import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_rate.freezed.dart';

@freezed
class ExchangeRate with _$ExchangeRate {
  const factory ExchangeRate({
    required CurrencyCode base,
    required CurrencyCode quote,
    required double rate,
    required DateTime date,
  }) = _ExchangeRate;
}
