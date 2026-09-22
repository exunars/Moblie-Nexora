import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../screens/home_screen.dart';
import '../screens/history_overview_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/bots_screen.dart';
import '../screens/backtests_screen.dart';
import '../screens/account_section_screen.dart';
import '../services/app_strings.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.locale, required this.onLocaleChanged});
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
      strings.get('overview'), strings.get('bots'), strings.get('history'),
      strings.get('backtests'), strings.get('exchanges'), strings.get('subscription'),
      strings.get('settings'), strings.get('help'),
    ];
    final tp = context.watch<ThemeProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex], style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.2)),
        leading: Builder(builder: (context) => IconButton(tooltip: strings.get('open_menu'), icon: const Icon(Icons.menu_rounded), onPressed: () => Scaffold.of(context).openDrawer())),
        actions: [
          _ThemeToggle(isDark: isDark, onTap: () => tp.toggleDarkLight()),
          const SizedBox(width: 4),
          Container(margin: const EdgeInsets.only(right: 8), decoration: BoxDecoration(color: Theme.of(context).cardTheme.color, borderRadius: BorderRadius.circular(12)), child: IconButton(tooltip: strings.get('notifications'), icon: const Icon(Icons.notifications_none_rounded), onPressed: () {})),
        ],
        elevation: 0, scrolledUnderElevation: 0,
      ),
      drawer: _buildDrawer(context, strings),
      body: tp.animationsEnabled
          ? AnimatedSwitcher(duration: const Duration(milliseconds: 220), switchInCurve: Curves.easeOutCubic, switchOutCurve: Curves.easeInCubic, child: KeyedSubtree(key: ValueKey(_currentIndex), child: _pageAt(_currentIndex)))
          : _pageAt(_currentIndex),
    );
  }

  Widget _pageAt(int i) {
    final pages = _buildPages();
    return IndexedStack(index: i, children: pages);
  }

  Widget _buildDrawer(BuildContext context, AppStrings strings) {
    final surface = Theme.of(context).scaffoldBackgroundColor;
    return Drawer(backgroundColor: surface, width: MediaQuery.sizeOf(context).width * 0.82, child: SafeArea(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.fromLTRB(24, 24, 20, 12), child: Row(children: [
        Container(width: 48, height: 48, decoration: BoxDecoration(color: context.watch<ThemeProvider>().accent.color, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: context.watch<ThemeProvider>().accent.color.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 8))]), child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 24)),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Nexora', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)), Text('v1.0.7', style: Theme.of(context).textTheme.bodySmall)]),
      ])),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), child: Text(strings.get('workspace'), style: Theme.of(context).textTheme.bodySmall?.copyWith(letterSpacing: 1, fontWeight: FontWeight.w600))),
      _menuItem(0, Icons.dashboard_outlined, strings.get('overview'), strings.get('portfolio_market')),
      _menuItem(1, Icons.smart_toy_outlined, strings.get('bots'), strings.get('strategies_launch')),
      _menuItem(2, Icons.history_rounded, strings.get('history'), strings.get('orders_executions')),
      _menuItem(3, Icons.science_outlined, strings.get('backtests'), strings.get('strategy_testing')),
      const SizedBox(height: 12), const Divider(indent: 20, endIndent: 20),
      _menuItem(4, Icons.account_balance_outlined, strings.get('exchanges'), strings.get('api_connections')),
      _menuItem(5, Icons.credit_card_outlined, strings.get('subscription'), strings.get('plan_access')),
      _menuItem(6, Icons.tune_rounded, strings.get('settings'), strings.get('profile_security')),
      _menuItem(7, Icons.help_outline_rounded, strings.get('help'), strings.get('support_answers')),
      const SizedBox(height: 10),
      _subscriptionFooter(context, strings),
    ]))));
  }

  Widget _subscriptionFooter(BuildContext context, AppStrings strings) {
    return Padding(padding: const EdgeInsets.fromLTRB(12, 0, 12, 16), child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Theme.of(context).cardTheme.color, borderRadius: BorderRadius.circular(12), border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.15))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(strings.get('subscription_inactive'), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 13)),
      const SizedBox(height: 3), Text(strings.get('access_limited'), style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 9), SizedBox(width: double.infinity, child: FilledButton(onPressed: () => _selectPage(5), child: Text(strings.get('activate')))),
      Material(color: Colors.transparent, child: ListTile(contentPadding: EdgeInsets.zero, dense: true, leading: const Icon(Icons.logout_rounded, size: 18), title: Text(strings.get('logout')), onTap: () {})),
    ])));
  }

  List<Widget> _buildPages() => [
    HomeScreen(locale: widget.locale, onNavigate: (index) => setState(() => _currentIndex = index)),
    BotsScreen(locale: widget.locale),
    HistoryOverviewScreen(locale: widget.locale),
    BacktestsScreen(locale: widget.locale),
    AccountSectionScreen(section: AccountSection.exchanges, locale: widget.locale, onOpenSettings: () => setState(() => _currentIndex = 6)),
    AccountSectionScreen(section: AccountSection.subscription, locale: widget.locale),
    SettingsScreen(locale: widget.locale, onLocaleChanged: widget.onLocaleChanged),
    AccountSectionScreen(section: AccountSection.help, locale: widget.locale),
  ];

  Widget _menuItem(int index, IconData icon, String title, String subtitle) {
    final isSelected = _currentIndex == index;
    final accent = context.watch<ThemeProvider>().accent.color;
    return Builder(builder: (context) => Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3), child: Material(color: Colors.transparent, child: ListTile(
      selected: isSelected, selectedTileColor: accent.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      leading: Icon(icon, color: isSelected ? accent : Theme.of(context).textTheme.bodySmall?.color),
      title: Text(title), subtitle: Text(subtitle), onTap: () => _selectPage(index),
    ))));
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle({required this.isDark, required this.onTap});
  final bool isDark;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Material(color: Theme.of(context).cardTheme.color, borderRadius: BorderRadius.circular(12), child: InkWell(borderRadius: BorderRadius.circular(12), onTap: onTap, child: Container(width: 44, height: 44, alignment: Alignment.center, child: AnimatedSwitcher(duration: const Duration(milliseconds: 350), transitionBuilder: (child, anim) => RotationTransition(turns: Tween<double>(begin: 0.7, end: 1).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutBack)), child: ScaleTransition(scale: anim, child: child)), child: Icon(isDark ? Icons.dark_mode_rounded : Icons.wb_sunny_rounded, key: ValueKey(isDark), size: 22, color: isDark ? const Color(0xFF9A8CFF) : const Color(0xFFE17055))))));
  }
}
