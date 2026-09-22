import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/trade_provider.dart';
import 'screens/main_screen.dart';
import 'screens/chart_screen.dart';
import 'theme/trade_theme.dart';
import 'services/navigation_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Цвета синхронизированы с TradeColors.background (#0B0D14)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF0B0D14),
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0B0D14),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('ru');

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TradeProvider(),
      child: MaterialApp(
        title: 'Trade Bot',
        debugShowCheckedModeBanner: false,
        locale: _locale,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [
          Locale('ru'),
          Locale('en'),
          Locale('uk'),
        ],

        // Темизация приложения
        theme: TradeThemes.lightTheme,
        darkTheme: TradeThemes.darkTheme,
        themeMode: ThemeMode.system,

        // Навигация с Named Routes
        initialRoute: NavigationService.homeRoute,
        routes: {
          NavigationService.homeRoute: (context) => MainScreen(
              locale: _locale,
              onLocaleChanged: (locale) => setState(() => _locale = locale)),
          NavigationService.chartRoute: (context) => const ChartScreen(),
        },
      ),
    );
  }
}
