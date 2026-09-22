class Order {
  final String orderId;
  final String symbol;
  final String type;
  final double price;
  final double amount;
  final double filledAmount;
  final String status;
  final DateTime timestamp;
  final String? errorMessage;

  Order({
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

  bool get isCompleted => status == 'completed' || status == 'filled';
  bool get isPending => status == 'pending' || status == 'partial';

  Order copyWith({
    String? orderId,
    String? symbol,
    String? type,
    double? price,
    double? amount,
    double? filledAmount,
    String? status,
    DateTime? timestamp,
    String? errorMessage,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      symbol: symbol ?? this.symbol,
      type: type ?? this.type,
      price: price ?? this.price,
      amount: amount ?? this.amount,
      filledAmount: filledAmount ?? this.filledAmount,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
