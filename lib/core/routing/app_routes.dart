/// Typed route path constants for the app.
abstract final class AppRoutes {
  static const String home = '/';
  static const String gallery = '/gallery';
  static const String details = '/details';

  static const String accounts = '/accounts';
  static const String newAccount = '/accounts/new';
  static const String accountDetails = '/accounts/detail';
  static const String newExpense = '/transactions/expense/new';
  static const String newTopUp = '/transactions/top-up/new';
  static const String newTransfer = '/transactions/transfer/new';
  static const String setBalance = '/transactions/set-balance';
  static const String tripSettings = '/trip';
  static const String newTrip = '/trip/new';
  static const String editTrip = '/trip/edit';

  /// Builds the path for the details screen for a given [id].
  static String detailsFor(String id) => '$details/$id';

  static String accountDetailsFor(String id) => '$accountDetails/$id';
  static String editTripFor(String id) => '$editTrip/$id';
}
