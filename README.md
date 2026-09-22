# Nexora

Cross-platform trading application built with Flutter. Supports Android and iOS.

## About

Nexora is a mobile client for cryptocurrency portfolio tracking, bot management, and trade execution. The app provides a clean interface for monitoring prices, analyzing charts, and managing assets across multiple exchanges.

Current status: UI and architecture are production-ready. Market data, portfolio, and order execution run on mock data until the backend API is connected.

## Features

- Market overview with price charts and asset strip
- Portfolio overview with realized PnL and position tracking
- Grid bot creation and management (paper trading mode)
- Trade history: orders, executions, positions
- Backtesting configuration
- Exchange API connection management
- Push notifications (Android 13+ runtime permission)
- 8 color themes: Midnight, Ocean, Forest, Sunset, Berry, Arctic, Light, Sand
- Accent color customization and light/dark toggle
- Localization: Russian, English, Ukrainian

## Tech Stack

- Flutter 3 / Dart 3
- State management: Provider
- Charts: fl_chart
- Fonts: google_fonts (Plus Jakarta Sans)
- Storage: shared_preferences
- Notifications: flutter_local_notifications
- Navigation: named routes via NavigationService

## Project Structure

```
lib/
  main.dart                — entry point, theme init, routing
  models/                  — Order, Portfolio, TradeData
  providers/
    trade_provider.dart    — market, portfolio and order state
    theme_provider.dart    — theme mode, accent, presets
  screens/
    main_screen.dart       — shell with drawer navigation (IndexedStack)
    home_screen.dart       — dashboard, KPIs, market strip
    bots_screen.dart       — bot creation form
    chart_screen.dart      — trading chart
    history_overview_screen.dart
    backtests_screen.dart
    account_section_screen.dart
    settings_screen.dart   — profile, trading, app, appearance
  services/
    api/                   — API DTOs and service layer
    app_strings.dart       — localized strings
    navigation_service.dart
    notification_service.dart
  theme/
    trade_theme.dart       — palette, AppTheme builder, typography
```

Drawer order: Overview, Bots, History, Backtests, Exchanges, Subscription, Settings, Help.

## Getting Started

### Requirements

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android SDK 21+ (Android Studio), Xcode 14+ for iOS

### Install dependencies

```bash
flutter pub get
```

### Run

```bash
flutter run
```

### Tests and analysis

```bash
flutter test
flutter analyze
```

## Build

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (macOS only)
flutter build ipa --release
```

CI: codemagic.yaml is configured for unsigned IPA builds (sideloading without a paid Apple Developer account).

## Configuration

### Android push notifications

Permissions declared in `android/app/src/main/AndroidManifest.xml`:

- `POST_NOTIFICATIONS` (Android 13+, requested at runtime)
- `RECEIVE_BOOT_COMPLETED`, `VIBRATE`

The notification channel `nexora_test_channel` is created in NotificationService. The test push button in Settings under Debug requests permission before showing the notification.

### Theming

Themes are defined in `theme/trade_theme.dart` and `providers/theme_provider.dart`:

- AppPalette holds the full set of surface/card/border/text colors per preset.
- AppTheme.build() generates ThemeData from brightness + accent + palette.
- All screens consume Theme.of(context) (cardTheme, colorScheme, dividerColor, textTheme) so switching a preset updates the entire app, not just isolated blocks.
- Typography uses Plus Jakarta Sans for a softer, more readable look.

Persistence: selected preset, accent, brightness mode, and animation preference are stored in SharedPreferences and restored on launch.

### Assets

- `assets/logo.jpg` — application logo (declared in pubspec.yaml).

## Current Limitations

- Market data, portfolio, and order execution are in-memory mock values.
- connect() toggles local state only; no real exchange API, WebSocket, or auth.
- Chart uses static points.
- ios/ folder is not generated in this checkout; iOS signing requires macOS.
- Android release currently uses debug signing for development builds.

## Roadmap

- Extract mock data into a repository interface and connect a real backend API
- Add WebSocket market stream with proper lifecycle management
- Use secure storage for tokens and API keys (Keychain / Android Keystore)
- Add DTO validation, error handling, and loading states
- Generate iOS platform and configure Bundle ID and signing
- Configure production Android signing
- Add integration tests for connect/place/cancel order flows

## License

Created for educational purposes.

## Authors

Nexora team
