import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budgeting_id_generator.g.dart';

abstract interface class BudgetingIdGenerator {
  String transactionId();
  String tripId();
}

class TimestampBudgetingIdGenerator implements BudgetingIdGenerator {
  const TimestampBudgetingIdGenerator();

  @override
  String transactionId() => 'txn-${DateTime.now().microsecondsSinceEpoch}';

  @override
  String tripId() => 'trip-${DateTime.now().microsecondsSinceEpoch}';
}

@Riverpod(keepAlive: true)
BudgetingIdGenerator budgetingIdGenerator(BudgetingIdGeneratorRef ref) {
  return const TimestampBudgetingIdGenerator();
}
