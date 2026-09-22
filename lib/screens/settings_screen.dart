import 'package:flutter/material.dart';
import '../services/app_strings.dart';
import '../theme/trade_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen(
      {super.key, required this.locale, required this.onLocaleChanged});

  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _biometricsEnabled = false;
  bool _paperTradingEnabled = true;
  bool _botEnabled = true;
  String _strategy = 'Balanced';
  double _riskLevel = 35;
  bool _twoFactorEnabled = false;
  final List<String> _connectedExchanges = [];

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(widget.locale);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        _profileCard(context),
        const SizedBox(height: 24),
        _sectionLabel(strings.get('account')),
        _panel(children: [
          _item(Icons.person_outline_rounded, strings.get('profile'),
              'user@example.com'),
          _divider(),
          _item(
              Icons.shield_outlined,
              strings.get('security'),
              _twoFactorEnabled
                  ? strings.get('two_fa_enabled')
                  : strings.get('password_2fa'),
              onTap: _showTwoFactorDialog),
        ]),
        const SizedBox(height: 20),
        _sectionLabel(strings.get('trading')),
        _panel(children: [
          _switchItem(
              Icons.science_outlined,
              strings.get('paper_trading_label'),
              strings.get('no_real_funds'),
              _paperTradingEnabled,
              (value) => setState(() => _paperTradingEnabled = value)),
          _divider(),
          _item(
              Icons.key_rounded,
              strings.get('exchange_api'),
              _connectedExchanges.isEmpty
                  ? strings.get('not_configured')
                  : '${_connectedExchanges.length} ${strings.get('connected')}',
              onTap: _showExchangeDialog),
        ]),
        const SizedBox(height: 20),
        _sectionLabel(strings.get('bots_section')),
        _botPanel(context),
        const SizedBox(height: 20),
        _sectionLabel(strings.get('application')),
        _panel(children: [
          _switchItem(
              Icons.notifications_none_rounded,
              strings.get('app_notifications'),
              strings.get('push_signals'),
              _notificationsEnabled,
              (value) => setState(() => _notificationsEnabled = value)),
          _divider(),
          _switchItem(
              Icons.fingerprint_rounded,
              strings.get('biometrics'),
              strings.get('quick_login'),
              _biometricsEnabled,
              (value) => setState(() => _biometricsEnabled = value)),
          _divider(),
          _item(Icons.language_rounded, strings.get('language'), _languageName,
              onTap: _showLanguageDialog),
          _divider(),
          _item(Icons.info_outline_rounded, strings.get('about'), 'Nexora 0.9'),
        ]),
      ],
    );
  }

  String get _languageName => switch (widget.locale.languageCode) {
        'en' => 'English',
        'uk' => 'Українська',
        _ => 'Русский',
      };

  AppStrings get _strings => AppStrings(widget.locale);

  Widget _profileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: TradeColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: TradeColors.primaryPurple.withValues(alpha: 0.22)),
      ),
      child: Row(children: [
        CircleAvatar(
          radius: 27,
          backgroundColor: TradeColors.primaryPurple,
          child: Text('TB',
              style: TextStyle(
                  color: TradeColors.background, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 14),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Trade Bot', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 3),
          Text(_strings.get('demo_account'),
              style: Theme.of(context).textTheme.bodyMedium),
        ])),
        Icon(Icons.chevron_right_rounded, color: TradeColors.secondaryText),
      ]),
    );
  }

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(label,
            style: TextStyle(
                color: TradeColors.tertiaryText,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2)),
      );

  Widget _panel({required List<Widget> children}) => Container(
        decoration: BoxDecoration(
            color: TradeColors.cardBackground,
            borderRadius: BorderRadius.circular(18)),
        child: Column(children: children),
      );

  Widget _divider() =>
      Divider(height: 1, indent: 62, endIndent: 16, color: TradeColors.surface);

  Widget _item(IconData icon, String title, String subtitle,
          {VoidCallback? onTap}) =>
      Material(
        color: Colors.transparent,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          leading: Icon(icon, color: TradeColors.primaryPurple),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: Icon(Icons.chevron_right_rounded,
              color: TradeColors.tertiaryText),
          onTap: onTap ?? () {},
        ),
      );

  Widget _switchItem(IconData icon, String title, String subtitle, bool value,
          ValueChanged<bool> onChanged) =>
      Material(
        color: Colors.transparent,
        child: SwitchListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          secondary: Icon(icon, color: TradeColors.primaryPurple),
          title: Text(title),
          subtitle: Text(subtitle),
          value: value,
          
          onChanged: onChanged,
        ),
      );

  Widget _botPanel(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        decoration: BoxDecoration(
            color: TradeColors.cardBackground,
            borderRadius: BorderRadius.circular(18)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Material(
            color: Colors.transparent,
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary:
                  Icon(Icons.smart_toy_outlined, color: TradeColors.accentLime),
              title: const Text('Momentum Bot'),
              subtitle: Text(_botEnabled
                  ? 'Работает по стратегии $_strategy'
                  : 'Приостановлен'),
              value: _botEnabled,
              activeThumbColor: TradeColors.accentLime,
              onChanged: (value) => setState(() => _botEnabled = value),
            ),
          ),
          const SizedBox(height: 8),
          Text(_strings.get('strategy'),
              style: Theme.of(context).textTheme.bodySmall),
          DropdownButtonFormField<String>(
            initialValue: _strategy,
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.insights_outlined)),
            items: const [
              DropdownMenuItem(value: 'Balanced', child: Text('Balanced')),
              DropdownMenuItem(value: 'Momentum', child: Text('Momentum')),
              DropdownMenuItem(value: 'Grid', child: Text('Grid')),
            ],
            onChanged: (value) =>
                setState(() => _strategy = value ?? _strategy),
          ),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(_strings.get('risk_per_trade'),
                style: Theme.of(context).textTheme.bodySmall),
            Text('${_riskLevel.round()}%',
                style: const TextStyle(
                    color: TradeColors.accentLime,
                    fontWeight: FontWeight.w700)),
          ]),
          Slider(
            value: _riskLevel,
            min: 5,
            max: 100,
            divisions: 19,
            onChanged: (value) => setState(() => _riskLevel = value),
          ),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.tune_rounded),
            label: Text(_strings.get('advanced')),
          ),
        ]),
      );

  Future<void> _showExchangeDialog() async {
    final exchangeController = TextEditingController(text: 'Binance');
    final keyController = TextEditingController();
    final secretController = TextEditingController();
    var testnet = true;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(_strings.get('exchange_api_dialog')),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                  controller: exchangeController,
                  decoration: InputDecoration(
                      labelText: _strings.get('exchange'),
                      prefixIcon: Icon(Icons.currency_exchange_rounded))),
              TextField(
                  controller: keyController,
                  decoration: InputDecoration(
                      labelText: _strings.get('api_key'),
                      prefixIcon: Icon(Icons.key_rounded))),
              TextField(
                  controller: secretController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: _strings.get('api_secret'),
                      prefixIcon: Icon(Icons.lock_outline_rounded))),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_strings.get('testnet')),
                value: testnet,
                onChanged: (value) => setDialogState(() => testnet = value),
              ),
              Text(
                  _strings.get('secret_key_notice'),
                  style: Theme.of(context).textTheme.bodySmall),
            ]),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(_strings.get('cancel'))),
            FilledButton(
              onPressed: keyController.text.trim().isEmpty ||
                      secretController.text.trim().isEmpty
                  ? null
                  : () {
                      setState(() => _connectedExchanges
                          .add(exchangeController.text.trim()));
                      Navigator.pop(dialogContext);
                    },
              child: Text(_strings.get('save')),
            ),
          ],
        ),
      ),
    );
    exchangeController.dispose();
    keyController.dispose();
    secretController.dispose();
  }

  Future<void> _showTwoFactorDialog() async {
    var enabled = _twoFactorEnabled;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(_strings.get('security_2fa')),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(_strings.get('two_fa_hint')),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_strings.get('enable_2fa')),
              value: enabled,
              onChanged: (value) => setDialogState(() => enabled = value),
            ),
          ]),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(_strings.get('cancel'))),
            FilledButton(
                onPressed: () {
                  setState(() => _twoFactorEnabled = enabled);
                  Navigator.pop(dialogContext);
                },
                child: Text(_strings.get('save'))),
          ],
        ),
      ),
    );
  }

  Future<void> _showLanguageDialog() async {
    final language = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(_strings.get('language_dialog')),
        children: [
          for (final option in ['Русский', 'English', 'Українська'])
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, option),
              child: Row(children: [
                Icon(
                  _languageName == option
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: _languageName == option
                      ? TradeColors.primaryPurple
                      : TradeColors.secondaryText,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(option),
              ]),
            ),
        ],
      ),
    );
    if (language != null) {
      final locale = switch (language) {
        'English' => const Locale('en'),
        'Українська' => const Locale('uk'),
        _ => const Locale('ru'),
      };
      widget.onLocaleChanged(locale);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${_strings.get('language_changed')}: $language')));
    }
  }
}
