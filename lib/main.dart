import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/trade_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/main_screen.dart';
import 'screens/chart_screen.dart';
import 'theme/trade_theme.dart';
import 'services/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final themeProvider = ThemeProvider();
  await themeProvider.load();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF0B0D14),
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0B0D14),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(MyApp(themeProvider: themeProvider));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.themeProvider});
  final ThemeProvider themeProvider;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('ru');

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: widget.themeProvider),
        ChangeNotifierProvider(create: (_) => TradeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, tp, _) {
          final isDark = tp.mode == ThemeMode.dark ||
              (tp.mode == ThemeMode.system &&
                  MediaQuery.platformBrightnessOf(context) == Brightness.dark);
          // palettes per mode — each preset now has dark+light
          final darkPal = tp.preset.darkPalette;
          final lightPal = tp.preset.lightPalette;
          final bg = (isDark ? darkPal : lightPal).background;
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: bg,
            statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            systemNavigationBarColor: bg,
            systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          ));
          return MaterialApp(
            title: 'Nexora',
            debugShowCheckedModeBanner: false,
            locale: _locale,
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            supportedLocales: const [Locale('ru'), Locale('en'), Locale('uk')],
            theme: AppTheme.build(brightness: Brightness.light, accent: tp.accent.color, palette: lightPal),
            darkTheme: AppTheme.build(brightness: Brightness.dark, accent: tp.accent.color, palette: darkPal),
            themeMode: tp.mode,
            initialRoute: NavigationService.homeRoute,
            routes: {
              NavigationService.homeRoute: (context) => MainScreen(
                  locale: _locale,
                  onLocaleChanged: (locale) => setState(() => _locale = locale)),
              NavigationService.chartRoute: (context) => const ChartScreen(),
            },
          );
        },
      ),
    );
  }
}
