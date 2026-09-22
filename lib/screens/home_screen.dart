import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/trade_provider.dart';
import '../services/app_strings.dart';
import '../theme/trade_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {super.key, required this.onNavigate, required this.locale});

  final ValueChanged<int> onNavigate;
  final Locale locale;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _marketScrollController = ScrollController();

  ValueChanged<int> get onNavigate => widget.onNavigate;
  Locale get locale => widget.locale;

  @override
  void dispose() {
    _marketScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TradeProvider>();
    final strings = AppStrings(locale);
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              EdgeInsets.fromLTRB(isWide ? 28 : 16, 18, isWide ? 28 : 16, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: _buildNexoraOverview(context, provider, isWide, strings),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNexoraOverview(BuildContext context, TradeProvider provider,
      bool isWide, AppStrings strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWelcome(context, provider, strings),
        const SizedBox(height: 18),
        _buildStats(context, provider, strings),
        const SizedBox(height: 18),
        if (isWide)
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(flex: 3, child: _buildGettingStarted(context, strings)),
            const SizedBox(width: 14),
            Expanded(child: _buildExchangeBalance(context)),
            const SizedBox(width: 14),
            Expanded(child: _buildSessions(context)),
          ])
        else ...[
          _buildGettingStarted(context, strings),
          const SizedBox(height: 14),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _buildExchangeBalance(context)),
            const SizedBox(width: 12),
            Expanded(child: _buildSessions(context)),
          ]),
        ],
        const SizedBox(height: 14),
        _buildMarketStrip(context, provider),
      ],
    );
  }

  Widget _buildWelcome(
      BuildContext context, TradeProvider provider, AppStrings strings) {
    return Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(strings.get('overview'),
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 5),
            Text(strings.get('overview_subtitle'),
                style: Theme.of(context).textTheme.bodyMedium),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
                color: provider.isConnected
                    ? TradeColors.successGreen.withValues(alpha: 0.12)
                    : Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: provider.isConnected
                        ? TradeColors.successGreen.withValues(alpha: 0.35)
                        : Theme.of(context).dividerColor.withValues(alpha: 0.15))),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.circle,
                  size: 8,
                  color: provider.isConnected
                      ? TradeColors.successGreen
                      : Theme.of(context).textTheme.bodySmall?.color),
              const SizedBox(width: 7),
              Text(
                  provider.isConnected
                      ? strings.get('connected_status')
                      : strings.get('disconnected_status'),
                  style: Theme.of(context).textTheme.bodySmall),
            ]),
          ),
        ]);
  }

  Widget _buildStats(
      BuildContext context, TradeProvider provider, AppStrings strings) {
    final portfolio = provider.portfolio;
    final stats = [
      _StatData(
          strings.get('realized_pnl'),
          '\$${portfolio?.totalProfitLoss.toStringAsFixed(2) ?? '0.00'}',
          strings.get('closed_trades'),
          TradeColors.successGreen),
      _StatData(strings.get('commissions'), '\$0.00',
          strings.get('gross_profit_compare'), Theme.of(context).textTheme.titleLarge!.color!),
      _StatData(
          strings.get('open_positions'),
          '${portfolio?.holdings.length ?? 0}',
          strings.get('nothing_held'),
          Theme.of(context).textTheme.titleLarge!.color!),
      _StatData(strings.get('bots_running'), '0 / 0',
          strings.get('executions_count'), Theme.of(context).textTheme.titleLarge!.color!),
    ];
    return LayoutBuilder(builder: (context, constraints) {
      final columns = constraints.maxWidth >= 760 ? 4 : 2;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: stats.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: columns == 2 ? 108 : 104),
        itemBuilder: (_, index) => _statCard(context, stats[index]),
      );
    });
  }

  Widget _statCard(BuildContext context, _StatData stat) => _panel(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(stat.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 2),
                Text(stat.value,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: stat.color,
                        fontWeight: FontWeight.w700,
                        fontSize: 22)),
                const SizedBox(height: 1),
                Text(stat.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall),
              ]),
        ),
      );

  Widget _buildGettingStarted(BuildContext context, AppStrings strings) =>
      _panel(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(strings.get('getting_started'),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(strings.get('getting_started_subtitle'),
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            _step(context, '1', strings.get('create_paper_bot'),
                strings.get('paper_bot_description'), strings.get('create'),
                () => onNavigate(1)),
            const SizedBox(height: 7),
            _step(context, '2', strings.get('protect_account'),
                strings.get('two_fa_description'), strings.get('enable'),
                () => onNavigate(6)),
            const SizedBox(height: 7),
            _step(
                context,
                '3',
                strings.get('connect_exchange'),
                strings.get('connect_exchange_description'),
                strings.get('connect'),
                () => onNavigate(6)),
          ]),
        ),
      );

  Widget _step(BuildContext context, String number, String title,
          String description, String action, VoidCallback onTap) =>
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: TradeColors.surface,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: TradeColors.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: TradeColors.tertiaryText)),
                child:
                    Text(number, style: Theme.of(context).textTheme.bodySmall)),
            const SizedBox(width: 10),
            Expanded(
                child: Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 13))),
            const SizedBox(width: 8),
            OutlinedButton(
                onPressed: onTap, child: Text(action)),
          ]),
          const SizedBox(height: 3),
          Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Text(description,
                  style: Theme.of(context).textTheme.bodySmall)),
        ]),
      );

  Widget _buildExchangeBalance(BuildContext context) => _panel(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(AppStrings(locale).get('exchange_balance'),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 7),
            Text(AppStrings(locale).get('not_connected_exchange'),
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 22),
            TextButton.icon(
                onPressed: () => onNavigate(6),
                icon: const Icon(Icons.link_rounded, size: 16),
                label: Text(AppStrings(locale).get('connect'))),
          ]),
        ),
      );

  Widget _buildSessions(BuildContext context) => _panel(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(AppStrings(locale).get('active_sessions'),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 7),
            Text('Устройства с доступом к этому аккаунту.',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 13),
            Text('1', style: Theme.of(context).textTheme.displayMedium),
            Text(AppStrings(locale).get('only_this_device'),
                style: Theme.of(context).textTheme.bodySmall),
          ]),
        ),
      );

  Widget _buildMarketStrip(BuildContext context, TradeProvider provider) =>
      _panel(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(AppStrings(locale).get('market'),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            SizedBox(
              height: 62,
              child: Scrollbar(
                controller: _marketScrollController,
                thumbVisibility: true,
                notificationPredicate: (notification) =>
                    notification.metrics.axis == Axis.horizontal,
                child: ListView.separated(
                  controller: _marketScrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.assets.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, index) {
                    final asset = provider.assets[index];
                    final color = asset.changePercent >= 0
                        ? TradeColors.successGreen
                        : TradeColors.errorRed;
                    return Container(
                      width: 128,
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.15))),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(asset.symbol,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(fontSize: 13)),
                                  Text(
                                      '${asset.changePercent >= 0 ? '+' : ''}${asset.changePercent.toStringAsFixed(1)}%',
                                      style: TextStyle(
                                          color: color,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11)),
                                ]),
                            const Spacer(),
                            Text(asset.price.toStringAsFixed(2),
                                style: Theme.of(context).textTheme.bodySmall),
                          ]),
                    );
                  },
                ),
              ),
            ),
          ]),
        ),
      );

  Widget _panel({required Widget child}) => Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.15))),
        child: child,
      );
}

class _StatData {
  const _StatData(this.title, this.value, this.caption, this.color);

  final String title;
  final String value;
  final String caption;
  final Color color;
}
