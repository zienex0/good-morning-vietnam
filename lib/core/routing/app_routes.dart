/// Typed route path constants for the starter app.
abstract final class AppRoutes {
  static const String home = '/';
  static const String accounts = '/accounts';
  static const String newAccount = '/accounts/new';
  static const String accountDetails = '/accounts/detail';
  static const String newExpense = '/transactions/expense/new';
  static const String newTopUp = '/transactions/top-up/new';
  static const String newTransfer = '/transactions/transfer/new';
  static const String gallery = '/gallery';
  static const String details = '/details';

  static String accountDetailsFor(String id) => '$accountDetails/$id';

  /// Builds the path for the details screen for a given [id].
  static String detailsFor(String id) => '$details/$id';
}
