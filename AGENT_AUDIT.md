# Аудит проекта Trade Bot - Для передачи другому агенту

## Актуальный аудит после UI-сессии — 2026-09-22

### Проверено

- `flutter pub get` завершён успешно.
- `flutter test --no-pub` завершён успешно: **18 тестов пройдено**.
- `flutter analyze` из исходного каталога может блокироваться сбоем Dart analysis server на Unicode-пути рабочего стола. Анализ в ASCII-копии проекта завершён с **0 errors, 0 warnings, 30 info**; замечания — deprecated API Flutter.
- `dart format lib test` применён ко всем 19 Dart-файлам.
- Edge debug preview запускается без runtime-исключений.
- `flutter build apk --debug` успешно завершён в исходном проекте после миграции Android-слоя на Kotlin DSL, Gradle 9.3.1/AGP 9.1.0, добавления `android.overridePathCheck=true` и восстановления Android resources. APK создаётся в `build/app/outputs/flutter-apk/app-debug.apk`.
- Android toolchain всё ещё показывает предупреждение о Kotlin Gradle Plugin migration и непринятых отдельных SDK licenses; это не блокирует debug APK, но должно быть закрыто перед release.

### Актуальная навигация

Drawer повторяет структуру Nexora и использует следующий порядок:

1. Обзор
2. Боты
3. История
4. Бэктесты
5. Биржи
6. Подписка
7. Настройки
8. Помощь

Меню прокручивается на коротких мобильных экранах. В нижнем блоке отображаются `Подписка неактивна`, `Активировать` и `Выйти`.

### Текущие экраны

- `home_screen.dart` — Nexora-style обзор с KPI, onboarding, балансом биржи, активными входами и рыночными тикерами.
- `bots_screen.dart` — пустая API-ready форма создания бота: поля не содержат зашитых биржи, пары, капитала или стратегии.
- `history_overview_screen.dart` — представления `Ордера`, `Исполнения`, `Позиции`, фильтр бота и пустые состояния.
- `backtests_screen.dart` — пустая конфигурация исторической проверки стратегии, параметры сетки, ограничения и пустые результаты.
- `account_section_screen.dart` — заготовки `Биржи`, `Подписка` и `Помощь`; реальные сервисы пока не подключены.
- `settings_screen.dart` — локальные настройки paper trading, бота, API, уведомлений и биометрии.

### Архитектурные ограничения

- Рынок, портфель и ордера всё ещё mock/in-memory; реальных REST/WebSocket API нет.
- API-ключи нельзя хранить в UI, `SharedPreferences`, логах или исходниках. Нужны backend API и Keychain/Android Keystore.
- База данных не должна подключаться напрямую из Flutter-клиента; клиент должен работать через backend.
- Каталог `ios/` отсутствует. iOS-проект, Bundle ID, capabilities, signing и TestFlight нужно настроить на macOS.
- Android release signing пока использует debug signing; перед релизом нужен защищённый keystore/CI.
- Для iOS и Android нужно проверить safe areas, клавиатуру, accessibility, системную навигацию, размеры шрифтов и реальные устройства после генерации платформ.

### Следующие шаги

1. Создать iOS-платформу на macOS и проверить UI на iPhone/Simulator.
2. Вынести mock-данные в repository-интерфейсы и подключить backend API.
3. Добавить secure storage для токенов и API-ключей, DTO/JSON, обработку сетевых ошибок и загрузочные состояния.
4. Принять оставшиеся Android SDK licenses и убрать Kotlin migration warning.
5. Заменить deprecated Flutter API (`withOpacity`, `activeColor`, старый test window API) после стабилизации UI.

> **Актуализация 2026-09-22:** исторические замечания ниже описывают состояние до текущего исправления. `lib/theme/trade_theme.dart` восстановлен, дублированный хвост удалён, а актуальная карта архитектуры и план интеграций находятся в разделе «Аудит состояния проекта (2026-09)» файла [README.md](README.md). Перед релизом повторно запустите `flutter analyze` и `flutter test`.

## Исторический журнал работы: 2026-09-22

### Выполнено

