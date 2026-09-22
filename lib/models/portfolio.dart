class PortfolioItem {
  final String symbol;
  final double amount;
  final double avgPrice;
  final double currentPrice;
  final double profitLoss;
  final double profitLossPercent;
  final double value;

  PortfolioItem({
    required this.symbol,
    required this.amount,
    required this.avgPrice,
    required this.currentPrice,
    required this.profitLoss,
    required this.profitLossPercent,
    required this.value,
  });

  String get profitLossColor {
    if (profitLoss >= 0) return '#4CAF50';
    return '#F44336';
  }
}

class Portfolio {
  final double totalValue;
  final double availableCash;
  final double totalInvested;
  final double totalProfitLoss;
  final double totalProfitLossPercent;
  final List<PortfolioItem> holdings;
  final DateTime lastUpdate;

  Portfolio({
    required this.totalValue,
    required this.availableCash,
    required this.totalInvested,
    required this.totalProfitLoss,
    required this.totalProfitLossPercent,
    required this.holdings,
    required this.lastUpdate,
  });
}
