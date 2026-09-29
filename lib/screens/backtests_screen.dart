import 'package:flutter/material.dart';
import '../services/app_strings.dart';

class BacktestsScreen extends StatefulWidget {
  const BacktestsScreen({super.key, required this.locale});

  final Locale locale;

  @override
  State<BacktestsScreen> createState() => _BacktestsScreenState();
}

class _BacktestsScreenState extends State<BacktestsScreen> {
  final _pairController = TextEditingController();
  final _candlesController = TextEditingController();
  final _capitalController = TextEditingController();
  final _depositController = TextEditingController();
  final _profitController = TextEditingController();
  final _stepsController = TextEditingController();
  final _depthController = TextEditingController();
  final _firstLineController = TextEditingController();
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  String? _exchange;
  String? _timeframe;
  String? _strategy;
  String? _gridMode;
  bool _singleCycle = false;
  bool _followPrice = false;
  final _scrollController = ScrollController();

  AppStrings get _strings => AppStrings(widget.locale);

  @override
  void dispose() {
    for (final controller in [
      _pairController,
      _candlesController,
      _capitalController,
      _depositController,
      _profitController,
      _stepsController,
      _depthController,
      _firstLineController,
      _minPriceController,
      _maxPriceController,
    ]) {
      controller.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final strings = AppStrings(widget.locale);
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding:
            EdgeInsets.fromLTRB(isWide ? 28 : 16, 18, isWide ? 28 : 16, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(strings.get('backtests'),
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 18),
              _form(context, isWide),
              const SizedBox(height: 18),
              _emptyResults(context),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _form(BuildContext context, bool isWide) => _panel(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_strings.get('run_backtest'),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 5),
            Text(_strings.get('backtest_form_description'),
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            _fieldGrid(isWide, [
              _select(
                  _strings.get('exchange'),
                  _strings.get('choose_exchange'),
                  _exchange,
                  ['Binance', 'Bybit', 'OKX'],
                  (value) => setState(() => _exchange = value)),
              _textField(_strings.get('pair'), _strings.get('enter_pair'),
                  _pairController),
              _select(
                  _strings.get('timeframe'),
                  _strings.get('choose_timeframe'),
                  _timeframe,
                  ['1m', '5m', '1h', '1d'],
                  (value) => setState(() => _timeframe = value)),
              _textField(_strings.get('candles'), '', _candlesController),
            ]),
            _textField(_strings.get('initial_capital'), '', _capitalController),
            _select(
                _strings.get('strategy'),
                _strings.get('strategy_choose'),
                _strategy,
                ['Grid', 'DCA', 'Momentum'],
                (value) => setState(() => _strategy = value)),
            const SizedBox(height: 4),
            _gridParameters(context, isWide),
            const SizedBox(height: 12),
            _limits(context, isWide),
            const SizedBox(height: 14),
            FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(_strings.get('run_backtest'))),
            const SizedBox(height: 8),
            Text(_strings.get('backtest_disclaimer'),
                style: Theme.of(context).textTheme.bodySmall),
          ]),
        ),
      );

  Widget _gridParameters(BuildContext context, bool isWide) => _panel(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_strings.get('grid_table'),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 13)),
            const SizedBox(height: 4),
            Text(_strings.get('grid_calculation_short'),
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            _select(
                _strings.get('mode'),
                _strings.get('choose_mode'),
                _gridMode,
                [_strings.get('sideways'), _strings.get('trend')],
                (value) => setState(() => _gridMode = value)),
            _fieldGrid(isWide, [
              _textField(_strings.get('deposit'), '', _depositController),
              _textField(_strings.get('sell_percent'), '', _profitController),
              _textField(_strings.get('steps'), '', _stepsController),
              _textField(_strings.get('depth'), '', _depthController),
            ]),
            _textField(_strings.get('first_line'), '', _firstLineController),
            TextButton(
                onPressed: () {}, child: Text(_strings.get('fill_table'))),
          ]),
        ),
      );

  Widget _limits(BuildContext context, bool isWide) => _panel(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_strings.get('limits'),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 13)),
            const SizedBox(height: 7),
            Text(_strings.get('buy_range'),
                style: Theme.of(context).textTheme.bodySmall),
            _fieldGrid(isWide, [
              _textField(_strings.get('not_below'), '', _minPriceController),
              _textField(_strings.get('not_above'), '', _maxPriceController),
            ]),
            _switch(_strings.get('one_cycle'), _strings.get('sell_stop'),
                _singleCycle, (value) => setState(() => _singleCycle = value)),
            _switch(
                _strings.get('follow_grid'),
                _strings.get('recalculate_grid'),
                _followPrice,
                (value) => setState(() => _followPrice = value)),
          ]),
        ),
      );

  Widget _emptyResults(BuildContext context) => _panel(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: Column(children: [
            Text(_strings.get('backtest_empty'),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(_strings.get('configure_run'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall),
          ]),
        ),
      );

  Widget _fieldGrid(bool isWide, List<Widget> fields) => isWide
      ? Row(children: [
          for (var i = 0; i < fields.length; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            Expanded(child: fields[i])
          ]
        ])
      : Column(children: [
          for (var i = 0; i < fields.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            fields[i]
          ]
        ]);

  Widget _textField(
          String label, String hint, TextEditingController controller) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: label, hintText: hint)),
      );

  Widget _select(String label, String hint, String? value, List<String> items,
          ValueChanged<String?> onChanged) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          hint: Text(hint),
          decoration: InputDecoration(labelText: label),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      );

  Widget _switch(String title, String subtitle, bool value,
          ValueChanged<bool> onChanged) =>
      Material(
        color: Colors.transparent,
        child: SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(title),
          subtitle: Text(subtitle),
          value: value,
          
          onChanged: onChanged,
        ),
      );

  Widget _panel({required Widget child}) => Builder(builder: (context) => Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.15))),
        child: child,
      ));
}
