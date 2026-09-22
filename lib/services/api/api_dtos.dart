import '../../models/trade_data.dart';
import '../../models/order.dart';

/// Server-side order DTO — used by [ApiService] implementations to
/// serialise/deserialise REST responses. Fields intentionally optional
/// to tolerate partial backend responses.

class OrderDto {
  const OrderDto({
    required this.orderId,
    required this.symbol,
    required this.type,
    required this.price,
    required this.amount,
    this.filledAmount = 0.0,
    required this.status,
    required this.timestamp,
    this.errorMessage,
  });

  final String orderId;
  final String symbol;
  final String type;
  final double price;
  final double amount;
  final double filledAmount;
  final String status;
  final DateTime timestamp;
  final String? errorMessage;

  factory OrderDto.fromJson(Map<String, dynamic> json) => OrderDto(
        orderId: json['orderId'] as String,
        symbol: json['symbol'] as String,
        type: json['type'] as String,
        price: (json['price'] as num).toDouble(),
        amount: (json['amount'] as num).toDouble(),
        filledAmount: (json['filledAmount'] as num?)?.toDouble() ?? 0.0,
        status: json['status'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        errorMessage: json['errorMessage'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'symbol': symbol,
        'type': type,
        'price': price,
        'amount': amount,
        'filledAmount': filledAmount,
        'status': status,
        'timestamp': timestamp.toIso8601String(),
        if (errorMessage != null) 'errorMessage': errorMessage,
      };

  Order toOrder() => Order(
        orderId: orderId,
        symbol: symbol,
        type: type,
        price: price,
        amount: amount,
        filledAmount: filledAmount,
        status: status,
        timestamp: timestamp,
        errorMessage: errorMessage,
      );
}

class MarketDataDto {
  const MarketDataDto({
    required this.symbol,
    required this.currentPrice,
    required this.high24h,
    required this.low24h,
    required this.volume24h,
    required this.change24h,
    required this.lastUpdate,
  });

  final String symbol;
  final double currentPrice;
  final double high24h;
  final double low24h;
  final double volume24h;
  final double change24h;
  final DateTime lastUpdate;

  factory MarketDataDto.fromJson(Map<String, dynamic> json) =>
      MarketDataDto(
        symbol: json['symbol'] as String,
        currentPrice: (json['currentPrice'] as num).toDouble(),
        high24h: (json['high24h'] as num).toDouble(),
        low24h: (json['low24h'] as num).toDouble(),
        volume24h: (json['volume24h'] as num).toDouble(),
        change24h: (json['change24h'] as num).toDouble(),
        lastUpdate: DateTime.parse(json['lastUpdate'] as String),
      );

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'currentPrice': currentPrice,
        'high24h': high24h,
        'low24h': low24h,
        'volume24h': volume24h,
        'change24h': change24h,
        'lastUpdate': lastUpdate.toIso8601String(),
      };

  MarketData toMarketData() => MarketData(
        symbol: symbol,
        currentPrice: currentPrice,
        high24h: high24h,
        low24h: low24h,
        volume24h: volume24h,
        change24h: change24h,
        lastUpdate: lastUpdate,
      );
}
