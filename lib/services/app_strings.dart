import 'package:flutter/material.dart';

class AppStrings {
  const AppStrings(this.locale);

  final Locale locale;

  bool get isEnglish => locale.languageCode == 'en';
  bool get isUkrainian => locale.languageCode == 'uk';

  String get(String key) {
    final values = <String, Map<String, String>>{
      'overview': {'ru': 'Обзор', 'en': 'Overview', 'uk': 'Огляд'},
      'bots': {'ru': 'Боты', 'en': 'Bots', 'uk': 'Боти'},
      'history': {'ru': 'История', 'en': 'History', 'uk': 'Історія'},
      'backtests': {'ru': 'Бэктесты', 'en': 'Backtests', 'uk': 'Бектести'},
      'exchanges': {'ru': 'Биржи', 'en': 'Exchanges', 'uk': 'Біржі'},
      'subscription': {
        'ru': 'Подписка',
        'en': 'Subscription',
        'uk': 'Підписка'
      },
      'settings': {'ru': 'Настройки', 'en': 'Settings', 'uk': 'Налаштування'},
      'help': {'ru': 'Помощь', 'en': 'Help', 'uk': 'Допомога'},
      'workspace': {
        'ru': 'РАБОЧЕЕ ПРОСТРАНСТВО',
        'en': 'WORKSPACE',
        'uk': 'РОБОЧИЙ ПРОСТІР'
      },
      'portfolio_market': {
        'ru': 'Портфель и рынок',
        'en': 'Portfolio and market',
        'uk': 'Портфель і ринок'
      },
      'strategies_launch': {
        'ru': 'Стратегии и запуск',
        'en': 'Strategies and launch',
        'uk': 'Стратегії та запуск'
      },
      'orders_executions': {
        'ru': 'Ордера и исполнения',
        'en': 'Orders and executions',
        'uk': 'Ордери та виконання'
      },
      'strategy_testing': {
        'ru': 'Проверка стратегий',
        'en': 'Strategy testing',
        'uk': 'Перевірка стратегій'
      },
      'api_connections': {
        'ru': 'API и подключения',
        'en': 'API and connections',
        'uk': 'API та підключення'
      },
      'plan_access': {
        'ru': 'Тариф и доступ',
        'en': 'Plan and access',
        'uk': 'Тариф і доступ'
      },
      'profile_security': {
        'ru': 'Профиль и безопасность',
        'en': 'Profile and security',
        'uk': 'Профіль і безпека'
      },
      'support_answers': {
        'ru': 'Поддержка и ответы',
        'en': 'Support and answers',
        'uk': 'Підтримка та відповіді'
      },
      'subscription_inactive': {
        'ru': 'Подписка неактивна',
        'en': 'Subscription inactive',
        'uk': 'Підписка неактивна'
      },
      'access_limited': {
        'ru': 'Доступ ограничен',
        'en': 'Access limited',
        'uk': 'Доступ обмежено'
      },
      'activate': {'ru': 'Активировать', 'en': 'Activate', 'uk': 'Активувати'},
      'logout': {'ru': 'Выйти', 'en': 'Log out', 'uk': 'Вийти'},
      'open_menu': {
        'ru': 'Открыть меню',
        'en': 'Open menu',
        'uk': 'Відкрити меню'
      },
      'notifications': {
        'ru': 'Уведомления',
        'en': 'Notifications',
        'uk': 'Сповіщення'
      },
      'account': {'ru': 'АККАУНТ', 'en': 'ACCOUNT', 'uk': 'ОБЛІКОВИЙ ЗАПИС'},
      'trading': {'ru': 'ТОРГОВЛЯ', 'en': 'TRADING', 'uk': 'ТОРГІВЛЯ'},
      'application': {'ru': 'ПРИЛОЖЕНИЕ', 'en': 'APP', 'uk': 'ЗАСТОСУНОК'},
      'profile': {'ru': 'Профиль', 'en': 'Profile', 'uk': 'Профіль'},
      'demo_account': {
        'ru': 'Демо-аккаунт',
        'en': 'Demo account',
        'uk': 'Демо-акаунт'
      },
      'security': {'ru': 'Безопасность', 'en': 'Security', 'uk': 'Безпека'},
      'password_2fa': {
        'ru': 'Пароль и 2FA',
        'en': 'Password and 2FA',
        'uk': 'Пароль і 2FA'
      },
      'two_fa_enabled': {
        'ru': '2FA включена',
        'en': '2FA enabled',
        'uk': '2FA увімкнено'
      },
      'paper_trading': {
        'ru': 'Paper trading',
        'en': 'Paper trading',
        'uk': 'Paper trading'
      },
      'no_real_funds': {
        'ru': 'Без реальных средств',
        'en': 'No real funds',
        'uk': 'Без реальних коштів'
      },
      'exchange_api': {
        'ru': 'API бирж',
        'en': 'Exchange APIs',
        'uk': 'API бірж'
      },
      'not_configured': {
        'ru': 'Подключения не настроены',
        'en': 'No connections configured',
        'uk': 'Підключення не налаштовані'
      },
      'connected': {'ru': 'подключено', 'en': 'connected', 'uk': 'підключено'},
      'bots_section': {'ru': 'БОТЫ', 'en': 'BOTS', 'uk': 'БОТИ'},
      'app_notifications': {
        'ru': 'Уведомления',
        'en': 'Notifications',
        'uk': 'Сповіщення'
      },
      'push_signals': {
        'ru': 'Push и сигналы бота',
        'en': 'Push and bot alerts',
        'uk': 'Push і сигнали бота'
      },
      'biometrics': {'ru': 'Биометрия', 'en': 'Biometrics', 'uk': 'Біометрія'},
      'quick_login': {
        'ru': 'Быстрый вход',
        'en': 'Quick login',
        'uk': 'Швидкий вхід'
      },
      'language': {'ru': 'Язык', 'en': 'Language', 'uk': 'Мова'},
      'about': {'ru': 'О приложении', 'en': 'About', 'uk': 'Про застосунок'},
      'strategy': {'ru': 'Стратегия', 'en': 'Strategy', 'uk': 'Стратегія'},
      'risk_per_trade': {
        'ru': 'Риск на сделку',
        'en': 'Risk per trade',
        'uk': 'Ризик на угоду'
      },
      'advanced': {
        'ru': 'Расширенные параметры',
        'en': 'Advanced settings',
        'uk': 'Розширені параметри'
      },
      'connected_status': {
        'ru': 'Подключено',
        'en': 'Connected',
        'uk': 'Підключено'
      },
      'disconnected_status': {
        'ru': 'Не подключено',
        'en': 'Not connected',
        'uk': 'Не підключено'
      },
      'overview_subtitle': {
        'ru': 'Контроль ботов, бирж и состояния аккаунта',
        'en': 'Control bots, exchanges and account status',
        'uk': 'Керування ботами, біржами та станом облікового запису'
      },
      'getting_started': {
        'ru': 'С чего начать',
        'en': 'Getting started',
        'uk': 'З чого почати'
      },
      'market': {'ru': 'Рынок', 'en': 'Market', 'uk': 'Ринок'},
      'exchange_balance': {
        'ru': 'Баланс на бирже',
        'en': 'Exchange balance',
        'uk': 'Баланс на біржі'
      },
      'not_connected_exchange': {
        'ru': 'Биржа ещё не подключена.',
        'en': 'No exchange connected yet.',
        'uk': 'Біржу ще не підключено.'
      },
      'connect': {'ru': 'Подключить', 'en': 'Connect', 'uk': 'Підключити'},
      'active_sessions': {
        'ru': 'Активные входы',
        'en': 'Active sessions',
        'uk': 'Активні входи'
      },
      'only_this_device': {
        'ru': 'Только это устройство.',
        'en': 'Only this device.',
        'uk': 'Лише цей пристрій.'
      },
      'orders': {'ru': 'Ордера', 'en': 'Orders', 'uk': 'Ордери'},
      'executions': {'ru': 'Исполнения', 'en': 'Executions', 'uk': 'Виконання'},
      'positions': {'ru': 'Позиции', 'en': 'Positions', 'uk': 'Позиції'},
      'all_bots': {'ru': 'Все боты', 'en': 'All bots', 'uk': 'Усі боти'},
      'download_csv': {
        'ru': 'Выгрузить CSV',
        'en': 'Export CSV',
        'uk': 'Експортувати CSV'
      },
      'no_orders': {
        'ru': 'Ордеров пока нет.',
        'en': 'No orders yet.',
        'uk': 'Ордерів ще немає.'
      },
      'no_executions': {
        'ru': 'Пока ничего не исполнилось.',
        'en': 'Nothing has executed yet.',
        'uk': 'Поки нічого не виконано.'
      },
      'positions_api': {
        'ru': 'Позиции появятся после подключения API биржи.',
        'en': 'Positions will appear after connecting an exchange API.',
        'uk': 'Позиції з’являться після підключення API біржі.'
      },
      'configure_exchange': {
        'ru': 'Настроить биржу',
        'en': 'Configure exchange',
        'uk': 'Налаштувати біржу'
      },
      'choose_subscription': {
        'ru': 'Выбрать подписку',
        'en': 'Choose subscription',
        'uk': 'Обрати підписку'
      },
      'create_ticket': {
        'ru': 'Создать обращение',
        'en': 'Create ticket',
        'uk': 'Створити звернення'
      },
      'failed_telegram': {
        'ru': 'Не удалось открыть Telegram',
        'en': 'Could not open Telegram',
        'uk': 'Не вдалося відкрити Telegram'
      },
      'language_changed': {
        'ru': 'Язык изменён',
        'en': 'Language changed',
        'uk': 'Мову змінено'
      },
      'exchange_api_dialog': {
        'ru': 'Подключить API биржи',
        'en': 'Connect exchange API',
        'uk': 'Підключити API біржі'
      },
      'exchange': {'ru': 'Биржа', 'en': 'Exchange', 'uk': 'Біржа'},
      'exchange_subtitle': {
        'ru':
            'Подключите источники данных и торговые API через защищённое хранилище.',
        'en': 'Connect data sources and trading APIs through secure storage.',
        'uk': 'Підключіть джерела даних і торгові API через захищене сховище.'
      },
      'exchanges_empty': {
        'ru': 'Биржи пока не подключены',
        'en': 'No exchanges connected yet',
        'uk': 'Біржі ще не підключені'
      },
      'exchanges_empty_text': {
        'ru':
            'Добавленные подключения появятся здесь после загрузки из базы данных.',
        'en':
            'Added connections will appear here after loading from the database.',
        'uk':
            'Додані підключення з’являться тут після завантаження з бази даних.'
      },
      'subscription_subtitle': {
        'ru': 'Управление тарифом и доступом к функциям платформы.',
        'en': 'Manage your plan and access to platform features.',
        'uk': 'Керування тарифом і доступом до функцій платформи.'
      },
      'subscription_empty_text': {
        'ru':
            'Тариф и срок действия появятся после подключения платёжного сервиса.',
        'en':
            'The plan and expiry date will appear after connecting a payment service.',
        'uk':
            'Тариф і термін дії з’являться після підключення платіжного сервісу.'
      },
      'backtest_form_description': {
        'ru':
            'Та же сетка, что у бота, на исторических свечах выбранной биржи. Результаты появятся после подключения источника данных.',
        'en':
            'The same grid as the bot, using historical candles from the selected exchange. Results will appear after connecting a data source.',
        'uk':
            'Та сама сітка, що й у бота, на історичних свічках обраної біржі. Результати з’являться після підключення джерела даних.'
      },
      'timeframe': {'ru': 'Таймфрейм', 'en': 'Timeframe', 'uk': 'Таймфрейм'},
      'choose_timeframe': {
        'ru': 'Выберите таймфрейм',
        'en': 'Choose timeframe',
        'uk': 'Оберіть таймфрейм'
      },
      'candles': {'ru': 'Свечей', 'en': 'Candles', 'uk': 'Свічок'},
      'initial_capital': {
        'ru': 'Начальный капитал',
        'en': 'Initial capital',
        'uk': 'Початковий капітал'
      },
      'backtest_disclaimer': {
        'ru':
            'Бэктест использует только исторические данные и не размещает реальные ордера.',
        'en':
            'The backtest uses historical data only and does not place real orders.',
        'uk':
            'Бектест використовує лише історичні дані та не розміщує реальні ордери.'
      },
      'grid_calculation_short': {
        'ru': 'Параметры сетки будут рассчитаны после выбора стратегии.',
        'en': 'Grid parameters will be calculated after choosing a strategy.',
        'uk': 'Параметри сітки буде розраховано після вибору стратегії.'
      },
      'choose_exchange': {
        'ru': 'Выберите биржу',
        'en': 'Choose exchange',
        'uk': 'Оберіть біржу'
      },
      'api_key': {'ru': 'API key', 'en': 'API key', 'uk': 'API key'},
      'api_secret': {
        'ru': 'API secret',
        'en': 'API secret',
        'uk': 'API secret'
      },
      'testnet': {
        'ru': 'Testnet / paper',
        'en': 'Testnet / paper',
        'uk': 'Testnet / paper'
      },
      'cancel': {'ru': 'Отмена', 'en': 'Cancel', 'uk': 'Скасувати'},
      'save': {'ru': 'Сохранить', 'en': 'Save', 'uk': 'Зберегти'},
      'security_2fa': {
        'ru': 'Двухфакторная аутентификация',
        'en': 'Two-factor authentication',
        'uk': 'Двофакторна автентифікація'
      },
      'two_fa_hint': {
        'ru':
            '2FA понадобится перед подключением реальных средств и запуском торговли.',
        'en':
            '2FA is required before connecting real funds and starting trading.',
        'uk':
            '2FA потрібна перед підключенням реальних коштів і початком торгівлі.'
      },
      'enable_2fa': {
        'ru': 'Включить 2FA',
        'en': 'Enable 2FA',
        'uk': 'Увімкнути 2FA'
      },
      'language_dialog': {
        'ru': 'Язык приложения',
        'en': 'App language',
        'uk': 'Мова застосунку'
      },
      'realized_pnl': {
        'ru': 'Реализованный P&L',
        'en': 'Realized P&L',
        'uk': 'Реалізований P&L'
      },
      'closed_trades': {
        'ru': 'По закрытым сделкам',
        'en': 'From closed trades',
        'uk': 'За закритими угодами'
      },
      'commissions': {'ru': 'Комиссии', 'en': 'Commissions', 'uk': 'Комісії'},
      'gross_profit_compare': {
        'ru': 'Валовой прибыли для сравнения нет',
        'en': 'No gross profit to compare',
        'uk': 'Немає валового прибутку для порівняння'
      },
      'open_positions': {
        'ru': 'Открытые позиции',
        'en': 'Open positions',
        'uk': 'Відкриті позиції'
      },
      'nothing_held': {
        'ru': 'Ничего не держим',
        'en': 'Nothing held',
        'uk': 'Нічого не утримуємо'
      },
      'bots_running': {
        'ru': 'Боты в работе',
        'en': 'Bots running',
        'uk': 'Боти в роботі'
      },
      'getting_started_subtitle': {
        'ru': 'Три шага до бота, торгующего вашими средствами.',
        'en': 'Three steps to a bot trading your funds.',
        'uk': 'Три кроки до бота, який торгує вашими коштами.'
      },
      'create_paper_bot': {
        'ru': 'Создайте бумажного бота',
        'en': 'Create a paper bot',
        'uk': 'Створіть паперового бота'
      },
      'paper_bot_description': {
        'ru':
            'Сетка на живых ценах с симулированными данными, без биржевого ключа.',
        'en':
            'A grid using live prices with simulated funds, without an exchange key.',
        'uk': 'Сітка на живих цінах із симульованими коштами, без ключа біржі.'
      },
      'protect_account': {
        'ru': 'Защитите аккаунт',
        'en': 'Protect your account',
        'uk': 'Захистіть обліковий запис'
      },
      'two_fa_description': {
        'ru': 'Двухфакторная аутентификация нужна до запуска реальных средств.',
        'en': 'Two-factor authentication is required before using real funds.',
        'uk': 'Двофакторна автентифікація потрібна до запуску реальних коштів.'
      },
      'connect_exchange': {
        'ru': 'Подключите биржу',
        'en': 'Connect an exchange',
        'uk': 'Підключіть біржу'
      },
      'connect_exchange_description': {
        'ru': 'Добавьте API-ключ с отключённым выводом средств.',
        'en': 'Add an API key with withdrawals disabled.',
        'uk': 'Додайте API-ключ із вимкненим виведенням коштів.'
      },
      'create': {'ru': 'Создать', 'en': 'Create', 'uk': 'Створити'},
      'enable': {'ru': 'Включить', 'en': 'Enable', 'uk': 'Увімкнути'},
      'market_data_hint': {
        'ru': 'Пара будет проверена через market data API выбранной биржи.',
        'en':
            'The pair will be checked through the selected exchange market data API.',
        'uk': 'Пару буде перевірено через market data API обраної біржі.'
      },
      'grid_mode': {
        'ru': 'Режим сетки',
        'en': 'Grid mode',
        'uk': 'Режим сітки'
      },
      'sideways': {'ru': 'Боковик', 'en': 'Sideways', 'uk': 'Боковик'},
      'trend': {'ru': 'По тренду', 'en': 'Trend', 'uk': 'За трендом'},
      'deposit': {
        'ru': 'Депозит (USDT)',
        'en': 'Deposit (USDT)',
        'uk': 'Депозит (USDT)'
      },
      'sell_percent': {
        'ru': 'Продажа, +%',
        'en': 'Sell, +%',
        'uk': 'Продаж, +%'
      },
      'steps': {'ru': 'Ступеней', 'en': 'Steps', 'uk': 'Кроків'},
      'depth': {'ru': 'Глубина, %', 'en': 'Depth, %', 'uk': 'Глибина, %'},
      'first_line': {
        'ru': 'Нижняя строка к первой',
        'en': 'Bottom line to first',
        'uk': 'Нижній рядок до першого'
      },
      'market_scroller': {
        'ru': 'Прокрутить рынок',
        'en': 'Scroll market',
        'uk': 'Прокрутити ринок'
      },
      'form_description': {
        'ru':
            'Заполните параметры. Значения будут проверяться через выбранную биржу перед сохранением.',
        'en':
            'Fill in the parameters. Values will be checked through the selected exchange before saving.',
        'uk':
            'Заповніть параметри. Значення буде перевірено через обрану біржу перед збереженням.'
      },
      'mode': {'ru': 'Режим', 'en': 'Mode', 'uk': 'Режим'},
      'choose_mode': {
        'ru': 'Выберите режим',
        'en': 'Choose mode',
        'uk': 'Оберіть режим'
      },
      'paper': {'ru': 'Бумажный', 'en': 'Paper', 'uk': 'Паперовий'},
      'real': {'ru': 'Реальный', 'en': 'Real', 'uk': 'Реальний'},
      'pair': {'ru': 'Пара', 'en': 'Pair', 'uk': 'Пара'},
      'enter_pair': {
        'ru': 'Введите торговую пару',
        'en': 'Enter trading pair',
        'uk': 'Введіть торгову пару'
      },
      'strategy_choose': {
        'ru': 'Выберите стратегию',
        'en': 'Choose strategy',
        'uk': 'Оберіть стратегію'
      },
      'grid_table': {
        'ru': 'Заполнить таблицу по режиму',
        'en': 'Fill table by mode',
        'uk': 'Заповнити таблицю за режимом'
      },
      'grid_calculation': {
        'ru':
            'Параметры сетки будут рассчитаны после выбора стратегии и заполнения полей.',
        'en':
            'Grid parameters will be calculated after choosing a strategy and filling in the fields.',
        'uk':
            'Параметри сітки буде розраховано після вибору стратегії та заповнення полів.'
      },
      'fill_table': {
        'ru': 'Заполнить таблицу',
        'en': 'Fill table',
        'uk': 'Заповнити таблицю'
      },
      'grid_config': {
        'ru': 'Конфигурация сетки',
        'en': 'Grid configuration',
        'uk': 'Конфігурація сітки'
      },
      'awaiting_calculation': {
        'ru': 'Ожидает расчёта',
        'en': 'Awaiting calculation',
        'uk': 'Очікує розрахунку'
      },
      'limits': {'ru': 'Ограничения', 'en': 'Limits', 'uk': 'Обмеження'},
      'buy_range': {
        'ru': 'Покупать только в диапазоне',
        'en': 'Buy only in range',
        'uk': 'Купувати лише в діапазоні'
      },
      'not_below': {'ru': 'Не ниже', 'en': 'Not below', 'uk': 'Не нижче'},
      'not_above': {'ru': 'Не выше', 'en': 'Not above', 'uk': 'Не вище'},
      'one_cycle': {'ru': 'Один цикл', 'en': 'One cycle', 'uk': 'Один цикл'},
      'sell_stop': {
        'ru': 'Продать купленное и остановиться.',
        'en': 'Sell what was bought and stop.',
        'uk': 'Продати куплене та зупинитися.'
      },
      'follow_grid': {
        'ru': 'Подтягивать сетку за ценой',
        'en': 'Follow price with grid',
        'uk': 'Підтягувати сітку за ціною'
      },
      'recalculate_grid': {
        'ru': 'Пересчитывать сетку при движении рынка.',
        'en': 'Recalculate the grid as the market moves.',
        'uk': 'Перераховувати сітку під час руху ринку.'
      },
      'support_service': {
        'ru': 'Служба поддержки',
        'en': 'Support service',
        'uk': 'Служба підтримки'
      },
      'support_subtitle': {
        'ru':
            'Официальные каналы связи с Nexora. Выберите канал в зависимости от характера обращения.',
        'en':
            'Official Nexora contact channels. Choose a channel based on your request.',
        'uk':
            'Офіційні канали зв’язку з Nexora. Оберіть канал залежно від звернення.'
      },
      'support_chat': {
        'ru': 'Служба поддержки и сотрудничество',
        'en': 'Support and partnerships',
        'uk': 'Підтримка та співпраця'
      },
      'founder': {
        'ru': 'Основатель проекта',
        'en': 'Project founder',
        'uk': 'Засновник проєкту'
      },
      'official_email': {
        'ru': 'Официальная электронная почта',
        'en': 'Official email',
        'uk': 'Офіційна електронна пошта'
      },
      'user_agreement': {
        'ru': 'Пользовательское соглашение',
        'en': 'User agreement',
        'uk': 'Користувацька угода'
      },
      'privacy': {
        'ru': 'Политика конфиденциальности',
        'en': 'Privacy policy',
        'uk': 'Політика конфіденційності'
      },
      'support_text': {
        'ru':
            'Официальные каналы связи с Nexora по вопросам приложения, подписки, оплаты и подключений биржи.',
        'en':
            'Official Nexora contact channels for app, subscription, payment and exchange questions.',
        'uk':
            'Офіційні канали зв’язку з Nexora щодо застосунку, підписки, оплати та підключення біржі.'
      },
      'support_handle': {
        'ru': '@nexorasupportq',
        'en': '@nexorasupportq',
        'uk': '@nexorasupportq'
      },
      'founder_handle': {
        'ru': '@aid66633',
        'en': '@aid66633',
        'uk': '@aid66633'
      },
      'email_address': {
        'ru': 'support@nexora.date',
        'en': 'support@nexora.date',
        'uk': 'support@nexora.date'
      },
      'legal_text': {
        'ru':
            'Определяет условия использования Nexora, порядок оплаты подписки, распределение рисков и ограничение ответственности.',
        'en':
            'Defines Nexora usage terms, subscription payment rules, risk allocation and liability limits.',
        'uk':
            'Визначає умови використання Nexora, оплату підписки, розподіл ризиків та обмеження відповідальності.'
      },
      'privacy_text': {
        'ru':
            'Определяет состав обрабатываемых данных, цели и сроки обработки, порядок передачи третьим лицам и права пользователя.',
        'en':
            'Defines processed data, processing purposes and periods, third-party transfers and user rights.',
        'uk':
            'Визначає дані, що обробляються, цілі та строки обробки, передачу третім особам і права користувача.'
      },
      'open_full_text': {
        'ru': 'Открыть полный текст',
        'en': 'Open full text',
        'uk': 'Відкрити повний текст'
      },
      'no_bots': {
        'ru': 'Ботов пока нет — создайте первого ниже.',
        'en': 'No bots yet — create your first one below.',
        'uk': 'Ботів ще немає — створіть першого нижче.'
      },
      'paper_later': {
        'ru': 'Сейчас на бумаге, на реальные деньги — позже',
        'en': 'Paper trading now, real funds later',
        'uk': 'Зараз паперова торгівля, реальні кошти — пізніше'
      },
      'paper_notice': {
        'ru':
            'Бумажные боты торгуют симулированными данными на живых ценах. API-ключи и реальные средства подключаются отдельно.',
        'en':
            'Paper bots trade simulated funds at live prices. API keys and real funds are connected separately.',
        'uk':
            'Паперові боти торгують симульованими коштами за живими цінами. API-ключі та реальні кошти підключаються окремо.'
      },
      'create_bot': {
        'ru': 'Создать бота',
        'en': 'Create bot',
        'uk': 'Створити бота'
      },
      'collapse': {'ru': 'Свернуть', 'en': 'Collapse', 'uk': 'Згорнути'},
      'draft': {'ru': 'Черновик', 'en': 'Draft', 'uk': 'Чернетка'},
      'save_draft': {
        'ru': 'Сохранить черновик',
        'en': 'Save draft',
        'uk': 'Зберегти чернетку'
      },
      'run_backtest': {
        'ru': 'Прогнать бэктест',
        'en': 'Run backtest',
        'uk': 'Запустити бектест'
      },
      'backtest_empty': {
        'ru': 'Бэктестов пока нет',
        'en': 'No backtests yet',
        'uk': 'Бектестів ще немає'
      },
      'configure_run': {
        'ru': 'Настройте параметры и запустите проверку.',
        'en': 'Configure the parameters and run the test.',
        'uk': 'Налаштуйте параметри та запустіть перевірку.'
      },
      'paper_trading_label': {
        'ru': 'Paper trading',
        'en': 'Paper trading',
        'uk': 'Paper trading'
      },
      'secret_key_notice': {
        'ru':
            'Секретный ключ не показывается и не должен храниться в UI. Подключение к серверу будет добавлено через API service.',
        'en':
            'Secret key is not displayed and must not be stored in UI. Server connection will be added via API service.',
        'uk':
            'Секретний ключ не відображається і не повинен зберігатися в UI. Підключення до сервера буде додано через API service.'
      },
      'new_bot': {
        'ru': 'Новый бот',
        'en': 'New bot',
        'uk': 'Новий бот'
      },
      'bot_filter': {
        'ru': 'Бот',
        'en': 'Bot',
        'uk': 'Бот'
      },
      'open_link_failed': {
        'ru': 'Не удалось открыть ссылку',
        'en': 'Failed to open link',
        'uk': 'Не вдалося відкрити посилання'
      },
      'open_telegram_failed': {
        'ru': 'Не удалось открыть Telegram',
        'en': 'Failed to open Telegram',
        'uk': 'Не вдалося відкрити Telegram'
      },
      'setup_2fa': {
        'ru': 'Настройка 2FA',
        'en': 'Set up 2FA',
        'uk': 'Налаштування 2FA'
      },
      'disable_2fa': {
        'ru': 'Отключить 2FA',
        'en': 'Disable 2FA',
        'uk': 'Вимкнути 2FA'
      },
      'google_authenticator': {
        'ru': 'Google Authenticator',
        'en': 'Google Authenticator',
        'uk': 'Google Authenticator'
      },
      'scan_qr_hint': {
        'ru': 'Отсканируйте QR-код в приложении Google Authenticator',
        'en': 'Scan the QR code in Google Authenticator',
        'uk': 'Відскануйте QR-код у Google Authenticator'
      },
      'enter_code_6': {
        'ru': 'Введите 6-значный код из приложения',
        'en': 'Enter the 6-digit code from the app',
        'uk': 'Введіть 6-значний код із застосунку'
      },
      'code_invalid': {
        'ru': 'Неверный код, попробуйте снова',
        'en': 'Invalid code, try again',
        'uk': 'Невірний код, спробуйте знову'
      },
      'code_verified': {
        'ru': '2FA успешно включена!',
        'en': '2FA enabled successfully!',
        'uk': '2FA успішно увімкнено!'
      },
      'two_fa_disabled': {
        'ru': '2FA отключена',
        'en': '2FA disabled',
        'uk': '2FA вимкнено'
      },
      'step_install_app': {
        'ru': '1. Установите Google Authenticator',
        'en': '1. Install Google Authenticator',
        'uk': '1. Встановіть Google Authenticator'
      },
      'step_scan_qr': {
        'ru': '2. Отсканируйте QR-код',
        'en': '2. Scan the QR code',
        'uk': '2. Відскануйте QR-код'
      },
      'step_enter_code': {
        'ru': '3. Введите код подтверждения',
        'en': '3. Enter verification code',
        'uk': '3. Введіть код підтвердження'
      },
      'secret_key': {
        'ru': 'Секретный ключ',
        'en': 'Secret key',
        'uk': 'Секретний ключ'
      },
      'copy': {'ru': 'Копировать', 'en': 'Copy', 'uk': 'Копіювати'},
      'copied': {'ru': 'Скопировано', 'en': 'Copied', 'uk': 'Скопійовано'},
      'confirm': {'ru': 'Подтвердить', 'en': 'Confirm', 'uk': 'Підтвердити'},
      'verification_code': {
        'ru': 'Код подтверждения',
        'en': 'Verification code',
        'uk': 'Код підтвердження'
      },
    };
    return values[key]?[locale.languageCode] ?? values[key]?['ru'] ?? key;
  }
}
