import 'package:hive_ce_flutter/hive_flutter.dart';

const String _tripsBoxName = 'budgeting.trips';
const String _accountsBoxName = 'budgeting.accounts';
const String _transactionsBoxName = 'budgeting.transactions';
const String _settingsBoxName = 'budgeting.settings';

const String settingsActiveTripIdKey = 'activeTripId';

class HiveBudgetingBoxes {
  const HiveBudgetingBoxes({
    required this.trips,
    required this.accounts,
    required this.transactions,
    required this.settings,
  });

  final Box<String> trips;
  final Box<String> accounts;
  final Box<String> transactions;
  final Box<String> settings;
}

Future<HiveBudgetingBoxes> openHiveBudgetingBoxes() async {
  final trips = await Hive.openBox<String>(_tripsBoxName);
  final accounts = await Hive.openBox<String>(_accountsBoxName);
  final transactions = await Hive.openBox<String>(_transactionsBoxName);
  final settings = await Hive.openBox<String>(_settingsBoxName);
  return HiveBudgetingBoxes(
    trips: trips,
    accounts: accounts,
    transactions: transactions,
    settings: settings,
  );
}
