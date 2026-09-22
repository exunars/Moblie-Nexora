class Asset {
  final String symbol;
  final double price;
  final double change24h;
  final double changePercent;

  const Asset({
    this.symbol = '',
    this.price = 0.0,
    this.change24h = 0.0,
    this.changePercent = 0.0,
  });

  Asset copyWith({
    String? symbol,
    double? price,
    double? change24h,
    double? changePercent,
  }) {
    return Asset(
      symbol: symbol ?? this.symbol,
      price: price ?? this.price,
      change24h: change24h ?? this.change24h,
      changePercent: changePercent ?? this.changePercent,
    );
  }
}
class Trade {
  final String id;
  final String symbol;
  final String type;
  final double amount;
  final double price;
  final double total;
  final DateTime timestamp;
  final String status;

  const Trade({
    required this.id,
    required this.symbol,
    required this.type,
    required this.amount,
    required this.price,
    required this.total,
    required this.timestamp,
    required this.status,
  });
}

class MarketData {
  final String symbol;
  final double currentPrice;
  final double high24h;
  final double low24h;
  final double volume24h;
  final double change24h;
  final DateTime lastUpdate;

  MarketData({
    this.symbol = '',
    this.currentPrice = 0.0,
    this.high24h = 0.0,
    this.low24h = 0.0,
    this.volume24h = 0.0,
    this.change24h = 0.0,
    DateTime? lastUpdate,
  }) : lastUpdate = lastUpdate ?? DateTime.now();

  MarketData copyWith({
    String? symbol,
    double? currentPrice,
    double? high24h,
    double? low24h,
    double? volume24h,
    double? change24h,
    DateTime? lastUpdate,
  }) {
    return MarketData(
      symbol: symbol ?? this.symbol,
      currentPrice: currentPrice ?? this.currentPrice,
      high24h: high24h ?? this.high24h,
      low24h: low24h ?? this.low24h,
      volume24h: volume24h ?? this.volume24h,
      change24h: change24h ?? this.change24h,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}
