import '../../models/trade_data.dart';
import '../../models/order.dart';
import '../../models/portfolio.dart';

/// Abstract API service contract.
///
/// Implement this interface to connect to any backend (REST, gRPC, WebSocket).
/// [MockApiService] ships with the app for offline/demo mode.
abstract class ApiService {
  /// Check backend health and authenticate.
  Future<bool> connect({required String apiKey});

  /// Disconnect / invalidate session.
  Future<void> disconnect();

  /// Fetch current market prices.
  Future<List<Asset>> fetchAssets();

  /// Fetch detailed market data for tracked symbols.
  Future<List<MarketData>> fetchMarketData();

  /// Fetch user portfolio.
  Future<Portfolio> fetchPortfolio();

  /// Fetch order history.
  Future<List<Order>> fetchOrders();

  /// Place a new order.
  Future<Order> placeOrder({
    required String symbol,
    required String type,
    required double amount,
  });

  /// Cancel an existing order.
  Future<bool> cancelOrder(String orderId);
}
