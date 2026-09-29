import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../providers/trade_provider.dart';
import '../services/app_strings.dart';

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
  final _hScroll = ScrollController();

  @override
  void dispose() {
    _hScroll.dispose();
    super.dispose();
  }

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
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(strings.get('history'), style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 18),
            _toolbar(context, isWide, bots, strings),
            const SizedBox(height: 18),
            _content(context, provider, isWide, strings),
          ]),
        ),
      ),
    );
  }

  Widget _toolbar(BuildContext context, bool isWide, List<String> bots, AppStrings strings) {
    final tabs = [
      (_HistoryView.orders, strings.get('orders')),
      (_HistoryView.executions, strings.get('executions')),
      (_HistoryView.positions, strings.get('positions')),
    ];
    final controls = <Widget>[
      Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: Theme.of(context).cardTheme.color, borderRadius: BorderRadius.circular(10), border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.12))),
        child: Wrap(spacing: 3, children: [
          for (final tab in tabs)
            ChoiceChip(
              label: Text(tab.$2),
              selected: _view == tab.$1,
              onSelected: (_) => setState(() => _view = tab.$1),
              selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
              backgroundColor: Colors.transparent,
              side: BorderSide.none,
              showCheckmark: false,
            ),
        ]),
      ),
      if (_view == _HistoryView.executions)
        TextButton.icon(onPressed: null, icon: const Icon(Icons.download_outlined, size: 16), label: Text(strings.get('download_csv'))),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(strings.get('bot_filter'), style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        SizedBox(
          width: isWide ? 148 : 150,
          child: DropdownButtonFormField<String>(
            initialValue: _selectedBot,
            isExpanded: true,
            hint: Text(strings.get('all_bots')),
            decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 7)),
            items: bots.map((bot) => DropdownMenuItem(value: bot, child: Text(bot))).toList(),
            onChanged: bots.isEmpty ? null : (value) => setState(() => _selectedBot = value),
          ),
        ),
      ]),
    ];
    return Wrap(alignment: WrapAlignment.start, crossAxisAlignment: WrapCrossAlignment.end, spacing: 14, runSpacing: 10, children: controls);
  }

  Widget _content(BuildContext context, TradeProvider provider, bool isWide, AppStrings strings) {
    switch (_view) {
      case _HistoryView.orders:
        final orders = provider.orders.reversed.toList();
        return _emptyOrTable(context, orders, strings.get('no_orders'), isWide);
      case _HistoryView.executions:
        final executions = provider.completedOrders.reversed.toList();
        return _emptyOrTable(context, executions, strings.get('no_executions'), isWide);
      case _HistoryView.positions:
        return _emptyState(strings.get('positions_api'));
    }
  }

  Widget _emptyOrTable(BuildContext context, List<Order> items, String message, bool isWide) {
    if (items.isEmpty) return _emptyState(message);
    // Горизонтальный скролл + ListView.builder для виртуализации
    return _panel(
      child: Column(children: [
        // header row — тоже скроллится синхронно
        Scrollbar(
          controller: _hScroll,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _hScroll,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 620),
              child: SizedBox(
                width: isWide ? 1100 : 700,
                child: Column(children: [
                  _tableHeader(context),
                  const Divider(height: 1),
                  // строки — ListView.builder с shrinkWrap для производительности
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => Divider(height: 1, color: Theme.of(context).dividerColor.withValues(alpha: 0.08)),
                    itemBuilder: (_, i) => _orderRowH(context, items[i]),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _tableHeader(BuildContext context) {
    const style = TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.6);
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(children: [
        SizedBox(width: 32),
        Expanded(flex: 2, child: Text('ПАРА / ТИП', style: style)),
        Expanded(child: Text('КОЛ-ВО', style: style)),
        Expanded(child: Text('ЦЕНА', style: style)),
        Expanded(child: Text('СТАТУС', style: style)),
        SizedBox(width: 60, child: Text('ВРЕМЯ', style: style)),
      ]),
    );
  }

  Widget _orderRowH(BuildContext context, Order order) {
    final isDone = order.isCompleted;
    final accent = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(children: [
        Icon(isDone ? Icons.check_circle_outline : Icons.schedule_outlined, size: 20, color: isDone ? const Color(0xFF00B894) : accent),
        const SizedBox(width: 12),
        Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${order.type.toUpperCase()} ${order.symbol}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          Text(order.orderId, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
        ])),
        Expanded(child: Text('${order.amount} ${order.symbol}', style: const TextStyle(fontSize: 13))),
        Expanded(child: Text(order.price.toStringAsFixed(2), style: const TextStyle(fontSize: 13))),
        Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: (isDone ? const Color(0xFF00B894) : accent).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)), child: Text(order.status, style: TextStyle(color: isDone ? const Color(0xFF00B894) : accent, fontSize: 11, fontWeight: FontWeight.w600)))),
        SizedBox(width: 60, child: Text('${order.timestamp.hour.toString().padLeft(2,'0')}:${order.timestamp.minute.toString().padLeft(2,'0')}', style: Theme.of(context).textTheme.bodySmall)),
      ]),
    );
  }

  Widget _emptyState(String message) => Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 84),
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.15))),
        child: Text(message, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14)),
      );

  Widget _panel({required Widget child}) => Container(
        decoration: BoxDecoration(color: Theme.of(context).cardTheme.color, borderRadius: BorderRadius.circular(12), border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.12))),
        child: child,
      );
}