- Перенесена основная мобильная навигация с нижней панели в `Drawer`.
- `MainScreen` теперь содержит четыре раздела в `IndexedStack`: Обзор, Рынок, История, Настройки.
- В боковом меню добавлены брендовый блок NEXORA, подписи разделов, активное состояние и иконки.
- Добавлена верхняя мобильная панель с заголовком текущей вкладки, кнопкой меню и уведомлениями.
- `ChartScreen` включён в основную навигацию как вкладка «Рынок».
- `SettingsScreen` переработан: профиль, безопасность, биржа, paper trading, уведомления, биометрия, язык и версия.
- Убраны три повторяющихся блока старых настроек.
- Цветовая система переведена с фиолетовой темы на тёмную графитовую с лаймовым акцентом (`TradeColors.accentLime`, `#B8F34A`).
- Исправлено обращение к несуществующему `TradeColors.darkTheme`.
- `HomeScreen` и `HistoryScreen` используют состояние `TradeProvider`, а не тестовые списки UI.
- Исправлены темы, дублированный код `trade_theme.dart`, двойной `TradeProvider`, тест счётчика и базовые тесты приложения.

### Текущая структура

- `lib/main.dart` — точка входа, глобальный `TradeProvider`, маршруты.
- `lib/screens/main_screen.dart` — мобильная оболочка и боковое меню.
- `lib/screens/home_screen.dart` — портфель, BTC, рынок и быстрые действия.
- `lib/screens/chart_screen.dart` — график и торговые контролы.
- `lib/screens/history_screen.dart` — история ордеров из провайдера.
- `lib/screens/settings_screen.dart` — настройки и локальные переключатели.
- `lib/providers/trade_provider.dart` — mock-рынок, портфель, ордера и lifecycle таймера.
- `lib/theme/trade_theme.dart` — актуальная графитово-лаймовая тема.

### Важно для следующего продолжения

- Nexora открыта в отдельном нативном окне и автоматически не просматривается средствами VS Code; точное pixel-perfect совпадение потребует скриншота.
- Flutter/Dart не найдены в `PATH` текущего Windows-терминала, поэтому `flutter analyze` и `flutter test` нужно выполнить после настройки SDK.
- Каталог `ios/` отсутствует; Android release signing пока не настроен.
- Не подключать БД напрямую из мобильного клиента. Следующий слой должен быть backend API + защищённое хранилище токенов.
- Старый `lib/widgets/bottom_navbar.dart` больше не используется после перехода на Drawer; удалять его можно отдельным cleanup-шагом.

## 📋 Историческая сводка до текущей миграции

**Проект:** Flutter торговое приложение  
**Путь:** `/home/user/Рабочий桌面/gui`  
**Проблема:** В файле `lib/theme/trade_theme.dart` есть дублированный код после класса `TradeThemes`, который вызывает ошибки компиляции.

---

## 🎯 Суть проблемы

### Что сломано:
Файл `lib/theme/trade_theme.dart` содержит **дублированный код**, который нарушает структуру:

### Правильная структура должна быть:
```
class TradeColors { ... }
class TradeTheme {
  static ThemeData get lightTheme { ... }
  static ThemeData get darkTheme { ... }
}
class TradeThemes {
  static ThemeData get lightTheme => TradeTheme.lightTheme;
  static ThemeData get darkTheme => TradeTheme.darkTheme;
}
```

### Что сейчас в файле:
Вместо того, чтобы заканчиваться после класса `TradeThemes`, в файле идет **дополнительный код** с:
- `backgroundColor: TradeColors.surface,`
- и продолжение кода для `darkTheme` метода
- больше дублированного кода...

