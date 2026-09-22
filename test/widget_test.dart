import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradebot/main.dart';

void main() {
  testWidgets('приложение открывает главный экран', (tester) async {
    tester.view.physicalSize = const Size(1440, 3000);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MyApp());

    expect(find.text('Обзор'), findsWidgets);
    expect(find.text('С чего начать'), findsOneWidget);
    expect(find.text('Баланс на бирже'), findsOneWidget);
    expect(find.text('Купить'), findsNothing);
    expect(find.text('Продать'), findsNothing);
  });

  testWidgets('переход в настройки через боковое меню работает',
      (tester) async {
    tester.view.physicalSize = const Size(1440, 3000);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Настройки'));
    await tester.pumpAndSettle();

    expect(find.text('БОТЫ'), findsOneWidget);
    expect(find.text('Momentum Bot'), findsOneWidget);
  });

  testWidgets('вкладка ботов открывает пустую форму', (tester) async {
    tester.view.physicalSize = const Size(1440, 3000);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Боты'));
    await tester.pumpAndSettle();

    expect(find.text('Боты'), findsWidgets);
    expect(
        find.text('Ботов пока нет — создайте первого ниже.'), findsOneWidget);
    expect(find.text('Выберите биржу'), findsOneWidget);
    expect(find.text('Binance'), findsNothing);
    expect(find.text('BTCUSDT'), findsNothing);
  });

  testWidgets('вкладка истории показывает представления и пустое состояние',
      (tester) async {
    tester.view.physicalSize = const Size(1440, 3000);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('История'));
    await tester.pumpAndSettle();

    expect(find.text('Ордера'), findsOneWidget);
    expect(find.text('Исполнения'), findsOneWidget);
    expect(find.text('Позиции'), findsOneWidget);
    expect(find.text('Ордеров пока нет.'), findsOneWidget);
    await tester.tap(find.text('Исполнения'));
    await tester.pumpAndSettle();
    expect(find.text('Пока ничего не исполнилось.'), findsOneWidget);
  });

  testWidgets('вкладка бэктестов открывает пустую конфигурацию',
      (tester) async {
    tester.view.physicalSize = const Size(1440, 3000);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Бэктесты'));
    await tester.pumpAndSettle();

    expect(find.text('Бэктесты'), findsWidgets);
    expect(find.text('Выберите биржу'), findsOneWidget);
    expect(find.text('Введите торговую пару'), findsOneWidget);
    expect(find.text('Бэктестов пока нет'), findsOneWidget);
    expect(find.text('BTCUSDT'), findsNothing);
    expect(find.text('10000'), findsNothing);
  });
}
