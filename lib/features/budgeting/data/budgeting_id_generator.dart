abstract interface class BudgetingIdGenerator {
  String transactionId();
  String tripId();
  String accountId();
}

class TimestampBudgetingIdGenerator implements BudgetingIdGenerator {
  const TimestampBudgetingIdGenerator();

  @override
  String transactionId() => 'txn-${DateTime.now().microsecondsSinceEpoch}';

  @override
  String tripId() => 'trip-${DateTime.now().microsecondsSinceEpoch}';

  @override
  String accountId() => 'acct-${DateTime.now().microsecondsSinceEpoch}';
}
