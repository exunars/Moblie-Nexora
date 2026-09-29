import 'package:flutter/material.dart';
import '../services/app_strings.dart';

class BotsScreen extends StatefulWidget {
  const BotsScreen({super.key, required this.locale});

  final Locale locale;

  @override
  State<BotsScreen> createState() => _BotsScreenState();
}

class _BotsScreenState extends State<BotsScreen> {
  final _pairController = TextEditingController();
  final _depositController = TextEditingController();
  final _profitController = TextEditingController();
  final _stepsController = TextEditingController();
  final _depthController = TextEditingController();
  final _firstLineController = TextEditingController();
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  String? _mode;
  String? _exchange;
  String? _strategy;
  String? _gridMode;
  bool _singleCycle = false;
  bool _followPrice = false;
  bool _isFormOpen = true;
  final List<String> _createdBots = [];
  final _scrollController = ScrollController();

  AppStrings get _strings => AppStrings(widget.locale);

  @override
  void dispose() {
    _pairController.dispose();
    _depositController.dispose();
    _profitController.dispose();
    _stepsController.dispose();
    _depthController.dispose();
    _firstLineController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
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
              _intro(context, strings),
              const SizedBox(height: 18),
              _paperNotice(context),
              const SizedBox(height: 18),
              if (_createdBots.isNotEmpty) ...[
                for (final botName in _createdBots) ...[
                  _botCard(context, botName),
                  const SizedBox(height: 18),
                ],
              ],
              if (_isFormOpen)
                _formPanel(context, isWide)
              else
                _createBotButton(),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _intro(BuildContext context, AppStrings strings) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(strings.get('bots'),
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 6),
        Text(strings.get('no_bots'),
            style: Theme.of(context).textTheme.bodyMedium),
      ]);

  Widget _paperNotice(BuildContext context) => _panel(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_strings.get('paper_later'),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 7),
            Text(_strings.get('paper_notice'),
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 9),
            TextButton(onPressed: () {}, child: Text(_strings.get('settings'))),
          ]),
        ),
      );

  Widget _formPanel(BuildContext context, bool isWide) => _panel(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(_strings.get('create_bot'),
                  style: Theme.of(context).textTheme.titleLarge),
              TextButton(
                  onPressed: () => setState(() => _isFormOpen = false),
                  child: Text(_strings.get('collapse'))),
            ]),
            const SizedBox(height: 5),
            Text(_strings.get('form_description'),
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            _fieldGrid(isWide, [
              _select(
                  _strings.get('mode'),
                  _strings.get('choose_mode'),
                  _mode,
                  [_strings.get('paper'), _strings.get('real')],
                  (value) => setState(() => _mode = value)),
              _select(
                  _strings.get('exchange'),
                  _strings.get('choose_exchange'),
                  _exchange,
                  ['Binance', 'Bybit', 'OKX'],
                  (value) => setState(() => _exchange = value)),
            ]),
            _textField(_strings.get('pair'), _strings.get('enter_pair'),
                _pairController),
            _hint(_strings.get('market_data_hint')),
            const SizedBox(height: 12),
            _select(
                _strings.get('strategy'),
                _strings.get('strategy_choose'),
                _strategy,
                ['Grid', 'DCA', 'Momentum'],
                (value) => setState(() => _strategy = value)),
            const SizedBox(height: 12),
            _panel(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_strings.get('grid_table'),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(_strings.get('grid_calculation'),
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 14),
                      _select(
                          _strings.get('grid_mode'),
                          _strings.get('choose_mode'),
                          _gridMode,
                          [_strings.get('sideways'), _strings.get('trend')],
                          (value) => setState(() => _gridMode = value)),
                      _fieldGrid(isWide, [
                        _textField(
                            _strings.get('deposit'), '', _depositController),
                        _textField(_strings.get('sell_percent'), '',
                            _profitController),
                        _textField(_strings.get('steps'), '', _stepsController),
                        _textField(_strings.get('depth'), '', _depthController),
                      ]),
                      _textField(
                          _strings.get('first_line'), '', _firstLineController),
                      TextButton(
                          onPressed: () {},
                          child: Text(_strings.get('fill_table'))),
                    ]),
              ),
            ),
            const SizedBox(height: 12),
            _panel(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: 4,
                          children: [
                            Text(_strings.get('grid_config'),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontSize: 13)),
                            Text(_strings.get('awaiting_calculation'),
                                style: Theme.of(context).textTheme.bodySmall),
                          ]),
                    ]),
              ),
            ),
            const SizedBox(height: 12),
            Text(_strings.get('limits'),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 13)),
            const SizedBox(height: 8),
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
            const SizedBox(height: 12),
            FilledButton.icon(
                onPressed: _createBot,
                icon: const Icon(Icons.save_outlined),
                label: Text(_strings.get('save_draft'))),
          ]),
        ),
      );

  Widget _createBotButton() => OutlinedButton.icon(
        onPressed: () => setState(() => _isFormOpen = true),
        icon: const Icon(Icons.add),
        label: Text(_strings.get('create_bot')),
        style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.15))),
      );

  Widget _botCard(BuildContext context, String botName) => _panel(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(botName, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(_strings.get('draft'),
                    style: Theme.of(context).textTheme.bodySmall),
              ]),
              const Icon(Icons.more_horiz),
            ],
          ),
        ),
      );

  void _createBot() {
    final botName = _pairController.text.trim().isEmpty
        ? '${_strings.get('new_bot')} ${_createdBots.length + 1}'
        : _pairController.text.trim();
    setState(() {
      _createdBots.add(botName);
      _isFormOpen = false;
    });
  }

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

  Widget _hint(String text) => Builder(builder: (context) => Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(text,
          style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 11))));

  Widget _panel({required Widget child}) => Builder(builder: (context) => Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.15))),
        child: child,
      ));
}
