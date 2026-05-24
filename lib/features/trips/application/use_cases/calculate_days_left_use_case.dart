/// Estimated days the current balance lasts at the average daily spend.
/// Returns null when there is no spend rate yet, and 0 once the money is gone.
class CalculateDaysLeftUseCase {
  const CalculateDaysLeftUseCase();

  int? call({required double totalBalance, required double averageDailySpend}) {
    if (averageDailySpend <= 0) {
      return null;
    }
    if (totalBalance <= 0) {
      return 0;
    }
    return (totalBalance / averageDailySpend).floor();
  }
}
