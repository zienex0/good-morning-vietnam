import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

enum TransactionType { expense, income, transfer }

@freezed
class Transaction with _$Transaction {
  Transaction._();

  @Assert('amount > 0', 'amount must be positive')
  @Assert('amountHome > 0', 'amountHome must be positive')
  @Assert('fxRate > 0', 'fxRate must be positive')
  @Assert(
    '(enteredAmount == null && enteredCurrency == null && enteredFxRate == null) || '
        '(enteredAmount != null && enteredAmount > 0 && enteredCurrency != null && enteredFxRate != null && enteredFxRate > 0)',
    'entered currency details must be complete and positive',
  )
  @Assert(
    'type != TransactionType.expense || '
        '(sourceAccountId != null && destAccountId == null && categoryId != null)',
    'expense transactions need a source account and category only',
  )
  @Assert(
    'type != TransactionType.income || '
        '(sourceAccountId == null && destAccountId != null)',
    'income transactions need a destination account only',
  )
  @Assert(
    'type != TransactionType.transfer || '
        '(sourceAccountId != null && destAccountId != null && categoryId == null)',
    'transfer transactions need source and destination accounts only',
  )
  @Assert(
    '(type == TransactionType.transfer) == '
        '(destAmount != null && destCurrency != null && destFxRate != null)',
    'dest currency snapshot is required for transfers and forbidden otherwise',
  )
  @Assert(
    'destAmount == null || destAmount > 0',
    'destAmount must be positive',
  )
  @Assert(
    'destFxRate == null || destFxRate > 0',
    'destFxRate must be positive',
  )
  factory Transaction({
    required String id,
    required String tripId,
    required TransactionType type,
    required DateTime occurredAt,
    String? sourceAccountId,
    String? destAccountId,
    String? categoryId,
    required double amount,
    required CurrencyCode currency,
    required double amountHome,
    required double fxRate,
    double? enteredAmount,
    CurrencyCode? enteredCurrency,
    double? enteredFxRate,
    double? destAmount,
    CurrencyCode? destCurrency,
    double? destFxRate,
    String? note,
    required DateTime createdAt,
  }) = _Transaction;

  bool get isExpense => type == TransactionType.expense;
  bool get isIncome => type == TransactionType.income;
  bool get isTransfer => type == TransactionType.transfer;
  bool get hasEnteredCurrency => enteredCurrency != null;
  bool get hasDestCurrency => destCurrency != null;
  bool get isCrossCurrencyTransfer =>
      isTransfer && destCurrency != null && destCurrency != currency;
}
