import 'package:flutter_foundation_kit/features/budgeting/domain/amortization.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

enum TransactionType { expense, income, transfer }

@freezed
class Transaction with _$Transaction {
  Transaction._();

  @Assert('paidAmount > 0', 'paidAmount must be positive')
  @Assert('accountAmount > 0', 'accountAmount must be positive')
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
        '(destAmount != null && destCurrency != null)',
    'dest amount is required for transfers and forbidden otherwise',
  )
  @Assert('destAmount == null || destAmount > 0', 'destAmount must be positive')
  @Assert(
    'amortization == null || type == TransactionType.expense',
    'only expenses can be amortized',
  )
  factory Transaction({
    required String id,
    required String tripId,
    required TransactionType type,
    required DateTime occurredAt,
    String? sourceAccountId,
    String? destAccountId,
    String? categoryId,
    required double paidAmount,
    required CurrencyCode paidCurrency,
    required double accountAmount,
    required CurrencyCode accountCurrency,
    double? destAmount,
    CurrencyCode? destCurrency,
    String? note,
    Amortization? amortization,
    required DateTime createdAt,
  }) = _Transaction;

  bool get isExpense => type == TransactionType.expense;
  bool get isIncome => type == TransactionType.income;
  bool get isTransfer => type == TransactionType.transfer;
  bool get hasSeparateAccountAmount =>
      paidCurrency != accountCurrency || paidAmount != accountAmount;
  bool get hasDestCurrency => destCurrency != null;
  bool get isCrossCurrencyTransfer =>
      isTransfer && destCurrency != null && destCurrency != accountCurrency;

  bool get isAmortized => amortization != null;

  /// Number of days this expense is spread across (1 when not amortized).
  int get spreadDayCount => amortization?.dayCountFrom(occurredAt) ?? 1;

  /// Paid amount attributed to a single day of the spread window.
  double get paidAmountPerDay => paidAmount / spreadDayCount;

  /// Paid amount this expense contributes to the calendar day [day].
  double paidAmountOnDay(DateTime day) {
    final start = DateTime(occurredAt.year, occurredAt.month, occurredAt.day);
    final target = DateTime(day.year, day.month, day.day);
    final span = spreadDayCount;
    if (span <= 1) {
      return target == start ? paidAmount : 0;
    }
    final offset = target.difference(start).inDays;
    if (offset < 0 || offset >= span) {
      return 0;
    }
    return paidAmountPerDay;
  }

  /// Paid amount that has accrued on or before [asOf]. Returns 0 for a fully
  /// future expense and the full amount once the spread window is over.
  double paidAmountThrough(DateTime asOf) {
    final start = DateTime(occurredAt.year, occurredAt.month, occurredAt.day);
    final asOfDate = DateTime(asOf.year, asOf.month, asOf.day);
    final span = spreadDayCount;
    if (span <= 1) {
      return asOfDate.isBefore(start) ? 0 : paidAmount;
    }
    final elapsed = asOfDate.difference(start).inDays + 1;
    if (elapsed <= 0) {
      return 0;
    }
    if (elapsed >= span) {
      return paidAmount;
    }
    return paidAmountPerDay * elapsed;
  }
}
