# Trade Bot API Documentation

## Обзор

Trade Bot предоставляет структуру для работы с криптовалютным рынком через объектно-ориентированный подход.

## Модели данных (Models)

### Order

Представляет торговый ордер.

**Свойства:**
- `orderId` (String) - Уникальный идентификатор ордера
- `symbol` (String) - Тикер актива (например, "BTC", "ETH")
- `type` (String) - Тип ордера ("buy" или "sell")
- `price` (double) - Цена за единицу
- `amount` (double) - Количество единиц
- `filledAmount` (double) - Количество, которое было заполнено (по умолчанию 0.0)
- `status` (String) - Статус ордера
- `timestamp` (DateTime) - Время создания ордера
- `errorMessage` (String?) - Сообщение об ошибке (опционально)

**Методы:**
- `isCompleted` (bool) - Возвращает true, если статус "completed" или "filled"
- `isPending` (bool) - Возвращает true, если статус "pending" или "partial"

**Пример:**
```dart
final order = Order(
  orderId: 'order-123',
  symbol: 'BTC',
  type: 'buy',
  price: 50000.0,
  amount: 1.0,
  status: 'pending',
  timestamp: DateTime.now(),
);
```

### Asset

Представляет криптовалютный актив.

**Свойства:**
- `symbol` (String) - Тикер актива
- `price` (double) - Текущая цена
- `change24h` (double) - Изменение за 24 часа
- `changePercent` (double) - Процентное изменение за 24 часа

**Пример:**
```dart
final asset = Asset(
  symbol: 'BTC',
  price: 64230.50,
  change24h: 1250.30,
  changePercent: 2.0,
);
```

### MarketData

Представляет рыночные данные.

**Свойства:**
- `symbol` (String) - Тикер актива
- `currentPrice` (double) - Текущая цена
- `high24h` (double) - Максимальная цена за 24 часа
- `low24h` (double) - Минимальная цена за 24 часа
- `volume24h` (double) - Объем торгов за 24 часа
- `change24h` (double) - Изменение цены за 24 часа
- `lastUpdate` (DateTime) - Время последнего обновления

**Пример:**
```dart
final marketData = MarketData(
  symbol: 'BTC',
  currentPrice: 64230.50,
  high24h: 63500.00,
  low24h: 62800.00,
  volume24h: 28.5,
  change24h: 1250.30,
  lastUpdate: DateTime.now(),
);
```

### Trade

Представляет отдельную сделку.

**Свойства:**
- `id` (String) - Уникальный идентификатор
- `symbol` (String) - Тикер актива
- `type` (String) - Тип ("buy" или "sell")
- `amount` (double) - Количество
- `price` (double) - Цена за единицу
- `total` (double) - Общая сумма
- `timestamp` (DateTime) - Время сделки
- `status` (String) - Статус

**Пример:**
```dart
final trade = Trade(
  id: 'trade-123',
  symbol: 'BTC',
  type: 'buy',
  amount: 0.5,
  price: 50000.0,
  total: 25000.0,
  timestamp: DateTime.now(),
  status: 'completed',
);
```

### Portfolio

Представляет общий портфель пользователя.

**Свойства:**
- `totalValue` (double) - Общая стоимость портфеля
- `availableCash` (double) - Доступные средства
- `totalInvested` (double) - Общие инвестиции
- `totalProfitLoss` (double) - Общая прибыль/убыток
- `totalProfitLossPercent` (double) - Процент прибыли/убытка
- `holdings` (List<PortfolioItem>) - Список позиций
- `lastUpdate` (DateTime) - Время последнего обновления

**Пример:**
```dart
final portfolio = Portfolio(
  totalValue: 15420.50,
  availableCash: 5200.00,
  totalInvested: 10220.50,
  totalProfitLoss: 520.30,
  totalProfitLossPercent: 5.38,
  holdings: [
    PortfolioItem(
      symbol: 'BTC',
      amount: 0.5,
      avgPrice: 61500.0,
      currentPrice: 64230.50,
      profitLoss: 115.25,
      profitLossPercent: 3.75,
      value: 32115.25,
    ),
  ],
  lastUpdate: DateTime.now(),
);
```

### PortfolioItem

Представляет отдельную позицию в портфеле.

**Свойства:**
- `symbol` (String) - Тикер актива
- `amount` (double) - Количество
- `avgPrice` (double) - Средняя цена входа
- `currentPrice` (double) - Текущая цена
- `profitLoss` (double) - Прибыль/убыток
- `profitLossPercent` (double) - Процент прибыли/убытка
- `value` (double) - Текущая стоимость

**Пример:**
```dart
final holding = PortfolioItem(
  symbol: 'BTC',
  amount: 0.5,
  avgPrice: 61500.0,
  currentPrice: 64230.50,
  profitLoss: 115.25,
  profitLossPercent: 3.75,
  value: 32115.25,
);
```

## Провайдер (Provider)

### TradeProvider

Класс для управления состоянием приложения и данными о рынке.

**Свойства (private):**
- `_assets` (List<Asset>) - Список активов
- `_marketData` (List<MarketData>) - Рыночные данные
- `_orders` (List<Order>) - Все ордера
- `_activeOrders` (List<Order>) - Активные ордера
- `_completedOrders` (List<Order>) - Завершенные ордера
- `_portfolio` (Portfolio?) - Портфель
- `_isConnected` (bool) - Статус подключения
- `_connectionStatus` (String) - Статус подключения
- `_errorMessage` (String?) - Сообщение об ошибке
- `_marketUpdateTimer` (Timer?) - Таймер для обновлений