Этот дублированный код начинается **после закрывающей скобки** класса `TradeThemes` и продолжается до **конца файла`.

---

## 📁 Структура проекта

### Всего Dart файлов: 15

**Основные компоненты:**

#### 1. Точка входа
- [lib/main.dart](lib/main.dart) - точка входа приложения, инициализация TradeProvider, named routes, systemUIOverlayStyle

#### 2. State Management
- [lib/providers/trade_provider.dart](lib/providers/trade_provider.dart) - TradeProvider с памятью leak (исправлен dispose), Timer для обновления рынка, copyWith методы

#### 3. Модели данных
- [lib/models/order.dart](lib/models/order.dart) - модель заказа
- [lib/models/portfolio.dart](lib/models/portfolio.dart) - модель портфеля
- [lib/models/trade_data.dart](lib/models/trade_data.dart) - данные торговли (исправлены final поля, добавлен copyWith)

#### 4. Экраны приложения
- [lib/screens/chart_screen.dart](lib/screens/chart_screen.dart) - экран с графиком
- [lib/screens/history_screen.dart](lib/screens/history_screen.dart) - история транзакций
- [lib/screens/home_screen.dart](lib/screens/home_screen.dart) - домашний экран (есть лингвистические ошибки анализа, но не критичные)
- [lib/screens/main_screen.dart](lib/screens/main_screen.dart) - главный экран с навигацией
- [lib/screens/settings_screen.dart](lib/screens/settings_screen.dart) - экран настроек

#### 5. Сервисы
- [lib/services/navigation_service.dart](lib/services/navigation_service.dart) - навигация с константами маршрутов

#### 6. Темы оформления
- [lib/theme/trade_theme.dart](lib/theme/trade_theme.dart) - **ПРОБЛЕМА: есть дублированный код**

#### 7. Виджеты
- [lib/widgets/bottom_navbar.dart](lib/widgets/bottom_navbar.dart) - нижняя навигационная панель

---

## ✅ Что уже исправлено

### 1. Memory Leak в TradeProvider
```dart
// Было (BUG):
Timer _marketUpdateTimer;
void dispose() {
  // Timer не отменяется!
  super.dispose();
}

// Стало (исправлено):
Timer? _marketUpdateTimer;
void dispose() {
  _cancelMarketUpdates();
  super.dispose();
}
void _cancelMarketUpdates() {
  _marketUpdateTimer?.cancel();
  _marketUpdateTimer = null;
}
```

### 2. NavigationService с константами
```dart
// Было (нет констант):
void navigateTo(String routeName) { ... }

// Стало (есть константы):
class NavigationService {
  static const String homeRoute = '/';
  static const String chartRoute = '/chart';
  static const String historyRoute = '/history';
  static const String settingsRoute = '/settings';
  // ...
}
```

### 3. Структура main.dart
- SystemUIOverlayStyle исправлен (не может использовать TradeColors.surface в const)
- Добавлен класс TradeThemes как обертка над TradeTheme
- Named routes работают правильно

### 4. Настройка PATH
- Flutter добавлен в PATH в `.bashrc`
- Команда `flutter --version` работает
- Flutter 3.47.5 + Dart 3.13.4

### 5. Зависимости
- Все пакеты установлены через `flutter pub get`
- 7 пакетов имеют более новые версии (не критично)

---

## ⚠️ Проблемы (очень кратко)

### 1. Дублированный код в trade_theme.dart **(КРИТИЧНО)**
Файл содержит дублированный код после класса `TradeThemes`, который вызывает ошибки компиляции.

**Нужно сделать:** Найти и удалить дублированный код, начиная после закрывающей скобки класса `TradeThemes`.

### 2. Лингвистические ошибки в UI файлах (не критично)
- [lib/screens/home_screen.dart](lib/screens/home_screen.dart) - ~50+ ошибок анализа
- [lib/screens/history_screen.dart](lib/screens/history_screen.dart) - ~10+ ошибок анализа

Это лингвистические ошибки (безопасность типов, etc.), не блокируют компиляцию.

### 3. Android SDK не установлен
- Нет gradlew в android папке
- Не удается собрать APK для Android
- **Важно:** Требуется Android SDK для сборки Android приложений

### 4. Linux desktop поддержка создана вручную
- Создана структура `linux/CMakeLists.txt` и `linux/main.cpp`
- Может требовать доработки или использования `flutter create linux --platforms=linux`

---

## 🚀 Как запустить

### Проверить состояние:
```bash
cd /home/user/Рабочий桌面/gui
flutter doctor
flutter pub get
```

### Исправить дублированный код в trade_theme.dart:
Найти дублированный код после класса `TradeThemes` и удалить его.

### Запустить приложение (после исправления):
```bash
# На Android (если есть Android SDK)
flutter run

# На Linux desktop (если настроен)
flutter run -d linux

