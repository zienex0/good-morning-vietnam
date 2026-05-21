DateTime budgetingDateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

int budgetingInclusiveDayCount({
  required DateTime start,
  required DateTime end,
}) {
  final startDate = budgetingDateOnly(start);
  final endDate = budgetingDateOnly(end);
  return endDate.difference(startDate).inDays + 1;
}
