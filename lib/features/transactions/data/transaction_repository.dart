import 'package:flutter_foundation_kit/core/data/data.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/amortization.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/transaction.dart';

/// Hive-backed store of transactions — the whole data layer in one declaration.
///
/// Transactions are scoped to a trip and filtered in the read providers. The
/// money-movement flows (expense / top-up / transfer / set-balance) and the
/// delete cascades live in the transactions controller, not here.
final transactionRepositoryProvider = localRepository<Transaction>(
  box: 'transactions',
  id: (transaction) => transaction.id,
  toJson: (transaction) => {
    'id': transaction.id,
    'tripId': transaction.tripId,
    'type': transaction.type.name,
    'occurredAt': transaction.occurredAt.toIso8601String(),
    'sourceAccountId': transaction.sourceAccountId,
    'destAccountId': transaction.destAccountId,
    'categoryId': transaction.categoryId,
    'paidAmount': transaction.paidAmount,
    'paidCurrency': transaction.paidCurrency,
    'accountAmount': transaction.accountAmount,
    'accountCurrency': transaction.accountCurrency,
    'destAmount': transaction.destAmount,
    'destCurrency': transaction.destCurrency,
    'note': transaction.note,
    'amortization': transaction.amortization == null
        ? null
        : {
            'unit': transaction.amortization!.unit.name,
            'count': transaction.amortization!.count,
          },
    'createdAt': transaction.createdAt.toIso8601String(),
  },
  fromJson: (json) => Transaction(
    id: json['id'] as String,
    tripId: json['tripId'] as String,
    type: TransactionType.values.firstWhere(
      (value) => value.name == json['type'] as String,
      orElse: () => TransactionType.expense,
    ),
    occurredAt: DateTime.parse(json['occurredAt'] as String),
    sourceAccountId: json['sourceAccountId'] as String?,
    destAccountId: json['destAccountId'] as String?,
    categoryId: json['categoryId'] as String?,
    paidAmount: (json['paidAmount'] as num).toDouble(),
    paidCurrency: json['paidCurrency'] as String,
    accountAmount: (json['accountAmount'] as num).toDouble(),
    accountCurrency: json['accountCurrency'] as String,
    destAmount: (json['destAmount'] as num?)?.toDouble(),
    destCurrency: json['destCurrency'] as String?,
    note: json['note'] as String?,
    amortization: json['amortization'] == null
        ? null
        : Amortization(
            unit: AmortizationUnit.values.firstWhere(
              (value) =>
                  value.name ==
                  (json['amortization'] as Map<String, dynamic>)['unit']
                      as String?,
              orElse: () => AmortizationUnit.days,
            ),
            count:
                ((json['amortization'] as Map<String, dynamic>)['count'] as num)
                    .toInt(),
          ),
    createdAt: DateTime.parse(json['createdAt'] as String),
  ),
  sort: (a, b) => b.occurredAt.compareTo(a.occurredAt),
  deleteInvalidEntries: true,
);
