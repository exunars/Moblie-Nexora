# Nexora — Agent Audit Log

## Session 2026-09-23 (current)

### What was done

1. Push notification fix (notification_service.dart)
   - Moved requestNotificationsPermission() out of init() into _ensurePermission()
   - Called before every show(), not just once at init
   - On Android 13+ denied permission returns false, UI shows error SnackBar

2. Font upgrade (trade_theme.dart)
   - GoogleFonts.interTextTheme -> GoogleFonts.plusJakartaSansTextTheme

3. Theme presets with dual palettes (theme_provider.dart)
   - AppPreset now holds darkPalette + lightPalette per preset
   - paletteFor(Brightness) method selects the right one
   - setPreset no longer forces dark/light mode
   - 8 presets: Midnight, Ocean, Forest, Sunset, Berry, Arctic, Light, Sand
   - Each has rich dark palette + matching tinted light palette

4. main.dart: theme/darkTheme built from separate lightPal/darkPal
   - Toggle (moon button) flips brightness while keeping selected preset colors
   - SystemChrome status bar updates per actual mode

5. Hardcoded colors removed from all screens
   - home_screen, bots_screen, backtests_screen, chart_screen,
     account_section_screen, settings_screen
   - All use Theme.of(context) now

6. Logo asset added (assets/logo.jpg, declared in pubspec.yaml)

7. README.md rewritten (clean, no emoji overload)

8. App name and icons (AndroidManifest: Nexora, mipmap launcher icons)

### Git log
- fb26724 fix: per-preset dark+light palettes, theme toggle respects selected preset
- 0752423 fix: app name Nexora, custom launcher icons
- 635d780 feat: theme overhaul, push fix, font upgrade, README rewrite

### What still needs to be done
- Run flutter analyze and fix remaining warnings
- Run flutter test to verify tests pass
- On-device test: push notification permission flow
- Remove unused TradeColors imports from screens
- Connect real backend API, replace mock data
- Set up production Android signing
- Generate iOS platform on macOS
