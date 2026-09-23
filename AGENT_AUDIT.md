# Nexora — Agent Audit Log

## Сессия 2026-09-23

### Выполнено

1. Push-уведомления (lib/services/notification_service.dart)
   - Разрешение POST_NOTIFICATIONS теперь запрашивается перед каждым показом через _ensurePermission()
   - На Android 13+ отклонение возвращает false, UI показывает SnackBar с ошибкой

2. Шрифт (lib/theme/trade_theme.dart)
   - Inter -> Plus Jakarta Sans

3. Двойные палитры (lib/providers/theme_provider.dart, lib/main.dart)
   - AppPreset хранит darkPalette + lightPalette
   - main.dart строит theme из lightPal, darkTheme из darkPal
   - Переключение dark/light работает с любым пресетом
   - 8 пресетов: Midnight, Ocean, Forest, Sunset, Berry, Arctic, Light, Sand

4. Хардкод цветов убран из всех экранов
   - home, bots, backtests, chart, account_section, settings
   - Всё через Theme.of(context)

5. Блок "С чего начать" (home_screen.dart)
   - Accent-gradient фон, кружки с градиентом, кнопки accent
   - TweenAnimationBuilder на стат-карточках (fade+slide)
   - Фон HomeScreen: два RadialGradient от accent

6. Logo (assets/logo.jpg), AndroidManifest (Nexora + mipmap icons)

7. README.md переписан на русском, структурированный, без эмодзи-спама

### Git log
```
9ba7337 fix: home getting-started cards, animated stats, ambient gradient
5ea3e19 fix: per-preset dark+light palettes, theme toggle
0752423 fix: app name Nexora, custom launcher icons
635d780 feat: theme overhaul, push fix, font upgrade, README
```

### Что нужно дальше
- flutter analyze + flutter test
- Тест push на устройстве (удалить старый APK, поставить свежий)
- Убрать неиспользуемые import TradeColors
- Ambient gradient на другие экраны (bots, backtests, account)
- Анимации на карточки ботов и истории
- Backend API, WebSocket, secure storage
- iOS платформа, production signing
