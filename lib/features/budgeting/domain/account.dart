import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';

enum AccountType { cash, card, bank, ewallet, custom }

@freezed
class Account with _$Account {
  const factory Account({
    required String id,
    required String tripId,
    required String name,
    required AccountType type,
    required CurrencyCode currency,
    required double openingBalance,
    String? icon,
    @Default(false) bool archived,
  }) = _Account;
}
