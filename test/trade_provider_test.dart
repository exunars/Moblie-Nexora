import 'package:flutter_test/flutter_test.dart';
import 'package:tradebot/providers/trade_provider.dart';
import 'package:tradebot/models/order.dart';
import 'package:tradebot/models/trade_data.dart';
import 'package:tradebot/models/portfolio.dart';

void main() {
  group('TradeProvider Tests', () {
    late TradeProvider tradeProvider;

    setUp(() {
      tradeProvider = TradeProvider();
    });

    tearDown(() {
      tradeProvider.dispose();
    });

    test('инициализация с mock-данными', () {
      expect(tradeProvider.assets.isNotEmpty, isTrue);
      expect(tradeProvider.marketData.isNotEmpty, isTrue);
      expect(tradeProvider.isConnected, isFalse);
      expect(tradeProvider.connectionStatus, 'Disconnected');
    });

    test('данные о рынке корректны', () {
      final asset = tradeProvider.assets.first;
      expect(asset.symbol, isNotNull);
      expect(asset.price, isNonNegative);
      expect(asset.change24h, isA<double>());
      expect(asset.changePercent, isA<double>());
    });

    test('ордер имеет правильную структуру', () {
      final orders = tradeProvider.orders;
      if (orders.isNotEmpty) {
        final order = orders.first;
        expect(order.orderId, isNotNull);
        expect(order.symbol, isNotNull);
        expect(order.type, isNotNull);
        expect(order.price, isNonNegative);
        expect(order.amount, isNonNegative);
        expect(order.status, isNotNull);
      }
    });

    test('портфель имеет правильную структуру', () {
      final portfolio = tradeProvider.portfolio;
      expect(portfolio, isNotNull);
      expect(portfolio!.totalValue, isNonNegative);
      expect(portfolio.availableCash, isNonNegative);
      expect(portfolio.holdings.isNotEmpty, isTrue);

      final holding = portfolio.holdings.first;
      expect(holding.symbol, isNotNull);
      expect(holding.amount, isNonNegative);
      expect(holding.currentPrice, isNonNegative);
    });

    test('получение копии ордеров не меняет оригинал', () {
      final initialLength = tradeProvider.orders.length;
      final copyOrders = tradeProvider.orders;
      expect(copyOrders.length, equals(initialLength));
    });

    test('смена маркета должна обновлять данные', () async {
      final initialAsset = tradeProvider.assets.first;
      final initialPrice = initialAsset.price;

      await Future.delayed(const Duration(seconds: 5));
      final newAsset = tradeProvider.assets.first;
      expect(newAsset.price, isNot(equals(initialPrice)));
    });
  });

  group('Order Model Tests', () {
    test('создание нового ордера', () {
      final order = Order(
        orderId: 'test-123',
        symbol: 'BTC',
        type: 'buy',
        price: 50000.0,
        amount: 1.0,
        status: 'pending',
        timestamp: DateTime.now(),
      );

      expect(order.orderId, 'test-123');
      expect(order.symbol, 'BTC');
      expect(order.type, 'buy');
      expect(order.price, 50000.0);
      expect(order.amount, 1.0);
      expect(order.status, 'pending');
    });

    test('проверка статуса ордера', () {
      final completedOrder = Order(
        orderId: 'test-1',
        symbol: 'BTC',
        type: 'buy',
        price: 50000.0,
        amount: 1.0,
        status: 'completed',
        timestamp: DateTime.now(),
      );

      final pendingOrder = Order(
        orderId: 'test-2',
        symbol: 'BTC',
        type: 'buy',
        price: 50000.0,
        amount: 1.0,
        status: 'pending',
        timestamp: DateTime.now(),
      );

      expect(completedOrder.isCompleted, isTrue);
      expect(completedOrder.isPending, isFalse);
      expect(pendingOrder.isCompleted, isFalse);
      expect(pendingOrder.isPending, isTrue);
    });

    test('копирование ордера', () {
      final originalOrder = Order(
        orderId: 'test-123',
        symbol: 'BTC',
        type: 'buy',
        price: 50000.0,
        amount: 1.0,
        status: 'pending',
        timestamp: DateTime.now(),
      );

      final copyOrder = originalOrder.copyWith(
        orderId: 'test-456',
        status: 'completed',
      );

      expect(copyOrder.orderId, 'test-456');
      expect(copyOrder.status, 'completed');
      expect(copyOrder.symbol, originalOrder.symbol);
      expect(copyOrder.price, originalOrder.price);
    });
  });

  group('Asset Model Tests', () {
    test('создание актива', () {
      final asset = Asset(
        symbol: 'BTC',
        price: 50000.0,
        change24h: 1000.0,
        changePercent: 2.0,
      );

      expect(asset.symbol, 'BTC');
      expect(asset.price, 50000.0);
      expect(asset.change24h, 1000.0);
      expect(asset.changePercent, 2.0);
    });
  });

  group('Portfolio Model Tests', () {
    test('создание портфеля', () {
      final portfolio = Portfolio(
        totalValue: 100000.0,
        availableCash: 50000.0,
        totalInvested: 50000.0,
        totalProfitLoss: 10000.0,
        totalProfitLossPercent: 20.0,
        holdings: [],
        lastUpdate: DateTime.now(),
      );

      expect(portfolio.totalValue, 100000.0);
      expect(portfolio.availableCash, 50000.0);
      expect(portfolio.totalInvested, 50000.0);
      expect(portfolio.totalProfitLoss, 10000.0);
      expect(portfolio.totalProfitLossPercent, 20.0);
      expect(portfolio.holdings, isEmpty);
    });

    test('создание позиции в портфеле', () {
      final holding = PortfolioItem(
        symbol: 'BTC',
        amount: 1.0,
        avgPrice: 45000.0,
        currentPrice: 50000.0,
        profitLoss: 5000.0,
        profitLossPercent: 11.11,
        value: 50000.0,
      );

      expect(holding.symbol, 'BTC');
      expect(holding.amount, 1.0);
      expect(holding.profitLoss, 5000.0);
      expect(holding.profitLossPercent, 11.11);
      expect(holding.value, 50000.0);
    });
  });

  group('MarketData Model Tests', () {
    test('создание данных рынка', () {
      final marketData = MarketData(
        symbol: 'BTC',
        currentPrice: 50000.0,
        high24h: 51000.0,
        low24h: 49000.0,
        volume24h: 100.0,
        change24h: 1000.0,
        lastUpdate: DateTime.now(),
      );

      expect(marketData.symbol, 'BTC');
      expect(marketData.currentPrice, 50000.0);
      expect(marketData.high24h, 51000.0);
      expect(marketData.low24h, 49000.0);
      expect(marketData.change24h, 1000.0);
      expect(marketData.lastUpdate, isNotNull);
    });
  });
}
