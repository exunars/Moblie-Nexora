import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/history_overview_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/bots_screen.dart';
import '../screens/backtests_screen.dart';
import '../screens/account_section_screen.dart';
import '../services/app_strings.dart';
import '../theme/trade_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen(
      {super.key, required this.locale, required this.onLocaleChanged});

  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _selectPage(int index) {
    Navigator.of(context).pop();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(widget.locale);
    final titles = [
      strings.get('overview'),
      strings.get('bots'),
      strings.get('history'),
      strings.get('backtests'),
      strings.get('exchanges'),
      strings.get('subscription'),
      strings.get('settings'),
      strings.get('help'),
    ];
    return Scaffold(
      backgroundColor: TradeColors.background,
      appBar: AppBar(
        title: Text(
          titles[_currentIndex],
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            tooltip: strings.get('open_menu'),
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: TradeColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              tooltip: strings.get('notifications'),
              icon: const Icon(Icons.notifications_none_rounded),
              onPressed: () {},
            ),
          ),
        ],
        backgroundColor: TradeColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      drawer: _buildDrawer(context, strings),
      body: IndexedStack(
        index: _currentIndex,
        children: _buildPages(),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, AppStrings strings) {
    return Drawer(
      backgroundColor: TradeColors.background,
      width: MediaQuery.sizeOf(context).width * 0.82,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 20, 12),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: TradeColors.accentCyan,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: TradeColors.accentCyan.withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.bolt_rounded,
                          color: TradeColors.background, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NEXORA',
                            style: Theme.of(context).textTheme.titleLarge),
                        Text('TRADING DESK',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(indent: 20, endIndent: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 20, 8),
                child: Text(strings.get('workspace'),
                    style: Theme.of(context).textTheme.bodySmall),
              ),
              _menuItem(0, Icons.dashboard_rounded, strings.get('overview'),
                  strings.get('portfolio_market')),
              _menuItem(1, Icons.smart_toy_outlined, strings.get('bots'),
                  strings.get('strategies_launch')),
              _menuItem(2, Icons.receipt_long_rounded, strings.get('history'),
                  strings.get('orders_executions')),
              _menuItem(3, Icons.query_stats_rounded, strings.get('backtests'),
                  strings.get('strategy_testing')),
              const SizedBox(height: 12),
              const Divider(indent: 20, endIndent: 20),
              _menuItem(4, Icons.account_balance_outlined,
                  strings.get('exchanges'), strings.get('api_connections')),
              _menuItem(5, Icons.credit_card_outlined,
                  strings.get('subscription'), strings.get('plan_access')),
              _menuItem(6, Icons.tune_rounded, strings.get('settings'),
                  strings.get('profile_security')),
              _menuItem(7, Icons.help_outline_rounded, strings.get('help'),
                  strings.get('support_answers')),
              const SizedBox(height: 10),
              _subscriptionFooter(context, strings),
            ],
          ),
        ),
      ),
    );
  }

  Widget _subscriptionFooter(BuildContext context, AppStrings strings) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: TradeColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: TradeColors.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(strings.get('subscription_inactive'),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 13)),
          const SizedBox(height: 3),
          Text(strings.get('access_limited'),
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 9),
          SizedBox(
              width: double.infinity,
              child: FilledButton(
                  onPressed: () => _selectPage(5),
                  child: Text(strings.get('activate')))),
          Material(
              color: Colors.transparent,
              child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: const Icon(Icons.logout_rounded, size: 18),
                  title: Text(strings.get('logout')),
                  onTap: () {})),
        ]),
      ),
    );
  }

  List<Widget> _buildPages() => [
    HomeScreen(
        locale: widget.locale,
        onOpenSettings: () => setState(() => _currentIndex = 6)),
    BotsScreen(locale: widget.locale),
    HistoryOverviewScreen(locale: widget.locale),
    BacktestsScreen(locale: widget.locale),
    AccountSectionScreen(
        section: AccountSection.exchanges,
        locale: widget.locale,
        onOpenSettings: () => setState(() => _currentIndex = 6)),
    AccountSectionScreen(
        section: AccountSection.subscription, locale: widget.locale),
    SettingsScreen(
        locale: widget.locale, onLocaleChanged: widget.onLocaleChanged),
    AccountSectionScreen(
        section: AccountSection.help, locale: widget.locale),
  ];

  Widget _menuItem(int index, IconData icon, String title, String subtitle) {
    final isSelected = _currentIndex == index;
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            selected: isSelected,
            selectedTileColor: TradeColors.accentLime.withValues(alpha: 0.12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            leading: Icon(icon,
                color: isSelected
                    ? TradeColors.accentLime
                    : TradeColors.secondaryText),
            title: Text(title),
            subtitle: Text(subtitle),
            onTap: () => _selectPage(index),
          ),
        ),
      ),
    );
  }
}
