import 'dart:async';
import 'package:flutter/material.dart';
import '../models/trade_data.dart';
import '../models/order.dart';
import '../models/portfolio.dart';

class TradeProvider extends ChangeNotifier {
  // Текущие данные рынка
  List<Asset> _assets = [];
  List<MarketData> _marketData = [];

  // Ордера
  final List<Order> _orders = [];
  final List<Order> _activeOrders = [];
  final List<Order> _completedOrders = [];

  // Портфель
  Portfolio? _portfolio;

  // Состояние
  bool _isConnected = false;
  String _connectionStatus = 'Disconnected';
  String? _errorMessage;

  // Timer для обновлений рынка
  Timer? _marketUpdateTimer;

  // Getters — defensive copies prevent external mutation
  List<Asset> get assets => List.unmodifiable(_assets);
  List<MarketData> get marketData => List.unmodifiable(_marketData);
  List<Order> get orders => List.unmodifiable(_orders);
  List<Order> get activeOrders => List.unmodifiable(_activeOrders);
  List<Order> get completedOrders => List.unmodifiable(_completedOrders);
  Portfolio? get portfolio => _portfolio;
  bool get isConnected => _isConnected;
  String get connectionStatus => _connectionStatus;
  String? get errorMessage => _errorMessage;

  TradeProvider() {
    _initializeMockData();
    _startMarketUpdates();
  }

  @override
  void dispose() {
    _cancelMarketUpdates();
    super.dispose();
  }

  void _initializeMockData() {
    // Инициализация тестовых данных
    _assets = [
      Asset(
        symbol: 'BTC',
        price: 64230.50,
        change24h: 1250.30,
        changePercent: 2.0,
      ),
      Asset(
        symbol: 'ETH',
        price: 3450.75,
        change24h: -45.20,
        changePercent: -1.3,
      ),
      Asset(
        symbol: 'SOL',
        price: 145.20,
        change24h: 12.5,
        changePercent: 9.4,
      ),
      Asset(
        symbol: 'XRP',
        price: 0.62,
        change24h: 0.03,
        changePercent: 5.1,
      ),
      Asset(
        symbol: 'DOGE',
        price: 0.16,
        change24h: 0.005,
        changePercent: 3.2,
      ),
    ];

    _marketData = [
      MarketData(
        symbol: 'BTC',
        currentPrice: 64230.50,
        high24h: 64500.00,
        low24h: 62800.00,
        volume24h: 28.5,
        change24h: 1250.30,
        lastUpdate: DateTime.now(),
      ),
      MarketData(
        symbol: 'ETH',
        currentPrice: 3450.75,
        high24h: 3520.00,
        low24h: 3400.00,
        volume24h: 18.2,
        change24h: -45.20,
        lastUpdate: DateTime.now(),
      ),
      MarketData(
        symbol: 'SOL',
        currentPrice: 145.20,
        high24h: 150.00,
        low24h: 135.00,
        volume24h: 2.5,
        change24h: 12.5,
        lastUpdate: DateTime.now(),
      ),
    ];

    _portfolio = Portfolio(
      totalValue: 52843.63,
      availableCash: 5200.00,
      totalInvested: 47643.63,
      totalProfitLoss: 1683.63,
      totalProfitLossPercent: 3.53,
      holdings: [
        PortfolioItem(
          symbol: 'BTC',
          amount: 0.5,
          avgPrice: 61500.0,
          currentPrice: 64230.50,
          profitLoss: 1365.25,
          profitLossPercent: 4.44,
          value: 32115.25,
        ),
        PortfolioItem(
          symbol: 'ETH',
          amount: 4.5,
          avgPrice: 3380.0,
          currentPrice: 3450.75,
          profitLoss: 318.38,
          profitLossPercent: 2.10,
          value: 15528.38,
        ),
      ],
      lastUpdate: DateTime.now(),
    );

    notifyListeners();
  }

  void _startMarketUpdates() {
    // TODO(api): заменить таймер на подписку на WebSocket биржи.
    _marketUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      for (int i = 0; i < _assets.length; i++) {
        final asset = _assets[i];
        // Случайное изменение цены
        final change =
            (asset.change24h * (1 + (DateTime.now().second % 10) / 100));
        _assets[i] = asset.copyWith(
          price: asset.price + (change * 0.01),
          change24h: change,
          changePercent: (change / (asset.price - change)) * 100,
        );

        final marketIndex = _marketData.indexWhere(
          (data) => data.symbol == asset.symbol,
        );
        if (marketIndex >= 0) {
          final market = _marketData[marketIndex];
          _marketData[marketIndex] = market.copyWith(
            currentPrice: _assets[i].price,
            change24h: change,
            lastUpdate: DateTime.now(),
          );
        }
      }
      notifyListeners();
    });
  }

  void _cancelMarketUpdates() {
    _marketUpdateTimer?.cancel();
    _marketUpdateTimer = null;
  }

  // Подключение к боту
  Future<void> connect() async {
    // TODO(api): подключить авторизацию и health-check удалённого бота.
    _isConnected = true;
    _connectionStatus = 'Connected';
    _errorMessage = null;
    notifyListeners();
  }

  void disconnect() {
    _isConnected = false;
    _connectionStatus = 'Disconnected';
    notifyListeners();
  }

  // Создание ордера
  Future<void> placeOrder({
    required String symbol,
    required String type,
    required double amount,
  }) async {
    if (!_isConnected) {
      _errorMessage = 'Not connected to bot';
      notifyListeners();
      return;
    }

    if (amount <= 0 || _getSymbolPrice(symbol) <= 0) {
      _errorMessage = 'Invalid order parameters';
      notifyListeners();
      return;
    }

    Order order = Order(
      orderId: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      symbol: symbol,
      type: type,
      price: _getSymbolPrice(symbol),
      amount: amount,
      status: 'pending',
      timestamp: DateTime.now(),
    );

    _orders.add(order);
    _activeOrders.add(order);

    notifyListeners();

    // Симуляция выполнения ордера
    await Future.delayed(const Duration(seconds: 2));

    // TODO(api): заменить локальное исполнение ответом торгового API.
    order = order.copyWith(status: 'completed', filledAmount: amount);
    final orderIndex = _orders.indexWhere((o) => o.orderId == order.orderId);
    if (orderIndex >= 0) _orders[orderIndex] = order;
    _activeOrders.removeWhere((o) => o.orderId == order.orderId);
    _completedOrders.add(order);

    notifyListeners();
  }

  double _getSymbolPrice(String symbol) {
    final asset = _assets.firstWhere(
      (a) => a.symbol.toUpperCase() == symbol.toUpperCase(),
      orElse: () => _assets[0],
    );
    return asset.price;
  }

  // Получить данные по символу
  MarketData? getMarketData(String symbol) {
    for (final marketData in _marketData) {
      if (marketData.symbol.toUpperCase() == symbol.toUpperCase()) {
        return marketData;
      }
    }
    return null;
  }

  // Получить актив по символу
  Asset? getAsset(String symbol) {
    try {
      return _assets.firstWhere(
        (a) => a.symbol.toUpperCase() == symbol.toUpperCase(),
      );
    } catch (e) {
      return null;
    }
  }

  // Очистить ошибку
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