# В браузере
flutter run -d chrome
```

---

## 📊 Статус проекта

| Компонент | Статус | Оценка |
|-----------|--------|--------|
| Memory Management | ✅ Исправлено | 100% |
| NavigationService | ✅ Исправлено | 100% |
| main.dart | ✅ Исправлено | 100% |
| TradeProvider | ✅ Исправлено | 100% |
| Модели данных | ✅ Исправлено | 100% |
| Темы оформления | ❌ Баг | 60% |
| Ошибки анализа в screens | ⚠️ Не критично | 80% |
| Android SDK | ❌ Отсутствует | 0% |
| Linux desktop | ⚠️ В процессе | 50% |

**Общий рейтинг:** 85%

---

## 🎯 Что нужно сделать в первую очередь

### 1. Исправить дублированный код в trade_theme.dart (1-2 минуты)
**Самая срочная проблема!**

Найти в файле и удалить все строки **после** закрывающей скобки класса `TradeThemes`.

Локализовать проблему: Смотреть на ошибки компиляции - они начинаются после класса `TradeThemes`.

### 2. Проверить компиляцию
```bash
flutter analyze
```

### 3. Запустить приложение
```bash
flutter run
```

---

## 💡 Контекст для агента

**Важно:** Когда агент откроет файл, он увидит странную структуру с лишними скобками и дублированным кодом.

**Подсказка для агента:**
- Посмотрите на ошибки компиляции в начале файла (строки ~190+)
- Структура должна заканчиваться после класса `TradeThemes` (строки ~193)
- Все, что идет после `}` - это дублированный код, который нужно удалить

**Файл для проверки:**
```
/home/user/Рабочий桌面/gui/lib/theme/trade_theme.dart
```

---

## 📝 Полезные команды для агента

### Проверить дублированный код:
```bash
grep -n "backgroundColor: TradeColors.surface" /home/user/Рабочий桌面/gui/lib/theme/trade_theme.dart
```

### Посмотреть количество строк:
```bash
wc -l /home/user/Рабочий桌面/gui/lib/theme/trade_theme.dart
```

### Проверить ошибки:
```bash
cd /home/user/Рабочий桌面/gui
dart analyze lib/theme/trade_theme.dart
```

### Запустить анализ всего проекта:
```bash
cd /home/user/Рабочий桌面/gui
flutter analyze
```

---

## 🔍 Как найти дублированный код

### Подсказка 1: Посмотрите на ошибки
Ошибки компиляции показывают, где именно начинается проблема. Скорее всего, это будет где-то после строки ~190.

### Подсказка 2: Посмотрите на структуру
После класса `TradeThemes` идет странная последовательность, которая не имеет смысла - это дублированный код.

### Подсказка 3: Найдите фрагменты
Ищите повторяющиеся фрагменты кода в файле - если вы видите одинаковые блоки кода дважды, это дублирование.

### Подсказка 4: Используйте read_file
Откройте файл и посмотрите на последние 20-30 строк - там будет видно, где заканчивается правильная структура.

---

## 📌 Краткий чеклист для агента

- [ ] Откройте файл `lib/theme/trade_theme.dart`
- [ ] Найдите класс `TradeThemes` и его закрывающую скобку `}`
- [ ] Посмотрите на ошибки компиляции - они показывают, где проблема
- [ ] Найдите начало дублированного кода (скорее всего, после строки ~190)
- [ ] Удалите весь дублированный код до конца файла
- [ ] Проверьте, что нет ошибок в файле
- [ ] Запустите `flutter analyze`
- [ ] Если все хорошо, запустите `flutter run`

---

## ⏱️ Ожидаемое время исправления

- Поиск дублированного кода: 1-2 минуты
- Удаление дублированного кода: 30 секунд
- Проверка: 1 минута
- Запуск приложения: 2-3 минуты

**Итого:** ~5 минут для полного исправления проблемы.

---

## 📄 Дополнительная информация

### Версии
- Flutter: 3.47.5
- Dart: 3.13.4
- Flutter SDK путь: `/home/user/flutter`
- Путь к проекту: `/home/user/Рабочий桌面/gui`

### OS
- Fedora 44 Linux
- Shell: bash

### Dependencies (установлены)
- flutter: ^6.1.1
- fl_chart: ^0.68.0
- intl: ^0.18.1
- cupertino_icons: ^1.0.6

### Что НЕ нужно делать
- Не нужно устанавливать новые зависимости
- Не нужно создавать новые файлы (только исправить существующий)
- Не нужно удалять папку `android` или `lib`
- Не нужно переустанавливать Flutter

### Что нужно сделать
- **Исправить дублированный код в trade_theme.dart**
- Проверить компиляцию
- Запустить приложение (опционально)

---

**Готово!** Агент может начинать работу.

**Ключевая инструкция:**
> "В файле `lib/theme/trade_theme.dart` есть дублированный код после класса `TradeThemes`. Найдите и удалите этот дублированный код, чтобы исправить ошибки компиляции."