**Геттеры (public):**
- `assets` (List<Asset>) - Список активов
- `marketData` (List<MarketData>) - Рыночные данные
- `orders` (List<Order>) - Все ордера
- `activeOrders` (List<Order>) - Активные ордера
- `completedOrders` (List<Order>) - Завершенные ордера
- `portfolio` (Portfolio?) - Портфель
- `isConnected` (bool) - Статус подключения
- `connectionStatus` (String) - Статус подключения
- `errorMessage` (String?) - Сообщение об ошибке

**Методы:**

#### `TradeProvider()`
Конструктор инициализирует mock-данные и начинает обновления рынка.

#### `dispose()`
Освобождает ресурсы, отменяет Timer.

#### `_initializeMockData()`
Инициализирует тестовые данные для демонстрации.

#### `_startMarketUpdates()`
Запускает периодическое обновление цен (каждые 5 секунд).

#### `_cancelMarketUpdates()`
Отменяет обновления рынка.

**Использование:**
```dart
// В виджете
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TradeProvider>(
      builder: (context, provider, child) {
        return Text(provider.assets.first.price.toString());
      },
    );
  }
}
```

## Услуги (Services)

### NavigationService

Класс для управления навигацией через Named Routes.

**Статические константы:**
- `homeRoute` (String) - Маршрут главной страницы ("/")
- `historyRoute` (String) - Маршрут истории ("/history")
- `settingsRoute` (String) - Маршрут настроек ("/settings")
- `chartRoute` (String) - Маршрут графиков ("/chart")

**Методы:**

#### `getInitialRoute()`
Возвращает начальный маршрут приложения.

**Использование:**
```dart
MaterialApp(
  initialRoute: NavigationService.homeRoute,
  routes: {
    NavigationService.homeRoute: (context) => HomeScreen(),
    NavigationService.chartRoute: (context) => ChartScreen(),
  },
);
```

## Темы (Theme)

### TradeColors

Содержит цветовую палитру приложения.

**Основные цвета:**
- `primaryPurple` (Color) - Основной фиолетовый (#6C5CE7)
- `lightPurple` (Color) - Светлый фиолетовый (#A29BFE)
- `secondaryBlue` (Color) - Синий акцент (#4F46E5)
- `accentPink` (Color) - Розовый (#FD79A8)
- `accentCyan` (Color) - Голубой (#00CEC9)

**Цвета статусов:**
- `successGreen` (Color) - Успех (#00B894)
- `errorRed` (Color) - Ошибка (#D63031)
- `warningOrange` (Color) - Предупреждение (#FF9800)
- `infoBlue` (Color) - Информация (#2196F3)

**Фоновые цвета:**
- `background` (Color) - Фон (#0F0F1A)
- `surface` (Color) - Поверхность (#1A1A2E)
- `card` (Color) - Карточка (#2C2C2C)

**Цвета текста:**
- `primaryText` (Color) - Основной текст (#FFFFFF)
- `secondaryText` (Color) - Вторичный текст (#B0B0B0)
- `disabledText` (Color) - Отключенный текст (#6B6B6B)

### TradeThemes

Содержит тему приложения.

**Методы:**

#### `lightTheme()`
Возвращает светлую тему.

#### `darkTheme()`
Возвращает темную тему.

**Использование:**
```dart
MaterialApp(
  theme: TradeThemes.lightTheme(),
  darkTheme: TradeThemes.darkTheme(),
  themeMode: ThemeMode.system,
);
```

## Примеры реализации

### Создание ордера
```dart
final order = Order(
  orderId: 'order-123',
  symbol: 'BTC',
  type: 'buy',
  price: 50000.0,
  amount: 1.0,
  status: 'pending',
  timestamp: DateTime.now(),
);
```

### Чтение данных из TradeProvider
```dart
Consumer<TradeProvider>(
  builder: (context, provider, child) {
    if (provider.assets.isEmpty) {
      return CircularProgressIndicator();
    }
    
    final asset = provider.assets.first;
    return Text(
      '\$${asset.price.toStringAsFixed(2)}',
      style: TextStyle(fontSize: 24),
    );
  },
);
```

### Фильтрация ордеров
```dart
final activeOrders = tradeProvider.activeOrders
  .where((order) => order.type == 'buy')
  .toList();
```

### Расчет прибыли/убытка
```dart
final totalProfitLoss = tradeProvider.portfolio?.totalProfitLoss ?? 0.0;
final profitLossPercent = tradeProvider.portfolio?.totalProfitLossPercent ?? 0.0;

if (profitLossPercent > 0) {
  print('Прибыль: $profitLossPercent%');
} else if (profitLossPercent < 0) {
  print('Убыток: ${profitLossPercent.abs()}%');
}
```

## Будущие улучшения

1. **API Integration**: Подключение к реальным биржам (Binance, Bybit, OKX)
2. **WebSocket Support**: Реальное обновление данных в реальном времени
3. **Authentication**: Система авторизации пользователей
4. **Database**: Хранение данных локально (SQLite или Hive)
5. **Analytics**: Детальная аналитика и отчеты
6. **Notifications**: Уведомления о движениях рынка
