import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../providers/trade_provider.dart';
import '../services/app_strings.dart';
import '../theme/trade_theme.dart';

enum _HistoryView { orders, executions, positions }

class HistoryOverviewScreen extends StatefulWidget {
  const HistoryOverviewScreen({super.key, required this.locale});

  final Locale locale;

  @override
  State<HistoryOverviewScreen> createState() => _HistoryOverviewScreenState();
}

class _HistoryOverviewScreenState extends State<HistoryOverviewScreen> {
  _HistoryView _view = _HistoryView.orders;
  String? _selectedBot;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TradeProvider>();
    final isWide = MediaQuery.sizeOf(context).width >= 760;
    final bots = <String>[];
    final strings = AppStrings(widget.locale);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(isWide ? 28 : 16, 18, isWide ? 28 : 16, 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(strings.get('history'),
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 18),
            _toolbar(context, isWide, bots, strings),
            const SizedBox(height: 18),
            _content(context, provider, isWide, strings),
          ]),
        ),
      ),
    );
  }

  Widget _toolbar(BuildContext context, bool isWide, List<String> bots,
      AppStrings strings) {
    final tabs = [
      (_HistoryView.orders, strings.get('orders')),
      (_HistoryView.executions, strings.get('executions')),
      (_HistoryView.positions, strings.get('positions')),
    ];
    final controls = <Widget>[
      Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: TradeColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: TradeColors.border)),
        child: Wrap(spacing: 3, children: [
          for (final tab in tabs)
            ChoiceChip(
              label: Text(tab.$2),
              selected: _view == tab.$1,
              onSelected: (_) => setState(() => _view = tab.$1),
              selectedColor: TradeColors.cardBackground,
              backgroundColor: Colors.transparent,
              labelStyle: TextStyle(
                  color: _view == tab.$1
                      ? TradeColors.primaryText
                      : TradeColors.secondaryText,
                  fontSize: 12),
              side: BorderSide.none,
              showCheckmark: false,
            ),
        ]),
      ),
      if (_view == _HistoryView.executions)
        TextButton.icon(
            onPressed: null,
            icon: const Icon(Icons.download_outlined, size: 16),
            label: Text(strings.get('download_csv'))),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(strings.get('bot_filter'), style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        SizedBox(
          width: isWide ? 148 : 150,
          child: DropdownButtonFormField<String>(
            initialValue: _selectedBot,
            isExpanded: true,
            hint: Text(strings.get('all_bots')),
            decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 7)),
            items: bots
                .map((bot) => DropdownMenuItem(value: bot, child: Text(bot)))
                .toList(),
            onChanged: bots.isEmpty
                ? null
                : (value) => setState(() => _selectedBot = value),
          ),
        ),
      ]),
    ];

    return Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: 14,
        runSpacing: 10,
        children: controls);
  }

  Widget _content(BuildContext context, TradeProvider provider, bool isWide,
      AppStrings strings) {
    switch (_view) {
      case _HistoryView.orders:
        final orders = provider.orders.reversed.toList();
        return _emptyOrList(context, orders, strings.get('no_orders'),
            (order) => _orderRow(context, order), isWide);
      case _HistoryView.executions:
        final executions = provider.completedOrders.reversed.toList();
        return _emptyOrList(context, executions, strings.get('no_executions'),
            (order) => _orderRow(context, order), isWide);
      case _HistoryView.positions:
        return _emptyState(strings.get('positions_api'));
    }
  }

  Widget _emptyOrList(BuildContext context, List<Order> items, String message,
      Widget Function(Order) builder, bool isWide) {
    if (items.isEmpty) return _emptyState(message);
    return _panel(
        child: Column(children: [for (final item in items) builder(item)]));
  }

  Widget _orderRow(BuildContext context, Order order) => Material(
        color: Colors.transparent,
        child: ListTile(
          leading: Icon(
              order.isCompleted
                  ? Icons.check_circle_outline
                  : Icons.schedule_outlined,
              color: order.isCompleted
                  ? TradeColors.successGreen
                  : TradeColors.primaryPurple),
          title: Text('${order.type.toUpperCase()} ${order.symbol}'),
          subtitle: Text('${order.amount} ${order.symbol}'),
          trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(order.price.toStringAsFixed(2)),
                Text(order.status,
                    style: TextStyle(
                        color: order.isCompleted
                            ? TradeColors.successGreen
                            : TradeColors.secondaryText,
                        fontSize: 12))
              ]),
        ),
      );

  Widget _emptyState(String message) => Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 84),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: TradeColors.border, style: BorderStyle.solid)),
        child: Text(message,
            style: const TextStyle(
                color: TradeColors.primaryText, fontWeight: FontWeight.w600)),
      );

  Widget _panel({required Widget child}) => Container(
        decoration: BoxDecoration(
            color: TradeColors.cardBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: TradeColors.border)),
        child: child,
      );
}
