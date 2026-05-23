import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/exchange_rate_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';

class ConvertToHomeCurrencyUseCase {
  const ConvertToHomeCurrencyUseCase(this._exchangeRates);

  final ExchangeRateRepository _exchangeRates;

  Future<Result<({double amountHome, double fxRate}), Failure>> call({
    required double amount,
    required CurrencyCode sourceCurrency,
    required CurrencyCode homeCurrency,
    required DateTime date,
  }) async {
    if (amount == 0) {
      return const Ok((amountHome: 0, fxRate: 1));
    }
    if (sourceCurrency == homeCurrency) {
      return Ok((amountHome: amount, fxRate: 1));
    }

    final rateResult = await _exchangeRates.fetchRate(
      base: sourceCurrency,
      quote: homeCurrency,
      date: date,
    );
    return switch (rateResult) {
      Ok(value: final rate) => Ok((
        amountHome: amount * rate.rate,
        fxRate: rate.rate,
      )),
      Err(failure: final failure) => Err(failure),
    };
  }
}
